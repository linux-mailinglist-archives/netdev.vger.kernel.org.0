Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFEAB506F43
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 15:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352892AbiDSNzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 09:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344219AbiDSNzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 09:55:24 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6902CFC8
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 06:52:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YRshp4YkfHTxTWXH5Yu03hyE3IHbcLdHOwSR8CaQ24H9dewHZrdO3onLrMlwrOtrrZX27rAt2dplYcZX8IJVIoslgPqLk0JMUYzTZE7Ai3oOFwsxePbL2zt2ZKHuyyMD30hYv9YSnZmWaGKESU7OSkVxr/Wmh0kNF/vHuYvveVHqJw4r+F/q/FwYLIH3WPKDhDKp02KG4oGW7EOjZoiknSDDeatF8ZCw6D0tRTtDHcDL738JRgH6H77/NwE4rtVJkxT8zdrvpd5Uw5Jgpgykbv+KUEZ5iS2FoVOXbcwc1QA3fMjQoRTVXlQIucGQ2c/vntD6OTQ0ibeSTft4f+RlLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a25rX18pZuPkYRgSq78jPSTljXRW54ESLbootUDSFH4=;
 b=Qw4xig7Pxd82t5giNnKv1IJrQmmkFai/Y713VALW5z5F8BGcQZwpS0PAzBHfgzZQXF6cZDphog1VbFgxHs6UJ/DcIm0+TOG8EWPqmPr56aF5dNliAwSxT55Gy981Y3Q/ccE0lwkCvTKxKoGk2iZUt8/fsWj3DhwNodFF5TD5kD5frVxR/kxVk0JRtleC5Fd+qQdmW37dVXkUV8C9CvxK2kaQo76HIJmhLvLyszmPSGYbV4LXaTWwSYamD6kuAOQPJ4lnZM8rvuGSnYQmM5CTroFqUyrF8EElsX8DaBDIrwSHNOxtpQIge8e2l8OO14qn1AVkI/5XOj8na+YauL+PTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a25rX18pZuPkYRgSq78jPSTljXRW54ESLbootUDSFH4=;
 b=qStX+WJ1E+DmK5x+IC/aC8FsP+6KnTY/aW4Nehe1Tws1hROscqah5ahdlnUBI9gXn1/MtXl3dHo7LnlVtkJsi34IRAe7uCR38DyluWjRZ+JMwpGhdkeY1URLQ9882qwkadkcqEM8+OfWxTr0KvFWEaPqF+hTMCuywUsEs7dd4jNxxDDsJtCOAJErSPCBjW3DSG7XhPLCAch+kPYDIdaBQjRlN3a2BYVrwz6URRikhkmZ8OYcqNvZ0SWRMzOwWJpPOy77EvXlsUa5A0BRe4dK1Gy0jUH/M/CrZyYtdBwt441kut7URmVHqCBslELELbEFAW+024QaHqPL1WRaF+H+qA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4347.namprd12.prod.outlook.com (2603:10b6:303:2e::10)
 by DM5PR12MB1850.namprd12.prod.outlook.com (2603:10b6:3:108::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 13:52:37 +0000
Received: from MW3PR12MB4347.namprd12.prod.outlook.com
 ([fe80::9196:55b8:5355:f64d]) by MW3PR12MB4347.namprd12.prod.outlook.com
 ([fe80::9196:55b8:5355:f64d%2]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 13:52:37 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 1/2] selftests: mlxsw: vxlan_flooding: Prevent flooding of unwanted packets
Date:   Tue, 19 Apr 2022 16:51:54 +0300
Message-Id: <20220419135155.2987141-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220419135155.2987141-1-idosch@nvidia.com>
References: <20220419135155.2987141-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0076.eurprd02.prod.outlook.com
 (2603:10a6:802:14::47) To MW3PR12MB4347.namprd12.prod.outlook.com
 (2603:10b6:303:2e::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b804255-34c1-4909-482a-08da220bdd2a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1850:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB185093938D49E05416C6B3F0B2F29@DM5PR12MB1850.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tI21mow4huOhwMO3TXHsQLEG6/P8MU5rda8vfKt52pePDEDjrAkAHAzQC+sCGTMAdeAZ7vd/vf5bfymjV1tBXYNzZU41aAox63almahZRzM9mhX73Yp9LxWLPi3WZW3wF6UAPbWGWMu+BJ9ld78laIgUVDxHDk+q1XEJZkmso1SR3lr5fDBD675lRrRJnwo7jXLJETA2HugAotHtehfoD7BeH8hKA/FY/EDvbXNCxj7rS1Xy0QVCIt4STlRH0foTZfJ19bGq45w7oVimX77p8TdDnxApYknsT5Ds7ueLf6GQRBzSMOjH/RLBQYDiNTev15GKdpchSIawhlXND/OAyVOKz8JzecLBuwuIR+TCtG2fuwSikKibDSym5zLM+st9YhtbUrljXffx8U1CIx2IlPmbBzVT+E4c7HgkIcU3AiDKfAHriyZ+Ip3C+wb07ZiNrUkCxfeOh9OKG0LK8k47EGRxQBO65k7gz5zWVtBk9ewFsAXNGW1pEKgXpsSrwwb5n7VtbwyHc5+SyewLv5Jtn4WyTuN/7Nt4gZPFlIrSIPqLepTqkemkKd1zcTHv+SuWVuZL34hYbjoWNsRAU0XnLF1iRkSgvM1qM/n+hg/t87AfsUgyojzv3ISf1g4TQjITDRaBA49Zs7vSs1WhIru/cf0r/4iv403CiltWUspicalyPqdxa/Br1uQAGa6627SjNoUX8FOijYQV7+ETA7pQZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4347.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(2906002)(508600001)(86362001)(6666004)(5660300002)(316002)(36756003)(6512007)(1076003)(6916009)(66946007)(8936002)(107886003)(66476007)(66556008)(6486002)(38100700002)(186003)(26005)(4326008)(8676002)(2616005)(26123001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q4xowP0hp/sOC96rC/EPkXt3zLOYhZGGYX1YwHQ3PXQoE97TdmD3Tp3xQHFX?=
 =?us-ascii?Q?cXXBU87GF0J6vQC9ZpKIEeSD0V9LisZ3W2nsXk/kbQny3anqj7y8oUOX+q1R?=
 =?us-ascii?Q?nWYqlNyB7qrBm3iO/5eFSUV517GRJB2YsM1cO55pbRloIvpWqQ7AfsLyHY9k?=
 =?us-ascii?Q?Ys8zHsYtClcgqGjkyhxPmM5i/36xM3Re2Buwl83/WEk8WfP4BJkgUkedAvVN?=
 =?us-ascii?Q?6Kn0qKDl1K6Oj8DG2kMZmzVKVQBHVnpVwoOuaXgoRSkm1PqdwrYobCqI7hyb?=
 =?us-ascii?Q?nAL89Tk9b/jn2y6GHMmdbvVnuGpdBfbP2o097y3nzXGw1tyg48FhbkQ1cjhh?=
 =?us-ascii?Q?sepHf6slmnBZrR3yjLdQumCwnegYeRuRU/7+89UGQtAsKyCosdYvbjV0wBAI?=
 =?us-ascii?Q?UpoQm4qBepxm9+hlybxoWaU00tqkNrGA069JFoDjNaH1RNLk/ry7UFOROEMw?=
 =?us-ascii?Q?fda30e28jcvNFeYhDFiM6ZWyNWE6grSXkfg2VKtq7lC3RWg5615h98ru4UYO?=
 =?us-ascii?Q?xcWOUFVFduxfdpTlrcr6c4q40izUYdUYFmOwpsDiH5Fsdc9twF4jCVigiP1m?=
 =?us-ascii?Q?OwDYArLO10NijM4Snd9znMWkIPMtXCRQTqIWJ/fDVa9dfgq4hKDxKbdfaTus?=
 =?us-ascii?Q?205oUTe6ZSJB1U9Kk2g3D1rG81bmE85C9kgngA3TOQDevUfRaFuFyRrF0fP9?=
 =?us-ascii?Q?iIdtf6unUS9HGlmhwzh6UDogUYsvaSJud1KHYeTO7Q3pP/oLLcohZpTf9+AS?=
 =?us-ascii?Q?kd5nScVzJ3a0tLqy+VpwgJadEDeKd/h8mCj6SaEB5VKoPrgI1JyRhq1uzyk8?=
 =?us-ascii?Q?ZudcgpE2lmuKGffpqBJq88dVt6T7FWJMEyOdTAoaZuPNWvYZvQ6B3Xle3e75?=
 =?us-ascii?Q?3RBNMCxRFwjjl4KCOhMejbXzy7MYo7iRopSaukDgNVtf7H5ha3aenYgp/AoD?=
 =?us-ascii?Q?2DX8pZpC4cpsyR/WnEOeKBuOoJcEUHJqoE/E636cvl2L1A+GdyrZ5YkOptkb?=
 =?us-ascii?Q?mN6tD1bpnIrwUDYZJCpTrKYisbZM5QscXYyayG7xEi9mqbNsI1mqJcSHzftV?=
 =?us-ascii?Q?K5y703sOd36EDgQeYoWGZpIGRbw68JjE4Cku1PEXjvopyZnjIo0tA8teskTR?=
 =?us-ascii?Q?4QuszyTXXmcu8tRO5CAxS6GtdIgUGwDMC/+uCGdfI7tcmlOcLOJ526jXE4CU?=
 =?us-ascii?Q?GupkGrdNPyq1vrgak9IHNiZKsykRgzCxrhR7uJR/Xnb2JNUh0YWaKF2LaJSK?=
 =?us-ascii?Q?8lPacvIC5zUQB1+bUJ+blQXZoIQbcoeF+hJAI/U45PBFpFd0ptLEuI6cH5/M?=
 =?us-ascii?Q?MnVW6y88+3IT8Vzdq/x9+zlnEtt13vRjsD8S9zja5AbCpuqdlk2dKQaXFXD4?=
 =?us-ascii?Q?ctRAmWHaxnyXaRbTGt7HFnC4VuYQ2Ifz+D1cBMIFoaPOwNH+n3C2M+JxpaLE?=
 =?us-ascii?Q?MKPr4r4+BLRzBIto8NpUxa+f+FulsJ+BL0/OzOvP9ZHWE9aVrPTSal9cRV5j?=
 =?us-ascii?Q?76UdWEDFa48aGwr3xGABzGSEwP7iRdg4z7K+r4KpGdy9b+Xowxa7E+w0zCbw?=
 =?us-ascii?Q?cjTIvvFdo+jbNcqurGhwDxuQopd/WqEboCaeNAAj+lpvBEU7ge2kdhalYgHX?=
 =?us-ascii?Q?o3IAZITWWGLL9qSB/HngEhaROFD13fZIQN8esSAId641AEBxrrqH/5qZ+5dF?=
 =?us-ascii?Q?7SGHAI1j3Hl+IyMikZLYfdXSYifctrGP2LN5kMJ1uw3xH0hMK0AxGdlVBoN5?=
 =?us-ascii?Q?2dooz0Vh3Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b804255-34c1-4909-482a-08da220bdd2a
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4347.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 13:52:37.8116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hT/PpctpHYitxTErUX6HEjLo9TLeUv4MEP6QiAfuwELVfa61QAo/BdV7uB3zpP3OYZRB1S5siFJIdYNbcgurMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1850
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test verifies that packets are correctly flooded by the bridge and
the VXLAN device by matching on the encapsulated packets at the other
end. However, if packets other than those generated by the test also
ingress the bridge (e.g., MLD packets), they will be flooded as well and
interfere with the expected count.

Make the test more robust by making sure that only the packets generated
by the test can ingress the bridge. Drop all the rest using tc filters
on the egress of 'br0' and 'h1'.

In the software data path, the problem can be solved by matching on the
inner destination MAC or dropping unwanted packets at the egress of the
VXLAN device, but this is not currently supported by mlxsw.

Fixes: 94d302deae25 ("selftests: mlxsw: Add a test for VxLAN flooding")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../drivers/net/mlxsw/vxlan_flooding.sh         | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/vxlan_flooding.sh b/tools/testing/selftests/drivers/net/mlxsw/vxlan_flooding.sh
index fedcb7b35af9..af5ea50ed5c0 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/vxlan_flooding.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/vxlan_flooding.sh
@@ -172,6 +172,17 @@ flooding_filters_add()
 	local lsb
 	local i
 
+	# Prevent unwanted packets from entering the bridge and interfering
+	# with the test.
+	tc qdisc add dev br0 clsact
+	tc filter add dev br0 egress protocol all pref 1 handle 1 \
+		matchall skip_hw action drop
+	tc qdisc add dev $h1 clsact
+	tc filter add dev $h1 egress protocol all pref 1 handle 1 \
+		flower skip_hw dst_mac de:ad:be:ef:13:37 action pass
+	tc filter add dev $h1 egress protocol all pref 2 handle 2 \
+		matchall skip_hw action drop
+
 	tc qdisc add dev $rp2 clsact
 
 	for i in $(eval echo {1..$num_remotes}); do
@@ -194,6 +205,12 @@ flooding_filters_del()
 	done
 
 	tc qdisc del dev $rp2 clsact
+
+	tc filter del dev $h1 egress protocol all pref 2 handle 2 matchall
+	tc filter del dev $h1 egress protocol all pref 1 handle 1 flower
+	tc qdisc del dev $h1 clsact
+	tc filter del dev br0 egress protocol all pref 1 handle 1 matchall
+	tc qdisc del dev br0 clsact
 }
 
 flooding_check_packets()
-- 
2.33.1

