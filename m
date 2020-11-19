Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B2D2B9B66
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgKSTSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbgKSTSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 14:18:43 -0500
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8908DC0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 11:18:43 -0800 (PST)
Received: by mail-vs1-xe31.google.com with SMTP id u7so3663326vsq.11
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 11:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nTLXgJ7tjkUnS0k+PgjHQTXYh/dqj7H+3M1TqSVN6vk=;
        b=Tx6kO2YIoRItgdgHsiq+oafjpE7Mw3Eh6v6oDE0qg8gUmBfueiGiQ9ycN5nYT4wlC4
         RLPEJjy7WVjsSqbVNWhrm9A1ZsLCFZ5Rwvv9ZsnvLyF7qctQWLRTijlTHLR+ImP+GqbG
         EqmvEGZqFilixaiqHKRiNI6WAktVtGqVtQVIQI/nkttd92omVYa9NkByl1ijTKNlEvWD
         x3WvLHe6jPPjni2YKZ9SSSjh9GWlQybWg4YXO/P/sJnP36B/+/PpQ4riiRbC57tgbsWJ
         Vr/0uVIpQ2dsy8uRxKZ8S9nPQQsJajL+WQvIkKuzkKgmLJUPXt05Y4Hb/JjTSsqFHs/1
         9k/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nTLXgJ7tjkUnS0k+PgjHQTXYh/dqj7H+3M1TqSVN6vk=;
        b=CSx5HpKH2e/W+/TMPHYQAG0d5YgnfEBbjRiPk3p2bUmXnKjxVHGhj0qg3TvJi/RXQe
         H5klMCSi9f6MLaZqsvP+BRSZK5SKQEV3tG9nZWpRlkkdDvV4Hl+dswSj4BslxnUSBFd5
         JM4AJHCxZ+4zp+pQdSd6sofIvxtYMngQOQrV9eyTOv9srAM6qwDz+mWQi9On80iU9O/3
         Zh3K0qlstYEz7yte1/Mtvf9kWSUifB7D3XpM+XX7GypuZG6nD6nRQHsuPgkFvCrukLlc
         6spayYAV9pY4it/V6J7PASCcptw55iyMPW43h1y1vheSmnQPdlwi/Fx/E99eanOK8pcN
         leag==
X-Gm-Message-State: AOAM531yE1Kjnz8UBs9CgyhCmMfaLNNVA0+UpnDStqX5KRGg8bDEMHkt
        03PqDwVfDVjq6LnSIwrDJ4XqWLut3kE=
X-Google-Smtp-Source: ABdhPJwKnvWf2Kubp8Ef1ZJ6wnqLTSNVzVeX2PxI/QRxUaWVXKE420FeVceYaWwHt/VsE8wrAVu42g==
X-Received: by 2002:a67:ed4b:: with SMTP id m11mr9265634vsp.14.1605813522312;
        Thu, 19 Nov 2020 11:18:42 -0800 (PST)
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com. [209.85.217.48])
        by smtp.gmail.com with ESMTPSA id b81sm63674vka.53.2020.11.19.11.18.41
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 11:18:41 -0800 (PST)
Received: by mail-vs1-f48.google.com with SMTP id h185so3688025vsc.3
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 11:18:41 -0800 (PST)
X-Received: by 2002:a67:e210:: with SMTP id g16mr10355299vsa.28.1605813520984;
 Thu, 19 Nov 2020 11:18:40 -0800 (PST)
MIME-Version: 1.0
References: <CALx6S353fPF=x4=yr4=a4zYCKVLfCRbFhEKr14A1mBRug7AfaA@mail.gmail.com>
 <1a40fa35-6ef0-5b42-3505-b23763309165@gmail.com>
In-Reply-To: <1a40fa35-6ef0-5b42-3505-b23763309165@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 19 Nov 2020 14:18:04 -0500
X-Gmail-Original-Message-ID: <CA+FuTSffeVqNKtno-RJPfc-t75ZDTG6MhpDvTp-aOJdTEtw3Ww@mail.gmail.com>
Message-ID: <CA+FuTSffeVqNKtno-RJPfc-t75ZDTG6MhpDvTp-aOJdTEtw3Ww@mail.gmail.com>
Subject: Re: Flow label persistence
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Tom Herbert <tom@herbertland.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 1:00 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 11/19/20 4:49 PM, Tom Herbert wrote:
> > HI,
> >
> > A potential issue came up on v6ops list in IETF that Linux stack
> > changes the flow label for a connection at every RTO, this is the
> > feature where we change the txhash on a failing connection to try to
> > find a route (the flow label is derived from the txhash). The problem
> > with changing the flow label for a connection is that it may cause
> > problems when stateful middleboxes are in the path, for instance if a
> > flow label change causes packets for a connection to take a different
> > route they might be forwarded to a different stateful firewall that
> > didn't see the 3WHS so don't have any flow state and hence drop the
> > packets.
> >
> > I was under the assumption that we had a sysctl that would enable
> > changing the txhash for a connection and the default was off so that
> > flow labels would be persistent for the life of the connection.
> > Looking at the code now, I don't see that safety net, it looks like
> > the defauly behavior allows changing the hash. Am I missing something?

Were you thinking of the net.ipv6.auto_flowlabels sysctl that can turn
off the entire feature (but not manually reserved flowlabels):

        if (flowlabel ||
            net->ipv6.sysctl.auto_flowlabels == IP6_AUTO_FLOW_LABEL_OFF ||
            (!autolabel &&
             net->ipv6.sysctl.auto_flowlabels != IP6_AUTO_FLOW_LABEL_FORCED))
                return flowlabel;

        hash = skb_get_hash_flowi6(skb, fl6);
