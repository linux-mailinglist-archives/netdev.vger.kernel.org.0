Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD66484532
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbiADPul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 10:50:41 -0500
Received: from mail-co1nam11on2076.outbound.protection.outlook.com ([40.107.220.76]:7649
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229798AbiADPuk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 10:50:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n16vfrtuLIz7z9KJ9T8Dfi5o/H9dObUTrBQg0DjjKwkYZOQ4KvmNo0fhjgNt6RWaN5RUhjInah1oVFS8R18Z8MoiXAWV6P+tTeZ6gcYqpPE8Grtf3QYRBuyISh6HHcQYLDN/8SUKnoE+/T/XdL1rtZteiKrYciGdZsFbdoRtAXixLf/wDQcjeRjAQ4LoDbPpEmcTiTbdMwBvliPXoN3LmEDI8ufXD/iDuLktDtvtPGOWqP/PI/uu2T2ikBP2hukkHbJEk037jXe2jU8MI8sRgrbRNoU/l3dpI2VymaSTrJMBMrHZYXxz6RDwTI4NVS187/ux1bmDuBdnDPSe7hH69Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8y830wVd9WtuoW6+KYzcLa/tZ9lKtXJwbTv14VYS38Q=;
 b=jrFyHC8Km/HJKKTqthV+ok6j/bKTkcq6awy06YsU7li/PLFPwcvl+Ka/HSH1LIAalYnydNhwMCDAgSS1h27vuCBRQZhbYODyG3FuSvPRPOsOHUmL4/h6V1y/m7qKqcjP9rJObTjz7QR6n6ej76nZqsvV+LeDHl5RVHg+Va5+730DWuz3ll1dVJq6zhE2n5IGq6Q4E94cChLLUvJQa6F3EanozAL5x19Fg5rzm5etCRYYqWytWsdEQr3bF27Sotb0v/8MzvD1w2xAuSz/QEdHRoUvPRPbC8Ffash4UBpBFe1vVXyOg3Vgm8dv5HFjcGFrK1MbYYzr90kRJ/dQIutsYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8y830wVd9WtuoW6+KYzcLa/tZ9lKtXJwbTv14VYS38Q=;
 b=eNF1HQr/Vp8M8f+nvYnF9wVVrI4pSJCl3rj9SjJcmumiM525Z0hiqOEOBkJspSBNIyArrofelgo57IsjPe3WBLE0b2ZusHcE1439vGej6AvH0JoohQZlMRfNIDUQ8qksAJcF5ERxnJqykIm4hPWGbl12krtwH/UwyDiNaVYdUPaN5LVvrno6w/jevGqurazYJ9js7ZGAOcMCVxZ57X1cgvtm8AiFcxA+lUIm+KNKqy9HqW05zE6qscjfnXnhw500cLaC/Rw/oBK0dqg9LL5/kKeWgR1wv3EhLrjRB/cJzYwSeEz2JLzt1Cl4RbT+/56Evd17R/vep1fS/fqNGpBHnA==
Received: from MWHPR04CA0030.namprd04.prod.outlook.com (2603:10b6:300:ee::16)
 by BN8PR12MB3235.namprd12.prod.outlook.com (2603:10b6:408:6e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Tue, 4 Jan
 2022 15:50:38 +0000
Received: from CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ee:cafe::7d) by MWHPR04CA0030.outlook.office365.com
 (2603:10b6:300:ee::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.16 via Frontend
 Transport; Tue, 4 Jan 2022 15:50:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT042.mail.protection.outlook.com (10.13.174.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4844.14 via Frontend Transport; Tue, 4 Jan 2022 15:50:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 4 Jan
 2022 15:50:37 +0000
Received: from [172.27.12.20] (172.20.187.5) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Tue, 4 Jan 2022
 07:50:35 -0800
Message-ID: <1335eea9-463b-3f99-d9bb-ce158a11d03b@nvidia.com>
Date:   Tue, 4 Jan 2022 17:50:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: htb offload support in i40e (intel nic)
Content-Language: en-US
To:     =?UTF-8?Q?Stanis=c5=82aw_Czech?= <s.czech@nowatel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Maxim Mikityanskiy <maximmi@mellanox.com>
References: <1429844592.20211229205044@nowatel.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <1429844592.20211229205044@nowatel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9c58404-283a-4738-bebb-08d9cf99f414
X-MS-TrafficTypeDiagnostic: BN8PR12MB3235:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB323512259CA3ECCB31E1B4E2DC4A9@BN8PR12MB3235.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uROJDszGU/8DlCXp1iqzUWRbuCNjv7rfEn1t39isaTI1LXN4Hda73Iw1yVC+usx5mAKn1pL414vrR8YA+s36L3BXFfR/leMPyIkOEEde7tyvEwaS6LcZPk9zUeRbCey/d+qDfqBmHOUYO2YbXKW3h8blJI2zmUbNlZ49Eunt71j7Up07daIeXDG+PPzbnNPr5w9jx+nQynDXGv7ilc8cBtvubXfOCgHHOFaNtpWvSrbSGa07XmQVBvGmoOX1gAXz+nD4P5woszZ5749XRQ9Ecde/jw5uvMbBR9iqSm0VveJH+eJ13XqeVhpiOzFOTOxWpGW4BgAaJf9xxbovKfHM8sMIVjhM8bh28D04DrP5ZwaKL66J9mdWRlaRlHHUEViWlqxMlmF4L+UtbjZMjWa8/uVOrdJm6CeRr+Mcy+cOpvjoYDNi2rIyEkSeIDCFYJDFqE+M82HuFmwtG6sywu2tBMHdq6x1Cn6DEC8NASX2dI+F/fgw4nJRVLfI5G5mfeg9ZsqSvF50lZCfcjtMiFk05/r5mUykNz5zDtPZIsNXbtLXyCefdefLXwPYcPyqwOpYPcy9T4HXHzbWPOzdczvM9PpmjVsyAL+Gt2xsfFPPbz7UfMtfhM+0FYhOpr7uvOvpaL0VScBIjfRudhcctkyoGG94MkAnpEkLGZhU1Qd/1EveKhFYKY7lZuk3aFmCdD95MkCxjchjgWiZh/MIFqoqghEL3YzeMVnxSxJOUJAQIQuU6qeUgpsKf74Q+yJAV4mgLewP+PPlipkdT2gPkZ8HgHMbOzKE6fmSoqiWK8mC8I9GGz0kYMLiZCCJiSmN6SfqCXyRIHSsDd2iYYo6aog4bg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(107886003)(6666004)(426003)(47076005)(31696002)(83380400001)(40460700001)(2906002)(81166007)(66574015)(5660300002)(82310400004)(26005)(16576012)(31686004)(36860700001)(16526019)(8936002)(2616005)(508600001)(316002)(53546011)(110136005)(86362001)(186003)(336012)(36756003)(70586007)(4001150100001)(8676002)(70206006)(4326008)(356005)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 15:50:38.0488
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9c58404-283a-4738-bebb-08d9cf99f414
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3235
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-29 21:50, Stanisław Czech wrote:
> Hi,
> 
> I saw that the htb offload needs additional changes in the mlx5 driver to support it.
> I couldn't find any info regarding the htb offload support on any other drivers/vendors like intel
> nic (i40e) We use multiple XL710 that seems to support hardware tc queues:
> 
> qdisc noqueue 0: dev lo root refcnt 2
> qdisc mq 0: dev enp65s0f1 root
> qdisc fq_codel 0: dev enp65s0f1 parent :18 limit 10240p flows 1024 quantum 1514                                                                                                              target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :17 limit 10240p flows 1024 quantum 1514                                                                                                              target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :16 limit 10240p flows 1024 quantum 1514                                                                                                              target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :15 limit 10240p flows 1024 quantum 1514                                                                                                              target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :14 limit 10240p flows 1024 quantum 1514                                                                                                              target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :13 limit 10240p flows 1024 quantum 1514                                                                                                              target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :12 limit 10240p flows 1024 quantum 1514                                                                                                              target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :11 limit 10240p flows 1024 quantum 1514                                                                                                              target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :10 limit 10240p flows 1024 quantum 1514                                                                                                              target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :f limit 10240p flows 1024 quantum 1514 t                                                                                                             arget 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :e limit 10240p flows 1024 quantum 1514 t                                                                                                             arget 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :d limit 10240p flows 1024 quantum 1514 t                                                                                                             arget 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :c limit 10240p flows 1024 quantum 1514 t                                                                                                             arget 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :b limit 10240p flows 1024 quantum 1514 t                                                                                                             arget 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :a limit 10240p flows 1024 quantum 1514 t                                                                                                             arget 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :9 limit 10240p flows 1024 quantum 1514 t                                                                                                             arget 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :8 limit 10240p flows 1024 quantum 1514 t                                                                                                             arget 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :7 limit 10240p flows 1024 quantum 1514 t                                                                                                             arget 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :6 limit 10240p flows 1024 quantum 1514 t                                                                                                             arget 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :5 limit 10240p flows 1024 quantum 1514 t                                                                                                             arget 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :4 limit 10240p flows 1024 quantum 1514 t                                                                                                             arget 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :3 limit 10240p flows 1024 quantum 1514 t                                                                                                             arget 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :2 limit 10240p flows 1024 quantum 1514 t                                                                                                             arget 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: dev enp65s0f1 parent :1 limit 10240p flows 1024 quantum 1514 t                                                                                                             arget 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> 
> Is this enough to support the htb offload or we must wait for the driver update to support it?

Hi,

The HTB offload requires hardware and driver support. The NIC has to 
support hierarchical rate limiting, and the driver has to implement the 
API used by sch_htb to communicate the hierarchy. Mellanox NICs starting 
from ConnectX-5 should support the HTB offload (see the original commit 
message for more details).

So far, in-tree drivers other than mlx5 don't implement the HTB API. I'm 
not aware whether the corresponding hardware has the needed capabilities 
- that is a question to developers from Intel.

> 
> 
> Greetings,
> Stanisław Czech
> 
>   
> 

