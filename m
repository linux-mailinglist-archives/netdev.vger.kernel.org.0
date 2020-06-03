Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852511ECF44
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 14:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgFCMCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 08:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgFCMCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 08:02:32 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3CDC08C5C1
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 05:02:31 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id s192so406008vkh.3
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 05:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=amz3ptynYvAUbH138IEG0LpKVjBvo8sPz/3+J+n07a8=;
        b=vHb999opMIzMza943w3iNjuwx1RH0ULq9DdNFIBNl056bXrXRIJUZCp5ljes0uQYaC
         309fs8zXNrFuwkmvoCWzKa6rp8w9ceaeFZctOEppExt9mu/tjfs7uxgg3XwTDj17BaCx
         zuOP9aqU7YiYeUOCR996/cgXzMGIUJiha2Iugh6txTnHMKIbNmP2nYml5bi2zGfpnI95
         6X/rnhb1zqoT6HuDf6UsdUfLNnVViv0Xht5/UFu06NY4SkwuEPWX8Znuko1EjeNchIYA
         KD8cWO+wMbh8V0jruPN2A13TRw4dm2Ic+XZt97mUzktOTdnbRmf0ISYUUE7SfY5RQfax
         Pztg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=amz3ptynYvAUbH138IEG0LpKVjBvo8sPz/3+J+n07a8=;
        b=fe3QGqJoZOghNXxi9m/hgZ8N2qFfpNa6qRxjUWOzXkE0cA5TmJuCgcpNZHVBNYGTjk
         ZbhKnTaXLVvRV8LoVo5jn9vaUHorpJUlIr8sefTAyObXMbm9LVz+E96Whtl69pbmsSfn
         dkx9VcwlTOx8KMt57tYhdkw5Iil06NR6PlDWq+szhnaXaFH20flbCbPl5gr4fDqF+o0A
         G7xyJFUX7/6aOn6p4wx2XkQWEKru7owLTZRmWc7KGZJSiietLCiw1BjxGmegCHJF6kCA
         bLyq/XocP38H2tzrgpasdX7ABaXMxYJSMkqcRqq6d1xUEJe7HBCQmzmHMVinWdq+GW7X
         cOGw==
X-Gm-Message-State: AOAM5316m0jph9FH4g8DFaxStpfsuySil+ekSawZ6pgFjWqYSSX2u39c
        R3VYT7vppNmiWf1RAf8lQJjW4Qwc1IU9fhsnYXTXbQ==
X-Google-Smtp-Source: ABdhPJxDaY9hHU9C9cqqrvDdwtLQXU+4TVbmTzqYFpSK6jRNSb3vAPXpIT+DTQmUBmYd1hclvqBGerS3oaC4/gGhIBw=
X-Received: by 2002:a05:6122:34:: with SMTP id q20mr7714782vkd.66.1591185750265;
 Wed, 03 Jun 2020 05:02:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200602080425.93712-1-kerneljasonxing@gmail.com>
 <CANn89iLNCDuXAhj4By0PDKbuFvneVfwmwkLbRCEKLBF+pmNEPg@mail.gmail.com>
 <CAL+tcoBjjwrkE5QbXDFADRGJfPoniLL1rMFNUkAKBN9L57UGHA@mail.gmail.com>
 <CANn89iKDKnnW1na_F0ngGh3EEc0quuBB2XWo21oAKaHckdPK4w@mail.gmail.com>
 <CAL+tcoDn_=T--uB0CRymfTGvD022PPDk5Yw2yCxvqOOpZ4G_dQ@mail.gmail.com>
 <CANn89i+dPu9=qJowhRVm9d3CesY4p+zzJ0HGiCMc_yJxux6pow@mail.gmail.com>
 <CAL+tcoC2+vYoFbujkLCF7P3evfirNSBQtJ9bPFHiU2FGOnBo+A@mail.gmail.com> <CANn89iJfLM2Hz69d9qOZoRKwzzCCpgVRZ1zbTTbg4vGvSAEZ-w@mail.gmail.com>
In-Reply-To: <CANn89iJfLM2Hz69d9qOZoRKwzzCCpgVRZ1zbTTbg4vGvSAEZ-w@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 3 Jun 2020 08:02:13 -0400
Message-ID: <CADVnQy=RJfmzHR15DyWdydFAqSqVmFhaW4_cgYYAgnixEa5DNQ@mail.gmail.com>
Subject: Re: [PATCH] tcp: fix TCP socks unreleased in BBR mode
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jason Xing <kerneljasonxing@gmail.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, liweishi@kuaishou.com,
        Shujin Li <lishujin@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 3, 2020 at 1:44 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Jun 2, 2020 at 10:05 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> >
> > Hi Eric,
> >
> > I'm still trying to understand what you're saying before. Would this
> > be better as following:
> > 1) discard the tcp_internal_pacing() function.
> > 2) remove where the tcp_internal_pacing() is called in the
> > __tcp_transmit_skb() function.
> >
> > If we do so, we could avoid 'too late to give up pacing'. Meanwhile,
> > should we introduce the tcp_wstamp_ns socket field as commit
> > (864e5c090749) does?
> >
>
> Please do not top-post on netdev mailing list.
>
>
> I basically suggested double-checking which point in TCP could end up
> calling tcp_internal_pacing()
> while the timer was already armed.
>
> I guess this is mtu probing.

Perhaps this could also happen from some of the retransmission code
paths that don't use tcp_xmit_retransmit_queue()? Perhaps
tcp_retransmit_timer() (RTO) and  tcp_send_loss_probe() TLP? It seems
they could indirectly cause a call to __tcp_transmit_skb() and thus
tcp_internal_pacing() without first checking if the pacing timer was
already armed?

neal
