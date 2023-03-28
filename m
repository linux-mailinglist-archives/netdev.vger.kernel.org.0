Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9998B6CBFA3
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 14:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbjC1MsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 08:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjC1MsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 08:48:13 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DA8AD2E;
        Tue, 28 Mar 2023 05:47:54 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32SA0s6m004579;
        Tue, 28 Mar 2023 05:47:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=naE6LNIxPHawDqJIfZUggQ4oY0WnkTWyO5LaGtkXH3Q=;
 b=qIMkHDaXKn2w3yvqWzJS0t3sdf97rU5vfbc6wvPBWNkvhjROhqhT5kiE6TPhss6c92oZ
 Tr3tP98YgOFpAp67cVUkbVk3X5z9jslh6qQ1gmOTXYrgXQBfoUCXpoN0dEwkN5llCl+/
 EQHVX21zQJQoNGijxbhk6Nlfm81uoxaihC4ITunaK5nBVL63K8Nmp3PMr94aJV1+RrpA
 mftwSlrkVbNYFGsBAq73ciQu8aa9Q9MDuI+dzREQPbntWecczN6bJ8hAGAxoDaU8Rk/Q
 pibkqwXA/L5EWX9QjIZJ+fl6qxYyKVuE5vKFpxBuYhgjr1waK8xKSuVRgwhVHGIspeNW bw== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3phv85u3a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 05:47:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FtyGXrDYXa5po7jMbNIggWC/YSP8MtLs2dxRXJNCGfW6tgWXEIOFyj078kII4foh22JPQG5bwgITVLMgFROnf8CSJ3ZrjkpKlxGopRWTjyt+t5lGebPYv/Nvk+7gRb8PVSudkkaoTmWoCfX6yhAhT2I/7HGX0LTVLue5FZMojWdq+4+0Efo+/F2lEjq335yhuXOhgk0CaLIqqqtqNkWWbWU5mItEu9jg7vCFotXbHy9hck9RPYL1wBA4jmJmA7H6nUNfSb5QALoXtBGGd7HfRNK4XLhHK2vAeYMLjPh+R+Zeq2HWAd0gU2mv7o4UjOqWuFW6TKt1ucZiyRAMhzNQkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=naE6LNIxPHawDqJIfZUggQ4oY0WnkTWyO5LaGtkXH3Q=;
 b=Ojg2I+G6FHxgS9Xl735958U9yxtRInH+Rkufz4kNBqD3brYnRiE1Y1amtiFp7l2MEhZRZkSw31movS3fk908MaJbKEUvIilSHXktvXSC1GzT7EK2imLmW0It+evuKxh5Euyk3/QKvAMxnHZWmUdlWNbfmG3xKysdgAYG0h652Zneu7EYustZ2tvEqXN+Yppou481EsjBbDj9cE2zHUO8pAwMCuC9fe0WTNtbV+PJM58AB6bCf/gcVCgORN5ofi62JAe9q5tSHTeCEd858DqcBlK4Reos/TW54nkJnHdUzRrWPs7QmtSIrggrpS8Ba2fI/w6Ng+ZBJ0CVSptjYrSSiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by SN7PR11MB7466.namprd11.prod.outlook.com (2603:10b6:806:34c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Tue, 28 Mar
 2023 12:47:06 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::95b3:67a1:30a6:f10e]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::95b3:67a1:30a6:f10e%5]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 12:47:06 +0000
From:   Dragos-Marian Panait <dragos.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     George Kennedy <george.kennedy@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5.4 0/1] tun: avoid double free in tun_free_netdev
Date:   Tue, 28 Mar 2023 15:46:27 +0300
Message-Id: <20230328124628.1645138-1-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0050.eurprd04.prod.outlook.com
 (2603:10a6:802:2::21) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|SN7PR11MB7466:EE_
X-MS-Office365-Filtering-Correlation-Id: 21b9badc-20e3-45b6-6e24-08db2f8a8979
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QzXr97P64tRlCSFWvdCS1xwwoPq6mxRZEvjg8MFBCdfzX70PmVgWJSy6eipy8ESOt82P3gFJ8Z5Wf41Hg1/JhrPRWghpnAFpTwGCRWsetDuenm7MpFn25RnX+kBJXMLEgen7Hi1eZPJmK3him0BeQgzHZOjfCZuG4CHZZE5nfwf49HkjYEr+woLbtnwOtGdUKvemVcExeFGRtpqww0t3vImgRx2p2tnvWvnz5v+cHWmL3NPLF3PQTfsqr9a6Uc9ixo7Qc9G1jITCbAYfgsL7RlMisFHvNNi8fre9Aua4/Rfi0rjw7Sid0y8E/K5p0bjCR+Tj5TRhnoPVogVF89ZqKxSTyyA67xlaS/HLOZeXpS87KMIfSyJeriyrrfk7vTQkr9Jh8j849oXXBGkdRyWf5fH38eqeTd+gdv4cfi4Lr7KTcJ4Mi5uE6ZwG5YEFtO8/gQWKzeXmMa/QBQdBJwJtyiwGvML5WFIrHZROmD4sfvt/8bIx1LgIwvzSFNXI4hlOp6PnET7VVwRF6AEUFVcN3JLWXK9xNXm9g+voJR/VawdqxjMvx2KDiT2g+/yH9otS3PGyRzrJ/VmpmOen/ZAyic/khfI8ptp5FoV0pquF9yo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(376002)(39850400004)(396003)(136003)(451199021)(66946007)(41300700001)(38100700002)(38350700002)(478600001)(54906003)(6916009)(4326008)(66476007)(8676002)(66556008)(316002)(8936002)(5660300002)(4744005)(52116002)(966005)(186003)(83380400001)(26005)(6486002)(2906002)(36756003)(2616005)(6512007)(6506007)(1076003)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nDCWbOAfI2YLH9ojDGs9npRd7wsIG0Te3tDwvtzYF+7jak2B7C0uB3UsOJ7C?=
 =?us-ascii?Q?VVM0KO7d2U6BsgkdzSbqMtSfAJI3GGNKC9LYz0HIcH0X02SmCzAB1zEBsk28?=
 =?us-ascii?Q?qXMbqJ/AyvJOYlkPY5VQ1j9gPkm78/9BOsRoq8yxgO8ZqjDpw+ui/t3DqBo+?=
 =?us-ascii?Q?5ttZYegMbRtTewZIcq42/IKrOeP6CURcozod8Tl73wVaxEpUrm5Oym6GOGL4?=
 =?us-ascii?Q?hcrctCnqEFI6VmEftOWTAOERqsBqZc/u+ZRHFo4s/60COGss1kWbv1+C1z6k?=
 =?us-ascii?Q?OCBboce7oqXTGu8sWk3tAM19OGmIEnyb2QTyGZNR/77higZ9G313fWovx8No?=
 =?us-ascii?Q?Fv9YGfzhxGDMpxsi4omGWnJPy9rYqc+hfSODIX+SX9Qd+Wb+xQ1zO+gqqVt1?=
 =?us-ascii?Q?UiVs7nzNjxgJLUwGA6YLBlQbrq85P7xDaPObUUPND0mXvz2+TTcU7ZmgoD7e?=
 =?us-ascii?Q?fCDatSsq0NWA/NWqZrpj67QSegtf2P+Rl7hFEeCf/mOd2ZuV0+ikI9FsWb/Y?=
 =?us-ascii?Q?aW72K/73c2g3KWYeRudhZw0SGUdkutjlmDEj+uqh2UFEOc94/a85AEY3Zhgt?=
 =?us-ascii?Q?oENPEpPg6xixlTFMSmQiTs4AADIMMyOZoFNwN9fTiwW3/L38N35Qugvecz6I?=
 =?us-ascii?Q?MLsJua15/ruUdb/iY+imSE9YIzJ2wmhWbxj9P8SY5GZKEHEORC7E3vo+52L+?=
 =?us-ascii?Q?Kh5Totrb8DpD1v8mATW0qzSvn93TWL664Rweblej2HChaCvCgobNKjUZThSX?=
 =?us-ascii?Q?e4+d33+szyfL8tM2jYzXSYJgn3/DG4c6q58D/62b6DOr2ualm/wHgsHbtBet?=
 =?us-ascii?Q?EsK9BOHRcbiORbQuXXwzOGCyDJsubq1X+DS7G1uAiWr5ft172WYT/N2a81jH?=
 =?us-ascii?Q?sY0LsxgRPd5gStGdg7NIdSQVGlND2G2rE/jZR7bfkuW8qh75AYnvc0fbu9mi?=
 =?us-ascii?Q?sasOqb6z9PkJKow7WwPsQPtbxxsN2u7l1cBcRD7mtlY7v4QvXcYuDX2cUM2r?=
 =?us-ascii?Q?4rw1ZhIkcWgvNIr4uvcXyQJPY6XZaJPeTnbzljGnJwZPShNY8sH7ucIvkYbu?=
 =?us-ascii?Q?YV4Oe0MsM23LchA98gzyfuRgOrIB7BQeEjlMIPeRsRcS8SXG9a4qWC6RbVIH?=
 =?us-ascii?Q?on8B7numGhJvRnF5bKB8m5u8yf18LPIDy523ynz8c7Cjq5vlavPqrEAqQs12?=
 =?us-ascii?Q?piZBnMeDZjTLS3NdyyLfSGSC8maJGDmIwPR2SAIslDF/83KquFkUOr8ZqeuO?=
 =?us-ascii?Q?Loh8gFRwK1YhGVSX+qJzDIewPmk7oiRGVYxoP5Xm6ua8taJv8ao6NHuLJ5wH?=
 =?us-ascii?Q?MPj57gLtzd1kSP2rI/tBn9MrRR+BKm9G+V/R9kPP8/gxGtQcX94OcehiBikt?=
 =?us-ascii?Q?fVViOUflv/Nc6TKdtsEpNu3Ev5aEwWQoGQJOP8VlIQtHF7yZn4FPX0vB6Wgk?=
 =?us-ascii?Q?tPhXnCFl/UJUvE3EyLCdgd+rsXmZ+jqdaUaFV9UWEfqOuTflxnx1elKkA5+2?=
 =?us-ascii?Q?ex6tknXTgCadlF0toJBHWSQJ7JGMM0ED780nASIswYDc5kyUe1nioOZ2xBru?=
 =?us-ascii?Q?e5qPHiMWJobK04OqKqnxxD4ZiPF2D8TT0jOCg4jMAZuzOKLWWXbCF54JbAjp?=
 =?us-ascii?Q?9A=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b9badc-20e3-45b6-6e24-08db2f8a8979
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 12:47:06.5581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BFrH2raFFnXBsEfIdg9tfm7QUk5UJ8RIOKbvoDLubKgI+Qp7wFSysGyzjAKAD8ePhQNAV/lzb7lb8g/n9Aq+08MWxKcP6XwsPIi4aJT1VYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7466
X-Proofpoint-GUID: 78Wiqoer-Pzy2tcHU4y0Rypcbq7MOOq0
X-Proofpoint-ORIG-GUID: 78Wiqoer-Pzy2tcHU4y0Rypcbq7MOOq0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=1 suspectscore=0 malwarescore=0
 adultscore=0 clxscore=1011 mlxlogscore=217 bulkscore=0 spamscore=1
 impostorscore=0 phishscore=0 mlxscore=1 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303280102
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following commit is needed to fix CVE-2022-4744:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=158b515f703e75e7d68289bf4d98c664e1d632df

George Kennedy (1):
  tun: avoid double free in tun_free_netdev

 drivers/net/tun.c | 109 +++++++++++++++++++++++++---------------------
 1 file changed, 59 insertions(+), 50 deletions(-)


base-commit: 6849d8c4a61a93bb3abf2f65c84ec1ebfa9a9fb6
-- 
2.39.1

