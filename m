Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3FA68BFF7
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbjBFOXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjBFOXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:23:30 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2046.outbound.protection.outlook.com [40.107.96.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889A318B
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 06:23:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nk7Ctyv4r4E7P3x9MfXTrwe4a34w5eT3p7NKgs3EssS+4uurZotreWvpLFDbqGeKm4QNSbo+MlKLkeaLradh+/4iQ+C90lXnQfcdpvFqtIroNsoAT1gPkt3WUVS9IXJ+EPiAyt8IqpegCH67KPPKC+hZyMnRaP8P2Lsvz2dC46iBpMw1DiVL29AbdfmEd1DD5BQyAmVU0quX+EOrmEUQGFUtU75PSbsMuQH8ek3/UgLDzOZCtoYAugZEstf70m4ZPtzPW/Wjw2Y+DgTi7g+xT/5Uw/aO8wH/VY10D3DIB+dZ0S7cRUbecL9QPw2hG4295wvJv9ZOQrAjtnC6d5DzZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qr83wMHsuyl33OuCS+KGcG70y2VnQBwdTSwCZTiXEnY=;
 b=DTw/H1TEfuKu50EMK2SVlokndhKPpwoKWExhAcoBPvYJVKlN5si2yu2hp9CuEkk8S0eGUVx1PGzjH/OEHiN/MIK2Ukdzw4zNwIG0sTRxntcu91YPkcmW1Ms6pNrWU6zDLJG7ve8QbHY6J+Qz+KwmcRbWxeuKXhLiCrbRaRo5wFPBdgpPs7/ysn3mT0QSIEwC0IN83TyqFUj9Y50H/2p23s8DwyvpN4wYXl86ddBCmdiUMmJh0IcFhyETn0mivDZss2wId/If2v6+WLCtFcV6RxYM92bPAQ+e6XGF9+jyk0UX2SxGGrnJt7JsIFbK0D5PsiciHYe5FlKjoOfZe5P6Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qr83wMHsuyl33OuCS+KGcG70y2VnQBwdTSwCZTiXEnY=;
 b=Q2alfId4QeIr+ySNRXQhWl9Dv7ghodnxVsaF+599gRFsfoNn8eIAfBtNXGikH/D8Y3u6gxbhVZiP4y4l/WfUsNOj2PMoMQJDcBMYmRCl8Uky4EM2aIWKXBWZ/tSrmvrFP61f0kissd1X/rEq2TVLTS9wD0YWzJ+I+3/ZMRIAjmdnEadaCcdKZS3JytKGlQJVtqJ2x7IIZ91SG/hRoHKk+LlsBK+viHZyc56bN0ClyCFEaSQxtxcwNMY2oHLhGv0q73D+mWGTTPLKSR3fgXH2mWCC4czITrsqeUhTnNofU5fHR5vuGCm7yj6jGlA3KT2YRqmhegNPtC/T0kA68fzE7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH0PR12MB8532.namprd12.prod.outlook.com (2603:10b6:610:191::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 14:23:27 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6064.025; Mon, 6 Feb 2023
 14:23:27 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next] bridge: mdb: Remove double space in MDB dump
Date:   Mon,  6 Feb 2023 16:21:52 +0200
Message-Id: <20230206142152.4183995-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0210.eurprd06.prod.outlook.com
 (2603:10a6:802:2c::31) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CH0PR12MB8532:EE_
X-MS-Office365-Filtering-Correlation-Id: dcff5da7-689e-4623-a583-08db084db6b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /7hlzDMWpyHhsCxZ4rVSFqsr+Kzad7RBca3pASQpyQcafnqUvitnXGWO+L8/QLaAn78mWT8YP1KYV5kt9H9uFE40H/pb3TlO7NEjzqOhgMw7c6HFQD+XC1KVeg8p4dDXGMJ6vC9Q2rSsq+dtq141pCz5kXOZ7ehacXrPQcShfChiO0yNG7I7DkGH/P589xeR3nCwl1uFvlvcT9LAHsJPyO10IBVINlseKLMBHYVZJ2rfbdm1WUYpBZFFVc0+8fPs7EZfJjpW1f7guD9/a9z8gpxW6ff179i8U7GPAELPTT3gQJSLLqU6Zs3M/oEwY03AfPJd2W0zNaUl+QbD0dq4Htg9nPO+NsGzbnzMnwmTKsFJPAc8lhvnZXxhNgrkpE31AdrYbYMKwEUf2bP9ZvEcy0USdadEehfE7CCjrfd3gShr9ERHgjcmoGqRUSWZuRL7445wI8CQmdfGFllnI3KFV1etrVXI6+MeoAsdteVFKVtbinvUekUQJfkJbqg2bCPiBmJi/EewuPUB3dVkOPN1MczX4duL7EHc6cSTp4ceoTiZM4BrBH0sepDjRTku1vDneowobXaGeL3wR/VKMi2CJz8uu/NcQSAXBGcRDqeVuDCKTu+Kz7Ju9vePgUUHZhFDUsPusEV6oPcwKwcqRtCdGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(451199018)(36756003)(6506007)(6512007)(1076003)(6486002)(26005)(186003)(107886003)(478600001)(6666004)(2906002)(41300700001)(4744005)(5660300002)(8936002)(316002)(4326008)(6916009)(8676002)(38100700002)(66946007)(66476007)(66556008)(86362001)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AXKuaSyG4o8scPD0EkZHQolMeo1yHzw0spHw+GpNmypXFCA1+wGP8MpH3BQT?=
 =?us-ascii?Q?+euqSsRT1GElQm9kko7w6kMJD5lX5MNkYUy01LuZlE2rHQBKfIl+mnktwfTF?=
 =?us-ascii?Q?H2TjPkwN2IuG9GxFxuXL/BEqdE37MxF02DMAsHP1O7vGJ3feNFHv54aAZCRm?=
 =?us-ascii?Q?yXhBafYjVACYMWPMX+C149bPITlxfHsdq58CTA3AkkWf0oeKuiEjrvwOiQb9?=
 =?us-ascii?Q?DFVbvYhx71uvenzqq07Zz+9zc3HNrv3uffyraahtV4SituTBAt08KOla2zxq?=
 =?us-ascii?Q?3jo7wU6z1VH5GMZ/bnjoSmHaaEvM0OegCH49H6Jz7B3yA4bhm57t06nfT03d?=
 =?us-ascii?Q?9Hjp8wg6FM69837JVlxOdf9hiXAX0MZ3/5e7Q9mefbpaclpvKsJf1QgWgOSs?=
 =?us-ascii?Q?bIoYwAWX05AD++W2idNehD+HAdN4cG5hh3UldhdryH/Rj6V8iF3Yjf/CDOjE?=
 =?us-ascii?Q?LoDtaQALZvcd5n1jesBHmGYIEask9yZmbDZIAMQ9yGy5NFMt5w0Ilzbt6NET?=
 =?us-ascii?Q?UoTlBD12YtqUfPfZkfqs1WzvoDuFp1PnAQ3JeraVzOi4UetqK30vv7t0Gkmu?=
 =?us-ascii?Q?nNXOekPKSDbQDgLHr0XMfC3zpAgNqx6Wm2AxxBEwqaRKeGG8v8556Q6M0Jws?=
 =?us-ascii?Q?mpORbMOspgEkE2w+4kP6P590DPuPYb2lbg1sotXfxSHAAtFJILE5tmluN/vf?=
 =?us-ascii?Q?vZPk2RAiHFcZtO6U+PG7oLm2gbAO9Z73eFd7gPCNBkDdpEyzBajL7M7M28PY?=
 =?us-ascii?Q?xM3FMTVz2ZcjhGmvh/KFmqpgtgXd1cf2eZIfLYk2yyjdPPmhul/UX25KXAV4?=
 =?us-ascii?Q?eC9AbxYU3Twsq9qXLD84cSOftlgjVg5hRoA3HAklTePP8v/1gCnK7yaFrMPe?=
 =?us-ascii?Q?FwYab2H0G76DyTAKKpAPMzbKj1K+DQZGAIH0DEjbqM4ixUJNIlz2byqRnR2X?=
 =?us-ascii?Q?ly+NGcBMVktjSbmdX/W5oT8iOfz2oEHBfKpVrq3xbtskzTUKkX9bqNt2en/j?=
 =?us-ascii?Q?j/ntGudRSF63hGnhAe/HdwGs5IsJlsBgT+WUNcNgTmhfKVGtVwVenMIz2xyf?=
 =?us-ascii?Q?FfTMQaU4xdpVTZxGTNJehm4d7lHJOju88m+sZNmNZdcw1t93E1Vl0eIubhA+?=
 =?us-ascii?Q?G4IEODf80k3i+1dXVT9u6DGiP0wdWHPE2Uf2BCR0xgKDOmg6lZiN7VnKzPEI?=
 =?us-ascii?Q?Hvlsj8z3sWRdVG6BrrDsU8ul2lIds70PvnZiCWCbZRmDQwOOu1lKz8GMmVRj?=
 =?us-ascii?Q?EEUIZ+vRN8/EFDzxWyJRYjxvR6XyDSUg7fH43XusqgOdP4+wDBZ/CQQ//vTl?=
 =?us-ascii?Q?+BB+WhtOMCZtM1IxK4idHk5m3FBPlTc4YsHI9Rc4DEX+TP7Knvmqs17gt0Tp?=
 =?us-ascii?Q?nXHBqniglfjDAsYrUsE1fYwlYpPbtUrxNQnKDJRek8IZdvmoPDU0U4LsaJQS?=
 =?us-ascii?Q?+qb1Gg0FMVf1s/08jfWBq/9rrCTFhH0gNsd3xaKr9Hb+TAlVQgpmRdpt2Pv9?=
 =?us-ascii?Q?5gd4G3Z9HGfJxBtfsdjAD6ex5w0PJEzqVHhO9dfCRm5Te+JnMA0mgpMciBsn?=
 =?us-ascii?Q?kOKDDuFNuzQJ5YlLucYWrtcAtWfkK9Qhqv0PhLSK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcff5da7-689e-4623-a583-08db084db6b0
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 14:23:27.4840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e6C19xTJP90QNyOe7lbWybnymesNEua71ilZUFbf/H1xpZz1yKaR48n5uErwa1CUw7gGb8KfIM2p5bFKXBRBxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8532
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is an extra space after the "proto" field. Remove it.

Before:

 # bridge -d mdb
 dev br0 port swp1 grp 239.1.1.1 permanent proto static  vid 1

After:

 # bridge -d mdb
 dev br0 port swp1 grp 239.1.1.1 permanent proto static vid 1

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 bridge/mdb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index f323cd091fcc..9b5503657178 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -221,7 +221,7 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 			__u8 rtprot = rta_getattr_u8(tb[MDBA_MDB_EATTR_RTPROT]);
 			SPRINT_BUF(rtb);
 
-			print_string(PRINT_ANY, "protocol", " proto %s ",
+			print_string(PRINT_ANY, "protocol", " proto %s",
 				     rtnl_rtprot_n2a(rtprot, rtb, sizeof(rtb)));
 		}
 	}
-- 
2.37.3

