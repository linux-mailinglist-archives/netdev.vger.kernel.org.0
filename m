Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B067218219
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 10:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgGHIWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 04:22:25 -0400
Received: from mail-eopbgr130071.outbound.protection.outlook.com ([40.107.13.71]:30691
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725747AbgGHIWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 04:22:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCcfh68TRzUtxcmw0QJyN7bbb8fTNphpOFLssfbvrRa+OamYJ5D8i8jq2XFFHmx4+FYAECYxk5gE2Rn3wKm1OIp09TgWTKagVjWUibU+4XXkEc/E7KfdasB+ZOmFg5yPewn6Y49D7qcrFWnt5h7UG2m1tPPRid1MIX9AnIETXf8ZMIGn5itPYevbCxjL6Xuk0sUwQMg+IBda97HLbON0nZsZ7u8BmjyduDA3/yj2/OxO8MYPhXEcVMh4yo8VVJYcUJLaYqQQmSJkqFRV3gZ2zYrSdrQQUilxoHajdZIroiaQUphashnMvalgjcT9o204RrMglbZuoALOJjhuCQffmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3fc+lhzzQqUfmd2KRWl3EvOelVBtv/ffKuyUSZK429c=;
 b=AwYrwzJ0iFEENWCvdYRon6JZyIa28KrvfM/90ceUpANfV0FDrybkTSQzbMP02hQrz7pGA1xdKmUMBimPOa9WPl977knPoxPweiieXaeCS/+rcMMwonrHlWFj6/Gxy2WjQ3fhEsWbPi8b9EKTYynR/7xJ1y7e32ON7XeneIi6c2pRFKqCmaVoW1wDUMoLDRMw7lzD1ZasY02k/l04dzO3eCF5vPs73zubU1xyG1fxCwmg3kuPjSekhQTwvlMazGjxr9H7qaaTb5JPNnaZePAKg33g6V08y2G/J6wigeFnmsCyG0Q3hRl8OoT62o5nj8RG+4sGxtKFa3vVPsjakUH6QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3fc+lhzzQqUfmd2KRWl3EvOelVBtv/ffKuyUSZK429c=;
 b=Svvui7KSIhMkgQNKnLm5BbnNT+E6qrpUaTEtFgwuPnFah65VhMqdCC22lEHzBHH8fn0trQQ0ctYKAhLSJcZaGriD3393ky5azz9TfYERdf2MoKfLm4WkdVCRYEAg53+e7Le6BPRM/BgbyvWPCGfrB04RjjlYA+bLvvJJmFUmGTI=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=mellanox.com;
Received: from DBBPR05MB6299.eurprd05.prod.outlook.com (2603:10a6:10:d1::21)
 by DB6PR0501MB2519.eurprd05.prod.outlook.com (2603:10a6:4:59::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Wed, 8 Jul
 2020 08:22:19 +0000
Received: from DBBPR05MB6299.eurprd05.prod.outlook.com
 ([fe80::a406:4c1a:8fd0:d148]) by DBBPR05MB6299.eurprd05.prod.outlook.com
 ([fe80::a406:4c1a:8fd0:d148%4]) with mapi id 15.20.3153.030; Wed, 8 Jul 2020
 08:22:19 +0000
From:   Aya Levin <ayal@mellanox.com>
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
To:     David Miller <davem@davemloft.net>, helgaas@kernel.org
Cc:     kuba@kernel.org, saeedm@mellanox.com, mkubecek@suse.cz,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        tariqt@mellanox.com, alexander.h.duyck@linux.intel.com,
        Jason Gunthorpe <jgg@nvidia.com>
References: <19a722952a2b91cc3b26076b8fd74afdfbfaa7a4.camel@mellanox.com>
 <20200624133018.5a4d238b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7b79eead-ceab-5d95-fd91-cabeeef82d6a@mellanox.com>
 <20200706.124947.1335511480336755384.davem@davemloft.net>
Message-ID: <0506f0aa-f35e-09c7-5ba0-b74cd9eb1384@mellanox.com>
Date:   Sun, 8 Jul 2040 11:22:12 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200706.124947.1335511480336755384.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GV0P278CA0040.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:29::9) To DBBPR05MB6299.eurprd05.prod.outlook.com
 (2603:10a6:10:d1::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a00:a040:198:1259:c900:5671:dddb:1adc] (2a00:a040:198:1259:c900:5671:dddb:1adc) by GV0P278CA0040.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:29::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22 via Frontend Transport; Wed, 8 Jul 2020 08:22:16 +0000
X-Originating-IP: [2a00:a040:198:1259:c900:5671:dddb:1adc]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3920edb9-2a84-4a26-977a-08d8231807b6
X-MS-TrafficTypeDiagnostic: DB6PR0501MB2519:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0501MB2519FF70E9D30C834B11BAC8B0670@DB6PR0501MB2519.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04583CED1A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EMpGWuw0qBvQlUt+3/nLoIp7IP9X68ijz4VRcDdcL8H1UI7qECk5w8rH4crOJnwQOen+4MA7h+VbV5ncPnz3Mkr+ZBg3mgXll7fxetACtoWkiaHX59imWmVEW+b01tzcSsJcFwM1h93GxLEpHNtshQdTvYsfBa4C0OhMPB9qErjznV0nRaXYMptshL/1jRaYG6QeTjhGCKEFkWDAB3+RJFIcJr9WCi1mo9Kx8RNv/PMlTK2hH1B3daX8ltp4e7u5uGjPP3VqgZ4AL7ZJsFWYJDey2U2wS39r+eUde6wjiVt1h2/d5+gLDUNyPYba8bh0gQh4AMnfCWRMkSSjSNiKh6UaU41mtCLfnYlv9EvLCtDmM42YzMsdPDkueRJ1LExYlUTrzqL4OMzUCjniVvxrWwVjgWC7E8sy/LVSc8Vm1V0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR05MB6299.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(4326008)(2906002)(2616005)(316002)(6486002)(83380400001)(31686004)(16526019)(186003)(36756003)(86362001)(66946007)(31696002)(52116002)(8676002)(8936002)(53546011)(6666004)(66556008)(66476007)(5660300002)(478600001)(22166003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lxTJo8BjXBxjjBcB7WHNqKSTRVtixScwGfIfLAPmpBA87YQ0vm7EgN6+BFehuxYqd2GEa2oTNixIi/kCmW0aYjCBSVpvIu/nfey7HbguK0Mwk1OaIoCrXOqjOIVQ21EtM9Ke44gRucp7nuFE6TKri15J2YYdC2g4YSm4GLx8fFWSaX7/DN6g5LB3eWijd15J6CGXXFyWuB5HBUPZxaG6XFw7BQra94rzj4BaMw/XC5ABPqOL9mN+B1Amf3b/OEOajXMzlSo48p2DjCyExwQtzMtbPO/sZIJH3yh0lfSlz4sAh6Z0+PkzYkIuBFW8yVOnDbG2lDsiTMzmZkHJkXN/Lih8c74lCjeZO5NYdegElKeobaI3uON7UuT26yiUDZi02aMb+Tr5GR/YXe4ylxJlNze3BYIt5UzhaTQ0a28AgU3qDP4GCe4t+3VoQ3ePQ/y9G8Z9hcN8gBZuPC0gi0xUAeTALrW+6fxYps5vU/qLz0ENa/S3n4bxM2WdtmaNzI9XBJ2m0Yq9TX/q/p6xtPz9b/7t1+gD+27GAATVu10/nUBEWDvWX5qMLsShtA7xi8lN
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3920edb9-2a84-4a26-977a-08d8231807b6
X-MS-Exchange-CrossTenant-AuthSource: DBBPR05MB6299.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 08:22:19.1127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b3tmkbVifl/cTFMERW8BufJztzwEDQh2PNU52i/QfmlEmt7boDC/cdUi19J9vRycA2jgwEd1ZFhhHiExNm0T5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2519
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/6/2020 10:49 PM, David Miller wrote:
> From: Aya Levin <ayal@mellanox.com>
> Date: Mon, 6 Jul 2020 16:00:59 +0300
> 
>> Assuming the discussions with Bjorn will conclude in a well-trusted
>> API that ensures relaxed ordering in enabled, I'd still like a method
>> to turn off relaxed ordering for performance debugging sake.
>> Bjorn highlighted the fact that the PCIe sub system can only offer a
>> query method. Even if theoretically a set API will be provided, this
>> will not fit a netdev debugging - I wonder if CPU vendors even support
>> relaxed ordering set/unset...
>> On the driver's side relaxed ordering is an attribute of the mkey and
>> should be available for configuration (similar to number of CPU
>> vs. number of channels).
>> Based on the above, and binding the driver's default relaxed ordering
>> to the return value from pcie_relaxed_ordering_enabled(), may I
>> continue with previous direction of a private-flag to control the
>> client side (my driver) ?
> 
> I don't like this situation at all.
> 
> If RO is so dodgy that it potentially needs to be disabled, that is
> going to be an issue not just with networking devices but also with
> storage and other device types as well.
> 
> Will every device type have a custom way to disable RO, thus
> inconsistently, in order to accomodate this?
> 
> That makes no sense and is a terrible user experience.
> 
> That's why the knob belongs generically in PCI or similar.
> 
Hi Bjorn,

Mellanox NIC supports relaxed ordering operation over DMA buffers. 
However for debug prepossess we must have a chicken bit to disable 
relaxed ordering on a specific system without effecting others in 
run-time. In order to meet this requirement, I added a netdev 
private-flag to ethtool for set RO API.

Dave raised a concern regarding embedding relaxed ordering set API per 
system (networking, storage and others). We need the ability to manage 
relaxed ordering in a unify manner. Could you please define a PCI 
sub-system solution to meet this requirement?

Aya.
