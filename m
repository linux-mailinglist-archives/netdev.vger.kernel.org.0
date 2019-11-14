Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03691FCEC3
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 20:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfKNTaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 14:30:03 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:33608 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbfKNTaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 14:30:02 -0500
Received: by mail-il1-f193.google.com with SMTP id m5so6440941ilq.0
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 11:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C9I8Z4v8szG7Sk2RVim/tFozyJuElI2LAeZNFm3LQmo=;
        b=RcNSGWc9oIJ3wGGS7RicxqKlvRj2R4x+H9oboiSA1Cm0mBhmMmbgDqCWPxJChGth66
         ZFUKlnwNVHNplfw2KPwNZwhaYLIz5AGb92S2fHN2dV8xXaZTXPgKd4i/kLeZYKG9Gmsg
         838ibPi+oAkSKBSx2tsHkIl99sh6cUwcmQpco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C9I8Z4v8szG7Sk2RVim/tFozyJuElI2LAeZNFm3LQmo=;
        b=ndMXWBiPMBqckF1n6RPT+G/RHlXyYVBTFXGAhyzeVZGeqIIu8z7RGPMwnyjLXAF15J
         kuMkN97NoMfbEtxE0QXrtvYx+en8y/s9vYbMARu5LLRt+pep4mTa51hwWmdESDRfNeo5
         fx/Cv0/xTYok2l2EyqZn3tEWFTB850vLZ9Zsk6GqVcyiRih2+hMM4oNDQ6bW2otDwjOE
         UM3TgmZsi2bTqxw6Wte2vR0EhFdPf5b584FSrhkwvZ3O7Ql0lFJ3SrHPB8xY40QwdYvc
         E3yGy8MplYMcKos53k8DRwbyPvYMlJYKF+o8b+I3FUcZq8qdNL1QUo4FVnXvIdJ1+7cH
         u61g==
X-Gm-Message-State: APjAAAXGEFFewZgh3hnY89yw1B7/7t7Ly0ywcQHMJwV6wys9lYcRJwwH
        QeBgDtQRshBs+4LGg0iekU1K2fJlMt4=
X-Google-Smtp-Source: APXvYqzktJnWSYTMsJUQ3+CfMBUUnIyYX5x8WHNR45OhWhs9ZJQLr2sZOtOcuhuZr3a9GRx/QlJrYg==
X-Received: by 2002:a05:6e02:789:: with SMTP id q9mr10968896ils.96.1573759801131;
        Thu, 14 Nov 2019 11:30:01 -0800 (PST)
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com. [209.85.166.176])
        by smtp.gmail.com with ESMTPSA id h21sm680927iol.7.2019.11.14.11.29.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2019 11:29:59 -0800 (PST)
Received: by mail-il1-f176.google.com with SMTP id q15so6404387ils.8
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 11:29:59 -0800 (PST)
X-Received: by 2002:a92:ba1b:: with SMTP id o27mr12281795ili.269.1573759799235;
 Thu, 14 Nov 2019 11:29:59 -0800 (PST)
MIME-Version: 1.0
References: <20191112230944.48716-1-abhishekpandit@chromium.org>
 <20191112230944.48716-5-abhishekpandit@chromium.org> <CAD=FV=UfGDAtePrDmsEsdCNsHQZwDkU8z6E=qzSu=opht7evpQ@mail.gmail.com>
 <CANFp7mWT2GwkSEcE5SkxRnfOebHq2aYLoLh6dmCZ-HktUe+mYQ@mail.gmail.com>
In-Reply-To: <CANFp7mWT2GwkSEcE5SkxRnfOebHq2aYLoLh6dmCZ-HktUe+mYQ@mail.gmail.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 14 Nov 2019 11:29:47 -0800
X-Gmail-Original-Message-ID: <CAD=FV=XPK9YHBCRWnksgeqPQ3v8Tmm413oie-x6ESzpTFtezqQ@mail.gmail.com>
Message-ID: <CAD=FV=XPK9YHBCRWnksgeqPQ3v8Tmm413oie-x6ESzpTFtezqQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] dt-bindings: net: broadcom-bluetooth: Add pcm config
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        linux-bluetooth@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Nov 14, 2019 at 11:20 AM Abhishek Pandit-Subedi
<abhishekpandit@chromium.org> wrote:
>
> > >  Example:
> > > @@ -40,5 +45,11 @@ Example:
> > >         bluetooth {
> > >                 compatible = "brcm,bcm43438-bt";
> > >                 max-speed = <921600>;
> > > +
> > > +               brcm,bt-sco-routing = [01];
> > > +               brcm,pcm-interface-rate = [02];
> > > +               brcm,pcm-frame-type = [00];
> > > +               brcm,pcm-sync-mode = [01];
> > > +               brcm,pcm-clock-mode = [01];
> >
> > I'm at least marginally curious why your example has a leading 0 for
> > all numbers.  It makes me think you intend them to be represented in
> > octal, though I don't know offhand if dtc uses that format for octal.
> > I guess it doesn't matter since all your numbers are between 0 and 5,
> > but it does seem strange.
>
> It's a bytestring with a length of 1. See bytestrings under
> https://devicetree-specification.readthedocs.io/en/latest/source-language.html#node-and-property-definitions

Oh, right!  ...except that now it's just one value and not an array of
values, just make it a normal number.  Don't worry about the fact that
it'll take up 4 bytes instead of 1--it's clearer for it to just be a
normal number.

...I would also note that the definition of the properties talks
nothing about them being a bytestring.  ;-)

-Doug
