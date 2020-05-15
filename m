Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395291D4F37
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 15:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgEON0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 09:26:54 -0400
Received: from mail-eopbgr70057.outbound.protection.outlook.com ([40.107.7.57]:58015
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726170AbgEON0x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 09:26:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QbmSjrhOSPM7VF/hFQpyK0HDZ6tNAgZjEyzL+W6TDuMu5sGHCR4chhqYMAU41FLbBrerfBA5OCipHwWiJydeXBYG5Vi67GDMrTPSlkvHWPCzHRg+6Psrdq2xkGct02lSeBY7ZveuqHgT/Xj+su/oN96roICbeLyf/TdMj0J1rAE0scKNqz8q7EJgBioZ6rmxj1V/UaKDe8rr0mK4e+Ejd7MEbAurCREk7C7PPDifqImuBtoS7IdalZMwZ5KP5e8tZdcNCmX17GDaLABN4OD7nH5+++gRaP9j10eW6NgcYlKdD++OVB26Qhwq9CYRL98zfTkcYKJB/L5tD+0B7It8YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4P2chuIAghvzEqLP+BHXbV//ega1vy0cMot3Q01HapU=;
 b=HlKK4Xp/GSvjIvaXz0OXorii4K3C/DxRnTXYkyLjsekvu7zC8Q+sA1YpuODGd88NHWG2gTTZKuhKTyPpcygvmypFDU6anFKnzbrHKto6C+Z0U5jAfJtGv/4KxK6shd3MwiDMvtiINrsqo1C8M/jAWrtBYWRExmZrPEPl5l7+HJ/axPsudMpqm2TbVPd++9KuBs9hKcWsdxR2hRx25ajT2aP6Us8KGmjju0xYqqvsAd16ml+MEircwgqfM1em5yKl2GiDnmpWQ3iBFiJ+dCcACRNDSiysJKs2903rs52HUI1bVA3G2RbtUnQifmuZcV12nE2kHIJI9vbTn4DbfCH6Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=orolia.com; dmarc=pass action=none header.from=orolia.com;
 dkim=pass header.d=orolia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orolia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4P2chuIAghvzEqLP+BHXbV//ega1vy0cMot3Q01HapU=;
 b=WMri2M2BWMza6yjy9/oJNGyLs6rcL4T/3qm4CXZlFWq2SZQ9rijt3QJm2GsY2C7sc3YTCMlXoyPaQhV87fVtjDaumd2JjEXBOPzcDlbC1q9KyDP+jsibPl0A+z900O5ZUMZG7AFhrH37ERIKZ3x1+f5VDM8uy1ECOyChp/mtmlo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=orolia.com;
Received: from AM0PR0602MB3380.eurprd06.prod.outlook.com
 (2603:10a6:208:24::13) by AM0PR0602MB3444.eurprd06.prod.outlook.com
 (2603:10a6:208:22::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Fri, 15 May
 2020 13:26:48 +0000
Received: from AM0PR0602MB3380.eurprd06.prod.outlook.com
 ([fe80::3d36:ab20:7d3b:8368]) by AM0PR0602MB3380.eurprd06.prod.outlook.com
 ([fe80::3d36:ab20:7d3b:8368%7]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 13:26:48 +0000
Subject: Re: [PATCH 0/3] Patch series for a PTP Grandmaster use case using
 stmmac/gmac3 ptp clock
To:     Richard Cochran <richardcochran@gmail.com>,
        Olivier Dautricourt <olivier.dautricourt@orolia.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20200514102808.31163-1-olivier.dautricourt@orolia.com>
 <20200514135325.GB18838@localhost> <20200514150900.GA12924@orolia.com>
 <20200515003706.GB18192@localhost>
From:   Julien Beraud <julien.beraud@orolia.com>
Message-ID: <3a14f417-1ae1-9434-5532-4b3387f25d18@orolia.com>
Date:   Fri, 15 May 2020 15:26:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200515003706.GB18192@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP123CA0004.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::16) To AM0PR0602MB3380.eurprd06.prod.outlook.com
 (2603:10a6:208:24::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a01:cb00:862c:3100:f406:ebd3:1008:85ef] (2a01:cb00:862c:3100:f406:ebd3:1008:85ef) by LNXP123CA0004.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:d2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Fri, 15 May 2020 13:26:48 +0000
X-Originating-IP: [2a01:cb00:862c:3100:f406:ebd3:1008:85ef]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddcdee38-3a88-4be0-50d6-08d7f8d39f10
X-MS-TrafficTypeDiagnostic: AM0PR0602MB3444:|AM0PR0602MB3444:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0602MB34442CA94BF1B8AA9826748599BD0@AM0PR0602MB3444.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GO8ZuXdEyTtJ89SCofpCsEKzveo8JhsC0GSGdvkK7MxZGOKn81eygDA3rJo7VG5Qu0SdMbQrnX+2je5ix3ikwnkN4iHzy3L+FgMg1LEzlkMfSxd9RrHGDZvUB05F6/0+GGYbA92b0R5cTRQ99U9z3knQGLiO/ytb9VonCA58cqHVPe7UnITQ8NHcwUrVyNjfOr7MARP6EwX0KpiMyjkuZ3gNuy/r786EhGF4j2aYGvCTCBaAo3xhaQJEfnB8XkPdwgyDkElh5pbFCj5NOsKXhzHnN0/dblyNeCLV9G7jIXl99tMVPWTq3KLZsFTyLPCIXU4nQHeNSHGNSiOa470TGw4B8eMz/O+fKrOpWIbHejZFgp3CQMiRLykajMcq3U4AvE4noruCbpsfWacHS04lWbfT69aqAwNRXBInMaNLAoBMtN2tbYeIcDH/KbYuEg8Y0kterShjHb0iAWebZvxfN+P0xTabEq3XczH6+AiRzW6klhdK+5DDBUuB8MTgKBie
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0602MB3380.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39850400004)(6636002)(36756003)(316002)(66476007)(31686004)(4326008)(186003)(16526019)(54906003)(66556008)(8676002)(66946007)(8936002)(110136005)(2906002)(31696002)(6486002)(52116002)(2616005)(5660300002)(44832011)(86362001)(478600001)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8NIlKKZvGhiqoUE1aK8Q/ew/hGFSSbirWWCTBvVbiDwnBIe162/pCCs4QOdAEkutVdeHqzadiWMgBC/iNuE/zgTWxFsV6bmCzfpqYxRv29LoLH5tVFWa0CDYmBSZeGvXXXurDztNwoXU/cmqmGbU954RXYWo165t/cij1Ihbr/zh2YuS7uZFaYCau+T0foyGKobFscdqeDTMsJ148+A+MGLVI9cUV7MTkR3NCF5feO9vpfAn8VvfuwhqKHrSgGx/BNz2YaUI6st7o+YMqGFTxiDWF/eqcY6GWSe00mxjIP6hvLTfPq1CKx4AlIqcFCea7akzXPbBL79zf6BK7jn4pA3hf3AZ2oaL+WAapzCfn//TIIs5OkIq1mPOUEgScIgjo+kG3KbMM7IkSl8lI/fpEYQEqmHwOfHEr8deeuArUkw772p8Ni5+ILqRHHOCMQBfEe4hyG//Qbhmvy+rTydwCYBQA7ERdjy22EOH4q7N7I3mPHYBVwnikVzObmo342MJ3yKPCl4NjCkby3I34DFF5Nlc4F74YCqe+sgtlmJq+YauBVWmfTi9OXgcRZH5RvSG
X-OriginatorOrg: orolia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddcdee38-3a88-4be0-50d6-08d7f8d39f10
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 13:26:48.8058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a263030c-9c1b-421f-9471-1dec0b29c664
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P158dDINg+WNHjLZvjITwk29sSr+ne9VC403PACDNA97V8GIC++iKwocmC+cU2mh7lRB4XqjJVdj9QQAsvo/8KOLXBsbJohML+ICMNLGimw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0602MB3444
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry to jump in, just wanted to add a few details,

On 15/05/2020 02:37, Richard Cochran wrote:
> On Thu, May 14, 2020 at 05:09:01PM +0200, Olivier Dautricourt wrote:
>>    My issue is that the default behavior of the stmmac driver is to
>>    set the mac into fine mode which implies to continuously do frequency
>>    adjustment, So if i'm not mistaken using the nullf servo will not address
>>    that issue even if we are not doing explicit clock_adjtime syscalls.
> 
> Why not use the external time stamps from your GPS to do one of the
> following?
> 
> A) Feed them into a user space PI controller and do frequency
>     correction, or
> 
> B) Feed the offsets into the hardware PLL (if that is present) using
>     the new PHC ADJ_OFFSET support (found in net-next).
> 
> I don't see a need for changing any kernel interfaces at all.  If you
> think there is such a need, then you will have to make some kind of
> argument or justification for it.

I think that B could work, but it doesn't solve the issue with the adjustment
mode of the mac's clock.
I understand this may be very specific to stmmac but the problem is still
there.

This MAC's Timestamping Clock has 2 adjustment modes :
- Fine
- Coarse

It has the following registers :
- sub-second-increment (32bits)
- addend (32bits)
- timestamp-control (to set the mode to fine or coarse)

It also has an accumulator (32bits)

-> When in fine mode, which is the current default,
- The sub-second-increment (in ns) is added to the clock's time when the
accumulator overflows
- At each clock cycle of ptp_ref_clock, the value of addend is added to the
the accumulator

The frequency adjustments of the mac's clock are done by changing the value of
addend, so that the number of clock cycles that make the accumulator overflow
slightly change.

The value of sub-second-increment is set to 2 / ptp_clk_freq, because using an
accumulator with the same number of bits as the addend register makes it
impossible to overflow at every addition.

This mode allows to implement a PTP Slave, constantly adjusting the clock's freq
to match the master.

-> In coarse mode, the accumulator and the addend register are not used and the
value of sub-second-increment is added to the clock at every ptp_ref_clock
cycle.
So the value of sub-second-increment can be set to 1 / ptp_clk_freq but fine
adjustments of the clocks frequency are not possible.

This mode allows to implement a Grand Master where we can feed the stmmac's ptp
ref clock input with a frequency that's controlled externally, making it
useless to do frequency adjustments with the MAC.

We want our devices to be able to switch from Master to Slave at runtime.

To make things short it implies that :

1- In coarse mode, the accuracy of the timestamps is twice what it is in fine
mode (loosing precision on the capability to adjust the mac clock's frequency)

2- I don't think modes can be switched gracefully while the timestamping clk is
active. (2 registers need to be modified : sub-second-increment and control)

1 makes it quite valuable to be able to switch mode. 2 means that this
cannot be done when doing the clock adjustment (offset vs. freq adj. for
instance).

So the question is what interface could we use to configure a timestamping
clock that has more than one functioning mode and which mode can be changed at
runtime, but not while timestamping is running ?

Another thing to note is that based on your comments, I understand that the way
the stmmac's clock is handled now, i.e configuring and enabling the clock when
enabling hardware timestamping may not be right, and we may want to split
enabling the clock and enabling hardware timestamping, but we'd still
need to be able to switch the mode of adjustement of the clock.

I hope this helps a bit,
Julien
