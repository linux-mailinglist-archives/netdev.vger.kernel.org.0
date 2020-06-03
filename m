Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032DB1ED652
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 20:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgFCSoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 14:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgFCSoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 14:44:06 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9E0C08C5C0;
        Wed,  3 Jun 2020 11:44:06 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id m18so4070312ljo.5;
        Wed, 03 Jun 2020 11:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0JtjVDE29MCLUy8xo6bhPCvI/GjrzGqHCR8IT29ZGyo=;
        b=iV1rUWoetNNHqfxdbVy+yYhQHKioYKhsY+4smiKl/hWx7bEpA2Vh0UUZVSDC7v/fDl
         9PeNQV+86W6yM0oLzhF1nm/VnsLqKqPDMTx4IIZ80ebYgIPiu4QN3ZIxC6dDnKAJJ3Qd
         7eJWkJgrfEgNFWwAXzxEuc1uMqXlpAIHAcU2WwRKm2V3mHL1S5t9QFXEv2PkD+5pTKO+
         T953CehXyAbrxXN1UyQVGDAXhx7q9tsRbYOGmFehPojmOmMSDhDmUzDdqkuqOE8RB7ZY
         DW97JwsuKCiRGGEgd4J1bABeAIB6CjxXt1+4ujoLz9s1eBqoe1xYKD7tZDdXTFMK9kTG
         JOIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0JtjVDE29MCLUy8xo6bhPCvI/GjrzGqHCR8IT29ZGyo=;
        b=dSm8eurOU4DCK5/W+y6ckBiQBa6qq2MqrQ5LR7N+zDUtjDRjWKFvextWyckiuURxz+
         4/m/Zeq5ASZEN/uSuw7p330JARfWfL4XHZhGRmbKJbvQTyt97V3KIykVRZmgnubWkiXv
         85huHCbdayMjDsNe3jHfyocTOWkKMYVvga8kWK4YtmJbL/BtCVQmt5O9+tLZZMkf/uuE
         lXqYtOOqeGfpB5yg/x0JlMvzsMSFJ3S1MVqtzEVFPc8EsDdJv7+18lIRLiaiiScO0Sy+
         BrCXN076se/bGaqQFLS9Mq9RKVK+mUtEa9Fysthv51C2S6Vmw9BVLhCQ8JBtw9w/zymt
         +Iig==
X-Gm-Message-State: AOAM531yT+oXaJTNwwiCxjDcoQDddwYkSB5mGl7Ky/R/hFb2ZgQxF0FL
        guRENxDkHZ+V9h4nIOiiCft4Al2df6Ltv2fWJac=
X-Google-Smtp-Source: ABdhPJwiFD6Hp6F9LCvnYeeV70kyqpT6LBOf62ESoLb72Q/lSSBvhq4Wgjf+QvMN7Rp4UaMXLJ3WehSRx1d4Hh462OY=
X-Received: by 2002:a2e:9187:: with SMTP id f7mr299407ljg.450.1591209844436;
 Wed, 03 Jun 2020 11:44:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200603081124.1627600-1-matthieu.baerts@tessares.net>
 <CAAej5NZZNg+0EbZsa-SrP0S_sOPMqdzgQ9hS8z6DYpQp9G+yhw@mail.gmail.com>
 <1cb3266c-7c8c-ebe6-0b6e-6d970e0adbd1@tessares.net> <20200603181455.4sajgdyat7rkxxnf@ast-mbp.dhcp.thefacebook.com>
 <3573c0dd-baa8-5313-067a-eec6b04f0f36@tessares.net>
In-Reply-To: <3573c0dd-baa8-5313-067a-eec6b04f0f36@tessares.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 3 Jun 2020 11:43:53 -0700
Message-ID: <CAADnVQ+k7+fQmuNQL=GLLaGUvd5+zZN6GViy-oP7Sfq7aQVG1Q@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix unused-var without NETDEVICES
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Ferenc Fejes <fejes@inf.elte.hu>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 3, 2020 at 11:41 AM Matthieu Baerts
<matthieu.baerts@tessares.net> wrote:
>
> Hi Alexei,
>
> On 03/06/2020 20:14, Alexei Starovoitov wrote:
> > On Wed, Jun 03, 2020 at 11:12:01AM +0200, Matthieu Baerts wrote:
> >> Hi Ferenc,
> >>
> >> On 03/06/2020 10:56, Ferenc Fejes wrote:
> >>> Matthieu Baerts <matthieu.baerts@tessares.net> ezt =C3=ADrta (id=C5=
=91pont:
> >>> 2020. j=C3=BAn. 3., Sze, 10:11):
> >>>>
> >>>> A recent commit added new variables only used if CONFIG_NETDEVICES i=
s
> >>>> set.
> >>>
> >>> Thank you for noticing and fixed this!
> >>>
> >>>> A simple fix is to only declare these variables if the same
> >>>> condition is valid.
> >>>>
> >>>> Other solutions could be to move the code related to SO_BINDTODEVICE
> >>>> option from _bpf_setsockopt() function to a dedicated one or only
> >>>> declare these variables in the related "case" section.
> >>>
> >>> Yes thats indeed a cleaner way to approach this. I will prepare a fix=
 for that.
> >>
> >> I should have maybe added that I didn't take this approach because in =
the
> >> rest of the code, I don't see that variables are declared only in a "c=
ase"
> >> section (no "{" ... "}" after "case") and code is generally not moved =
into a
> >> dedicated function in these big switch/cases. But maybe it makes sense=
 here
> >> because of the #ifdef!
> >> At the end, I took the simple approach because it is for -net.
> >>
> >> In other words, I don't know what maintainers would prefer here but I =
am
> >> happy to see any another solutions implemented to remove these compile=
r
> >> warnings :)
> >
> > since CONFIG_NETDEVICES doesn't change anything in .h
> > I think the best is to remove #ifdef CONFIG_NETDEVICES from net/core/fi=
lter.c
> > and rely on sock_bindtoindex() returning ENOPROTOOPT
> > in the extreme case of oddly configured kernels.
>
> Good idea, thank you!
> I can send a patch implementing that.

Please do.
Your 'Notes:' section was absolutely correct in terms of different
trees relationship :)
Thank you.
