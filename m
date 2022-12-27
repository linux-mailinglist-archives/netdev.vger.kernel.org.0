Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F956569A8
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 12:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiL0LDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 06:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbiL0LDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 06:03:38 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2079.outbound.protection.outlook.com [40.107.101.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A2CA1AE
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 03:03:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LpIh7hPbNvoWYzQxDELtMTAeHU80pG0EIIQmm1dzKtY3jduJi4OrUr1eAlQRoBMj8/5xpxyF/e/BtNzx5DD14pNJNz1J2TNIwbRESYSkl830mmbRpg4ZFkpNeFm5k9rlos82rLPF5KBKV+cOdltnn4WQlWFFVyW5wKkAx71UbjSMUlaeQxw0+IMzxMvcQdHkXtW6lEccMa1DiQTA9R6tgcYNc1aej1JoRPzyOZj7ZbZyw/l7fJHoZHo7EQLM2xEe2r5GPmdtaNg9g8Zu+pqQyQsHksSXjoqJjyUF5UasqDS57HqkkZAfpIdhTg10aTf/17ZM6EDKbliH2vvJOj2C6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UpGL97eOzNEErykGYEn0rur4DRXD4ocE9RNn3H+PMao=;
 b=AQyzWmexgTFtGKd7xgg1ixWbL1zy1u970kGKSEIx4hiF+VuaCcSb0OKfyIcOXj7H0452JaQCdj8ErYTiKNcLsLOB8M9T7OnWelLuqBMJTylNX6x0KP2np+UBuCw7lb7zpaBdcayYAbH2GxGJu2g8ssLLTnvGCzknq+w+5IDTqkl6g+SfcZZH+pcsKSOu9Pu5eYJkFEJ0/Ns0azcKHIk16JnKYZlhuf4WC2q8YO1hur2tcWAEtgp09E+tFeXTHkaAqAh61NyMGq50Kw4GEbPqopDfV/1/3F4PP9WwMaKe5xDlj+t8uFSqb2mlQanC+3v4NtYhkGPXbg4M1CAGS3z6VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpGL97eOzNEErykGYEn0rur4DRXD4ocE9RNn3H+PMao=;
 b=E0QqpAgP8bZkB8H2q9t95sHtrQLaivao+pNoE7nu77Gji1TAFkbb6K7unSoimYDZBiRStBF5AW7QJqipuW9eUC5eTqoag8jO/Xb3m0ym/a/JC7n1CY2cLmjPhAkXUWfejL86R1IRTEZTgApVSt6gjsXuNFtP15OUqT2HF3VD3TOlqzOxy5lB+MbGDi2EcRDL57FCX6+C8gmmeiKcg0d98nFUgqT0+PBhqZJp/q1qleX9Uwt04mBrGMusttCh3s8C9YbRs4f7O02RFfn03lOiaqYRNRakNZ2GbBIvBWmT/JGSItS8p6UXPcbcYriVRU+c6OGFL0teh2qgZvA6uRkwHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ2PR12MB8157.namprd12.prod.outlook.com (2603:10b6:a03:4fa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.15; Tue, 27 Dec
 2022 11:03:32 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5944.016; Tue, 27 Dec 2022
 11:03:31 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        chenjunxin1@huawei.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2] dcb: Do not leave ACKs in socket receive buffer
Date:   Tue, 27 Dec 2022 13:03:18 +0200
Message-Id: <20221227110318.2899056-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0601CA0008.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::18) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SJ2PR12MB8157:EE_
X-MS-Office365-Filtering-Correlation-Id: 5893c222-ca6a-4521-e8ed-08dae7f9fdbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l7kst+imO+F2dGzvnKdeJhwp3BwM4c2aG6CvC8ZzjP8trGaDzkh5kNjcwEAu49lhdOTXpirKNBgjM+JT16SAHvtAsWtOh5GWA68zlWFuYI+BY6WFx6oBtb/O0h0/r9/UD5YAJPtKhsMVlwdZ2L4SmPhy8iJ8CkUysppZkSxZe3WXhaIj+vAeb6x7miqtxyHsnGOt2MFCYI0ihhuczaqpQIjTry6BGm2ve7YfyxkI1sYLCGXK4xRgMsud6aekvfBtDUzgVKZVuFUbT1lEGUA2ZMjmHukhjXcy9vV720YvO+DcswToN2F/c8qa49LkCpRYZSXTzrtiNSpopeqdhI/rb9lz176r4/Z9M9Me6UWndjDAHuoq5uR3EJTqILx01q7CdgvfPMvkXQinZHoc7t0035a7oYkIcjCS2V6irUC5SYAjQaEOfJT7pjhZZgwD+MndYI4ZhZZxrpC7708QJNsp9OxsY7Mm3fjjlhyoMMof7uXZlzXc4BVQoQilVK10qo/UfpNg3mh3fG95suQZcyRHXe3Wiv+GHRZAjFmOPvExJNM2osxIPvA2uzbxZKHtwqLEm3wzsm4jluZMZfrJgKMOlD4a8JgNRawiKt64WK8i13vEgRtmJTZopVqqZYDsQIPsNeSpsj6FBnR1JAri+iGdtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199015)(2906002)(86362001)(6666004)(6506007)(316002)(26005)(6486002)(6916009)(186003)(107886003)(6512007)(478600001)(1076003)(2616005)(4326008)(8676002)(41300700001)(8936002)(5660300002)(66556008)(66476007)(38100700002)(66946007)(83380400001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u/5G9I3KSiQsFc0VtfmeeUr7omH7OKuYdt/BT+pkptOTIb0dZ+xbR+qfE0/x?=
 =?us-ascii?Q?JsuLl9VTcu14yfGqO0ZSHM6YXB9unlLkao5LwBFYPoTAR1xVqMru3f1helOO?=
 =?us-ascii?Q?Uuy0+pFfYOYWjq+SFIBNZaAAtVOVitFysETS+cLQzvjmOhAvKJAR0RGbjO40?=
 =?us-ascii?Q?X01G4uA/RJZzuyIDaOdavus7XmugDDO6/bmg9E6AD00I09GxCiAwr/3BqjuG?=
 =?us-ascii?Q?kVoch4lOlDUkzNh5HsDM0tflTR4JeI8V6u4FZs1AEU52gDs9DRf2Aq7DrVVI?=
 =?us-ascii?Q?Z3qeW3uOKcrqx3SXmHEwllaC2dDLNmecJU6YBs6BINCbrKEh7dicLogBIudk?=
 =?us-ascii?Q?hNbA/sQ791wIHdqHH7EjzPSjwrHSV6/3CECQTk6SYjB3RduRmj11ZB79OYLX?=
 =?us-ascii?Q?NhLtutRUr+QBPh8NvEp4oUZb8JzvQ0Y1RlsI85lCluOnFlZx53YF1d93gFP+?=
 =?us-ascii?Q?Q08TxxNVLsGC8sfQsKoYKy3dcRbXyRIB9MT3xKlTp+U0y8CcFrWsFLxamuGX?=
 =?us-ascii?Q?tFH34xT/as49wSUQUr+c1fe+wtFIOn9+rQBdTSOcYGMGGcMNFBzi2mjiy1Mb?=
 =?us-ascii?Q?42or6ckKEQeeOeLqpnFDk0kng+krCKDdTStDrGeK1aN9lW9bx6Wmc6/2yMyQ?=
 =?us-ascii?Q?wxXEP5lIBS20WOlfGlN6k9+klJrenfAsX9TZYvR2OZuDYkDoFa2tPQ9yfmVe?=
 =?us-ascii?Q?lhxBFB1+KwnVJyTUQEBl/6+V3JeDkq0lysxxQ0Xl0yvT5VA76VA1v0Lo8OeV?=
 =?us-ascii?Q?YMWtpllzed9cv9kQxeCRxz15glI9+jNYVSV0tymFeeXMIB7jretKEtx0IiCQ?=
 =?us-ascii?Q?4yrL9rJrI+NgYK6vpX+jxSFhkoVkEaUwzfyIE2e3ml4d0dWByAncFuP219Ey?=
 =?us-ascii?Q?51o25TLm/+9p61RXhiRfeTWMe9+vNA2HyxMBJIbDA+/fwFvyXrYQKtQX0V8F?=
 =?us-ascii?Q?lKWdrSenJvpt0l5vV3qJ6tOZw96Z5piO/W9fHoc4ehCODxjVZtcJkd5NqwiH?=
 =?us-ascii?Q?yWPEIMe8bPc4Ox36CwXKyBFOkfLalfJIZ6wc3dGwJuT63QhSg5LtEsHiW/5U?=
 =?us-ascii?Q?t71ez47IpgOQc2gwg0Y0BzFAxZy/MT5806fZ5d6ffRLJ25jhjs3ieqpn1Zwv?=
 =?us-ascii?Q?lA6/3cDfSstkuj1JZzjpk2RCgw6v99eMTavYbiUw22SzdrYRr3sHbrKyuxEd?=
 =?us-ascii?Q?m/A608VTKUMFg58K7v8mA4MdIpnIG60g4gV5K706OPlM4Zkm8f/l0ViRY0SV?=
 =?us-ascii?Q?MfPShE8kTH0HPm60teqDuiGy2t30tda31qeuhBs7kfmKavngE0VymlwvtL7d?=
 =?us-ascii?Q?zkhTJTWT4hlS5CXpN6WmRUpQebgOUOwUg8ITm6ceIlmIh7TZX4ZbcVgqE/g0?=
 =?us-ascii?Q?n0TzcpIt+M1uYC9VkCBnK6OSFoDx01kXBVjTWVIslWhQlyslgatNCHJK+0kj?=
 =?us-ascii?Q?UIuxRc0ukX7NIg715IEv8JCiFLR03RCIX97JqJI0mCulbK2WjUCL3qeXxNCk?=
 =?us-ascii?Q?Su79EUvZyk6v3HCGiPrQaNf8RpQx5/PzYJc+nCO7S6zIUJsiul45p5HtkdbR?=
 =?us-ascii?Q?UPUhjn6KAwcIChlAX5GZxN9w6WNiTSpAoL3DRKOI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5893c222-ca6a-4521-e8ed-08dae7f9fdbf
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2022 11:03:31.7525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z/zuL378ICFGpNktegqfkhQObUiNHzawxQsNVWzcX8yrJN9tGN//vVBlJJUwS87yWB9hbLbUP2Ersoi1tNBZ/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8157
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Originally, the dcb utility only stopped receiving messages from a
socket when it found the attribute it was looking for. Cited commit
changed that, so that the utility will also stop when seeing an ACK
(NLMSG_ERROR message), by setting the NLM_F_ACK flag on requests.

This is problematic because it means a successful request will leave an
ACK in the socket receive buffer, causing the next request to bail
before reading its response.

Fix that by not stopping when finding the required attribute in a
response. Instead, stop on the subsequent ACK.

Fixes: 84c036972659 ("dcb: unblock mnl_socket_recvfrom if not message received")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 dcb/dcb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/dcb/dcb.c b/dcb/dcb.c
index 3ffa91d64d0d..9b996abac529 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -72,7 +72,7 @@ static int dcb_get_attribute_attr_ieee_cb(const struct nlattr *attr, void *data)
 
 	ga->payload = mnl_attr_get_payload(attr);
 	ga->payload_len = mnl_attr_get_payload_len(attr);
-	return MNL_CB_STOP;
+	return MNL_CB_OK;
 }
 
 static int dcb_get_attribute_attr_cb(const struct nlattr *attr, void *data)
@@ -126,7 +126,7 @@ static int dcb_set_attribute_attr_cb(const struct nlattr *attr, void *data)
 		return MNL_CB_ERROR;
 	}
 
-	return MNL_CB_STOP;
+	return MNL_CB_OK;
 }
 
 static int dcb_set_attribute_cb(const struct nlmsghdr *nlh, void *data)
-- 
2.37.3

