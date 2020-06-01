Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D90D1EB0E7
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 23:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbgFAVXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 17:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgFAVXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 17:23:38 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA94C061A0E;
        Mon,  1 Jun 2020 14:23:38 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id 202so4813355lfe.5;
        Mon, 01 Jun 2020 14:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H2b28AkIEl8cTTOnSvSwRsLMj8pDY11OVKWEIgc0mGY=;
        b=XsekpyEm+5Xn61AEAPS7v3MqalHbMC2MXcaXKOmkzjQo10uFt1DRTK2RQULzRL3pWv
         lzWJCZ5TlskshiZJ+2RTYRm9aRcn+gBW+gPQL97Say73gv0pNVtA49soCjtclFFgTwAY
         ducc+vCLTwtWi46NvjZPg+Oti3IfG+aliogznZqF5yLx27bnS2jdT2qQ4vb6yk4e5uep
         AhnPsoHwcXofl5C35uHT92nZfvzmleP/iOAsPx7LgSSjsw4WB6usmYBdLJtf0ch9+ruO
         NBhFQnufe/vzKWtVK1XAD0UbJ4ODwZAh3WDeWNC1esU6E3G/fjXWfGD/R9Gy/uv4rQIs
         c7Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H2b28AkIEl8cTTOnSvSwRsLMj8pDY11OVKWEIgc0mGY=;
        b=KbLrgdC0avM6byVOHL+sIdbSi8BvjIPSrup6sm7cVeoJJnTieUXEkGfFXl4KrdszcH
         KuwWP5HW/nMClSMmy2sWczwl/ZUm3X6yJSgEjvKDRzLqLhhhINA0lhl3umLZBxwKQ4Wq
         5bxFCd/tuuWIQ906eDoryjBAHf+EPLhkxbQ94+oQ+8opI9Gw0/DCeenHC+auL7njXWHa
         5ZcteSOkuw6J2zAMc3OUHcFmErm/BYbzbeKobWI2/rR0DDMuV1u2eVAW37WYYIqONUK8
         TjE93Jrqxg7dyEsyTenXgHIsJ7gve4PKtln6vjLz11rTXTDKtkCGh+DKA3alvYFQpgQh
         3saQ==
X-Gm-Message-State: AOAM532Dmma3cyC8rZ66uhsH1HlPE7GjFwRbU5RYlLOnrF1zqVc7cFeC
        yrNX+FMKHAYUwagUI+BZW2yfWPkeUTknaVsG2LT3WQ==
X-Google-Smtp-Source: ABdhPJyDNeHW02meK621RTVpww8SqO92MrRK8y8cHP48Q3zWX/DgXHR5btr6zdLjjFjbjktFTVri0TQnOn+6nG1w/Ks=
X-Received: by 2002:a19:987:: with SMTP id 129mr12253517lfj.8.1591046616932;
 Mon, 01 Jun 2020 14:23:36 -0700 (PDT)
MIME-Version: 1.0
References: <159079336010.5745.8538518572099799848.stgit@john-Precision-5820-Tower>
 <159079361946.5745.605854335665044485.stgit@john-Precision-5820-Tower>
 <20200601165716.5a6fa76a@toad> <5ed51cae71d0d_3f612ade269e05b46e@john-XPS-13-9370.notmuch>
In-Reply-To: <5ed51cae71d0d_3f612ade269e05b46e@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 1 Jun 2020 14:23:25 -0700
Message-ID: <CAADnVQ+2NTdyKY+ZX3xW965h8_PGRimy9se=iqW6AvmnB8v7wg@mail.gmail.com>
Subject: Re: [bpf-next PATCH 2/3] bpf: fix running sk_skb program types with ktls
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 1, 2020 at 8:20 AM John Fastabend <john.fastabend@gmail.com> wrote:
> > > @@ -1793,11 +1795,12 @@ int tls_sw_recvmsg(struct sock *sk,
> > >
> > >             if (to_decrypt <= len && !is_kvec && !is_peek &&
> > >                 ctx->control == TLS_RECORD_TYPE_DATA &&
> > > -               prot->version != TLS_1_3_VERSION)
> > > +               prot->version != TLS_1_3_VERSION &&
> > > +               !sk_psock_strp_enabled(psock))
> >
> > Is this recheck of parser state intentional? Or can we test for
> > "!bpf_strp_enabled" here also?
>
> Yes I'll fix it up to use bpf_strp_enabled. Thanks

I fixed that bit and applied the set.

Thanks!
