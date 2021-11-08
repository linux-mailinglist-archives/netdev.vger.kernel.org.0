Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DC6449F34
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 00:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241010AbhKHXzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 18:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239204AbhKHXzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 18:55:24 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CD4C061714
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 15:52:33 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id l19so18894591ilk.0
        for <netdev@vger.kernel.org>; Mon, 08 Nov 2021 15:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zVnAxwCTKjC3AUkCPijiuTypRE/MJddmMMQInhWEYjg=;
        b=1BbGuwFmIJ6ilYIYJQ3CKsTFLJsPmDHclczUpQ4FmG3zG4epF7hOnFi1x49u54eOb4
         vOBRrcemz3u6edv7mCXotXBhO5mCYFh9bEGVgt9ajeGv5vSzGuneBWy1XSZ7LPe4VdI0
         1sKS8fGXkzSOinH1vB//SRs1joVwKVSMDLr8gX/1brfJGssTgtZAVyt6b9bu/h3qtRHZ
         32Zg06KNzHAicEAiFxHsgtPlY/nlNyON8LKXiqryVPqLR7sOXNqrzrxRn9W0vnvl5ntN
         XzBjkQfznPTMeaH2LvvDs5xidW3NqeZFcd7luJHbCou+xsARRrcMHa9XMzdrc58B30xW
         pA/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zVnAxwCTKjC3AUkCPijiuTypRE/MJddmMMQInhWEYjg=;
        b=ALqSkl5Rk3jF8311vAAdg1YcRvdoRpX2iQklpMPuCpdaih5/qaTdnAFcva94dq84nY
         KvWqt+exwm0mvdXAvrSs3JdWcDUYH86WjAmHVwiCXCZrRlSDVfPYndUpSo0Hj6Ia/frI
         O1dtfwLLWlRwS0VpL8BZnvMhSQbZ/szGGdLRb5taQp+4XxT3sarZdFbBfSy+R7tn7N7P
         NueNEeHdjmolf/MnLs++7ENpAnYbcthDyr09a6u/IlZ0wo52POJtNDtJD4TnY14devsU
         tgq0MDGaOzVPQt+y02R5bTghjcGNv5g66I5LiLrzEhClvHdtMEK6YyeJZBTNxY6DllU3
         oJ1g==
X-Gm-Message-State: AOAM532yVFfRBm/B/e9vtdXy2rtyFjpGlMwgNdUlDBsGKI5Xt3U7mxtF
        ghYFRdlolF0xoG74vscN3oWt+sr6Qt36PGb0UGRtqQ==
X-Google-Smtp-Source: ABdhPJzLlms+rbnmUdWf+Dr2jmDi5p0A5MQDDKPziEJJ+8j+NVxe3wQIyGidvv9WN0LMhOKfzmBprOewGoTMEFXl2lw=
X-Received: by 2002:a05:6e02:190f:: with SMTP id w15mr2171155ilu.56.1636415552824;
 Mon, 08 Nov 2021 15:52:32 -0800 (PST)
MIME-Version: 1.0
References: <20211104124927.364683-1-robert.marko@sartura.hr>
 <20211108202058.th7vjq4sjca3encz@skbuf> <CA+HBbNE_jh_h9bx9GLfMRFz_Kq=Vx1pu0dE1aK0guMoEkX1S5A@mail.gmail.com>
 <20211108211811.qukts37eufgfj4sc@skbuf> <CA+HBbNGvg43wMNbte827wmK_fnWuweKSgA-nWW+UPGCvunUwGA@mail.gmail.com>
 <20211108214613.5fdhm4zg43xn5edm@skbuf> <CA+HBbNEKOW3F6Yu=OV3BDea+KKNH6AEUMS07az6=62aEAKHGgw@mail.gmail.com>
 <20211108215926.hnrmqdyxbkt7lbhl@skbuf> <CA+HBbNH=31j1Nv8T67DKhLXaQub2Oz11Dw2RuMEWQ3iXrF2fxg@mail.gmail.com>
 <20211108233816.tnov6gufaagdrhlv@skbuf>
In-Reply-To: <20211108233816.tnov6gufaagdrhlv@skbuf>
From:   Robert Marko <robert.marko@sartura.hr>
Date:   Tue, 9 Nov 2021 00:52:21 +0100
Message-ID: <CA+HBbNGHrQi_SbY=Ta395_J22Ab1s3wG_RtRvbjwa1LOw8Kfmw@mail.gmail.com>
Subject: Re: [net-next] net: dsa: qca8k: only change the MIB_EN bit in
 MODULE_EN register
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gabor Juhos <j4g8y7@gmail.com>, John Crispin <john@phrozen.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 9, 2021 at 12:38 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Mon, Nov 08, 2021 at 11:13:30PM +0100, Robert Marko wrote:
> > > The driver keeps state. If the switch just resets by itself, what do you
> > > think will continue to work fine afterwards? The code path needs testing.
> > > I am not convinced that a desynchronized software state is any better
> > > than a lockup.
> >
> > It's really unpredictable, as QCA doesn't specify what does the software reset
> > actually does, as I doubt that they are completely resetting the
> > switch to HW defaults.
> > But since I was not able to trigger the QM error and the resulting
> > reset, it's hard to tell.
> > Phylink would probably see the ports going down and trigger the MAC
> > configuration again,
> > this should at least allow using the ports and forwarding to CPU again.
> > However, it may also reset the forwarding config to basically flooding
> > all ports which is the default
> > which is not great.
> >
> > But I do agree that it may not be a lot better than a lockup.
>
> I'm not sure what you expect going forward. You haven't proven an issue
> with the actual code structure, or an improvement brought by your change.
> Allowing the hardware to autonomously reconfigure itself, even if
> partially, is out of the question (of course, that's if and only if I
> understand correctly the info that you've presented).

After this discussion, I think that John clears the bits intentionally,
I still don't think its really the best practice to do so in the MIB enablement
without documenting it.
However, since this doesn't seem to be hurting anyone I will drop it and rather
focus on IPQ4019 support which is slowly shaping into something upstreamable.

Regards,
Robert

-- 
Robert Marko
Staff Embedded Linux Engineer
Sartura Ltd.
Lendavska ulica 16a
10000 Zagreb, Croatia
Email: robert.marko@sartura.hr
Web: www.sartura.hr
