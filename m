Return-Path: <netdev+bounces-8106-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C83A6722B7B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:41:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CDAC28133D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9864A209BE;
	Mon,  5 Jun 2023 15:40:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B931F93A
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:40:36 +0000 (UTC)
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409BDE62;
	Mon,  5 Jun 2023 08:40:27 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
	by mx0c-0054df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 355AqrFp015545;
	Mon, 5 Jun 2023 11:40:02 -0400
Received: from can01-yqb-obe.outbound.protection.outlook.com (mail-yqbcan01lp2241.outbound.protection.outlook.com [104.47.75.241])
	by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3r00mvh95t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jun 2023 11:40:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/UlcbTZad+kbWln+PEV8kY9K39g6LJvVqs+4/a2ReGOCk2ZvNBotKZ2t7C65u17pBFiO8Xhfm7ayRASkTN6ZHfrNrEkTQ+KQ+NJDTB+DO1HmqPAgTu18tSdbH8U/883UEp04ybV981IVReEaZU1Xr6S4OhYCQ82aenCjsgQPdmmpUO+YuaGj0tZ6BFbdKw0eviSfMoRxOH6cFr6DAsHNv8iyrg5949syZAegLGaFtBbrCdD3ynOAWzeIEi5hjw/y+UlZYdVhs+DQn79f4DjCdmdv63lpwcz8Qdc+f6g5fCMLHmQkrOEzr1zzlPZOmx4rmbKy/LCL2YrvLqMtdIedw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dgkFYKtD3LK051GyGJmTwF0VSbvk86fYZ1jkoTC0Mjo=;
 b=j18/WoLOxakwkdJruzB7cVcATtOOP2l/dMEsh/MqyeimdnSXJijpru6I165lifgneDpvXzhEUhOXFewV1BG9GB+TlMFlCwnF2HAqE6fja7cWqbAwiSmT787LjvXVAsGx3DbFTeGj0YAQ5M/iv2e+TgjxzVZ4tdkETxBeWQHx9XUJuSxhS/HVOEoS37UAoVahdAo/7bc5XSw3JS/rhXSK5L82zsmLS8NAu1f41jViDCPmwl7Ia8yOaTMm5J0piLkJsUFnG/YAvyuFKpZYJfpGOSCStSBrgW9JIf1kHx+D8Tr8tI+sBMh1ArIsgVPLSF6rwuszCIkK78f3y7lXVv/zpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dgkFYKtD3LK051GyGJmTwF0VSbvk86fYZ1jkoTC0Mjo=;
 b=0CJkMsSBiexSaeG6VX/3W2fhRMgP8BKG4lwGwS/nEIzRJVu3Q0rkxGMf0KkwU5q2GjDpij+soA3cPKdze0Pwe+pk4FIaa2gfD+Gu40V+vD+aySub4hRiXKAmfGm1HXeQuYT2mIeJvoSOm4bjuiouLP/vIijCz2W4YgI2FFoNTck=
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b9::6)
 by YQBPR01MB10812.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:76::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 15:39:59 +0000
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::c059:dcd5:ca20:4a0]) by YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::c059:dcd5:ca20:4a0%6]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 15:39:59 +0000
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
Subject: [PATCH net-next v2 0/2] Move KSZ9477 errata handling to PHY driver
Date: Mon,  5 Jun 2023 09:39:41 -0600
Message-Id: <20230605153943.1060444-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.40.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CYXPR02CA0063.namprd02.prod.outlook.com
 (2603:10b6:930:cd::8) To YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:b9::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB8838:EE_|YQBPR01MB10812:EE_
X-MS-Office365-Filtering-Correlation-Id: 58f7e1d8-b229-432a-ebfa-08db65db1ef3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	2YTSfEmVAfgUKj7sEhU1dFL7Dao2abHauJqe1N4PQOzJltIEw60o2DSYx6f8PtJGyEbBZtApHbS4hKrA5n7zwsIMST8TdbyXt8hGBhJhcX8Z/ORnNZz58RSlG/R9SrkTCFtbxYx5OYYNCxhRTJ8WFMeQn7DgHBcSZHFs9zzOMRG7BW0k6soqd4krmhlEMZa+8nuozJOPZhtnwrRwqbbx5/oEP8PShjLVIo0LtJ/GTWyoTDe5JXYLbQ/EB1mOMty+Dy3Bs16FOkkPXP+k1aCLm1ktRzCORwTAmnJdBoX/Wv7PEcyy2Qo65UmuvGZefFBa3TDn6jYrLgXkeJwXyHKnT6NwfLg6AzmlqHTKxB5R0Xy1lwcpZ+Z+t+l6AnWf5AvCr1pZrO5uy74THx86lq0S8kg0kdWCPWd9Bq+MuByVswJIQBn8WXrUTy32tsOXsPQZrjAY60bB8YzSOKfFAc5Wq++xfxoSbdmozDn7JhtfYa2jWrKQJkH/cKt/LIuQGMJdhocWwVLsf1ETpXQrDfpa1ch2ej4Zf9w0Wd0PoUuYinjUfyulzNv34KU6IdXMQsMBU8HX8NvwJwXymq4kD7RSlJC5WLRIx4bQO/FFNoudQIYa4kLIEMwFrQm+V6m+gCrhyLc3VOkZxFVlNSf8z8R87Q==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39850400004)(366004)(136003)(346002)(376002)(451199021)(8676002)(8936002)(2906002)(478600001)(66556008)(66476007)(4326008)(316002)(66946007)(4744005)(110136005)(41300700001)(6666004)(44832011)(5660300002)(7416002)(52116002)(6486002)(6512007)(6506007)(1076003)(26005)(186003)(107886003)(921005)(2616005)(83380400001)(36756003)(86362001)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?B70ot7gVlbxR9te3QCEj2LizoXiduAJTppU3V+6ME3YJDGH0pHo2m2s4hHL1?=
 =?us-ascii?Q?PaHdFrtmY6bbapLAX7mltAMF8Li6/Juyl6mIo0OTeoooWLTN+oPJYBWakwK+?=
 =?us-ascii?Q?2jvlFpeQbVPRNDO4EUGhbBzie9V4WTQddgz7vg5e9En/fzfFLAgP7XsGy0WS?=
 =?us-ascii?Q?lmXR/Hp9ovTzVCdju+N7kG/2IOfDP2V3JvqoaRoEwKnvy2FI6lnZfOpcbYEd?=
 =?us-ascii?Q?SCvvEUL2/rGI8CBNk67zp7ZYewDRA1ZNmS+VrXqGXbMhNT5z+Rk6spBFffjF?=
 =?us-ascii?Q?h6OPACSTSAcoic00M2UGBVOVJ6RtKHeoNTM0crj6lksEdgmEm6PblCqP8I+r?=
 =?us-ascii?Q?MpqZkKNWSsdFuKZav+94CbX64dst1DzESWj1CybdDC3kY5p9rBOBknwmk09Z?=
 =?us-ascii?Q?9piempTDDVbGBSjB16PzxMZs49h5Xx4TxPqYulDAJL5CDaOe7Z7IYZ7LjuqX?=
 =?us-ascii?Q?MGLA7HU/BA3SaOW0nSPOJ3EXeQcpZO32OhfExjfUBLbbLF4oJKW+sJmiF666?=
 =?us-ascii?Q?wO9dlN6s9YbPez2RtzqqexJ2x/jgg3YKcM4rUBE8D5VQiU9fTfQ3XTfCcZkc?=
 =?us-ascii?Q?e/h8HRUgBLw2tz+KR5ZWiBslpxpxdV29B+VmQVlepPNqlbhtMl9n9SAzQsa/?=
 =?us-ascii?Q?TZ1H5dZxYNTYXBasvNyA8IfkAYQcDLYKULF+H/VXfCah166aptmT93bCMgcl?=
 =?us-ascii?Q?QYegFebM9vnNumqT0dPltyZshQ0miXgJOkSw3OKqIoE/KvyodiC9keVpMod1?=
 =?us-ascii?Q?xi7exgJaFrlYANFZgAd8No8WLDsBob08ffJ3+EHrs9q5WEk9/oCQE2TPs8Wl?=
 =?us-ascii?Q?+lDlkVB6uRXMdgvNE1rUgYLgNdVjbWHrm5W112pUa7Gn4+agOPE759YtxSBk?=
 =?us-ascii?Q?zv34wtXHXf8vIZX450c8op9ooebHlDltiDeNgzvaXoAnLRVK2qyY6Sl/7BFd?=
 =?us-ascii?Q?eECvjy5/zIGjhi7OMi0nVjbFZ0boOiWe7+vNhTjF46E9qs/R5lPJJTstvrzE?=
 =?us-ascii?Q?NRC2lo92uInMDM9Nz7oWiU8fRUQHnS7LmJUTXqERGkZOU3zvFbRqbuxGeGdu?=
 =?us-ascii?Q?lloBPie2N1K4Ixl1HLQJ0mPKixh+Fo2yJ0PpCeJILenORfVEkI7hiUMIkrB6?=
 =?us-ascii?Q?HO/ist0SNYPI2iRTLCogNRbLn69faGWNtbUfyJDhKl/c2FnrwbgaEdSHeGHZ?=
 =?us-ascii?Q?lglwcRP6d6rDUOev8RCEPznqG5JtMGICOAVFRc7WD4hN2yOWjLXQHy1CjPGV?=
 =?us-ascii?Q?osS4oITIrKeLxL842GIvikKzNX3RmbJ1Wm6moUF6HJnUjTwipdt91JOTEgyD?=
 =?us-ascii?Q?KI0Qiax/aQkYepK9nB/JsVrUm3ITqg5WiAlg5btqjinvYWddNAmbxp8oIUa1?=
 =?us-ascii?Q?nbTVRmR24g9S6f0CbglJSzRs6QOYoLAysz5Fx4zOX2RZRsjW7jJP/SSLr+Wm?=
 =?us-ascii?Q?9vPY6uyvzJtAqqL4MEKH9uaOhli1rAaJJmRupJbf80/xQSQ+hwvlS1cO3R72?=
 =?us-ascii?Q?TDBmVxUNIf3Lx5NbWjsY+8uSmg2OXpz7hzQpd/a8taZtKbO4dmiaTIRz4Fny?=
 =?us-ascii?Q?w6pis21j1XZppLqmr0hegwpCpMfcTJk7XqdD1PebfK9dflBJYhsWr2PFw4MW?=
 =?us-ascii?Q?hQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?GYqGof6S6uzMdywzqpWCcv3CtfJCfZW/KYh/0C2JBADcZc7k+M2YfP4UOx+D?=
 =?us-ascii?Q?pKFYUyR62Hz7NoMnaLuXFWtesqxKQRjEOrHc+PUuntqj7sCogUDNMzxzUy4K?=
 =?us-ascii?Q?8/TblF7fzBi5iOjfIF5Ns6FJqSHdPvK9l2bWk52eALVx1De8eI2axLgXzDpD?=
 =?us-ascii?Q?rHYtFpq1O+BpLBB4SmjgMO42ZA3Db4xGU4/9n+Bij0zNrwaCLp760tu/jJ41?=
 =?us-ascii?Q?7H+XhrFusfSJIBSpC/crhyb3cCS8DhwP3tsupYrxA7O4Kbdfb3dTT5jrGXJd?=
 =?us-ascii?Q?cV4AE/Fp4tY4RVnAR7vimwB/FY1loKjmF3SqJ5cfarrn2PxWqpd7TViXsZy6?=
 =?us-ascii?Q?zajhcY4e2IgpkMMz9teHpXxceHpaWKJKwQ+aysJgrZL5C3kNo+4ABBscXix6?=
 =?us-ascii?Q?8Y9FkZvsVlfI48npQQY7kqqHQZoLWY6wNUqlx8naXKyBEg2VTgBjHCn6mnQ5?=
 =?us-ascii?Q?tE8fBOJV1HU2SVOcFsKQ9+F1o/SHWhCKhCy+hkdkp7uQunnRpKMhooQib725?=
 =?us-ascii?Q?8k3dleu0phNyIniyrkXD6DMh1184MBcdKeyZxTyFAs/zOikAqnMB10xINfgL?=
 =?us-ascii?Q?q+lxTN4mOS+uQtlUYV7C+nqGQy2yD09l8jI2mJIOzlUES9pjult+PBhzbcSO?=
 =?us-ascii?Q?l839W8oQ7FhP2tQ0izSmnrdtQVdn3LVJMKWz3HQmgKLPKH3UIT+zztbEjegF?=
 =?us-ascii?Q?xMfBDJCn8WEdyImWqtj9brr76i0spS7HwvVfMUY/czm0POlMNCW69Cu+iMx9?=
 =?us-ascii?Q?NU0/9hhh5rs6Qn4+V1t/iPZTGe9eWlpqj8earNNXtFo/w8kEcZWXb3fC/Y5r?=
 =?us-ascii?Q?c/jdCL9L/lx/FuYcMeQKznPNYk7qSv47yUV1asWTDVSzSdfvyDrHPQsFAeB4?=
 =?us-ascii?Q?ojR8KdLUQjqhwmkkvrTGxgV8P7PXczwUXURm6Mbt1Ac59KUmlD4qQ1w8zDXD?=
 =?us-ascii?Q?fGUQUqJq40/DRYn1ntal5WEJgiedye8jA+H+kTt+zQ3ZMBt3f74J00dFRyp+?=
 =?us-ascii?Q?REJAY3uMiGzlx2RTfjsBBI3TrQ=3D=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58f7e1d8-b229-432a-ebfa-08db65db1ef3
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 15:39:59.6807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aq26TwS5ixDGARA9pdgrUSMy3J4uHdCm9TNxaR9HxVZSpXGscrUnrjqhbGV5XYheQb+pQYIKn37yTT8zLq2aryN4RBR4sRj9KHoIxcCttTI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR01MB10812
X-Proofpoint-GUID: Nqx8sfGPOk3FN5AOBdR6fttY5-Kc5YkL
X-Proofpoint-ORIG-GUID: Nqx8sfGPOk3FN5AOBdR6fttY5-Kc5YkL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-05_31,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015
 mlxlogscore=734 mlxscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306050135
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Patches to move handling for KSZ9477 PHY errata register fixes from
the DSA switch driver into the corresponding PHY driver, for more
proper layering and ordering.

Changed since v1: Rebased on top of correct net-next tree.

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


