Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5559B4D8B33
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 18:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240191AbiCNR5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 13:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239488AbiCNR5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 13:57:48 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEAE3ED15
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 10:56:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KjvtjSZEG2fYbrnlhi7THzXsesECUlMEVrAB+5GS6vzkQsDpXM+TzAv8KEdc+MidfNAWUq8KojcF2vUQFqzXyBaMcFBuuo/2UKi+yeQxcfY11wmGHPtSoph/SU2uRtqubDSLM6z7k9G5Y8ptccEOqAUeNyRDXGoaHRxe9v3V0tRJB1qJfUlYXFYaDiRp7K6McwN01PpT3aL2FBnGsG4P+ZDua5HC6GfPxglHg9vM5yDJ/8nBlJWzbWOkJpt6Anvn3DkwZwdK8fm+IuxfuE4u4X/eRFFggn/wN8hJRUhuwHTwC8TrR/oMECSJp1Ek5oUNFQE+mmrGxwK0c+yUoFxJlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FKPIueqPRqMc0lO9dRwia/EXnAa0jJnbLPsUUp/u4A4=;
 b=YBwro7msfbhWJkJgOPFp9PP/L3sOcDmKVaf1+9BwvhLXyHN8snZG2WVi3OzffS0ANrsU9vOnspfOo22pmwusqW7d06TYFXgxhy6NRU9y2Br3MdqUZ0sDBajgIjoV6IqkIKH/tyQv7+/fkhchjEiGzNXV171nGDk3bh0JbE5gean6BBpC6qfKzQhTKXKhxbgr57c1SiO1iM7vLBHmyiqmBIoDupgMWdFc5Hp1J9LTU7gBFS15wbJgLKejWqKUlPjxFNxPf/M7zLMzA4kwboyci6QWTJ9MGVs5Wo/glWRi0EQzuJi/GdxQQgbDELIl56Un1K0Al3KmUdBSwK2hmV2joQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKPIueqPRqMc0lO9dRwia/EXnAa0jJnbLPsUUp/u4A4=;
 b=mC7vHN1HPXpjJ1tQqhuyiJGPXm3te2g2/6NZ0I615uKnf5N/nJ0jD0cOGFTBGy2O1I8pn6Vsz3xwYr2dtYgaW5j+KhKGfxnn2cfkfzsed0qXoE7SuQMBcb4u+fR3TNx+pK9BHJZtv+n0YD9+gL9gLt+rpVGI6mFbv4Cbzsixaj+c77j91sC4/ce46hacBDVgW+wtn3omRI4n8ot7U1u82imx0RgMp1zuS4QV6zUziBfag4RfC9Z9BbMsR0VzbQ2R8uKkEWqLZ4pst/Sj5BthNBs36zAgIwmfjsLmz7eVtM5WU5Z9SmA2jXgAEu3q+6uoAL7n5cJgB4J1v8dUSVlCBw==
Received: from BN8PR04CA0012.namprd04.prod.outlook.com (2603:10b6:408:70::25)
 by BYAPR12MB2744.namprd12.prod.outlook.com (2603:10b6:a03:69::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Mon, 14 Mar
 2022 17:56:36 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70::4) by BN8PR04CA0012.outlook.office365.com
 (2603:10b6:408:70::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.28 via Frontend
 Transport; Mon, 14 Mar 2022 17:56:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Mon, 14 Mar 2022 17:56:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 14 Mar
 2022 17:56:35 +0000
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 14 Mar
 2022 10:56:32 -0700
User-agent: mu4e 1.6.6; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jiri Pirko <jiri@nvidia.com>
CC:     <netdev@vger.kernel.org>, Jamal Hadi Salim <hadi@mojatatu.com>,
        "Maor Dickman" <maord@nvidia.com>
Subject: cls_flower vlan matching
Date:   Mon, 14 Mar 2022 19:26:38 +0200
Message-ID: <8735jkv2nm.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29ef0a0c-7578-4f0e-9e0d-08da05e3fb54
X-MS-TrafficTypeDiagnostic: BYAPR12MB2744:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB2744E90B1E33266D29732A55A00F9@BYAPR12MB2744.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iIjBdAria9W6mRdMdOENAwBjnvLCkh7HjI+9SgUEbNt1CNvMxlmQfiDILpt3Oe+1dGqbI9/miAEsP/aISAy3wq4al7KhLIco9Hvdwy9W2gqDFzGHTE6D4V5nXWKdRybFm1pGkqhooE2r+GGCN744+SaxBvJJMgUb/uWrxUattjzVp0vU1qyn+qzYc77zC6o8W0O/+AxF9GZK8+H7h2uxx507l4J1vo934NxfpR418KOlXhA1Rqg9dz5q7HNk9gqln5nwD172zkMJVW90yi8OyTMIWc1OLYpHLHMirpRinHbNmO5U73o3r4A+OJApmXnPjaPfT5jcK24vY0HV5pvO01AYbrUqk+J6NVu1C++AUJdw3zIyhsb39xgEE8uiZkHnAHepsbKKvTAVT4s5pM42t5S7SnRBi3kkWbiBNDm3Tj8KtDCAXWfRmYFKHViRrJ4tdxLJuUmIJxxuCKCzAaNB9UYFH59ZZ+zxwUF9723EQ1cCG8aUdlYyyyZ6KdMgGoIx7RxNRZdWm0qrsDdRmPcFi6pvFOWqK6XQEMmblMfMd9zudkOglxEJFCUpAhUtbXGbtN85GgW34IE6tXBvo9YW0kXouR7atTx6bCUu+WRBNmoJrb0iW3Bb8tZbKweHjUgnl9EFYcyJ9HtcNzzgSkTp/RyRstnFDc0rdScAVCln6SlOEiZ3EYwor5n9Uehrx8TcV+6MjsfFEGCnvFQ1SNzV3Q==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(508600001)(107886003)(426003)(26005)(16526019)(336012)(186003)(2616005)(82310400004)(7696005)(40460700003)(356005)(81166007)(47076005)(86362001)(36756003)(316002)(36860700001)(83380400001)(8676002)(4326008)(7116003)(6862004)(2906002)(70586007)(70206006)(5660300002)(8936002)(37006003)(54906003)(6636002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 17:56:35.6813
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29ef0a0c-7578-4f0e-9e0d-08da05e3fb54
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2744
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

I've been debugging an issue that we encounter with OvS-created rules
for single and double-VLAN packets.

Basically, for flows with single VLAN OvS creates following tc filter:

filter protocol 802.1Q pref 2 flower chain 0 
filter protocol 802.1Q pref 2 flower chain 0 handle 0x1 
  vlan_id 10                                                                                                            
  vlan_prio 0             
  vlan_ethtype ip                                                                                                       
  dst_mac e4:2c:0b:08:00:02     
  src_mac b8:ce:f6:05:e7:3a
  eth_type ipv4
  ip_flags nofrag                                                                                                       
  skip_hw                                                                                                               
  not_in_hw               
        action order 1: vlan  pop pipe                                                                                  
         index 2 ref 1 bind 1 installed 11 sec used 0 sec firstused 10 sec
        Action statistics:                     
        Sent 860 bytes 10 pkt (dropped 0, overlimits 0 requeues 0) 
        backlog 0b 0p requeues 0
        no_percpu

        action order 2: mirred (Egress Redirect to device enp8s0f0_0) stolen
        index 2 ref 1 bind 1 installed 11 sec used 0 sec firstused 10 sec
        Action statistics:
        Sent 860 bytes 10 pkt (dropped 0, overlimits 0 requeues 0) 
        backlog 0b 0p requeues 0
        cookie 16a9b603144b3e0c64a887aeb972a269
        no_percpu

Such rule also matches packets that have additional second VLAN header,
even though filter has both eth_type and vlan_ethtype set to "ipv4".
Looking at the code this seems to be mostly an artifact of the way
flower uses flow dissector. First, even though looking at the uAPI
eth_type and vlan_ethtype appear like a distinct fields, in flower they
are all mapped to the same key->basic.n_proto. Second, flow dissector
skips following VLAN header as no keys for FLOW_DISSECTOR_KEY_CVLAN are
set and eventually assigns the value of n_proto to last parsed header.
With these, such filters ignore any headers present between first VLAN
header and first "non magic" header (ipv4 in this case) that doesn't
result FLOW_DISSECT_RET_PROTO_AGAIN.

Is described behavior intentional? Any way to enforce matching for
header following the VLAN header?

Regards,
Vlad
