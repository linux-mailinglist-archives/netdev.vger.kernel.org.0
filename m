Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA44D1A7E3E
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 15:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732417AbgDNNfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 09:35:53 -0400
Received: from mail-eopbgr40043.outbound.protection.outlook.com ([40.107.4.43]:62851
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729076AbgDNNdX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 09:33:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e070gIRH1rkknibKvkip992uGZNVTUEPhnDofkbMXQVJCtT991spe1AsmqyPuMEZ55ugdWi1B89EVec6ANtw/GMKw5Hpz84UIHem16E6F9aAbBzESVNxBo5D6k/AWXIU/mMHa8nav+IHAFBjH1LH1plfGNEAJvGnktIqT84BGq+0Q8Ln67U6KFbbKVcz9ntd/hiLRbPXSAGb51nys41eRX6yZruUyXHZMOz4IR5dWiBfi7IC6NgNUW1CnbYIdMzHB2jI+Owd1XUD30pbmPFR7WJRvXjz5PERGcdBoo6MgyITRvNDmbAbc+bzJAUO3vzqS8ZuPm1qNOQTIZtcybIouA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mSwGv1WwwsocFMXE8BPRFY776KZK4TcALKF5nLaxsS8=;
 b=VWt4cC8klO/uieyCET7YBmhsQxr3Bfzas3czeSRS9oOpI36dIDmepqZ9+fLiHaRPL9woydpm+P9RN4W4IVyA6kp5DwR7oImTCYMo1SlxpWvACGIv7VcEqfXqSlZWqZoziTshPh0GUKVlWfsVMn1C6nHvo6k3EsIQiIVeQH4nHZvyJxikh6fKexWPlw438sl0SPA1Qv6wU/YJdh8TRVPgC3b2914NKqrFyFeXfmHPJMy+B2fX6C/x8fT/CCf2mXsxRlRvhfLZ5WxBtaRx6t/lKnzIsDa8qv5UKQSOG0r+Z4kgQJHQcBTuESwp+10XNPx0gfGf9q0qnOgmLrOg2CM4AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=orolia.com; dmarc=pass action=none header.from=orolia.com;
 dkim=pass header.d=orolia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orolia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mSwGv1WwwsocFMXE8BPRFY776KZK4TcALKF5nLaxsS8=;
 b=W0wZE1dp4Y9Q7XH+yjTNNU69M3y1Z5989jtnh3eDfmScz2yewZTMEPr8VpjOo7k6/9kwpFHdWYt/ceTeifCw9p3dgirq+vJA+0vXnQr3AcJgQntrvfYbOXzzdtfwE/trCim+ysFsmQEFWcl/onomTQNs+Lmg2/+KhSgJedD9X3A=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=julien.beraud@orolia.com; 
Received: from AM5PR06MB3043.eurprd06.prod.outlook.com (2603:10a6:206:3::26)
 by AM5PR06MB3012.eurprd06.prod.outlook.com (2603:10a6:206:a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.28; Tue, 14 Apr
 2020 13:33:19 +0000
Received: from AM5PR06MB3043.eurprd06.prod.outlook.com
 ([fe80::7893:2451:4039:f36b]) by AM5PR06MB3043.eurprd06.prod.outlook.com
 ([fe80::7893:2451:4039:f36b%7]) with mapi id 15.20.2900.026; Tue, 14 Apr 2020
 13:33:19 +0000
Subject: Re: [PATCH 2/2] net: stmmac: Fix sub-second increment
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20200414091003.7629-1-julien.beraud@orolia.com>
 <20200414091003.7629-2-julien.beraud@orolia.com>
 <BN8PR12MB3266F9F1656962A9D1675AE9D3DA0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <310f0a67-7744-3544-126f-dff1fcb75ef4@orolia.com>
 <BN8PR12MB32661DCB43EFE9F9235431A4D3DA0@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   Julien Beraud <julien.beraud@orolia.com>
Message-ID: <697c2998-9faa-4e25-ebc4-4a983adb2fcf@orolia.com>
Date:   Tue, 14 Apr 2020 15:33:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <BN8PR12MB32661DCB43EFE9F9235431A4D3DA0@BN8PR12MB3266.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0025.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::13) To AM5PR06MB3043.eurprd06.prod.outlook.com
 (2603:10a6:206:3::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a01:cb00:87a9:7d00:9d00:f9d3:1f5a:64cc] (2a01:cb00:87a9:7d00:9d00:f9d3:1f5a:64cc) by LNXP265CA0025.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:5c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Tue, 14 Apr 2020 13:33:17 +0000
X-Originating-IP: [2a01:cb00:87a9:7d00:9d00:f9d3:1f5a:64cc]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 514ded47-8071-4eef-7666-08d7e07864ed
X-MS-TrafficTypeDiagnostic: AM5PR06MB3012:
X-Microsoft-Antispam-PRVS: <AM5PR06MB3012902A03E516314EC0CA1F99DA0@AM5PR06MB3012.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0373D94D15
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR06MB3043.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(39840400004)(366004)(376002)(396003)(136003)(4326008)(8676002)(31696002)(110136005)(44832011)(8936002)(2906002)(2616005)(316002)(86362001)(6486002)(186003)(81156014)(53546011)(31686004)(478600001)(5660300002)(16526019)(52116002)(66946007)(66556008)(66476007)(36756003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: orolia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xLRERtguYc5O7XQLlrTCw+GUKaTT1ZbmgYlcA2hao7L9TlCx+5545MNuohNpufKnVOdp5OXX0e5kQVw/nK7Ql/2l+kAGzl6LzTVR78oL2wFPg47b+868fbHpg7y26h6iPMCnPQdENrzIsmJrd89GfLCzZce0UAPDKDsOJ430apNLfDfi594bBD54eFoUl0MD5HJE5jtLjLCdnD9Yf2Vnw7iGExTe9A9yBK18l8lggQ/daRHzPet8nWK9dQsDQgGG6EApuRQrUvxFnV/k+nFOcArVSPwG2yajEADlv6YjtK24quOQZv3scLNBci0/u1KdH9hdXFhfFKAZcjtYnttTUBeNF4ez4Cmo0yDqilxdvOlcLVIfgXLOZ49pe40fF90rVt1fkY5rBfQNy/vprstmAY0VPoRiIZcI1sdJdCaIlUziXJyLiih3Z+Z5ddBeRcru
X-MS-Exchange-AntiSpam-MessageData: hnO++YtP8dtGWycDMjTKkEajYeC4CfWUk9qTUoNc1ZL7IT2/tF3GDv2ZQFeRZEEhGf3qZGNmaVwaqf3DsCA9mQvqxo6pxvDT2BLJhcpXQzupWHsKZTEPz+Ulmdp/Ca7W0Y7iPGQXo126/90jwLMANj/nAwtWUGKKtiHkFKAxadC82PngqfrYb9biw0LRFw3cjo4qJJlxDAg9R7dYBl67Lg==
X-OriginatorOrg: orolia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 514ded47-8071-4eef-7666-08d7e07864ed
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2020 13:33:19.1874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a263030c-9c1b-421f-9471-1dec0b29c664
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vDNsDbxhY01O/o8llI95mc1AKMA0jS/8DnJTZctU6CYfGBKT7LyGbmx7QpcC8eZNTA6Ap6XmvJsXs9NLq2m997QY5YqiZo68dQZqBDIN504=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR06MB3012
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14/04/2020 13:14, Jose Abreu wrote:
> From: Julien Beraud <julien.beraud@orolia.com>
> Date: Apr/14/2020, 10:46:49 (UTC+00:00)
> 
>> The numbers I have in the documentation say that the minimum clock
>> frequency for PTP is determined by "3 * PTP clock period + 4 * GMII/MII
>> clock period <= Minimum gap between two SFDs". The example values say
>> 5MHz for 1000-Mbps Full Duplex. Is this documentation incorrect ?
> 
> I meant for fine update method (which is the one currently used), the
> clock frequency must be higher than the desired accuracy (which is
> 50MHz).
For the fine update method, this patch makes it possible to adjust the 
accuracy (sub seconds increment) of the ptp clock to the ptp_ref_clk's 
frequency, making it possible to work with frequencies down to the 
minimal value to the maximum value of the ptp_ref_clk freq. It also 
allow to set a value that is inferior to 20ns, thus improving the 
accuracy for frequencies higher than 100MHz.

> 
>> Apart from that, the existing logic doesn't work. The calculation is off
>> by a factor 2, making the ptp clock increment twice slower as it should,
>> at least on socfpga platform but I expect that it is the same on other
>> platforms. Please check commit 19d857c, which has kind of been reverted
>> since for more explanation on the sub-seconds + addend calculation.
>> Also, it artificially sets the increment to a value while we should
>> allow it to be as small as posible for higher frequencies, in order to
>> gain accuracy in timestamping.
> 
> I'm sorry but I don't see any "off by factor of 2". I also don't
> understand this:
>   "the accumulator can only overflow once every 2 additions"
> 
> Can you please provide more details ?
Sorry, my explanation was incorrect. The current calculation is not off 
by a factor 2, it is compensated later by a division. It is just that in 
the case of a 50MHz clock, it will lead to a value of 0 in the addend 
register, so it will not work either like it is described in commit 19d857c.

About "the accumulator can only overflow once every 2 additions", please 
see commit 19d857c.

> 
> BTW, I applied your patch and I saw no difference at all in my setup
> except for path delay increasing a little bit.
Ok, my bad, the current calculation does work but it limits the the 
accuracy in case of a clock frequency higher than 100MHz, and doesn't 
work for frequencies inferior or equal to 50MHz. What is your 
ptp_ref_clk frequency? If it is 100MHz, then our 2 calculations give the 
same result.

To summarize, I think I can rephrase the commit message to make it 
easier to understand, but this patch gives the ability to solve 2 issues 
with the current code:
-> The impossibility to use a clock freq inferior or equal to 50MHz
-> The limitation of the sub-second-increment that limits the accuracy 
of the timestamping for frequencies higher than 100MHz.
