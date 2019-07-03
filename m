Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7C5B5DB1E
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfGCBrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:47:48 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:43137 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGCBrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 21:47:48 -0400
Received: by mail-yw1-f68.google.com with SMTP id t2so371623ywe.10
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 18:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4pHsUc/95b4xot9oTHX51FihAVuuP1I8UE3xSm/7qSY=;
        b=nKdAI/dFOyPumICkOTGJxzaI2XPIcn3JfND+tkUaVf+3i7GBxJ58ye8U+nzJf0Roe1
         kiC9qawt2y3xt/f3AHBOWrOeszjWx+Y1D3+xMXZ3wrLib3w1Admv2W0m6pZVL63DMLin
         AJgLiIl6W1r1tZbn0PNUCTfIa+BcqWlyvw/V5PpqYpfS37JzgXX5a37eBKWYoCCZbMMK
         fkQ65TIRP4/re/srafKX/h3PA8b4ms5uH75dSxW56xQLtuRSNDSP0MKE34evt04ZIDqs
         LlrPAq3ql1Vongzqro6vgYEYmKSH7qp9gTuACtVA04Sv7/Ney2wAgVrTVJ3PJXPTbZJz
         1+eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4pHsUc/95b4xot9oTHX51FihAVuuP1I8UE3xSm/7qSY=;
        b=PXEptTjTmsKdQgf7F5bSJk/ZxHg7qE3mVK6wooQUPj6w04mmeUksX8aHHE4LgQUjKF
         75MpegLFB4yEPRPoXCjBJcReogW4dlYnO3NYi9RJmMUeW581/BQ+0/ou2HFzfRuW26TZ
         5JXooZzDX20SwrlEa2vgpImdYWgka2K1szeAGxvVZCQAwOMGwn82R69+J1qRN8kMESKw
         Mwi3ygr0PBRzmQPl4coiyZ9v+G10LawD6T/CUCMALQ6cMSy2dcbkeERCVf5oxzDXGhBP
         NtzYa2BjlRVcBmKQthw6YfKCd/BagtMz1E/xaIpu9N991vOXyfqoG01NMR+tiTmU0ElM
         OP7g==
X-Gm-Message-State: APjAAAXOKdLuiaIV9Q2r1TL96WfOsFaBogaJwFWG9fgLqyPIsmeGYn2v
        NCSydpaEmybSpBM0YAMHrqiUNf74
X-Google-Smtp-Source: APXvYqxU088p3f79oRJA0aI975E5u21yC7dz3Dq4P1z57BpVc7i6zQ4+6BMK5Auavq2vQSCX4Ac1cQ==
X-Received: by 2002:a81:4c3:: with SMTP id 186mr20796923ywe.462.1562118467120;
        Tue, 02 Jul 2019 18:47:47 -0700 (PDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id x199sm397723ywd.99.2019.07.02.18.47.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 18:47:46 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id f18so379980ybr.10
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 18:47:45 -0700 (PDT)
X-Received: by 2002:a5b:4c9:: with SMTP id u9mr10014083ybp.235.1562118465542;
 Tue, 02 Jul 2019 18:47:45 -0700 (PDT)
MIME-Version: 1.0
References: <1250be5ff32bc4312b3f3e724a8798db0563ea3c.camel@domdv.de>
 <CA+FuTSdzM3AFFrvANczVzXeRP0TVZ06K--GkmTZVAk-6SKQGxA@mail.gmail.com>
 <94382bd8cfbf924779ce86cd6405331f70f65c27.camel@domdv.de> <CAF=yD-LBRZjns1x9_UrhBYZGX8JNeM+r-cYJV=eyYKDTSG8rBQ@mail.gmail.com>
 <a7c67e7e22103fc7cf02c520a8b42d9aa525700f.camel@domdv.de>
In-Reply-To: <a7c67e7e22103fc7cf02c520a8b42d9aa525700f.camel@domdv.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 2 Jul 2019 21:47:08 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe3=ZuHemWRM5yvdB-shotPeoLnQOqz0CjugtG3ToMiNg@mail.gmail.com>
Message-ID: <CA+FuTSe3=ZuHemWRM5yvdB-shotPeoLnQOqz0CjugtG3ToMiNg@mail.gmail.com>
Subject: Re: [PATCH net 2/2] macsec: fix checksumming after decryption
To:     Andreas Steinmetz <ast@domdv.de>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 3:48 PM Andreas Steinmetz <ast@domdv.de> wrote:
>
> On Tue, 2019-07-02 at 10:35 -0400, Willem de Bruijn wrote:
> > On Tue, Jul 2, 2019 at 12:25 AM Andreas Steinmetz <ast@domdv.de> wrote:
> > > On Sun, 2019-06-30 at 21:47 -0400, Willem de Bruijn wrote:
> > > > On Sun, Jun 30, 2019 at 4:48 PM Andreas Steinmetz <ast@domdv.de>
> > > > wrote:
> > > > > Fix checksumming after decryption.
> > > > >
> > > > > Signed-off-by: Andreas Steinmetz <ast@domdv.de>
> > > > >
> > > > > --- a/drivers/net/macsec.c      2019-06-30 22:14:10.250285314 +0200
> > > > > +++ b/drivers/net/macsec.c      2019-06-30 22:15:11.931230417 +0200
> > > > > @@ -869,6 +869,7 @@
> > > > >
> > > > >  static void macsec_finalize_skb(struct sk_buff *skb, u8 icv_len,
> > > > > u8 hdr_len)
> > > > >  {
> > > > > +       skb->ip_summed = CHECKSUM_NONE;
> > > > >         memmove(skb->data + hdr_len, skb->data, 2 * ETH_ALEN);
> > > > >         skb_pull(skb, hdr_len);
> > > > >         pskb_trim_unique(skb, skb->len - icv_len);
> > > >
> > > > Does this belong in macset_reset_skb?
> > >
> > > Putting this in macsec_reset_skb would then miss out the "nosci:" part
> > > of the RX path in macsec_handle_frame().
> >
> > It is called on each nskb before calling netif_rx.
> >
> > It indeed is not called when returning RX_HANDLER_PASS, but that is correct?
>
> This is correct. Packets passed on with RX_HANDLER_PASS are either not for this
> driver or the special case of being destined for a KaY and in this case being
> the MACsec ethernet protocol and thus not IP, so no checksumming.

So this could have been set in macsec_reset_skb, then? As all relevant cases
call it. Anyway, it's not very important and already merged.
