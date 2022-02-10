Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278A74B1216
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243802AbiBJPxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:53:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234943AbiBJPxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:53:01 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C69C26
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 07:53:00 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id y7so2179088plp.2
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 07:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0aRk2HscakizWLCqrQ5CB9tK40FZrYvTnEVJfReiNFY=;
        b=cpP2LFQ2eDQJe1EcaNgZ1viwdC1hsSCsiX89PLoiweg3TfX7WlC3XJrAXXye7iSxfK
         DZUODoJBTptRW8uP3q03n32z5WbCGSPy2vcAXI2pj6jgniJH+7RL2EEfNNkorwwdJoov
         p1absB5z4ZacBDKRjCGZEwtE90JG0qMJBt1YnOg5KMgjG8wnh4BrDhAZp/3ZhLWex9xB
         OVQQRLubLo79JrW1ihdgN/sYDdQ66R08TGoE8jU/IT7NHuDTBelht/k9p8laqHVBGahW
         HU57kCTbXYB41R+bE+SK7Slk/74xGa8RtIiGKY2fNOeJO+/V40FfKo/k8vxPwi8ChtyN
         EHaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0aRk2HscakizWLCqrQ5CB9tK40FZrYvTnEVJfReiNFY=;
        b=A+lgmZ6fazdMEBMZp32aE2mGucsXkLc0llO9E8xvmfhPRCty5ejvlX9iMFp48BDPPk
         WtGhRKMzvRWzYpXDcId2viF/dWvWomTSmD5Qkel7NMIkKWYhzcw0Ost3XyiTf9z75O1a
         keKpCiTxXwm0i8rB5sNyJU2R9jSMkhFh+FnRL5P3oZbQxTYNclmuLN0/ej3RWJHBngWL
         gZm0pymrj+4+O00ke4BFMar/i2Y/kiGBZKobozB66lR8a7NC7rH/BMvKWsCA0Gervcwx
         5IIOOJ3Yik+mkxHrtxQn/xuLKj4j9+1upSsuJGTvd5d50m03TJcb67jXqkl1xc3vVMjk
         2VJQ==
X-Gm-Message-State: AOAM533HdWJFaHtdkC+iFwEZCMvhuPhJVNDibahlbLUH3rrG9nvCKKpE
        URnv7xYpYNLPI/FmotmY+cKAM6/BU4/9o5HBYw5hMg==
X-Google-Smtp-Source: ABdhPJzhIDlgg0ODPB8qVf1n8qI/DXWoH8jwpmcTEd2zXyfLZPFCTLNFEyefMem1sfonuxQSxIruS4cSPxJgSyBcG/o=
X-Received: by 2002:a17:903:32cb:: with SMTP id i11mr7831244plr.118.1644508380054;
 Thu, 10 Feb 2022 07:53:00 -0800 (PST)
MIME-Version: 1.0
References: <20210421055047.22858-1-ms@dev.tdt.de> <CAJ+vNU1=4sDmGXEzPwp0SCq4_p0J-odw-GLM=Qyi7zQnVHwQRA@mail.gmail.com>
 <YfspazpWoKuHEwPU@lunn.ch> <CAJ+vNU2v9WD2kzB9uTD5j6DqnBBKhv-XOttKLoZ-VzkwdzwjXw@mail.gmail.com>
 <YfwEvgerYddIUp1V@lunn.ch> <CAJ+vNU1qY1VJgw1QRsbmED6-TLQP2wwxSYb+bXfqZ3wiObLgHg@mail.gmail.com>
 <YfxtglvVDx2JJM9w@lunn.ch> <CAJ+vNU1td9aizbws-uZ-p-fEzsD8rJVS-mZn4TT2YFn9PY2n_w@mail.gmail.com>
 <Yf2usAHGZSUDvLln@lunn.ch> <CAJ+vNU3EY0qp-6oQ6Bjd4mZCKv9AeqiaJp=FSrN84P=8atKLrw@mail.gmail.com>
 <YgRWl5ykcjPW0xvx@lunn.ch>
In-Reply-To: <YgRWl5ykcjPW0xvx@lunn.ch>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Thu, 10 Feb 2022 07:52:49 -0800
Message-ID: <CAJ+vNU1kmxgFjX2HeTok-6FcnCAApvzszhh2dbNnDgFD7ZsAiQ@mail.gmail.com>
Subject: Re: [PATCH net v3] net: phy: intel-xway: enable integrated led functions
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Martin Schiller <ms@dev.tdt.de>, Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>, hkallweit1@gmail.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 9, 2022 at 4:04 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > The errata can be summarized as:
> > - 1 out of 100 boots or cable plug events RGMII GbE link will end up
> > going down and up 3 to 4 times then resort to a 100m link; workaround
> > has been found to require a pin level reset
>
> So that sounds like it is downshifting because it thinks there is a
> broken pair. Can you disable downshift? Problem is, that might just
> result in link down.

Its a bad situation. The actual errata is that the device latches into
a bad state where there is some noise on an ADC or something like that
that cause a high packet error rate. The firmware baked into the PHY
has a detection mechanism looking at these errors (SSD errors) and if
there are enough of them it takes the link down and up again and if
that doesn't resolve in 3 times it shifts down to 100mbs. They call
this 'ADS' or 'auto-down-speed' and you can disable it but it would
just result in leaving your bad gbe link up. It's unclear yet if it's
better to just detect the ADS event and reset or to disable ADS and
look for the SSD errors myself (which I can do).

>
> > - 1 out of 100 boots or cable plug events (varies per board) SGMII
> > will fail link between the MAC and PHY; workaround has been found to
> > require a pin level reset
>
> I don't suppose there is a register to restart SGMII sync?  Sometimes
> there is.

Not that I see but I haven't really investigated too much into
mitigating that issue yet. The errata for that issue says you need to
assert reset but then it also says it can occur on a cable plug event
which makes me think an MDI ANEG restart may be sufficient.

>
> Anyway, shared reset makes this messy, as you said. Unfortunate
> design. But i don't see how you can work around this in the
> bootloader, especially the cable plug events.
>

Ya, in hindsight the shared reset was a really bad idea, of course the
last PHY we used on this particular board for years before the supply
chain crashed didn't have any issues like this.

I agree that I can't do anything in boot firmware. I was planning on
having some static code that registered a PHY fixup to get a call when
these PHYs were detected and I could then kick off a polling thread to
watch for errors and trigger a reset. The reset could have knowledge
of the PHY devices that called the fixup handler so that I can at
least setup each PHY again.

Regardless of how I go about this the end result may be unreliable
networking for up to a couple of minutes after board power-up or cable
plug event.

Best Regards,

Tim
