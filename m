Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE984BBC3F
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 16:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237051AbiBRPdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 10:33:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236375AbiBRPdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 10:33:39 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1C81EEF5;
        Fri, 18 Feb 2022 07:33:22 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21IF773A001156;
        Fri, 18 Feb 2022 15:33:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=/DqGKwJwEvEoDhC/wsKYOVzFDlWfRou1p3pQok5jZBQ=;
 b=qTxeU+B1gA3op7+vWEJvFKlheqRhwfsCw5wMlMukacNx2rQimMsGvOUsSxbtD0btXHc2
 +mfg1rSem8Z5Dj/LAnMzsLlOLepnnYjIIUeqIEWPIu9yDhUABDqWyz11vrofYUlDLhsw
 j1KkKAO94OWbB93h/opiK7ZQSnn/QtLCWUKvcGV8h8VISXuPm14QUKT9EvN1FuNjeRGj
 P8ZrjW+FUMei2r3/c93PCBdAxw9Sx3J3OWIafdEdDqRd3X2cM8hhlGen310Nt3ct8OK+
 TzGogzuNFxMqd0h83AAnPX/E5ZxN6xxK4LHaYDGDneGrkUcP7bxoZ2luFzp2W8fsCPdc Hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8n3e1wgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Feb 2022 15:33:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21IFUeXj081906;
        Fri, 18 Feb 2022 15:33:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by aserp3030.oracle.com with ESMTP id 3e9bre0uu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Feb 2022 15:33:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxmx41YW2/Qq1fHK3mNLn+ZCOzm7K5x4k11yckuUTAZ0rWa+GhUka/1T1c/DR5gNkzznjJRg2H7upKO4nq0GLXNfQ1ilvU47mwltQf+iW3AH3TP9jKCwX0wWI8Dc2u/cxuOS1BHmPZn4e82K4iSFLlTpZU4+eL3/AMlqv0AXtJcd9wpq9Mx1Puv+md6+Zsto1lZOirzMau1NWlXRxJ5DR/MUN1XAat70K9FJe4G3WxpUqRjZkWTQMk5Y2gnFV2xJi5FVK+2mAERKnoQqbtJG89Xb+xguyjuazO6CSi/Q4JZJuERaT/TNOtf83yFK2QzHJbsT57IO5YhEiEoutyDiZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/DqGKwJwEvEoDhC/wsKYOVzFDlWfRou1p3pQok5jZBQ=;
 b=obxyrWhwHkvFRkwvyAaq3d/EEqs1jsUh8/z0m/yQZrJ086mAFRevoHrl+OZw26BtDr/kMzNQ9ZVekUqpYsa8WhCsShSoiQBWIgCdW+ONtAFXniTOqpRiArl4T/IFH3Dzucz6m65Y1jyNtZ/lRaxQQD/LWSsvsAEYeOA+4274eYRVx4G6AnGtA1Nr6JYAjN/OKsY3msffo9KX3HtutO6PKnV/znDM+IRI45SF4loLuuoAyg5o+WkiX57nLiEnQ9dN+v6jimF35GL0ZSA3xv2I8/JJcPzNaM0sge5uP1QfJblAAjUAY0owLvtIGbaz+lLMPA+QU5twjHt+TRCb8ZExwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DqGKwJwEvEoDhC/wsKYOVzFDlWfRou1p3pQok5jZBQ=;
 b=VT0DkKV/uue4XYrCVxwA8XJ7k956Vh8CijSHVHtBg2iZpu44gSqYgOeWpLexmDelP7M/ZyBIvBGxhK+1BG3oZsOrJ5onkPlyaeG/oMKc2xyNGegEBjuBE65QIVEqlm3u9fGZUEs34yynXFEMw5EwyvFCd3qOAajo1Kv+8eszIKY=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BLAPR10MB5028.namprd10.prod.outlook.com
 (2603:10b6:208:307::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Fri, 18 Feb
 2022 15:33:12 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%3]) with mapi id 15.20.4975.019; Fri, 18 Feb 2022
 15:33:12 +0000
Date:   Fri, 18 Feb 2022 18:32:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net/smc: unlock on error paths in __smc_setsockopt()
Message-ID: <20220218153259.GA4392@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0027.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::14) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6bbd25f-71e8-4078-435d-08d9f2f3f8fb
X-MS-TrafficTypeDiagnostic: BLAPR10MB5028:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB502852D039F6E3731E426EF28E379@BLAPR10MB5028.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1usQPYcLE3xDnaYvE5GstxBffKG+Nci+OuAF8Vav8Is2pdY0+WDfZ/ncWI5Asjv31qWNeJzR6dn+6lmLcVCxQd9EzGHDiVCDXBfGaH0t5EMtOCLBdE+Kqx+2k8Na6OcvKFIc6Xoyj0Nd5EvYscNPVhq6lZKIFeGQXcj5Xd1SaKiWgiPT5yrl9RwCFyxJA+hGyFW9pUJbhLFTb7C2GWwJFJmM144nDhNKULiZU1QyP7XIgfwo55OzKlx+yZ5wL24GVkrFUt5pitXDjHc2sCMiIx7lEjfdecdrZeSLfCFiiQwlL2fpCKqMlzozXNrdRxFqVK/D1zTC1HL7VdDm4dH/mjAu1qBidkN4If6tYVYn0OCVmriwgzWpmUTEdytK4qEEX3Mr59Aiva4HWw4F3FhvRrhj4D+GJebjuFnSkvIw+UoP36z9bj3qyV5JTQXLyWbQawP5bkmJJH85kPVO55s8grg8WsWmLG2aPzb94GXSOWWHkloobUtGaINon32mWMpioLTfklmKxHNJoNuguqTDVrhKOuyYTBdHb4bh2O4CaKyyeqz49qgB+l0zH3gff7a+UegK5BC4SR6bDGQF84ffC3ETPG4eAqrv2uQk+qS/9hfhlTzushUSkR9kLPv/hABD913sa8ByGvWimfUpPq4jlA//299gE4Rt5My/ccZwwfExs7Bp+Gu4K0fm4UoWb7lk+rhEDojgwM7NT9Fl0dGij7XU24s7DulD3PhcFbEAsWU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(83380400001)(186003)(66476007)(54906003)(33656002)(26005)(52116002)(2906002)(9686003)(38350700002)(1076003)(38100700002)(6506007)(6512007)(6666004)(4744005)(8936002)(44832011)(5660300002)(86362001)(6486002)(508600001)(33716001)(8676002)(316002)(110136005)(4326008)(66556008)(66946007)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ypyHt/qmrxiSdnqfIt6tG7/XT+XeFnvzqNwMxEDRsX7OvOpwcEIAgs1pnJ1T?=
 =?us-ascii?Q?8obwDYQsWeVzFWnsLqY6wxa/FYZiQqOU2O5J7zBRNrA0pjy0sNtyBoXWmqby?=
 =?us-ascii?Q?raZhRXemH0Z+KkxKrswhnRypVV8BtQUdQKuwVFltx4CSe0KdeK2L+QrdcUoX?=
 =?us-ascii?Q?F/oSowJO9Bc+rBPaRCI4GSUFwNz6oZHQozyYUhPGaCpHXVdvIfLjzS2mJlIM?=
 =?us-ascii?Q?9P92WwNv6MXQqR8MeK6WT48arGBFcbIcEnpHyx9t+WY++OfC5+8YKD9k/Axg?=
 =?us-ascii?Q?N6UdhMpL3ATmG3sURxLE/hgh4EY53lIOnHNvEU5/iVLNXANDUw2wAyC2jhLU?=
 =?us-ascii?Q?Bjnx/970fWFjZh5R8E8PcrLNcS0NRRTVXXgjdIRu8ThUMpWLpwiBDQ0yJEFy?=
 =?us-ascii?Q?QIUaNTTl9joPUIcghx+ZzVO81KqIdb23ym6cmsUE+egeUuUvPg5nwoe//opg?=
 =?us-ascii?Q?f/rfaDyZgdaC2x/8s885dmnSVFPaZ/yBwEbcVhUJwI+BF4qZ3Kqbv+g6LK1x?=
 =?us-ascii?Q?zmKhSf2NqMlsajQCImKGJtDWXp0VU+nlJXFWFDmW0MMchwod60DVv+j2+dyZ?=
 =?us-ascii?Q?HvZ9F3sgmJFdYZ0r5X+S86wXDgdbbmvcl4AL+Xm9bRFzUfg8mZszhEFLbN8B?=
 =?us-ascii?Q?QXUTB+DKwfwDWZILaZ5JQzBuE945yNmpN3W95MliRQKu8or/v2/03GwGTkJd?=
 =?us-ascii?Q?OcQPrMsuXuqkVdYNyIYnbJ2FMPifwL/XgNI9zuwYhUGUwBIaKg/RlS2wSjkX?=
 =?us-ascii?Q?saFSlRCpfwMGZSuosEkU4aJC83zWlrmniiMqFjSS48gUgY4ffBJh3VVbgKDn?=
 =?us-ascii?Q?PYLJ771k0KLd33ayXecHtXeSFGISRpsrDAHuDjWfhrtTnBZkd2NwYj3chPD5?=
 =?us-ascii?Q?tESHd2dpNhQRjMTJyFcCjEPB087zP9Fb5VlMrg5S/y7tY3eSPHrJSRbuc+VK?=
 =?us-ascii?Q?JGldt3Glz9mHEW6a0hRWtZ1xMjjpZI1+KaT/qcCTqJJsYnwX2JX0/x/vloym?=
 =?us-ascii?Q?5L/sjgpWwTNZi6fJeuWIM0oKWoOobZYlIpi3tKFNJrlly65UVX/xOgbYKIWi?=
 =?us-ascii?Q?ujLb/zfpp/Yex8wFzgpbyk4LBUICmAwPfR79vriTpAnSgjrWK26hDoFNLI6t?=
 =?us-ascii?Q?MhDbDhkBuPbE+ckJZ5DqbzH6UChL/cUsrCnsyCHZ/jYAnChAsCdi+0savHOD?=
 =?us-ascii?Q?CNicXyxLxO4ivXsIUu3rcFuZSmLLZb9NoRZmgc/JYj5liJ+AlwrJ0NoaX90W?=
 =?us-ascii?Q?RdhF7tD92bBX7HGXluek/X9TFc5isfXXPPTGsXbOwvCGDCBBi7hosZUrZmbO?=
 =?us-ascii?Q?46YGjOt13w6psb7Fm7ofKx9lC2cK6SOdhAbBZS2SowOBg6kJNkxgZBhwwt3d?=
 =?us-ascii?Q?R8ChediFdYYaeL44cOXL6apZMFqjIEUgElIjQZ/BRoBsr/APzG4cuKrxymPc?=
 =?us-ascii?Q?B1s4DS+PYrI4cST1DDMFN4FVex/2KC9N5CWUqY1aAhUwYr5vJRT2KwK2HXGF?=
 =?us-ascii?Q?gWWhe0N5d5IozLDp3SlLiuwv8dx6e3GOJK2CIR48Vf9/CJ2RVWel8egu9y0b?=
 =?us-ascii?Q?x8jSmNS+rMV1FGJ6Bar5EqTkeLqSRFk3xdaheQrtbN7jopAkJdghJvJUGQCH?=
 =?us-ascii?Q?02hkjmeaQS9wWcRzC9cASWxL6X+LCHIc43fxVb72WAQA9nj6n/a5UnbnYGEO?=
 =?us-ascii?Q?BciXXw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6bbd25f-71e8-4078-435d-08d9f2f3f8fb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 15:33:12.1889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YSRxUXAMYcR9q6KnbT225nVbwdXSeNYfryNigqQKoA48qZZFmAEWeTxUuTSL+z8cbQMg4vlcN6IVN72oxOzgYP5MMehpG6f2sJOUf1M5SCI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5028
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10261 signatures=677564
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202180100
X-Proofpoint-ORIG-GUID: cYZIGEXhzF6pl7tBUVgJRgs1ty4ghQTA
X-Proofpoint-GUID: cYZIGEXhzF6pl7tBUVgJRgs1ty4ghQTA
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two error paths need to release_sock(sk) before returning.

Fixes: a6a6fe27bab4 ("net/smc: Dynamic control handshake limitation by socket options")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/smc/af_smc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index d873afe2d4dc..38faf2b60327 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2715,10 +2715,14 @@ static int __smc_setsockopt(struct socket *sock, int level, int optname,
 	lock_sock(sk);
 	switch (optname) {
 	case SMC_LIMIT_HS:
-		if (optlen < sizeof(int))
-			return -EINVAL;
-		if (copy_from_sockptr(&val, optval, sizeof(int)))
-			return -EFAULT;
+		if (optlen < sizeof(int)) {
+			rc = -EINVAL;
+			break;
+		}
+		if (copy_from_sockptr(&val, optval, sizeof(int))) {
+			rc = -EFAULT;
+			break;
+		}
 
 		smc->limit_smc_hs = !!val;
 		rc = 0;
-- 
2.20.1

