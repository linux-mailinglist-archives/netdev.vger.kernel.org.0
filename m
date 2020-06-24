Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CC5206DD7
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 09:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389792AbgFXHes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 03:34:48 -0400
Received: from mail-eopbgr50060.outbound.protection.outlook.com ([40.107.5.60]:49216
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388375AbgFXHer (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 03:34:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPwElkBkHBQ6X1dY3UY8m0jWHO3g28+C0B46Pu4A9MwaoZQx/LfC73+J6bHAzCrhpqp8efB8Cox+G9HN7E8Y7JWlxuIglNMr+c0KBA5/Ll++9ZQ1VNv+SSSvEOaadlsn1b0lewUtNToFnHWqf5Xc40sGGF3gXjk6Pwoha1WcIlIBB8GioyO4GpS4MWZEThNkbQKiGWJWfCN2gdc3McdGwZSNRqHLLWCZHWuwewmOLD2h51XoICSQe0K1+6bZKhaW2wgWXxKcaFc0/iTOk91slM1ssdoNYGD7fordZZXiN753DB7G7TJu33/iwHFGCqKVWo+ipN9kYBs91cTndBOsKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p04CvwjJWbs75QxLnYL0TrgnMy1qEC7wXBNEinDKDns=;
 b=fjgrAe5cBFSttwXV5cP6FlIocHYhMOJVr/7vOt9UxrZoFTSKopivrWiktGH0xVrZgHhpezPQK2NPYml3I9OBleGeqr7kwbvycTxjCQE7r5zey8A/iVaTlZTJG+eqIf+ZMolCAebicKG0U/fmFW8JcWRN/lsfksvq8+DG7iPboAEjSg7bGomZg6VKzhTXzufPvZKCfiG1+rVd6HPrP3Wy51dFY+Za0FA8U69TTeO60zmcKh0ZOllsjz7o1VzaC2bN1CsBUXEcv8llBAc/aAL9AHW3IE/JXTNOyGIwOqTrCY0G9OuVKFWorexsmT1Ipt/XYM68GmeLnInAwPO2AU4shA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p04CvwjJWbs75QxLnYL0TrgnMy1qEC7wXBNEinDKDns=;
 b=PfJMiLhLdynS28ShZmnnRkxWA5swge+TLHfRcOvqVm5RW9vag6U1ZjeFOgBC7ofPdrWZo8td7vdxsxokpnZ0QL800niZfgewU5Rr2JRxehwaYPRBhzeXlZWJJIIGhV+V1M9uraAm6qmWW27ou9hpMX/AWq8s7VENzf7gOGbe0P8=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from DBBPR05MB6299.eurprd05.prod.outlook.com (2603:10a6:10:d1::21)
 by DBBPR05MB6474.eurprd05.prod.outlook.com (2603:10a6:10:c8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Wed, 24 Jun
 2020 07:34:43 +0000
Received: from DBBPR05MB6299.eurprd05.prod.outlook.com
 ([fe80::a406:4c1a:8fd0:d148]) by DBBPR05MB6299.eurprd05.prod.outlook.com
 ([fe80::a406:4c1a:8fd0:d148%4]) with mapi id 15.20.3109.027; Wed, 24 Jun 2020
 07:34:43 +0000
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>
Cc:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
References: <20200623195229.26411-1-saeedm@mellanox.com>
 <20200623195229.26411-11-saeedm@mellanox.com>
 <20200623143118.51373eb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <dda5c2b729bbaf025592aa84e2bdb84d0cda7570.camel@mellanox.com>
From:   Aya Levin <ayal@mellanox.com>
Message-ID: <082c6bfe-5146-c213-9220-65177717c342@mellanox.com>
Date:   Wed, 24 Jun 2020 10:34:40 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
In-Reply-To: <dda5c2b729bbaf025592aa84e2bdb84d0cda7570.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0016.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::26) To DBBPR05MB6299.eurprd05.prod.outlook.com
 (2603:10a6:10:d1::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.13] (77.138.160.220) by FR2P281CA0016.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Wed, 24 Jun 2020 07:34:42 +0000
X-Originating-IP: [77.138.160.220]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7b87b648-0253-4ffe-00a8-08d818110fef
X-MS-TrafficTypeDiagnostic: DBBPR05MB6474:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR05MB6474DFBF6234A42D89984DD7B0950@DBBPR05MB6474.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WF/+62EMzBiBFEZ0JwHJHKnAOogWbEWUrKBGfF+msKdQWl3kwBT7f/6Q4LaI3YvkdhkOOVtkAEpncwYXx5uYZc+N578XRNnzXpbInwk2LyMxeL1YUf7dNkGdd8D9H1ZPmdeX6BUFPoMkyosYjgWc/37YvrCArLzv27vuEn5T/6cAs2j9sjxemXIUJ/pFgcgB8tGjeXm+hXy0hGiGCCRlkQBefJznVV7T39TY4qVNyJCJvDHXRE+T3nxq+dpzQc+jywF/f8eJEp5H7UbKfigaSKS2r+GYfhQ8AvrI61t/hiHXHHkttx9gpDr6Vkrk8/jWl1LNI81v+rY85+b1KsEUwfcKJeJwJsrwbZiX6ygqOd4TVOeC8s8ri2og2wzD3/pX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR05MB6299.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(396003)(366004)(346002)(136003)(376002)(16576012)(316002)(83380400001)(54906003)(110136005)(2616005)(478600001)(6486002)(956004)(53546011)(66946007)(8936002)(186003)(16526019)(66556008)(5660300002)(8676002)(86362001)(107886003)(26005)(66476007)(31696002)(4326008)(36756003)(52116002)(2906002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kExuHdvWpyzdVJudzO0cunhqmKoRTLTV3/3+b5xftyYXNbuIFU2Wc4JQRES34uSXEjb58ARGtIosLvgx3lZ+zOZfktGMmNY4I/EZIEmODBd9bpEfA9ZSVErZegNVlwMX63u49RQ/9UF5gdqNe/JqAKfwlRveBoXzHOQ7GG8h+LPYws0+tZvrJpv9ORtLCB0h4+GujUv6sfV76JSEctg9XI4p3QcLC57lNvZhA3O/cfk43BwEtMi3mW8xJTq8zOh4xrfUYVfvj34xgwmqxTuks30CzBpdB/AUIGGG9PpTYWqQ8CgvfVHZHfOPG7SWQHis3h4oTI/EFz/gKciwEQy9kAxmSebziO9zF8jE475kcVzig1uP3YB0r8SjtohOZqTCvWnHlFU0Jk1i1YCLe5/Wp5OILhHDLZyKK2Bur4VHWfXPBA87E61AvJFjO4l6FJKSnUwJWi928gdP8UFuuECLnGlxynse2AxJpbBdge33ZjGowxC+C2/x/iZzwt7HpgBU
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b87b648-0253-4ffe-00a8-08d818110fef
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 07:34:43.5076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZEmPtPgpAbdBmaHVDgIC1JfndNrbGbHwGWIXeexWsZB0gE9mkS0ukSlpPkjL3Wp0FJRxyT/UqtBlwJE3AsSpBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6474
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/2020 9:56 AM, Saeed Mahameed wrote:
> On Tue, 2020-06-23 at 14:31 -0700, Jakub Kicinski wrote:
>> On Tue, 23 Jun 2020 12:52:29 -0700 Saeed Mahameed wrote:
>>> From: Aya Levin <ayal@mellanox.com>
>>>
>>> The concept of Relaxed Ordering in the PCI Express environment
>>> allows
>>> switches in the path between the Requester and Completer to reorder
>>> some
>>> transactions just received before others that were previously
>>> enqueued.
>>>
>>> In ETH driver, there is no question of write integrity since each
>>> memory
>>> segment is written only once per cycle. In addition, the driver
>>> doesn't
>>> access the memory shared with the hardware until the corresponding
>>> CQE
>>> arrives indicating all PCI transactions are done.
>>
> 
> Hi Jakub, sorry i missed your comments on this patch.
> 
>> Assuming the device sets the RO bits appropriately, right? Otherwise
>> CQE write could theoretically surpass the data write, no?
>>
> 
> Yes HW guarantees correctness of correlated queues and transactions.
> 
>>> With relaxed ordering set, traffic on the remote-numa is at the
>>> same
>>> level as when on the local numa.
>>
>> Same level of? Achievable bandwidth?
>>
> 
> Yes, Bandwidth, according the below explanation, i see that the message
> needs improvements.
> 
>>> Running TCP single stream over ConnectX-4 LX, ARM CPU on remote-
>>> numa
>>> has 300% improvement in the bandwidth.
>>> With relaxed ordering turned off: BW:10 [GB/s]
>>> With relaxed ordering turned on:  BW:40 [GB/s]
>>>
>>> The driver turns relaxed ordering off by default. It exposes 2
>>> boolean
>>> private-flags in ethtool: pci_ro_read and pci_ro_write for user
>>> control.
>>>
>>> $ ethtool --show-priv-flags eth2
>>> Private flags for eth2:
>>> ...
>>> pci_ro_read        : off
>>> pci_ro_write       : off
>>>
>>> $ ethtool --set-priv-flags eth2 pci_ro_write on
>>> $ ethtool --set-priv-flags eth2 pci_ro_read on
>>
>> I think Michal will rightly complain that this does not belong in
>> private flags any more. As (/if?) ARM deployments take a foothold
>> in DC this will become a common setting for most NICs.
> 
> Initially we used pcie_relaxed_ordering_enabled() to
>   programmatically enable this on/off on boot but this seems to
> introduce some degradation on some Intel CPUs since the Intel Faulty
> CPUs list is not up to date. Aya is discussing this with Bjorn.
Adding Bjorn Helgaas
> 
> So until we figure this out, will keep this off by default.
> 
> for the private flags we want to keep them for performance analysis as
> we do with all other mlx5 special performance features and flags.
> 
