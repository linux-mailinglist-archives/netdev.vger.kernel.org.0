Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3431B2E6C5F
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbgL1Wzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729349AbgL1Tw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 14:52:29 -0500
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09242C0613D6
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 11:51:49 -0800 (PST)
Received: by mail-ua1-x92b.google.com with SMTP id k47so3686564uad.1
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 11:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zzyjd88NUbxeK6ogA3JXthDFCQ1wxhoB9rYZKCKLlyk=;
        b=ln4L3Lw7MRyfZYMURHOVQ/6Q+rtDd1F16YYABE2HRAKpLkQ+Z+znsJprN+n0CQWh0n
         WUE1nt0HHttwIpNrZeJgMPCQIDzUYa6ylf3rg+x3+SpsZGaOD3+VDydr6wJUJzxwmNQX
         wek2Od4vkwkXRJWGJZkfugjcut1pUEeXrN8OmzHFOKy/FvKwKkm6wOWwRXKa/JUiJ7va
         HbJA4urwcfQxHgh/ciGfSzbPiFV0HPYpoVFzKhxRYkTjCLrDV1khyxJNTTcutQy7cjzF
         KFjLe7ktglKjKEsB58whX/4elHCkOXIarUjpaT4hKYOxaQs9SsnzVWe2sWogkM9NfIze
         vmmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zzyjd88NUbxeK6ogA3JXthDFCQ1wxhoB9rYZKCKLlyk=;
        b=AdfrTd1YG579hVCEvaQVcF0Z0FKBM3iXlXjFGC/rODy+gCYjK3cPOk8ovARMlCWbuZ
         5VSfQTC0cCp+0oV0rPxynC7F4DA2Cs6tqB/AWA+JQlNGQoW+geyMllijUg6EixiSMFMG
         +begnZaBQapNwIfqZXUBl1rJpFFEvwrmQef/aolk6Om82HRXXOeffLAijt+5jLrggOmm
         zwwaaaDHPYb4Pp4fRgILoI5m+lridPzVG2HwjjNZkvggLPxrIXPJgSMCQeHdveNajnHU
         VPBNMYGuvNCygNOmeDlRK6zN3pjmrbjI6/FnxBrbEfsM0wB0D3EOoEZMszvgSzGO4TEf
         cfgA==
X-Gm-Message-State: AOAM531BxcsFJ9I47EvkrBt6iZak2lxwLJULGeWq5u+Kb2Qjy2XNiFN5
        zl7B4Z8hRoKZWVIiE9W3FUb8f2qG4z0=
X-Google-Smtp-Source: ABdhPJwUJKGyMP87tjxsaAjxHKJioyhVCddLpAImBUGYvHpfPrSVfcGt1xUaMjKoVEz1RpayXpxzxg==
X-Received: by 2002:ab0:3359:: with SMTP id h25mr28726848uap.76.1609185107732;
        Mon, 28 Dec 2020 11:51:47 -0800 (PST)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com. [209.85.222.50])
        by smtp.gmail.com with ESMTPSA id q124sm3790079vsd.6.2020.12.28.11.51.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Dec 2020 11:51:47 -0800 (PST)
Received: by mail-ua1-f50.google.com with SMTP id f29so3688824uab.0
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 11:51:46 -0800 (PST)
X-Received: by 2002:ab0:7386:: with SMTP id l6mr30028720uap.141.1609185106156;
 Mon, 28 Dec 2020 11:51:46 -0800 (PST)
MIME-Version: 1.0
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com> <20201228122911-mutt-send-email-mst@kernel.org>
In-Reply-To: <20201228122911-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 28 Dec 2020 14:51:09 -0500
X-Gmail-Original-Message-ID: <CA+FuTScXQ0U1+rFFpKxB1Qn73pG8jmFuujONov_9yEEKyyer_g@mail.gmail.com>
Message-ID: <CA+FuTScXQ0U1+rFFpKxB1Qn73pG8jmFuujONov_9yEEKyyer_g@mail.gmail.com>
Subject: Re: [PATCH rfc 0/3] virtio-net: add tx-hash, rx-tstamp and tx-tstamp
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 12:29 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Dec 28, 2020 at 11:22:30AM -0500, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > RFC for three new features to the virtio network device:
> >
> > 1. pass tx flow hash and state to host, for routing + telemetry
> > 2. pass rx tstamp to guest, for better RTT estimation
> > 3. pass tx tstamp to host, for accurate pacing
> >
> > All three would introduce an extension to the virtio spec.
> > I assume this would require opening three ballots against v1.2 at
> > https://www.oasis-open.org/committees/ballots.php?wg_abbrev=virtio
> >
> > This RFC is to informally discuss the proposals first.
> >
> > The patchset is against v5.10. Evaluation additionally requires
> > changes to qemu and at least one back-end. I implemented preliminary
> > support in Linux vhost-net. Both patches available through github at
> >
> > https://github.com/wdebruij/linux/tree/virtio-net-txhash-1
> > https://github.com/wdebruij/qemu/tree/virtio-net-txhash-1
>
> Any data on what the benefits are?

For the general method, yes. For this specific implementation, not  yet.

Swift congestion control is delay based. It won the best paper award
at SIGCOMM this year. That paper has a lot of data:
https://dl.acm.org/doi/pdf/10.1145/3387514.3406591 . Section 3.1 talks
about the different components that contribute to delay and how to
isolate them.

BBR and BBRv2 also have an explicit ProbeRTT phase as part of the design.

The specific additional benefits for VM-based TCP depends on many
conditions, e.g., whether a vCPU is exclusively owned and pinned. But
the same reasoning should be even more applicable to this even longer
stack, especially in the worst case conditions.
