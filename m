Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D6E4097BB
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 17:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344198AbhIMPr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 11:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235334AbhIMPr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 11:47:56 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60096C014C02;
        Mon, 13 Sep 2021 08:22:55 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id h20so9557114ilj.13;
        Mon, 13 Sep 2021 08:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3xQ+qOmUBpF0Ou2q2vDoKXn215jIxD4ZZAE7jcxIbx4=;
        b=Y81hrVKOK9tYm05otw8d7wclpAAMZSGhbSXyEOHLioWGSmgyk0e3KmBtGgDzf/v4S3
         bcoGBjLV56VFnnuVW2VlQYXcPMTGZdJh7FpG5KerB4iLbmTiEfPXaFQT4To2o1rti3I+
         Ty/Z+oIeCCpdtrxV8rfFS7m/+chrh/zD+SDSJF42o/53qnGnGdXCqRfL48ed0KrPnTMz
         CGZYxcUJApwkNl0NHztEPjmhh11tAOht+4Ui98kj8O3zYWFEnoh90Ki7LLQ6RL7hZnJv
         xAtDueGry8LowtTuzAjfQmADuYwi35UVsjcYrcpzN25LtK5G3NkNWBADz/Nx2Bb7qMzB
         BJHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3xQ+qOmUBpF0Ou2q2vDoKXn215jIxD4ZZAE7jcxIbx4=;
        b=71ElPYxVxF1IkMz4hKEA00KWvO6Yr3B5n2G8uC31wV9tCiPlkNCYAgZqFg6Oac3dHF
         hrllTczd48KnTDtIx38Q78X9J43iDG2rl8U5ydL7j3VbGnTF89BmLoNcKM0XzGHeVBws
         9c0ZBfnAW9c7VEnAEhdBSEhiKQ6ueLPz2KoNm+TbkcbXnXC5Dx7vbEWRhEFGk7fhWY44
         wKWWTlBqPxa4K6ZSulezINEp1qVJlddemzNr59vdnMAVbP9ily7B82WxvM0bnV47F2PX
         7JMAvTLxG57x/U4/VgvgOHBb/z2AabCnUOkOOHoe4nqsbYQTWNqPCyIjH5RZ8KsvxpN/
         WA/A==
X-Gm-Message-State: AOAM531u1yPyy/GdmJbF5GIjnhmrJqKTMH7PZaBoacaXb+7+sG97VnQt
        0MRxHu20eQnm0Gf767PP3pRsudDlQrurxgJDFmA=
X-Google-Smtp-Source: ABdhPJzzbFmXjdHQqSdX4Jm9ZMFbQEwcjIYeWzjMD1oRLTc8vnnWyBGHezf3xQYAd0kJtZ12NvWMLjFruqb+Xv36cJs=
X-Received: by 2002:a05:6e02:ea2:: with SMTP id u2mr8664451ilj.133.1631546574861;
 Mon, 13 Sep 2021 08:22:54 -0700 (PDT)
MIME-Version: 1.0
References: <46a9dbf2-9748-330a-963e-57e615a15440@gmail.com>
 <20210701085117.19018-1-rocco.yue@mediatek.com> <62c9f5b7-84bd-d809-4e33-39fed7a9d780@gmail.com>
 <CAKD1Yr2aijPe_aq+SRm-xv0ZPoz_gKjYrEX97R1NJyYpSnv4zg@mail.gmail.com>
 <6a8f0e91-225a-e2a8-3745-12ff1710a8df@gmail.com> <CAO42Z2w-N6A4DmubhQsg6WbaApG+7sy2SVRRxMXtaLrTKYyieQ@mail.gmail.com>
 <CAKD1Yr2jZbJE11JVJkkfE-D8-qpiE4AKi87sfdCh7zAMJ-tiEQ@mail.gmail.com>
In-Reply-To: <CAKD1Yr2jZbJE11JVJkkfE-D8-qpiE4AKi87sfdCh7zAMJ-tiEQ@mail.gmail.com>
From:   Mark Smith <markzzzsmith@gmail.com>
Date:   Tue, 14 Sep 2021 01:22:28 +1000
Message-ID: <CAO42Z2wxZf260tupJSZVxJi-Tt4Y5L5WHja3JKTrQOSxixgViw@mail.gmail.com>
Subject: Re: [PATCH] net: ipv6: don't generate link-local address in any addr_gen_mode
To:     Lorenzo Colitti <lorenzo@google.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Rocco Yue <rocco.yue@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
        rocco.yue@gmail.com, chao.song@mediatek.com,
        =?UTF-8?B?S3VvaG9uZyBXYW5nICjnjovlnIvptLsp?= 
        <kuohong.wang@mediatek.com>,
        =?UTF-8?B?Wmh1b2xpYW5nIFpoYW5nICjlvKDljZPkuq4p?= 
        <zhuoliang.zhang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

On Mon, 13 Sept 2021 at 19:38, Lorenzo Colitti <lorenzo@google.com> wrote:
>
> On Mon, Sep 13, 2021 at 12:47 AM Mark Smith <markzzzsmith@gmail.com> wrote:
> > This is all going in the wrong direction. Link-local addresses are not
> > optional on an interface, all IPv6 enabled interfaces are required to
> > have one:
>
> The original patch did indeed disable the generation of the link-local
> address, but that patch was rejected. It sounds like the right
> approach here is to provide two new addressing modes:
>
> IN6_ADDR_GEN_MODE_RANDOM_LL_TOKEN
> IN6_ADDR_GEN_MODE_STABLE_PRIVACY_LL_TOKEN
>
> which would form the link-local address from the token passed in via
> IFLA_INET6_TOKEN, but would form non-link-local addresses (e.g.,
> global addresses) via the specified means (either random or stable
> privacy). I haven't looked at how to do that yet though.

I think there is a broader issue here.

If RFC7217 is used to generate the Link-Local address, then the
likelihood of the Link-Local address being a duplicate with the GGSN
is very low, because RFC7217 uses a function such as SHA-1 or SHA-256.
RFC7217 also performs DAD just in case, and triggers RFC7217 again if
a duplicate does occur.

RFC8064 recommends RFC7217 for all stable IPv6 addresses by default
now, which includes Link-Local addresses.

Following RFC8064 by Implementing RFC7217 for all stable IPv6
addresses the Linux kernel generates would solve both the 3GPP's
duplicate Link-Local address concern, and also make the Linux kernel
compliant with the latest SLAAC recommendation for default IIDs and
stable IPv6 addresses.

Regards,
Mark.
