Return-Path: <netdev+bounces-8184-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3EAD722FCA
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:27:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FCA6281240
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:27:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB0592415F;
	Mon,  5 Jun 2023 19:27:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1B8DDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:27:40 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427B9A7
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:27:39 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-977e83d536fso144915666b.3
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 12:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685993258; x=1688585258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a9PpPv6SChUQdCvmK/K6I38TlAflXmLSfSOAXtO2e4c=;
        b=hPKVP0w72zNMu+pnXJt+ll9e3TrJ1hZbyrH0udDAQzQX86xzZqdWKPZmkq6PYT1KAG
         BBmBA7GjJcpK89J2sDan7s1Ajgo1SxePPGsJHo2FcEMcoIpxqDnQYJ52fOfY7zxQBrmX
         g9cuIdRAtYOwvEsbvvb8ePdXil9yW3ALacZuYcMI9QkP20oYi4omPcS2WkjaIhqw+Jwe
         yYfivaLAy0oLoK+tjjEt8LCsIzL174Q++hsgDOO3RSEIl9ObWFzR0kJN1CU/K3J27jSz
         k2Q8gdGmj3DIho75mgUo8V27dZryUv2xHyT94+KRIw4HMAf8Kk/v5n3JOBs81+QvtBYq
         iHjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685993258; x=1688585258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a9PpPv6SChUQdCvmK/K6I38TlAflXmLSfSOAXtO2e4c=;
        b=G1rE8+36qXwuTWrlsKikJqjIiDPgDsYLoHrCGCFelzrgvZCrg564Fc/dC+Rspk1g9z
         lhbdXUtKB6NXh5C4Z3nDE716zafV6KvdvQ+ZkhAx11TOu4TsnU67NcJRYvH2BexY1H5e
         aCuUab6+PvX3IWxNUjVSCBQKfmgVJOAP/Eh7Qckjc/LAvG6R0izSMHq1m2h1mZwjC6X+
         ukMYuHmQXjx0inoE4iXf8+oyl57nkajzy1RPhvP+bFvosKQgQ4m5SY8PkcVFLVf5oCvX
         Ju1ws01jimdfj2K4XRCR3yqfdtycysMT8B0nO21BXtV+2dFVbwn6ZPG0NYK7Sy/BIH/1
         0Mjw==
X-Gm-Message-State: AC+VfDwwEtq2h892FjpnygM5WbFnD1BCwDv5LGt9r4abLSe4M59oZwtj
	hcOdwqK14AyQ5WaPw4dFUmZVldfRLVr5elgmgKs=
X-Google-Smtp-Source: ACHHUZ7avQJjBnwupRvabhj/KvgYPA9RJ1HUBOPjO7I9ozp95Xu1VILY4N0aKg4WLYA2C3oeDsyKs8kXoGT63RkgWaQ=
X-Received: by 2002:a17:907:970b:b0:977:ccc6:1d73 with SMTP id
 jg11-20020a170907970b00b00977ccc61d73mr4629752ejc.71.1685993257563; Mon, 05
 Jun 2023 12:27:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20210123045321.2797360-1-edwin.peer@broadcom.com>
 <20210123045321.2797360-2-edwin.peer@broadcom.com> <1dc163b0-d4b0-8f6c-d047-7eae6dc918c4@gmail.com>
 <CAKOOJTwKK5AgTf+g5LS4MMwR_HwbdFS6U7SFH0jZe8FuJMgNgA@mail.gmail.com>
 <CAKOOJTzwdSdwBF=H-h5qJzXaFDiMoX=vjrMi_vKfZoLrkt4=Lg@mail.gmail.com>
 <62a12b2c-c94e-8d89-0e75-f01dc6abbe92@gmail.com> <CAKOOJTwBcRJah=tngJH3EaHCCXb6T_ptAV+GMvqX_sZONeKe9w@mail.gmail.com>
 <cdbd5105-973a-2fa0-279b-0d81a1a637b9@nvidia.com> <20230605115849.0368b8a7@kernel.org>
In-Reply-To: <20230605115849.0368b8a7@kernel.org>
From: Edwin Peer <espeer@gmail.com>
Date: Mon, 5 Jun 2023 12:27:26 -0700
Message-ID: <CAOpCrH4-KgqcmfXdMjpp2PrDtSA4v3q+TCe3C9E5D3Lu-9YQKg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] netlink: truncate overlength attribute list
 in nla_nest_end()
To: Jakub Kicinski <kuba@kernel.org>
Cc: Gal Pressman <gal@nvidia.com>, David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>, 
	Andrew Gospodarek <andrew.gospodarek@broadcom.com>, Michael Chan <michael.chan@broadcom.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, Michal Kubecek <mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 11:58=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> [Updating Edwin's email.]
>
> On Mon, 5 Jun 2023 10:28:06 +0300 Gal Pressman wrote:
> > On 26/01/2021 19:51, Edwin Peer wrote:
> > > On Mon, Jan 25, 2021 at 8:56 PM David Ahern <dsahern@gmail.com> wrote=
:
> > >
> > >> I'm not a fan of the skb trim idea. I think it would be better to fi=
gure
> > >> out how to stop adding to the skb when an attr length is going to ex=
ceed
> > >> 64kB. Not failing hard with an error (ip link sh needs to succeed), =
but
> > >> truncating the specific attribute of a message with a flag so usersp=
ace
> > >> knows it is short.
> > >
> > > Absent the ability to do something useful in terms of actually
> > > avoiding the overflow [1], I'm abandoning this approach entirely. I
> > > have a different idea that I will propose in due course.
> > >
> > > [1] https://marc.info/?l=3Dlinux-netdev&m=3D161163943811663
> > >
> > > Regards,
> > > Edwin Peer
> >
> > Hello Edwin,
> >
> > I'm also interested in getting this issue resolved, have you had any
> > progress since this series? Are you still working on it?

Hi Kuba,

Thanks for the CC, I left Broadcom quite some time ago and am no
longer subscribed to netdev as a result (been living in firmware land
doing work in Rust).

I have no immediate plans to pick this up, at least not in the short
to medium term. My work in progress was on the laptop I returned and I
cannot immediately recall what solution I had in mind here.

Regards,
Edwin Peer

