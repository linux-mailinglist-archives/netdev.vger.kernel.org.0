Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0207C2BC361
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 04:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbgKVDYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 22:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbgKVDYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 22:24:39 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7ECC0613CF;
        Sat, 21 Nov 2020 19:24:37 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id p12so14258488ljc.9;
        Sat, 21 Nov 2020 19:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AvaEcm82w+0FGQu5LBa1EJaM0t9ELvo00zhPW4pfp9c=;
        b=s4d87BEgxdzneZo4k/3CWUrW9L3LwME+hlvq118TS+SZtTNytqvRScX2rNDhKbDAek
         qUR/wZMo1kLETgsKphjMWKToUKlcCiKKPjOs8jI7UmghM0+IBXtxnoxP/9KdnZqOM9gQ
         TArGbQl2y5nB8t9m9PZeuIXW0p++/fdXpOLue+Uxp1xyKP+vr/VzTUgXt3td0nKlip6l
         9ojlI4HIftfRo5DRlLJUACFi2PVFxxTB2foc0LZMPhg0rPJ0M6bAkPOxo+bfjui2CtFB
         sAOrhI0KTC9byc2nlKBHY8JaI1EPGGr2dU9qnMW88/IwADvSFak8ZnYisBtvWZPW80LG
         7/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AvaEcm82w+0FGQu5LBa1EJaM0t9ELvo00zhPW4pfp9c=;
        b=PlSOkclfQKSowMAdrpwl1H7d1h835KLw7gkD+3F4vbvHZ4djf18oGDkssnqlv7PMAk
         SNnR3l+r7jd2gK8S7W9ApBfLKdH04rSYSe5PsisuOI/AOEW4P6yV8mpDSqnBCtA4YT2f
         UHSnaY3/3akAuyRZ23PH3eKwcyI4+htw7BkncdeOoznOX/mwPdS3tc6cEaJAO7Wvr6je
         eh6D0+U2Ec0A9kncC2fIaIYrLUZ4RBw39MDJ+hoFzyekIA2NAWgEokq72H7m6Ncpu7sw
         9siZ9ep9kQkXtIn5BtORWLW2kEt1d0IZRe74jBrkXm4+vdWzklY31TMz0PmJ3GfJivB7
         ce7w==
X-Gm-Message-State: AOAM531Xjlz1E3l/41NAtEctnvRPL4LZA7aEnC/83BWm5uu37utYeXZX
        47uj632/ryVkJxxRIEOqiEoxdkYinOkko8zmOsEk6lt7
X-Google-Smtp-Source: ABdhPJw+CNY4TPTPEwZXi9s0tr1/fmJ+HlmVRcmkSXwB3e+oU7ylJTy987nRUaCkIrY95RbkeYB24ZHekieGkXNN434=
X-Received: by 2002:a2e:6c14:: with SMTP id h20mr40554ljc.450.1606015476264;
 Sat, 21 Nov 2020 19:24:36 -0800 (PST)
MIME-Version: 1.0
References: <20200904162154.GA24295@wunner.de> <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
 <20200905052403.GA10306@wunner.de> <e8aecc2b-80cb-8ee5-8efe-7ae5c4eafc70@iogearbox.net>
 <CAF90-Whc3HL9x-7TJ7m3tZp10RNmQxFD=wdQUJLCaUajL2RqXg@mail.gmail.com>
 <8e991436-cb1c-1306-51ac-bb582bfaa8a7@iogearbox.net> <CAF90-Wh=wzjNtFWRv9bzn=-Dkg-Qc9G_cnyoq0jSypxQQgg3uA@mail.gmail.com>
 <29b888f5-5e8e-73fe-18db-6c5dd57c6b4f@iogearbox.net> <20201011082657.GB15225@wunner.de>
 <20201121185922.GA23266@salvia>
In-Reply-To: <20201121185922.GA23266@salvia>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 21 Nov 2020 19:24:24 -0800
Message-ID: <CAADnVQK8qHwdZrqMzQ+4Q9Cg589xLX5zTve92ZKN_zftJg_WHw@mail.gmail.com>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Lukas Wunner <lukas@wunner.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 21, 2020 at 10:59 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> We're lately discussing more and more usecases in the NFWS meetings
> where the egress can get really useful.

We also discussed in the meeting XYZ that this hook is completely pointless.
Got the hint?
