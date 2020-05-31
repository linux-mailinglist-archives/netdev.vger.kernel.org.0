Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA531E976D
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgEaMGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:06:53 -0400
Received: from mail-am6eur05on2049.outbound.protection.outlook.com ([40.107.22.49]:11424
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725898AbgEaMGw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 08:06:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBLudxMF6JSvSRId1D0nMpl1zumkKu5ckyvxcANGfdREsmfHHlvIXWmxgDcXq63px1abeBodJ0v6TosVKbpQgo8O930/6jzazlV+ssrbhGwzMhGjOhPNe7gbMbzWcw7/7ODehV33GFP+IdS6B/WtiXsVWgVM5OFLd8SToRc+lh3NGHBkTYk41Ba5On1AlWMpS0VYe/OaAd1djD3LCHdDBYgJHXa22duacUC/5RjqjSRmzmOhWhIvWicfqVtv4Jc2zJX1HhOnfyDgOiMhl2EqaxlbdKl0NubB9PUc17nmsljQxAKVWBgb8hrq9Q4Tm1zQBn8Dav86yTQA5LK9B93apg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eI3U6lwNuxZSimD863B0k3xcofRmSszuDHaG8hCmlcc=;
 b=I4TzwrRMIIKh48kwDSXYewkWOwkfrcEiApZWLy9oNnCNpWY4Rrohwc6DKW42po1cRYZQwiYZZNru3a9+ddd2A4moOIu6QB7tdW49u6Xa+pB/ZcpwdDQ7UFlgJBP6QiQbUeQf7yHOfgMF3cuAmXAxS4VD04J9TTKaEbj8ePIvKS4sIm9CVopWL2cyy/TCYrSmJHBlgOyRS1LtKR6F5LznuSLjZfoACc/HER3L2I3iOfizRcyknka8/K6ccBVMbEW6OGNaYOWDFWByng0ykJoAuMnpHua6UosgYNv/wpBnw3yoRbSFw2wUlclVz5CXbwJ2Zc5X6DU1UcfANhGKn1exUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eI3U6lwNuxZSimD863B0k3xcofRmSszuDHaG8hCmlcc=;
 b=M668nmJ/PjQGleZ4Ip1aOoVbBJwsNJcujbzt6c83/QMIXMdZYZ5KKuCG6eWhNkA/SuefTET11ncB/Mdtk5KzKMxx9Gr0irrrv3J0gCsNNrPqbCYQJk/PwK8S2mFoE0hV0XzQZAj3Gn3foasfSW/+YZHbK2jxFQ+LqkGA7sQYGj8=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com (2603:10a6:20b:1ac::19)
 by AM7PR05MB7025.eurprd05.prod.outlook.com (2603:10a6:20b:1a7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.22; Sun, 31 May
 2020 12:06:49 +0000
Received: from AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::3d04:fdc3:1002:732f]) by AM7PR05MB7092.eurprd05.prod.outlook.com
 ([fe80::3d04:fdc3:1002:732f%8]) with mapi id 15.20.3045.022; Sun, 31 May 2020
 12:06:48 +0000
Subject: Re: [net-next 10/11] net/mlx5e: kTLS, Add kTLS RX resync support
To:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
 <20200529194641.243989-11-saeedm@mellanox.com>
 <20200529131631.285351a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <e0b8a4d9395207d553e46cb28e38f37b8f39b99d.camel@mellanox.com>
 <20200529145043.5d218693@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Boris Pismenny <borisp@mellanox.com>
Message-ID: <27149ee9-0483-ecff-a4ec-477c8c03d4dd@mellanox.com>
Date:   Sun, 31 May 2020 15:06:28 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
In-Reply-To: <20200529145043.5d218693@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0076.eurprd02.prod.outlook.com
 (2603:10a6:208:154::17) To AM7PR05MB7092.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ac::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.11] (213.57.108.142) by AM0PR02CA0076.eurprd02.prod.outlook.com (2603:10a6:208:154::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Sun, 31 May 2020 12:06:47 +0000
X-Originating-IP: [213.57.108.142]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b0324142-0fe3-4b02-7a0b-08d8055b18be
X-MS-TrafficTypeDiagnostic: AM7PR05MB7025:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB70258F9804BE29EEC7CC23CEB08D0@AM7PR05MB7025.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0420213CCD
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GgJDEdxRTg3lyj0IKHgZWynQFRL8ejwPk7Yp3tRUGSp3WpUkIOAd+WhGFNHCddsSEm2QExqeMM+Jc+wg2peaA4lE12Khr1kqDnlXw7pf3r6xu2CRtiTX/O8D4apEoeqmpEq8tI3NeKadcmcMK07P6bDVPIywznNwVJtm/ZT/nJWNN1zKYWqPeBN78pgve89/vwUgzfIVz1MpHNBX2TDiFuLiRZx2nr+tl4IvTCVRTeETf6AhdzwfelwXMVNfDjaj9dmC9zLz1m2zRDxaCi3ip2zZfev5eixcATJ7nze+QJJ1TWcF77IvN8/oqtj9GVS7nygVJ0Z7ko6/4Xn1gXK8aYicT0yDJ2PbNOpP0mkJ6ypNAf3rume440oXB5qadAeV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB7092.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(31686004)(31696002)(53546011)(86362001)(52116002)(54906003)(2616005)(186003)(16526019)(8936002)(8676002)(16576012)(110136005)(6486002)(316002)(26005)(66556008)(66476007)(66946007)(4326008)(107886003)(5660300002)(36756003)(6666004)(2906002)(83380400001)(478600001)(6636002)(956004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GT4XWl305sKOSdewzCnGj13uXRfAIk9jhdq99Spo20yLsn/ICA7halHtO0iYmiFIsthUiZPUD31ZBx7qLJ4R1q2Wdm5oaGn/4aLVEdFE2Ybx5CAAPFUcNqWXH+DiS3p2CHGMk/+UqgOSSCW1gt7C1uE8G/zRJqvYafdwWflSTFtBS4iKd1sFXYQ5+bGdmNTe0wYMqD4UxK3cmcsKgrNP33q+0KwPJuTThdnD49H3Dp/iGU8xsPBe2vzDr0FiJ4ZCQ7eRjcjtTEjh08pAaHZRceNmNpgtZ4bJn0fObyM7FH89sV2HK7ov/3VY3aOlzHIyWBEDewc+HoPD+U904znx08xLgQ5h/bYHfEiXgLuvO+R4Uf3Fv96StK5PFcsqXe4v6ip8HcPbZoA599xAscI+jzMUljMPtVs50YAJzaxBYIi6glFxAAPw3ge7DvZGV8NYwB6nL9IlQMwD94vC6fv8seCAOvYYtvnxL8IGXhocQteG8wbh32RbWoNIq54Yn9/I
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0324142-0fe3-4b02-7a0b-08d8055b18be
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2020 12:06:48.9568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fnnl9lv9ubHHbbMl7A1Yghww8hgR9L5N1YSmADcxc8oCR+u2wWpW5lGfUmrCK0RNpakCkvnQBLDkR5EPCvY9sQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB7025
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/05/2020 0:50, Jakub Kicinski wrote:
> On Fri, 29 May 2020 20:44:29 +0000 Saeed Mahameed wrote:
>>> I thought you said that resync requests are guaranteed to never fail?
>>
>> I didn't say that :),  maybe tariq did say this before my review,
> 
> Boris ;)
> 

I didn't say we are perfect, just that we can make a trade-off here, and currently this is the simplest version that our team came up with for this series.
As a first step, I think it is reasonable. But, I expect that we will improve it in the future.

>> but basically with the current mlx5 arch, it is impossible to guarantee
>> this unless we open 1 service queue per ktls offloads and that is going
>> to be an overkill!

I disagree, there are many ways to guarantee reliability here. For example, we can sleep/spin until there is space in the queue or rely on work stealing to let a later operation execute this one.

> 
> IIUC every ooo packet causes a resync request in your implementation -
> is that true?
> 

No, only header loss. We never required a resync per OOO packet. I'm not sure why would you think that.

> It'd be great to have more information about the operation of the
> device in the commit message..
> 

I'll try to clarify the resync flow here.
As always, the packet that requires resync is marked as such in the CQE.
However, unlike previous devices, the TCP sequence (tcpsn) where the HW found a header is not provided in the CQE.
Instead, tcpsn is queried from HW asynchronously by the driver.
We employ the force resync approach to guarantee that we can log all resync locations between the received packet and the HW query response.
We check the asynchronous HW query response against all resync values between the packet that triggered the resync and now. If one of them matches, then resync can be completed immediately.
Otherwise, the driver keeps waiting for the correct resync.

>> This is a rare corner case anyway, where more than 1k tcp connections
>> sharing the same RX ring will request resync at the same exact moment. 
> 
> IDK about that. Certain applications are architected for max capacity,
> not efficiency under steady load. So it matters a lot how the system
> behaves under stress. What if this is the chain of events:
> 
> overload -> drops -> TLS steams go out of sync -> all try to resync

I agree that this is not that rare, and it may be improved both in future patches and hardware.
Do you think it is critical to improve it now, and not in a follow-up series?

> 
> We don't want to add extra load on every record if HW offload is
> enabled. That's why the next record hint backs off, checks socket 
> state etc.
> 
> BTW I also don't understand why mlx5e_ktls_rx_resync() has a
> tls_offload_rx_force_resync_request(sk) at the end. If the update 
> from the NIC comes with a later seq than current, request the sync 
> for _that_ seq. I don't understand the need to force a call back on
> every record here. 
> 

The extra load here is minimal, i.e. a single call from TLS to the driver, which usually just logs the information.

> Also if the sync failed because queue was full, I don't see how forcing 
> another sync attempt for the next record is going to match?
> 

It doesn't, and if sync failed then we should stop trying to force resync.
