Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A983F558F
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 03:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbhHXBpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 21:45:18 -0400
Received: from mail-bn8nam08on2045.outbound.protection.outlook.com ([40.107.100.45]:26080
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232186AbhHXBpR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 21:45:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eRziZ/m8Exg8R/MrbTMfFhkyI02ThwzH73a4JJ1b/2kStHQn96R3e5vJRiVSeD7EhAOL+JmpPTSPFHDst0yEEr7TEO/xA+n0Pih7iqn+KbJUUUViXXF8ki8sXJ/iY9UmjLDWbzJrXwk51fpVQ4nqYG3XQbf+1pFe2X8aJ9NUmurfx0j7Q2j5vzgHvflWTr7izlf1QjCzZBYaMskXTkZL8eGv3As1KkkFqhO4TufKzujUFUGPr0Vk+WGsRQiTuzScSD24CSrBQAGH/xjUo5c8kPmdm+9l61nfUtDKEBgyy0I+KPdWBRcH7kmCEEYD3tlsa6G8lbdNP+jO+3xA4oaUBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlLjytztpngTkurKTHgWobOcTObKRlpXDFId6bJGZ0g=;
 b=od4Ru2S0tbQd0jvI4l2ge9s+nRChDKBoqgD+YJKHP123X3xCn8FgcZS/cCmdxmFVcldg8kSK7Do70F0Au97uJe3fh+m0K2fRBndJ9BNceAeMY78lE3jsfGgVch25fm1o4NC1A4hRuIBIb6Jga0fBjY1nWxEgq6hcbyLFsVGZ/AS1fu9wcjAO9wr26LUBHz5Ygdg7S8vDyjGbNZMqGSS45N+hfIi0Qgx+BqTuL8tN9tD4J9fPKXNwpSS+U9iXKyCmf4Z1cjmMgPVW/72hohjmazp4Gn1OeO0jMYSWbfhnmmiSkIDADKOs2beFIV5zkOYFentBxYcpamQ3+yjeUxBwag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlLjytztpngTkurKTHgWobOcTObKRlpXDFId6bJGZ0g=;
 b=gPnCtZsZ2k9/F8joqMmWIIGKKxsee5glhPKgP+f76Bks/Lla6B3a89ahVrVFhguHS9Ufy8dHswLILmjmDn8A6uGEGquhg7ddazQxR1hiv6cLuQXnQK/3D3o61GKmBqobYgfgb/xN3EHyQDQIUMwPTLEGUM2eyfKIx+24McNHUTrfrImzbnnUt7bGwwVa1QU1zFFO7IwUakqG+W6ybxt4qWb4rYFQ9i2/oUH56WHl5EhCY1GabNmq3qPOJuWvu8j6BlMcJTe5P5EIOGX6iId1nN2Q4ddv5y77NFi5JTrAuULoUJeltJ0Whu+JGsILrbPvu0YMseAoumWFNPNJ6tsYpA==
Received: from BN0PR04CA0078.namprd04.prod.outlook.com (2603:10b6:408:ea::23)
 by BL1PR12MB5031.namprd12.prod.outlook.com (2603:10b6:208:31a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 01:44:32 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::58) by BN0PR04CA0078.outlook.office365.com
 (2603:10b6:408:ea::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Tue, 24 Aug 2021 01:44:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 01:44:32 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Aug
 2021 01:44:31 +0000
Received: from [172.27.8.76] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Aug
 2021 01:44:29 +0000
Subject: Re: [PATCH rdma-next 00/10] Optional counter statistics support
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <dledford@redhat.com>, <saeedm@nvidia.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
 <20210823193307.GA1006065@nvidia.com>
From:   Mark Zhang <markzhang@nvidia.com>
Message-ID: <36e3e090-2568-4c7e-868f-673ac6eca7f9@nvidia.com>
Date:   Tue, 24 Aug 2021 09:44:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210823193307.GA1006065@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54b9e3a5-258e-4710-ad58-08d966a0b882
X-MS-TrafficTypeDiagnostic: BL1PR12MB5031:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5031D13604F92CCF2B8FACF1C7C59@BL1PR12MB5031.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S70MY442CPDM+HKNkW8jyk4f/erjgVXN9zPbD8Fvg8h8J3oa8cfrf23NSWekt9yt2HyRyvTO0Xo47X6BbZleH/zG/iZ2pWCq06BP8alLiy4u7Nb50+h03yWXeq/ldaf1Hx2qQbl8ah4QEfwbj8cQlfmVQXMRoeocQknhM/nwQtNY7ULU2H5gmAnuosUWQdxxGk20zXyDVmDhc0FbESdimqHV8s2mkoiSUgKbuobokoxZ2J3efK6Qfr1+CiF48tGYZqItjy3kxBU+aveLO6WyjubvdwuEa64h/BBVzQmnlvSHOIut3D665ytpJUy4tcJuZX2/KRvn9hvMmTbk6mXPAEtKD0pmz9i4E+XdyQTQWlN6M1C/MOAdD8ncsFEQpJwHu3fK3c2tLT4Jm6ThtW3sDNl+bSpC+PdXnXGPgCkYWtI3xdDjXxXqEcyfJwMZAvfj++LLdJwpfHRbDxtA+FhxuVHxd9pcF/bbaiOmL5R4JGt2FWbrA25KTXARegHpUlR8stL7xbTxYeSA6gi2GVuskDgdb3VKKPYJCeI7G9cW1AnskaiI2hMkU57H4qXIACfzACHxXX+ioJOLqQLV9UGgiEsdAdSPdrjQfH7OO2Yj3Ypug9NkS8dWK7azOZ2wDP/tFvnVMQjPtMa+djUofrz03AsXBxseqCTNeHdgACc91jrEknItW3l45gz9xt/4GyaUZ/w85TaLRso+cNjofAJyCmqLNp9YyIb7YAOzOKoo3eU=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(36840700001)(46966006)(26005)(5660300002)(82740400003)(107886003)(8936002)(37006003)(336012)(53546011)(186003)(54906003)(6666004)(16576012)(7636003)(83380400001)(478600001)(426003)(2616005)(31686004)(4326008)(6862004)(70206006)(356005)(70586007)(2906002)(82310400003)(36756003)(36860700001)(86362001)(8676002)(6636002)(31696002)(36906005)(316002)(16526019)(47076005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 01:44:32.4499
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54b9e3a5-258e-4710-ad58-08d966a0b882
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5031
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/24/2021 3:33 AM, Jason Gunthorpe wrote:
> On Wed, Aug 18, 2021 at 02:24:18PM +0300, Mark Zhang wrote:
>> Hi,
>>
>> This series from Aharon and Neta provides an extension to the rdma
>> statistics tool that allows to add and remove optional counters
>> dynamically, using new netlink commands.
>>
>> The idea of having optional counters is to provide to the users the
>> ability to get statistics of counters that hurts performance.
>>
>> Once an optional counter was added, its statistics will be presented
>> along with all the counters, using the show command.
>>
>> Binding objects to the optional counters is currently not supported,
>> neither in auto mode nor in manual mode.
>>
>> To get the list of optional counters that are supported on this device,
>> use "rdma statistic mode supported". To see which counters are currently
>> enabled, use "rdma statistic mode".
>>
>> $ rdma statistic mode supported
>> link rocep8s0f0/1
>>      Optional-set: cc_rx_ce_pkts cc_rx_cnp_pkts cc_tx_cnp_pkts
>> link rocep8s0f1/1
>>      Optional-set: cc_rx_ce_pkts cc_rx_cnp_pkts cc_tx_cnp_pkts
>>
>> $ sudo rdma statistic add link rocep8s0f0/1 optional-set cc_rx_ce_pkts
>> $ rdma statistic mode
>> link rocep8s0f0/1
>>      Optional-set: cc_rx_ce_pkts
>> $ sudo rdma statistic add link rocep8s0f0/1 optional-set cc_tx_cnp_pkts
>> $ rdma statistic mode
>> link rocep8s0f0/1
>>      Optional-set: cc_rx_ce_pkts cc_tx_cnp_pkts
> 
> This doesn't look like the right output to iproute to me, the two
> command should not be using the same tag and the output of iproute
> should always be formed to be valid input to iproute

So it should be like this:

$ rdma statistic mode supported
link rocep8s0f0/1 optional-set cc_rx_ce_pkts cc_rx_cnp_pkts  cc_tx_cnp_pkts
link rocep8s0f1/1 optional-set cc_rx_ce_pkts cc_rx_cnp_pkts cc_tx_cnp_pkts

$ sudo rdma statistic add link rocep8s0f0/1 optional-set cc_rx_ce_pkts
$ rdma statistic mode
link rocep8s0f0/1 optional-set cc_rx_ce_pkts
$ sudo rdma statistic add link rocep8s0f0/1 optional-set cc_tx_cnp_pkts
$ rdma statistic mode
link rocep8s0f0/1 optional-set cc_rx_ce_pkts cc_tx_cnp_pkts

> 
>> $ rdma statistic show link rocep8s0f0/1
>> link rocep8s0f0/1 rx_write_requests 0 rx_read_requests 0 rx_atomic_requests 0 out_of_buffer 0
>> out_of_sequence 0 duplicate_request 0 rnr_nak_retry_err 0 packet_seq_err 0 implied_nak_seq_err 0
>> local_ack_timeout_err 0 resp_local_length_error 0 resp_cqe_error 0 req_cqe_error 0
>> req_remote_invalid_request 0 req_remote_access_errors 0 resp_remote_access_errors 0
>> resp_cqe_flush_error 0 req_cqe_flush_error 0 roce_adp_retrans 0 roce_adp_retrans_to 0
>> roce_slow_restart 0 roce_slow_restart_cnps 0 roce_slow_restart_trans 0 rp_cnp_ignored 0
>> rp_cnp_handled 0 np_ecn_marked_roce_packets 0 np_cnp_sent 0 rx_icrc_encapsulated 0
>>      Optional-set: cc_rx_ce_pkts 0 cc_tx_cnp_pkts 0
> 
> Also looks bad, optional counters should not be marked specially at
> this point.

Will put optional counters in the last, like this:

$ rdma statistic show link rocep8s0f0/1
link rocep8s0f0/1 rx_write_requests 0 rx_read_requests 0 
rx_atomic_requests 0 out_of_buffer 0
out_of_sequence 0 duplicate_request 0 rnr_nak_retry_err 0 packet_seq_err 
0 implied_nak_seq_err 0
local_ack_timeout_err 0 resp_local_length_error 0 resp_cqe_error 0 
req_cqe_error 0
req_remote_invalid_request 0 req_remote_access_errors 0 
resp_remote_access_errors 0
resp_cqe_flush_error 0 req_cqe_flush_error 0 roce_adp_retrans 0 
roce_adp_retrans_to 0
roce_slow_restart 0 roce_slow_restart_cnps 0 roce_slow_restart_trans 0 
rp_cnp_ignored 0
rp_cnp_handled 0 np_ecn_marked_roce_packets 0 np_cnp_sent 0 
rx_icrc_encapsulated 0 cc_rx_ce_pkts 0 cc_tx_cnp_pkts 0

>> Aharon Landau (9):
>>    net/mlx5: Add support in bth_opcode as a match criteria
>>    net/mlx5: Add priorities for counters in RDMA namespaces
>>    RDMA/counters: Support to allocate per-port optional counter
>>      statistics
>>    RDMA/mlx5: Add alloc_op_port_stats() support
>>    RDMA/mlx5: Add steering support in optional flow counters
>>    RDMA/nldev: Add support to add and remove optional counters
>>    RDMA/mlx5: Add add_op_stat() and remove_op_stat() support
>>    RDMA/mlx5: Add get_op_stats() support
>>    RDMA/nldev: Add support to get current enabled optional counters
>>
>> Neta Ostrovsky (1):
>>    RDMA/nldev: Add support to get optional counters statistics
> 
> This series is in a poor order, all the core update should come first
> and the commit messages should explain what is going on when building
> out the new APIs.
> 
> The RDMA/mlx5 patches can go last

Will fix it, thanks Jason.

> Jason
> 

