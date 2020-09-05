Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C965025E4DD
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 03:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgIEB2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 21:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgIEB2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 21:28:53 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49DFC061244;
        Fri,  4 Sep 2020 18:28:50 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id c142so5525914pfb.7;
        Fri, 04 Sep 2020 18:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MIoqWzM7oHXf+obL3wtLv7wSPLoC1E+S6MGKQMl9fAg=;
        b=Zimnoxn8ogLfyaclqMhIwhkKsvsv3m4CVED6ZQ3mRVOGf1k1lmOTSAb5LpoYYeA1gs
         8mvnqSfsQ58viypaidR8Paq9jzu1/vjiliFYlD5hnC/I3txxG4LRPhQuKjhSCqC2XmwO
         1xPpT0iqg3c9Cs11GygDWJOXSwDFmlJKGZMSe+WXs5ciB2fFmRM6+2c94KvuN94j8s+2
         fM5ojg9K2vWlyn0RVo2yHsIm68C/BTOMksyYwUnNslkBM+q0WYQ+59HUMxxkrOPwASk3
         s9Sfh8H+zycMtHY6jjPURiMRlxiq6n2DiDBwNlKpwva6Cwy567EExXNKBVV11MsL4Ti7
         r84w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MIoqWzM7oHXf+obL3wtLv7wSPLoC1E+S6MGKQMl9fAg=;
        b=FW6zRym3xP+8hcN3q9SlkSn44QZP9FK5uG7unnMpnSzuIKfOyOFhon9KmVyUjI8+Uw
         jsgOqmN0J19rrtutYd6B2WSybIg491rwhsbHbEKpuLkjDBqJO52vFT0t5A8arpHEoDdM
         8zkVpAkyr4bkZePNuyN+yzTIGgfbomd+SvVEzGoui9GjadKYPFQyaqNZpw4MgF1zRM7t
         z+XKr0uJOrYKEW2yFOlx2HFPWDl/hWnU9yS6SHtRNIQCDI9wwTj3ft+eX2qhN5A1y4aL
         V2SUsincbDOLq3Ij0TwbWddN194BNgrEN1aL6jSdD2GBYfPPs0gnf12NHPunqvI1ntAa
         3pjQ==
X-Gm-Message-State: AOAM530W6oPZx/8BBaOz8tEBcSTCQpTR7meRaV+Ma9imRmLb1/Ydnbp5
        44sz6TLGP57SK3wW893btTZzRtTclHSG+ybCDKsO1m9rywY=
X-Google-Smtp-Source: ABdhPJymDz3stfxbn4JH5etSAf9doa0r3U6zowq1s8w9+Yjttnq9fxYYLN6hEwWZUzcyKxsQUOqjJo24VHsnxEo8Qh8=
X-Received: by 2002:a63:b24b:: with SMTP id t11mr9273063pgo.233.1599269329649;
 Fri, 04 Sep 2020 18:28:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200903000658.89944-1-xie.he.0141@gmail.com> <20200904151441.27c97d80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200904151441.27c97d80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 4 Sep 2020 18:28:38 -0700
Message-ID: <CAJht_EN+=WTuduvm43_Lq=XWL78AcF5q6Zoyg8S5fao_udL=+Q@mail.gmail.com>
Subject: Re: [PATCH net v2] drivers/net/wan/hdlc_fr: Add needed_headroom for
 PVC devices
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Krzysztof Halasa <khc@pm.waw.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for your email, Jakub!

On Fri, Sep 4, 2020 at 3:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Since this is a tunnel protocol on top of HDLC interfaces, and
> hdlc_setup_dev() sets dev->hard_header_len = 16; should we actually
> set the needed_headroom to 10 + 16 = 26? I'm not clear on where/if
> hdlc devices actually prepend 16 bytes of header, though.

The HDLC device is not actually prepending any header when it is used
with this driver. When the PVC device has prepended its header and
handed over the skb to the HDLC device, the HDLC device just hands it
over to the hardware driver for transmission without prepending any
header.

If we grep "header_ops" and "skb_push" in "hdlc.c" and "hdlc_fr.c", we
can see there is no "header_ops" implemented in these two files and
all "skb_push" happen in the PVC device in hdlc_fr.c.

For this reason, I have previously submitted a patch to change the
value of hard_header_len of the HDLC device from 16 to 0, because it
is not actually used.

See:
2b7bcd967a0f (drivers/net/wan/hdlc: Change the default of hard_header_len to 0)

> > diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
> > index 9acad651ea1f..12b35404cd8e 100644
> > --- a/drivers/net/wan/hdlc_fr.c
> > +++ b/drivers/net/wan/hdlc_fr.c
> > @@ -1041,7 +1041,7 @@ static void pvc_setup(struct net_device *dev)
> >  {
> >       dev->type = ARPHRD_DLCI;
> >       dev->flags = IFF_POINTOPOINT;
> > -     dev->hard_header_len = 10;
> > +     dev->hard_header_len = 0;
>
> Is there a need to set this to 0? Will it not be zero after allocation?

Oh. I understand your point. Theoretically we don't need to set it to
0 because it already has the default value of 0. I'm setting it to 0
only because I want to tell future developers that this value is
intentionally set to 0, and it is not carelessly missed out.
