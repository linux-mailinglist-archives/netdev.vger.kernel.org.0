Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C517E3ED107
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 11:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235421AbhHPJ1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 05:27:07 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:4854 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235406AbhHPJ1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 05:27:07 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17G9BvEl019937;
        Mon, 16 Aug 2021 09:26:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=W+tE2wYYDIhwzPhKy06wCtYrQVp+yQNqp4D9S+mIZXI=;
 b=WrisNEqvJXk08OpODl5Wv+M9nyBLWB4lC//gdERkdo3jmfMuClYKjuAftl1GMHiHBBBW
 P8v5ACCnECAbKGR5HxwUdg3c+cUkRyZzFXrgQpFu6FHfdqScMXRpqac/K3RT3xP3IIpc
 e1DBjJxGAtWdESepQbPiw0aBPrfd1VpVjGWzp/ME9Th2/Z/LcoEVjDm7WTg9tJIK0w+Q
 rnNIqMYCKPv7QPrWWoPdu8fZqpSGAWPejRCZe2lWDm+zM68yOuPA0e68KaqfCYC4Mu4r
 qi5PT5j9iNaCmWdVc5Bd5p/OdvQQS4DKE+ptx7oNQgN4Lu4akuV9Akxy/WikgJtm8mXe iA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2020-01-29; bh=W+tE2wYYDIhwzPhKy06wCtYrQVp+yQNqp4D9S+mIZXI=;
 b=qsFvmgsfQ1u+TMFwM2y5xpG0+rlV1X1mxwOlsgu639xq6up0mSk5MLsVGH0xPMcSzfpN
 1ngcVh7OEa2W/YO/HeRTojiM4wVjwwaJ+Setpj5vp9gz+fv2VLsdi6drZCcUE9Nh8oks
 uPTyPul9KfAybxcHiWtoYU2A80KVzJP7kzpI3VlImT58kS81vLBn9qrN7vYNJXNFAC76
 R/bvxztJl05XVFqBMudxZzrcbeJpamAzxech1NBV8Hpe2DiS1R+CP3FRe/zv00HevA8T
 NsnSzi/O8ugLBo/YkINxUN0jAAz34439cyBtxnxQ/QdgqLSa7/alzSJRUgUfXPljEMWt fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afdbd0wng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 09:26:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17G9Op8T054374;
        Mon, 16 Aug 2021 09:26:26 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by aserp3030.oracle.com with ESMTP id 3ae3vdgc2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 09:26:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJDfacFUjTFEbiCh1wA/LQXht7k5cbsDO0yWtuS4mHCR9l4eP2O3VytqlTLW5ZBkCCvqwqi1O6aqz7eatrdIwIIZ7jcKcppcmPnlRHOZPNrWR1o+BCJILVUed7NvK2E4GOrL1T/333+O7s/DhnxdKPeJKChdYbhg0wCD21AtN5yM6zXCVam9hhWA3rVeUujRK9GvvAK1dOmO+QymETrH9ccPW10nH542L3SNrmPjMyGSFRV7Ns/1F0g0PRgIe1vVSrIfxODMVmRcIhrL+L4gfotIL7TSrvODuW1fdnKY69hO+DFJYdKGFVfmVfUVrg2Db2LHHfe2c+fyWej7yLNxWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+tE2wYYDIhwzPhKy06wCtYrQVp+yQNqp4D9S+mIZXI=;
 b=DPvkb6kowTVG4odiPdxxW6/njfei6WraEu331DjH4C1BIPuP5z80q2CqolXycs24J+vIqFp84MgbZKbBfVS3XV6kOelVccnYkcjTlnJtLB0shrpJNNnJutN2fL4fy8h5vjVSE0LkMcjVrwC2zmhZfjiPpmAuzofDH6k8kt7ztyxsdmS8duzZCeTf+E1P3uYf6RyNGHxYYUXsSrYASVNR88P/bEpJW+sQPQvziZhb3wzSbfaVM2/XWMXehxJUa1ySe5RsradZKDi49nNYDoorgAr1maFdMUnJRfqMBqrxXA1zLXzeX9JMhMb4QZ6nFZ0UmvPrbzU2gLmzooV3aGUFsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+tE2wYYDIhwzPhKy06wCtYrQVp+yQNqp4D9S+mIZXI=;
 b=n/673we06yZ+xbUU4jRsDVRYKTbZ6icb/hegxo8Zr4cF94jZtYKi85Y84rODHHDE3qh7jV/MowCSw5eHn5Su8wb+gx+Jwsv4x07TGmQMRbK51eHsJYXJKUI33BrEWTInK34ci/X80mHY13CsIKXdjS6QLZJVaO2MqXxEDrxjIM8=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4434.namprd10.prod.outlook.com
 (2603:10b6:303:9a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Mon, 16 Aug
 2021 09:26:24 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 09:26:24 +0000
Date:   Mon, 16 Aug 2021 12:26:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Solomon Ucko <solly.ucko@gmail.com>
Cc:     Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        security@kernel.org
Subject: [PATCH net] net: iosm: Prevent underflow in ipc_chnl_cfg_get()
Message-ID: <20210816092610.GA26746@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANtMP6qvcE+u61+HUyEFNu15kQ02a1P5_mGRSHuyeCxkf4pQbA@mail.gmail.com>
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0079.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::12) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (62.8.83.99) by ZR0P278CA0079.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17 via Frontend Transport; Mon, 16 Aug 2021 09:26:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d59f2c18-128a-408f-3ae8-08d96097eaba
X-MS-TrafficTypeDiagnostic: CO1PR10MB4434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4434AE56EF7241AA820EB0208EFD9@CO1PR10MB4434.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vA35WcQyKfJHbC2EqEMgiX7JVqOykKv56/T0iwJPjwn4GnkqhsA5uG9xhlbS2SSBVDt47oc/iBu2EeSslSw2yVEm0/kNKaTC1fLQXxE/KeuFZBNC/BPD1XGsL9bM5rTOI4CLT+1sTJPU2CU01v2XWDCocaf9Tc+AP8H6mB6MOgGqkFa6NEYHJwcVyge1nVtwwDwATOIhOUkixzvqKZYgHYRynbZD6rj/YNUziPWumvFOo/lzZWBZhlSgEQaL+Q1Hfa5v+Yf2HxHnZVOF2opLJ0tou62O+LPUNooBiUKg7gTKynzKP0/f94EgCodttDy0kVn402aES91TCbRdbgq9IoQyF0EQrszLoGveXlI/K0EErQ5vEIbTxUWOl1ViJ5zNlEJYjIzpKU3BRbjM0MpmVX9ouc9gTe/dYfU+CoeiU9EmVnzntZWwhQF4QSy4f4tpQkBsghk4/qpJgN5H4D8LMtyZzzaiY/m/ANJFCQYQn7eyLXHbWlj1aPFgUCn96LiO8wSvCM0bdVNBzJzOr5iTC1XQNOlqJ/L/PqEBiEn8+I/pZxIuuPr7z/4xFzu1XfiWwPtRt+JgPDWtySNDYn6eU1ZYLnl7HGz6foUQ5EqDvXdyEg8t+nV8AhvgBA0IyHxQWr/wCapGkv0Vbx/4LbS6DM3EqS0KO08iJNPcH1eOTylBLloCvPOVHAnrmiLlnvcU6w5Tu1V184tJw+cG28dmdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7416002)(5660300002)(1076003)(8676002)(8936002)(33716001)(44832011)(6496006)(956004)(2906002)(66476007)(52116002)(6666004)(508600001)(9576002)(9686003)(26005)(38350700002)(55016002)(186003)(4326008)(83380400001)(86362001)(33656002)(66556008)(110136005)(66946007)(54906003)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MiApIO0sRe47ZV1OJV9WUkX9MkHaYo1dkTh0vqyDFRPKJYBW+RmFmt9pM1+u?=
 =?us-ascii?Q?tzef54HVCngqNxrwA9uTqAYwUc5sIMKpTdvrG6KzHymkf7teTav+2ApYFplF?=
 =?us-ascii?Q?RTueT61UE0e/dL2bJllkT6RMYVHuxmMs4+ZYRdWY7WReql4JMIEiYDBmhF5s?=
 =?us-ascii?Q?/LoJ5FyNftsEu8Bx2lPhWdwvIqTgA4j34gyLZjl6hJE6Ha8/78v5Gr3bn29n?=
 =?us-ascii?Q?D+ZSgxms5UK72oLzkj2Q0ilHwlRP5H2qkZ82bSLBQBE/+aFzuVVLAbc28E2R?=
 =?us-ascii?Q?0NGRokDWSlFQqI50hlmyRuWiKtzXdEHtXriSGjW0cUIiyf3Wcr2/Wkp6Xb98?=
 =?us-ascii?Q?mmunR9RKIo8qRV3gxfCS6AaIdkQxvgLWECIObgKlpSjJ50B/sblMdgi7+iKy?=
 =?us-ascii?Q?5Ug6A67DlyGPMqqZRG14z94pdMH897u3DqXBHewvOwZ+NZlOQP1NTcnLon/7?=
 =?us-ascii?Q?kVeVKq1ZZxfHCg8VV4eyEWLuF8mOLC1mp1LzeHvPIIjQ+oCiZ5ZSxg4lGztp?=
 =?us-ascii?Q?evc18YnAPVhP/7h8soauv708irkS2Lg33PCX/QOgnVwYQnA2CmrMuqBMrf3n?=
 =?us-ascii?Q?9OVoib77KYo3dLZtXVUcST1w7OXjR/antnLA1b45ZgqiuDIBAsEGjV2APRk9?=
 =?us-ascii?Q?B/5JH9x9Y2HXDYJoMNJ19tdrR599A/TBasu6mqVE0ctHvjE4rP2Mn+Em2hdW?=
 =?us-ascii?Q?w1ebsRFMoeQkA0UI5Y502SjVnXiM0acBdFjDOA2MY1Z3KeapIYT69Ar+RqTs?=
 =?us-ascii?Q?iqBRvY8gCGbsaJz890HyFQF8Vpl16qOJM572B/CC1VPwzygE29uDjMhLsweS?=
 =?us-ascii?Q?qQ7X/VpXbsvUsliCxjOInKzdVUzsfvpCA3fgRlgG6sdtL7+VkeR3In6WLXCc?=
 =?us-ascii?Q?B1161+DU5rh6Uh4puwt23OpWVO3vt3DKe8tkUGWLLcDmX9vmAlZZ2QDypsbw?=
 =?us-ascii?Q?Ve5yMGTAgsgv/p8qwvi+tk77VHL+AAajvQYhPLIbp6NkjvpugYX8Kyxv1+qJ?=
 =?us-ascii?Q?Dsv4tZIUsVc6cs9p9Gk3DJE34PFmCerHOguAh7zX+rn+ANHYZD0rHP7TrrHV?=
 =?us-ascii?Q?ikm5HVRiTNUQyd5+moIdbvosmw4a4BZUoP2dfeMhUzHztgl1hEujMnsRJFz2?=
 =?us-ascii?Q?YMYSfSMfD+0+qqucERev2CM2tC1YDcX4q7UjbnfosQVHA8Fm+qWlgp4Fb5UQ?=
 =?us-ascii?Q?5q01bz7UNkx9fmdaYowxB9iDdKQlZKjdVnZpdJHSPNfyo8deoVhIskYX8ess?=
 =?us-ascii?Q?01reNsQqPGMAd/eFJCgVYwAMdfYynaM3w4WAtTsV07eFYg7nAB0xDFB+zckZ?=
 =?us-ascii?Q?Z318Hdon1eG+cA57eFhumlVs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d59f2c18-128a-408f-3ae8-08d96097eaba
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 09:26:24.5946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hawleJ/PgOgAyiNmpIcSX8nLFb49hicdfsQB46W37OdWc2I7tMSQHLlc76SOcRHo740kj4gTNOoyqU7cTalupFhfxaBt0uikM4D/Go5zyLU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4434
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10077 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108160058
X-Proofpoint-ORIG-GUID: EqBLACGIq-yseo0ta0_EPnoeXL1QN8C0
X-Proofpoint-GUID: EqBLACGIq-yseo0ta0_EPnoeXL1QN8C0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bounds check on "index" doesn't catch negative values.  Using
ARRAY_SIZE() directly is more readable and more robust because it prevents
negative values for "index".  Fortunately we only pass valid values to
ipc_chnl_cfg_get() so this patch does not affect runtime.


Reported-by: Solomon Ucko <solly.ucko@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I suspect this is bug report was based on static analysis.  I had a
Smatch check that used to print a warning, but then I modified it to
only complain when the index was user controlled.

 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c b/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
index 804e6c4f2c78..016c9c3aea8e 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
@@ -64,10 +64,9 @@ static struct ipc_chnl_cfg modem_cfg[] = {
 
 int ipc_chnl_cfg_get(struct ipc_chnl_cfg *chnl_cfg, int index)
 {
-	int array_size = ARRAY_SIZE(modem_cfg);
-
-	if (index >= array_size) {
-		pr_err("index: %d and array_size %d", index, array_size);
+	if (index >= ARRAY_SIZE(modem_cfg)) {
+		pr_err("index: %d and array_size %lu", index,
+		       ARRAY_SIZE(modem_cfg));
 		return -ECHRNG;
 	}
 
-- 
2.20.1

