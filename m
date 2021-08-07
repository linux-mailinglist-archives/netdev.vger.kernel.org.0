Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183DD3E361D
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 17:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhHGPji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 11:39:38 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:32340 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232616AbhHGPje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 11:39:34 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 177Fcj9Y024262;
        Sat, 7 Aug 2021 15:38:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=JT5xvYK1bFGSNdo3VPNL2yHYcsW/sCgeiXnZJQwoqaU=;
 b=ZdBXxMMv3DKX+i6KBr+/DR7z0rLcxT4u1mZq8lPaexu3KgZBCPxS0lfZmmaT2BAZQECB
 a40fgxrr7EkilUuA7Dm1dqcLv1y7wA5BkQayhmder2WDVkocOpQ/+Tr5Cz1ijfDFaRi9
 siFrzW/SFlofO8xLFABa+7CqZ7k/cV7JLVZHndW5rF6xdVbh9bhIOoD5Kzdf6SuCbK65
 7gYbrvI7Cxc+M4baZm8+c3W2+BQ9OmYkF7iD427p1o2PHsc6grtKc2IcLBNAKp5Ihchv
 gUIKl9YOWU2GJIMsgBWFyyOpb9PPFQI9u7dFgudqKQWL+HIpOL1ptFztb7X8SfBtxMVX zQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a9fd2rbjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 Aug 2021 15:38:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRFnZo8U1rHoSAzuGVT8lSEqqO8UknbpaAHzyGv0ELPse9QQ30Rv0zuoSpplFWzgl7dNyf3KaCgVxurU5MPkSA/Kp2QaOajxHY0mdNlVKKZ9qxL94jso+mu/1cvcoFgcKNRdLDqCOdG61Tv3jhFHNgX1ZG7KCFjqynYo9rDf9kYUBmDEL7T+dM8IgVbVhIpc8f3f28LZ9+VQBqjqKDP0JKSSkR/MpADikF/wwUrYlKXsuF2r98moximprai7FIxSTFtK2WnYBJ1ZOBy4nK5FlbSfcQppk5KsJIcUXsIIxh4ZWdL2pLPS37FEQ+FZi2L98IWjlarZCAOT2mID6c1KOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JT5xvYK1bFGSNdo3VPNL2yHYcsW/sCgeiXnZJQwoqaU=;
 b=PjYzf+GnW6ctVfBgVpgJcRdJN789dQuaQX0lr1CDkuGKgIXEE/3zdnOKyNJBHAKtSaYGfRJKA5DrQ5Y+sKszT35gkT568bZHF/gtUnBcfdPVXkoAyEiRtP6BrQcGRZmSTZ+hPheczaeH/HdEmEjiJ0CZUhKbufBazM7SzocH2iyCobfxv3V7hiqSO6LXdke3xW/KmJ+Enz0Ew8Le68r48UdRZJaMsV6WChJpjAgz3hD1w222fWd/puJmz3X3W2W5bxfQSaEMwV07xuJXdRPvw+644QkhDwbzmbqyVo/goVib33YfMb4NthlX2rXXD3dwRw15oQBuQY026PqtoMaFMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=windriver.com;
Received: from DM6PR11MB2587.namprd11.prod.outlook.com (2603:10b6:5:c3::16) by
 DM6PR11MB3564.namprd11.prod.outlook.com (2603:10b6:5:137::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4394.15; Sat, 7 Aug 2021 15:38:43 +0000
Received: from DM6PR11MB2587.namprd11.prod.outlook.com
 ([fe80::8ccc:636b:dcea:7a5d]) by DM6PR11MB2587.namprd11.prod.outlook.com
 ([fe80::8ccc:636b:dcea:7a5d%5]) with mapi id 15.20.4394.019; Sat, 7 Aug 2021
 15:38:43 +0000
From:   Jun Miao <jun.miao@windriver.com>
To:     3chas3@gmail.com
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jun.miao@windriver.com
Subject: [V2][PATCH] atm: horizon: Fix spelling mistakes in TX comment
Date:   Sat,  7 Aug 2021 23:38:30 +0800
Message-Id: <20210807153830.1293760-1-jun.miao@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0187.apcprd02.prod.outlook.com
 (2603:1096:201:21::23) To DM6PR11MB2587.namprd11.prod.outlook.com
 (2603:10b6:5:c3::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-lpggp7.wrs.com (60.247.85.82) by HK2PR02CA0187.apcprd02.prod.outlook.com (2603:1096:201:21::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Sat, 7 Aug 2021 15:38:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00335eaf-418f-4717-5bd6-08d959b96fd3
X-MS-TrafficTypeDiagnostic: DM6PR11MB3564:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR11MB3564D40668498A1CC53BE5708EF49@DM6PR11MB3564.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GWdBCveGTbV3Za9sd5k6gIR0c86rcxqcXk55x++087lOuBtfdVATyvCLwX3+d0bCfyiVtFR3ghFEaoAWiw1bkf6fJdop8yMfOoZNPrgfHt5k9AswFDWuCDTObr//d+GERxbaQkWBrq+ZM6f2b8bV8cR3ZZsZDi4UFyzXalp+XP0TvBEE1rPspNgS65yIDJNIYgSog8dzeMBwhsWpZcw1UjUQHHaUUVoJ8CTIbpXYPezrg+Xmv713AGWkAulge5aSm6Tr67C5yCQOIWGlT4giht/QTSjZeUIMWfMfUGkPhO7LFflXmxN8wYFKZcidjE0pXc0kP0HQWzuvaVpSz4iO/Fhlt2JbvCGfy/OWBUAJJThwcrjtGdGFQKXCRpw3rmbL6rDhRCJyhqFamlcZ1J/d+J9pePYMAeJAREBaoWb3isXRSTebp+PST8uElQTSARGWWJG6YY+yhbtZZZN/CJdenMODyFSk2PbhneV/IEZNnA36Bn8vjg0Q3jATxPy1hESGQax/aBDHvgUUSFzDyHQ/JJAeFjnGGIESglXJlb/cG6yJKJmJ6PW/IPKHbnzDCCuw+PfzpNKVIQjdRde/PhKhmVWEZY9YYqCTxAzRc+iYMWB6uLe6AhbjlBcBMqYaX14+u2y3Z71BZgfxB76xeq5okoPtccIm55yYLCGTrljKxSOdOEB7ABWNaSFzNupsrBwsUh4J11NC/dBbeWD6XnbSV8XeVPn97TEsKj3AcIrdazw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39840400004)(396003)(346002)(366004)(52116002)(956004)(2616005)(8676002)(478600001)(86362001)(6506007)(44832011)(2906002)(316002)(6916009)(5660300002)(1076003)(6512007)(38100700002)(66946007)(66476007)(36756003)(66556008)(107886003)(186003)(8936002)(83380400001)(38350700002)(26005)(6666004)(4326008)(6486002)(169013001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SqzA7fcaSwerm37nXrJwvZhGVMZTwOJEC+SgTocM2YSyHUzgH46Xkvo9YI2m?=
 =?us-ascii?Q?Hypd62nRisHydh9Zu2eiZhP/+4o8cnYntn5chbhww/wz+WcC3jCcz4+wI0pk?=
 =?us-ascii?Q?r4qGpsCbFNRWcUwdRyLl/BL/OkoIyrqlu6FxkY/WrYae1F70GyXrGE6SPMmw?=
 =?us-ascii?Q?18qkxlOeGfkASMAHdcMkcaicqq1NQdmGJqRqmDHl/LbiZWkG9xUL+kAthehc?=
 =?us-ascii?Q?7WnX0rjOJnPnm0LjBh5Pay5mNTF+EXGulG3Ua2/TfB9WNXUVLdb73p/brsfj?=
 =?us-ascii?Q?ule8n37klLmoZEMvuVFnf2KVX24KzDqHvtDsVCPe5pYE+v8T7fLzgiBNTIvh?=
 =?us-ascii?Q?YCgeaSghSSMqoSl+OlLBUDBuaUlcpq70ge437zdgt8lazh3vQ/5nxIDZqsOy?=
 =?us-ascii?Q?QBksQBcLff4gNcSkCt3c/mMAEthb266G2A8/LJFbyWGUXcfMSW/aUVdVq4Wo?=
 =?us-ascii?Q?AyX2UtDU1dkha/yN+i5OUQwU3paPys8LBAy4JcEl9qMx6iJDCxGgCmlG1lL0?=
 =?us-ascii?Q?XmYaoq5P/1hKMn/u0WriUeG31PpKLeUebV1v1xpXCJ73BZSCogyK5mjL+vby?=
 =?us-ascii?Q?nX+S1m+yv062CMGPojhkSDI1uLGavAQSOLzsanA2Hdc/0+gLEvNnndByZDt2?=
 =?us-ascii?Q?ZSFK8g6/WaGNV79DF8UkVTuf+wqIhpTbtArImrNS3Ou4NMPVFV7WiajWg+is?=
 =?us-ascii?Q?ankS82kUKEqHve2uDIyDtrU9kHmX2TeRteovBxCNDm+PqOv+kOhXk9gXRe6X?=
 =?us-ascii?Q?y8cD1H5UYsIMXrK+WUkMsZoEFbXHrobsK/w9vApXQ/9+LY1mBnSuCrv3CDEy?=
 =?us-ascii?Q?tmBrZptkc4hXoUKuyv/QwU3zAw5UAb7KLukmUATymcH+FIuhlxhy9cXGMlnr?=
 =?us-ascii?Q?WvoF2xKH9OAi2fCl/Hfj5pk/2W5PMw7MGrrhY0bYqI6d3lBDVxvm9ZYfEXtF?=
 =?us-ascii?Q?dalwL79YO9J2jLiM0hmBcoVi9kLg1nm3G7A49Rficcr4EsjMY+taxbAUNHit?=
 =?us-ascii?Q?SpI6f+n5DdfAKj4ygZrc+TX+mrCUWbzGIvYTbEykoylC9aoGnasygxKdc/h/?=
 =?us-ascii?Q?pjXNAhVWgwd0NaoW6uhulY0LGgMAgfIK3ZPGdThN/nQtfWTRtn5T+h/5TS9g?=
 =?us-ascii?Q?WTfo0L6aPysX0Ftwb5U22z/PhoeqLYBEO45KwWB6q3wxW7RWFTYRO1Dd20nq?=
 =?us-ascii?Q?N7sQW1MgRVNYx7HkY2auqBpD8fem6n8YKXjzc1E7fs78XwpYCTni1R27N5rc?=
 =?us-ascii?Q?ldLLVjaZotNNFL7APZr7BuLR+e1A2LGa5y83Y7uY2+LbDpECr+sw+Ln+jFvh?=
 =?us-ascii?Q?OS+w4ax7cyaDterafpa4GCyq?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00335eaf-418f-4717-5bd6-08d959b96fd3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2021 15:38:43.3677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UJqcIIDE5hy5ymBglH//co2CdXONvMNcjdWq/fnecYTXl/dXhmxnmiDrsElC0AoHM9/p63tHuMukTyY/se/l9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3564
X-Proofpoint-GUID: t2Ax5YNqAgOxousH4NSGjWaIwV58h2O3
X-Proofpoint-ORIG-GUID: t2Ax5YNqAgOxousH4NSGjWaIwV58h2O3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-07_05,2021-08-06_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 clxscore=1015 suspectscore=0 mlxlogscore=558 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108070112
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's "must not", not "musn't", meaning "shall not".
Let's fix that.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Jun Miao <jun.miao@windriver.com>
---
 drivers/atm/horizon.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
index 4f2951cbe69c..9ee494bc5c51 100644
--- a/drivers/atm/horizon.c
+++ b/drivers/atm/horizon.c
@@ -2167,10 +2167,10 @@ static int hrz_open (struct atm_vcc *atm_vcc)
   
   // Part of the job is done by atm_pcr_goal which gives us a PCR
   // specification which says: EITHER grab the maximum available PCR
-  // (and perhaps a lower bound which we musn't pass), OR grab this
+  // (and perhaps a lower bound which we mustn't pass), OR grab this
   // amount, rounding down if you have to (and perhaps a lower bound
-  // which we musn't pass) OR grab this amount, rounding up if you
-  // have to (and perhaps an upper bound which we musn't pass). If any
+  // which we mustn't pass) OR grab this amount, rounding up if you
+  // have to (and perhaps an upper bound which we mustn't pass). If any
   // bounds ARE passed we fail. Note that rounding is only rounding to
   // match device limitations, we do not round down to satisfy
   // bandwidth availability even if this would not violate any given
-- 
2.32.0

