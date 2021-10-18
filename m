Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B061E432389
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 18:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhJRQPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 12:15:17 -0400
Received: from mail-mw2nam12on2068.outbound.protection.outlook.com ([40.107.244.68]:12896
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229634AbhJRQPQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 12:15:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kqinmKFPQuvxruXcHc9Ld3J14n6Gq+mYFqf4kn4pXncwNLEmn0/LL+IunQT99nvffnQRRYdc1lyPkIL+Jt2ACaHUFDiWvqMwOrQk5V8rDl2+yC68X26VebpZT/RocgvTiHDkDOs8rK8E/klmgaNPa2MObumrBKUN805kFxFoyQeNscJXjh7niACM84mQdf/tJ2pgD6ytkX2asgEFhpqxciK7YPHg0upt0bLvZIhToPN0986e2SemJU/2DTQPBDpGc42RZB7AiW9bMw8MqMhAx7Q/v+393iKe9PAGzU8ETgMB1X/9Y89/SGnSH0fdklTtrKN315wfGMdZVkugyFu6Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VPYkVOkvjbjjNaCzyr5zNGFpqQmeCp4AIcwTQCfBkHE=;
 b=jl/vpL/QRI7kKmhvQCT1GkujKZqbteFGwgG7Fpu0WByltFu1IA2sJ7F6VGwGCH4audx9sElV0f1Zg38FojBy+p+zqoYykFcjFfWCMwd+vdAIbAoT19llW7v4kb0estehKkJHmFL9p9HCQO2qiORNrWuEsnNVRZVSBT+gtV7b6dhZAvmZkQwFQkRRLXeQnu1y6VrsuIchiWD4qqzoB7TwMTG+F6qNAxdN7N24+GNgjx19VAjf+zqWiCgTCuZ4q2XqjiysQgMzt4n+V+Azs5ROrVZBWMvu7nCUY1lQG1LefTBN++VT2pFf2YF7s6xR9bAT1Gj58nUW16l1/GIGnn+UNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VPYkVOkvjbjjNaCzyr5zNGFpqQmeCp4AIcwTQCfBkHE=;
 b=TqP9+dezR5VpNhfMtjWNUcdTnjUD1wz4EOCOdPI2tlPFkYDtqa8J4g9X/SKHQGroowajL2aUmdcATS7SOyEmD3FVdMSQjSfRSLTAnTLFPurXi466wpyWBtfCIc62KYk8gxif85lq88YzQA6s/URK2R+jgSGO5yuPC7ptLUdjhsbNtFKnx80FqL5ryIJ3VUtMcA0Er2dOVh9FQskrXXHFwB/EV1imEqnIBsrwRum6h8gdl0fIa6j9q1BU7uLOVLRo5/WBG5XL0tpAc3/0vWELSY7Mj5xsjkhrRSk2w+tW/tlo2FMqcuN++IvWINDcNFgrzpgnRinM6gWZ8Y56W4EfZw==
Received: from DS7PR03CA0229.namprd03.prod.outlook.com (2603:10b6:5:3ba::24)
 by CY4PR12MB1383.namprd12.prod.outlook.com (2603:10b6:903:41::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Mon, 18 Oct
 2021 16:13:02 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::c2) by DS7PR03CA0229.outlook.office365.com
 (2603:10b6:5:3ba::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend
 Transport; Mon, 18 Oct 2021 16:13:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 16:13:01 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 18 Oct 2021 16:12:52 +0000
References: <0000000000005639cd05ce3a6d4d@google.com>
 <f821df00-b3e9-f5a8-3dcb-a235dd473355@iogearbox.net>
 <f3cc125b2865cce2ea4354b3c93f45c86193545a.camel@redhat.com>
 <ygnh5ytubfa4.fsf@nvidia.com>
 <20211018084201.4c7e5be1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        syzbot <syzbot+62e474dd92a35e3060d8@syzkaller.appspotmail.com>,
        <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <kafai@fb.com>, <kpsingh@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>, <syzkaller-bugs@googlegroups.com>,
        <yhs@fb.com>, <toke@toke.dk>, <joamaki@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [syzbot] BUG: corrupted list in netif_napi_add
In-Reply-To: <20211018084201.4c7e5be1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Mon, 18 Oct 2021 19:12:47 +0300
Message-ID: <ygnh35oyb9c0.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1c7fad5-0802-4681-7720-08d9925228bc
X-MS-TrafficTypeDiagnostic: CY4PR12MB1383:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1383916158305DADBB8610C8A0BC9@CY4PR12MB1383.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gcVn6ES+OAiwCKmzKfaFJr9hZFH8gQTf2/jp0TkE5GTAz+efjOP1QOAksZ/SURR3MsspyoBi/rTtA2WCC1YKGXh/1xw3qJJb2F5fx3zzdYI/ta2YhyN4L7c86OjIxfTKWY3ACwV//ZTPyMwfwYbHz0UPqRSQcuFjLaLB5xx4JS8CybdknzPT3q0+qzvkIHC1D8NSYVaFWGl6xbL4I8Mqd4e1wuLPSkmc9qq0joZelf7Ss4ucLNbVZVfeOn4oAl1CsKIIPOglj6cX+5s5GlLbWYVAnHY7fv7cND/UgTpOZhyH0qvA4XijEP7SYKytI0deRPmdCNM+IsIa6UWp4d/8YOpcaXhL/VnFQLznVFmoU7/ggB9dg4OC0t4puDby753t9fKrR6yUMEyGsQ+po8+lZzgibxCq9sW5JM7VkF55zRZS6eIf2zUzrBX+UPlwIWCB5gEfNiMQzIG9hJ+cFLqazlZTKPTr5SGZ0VhBEPH8MTJAn+p53L6L+TM+T48DnGJXUvLZBWN7Kl2J5TaLfKN+ELHhvbbg+Ut532Xo0WBIdRLnlfkYrTGmAsQQvHJ37lK/XOoIirf30CAUelTxsfnG1ayjStZs6Tn3geiDj+xw198JFYMv6TAmKNR/7rv401d+kNf8lyTw4rtkgZNa16Kk8MML1wL7nu5Vbromy0A/zVciXNKR/xU46cHk4AIRVG1LBynumEeMyrLR8L7no60OiQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(70586007)(36860700001)(2616005)(4326008)(5660300002)(83380400001)(47076005)(54906003)(70206006)(508600001)(2906002)(8936002)(356005)(316002)(336012)(7636003)(6916009)(36906005)(86362001)(426003)(7416002)(26005)(107886003)(82310400003)(36756003)(16526019)(186003)(7696005)(6666004)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 16:13:01.6550
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c7fad5-0802-4681-7720-08d9925228bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1383
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 18 Oct 2021 at 18:42, Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 18 Oct 2021 17:04:19 +0300 Vlad Buslov wrote:
>> We got a use-after-free with very similar trace [0] during nightly
>> regression. The issue happens when ip link up/down state is flipped
>> several times in loop and doesn't reproduce for me manually. The fact
>> that it didn't reproduce for me after running test ten times suggests
>> that it is either very hard to reproduce or that it is a result of some
>> interaction between several tests in our suite.
>> 
>> [0]:
>> 
>> [ 3187.779569] mlx5_core 0000:08:00.0 enp8s0f0: Link up
>>  [ 3187.890694] ==================================================================
>>  [ 3187.892518] BUG: KASAN: use-after-free in __list_add_valid+0xc3/0xf0
>>  [ 3187.894132] Read of size 8 at addr ffff8881150b3fb8 by task ip/119618
>
> Hm, not sure how similar it is. This one looks like channel was freed
> without deleting NAPI. Do you have list debug enabled?

Yes, CONFIG_DEBUG_LIST is enabled.

