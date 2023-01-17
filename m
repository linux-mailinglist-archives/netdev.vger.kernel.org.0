Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DDC66E514
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 18:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbjAQRhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 12:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234277AbjAQRey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 12:34:54 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF4E4B742;
        Tue, 17 Jan 2023 09:32:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ro4rntOwnXJ3C48DENA7WLsm1+dHGrlMmWimgyQlYO1wkwmD4cxOHhh1rwI47dJiagt+rnN2YncZ/fIA2pbXGoHOH0i1bOlSNMQldHQ5yG7g3/xA9Ijr8g5fEPDuGGQML7iUZaKYOGW2k5i5JGMJuFho+sxPnSMHjurdl6SKavJjVVCaeBs5OP4fWUVmk2TCXzKvBShEr6hzwZhdurngxwtZa+wIP26hDghz8D/zymI2PXAK7JJp3WC1npO/25Ta1prD282VGFQ3YUOdqSdhUnfBkG1DmNTS5kHrA/bLNqxtjBMvM179G392q091tyUXLR5m+KCHOIqeoZDwWhlGOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MbX7lGCcIZuA22zUx8h77w10G7rKNkjlkOi7xT4HUqs=;
 b=eS4Q/RhaazJPsPCtxG9HZgXCqT052MHouPVlbkh0kOxKwq/csZyoZfLp5jN+b157fekzdOGo4A3CrUZPx7s4m5Qcq83XyMZ79VVI5D7CtgZVz6y95JxcIYAHuhX+qTlUOqtB96JXJqBP5+BTTZjk5DSQ5Nue6sKWgS0Ku/omKQDnq6TOP3gdZsCESd29ZMtS7Pybm/snKDZO/AgrCS3fXWib92BpAfY6F0YpLoFgrkxxDt4SJTHQIorcDbdGz16SnDgu/1imoyw4j/Z3c9Dr9rOBmAT0po5h5ee3DnoPY/Af567CXI8U8UPKvXjb6iR72t39L0zBuxBwbjIYeanZag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MbX7lGCcIZuA22zUx8h77w10G7rKNkjlkOi7xT4HUqs=;
 b=S1V8pE+G946HoVPLiO54FwDqqz7Web2wRJwxzLQQMy0Mt3cQiLIA6uDNzW1I7oTfOgSRHxYsd9IGpt7kagGMcgO6ypVf3QHEnVoxCvZ80HQDlVcoSNbvz05PFDHOpQoimMjmKj80DNd8m2AjPcVs3G7nQhEawoKoR6uQkZY6bLQ0qKP6oKUlOvBkrVmm7PfXsODCyBe6vDgqTuGrlN1GT64mXu29e/JYXyyrHW0FXQXfH4ugxJ3Zsxu+TT1Fv9XFcMXdpLR5ufHTa0192Nb82DsDtD3eop4bj5l9mITnRjQXL5BT6ecQdpMu9NLkwnKOFIXseOtR67ebrgTDAcL0+g==
Received: from BN9PR03CA0403.namprd03.prod.outlook.com (2603:10b6:408:111::18)
 by CY5PR12MB6597.namprd12.prod.outlook.com (2603:10b6:930:43::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 17:32:15 +0000
Received: from BN8NAM11FT115.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::8d) by BN9PR03CA0403.outlook.office365.com
 (2603:10b6:408:111::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Tue, 17 Jan 2023 17:32:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT115.mail.protection.outlook.com (10.13.177.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Tue, 17 Jan 2023 17:32:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 09:32:02 -0800
Received: from fedora.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 17 Jan
 2023 09:31:59 -0800
References: <20230113165548.2692720-1-vladbu@nvidia.com>
 <20230113165548.2692720-4-vladbu@nvidia.com>
 <Y8a7f2AXVMx8WWPc@t14s.localdomain>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <ozsh@nvidia.com>,
        <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v2 3/7] netfilter: flowtable: allow
 unidirectional rules
Date:   Tue, 17 Jan 2023 19:31:45 +0200
In-Reply-To: <Y8a7f2AXVMx8WWPc@t14s.localdomain>
Message-ID: <87a62hcbjm.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT115:EE_|CY5PR12MB6597:EE_
X-MS-Office365-Filtering-Correlation-Id: bef1cd95-5e91-47e1-552c-08daf8b0c68b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sNVXe0ZBMPX5xVCIGVAcvRe2EjwfdjnXFc3SoKytgrGSm49GQKfV6CnVBWmkQB1mbhVbVLw+3q9AYpx0MMC772RIjMXZjNunc/dk9wRSzXhH62eCqnqF/dMbUcDrk8dcOOp3ZzOl592GrJY60Om118uwc54o0vugigysG+eR2KsnZojyRWvNCWWookHZyaIGZLcMfqJFWtilhqcUAKAoqWyoJxZsh2e8wE/JKDTcy+QI/2JftxYq/sz07O1e0cSKtL5eFLx5j3a3Xe+D7DtscYJAt/6r5iUdx5YcvR3F2ivuW7GDOdlu1QuGS1FbBDHUDokBw3IginiEkrLagcpA4sCCV8G2UEdHjHlrZKxf4Vx7NtaIkchhejvD6LPR3vd4ZF7IwfYYYoENBaEw1+Piz1IJP0iOMQVpnyBZ/b1HcPF1lY8c8FNGU0PAFSFQQzBGIxcNveNCF4eQHcCFwK4mY/JB86POL6r15oU80xSO5+rcz9Lz8aDYOBoslyZ/Ge+HcwXC77x1LcDeg8VOT3AnNX1DtB+nPAC6SW173rCD+fZmG+J0HC7bGp5oA9+iVCLZ6B+wnZ9akus7Qnrtl0yxTlJN+K+2e9abCX174EcTQPPjaX69HnepiZM7P8xroowbPsMzaB/eQjr0vnKTG9Ib8XOmgwHBS2XFpTxrT4Kmp9vygPBLt0OWucdWwha+pMqYhNmw/dKGLaxYJxRSUiDjBg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199015)(36840700001)(46966006)(40470700004)(82740400003)(36860700001)(7636003)(5660300002)(356005)(86362001)(6916009)(2906002)(7416002)(4326008)(4744005)(8936002)(70586007)(8676002)(70206006)(82310400005)(478600001)(40480700001)(426003)(336012)(16526019)(186003)(47076005)(26005)(2616005)(54906003)(316002)(7696005)(40460700003)(6666004)(41300700001)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 17:32:15.3268
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bef1cd95-5e91-47e1-552c-08daf8b0c68b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT115.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6597
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 17 Jan 2023 at 12:15, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> On Fri, Jan 13, 2023 at 05:55:44PM +0100, Vlad Buslov wrote:
>> Modify flow table offload to support unidirectional connections by
>> extending enum nf_flow_flags with new "NF_FLOW_HW_BIDIRECTIONAL" flag. Only
>> offload reply direction when the flag is not set. This infrastructure
>                                            ^^^ s///, I believe? :-)

Good catch!

>
> ...
>> -	ok_count += flow_offload_tuple_add(offload, flow_rule[1],
>> -					   FLOW_OFFLOAD_DIR_REPLY);
>> +	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
>> +		ok_count += flow_offload_tuple_add(offload, flow_rule[1],
>> +						   FLOW_OFFLOAD_DIR_REPLY);
>>  	if (ok_count == 0)

