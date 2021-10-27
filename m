Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A07043C83B
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 13:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbhJ0LD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 07:03:58 -0400
Received: from mail-bn1nam07on2069.outbound.protection.outlook.com ([40.107.212.69]:65252
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241560AbhJ0LD5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 07:03:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HGxvulHfy8TwbKdAnbA2fi6H7Qsgxvb5onQNIOTTVdHvV/Y9+GE+qH0THiGt/8ZRZwIyqRyFl5H7rD+jK4I1H+NQDGs+G0YW6EdwCeyaiBf+jxTaXprPiSXypBlZhTLlvDWEqGpehCeJ1xjaRBB4xiebJp01fXKPTRE9a4W5jxwyohn+xbOpTHf1QxxXoNWuAFLOaEqwkn/LEIq7+ZfQfwlhvTLhSD8afnUybZyECz7YlkL04bnaJC9E3e/OQ02/cuTUk2YrRy+m/GI8jODSWdovq8yXKVRLA1xdPOn+Ws54RarQBmtkSKJ4ZTmVBJmYJPL+23D2JLH8DueUM8lblg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i4GSp+WGpYtcdppod3vUcKJUQhrLAfLCoTgfa/DjAu0=;
 b=G7PoWkSPittG/IdSqP6I6bJxC0+xF+z1h3FdjPRNKwYChVs6GKTtfPnKsEzYIHNt2lELETp0iuJSeLz7KdqbavFDCbdVCZJHhXIEka0gJfrSpadjSzLNJD+lR6EUXGJ3MiWK1xr8CQNH9ZUdJnm3KXq05VDh+WY528gXAYgoESLFRE1nW4O7tFPruP/GrPWQSEOVfKHSuqABStAywXkcgaPP0/fKtK40US52PMqIcxVOA4H6gwZzPa/Ug0XPt6o1Cd+bJvyTAEpfNMpZR2l055RREdY5ei/T/qwq5D9/Y5UARO77/Yl+flxjXH3wyLGfWkm9xPyXSqzKtMkHC27OgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i4GSp+WGpYtcdppod3vUcKJUQhrLAfLCoTgfa/DjAu0=;
 b=K7atSKjyb/A0BA6eUGQAachXx4gF4xm2Ujv8f5Zr50QolZ8ofKnJ0bPvwadcNZeFDtVXSAk24xyhjlQhpfqcoaqESUMUJfE1B1CAQoKl5u9Fssym0SsyehMI/uDEUynUTmEB6Doi3SUWGvvpZBIlRYrl7C5l+JXdaIjq9IVSnOu/jC7ddQt/pWz/It8uNSBkNDkheY/yRIpoqFwFX+cAy2rv76Nj1A27qsaVAoGMPRRghvYcAxo8CCFb5YTeR6n1hVsvp1VEie3hnCD1JWGLjAX5bH2NPLvHjPyrMHMssP6652/hPIcWV1lNP6KUCoQFILSVmfrDE1ZG8pDALetoEw==
Received: from MW4PR04CA0183.namprd04.prod.outlook.com (2603:10b6:303:86::8)
 by BN6PR12MB1858.namprd12.prod.outlook.com (2603:10b6:404:fe::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Wed, 27 Oct
 2021 11:01:30 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::ee) by MW4PR04CA0183.outlook.office365.com
 (2603:10b6:303:86::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend
 Transport; Wed, 27 Oct 2021 11:01:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 11:01:30 +0000
Received: from [10.26.49.14] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 11:01:06 +0000
Subject: Re: [PATCH 2/5] PCI/VPD: Use pci_read_vpd_any() in pci_vpd_size()
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Raju Rangoju <rajur@chelsio.com>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <ba0b18a3-64d8-d72f-9e9f-ad3e4d7ae3b8@gmail.com>
 <049fa71c-c7af-9c69-51c0-05c1bc2bf660@gmail.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <88bfd6ed-f5c6-b9f9-c331-643eb0d37289@nvidia.com>
Date:   Wed, 27 Oct 2021 12:01:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <049fa71c-c7af-9c69-51c0-05c1bc2bf660@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52b44a87-7abb-4dc8-88a8-08d99939216a
X-MS-TrafficTypeDiagnostic: BN6PR12MB1858:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1858A98008941BF1486B7FC1D9859@BN6PR12MB1858.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P4sFPlH8dIovYxX1t2Ecvbu/2xFxm5F1t21AUKb8gj22L4rX0brlvgYbvM44wNj8///Tptaf8PaOZPV7rh1PTWTrD2PqRObvNqJ5lln/WnvQJxLitENTObbbOjy3R3mIftu8i3z8tjWK5ERzFFepqoSCKuP2QjrrwESGa7QmzNu47X0sr7R8shVDiC6trV0BX6ZB/z3BOq2wWtd+B63aexNlrtrnd9wp+QlPjrfPzdy+BQD1exxVSz1NTBUC6tq22sn3L6pnHe3X2FDqiGpyuicQJyn6rhnI6VFs7tzZU64YPJ6HJHY+O/5kBwcLOxO1HW0Dkx1vG1Y8tMFShPPwuto/MNGAsd9DRoZ37tDqM7i3UuN4C3eajlYnzB3JdcaNEIooyR/MImme2EC02m3OyG1nFBl1kfNtHSrJzf++Wu5f6yZb/473nEmFrnHgd/gFwaAskW05VONCTyTYFnv+GPCfPxPZLsPijZX5C6B+PhEI4zyAu6O524qWVNdZVFj68I0gD/ut86K0wynIbTS7jeGyK7SqP3btgBre+SOfL88oBpdPRTP8zQ4fK7OCaNdotCLMMuxyZFdXjXadOXUFMyV0laAqaHVF7GGxD6b5cecINw80ctWPArQ66ZRixG0EEnw3+/WG43zK7C5qqL5CMza065OBPx9gE+7MhvQ/fX+hSYpQCt7vOTFIg5f9NS1ljpFx+MJ9FbXAjGN/1iEPL/hXCiXh9FmUz7XlDBzxDxc=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(83380400001)(2906002)(70206006)(31686004)(70586007)(16526019)(82310400003)(426003)(47076005)(31696002)(7636003)(4326008)(54906003)(2616005)(508600001)(45080400002)(356005)(36756003)(316002)(110136005)(36860700001)(186003)(86362001)(8676002)(336012)(26005)(8936002)(53546011)(16576012)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 11:01:30.1441
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52b44a87-7abb-4dc8-88a8-08d99939216a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1858
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/09/2021 07:22, Heiner Kallweit wrote:
> Use new function pci_read_vpd_any() to simplify the code.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>   drivers/pci/vpd.c | 7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/pci/vpd.c b/drivers/pci/vpd.c
> index 286cad2a6..517789205 100644
> --- a/drivers/pci/vpd.c
> +++ b/drivers/pci/vpd.c
> @@ -57,10 +57,7 @@ static size_t pci_vpd_size(struct pci_dev *dev)
>   	size_t off = 0, size;
>   	unsigned char tag, header[1+2];	/* 1 byte tag, 2 bytes length */
>   
> -	/* Otherwise the following reads would fail. */
> -	dev->vpd.len = PCI_VPD_MAX_SIZE;
> -
> -	while (pci_read_vpd(dev, off, 1, header) == 1) {
> +	while (pci_read_vpd_any(dev, off, 1, header) == 1) {
>   		size = 0;
>   
>   		if (off == 0 && (header[0] == 0x00 || header[0] == 0xff))
> @@ -68,7 +65,7 @@ static size_t pci_vpd_size(struct pci_dev *dev)
>   
>   		if (header[0] & PCI_VPD_LRDT) {
>   			/* Large Resource Data Type Tag */
> -			if (pci_read_vpd(dev, off + 1, 2, &header[1]) != 2) {
> +			if (pci_read_vpd_any(dev, off + 1, 2, &header[1]) != 2) {
>   				pci_warn(dev, "failed VPD read at offset %zu\n",
>   					 off + 1);
>   				return off ?: PCI_VPD_SZ_INVALID;
> 


This change is breaking a PCI test that we are running on Tegra124
Jetson TK1. The test is parsing the various PCI devices by running
'lspci -vvv' and for one device I am seeing a NULL pointer
dereference crash. Reverting this change or just adding the line
'dev->vpd.len = PCI_VPD_MAX_SIZE;' back fixes the problem.

I have taken a quick look but have not found why this is failing
so far. Let me know if you have any thoughts.

Cheers
Jon

[   56.577644] 8<--- cut here ---
[   56.580714] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[   56.588836] pgd = da85f9ea
[   56.591545] [00000000] *pgd=00000000
[   56.595124] Internal error: Oops: 80000005 [#1] PREEMPT SMP ARM
[   56.601029] Modules linked in: nouveau drm_ttm_helper ttm tegra_soctherm
[   56.607725] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.15.0-rc2-00004-g7724d929fdde-dirty #5
[   56.616231] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
[   56.622482] PC is at 0x0
[   56.625007] LR is at rcu_core+0x368/0xc5c
[   56.629011] pc : [<00000000>]    lr : [<c01a3384>]    psr: 60000113
[   56.635261] sp : c1201dc8  ip : c35f4b80  fp : c1201df0
[   56.640472] r10: ffffe000  r9 : 00000007  r8 : c135d3a0
[   56.645683] r7 : 0000000a  r6 : c1204f0c  r5 : 00000008  r4 : 00000000
[   56.652193] r3 : c3c33850  r2 : 00000000  r1 : 00000000  r0 : c3c33850
[   56.658703] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   56.665821] Control: 10c5387d  Table: 82e0806a  DAC: 00000051
[   56.671551] Register r0 information: slab kmalloc-64 start c3c33840 pointer offset 16 size 64
[   56.680066] Register r1 information: NULL pointer
[   56.684759] Register r2 information: NULL pointer
[   56.689451] Register r3 information: slab kmalloc-64 start c3c33840 pointer offset 16 size 64
[   56.697964] Register r4 information: NULL pointer
[   56.702655] Register r5 information: non-paged memory
[   56.707693] Register r6 information: non-slab/vmalloc memory
[   56.713338] Register r7 information: non-paged memory
[   56.718375] Register r8 information: non-slab/vmalloc memory
[   56.724020] Register r9 information: non-paged memory
[   56.729057] Register r10 information: non-paged memory
[   56.734183] Register r11 information: non-slab/vmalloc memory
[   56.739914] Register r12 information: slab kmalloc-64 start c35f4b80 pointer offset 0 size 64
[   56.748428] Process swapper/0 (pid: 0, stack limit = 0x54fa894a)
[   56.754419] Stack: (0xc1201dc8 to 0xc1202000)
[   56.758762] 1dc0:                   ???????? ???????? ???????? ???????? ???????? ????????
[   56.766919] 1de0: ???????? ???????? ???????? ???????? ???????? ???????? ???????? ????????
[   56.775076] 1e00: ???????? ???????? ???????? ???????? ???????? ???????? ???????? ????????
[   56.783232] 1e20: ???????? ???????? ???????? ???????? ???????? ???????? ???????? ????????
[   56.791389] 1e40: ???????? ???????? ???????? ???????? ???????? ???????? ???????? ????????
[   56.799545] 1e60: ???????? ???????? ???????? ???????? ???????? ???????? ???????? ????????
[   56.807701] 1e80: ???????? ???????? ???????? ???????? ???????? ???????? ???????? ????????
[   56.815857] 1ea0: ???????? ???????? ???????? ???????? ???????? ???????? ???????? ????????
[   56.824014] 1ec0: ???????? ???????? ???????? ???????? ???????? ???????? ???????? ????????
[   56.832170] 1ee0: ???????? ???????? ???????? ???????? ???????? ???????? ???????? ????????
[   56.840326] 1f00: ???????? ???????? ???????? ???????? ???????? ???????? ???????? ????????
[   56.848482] 1f20: ???????? ???????? ???????? ???????? ???????? ???????? ???????? ????????
[   56.856639] 1f40: ???????? ???????? ???????? ???????? ???????? ???????? ???????? ????????
[   56.864795] 1f60: ???????? ???????? ???????? ???????? ???????? ???????? ???????? ????????
[   56.872951] 1f80: ???????? ???????? ???????? ???????? ???????? ???????? ???????? ????????
[   56.881108] 1fa0: ???????? ???????? ???????? ???????? ???????? ???????? ???????? ????????
[   56.889264] 1fc0: ???????? ???????? ???????? ???????? ???????? ???????? ???????? ????????
[   56.897420] 1fe0: ???????? ???????? ???????? ???????? ???????? ???????? ???????? ????????
[   56.905580] [<c01a3384>] (rcu_core) from [<c0101358>] (__do_softirq+0x130/0x42c)
[   56.912966] [<c0101358>] (__do_softirq) from [<c012bcec>] (irq_exit+0xbc/0x100)
[   56.920262] [<c012bcec>] (irq_exit) from [<c0189388>] (handle_domain_irq+0x60/0x78)
[   56.927906] [<c0189388>] (handle_domain_irq) from [<c051445c>] (gic_handle_irq+0x7c/0x90)
[   56.936071] [<c051445c>] (gic_handle_irq) from [<c0100b7c>] (__irq_svc+0x5c/0x90)
[   56.943538] Exception stack(0xc1201ec0 to 0xc1201f08)
[   56.948574] 1ec0: ???????? ???????? ???????? ???????? ???????? ???????? ???????? ????????
[   56.956731] 1ee0: ???????? ???????? ???????? ???????? ???????? ???????? ???????? ????????
[   56.964888] 1f00: ???????? ????????
[   56.968364] [<c0100b7c>] (__irq_svc) from [<c0865fb8>] (cpuidle_enter_state+0x258/0x4c0)
[   56.976441] [<c0865fb8>] (cpuidle_enter_state) from [<c0866270>] (cpuidle_enter+0x3c/0x54)
[   56.984687] [<c0866270>] (cpuidle_enter) from [<c015c568>] (do_idle+0x200/0x27c)
[   56.992069] [<c015c568>] (do_idle) from [<c015c93c>] (cpu_startup_entry+0x18/0x1c)
[   56.999623] [<c015c93c>] (cpu_startup_entry) from [<c1100fa8>] (start_kernel+0x664/0x6b0)
[   57.007786] Code: bad PC value
[   57.010968] 8<--- cut here ---

-- 
nvpublic
