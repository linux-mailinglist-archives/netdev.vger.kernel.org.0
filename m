Return-Path: <netdev+bounces-7602-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0095A720CA9
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 02:40:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1608D1C21279
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 00:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D7E6195;
	Sat,  3 Jun 2023 00:39:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2FB187E
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 00:39:59 +0000 (UTC)
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023A3E41
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 17:39:57 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
	by mx0c-0054df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 352KX7ER018353;
	Fri, 2 Jun 2023 19:41:44 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2168.outbound.protection.outlook.com [104.47.75.168])
	by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ques3pcpg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Jun 2023 19:41:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hLcEDzTTWrAsnV14K9UBregXK3z8VOmGta60Vnt/aOGMRArELoXiHF5Uy61euv/cJwbj3eUiEtEQ7v8DID0SRvcOBYF+lDdSvG6IeV6w+gE/tG+Tatbj+rC8R0txuEDsMBK1ceU7ode3+UUqbY76NRimhL+T1QhmaYlKB8NCsBAhJeIlVJtEOxGAD46G0OHuwMNINOQ0vC+UHodcx7+pFAzGKHUz4Te6XJUF/WakG3eRzaU1/E4mf8qZCtDJRK5jGgFgqQWSeZmZHJv/vvMRuw22WxtB5Pv70kat5tnYYHq6wOWXXlWFd7H67rh1tHKAnZtwe/SZw0mvnmJTxMpE2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6H86h10nUFTj3KLMScWR5P1HRQWQn/0rq3H/7mlbcLI=;
 b=cV0kF9J0g5v8P6V9rVqiAfKG1GhgYpFaAS7UzzG8gRo71Y+Dv/9DTgvO8mke1ZMHPONSTQtB8dl4Hc6gPPn4TKPIQ5n9GpcUnJASrRXLmKvGUPyVfIcZYAETEWBOWfp55QU5Xf87Tjt35vQy9dkdnI3eHJVxA0f2cxlkb7vQzHoeTQvH5zEBZ4nBXUHHZB16dLbjNYCfuLYdf8OECNPmuoz5XnM3wqhiAgS5/oqzUAMvvOM7y/rgVcHuYG1dV8JMv9UoZzv2+xFb+BH6kOi6slWFo5EHv49hK6rgBeoNCSH2bawRW2fpOgVgyTHQ/nSoxakvUkC3S1moPELIThCr/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6H86h10nUFTj3KLMScWR5P1HRQWQn/0rq3H/7mlbcLI=;
 b=4m8X5XWX9OvFy3qbdD4HfZ3qGOfKLhBjMQB6x7WRjEvbcOm3+xNf2oZ4LiiRNY6o7JeXYZZJ7O+D3qTWadibaieDppAueb/ijI0yxwD4y83pwi3a7EWaUb012M6Lwb3eHar9PdMwCa3HqJ4cHjPObI8smr4ulZkiUh4jxVkCV3k=
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b9::6)
 by YT1PR01MB8763.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:ca::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.27; Fri, 2 Jun
 2023 23:41:42 +0000
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::c059:dcd5:ca20:4a0]) by YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::c059:dcd5:ca20:4a0%6]) with mapi id 15.20.6455.028; Fri, 2 Jun 2023
 23:41:42 +0000
From: Robert Hancock <robert.hancock@calian.com>
To: Woojung Huh <woojung.huh@microchip.com>, UNGLinuxDriver@microchip.com,
        Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 0/2] Move KSZ9477 errata handling to PHY driver
Date: Fri,  2 Jun 2023 17:40:17 -0600
Message-Id: <20230602234019.436513-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.40.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0362.namprd04.prod.outlook.com
 (2603:10b6:303:81::7) To YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:b9::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB8838:EE_|YT1PR01MB8763:EE_
X-MS-Office365-Filtering-Correlation-Id: 5879a24a-92f4-4a6f-070e-08db63c2eaf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	IwYpYjlJB4jyviR1JGhtwyDPLie3QPoBQIvaudtc5fI9/c0PRxVCYqfWShgKXoRU4nNx+J0KFyEzwA5ps0BPwbMgZUVeZgCMFhhcLdEliydYPxdZpC0CHxgZNTDZ2K7rTgGHLFNCTmLDm3Mk5qYMvoaxRhnDcrKYXUKOqE1Y7v9Y/ojUWvim4G1z/rJq3nX1EzWgXqH0laExDAkMLqNW0bgJ4ZWE3uT4s7RG3RPWaKoAZ7nur5AF6M/Mu6JOHmVlpObRYysTV+AnQnpLrn/J4jNebqpz8A04PUuelr/M6yLKM/OZvch5G8ssT1mMqfQshK08XbL/572iNCCtUaFmciW87Io0ryLDACLlooer56hjayD3NF/NyimjaxQ2hIxjI7i6qM4lWMlcRn1Ecj/wtFkDD65GzneYlGUEUwTriEOxR/nKt1BpL0CAElETS6uukeGhzFlkIEzMvzgCqfo2Gs5E/gWxi4xjlgAHCm95q1118CDubnXrpLwkxLh0zy3GboH94k1mkymfrgBt09O1dQfubRwH0psaCUbi1EvTqy5mIuW5pHfXz7kZvuzaPNdyLGMFuKI93mM1yuTX8/n/+iAXpB/IdjEGVRMkl8YtECPj+u2YCR5BQEht1wBWKU8JIYA73qOCMnIIGdQNpI/evQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199021)(8676002)(8936002)(6666004)(110136005)(478600001)(921005)(52116002)(316002)(41300700001)(5660300002)(6486002)(186003)(26005)(1076003)(7416002)(107886003)(44832011)(66946007)(66476007)(66556008)(4326008)(6506007)(6512007)(83380400001)(2906002)(4744005)(86362001)(36756003)(2616005)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?by3TC/KGeMrHR25+7mKL+MNSiKElgdztrZwOlPBr2SQKUv7GBuF+peV3QxUS?=
 =?us-ascii?Q?YGnGSkqol9FicP0Pz1uSv8X17xOg2+4itMySdFcuQOR28egM+OTuxvhaOFNM?=
 =?us-ascii?Q?71kbidDkd90Ta+hqXwmVMD8boDi8oPsQz9DlmvI/IhgAVFITiDaha0HYBDYN?=
 =?us-ascii?Q?D9kBA8aox/SB4ch1Gf/LS5iSXfQ3drY3x77ra7eiGcpcnuyT92lqaXJN5y4g?=
 =?us-ascii?Q?ahrXfeC9PrtxYmjrN+2YXKs05GV/mD+ImXfW6RmkaJ4HrfXd/wlrz+id1vfH?=
 =?us-ascii?Q?oJ+JSvHatibCmv6m1Y7cdGxhYOU0rmk2kM/wF8C5T2nqjlq+dgBOEoTHqmad?=
 =?us-ascii?Q?7k3NGDDa8VbPukDrK/ijwg23JHMLen63o6C81A4vu92BDQEc0R1+q34R9h8C?=
 =?us-ascii?Q?KisD9pGBpOvLVyLVGpDSO6tg+bKGR+o7NvAFufU2RLgsiIYYkRGWUDZiSvXf?=
 =?us-ascii?Q?OL+Kh/AzSXqXyLrHwXwZuKIDDn1PAX8A+M+OK9J7uxCw1BMU4ySgH6TAd0dO?=
 =?us-ascii?Q?fZ+pVDlI5+ExRain1oacixYj7His7a3J4AJ+6TYWfjTHV3eAA9qim1MY0WTa?=
 =?us-ascii?Q?PV6eU9xjANgd93E0w2caBOStjJwGMX4YC8V9hAC2zpnhck1i0PtpGueEwlT8?=
 =?us-ascii?Q?Fw8ma1pdRPr/Jjdm+rSHN9rkd3cpRqyZVCmtyu5zMif2bjauUc3IJVGS1X7D?=
 =?us-ascii?Q?zSbCVXuPOWa1AnvZgwE1BO5zsGRFuUBlkFEg9eJp2V9b0M+GT4bDJgeVKMg+?=
 =?us-ascii?Q?4ZadXJDd9qO61tnd80rmmlHazpVqrU2vrGuLOo/gdQxfxMgKa2boiRA/D2dl?=
 =?us-ascii?Q?BZVAk+Gcr8JprgaZ1JywdmQJio7gODj9Voj9TagSFXmpupyMQHDBCFxT799k?=
 =?us-ascii?Q?LCXHX2fhfxXJH8iqtVARZ4PRmzOCiLHNG/V7txiM+A1AOLareQgRMtLRK8so?=
 =?us-ascii?Q?4zijxgGIFYdtlS9bVdMcgFKv2MK2y22y/0GCEFyJ/d2YWDK1iKb7yyDH1fhp?=
 =?us-ascii?Q?J2CrDsWyyPDHb704ui7K6ulLm0U3BAhLoylwrAn6TcKFaytOeIoNgoQ6Ed7n?=
 =?us-ascii?Q?Vu2oqNNf5marYZj84DzniUJOfLOtkG9Z6RqMVOezuOB1bVKrinXrLjbbVabJ?=
 =?us-ascii?Q?HqzO+tKHx9l7E0JE7KFdv9+Tl6CCHSg+pUBgWsxeY1c10ZhHW3BJvJ59tamz?=
 =?us-ascii?Q?dI1s58J8J49cM1l2YRlcsdea4lsQOplIHo3N4SRTvKsehbBCcV56P/AlGXEm?=
 =?us-ascii?Q?3MaT+2w/yHOIzHM94Q4pKRVN2GPLP1ZiiSNO2Nn6RK7lpPSgwVOXWCRsCexq?=
 =?us-ascii?Q?M3SL96HunBs54QHYZBLfmBe2Z1rj7kYtA+wY39nc/ZBPZiiWBZduM2hce25k?=
 =?us-ascii?Q?6klnlDVbGc1E3SRgrcoRBQdA8L6Hn4jhN8n7W/3ltLEjjGl5klAjROIR+LgO?=
 =?us-ascii?Q?+cQ1D2W2w2dsleQaXKzJG3RCH0cd4iaEBYfqBptgbz18m0aft46oMd9F0orV?=
 =?us-ascii?Q?GZJJJ5wYH3LfuHDxJ5tNegGjcbmti0lCFaL7PVu5uJ2PibKs5kAwW9GsBca5?=
 =?us-ascii?Q?cKU06DQYS/o/TxK6LwuIDyeH2q7YGQMSnFyIUQq/UWMnhJcJ/6aEL4L+NTal?=
 =?us-ascii?Q?sw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?dFDNqqXzEDB5c4l55HN8t4G42s9VuAQPJI7gLFSq5XinxM5nTxlK/GbHZS0u?=
 =?us-ascii?Q?YDeOqLpfAMf6zKsLxs6EVAmTBInR5zWBl+IQBop65M7KgfJ7oMmXW2idSwOg?=
 =?us-ascii?Q?2ouMM98y3wkMVF1JmBmFGUPNPf9Pir+7EPDVFJ8dr4YewqQDjMuurL1Ob3/S?=
 =?us-ascii?Q?XKMvTrYrmeF4GCgb3lYyhMN+aMisiil+auc2Qe7kf7Dk8wTfaybcoqG/Misi?=
 =?us-ascii?Q?mHhrZvKRKbEnOXnUL8iXk2wA/sioO7n4fki6sOH4vdYEJmEJDU67rd/Um/Yh?=
 =?us-ascii?Q?DrHXKD3aULoiYyTBqeiZ/fGA2ogb8T3Sk25eqlBwQTfNlW3575ImupYTxGaj?=
 =?us-ascii?Q?PAFjSr8uKBOuDhQCZw7PHB5sZ89AThu1PMbMAQ7kK4ohkf/tYyLDQ3OcTB7G?=
 =?us-ascii?Q?XDlGJujixTPKDi0SNkzGPnEDfwmMwXsz2ywpJYyIXuttW7VWW3GsSOwY9Bxb?=
 =?us-ascii?Q?aMpk/qj9e0mR0MnWp78SIr7KWst4EI7yCfKBNH2NzM3KW1c2g5oKu7fDhA+O?=
 =?us-ascii?Q?rS3elnh5kXGZxo1YgiGXnGl2EinCM8eD5KakEPfUN7yxKKWmIqxDDF7zy0Hh?=
 =?us-ascii?Q?idotPBsLIgRaO2vSKxBmSTPuWAZatl6JDE+q73V3yD6Zflh9IarNRCWEcgLG?=
 =?us-ascii?Q?jdPiUr9gGvbKMsMp5mGAeCX+pK/H6W3o1z7V8h/PkfEvbozmv1O3GZZJNgm2?=
 =?us-ascii?Q?yrsGBteVx4bKDER3mKCw3b/bwuj6Y4bTcfu5CjJLBqVYnTtPbiLw6Yt0OJVJ?=
 =?us-ascii?Q?uXNkFKrxzrvp3lAjBhmKEDgqJTviqWA7npGqmDAVrRz7lJ2cj4Owsridsp+5?=
 =?us-ascii?Q?obiEu7Y1Ynw1JCyRD1KFSzTVqy97gPDO/EyWBNiXSYIT4zLW2kV54m+9Hl2f?=
 =?us-ascii?Q?hE0DNdNEA6f70LLoxAtaI9KlMTZ3EvrLAgZ8DP/u6nOkV6yGHkHbQLs4qjI8?=
 =?us-ascii?Q?0BHHepL7h/+ipCwcsXHmgIjDOO84mN0C1mfO4p3VYOW2uA0Tt7OeDQBGofuY?=
 =?us-ascii?Q?X4mvB5+pp5eh5lu5IpqYyg1WUw=3D=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5879a24a-92f4-4a6f-070e-08db63c2eaf7
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 23:41:42.2167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jBlxVXmc9Rr8qD1ekXCtHJEn66ULlw+n7LTwZz6VVXEHadHiaFylP7dzxjBLQESejpYYyPVQUhMaH+yIk4/rc/jvMpN/EtjYIFWWz/OB9wE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB8763
X-Proofpoint-GUID: GbOOHv_wITDa30ATmeOVSAT_kYN6r1QF
X-Proofpoint-ORIG-GUID: GbOOHv_wITDa30ATmeOVSAT_kYN6r1QF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_17,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 lowpriorityscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 mlxlogscore=715 phishscore=0 suspectscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306020187
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Patches to move handling for KSZ9477 PHY errata register fixes from
the DSA switch driver into the corresponding PHY driver, for more
proper layering and ordering.

Robert Hancock (2):
  net: phy: micrel: Move KSZ9477 errata fixes to PHY driver
  net: dsa: microchip: remove KSZ9477 PHY errata handling

 drivers/net/dsa/microchip/ksz9477.c    | 74 ++-----------------------
 drivers/net/dsa/microchip/ksz_common.c |  4 --
 drivers/net/dsa/microchip/ksz_common.h |  1 -
 drivers/net/phy/micrel.c               | 75 +++++++++++++++++++++++++-
 4 files changed, 78 insertions(+), 76 deletions(-)

-- 
2.40.1


