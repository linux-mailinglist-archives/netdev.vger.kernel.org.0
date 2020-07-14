Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC9321EE49
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 12:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbgGNKr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 06:47:28 -0400
Received: from mail-db8eur05on2073.outbound.protection.outlook.com ([40.107.20.73]:6138
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725884AbgGNKr1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 06:47:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K8M7K1lU+8L49wkdahx5xE90p3mNELIrVrrs23wUlnNOKjvYOEvnTJ84PV+G0gqBVuwEXuTYdDp3XWPW6sgDriYfSjEVGpNMCYxNasSfF1hhlXbdYHB1S3yKk4nJmnxkJwhMr/wRMUr+uDntGnLkrFWH4lJPYtEpUVAHlo7m6uFFPEaYnzg0m6/9NDtwm4YDWEr46V7Sn0xzUzFnCEaLCJrdChsFlQZjJqd2TwlvrFeruP/2mUdUtrlOw84ZUs947Tx4vRRotBN1/AZed6zPpqq13upZPu/fOqMAM6DiVOBusLCe5Yy419Gz5qRfQL89gNADs2AdXYFI5IVdPtT7fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TfjBPUayx6iZB8uFkbJhsTPZrMdkufhb2V41kAFdZd8=;
 b=MiuMbS+FXH7vhD3VVp0M4+EmoJHWM4e8s4ftfmekX9idCNbK/TIQxDjkUsXWRXBitXPdO398Ludifdmtcxp1CjIpNs6f7e1/Y4e3hjdD5pc+vpJDx3JGY9kxJmr63nv5XaqTllMO2VB5fnLe2kFIZu3+3rYyey/uFSG9ePyFLzZSpDKhi6ur75IBk/wxLMZ8jBhWvUpn0Ubf52vzA5yYhaolGFbwQMn40wWARIsy/g+xty2ExkP8XMMRLycfP9GGVnxnUTxulG0xm6fBNfZVBzWQzjRLES6yQzgRclnTftqNMPK+R3vBqA7jPQ0GXtCp0JNjC8f06nmQFYBilSP0BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TfjBPUayx6iZB8uFkbJhsTPZrMdkufhb2V41kAFdZd8=;
 b=EbEHyNT6BgDJ/ohb+PQah9tGug+744tZITrpzW0NrCILGnwyYdYJ95lVRI1g3UzsjIaEngM5AxHBEz9B2QOrel+Ed2E8z0RefGK54mpxA/4XQQXUhexLbGQcQUZxd1fo8vxDiwGfrM1/J+iC4PF1AKVV7U0qn5bGIeRHEOFduDc=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=mellanox.com;
Received: from DBBPR05MB6299.eurprd05.prod.outlook.com (2603:10a6:10:d1::21)
 by DB8PR05MB6011.eurprd05.prod.outlook.com (2603:10a6:10:af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Tue, 14 Jul
 2020 10:47:19 +0000
Received: from DBBPR05MB6299.eurprd05.prod.outlook.com
 ([fe80::a406:4c1a:8fd0:d148]) by DBBPR05MB6299.eurprd05.prod.outlook.com
 ([fe80::a406:4c1a:8fd0:d148%4]) with mapi id 15.20.3174.026; Tue, 14 Jul 2020
 10:47:19 +0000
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        saeedm@mellanox.com, mkubecek@suse.cz, linux-pci@vger.kernel.org,
        netdev@vger.kernel.org, tariqt@mellanox.com,
        alexander.h.duyck@linux.intel.com, Jason Gunthorpe <jgg@nvidia.com>
References: <20200708231630.GA472767@bjorn-Precision-5520>
From:   Aya Levin <ayal@mellanox.com>
Message-ID: <5ecc588d-6397-37e4-3104-a32a639312f0@mellanox.com>
Date:   Tue, 14 Jul 2020 13:47:15 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200708231630.GA472767@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0051.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::31) To DBBPR05MB6299.eurprd05.prod.outlook.com
 (2603:10a6:10:d1::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.15] (37.142.4.236) by AM0PR10CA0051.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Tue, 14 Jul 2020 10:47:18 +0000
X-Originating-IP: [37.142.4.236]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fec4c0d4-1cd5-46b1-d32c-08d827e3481e
X-MS-TrafficTypeDiagnostic: DB8PR05MB6011:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR05MB6011AEBD2D64FF4A5A0CF290B0610@DB8PR05MB6011.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xnQektjblI9Ut3RYxdCJnwVWG8Lb528LgxCJ06qN+PgFvXc/v+yy/GBFcUkliV/OplK0Z7Lq0J+exG8Bp5QcU80Q10DXbRT0fTKco6zHUXEpDjyjiKb2LFG8jiNK4THYdeQVytlmCNYeHxM1CfPZUUFKDMfttgQ4OR5KacL3cFjzbidlM/jg2saxhHWSY/zpaB9uxpHzihcyrzzt0h0SstKEKYaq+keLAUlKJ0i6IQrxlJHmq76yHm/5psk3XbMBqTsn7rbHBfF+MLQVRlIsDCMS6YCysnWB7gw1Oh7O4ZLUoFWDBpZA9gDgGp24pETI5NnlwlPDO1aZmW9psqrciQ7Hh8b1oRy99NoouE/li+5K+aKXzjS+pM7kGk2wob1SAwSnLIU8SQ4XE1f/AycvYuaR3tf9LutoBIX+nUDd4A9kH0mkKyy8rvQYqOSsQYpPLhk6COpYMQlREqjsMbg0kg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR05MB6299.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(83380400001)(31686004)(478600001)(6916009)(6666004)(31696002)(16526019)(4326008)(26005)(966005)(186003)(36756003)(54906003)(16576012)(5660300002)(316002)(2616005)(86362001)(956004)(66946007)(8676002)(66556008)(6486002)(52116002)(2906002)(66476007)(53546011)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9Ta78K0dgntt9BS7JY/bJEse+YuBKY+ERrcE8lU+swm7P+TyUQT2Wl4/kQxsVejr1B+Q2CtdKxw76Cw9ESTAeYtblMHnyuR68Yhg86qKODnDapz4OWN9wk5GJ41OmBFc5LaUE7y+zrXvYTFtUy1PxxVDNRF5Z6AGWGLqGBmhxhY3NwEGejo1PuHK0sp8F0XTwoKasWOhR2z8w/CZe4G6S+yWiCl2GvpCfeKGZ7FY81sggbVCWHMDwmiDYYrqJHGiI1/h7CRigaDVJgHb1nhdVrFHFY1o3UXJkBxr2jvbgzVWyeJY39jANPnV70CZMiPhGeMgjrdEr2RuNO0wMPgwhmN0KkWBNNUpHJvcG39c4vbbNDlRoIl1wuMTfNy02srmHBYr31K66am95t0aQylidfJ85y9+g47oQCEwvqoxE8Wg2pVqvSHPATIGKrSwCheFd/XFS1yCKFQpopFCZMREmk1pNaKVZSZb7XSt0tQHG28=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fec4c0d4-1cd5-46b1-d32c-08d827e3481e
X-MS-Exchange-CrossTenant-AuthSource: DBBPR05MB6299.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 10:47:19.5113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0+sxVdQwSlhsDq8cpSXOqev4aOsMFDi+we8UDUpLd+/+w9tW2DzlBUn+BD6nHXBrVnTxTJxbjxJfQ7p8zwJKsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6011
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/9/2020 2:16 AM, Bjorn Helgaas wrote:
> On Sun, Jul 08, 2040 at 11:22:12AM +0300, Aya Levin wrote:
>> On 7/6/2020 10:49 PM, David Miller wrote:
>>> From: Aya Levin <ayal@mellanox.com>
>>> Date: Mon, 6 Jul 2020 16:00:59 +0300
>>>
>>>> Assuming the discussions with Bjorn will conclude in a well-trusted
>>>> API that ensures relaxed ordering in enabled, I'd still like a method
>>>> to turn off relaxed ordering for performance debugging sake.
>>>> Bjorn highlighted the fact that the PCIe sub system can only offer a
>>>> query method. Even if theoretically a set API will be provided, this
>>>> will not fit a netdev debugging - I wonder if CPU vendors even support
>>>> relaxed ordering set/unset...
>>>> On the driver's side relaxed ordering is an attribute of the mkey and
>>>> should be available for configuration (similar to number of CPU
>>>> vs. number of channels).
>>>> Based on the above, and binding the driver's default relaxed ordering
>>>> to the return value from pcie_relaxed_ordering_enabled(), may I
>>>> continue with previous direction of a private-flag to control the
>>>> client side (my driver) ?
>>>
>>> I don't like this situation at all.
>>>
>>> If RO is so dodgy that it potentially needs to be disabled, that is
>>> going to be an issue not just with networking devices but also with
>>> storage and other device types as well.
>>>
>>> Will every device type have a custom way to disable RO, thus
>>> inconsistently, in order to accomodate this?
>>>
>>> That makes no sense and is a terrible user experience.
>>>
>>> That's why the knob belongs generically in PCI or similar.
>>>
>> Hi Bjorn,
>>
>> Mellanox NIC supports relaxed ordering operation over DMA buffers.
>> However for debug prepossess we must have a chicken bit to disable
>> relaxed ordering on a specific system without effecting others in
>> run-time. In order to meet this requirement, I added a netdev
>> private-flag to ethtool for set RO API.
>>
>> Dave raised a concern regarding embedding relaxed ordering set API
>> per system (networking, storage and others). We need the ability to
>> manage relaxed ordering in a unify manner. Could you please define a
>> PCI sub-system solution to meet this requirement?
> 
> I agree, this is definitely a mess.  Let me just outline what I think
> we have today and what we're missing.
> 
>    - On the hardware side, device use of Relaxed Ordering is controlled
>      by the Enable Relaxed Ordering bit in the PCIe Device Control
>      register (or the PCI-X Command register).  If set, the device is
>      allowed but not required to set the Relaxed Ordering bit in
>      transactions it initiates (PCIe r5.0, sec 7.5.3.4; PCI-X 2.0, sec
>      7.2.3).
> 
>      I suspect there may be device-specific controls, too, because [1]
>      claims to enable/disable Relaxed Ordering but doesn't touch the
>      PCIe Device Control register.  Device-specific controls are
>      certainly allowed, but of course it would be up to the driver, and
>      the device cannot generate TLPs with Relaxed Ordering unless the
>      architected PCIe Enable Relaxed Ordering bit is *also* set.
> 
>    - Platform firmware can enable Relaxed Ordering for a device either
>      before handoff to the OS or via the _HPX ACPI method.
> 
>    - The PCI core never enables Relaxed Ordering itself except when
>      applying _HPX.
> 
>    - At enumeration-time, the PCI core disables Relaxed Ordering in
>      pci_configure_relaxed_ordering() if the device is below a Root
>      Port that has a quirk indicating an erratum.  This quirk currently
>      includes many Intel Root Ports, but not all, and is an ongoing
>      maintenance problem.
> 
>    - The PCI core provides pcie_relaxed_ordering_enabled() which tells
>      you whether Relaxed Ordering is enabled.  Only used by cxgb4 and
>      csio, which use that information to fill in Ingress Queue
>      Commands.
> 
>    - The PCI core does not provide a driver interface to enable or
>      disable Relaxed Ordering.
> 
>    - Some drivers disable Relaxed Ordering themselves: mtip32xx,
>      netup_unidvb, tg3, myri10ge (oddly, only if CONFIG_MYRI10GE_DCA),
>      tsi721, kp2000_pcie.
> 
>    - Some drivers enable Relaxed Ordering themselves: niu, tegra.
> 
> What are we missing and what should the PCI core do?
> 
>    - Currently the Enable Relaxed Ordering bit depends on what firmware
>      did.  Maybe the PCI core should always clear it during
>      enumeration?
> 
>    - The PCI core should probably have a driver interface like
>      pci_set_relaxed_ordering(dev, enable) that can set or clear the
>      architected PCI-X or PCIe Enable Relaxed Ordering bit.
> 
>    - Maybe there should be a kernel command-line parameter like
>      "pci=norelax" that disables Relaxed Ordering for every device and
>      prevents pci_set_relaxed_ordering() from enabling it.
> 
>      I'm mixed on this because these tend to become folklore about how
>      to "fix" problems and we end up with systems that don't work
>      unless you happen to find the option on the web.  For debugging
>      issues, it might be enough to disable Relaxed Ordering using
>      setpci, e.g., "setpci -s02:00.0 CAP_EXP+8.w=0"
> 
> [1] https://lore.kernel.org/netdev/20200623195229.26411-11-saeedm@mellanox.com/
> 
Hi Bjorn,

Thanks for the detailed reply. From initial testing I can say that 
turning off the relaxed ordering on the PCI (setpci -s02:00.0 
CAP_EXP+8.w=0) is the chicken bit I was looking for.
This lower the risk of depending on pcie_relaxed_ordering_enabled(). I 
will update my patch and resubmit.

Thanks,
Aya
