Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAF91ED329
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 17:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgFCPRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 11:17:31 -0400
Received: from mail-eopbgr80088.outbound.protection.outlook.com ([40.107.8.88]:8067
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726013AbgFCPRa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 11:17:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MAhfIlKLpk4j2orFClVgEnfEAkjRFKmW+nCjddZQ9TbonkxFiDrY7r3j7sTNxsWdfd3wisq3Kr7+N7LP8rdghGmGCIajvrpDx/TXxnFKd+RcAmPsRtEjZasnXrlkFU1805XK7NXIsHfOxZZehwGg5xdUNw+RF6M8AQpGHjRDaEx2YLoJmf3xi4JWo7A4h3FkUI8htPsiP+J7HLsueZLmlrAFqOEs8XZQ+qTsaz1sw2gdiyJVAsC1KmVY74PF4U5CYggTtsZc+LajqmpVM080SdmMVGSuhLgmCCg8Ew3hrxM3aafWdq7Yg9PQOSnp+M1g0ql06Rnqu7BVS644gba/4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQl5Dd9cNVtpH3GwK3CJj0f7wAiIggTfpTciukStjoE=;
 b=HQen1g6jz9petRDTrBYwhZcfNcSR+/HKDgp5qu5vQZaRYPSdGB7kpa9hbz1656bzbxtDrQc6fYRPv3dYV0+EYYDRw8yhQLi69T6C2YyzwI6fhWFIDVCVZkeFscsO8ihhloufr58hx/kDm17Fy/IzZaI4XS2x6zdOSLfY/vB9WcASPd3CbiiNtClNGAj1lrXaCB5nc1aVeNlKC13xiByM8ceMyUHA21SAuXWZyxdz/1ONGceL9RWhXABBBB7YX2DKWOmiCcvLcLGzVTyMHFP1znvia/oIvsQGRms5DqoM8ehGQyg8qJugoXIZU0YSjaO86Y8dsIe0pmEMIOCMuatwkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=orolia.com; dmarc=pass action=none header.from=orolia.com;
 dkim=pass header.d=orolia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orolia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQl5Dd9cNVtpH3GwK3CJj0f7wAiIggTfpTciukStjoE=;
 b=h5+AzUvIbZkhHKl1fHivgUotuL1JzBiL+w2Yx5Lz16M67+LlaLe9NLcK72hPuc2cue40KVBPi9Rid+zpoc93mlbNDnKE++twU+3rk9P9vwydbdOHe0826f3JlljViGPWNMBlf7iLUYmH7JI9fmjGQP9yxSfdvel2N7Z22YKlQg0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=orolia.com;
Received: from VI1PR06MB3919.eurprd06.prod.outlook.com (2603:10a6:802:69::28)
 by VI1PR06MB4637.eurprd06.prod.outlook.com (2603:10a6:803:a9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.22; Wed, 3 Jun
 2020 15:17:27 +0000
Received: from VI1PR06MB3919.eurprd06.prod.outlook.com
 ([fe80::d0db:5378:505c:873c]) by VI1PR06MB3919.eurprd06.prod.outlook.com
 ([fe80::d0db:5378:505c:873c%4]) with mapi id 15.20.3045.024; Wed, 3 Jun 2020
 15:17:27 +0000
Date:   Wed, 3 Jun 2020 17:17:19 +0200
From:   Olivier Dautricourt <olivier.dautricourt@orolia.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Julien Beraud <julien.beraud@orolia.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] Patch series for a PTP Grandmaster use case using
 stmmac/gmac3 ptp clock
Message-ID: <20200603151719.GA21184@orolia.com>
References: <20200514102808.31163-1-olivier.dautricourt@orolia.com>
 <20200514135325.GB18838@localhost>
 <20200514150900.GA12924@orolia.com>
 <20200515003706.GB18192@localhost>
 <3a14f417-1ae1-9434-5532-4b3387f25d18@orolia.com>
 <20200527040551.GB18483@localhost>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200527040551.GB18483@localhost>
X-ClientProxiedBy: AM0PR10CA0096.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::49) To VI1PR06MB3919.eurprd06.prod.outlook.com
 (2603:10a6:802:69::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from orolia.com (2a01:e35:1390:8ba0:9022:c6c:b638:21f8) by AM0PR10CA0096.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.19 via Frontend Transport; Wed, 3 Jun 2020 15:17:26 +0000
X-Originating-IP: [2a01:e35:1390:8ba0:9022:c6c:b638:21f8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 219a3812-bbc4-424f-b9e3-08d807d139c5
X-MS-TrafficTypeDiagnostic: VI1PR06MB4637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR06MB4637575A923C6FDCA1DCEFB38F880@VI1PR06MB4637.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04238CD941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VkB6KPNUFPQWg03+qj6sTxf7PitxXVl33bh6It0nTKpxNJ3Fn+lmdeYwEd7SZqZfKY2n2pM0mx2IY81wBSx8+1kymU7MYg2epjQy1FHnAekxcOmqhT/xjxRNaqJfFIPUKMUiS/OqNmSISRxy1alSMkOLjTlq9lBR4iImS3yk0ePesdGnM57DVHwvXPt68qRWs3YMaJGN98rkliQ5K4cVYtdhaM7BqTAY0a4UYwY/P3LW20PGqBQfOP96PEfLDVR6XuqSodCWEplMJ4eKD0VdL3yPAu7dQGCq45g5/qyXq/Ibz3hSK1GVnev27lTzdr+vSgM7w4C1DTEUxQLpcJArQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB3919.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39850400004)(366004)(136003)(346002)(376002)(6916009)(55016002)(52116002)(66476007)(66946007)(8936002)(8676002)(8886007)(54906003)(7696005)(66556008)(186003)(83380400001)(316002)(1076003)(16526019)(5660300002)(33656002)(86362001)(4326008)(44832011)(478600001)(6666004)(2906002)(2616005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fis8mfB7DBTuaPNFzva9knOjePLbINRXBn16tUBx+jxSx6qsd0Bl6SmZV6w9rTsehZ7Y9SD/kBpbibjV8Zj6UaHp08S4cJK5fKLR8ewprgbEhpO6sq1X7EzUrlSIO4P5ETqflR7Xl4MusLIa+sW2VvbmumLOT37EYcPH5owx6VdJiM0x5qjw7ZPfh96H4BEZ7yARKM+FpsRvhgOJcwdOY8lORRTNEOGPlW9ohSxQgACH1JJ8et/bPCb+qIhlRXsWEAD72VNkdIrSSa2Req1vkPJlLR1jYnX0pX4ORBCGOtuiF+FjoQsGKUfqsAw+4Oka56iDVcWQjAO96jWilkD+Xa9DN4kx1yh8+UX1bPAZckFZ84gHTCky/l++r6ojPrrvl9grgSD9cnpeykQ3Oy6AarWT30zYcmkYXxeCvSf1TQ299r4Ktk7ftRABTFbdQXPvzy0lnRtKRqOt0C/xKpibjnldzoWrmXElFrKxmxpW9MV42X7rx/ID55Z2u5DaOnxwEVUOxmzsHrql3SfHvJvbvz84cpbKa+4mqfk9NqugLis=
X-OriginatorOrg: orolia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 219a3812-bbc4-424f-b9e3-08d807d139c5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2020 15:17:27.4322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a263030c-9c1b-421f-9471-1dec0b29c664
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: emEZroHLvhoKtzNMBCic6OM744fcmqc5I3OG0aIA2RJ0uQkXQcHsKunEZCQi86WifQCVIUHkj2XTLIQDQDgf7if8147fX700Exk62QHx0dw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR06MB4637
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 05/26/2020 21:05, Richard Cochran wrote:
> On Fri, May 15, 2020 at 03:26:47PM +0200, Julien Beraud wrote:
> > The frequency adjustments of the mac's clock are done by changing the value of
> > addend, so that the number of clock cycles that make the accumulator overflow
> > slightly change.
> 
> This is typical.
> 
> > The value of sub-second-increment is set to 2 / ptp_clk_freq, because using an
> > accumulator with the same number of bits as the addend register makes it
> > impossible to overflow at every addition.
> >
> > This mode allows to implement a PTP Slave, constantly adjusting the clock's freq
> > to match the master.
> 
> Right.  And I would stick with this.  With the ts2phc program
> (linuxptp master branch) you can use the EXTTS to discipline the clock
> to match the external time source.

The advantage for us here is that the coarse mode allows to set the
sub-second-increment to 1 / ptp_clk_freq and increase the precision of
the timestamps in that mode. Because we don't have to deal with the accumulator
overflow anymore.

> 
> > -> In coarse mode, the accumulator and the addend register are not used and the
> > value of sub-second-increment is added to the clock at every ptp_ref_clock
> > cycle.
> 
> That sounds like simply configuring a fixed rate.

Yes it is. But we want that rate not to be the same that in fine mode, by
configuring it at runtime.

> 
> > This mode allows to implement a Grand Master where we can feed the stmmac's ptp
> > ref clock input with a frequency that's controlled externally, making it
> > useless to do frequency adjustments with the MAC.
> >
> > We want our devices to be able to switch from Master to Slave at runtime.
> 
> If I understand correctly, what you are really asking for is the
> ability to switch clock sources.  This normally done through the
> device tree, and changing the device tree at run time is done with
> overlays (which I think is still a WIP).

In our setup the source clock switch is actually done in an fpga, so the
device tree node is still the same in both cases and we configure the input clock
through a gpio control from the ptp client.

> > So the question is what interface could we use to configure a timestamping
> > clock that has more than one functioning mode and which mode can be changed at
> > runtime, but not while timestamping is running ?
> 
> I think this must be decided at boot time using the DTS.  In any case,
> the PHC time stamping API is not the right place for this.  If you end
> up making a custom method (via debugfs for example), then your PHC
> should then return an error when user space attempts to adjust it.

I think the problem here relies on the fact that the configuration of the mac
is done in the stmmac_hwstamp_set function while what we are really
configuring is the time stamping + ptp_clock functionning.
In the end there is only one register where both are configured
(Control register). But this also makes sense because if there is no
active timestamping the ptp clock can't work. Also as Julien explained
it in his previous mail, the mode switch (writing 2 registers) needs
the timestamping to be reinitialized in any case.

So for something upstreamable i'm kind of stuck here.
This kind of mode configuration does not seems to fit in the current kernel API
because it affects both timestamping (sub-second-increment value) and the ptp clock
functionning (no fine adjustment possible while in coarse mode).

If we don't find a solution i'll at least resubmit my first patch
which is independent of the other two.

Thanks,
-- 
Olivier Dautricourt

