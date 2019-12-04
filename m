Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5681136A0
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 21:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfLDUnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 15:43:40 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:35198 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbfLDUnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 15:43:39 -0500
Received: by mail-yb1-f193.google.com with SMTP id h23so550019ybg.2
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 12:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BI1sz+UgmYlwd0FcX64qY5xEEMiY/gN/Xbiip79JI8Q=;
        b=q4XMUWvQwMVkQnvWBeeR8KamRV/bWMzH4ycUQaCSXuoaoHhyWyY9+mwi4woc9dJBMZ
         G7h0mQ/5RvZ3qSCdLCAGKa5rdUXSyZ7MUrJp7PuMynNhnJNmRgevOe5r7D/xyLL+Rpcc
         PynRnqFnoSjyOBgBt6V696UhGIzzpoMl/LHCdkxSlRJxCxFqar/KmgctsSrkx9riDw+V
         x5OPAmhsO+jKiV2U+uV+O6R7ACWqoe3SkJmUCXPrM20NPTQUQlkJA3ymUbvfV9EOUyC2
         2cBzF9ZXUq4OF6tQVoijtb5nhywjyr/vjXu5O4V77MokhxoLbsyTv8vpTIP7RTyUCYG4
         YL/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BI1sz+UgmYlwd0FcX64qY5xEEMiY/gN/Xbiip79JI8Q=;
        b=eL3z8RgEclYopvVPTrgv6eVg0vPwRG7qX++z3eCMdYvm0z04YiM3T9ghpYkvR0kO9Z
         fDVvaqjB2qpZ9HXYvXotcQRn8ljatVm5svsEl4Z5Wf6osURxImL58KBWoIfcBIVmBRuz
         DI2SQgfuEauyr8dlnm0jWHAIk2KCkWEM57x1FoZkxuqj4VOA7aAND1Kb26ybTUW4O78M
         vkHZJgSlO8pZbcRLPgNPIs4MlyEoWR9dnOmk3pF6ipZQ1dI1hQj11NQr3QClD/EOZWPI
         c2qrW0YXAug2Exci5b26GVjCv9mAagz6ljBUzFwOEl6B1VqRLZJKcgPD91xuRrSffLK8
         H8eA==
X-Gm-Message-State: APjAAAULgQCXBHM/4on3NfyvPAq9csBXAYD3efyVKx05eGIcoPNNeWEL
        NaTgSfAiropujBqWkHiLBvTTpFLf
X-Google-Smtp-Source: APXvYqyizJc7fEY3o3fW3oGh32l3LUp/o7qOs1c8Q17HHbDGgdLc1V2TTRYAQIseVMl4oE9Fto6Ikg==
X-Received: by 2002:a25:73c3:: with SMTP id o186mr3669322ybc.30.1575492218268;
        Wed, 04 Dec 2019 12:43:38 -0800 (PST)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id x66sm3607047ywf.98.2019.12.04.12.43.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 12:43:37 -0800 (PST)
Received: by mail-yb1-f169.google.com with SMTP id n3so531296ybm.7
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 12:43:36 -0800 (PST)
X-Received: by 2002:a25:208b:: with SMTP id g133mr3908585ybg.337.1575492216303;
 Wed, 04 Dec 2019 12:43:36 -0800 (PST)
MIME-Version: 1.0
References: <20191203224458.24338-1-vvidic@valentin-vidic.from.hr>
 <20191203145535.5a416ef3@cakuba.netronome.com> <CA+FuTSdcDW1oJU=BK-rifxm1n4kh0tkj0qQQfOGSoUOkkBKrFg@mail.gmail.com>
 <20191204113544.2d537bf7@cakuba.netronome.com>
In-Reply-To: <20191204113544.2d537bf7@cakuba.netronome.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 4 Dec 2019 15:43:00 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdhtGZtTnuncpYaoOROF7L=coGawCPSLv7jzos2Q+Tb=Q@mail.gmail.com>
Message-ID: <CA+FuTSdhtGZtTnuncpYaoOROF7L=coGawCPSLv7jzos2Q+Tb=Q@mail.gmail.com>
Subject: Re: [PATCH] net/tls: Fix return values for setsockopt
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 4, 2019 at 2:36 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> (there is a v2, in case you missed)

Thanks. I meant to respond to your comment. (but should have done sooner :)

> On Wed, 4 Dec 2019 14:22:55 -0500, Willem de Bruijn wrote:
> > On Tue, Dec 3, 2019 at 6:08 PM Jakub Kicinski wrote:
> > > On Tue,  3 Dec 2019 23:44:58 +0100, Valentin Vidic wrote:
> > > > ENOTSUPP is not available in userspace:
> > > >
> > > >   setsockopt failed, 524, Unknown error 524
> > > >
> > > > Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
> > >
> > > I'm not 100% clear on whether we can change the return codes after they
> > > had been exposed to user space for numerous releases..
> >
> > This has also come up in the context of SO_ZEROCOPY in the past. In my
> > opinion the answer is no. A quick grep | wc -l in net/ shows 99
> > matches for this error code. Only a fraction of those probably make it
> > to userspace, but definitely more than this single case.
> >
> > If anything, it may be time to define it in uapi?
>
> No opinion but FWIW I'm toying with some CI for netdev, I've added a
> check for use of ENOTSUPP, apparently checkpatch already sniffs out
> uses of ENOSYS, so seems appropriate to add this one.

Good idea if not exposing this in UAPI.

> > > But if we can - please fix the tools/testing/selftests/net/tls.c test
> > > as well, because it expects ENOTSUPP.
> >
> > Even if changing the error code, EOPNOTSUPP is arguably a better
> > replacement. The request itself is valid. Also considering forward
> > compatibility.
>
> For the case TLS version case?

Yes. It's a more specific signal. Quite a few error paths already return EINVAL.
