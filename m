Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9104A27AE96
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 15:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgI1NDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 09:03:23 -0400
Received: from mail-eopbgr00065.outbound.protection.outlook.com ([40.107.0.65]:22145
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726465AbgI1NDX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 09:03:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LAqYYlDV5q02tjBASDKZmB0w1haLD92MlUwcvmUoQ+Xg7L0m1CHfmeNXJFm5By2AvfnJegCTU0MHMSBrwnjSr3ieaRtZuCdzKMxeCZbkFphM4C4owuJf+YPgy88XiHQ863A+ktG3OZB3EOtT+SKuDqB1M+XOyCu+/g5ofk1tR+SCcij77NMuhDaVXt/jCozUWbm3ZBlH0xNfu7W5H9N1YDL6J77LKCMD6Yt8WajTh3ta97H7Cp3PujcbiCN+3FeOSLzrSWFDAcXgz9Qabl9wmEC3dvHPhwEPqXIZwcjn0XoizkHI4DBM5DrajrbcufTie1NQnQSNEA8B1w2I8nFMOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mk1G73gTTfY+S/Td+fyRJeDBbnP0AoshJZdaZDMbzzw=;
 b=oG8Y9QQqh5Qu9ZYqg1UpOWv5Q9Sqxr0I8Mo6rGAuuGwMPD6zmCvxC68ladCNJ+CzXY24f3ceZoK4AyBerz1dIN8I4N8hd9BLnrrAIcSloTXaeggL4i6ycQVJedVqL8i1SBZr9Yo7Mny/MSmPVaTtNClmjzPtrFThHDU5RvIsl+eMH/K0hqVlq88VdsLFqh49IWmdoj35GO41CeKlsQ/ss7qOUqOkHTRoxWSyhEy6AWroSYAF7aCH3Mwwu7fQ39PAPQ3jBAleL0Nz2U6wQBFbmuiZjA4cXdAkdGNXs9MPDgLknvTCd0BfRP5mBMNMbhV2eiXBQrM4mqxXcY95g7jeFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=skidata.com; dmarc=pass action=none header.from=skidata.com;
 dkim=pass header.d=skidata.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=skidata.onmicrosoft.com; s=selector2-skidata-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mk1G73gTTfY+S/Td+fyRJeDBbnP0AoshJZdaZDMbzzw=;
 b=qlneLuEUq6IrTrAfI/0W9Myvb67PDXCt+UXez06roo/wXsBbkncJ5BjPhu//WJz6N/jI9J0rDLLBEV8GXZhPCbmBYS7Eyv8sHOfeqlPOqUYyxCnIpOHLHgaNrTqn+kWkb7rLePtkAqDP2Q3CL+Kd7OYFCT6ZTvDF8IRLEETbkyQ=
Authentication-Results: denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=none action=none header.from=skidata.com;
Received: from VI1PR01MB5007.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:9d::19) by VI1PR01MB3933.eurprd01.prod.exchangelabs.com
 (2603:10a6:802:64::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.29; Mon, 28 Sep
 2020 13:03:19 +0000
Received: from VI1PR01MB5007.eurprd01.prod.exchangelabs.com
 ([fe80::2411:4545:d175:a0a6]) by VI1PR01MB5007.eurprd01.prod.exchangelabs.com
 ([fe80::2411:4545:d175:a0a6%7]) with mapi id 15.20.3412.029; Mon, 28 Sep 2020
 13:03:19 +0000
Date:   Mon, 28 Sep 2020 15:03:15 +0200
From:   Richard Leitner <richard.leitner@skidata.com>
To:     Marek Vasut <marex@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH] net: fec: Fix PHY init after phy_reset_after_clk_enable()
Message-ID: <20200928130315.GE4292@brokenbit>
References: <20200903215331.GG3112546@lunn.ch>
 <02ce2afb-7b9f-ba35-63a5-7496c7a39e6e@denx.de>
 <20200903220847.GI3112546@lunn.ch>
 <c67eb631-a16d-0b52-c2f8-92d017e39258@denx.de>
 <20200904140245.GO3112546@lunn.ch>
 <b305a989-d9c3-f02a-6935-81c6bcc084c5@denx.de>
 <20200904190228.GG81961@pcleri>
 <dce19310-edbd-e26b-77cd-f03f3350a477@denx.de>
 <20200909083813.GI81961@pcleri>
 <581e5db1-9aac-458d-ed0c-2784ad28b3cc@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <581e5db1-9aac-458d-ed0c-2784ad28b3cc@denx.de>
X-ClientProxiedBy: AM3PR07CA0071.eurprd07.prod.outlook.com
 (2603:10a6:207:4::29) To VI1PR01MB5007.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:9d::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from brokenbit (83.215.125.121) by AM3PR07CA0071.eurprd07.prod.outlook.com (2603:10a6:207:4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.17 via Frontend Transport; Mon, 28 Sep 2020 13:03:18 +0000
X-Originating-IP: [83.215.125.121]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24b777cf-683e-4ebf-afa6-08d863aedee7
X-MS-TrafficTypeDiagnostic: VI1PR01MB3933:
X-Microsoft-Antispam-PRVS: <VI1PR01MB393301C349A3C159386ADE8CF0350@VI1PR01MB3933.eurprd01.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +DulYIphducOQy7iRIcRhyQv1QENPoQv+874VxAanBdSgxTzOy73iloJp38z2hdoAIppCeNWDyOSYuGuWJzoqmCLIt6TtlTQhud3NCN3Fp0OxkWC3U+TlhHGwhNxkrFXdQEUFHrnI7310Yjl60nz6kdsupm6/gW3MgZJyhRgxIggVrd7FkqttqE9xaiGZ5P13K1lt2qARom83ktWYJ4mCA6NeLuFJHkvcXx3VcB08mGwGHhwuQ0r4qxlWi12fMYPTVfqeof8wPwrJbyMgfeWwxnHUh5FvwRZuYdsbUnejbOUIyEcdhiqBXI3ByrTHQKDOgPED3ixMXxqs0WhoXgiV2w1D+rj+oTE0jXhzrcR45G022/w9H0MbboiJ5gAxaND
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR01MB5007.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39850400004)(366004)(346002)(376002)(2906002)(4326008)(53546011)(66556008)(316002)(54906003)(8676002)(66476007)(66946007)(44832011)(33656002)(55016002)(956004)(16526019)(9576002)(6916009)(186003)(6666004)(26005)(9686003)(5660300002)(6496006)(52116002)(1076003)(8936002)(86362001)(83380400001)(33716001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EV89g+4orzTVThH0bB5e7+Ws11Kx/USFD/VMWqsMiGl/eEDuzyXXO7vUPCQ0ODVDSBqI8DqtfTxp2iwjn7Y2rMaxOelG7gvnr3E/rll5KU02b3TBwWLIAgAxx0DRZHaM0/wMnK98agiVhC5zUHLo/5KuZ8AYxHEUx4wXBZzwZ4rNvGX//JsLCZwDCzT4tT5SgVUpgLbfRXNEFlR26IXGMxzvDR00TNXgg53eUxD8FVcwOT+H9Wdxhq0V8Sm+VR8PCmjUCm5mBVF3gZHjDeUJYJ/IJRXeOwMxfVg/+1eemqDEbasrujVXjGo9QNZhFcgCke3NVc5ktUJB5apbj/iyzzZMTsT8hgRgWrHjO7TyMiQw5xRlrz1PcUctp9hah4NFS32xYw0j8ff9kv6R+7OznUDekddHn3H5SXecc9nyNMf/5Xl2mDOX7H3zk8YHwPSka0qC7buc55Uchwaq3yn92Y0BGM4QPgsiI/dLxEV3QKjdmv17DiJ+Qkn/O/vNWK+bEmjLDcrjKP77k8iu49Gu7bLNGaTh3XVhO3nwwHoqLIuh/zZ9T37SFdJ6UDZKgo54o5xg9e9tAUAtB5BRxmk8YE1Uq4MrscBOffmrvhwz2aDj9VMZMHIXxpJSV+H+/Ud+FpCWY9pyzHukpxooLugEwg==
X-OriginatorOrg: skidata.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24b777cf-683e-4ebf-afa6-08d863aedee7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR01MB5007.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2020 13:03:18.9409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3d52ce8f-cef6-4b27-bace-cf9989cf3973
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p3UdTzt+VgckjgipQT8f/oU/Xzi+vUbH/p/YT0HuSdanK6tpz+5a0eg8aiOgq0gCb3iI+y4OoUKQc1FJ4fD/IgolfJU5KbX5FmNZkwCDiac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR01MB3933
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 08:52:17PM +0200, Marek Vasut wrote:
> On 9/9/20 10:38 AM, Richard Leitner wrote:
> > On Fri, Sep 04, 2020 at 09:23:26PM +0200, Marek Vasut wrote:
> >> On 9/4/20 9:02 PM, Richard Leitner wrote:
> >>> On Fri, Sep 04, 2020 at 05:26:14PM +0200, Marek Vasut wrote:
> >>>> On 9/4/20 4:02 PM, Andrew Lunn wrote:
> >>>>> On Fri, Sep 04, 2020 at 12:45:44AM +0200, Marek Vasut wrote:
> >>>>>> On 9/4/20 12:08 AM, Andrew Lunn wrote:
> >>>>>>>>> b4 am 20200903043947.3272453-1-f.fainelli@gmail.com
> >>>>>>>>
> >>>>>>>> That might be a fix for the long run, but I doubt there's any chance to
> >>>>>>>> backport it all to stable, is there ?
> >>>>>>>
> >>>>>>> No. For stable we need something simpler.
> >>>>>>
> >>>>>> Like this patch ?
> >>>>>
> >>>>> Yes.
> >>>>>
> >>>>> But i would like to see a Tested-By: or similar from Richard
> >>>>> Leitner. Why does the current code work for his system? Does your
> >>>>> change break it?
> >>>>
> >>>> I have the IRQ line connected and described in DT. The reset clears the
> >>>> IRQ settings done by the SMSC PHY driver. The PHY works fine if I use
> >>>> polling, because then even if no IRQs are generated by the PHY, the PHY
> >>>> framework reads the status updates from the PHY periodically and the
> >>>> default settings of the PHY somehow work (even if they are slightly
> >>>> incorrect). I suspect that's how Richard had it working.
> >>>
> >>> I have different PHYs on different PCBs in use, but IIRC none of them
> >>> has the IRQ line defined in the DT.
> >>> I will take a look at it, test your patch and give feedback ASAP.
> >>> Unfortunately it's unlikely that this will be before monday 😕
> >>> Hope that's ok.
> >>
> >> That's totally fine, thanks !
> > 
> > Hi, sorry for the delay.
> > I've applied the patch to our kernel and did some basic tests on
> > different custom imx6 PCBs. As everything seems to work fine for our
> > "non-irq configuration" please feel free to add
> > 
> > Tested-by: Richard Leitner <richard.leitner@skidata.com>
> 
> So can this fix be applied ?

In case this question was aimed at me:
From my side there are no objections.

regards;rl
