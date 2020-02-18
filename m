Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 107CB161FAC
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 04:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgBRDxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 22:53:04 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37630 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbgBRDxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 22:53:04 -0500
Received: by mail-wm1-f66.google.com with SMTP id a6so1325704wme.2
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 19:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b8DcPr6cIaIbAoa9ReoBQr5pe2ADwgDgOf3B/eVgXyk=;
        b=UhKXQAJ0PFF+4SNry9zNuupjO7X6Xv093m0pJMcLaUyoQAm1b9CaEPWEN7KAREIqDr
         goSipZ2usX3yg09k/oyMrsfyNc/L8sg+dNVvatcSGCHokkCLzgHkBFThxiKg+KRHcHoc
         JjIlzkWvqP6mOOoqBelTnh7xp4PPDckLO8ReeVS2gurZNZLSSHU7DrkSMeEBWnfYy7hw
         wNkvhXlxxxWer7M7fzf4DYN4lbRKUL6CIeDGIfolaqTP6QewS87LmVGF6MvB9Qpl+imt
         yjhDF0qFxIrXP0diBg7rG0ogJuW319MA1/3vlCU6biZr9I2yvBSyGNOpv+8DeRMVc409
         D8LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b8DcPr6cIaIbAoa9ReoBQr5pe2ADwgDgOf3B/eVgXyk=;
        b=MfDnyMwpXIttfSzX8eq1bbEjLPtd+wADkQCyvk3BrEakNc7rWl/OYUSNd3GZbQc+WK
         nBqrcatCw7hgAZWitN+/s2iHKebTA57GeC3qd0U1M2xizUjAZJzUANVD+bNJwDiAp2U/
         3YawvQtGbURjN6bxKUahF17V5ygn4wVLmysEDV0jTsqZ1cqF1Ba7pktrRM8pgw2EMnR7
         8cyQxGlcszoxBvZaBgwAZbr2/xzCG4Up3VaSOXRX4F+WYYaodZIDs6UJOicYd3hGB6AX
         qsSqwxKEYuIIIgg6Tlg7SNAGDZNaA5Writs6HiSuPzpewuFeyDRfq4jBuktHaBlUhnVm
         +JIA==
X-Gm-Message-State: APjAAAXHn6qZ9zEMju5NnqtqMxTi4dxcsaJ7oj7ozGCM9zrREee8fNs+
        GKy+0TsbYxTLbCFv6yHmix3V1TaldQaidlu4NkI=
X-Google-Smtp-Source: APXvYqyyePM2dBm65tFQeehy/AmnB7iEEuGJtegWykgEJRvesnFdJ90QPPlOoFamm0K1uSI96ZSkFdCvTgRbudA2xEE=
X-Received: by 2002:a05:600c:214f:: with SMTP id v15mr265056wml.110.1581997980888;
 Mon, 17 Feb 2020 19:53:00 -0800 (PST)
MIME-Version: 1.0
References: <0abbe3fb8e20741c17fe3a0ecbca9ccd4f8ab96b.1581994848.git.lucien.xin@gmail.com>
 <35147ca5-3abf-c441-54be-faf08271fd7c@gmail.com>
In-Reply-To: <35147ca5-3abf-c441-54be-faf08271fd7c@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 18 Feb 2020 11:53:59 +0800
Message-ID: <CADvbK_f0K--VhoivU-XLOFSXmkAqXNFZOFBAAjcP7dkDbhCY_A@mail.gmail.com>
Subject: Re: [PATCHv2 iproute2] erspan: set erspan_ver to 1 by default
To:     David Ahern <dsahern@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 11:11 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 2/17/20 8:00 PM, Xin Long wrote:
> > Commit 289763626721 ("erspan: add erspan version II support")
> > breaks the command:
> >
> >  # ip link add erspan1 type erspan key 1 seq erspan 123 \
> >     local 10.1.0.2 remote 10.1.0.1
> >
> > as erspan_ver is set to 0 by default, then IFLA_GRE_ERSPAN_INDEX
> > won't be set in gre_parse_opt().
> >
> >   # ip -d link show erspan1
> >     ...
> >     erspan remote 10.1.0.1 local 10.1.0.2 ... erspan_index 0 erspan_ver 1
> >                                               ^^^^^^^^^^^^^^
> >
> > This patch is to change to set erspan_ver to 1 by default.
> >
> > Fixes: 289763626721 ("erspan: add erspan version II support")
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  ip/link_gre.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/ip/link_gre.c b/ip/link_gre.c
> > index 15beb73..e42f21a 100644
> > --- a/ip/link_gre.c
> > +++ b/ip/link_gre.c
> > @@ -94,7 +94,7 @@ static int gre_parse_opt(struct link_util *lu, int argc, char **argv,
> >       __u8 metadata = 0;
> >       __u32 fwmark = 0;
> >       __u32 erspan_idx = 0;
> > -     __u8 erspan_ver = 0;
> > +     __u8 erspan_ver = 1;
> >       __u8 erspan_dir = 0;
> >       __u16 erspan_hwid = 0;
> >
> >
>
> re-send of v1? lacks the v6 change too.
sorry, :D
already posted v3.
