Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C4E3921EB
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 23:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbhEZVY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 17:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233897AbhEZVYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 17:24:23 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AF6C06175F
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 14:22:50 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id g7so3236779edm.4
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 14:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7bWUzz3mXf4ng9N21e9bEjKKU0Rq54acZv1GkQ/xcY0=;
        b=QfikG8wrkmC0m3tXTYmZxodBn7Xg0IuuRN5Yz3uWBPt5XyG519/kEF/cjtKsVu/DFb
         742PzlhLYjmMM/bR+ePUG+ZTOFghKJ6xJ0RwXste9wLuIVJwVI3mhrv/z8q8e3sjkBji
         rJV76aXN2p6COObuBp/p54lbINi2h51pKqhPZBRdDMMFtSP1GKYMgwWFuyVBMaAFdt4c
         5wZpGepxAhDtKDr2DvOanz0U9WZ47xdlGyxAbvOlmY43TzDCEcl8CaGYf4DU32f54T4h
         l6vEZbyLAkOqiAu2AmXR/oaQ5x7lbtCuNFF0sZ9e8xvMHo5lmvUiDOumNNLZor0DU78J
         SfCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7bWUzz3mXf4ng9N21e9bEjKKU0Rq54acZv1GkQ/xcY0=;
        b=gcKvPufEu3QcDjZFM+Q+fbQcFo8MtRsvMJR396ATk1H9Fqs24LDitTNhZ3EQww+mnw
         CuERqMRWG7BNXOyfMXlVsum4jLqZbFc7elptaSH+00PCJ8AyRBCfYKIznSDdhWtQoAth
         lGYMC0i+0OMsMZtlcyplnpzao5fqJBCAdpssFf2TChASnahzWr7CHVZPGDmYbBMxycNc
         jWrHf0OEH3ytlmb/K6DGO+HZJcPd59KaW+OR4ZlvncvoteT/gSRsr5ksUgRgJqaVZPOD
         60HcMPrhjBEBMHfH1Og4QRYroeuVhx1Fm6SqccremliLU4aT+XSA8Os4dm45Ntf01CWY
         2AnA==
X-Gm-Message-State: AOAM533ieWsaPfocP9S77bEyQe9GyfcD5wroPKObH8fbAjSh1PeLJNCa
        zTay+HkUS3z0pzDWaa4virR3ZXeEZYiLOg==
X-Google-Smtp-Source: ABdhPJwjNKeZ3+feeoQ+JoR5E8zR3rkw2x27vj4+q9EKpcj3To+f8Pha9jcIgb1UZmWzr3fuGAp1tA==
X-Received: by 2002:a05:6402:4301:: with SMTP id m1mr240631edc.182.1622064168643;
        Wed, 26 May 2021 14:22:48 -0700 (PDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com. [209.85.128.48])
        by smtp.gmail.com with ESMTPSA id cd8sm119082ejb.46.2021.05.26.14.22.47
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 14:22:47 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id z137-20020a1c7e8f0000b02901774f2a7dc4so4068656wmc.0
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 14:22:47 -0700 (PDT)
X-Received: by 2002:a05:600c:2209:: with SMTP id z9mr337264wml.120.1622064166487;
 Wed, 26 May 2021 14:22:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210526082423.47837-1-mst@redhat.com> <20210526082423.47837-5-mst@redhat.com>
 <18b47c22-8c8a-7699-ffaf-ccfdcbf39d37@gmail.com>
In-Reply-To: <18b47c22-8c8a-7699-ffaf-ccfdcbf39d37@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 26 May 2021 17:22:08 -0400
X-Gmail-Original-Message-ID: <CA+FuTSetvnwCzyuFkypkXgYycsMe1B3brW93upmg+KjGsgD-gA@mail.gmail.com>
Message-ID: <CA+FuTSetvnwCzyuFkypkXgYycsMe1B3brW93upmg+KjGsgD-gA@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] virtio_net: disable cb aggressively
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 11:15 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 5/26/21 10:24 AM, Michael S. Tsirkin wrote:
> > There are currently two cases where we poll TX vq not in response to a
> > callback: start xmit and rx napi.  We currently do this with callbacks
> > enabled which can cause extra interrupts from the card.  Used not to be
> > a big issue as we run with interrupts disabled but that is no longer the
> > case, and in some cases the rate of spurious interrupts is so high
> > linux detects this and actually kills the interrupt.

Temporarily disabling interrupts during free_old_xmit_skbs in
virtnet_poll_cleantx might reduce the spurious interrupt rate by
avoiding an additional Tx interrupt from being scheduled during
virtnet_poll_cleantx.

It probably does not address all spurious interrupts, as
virtnet_poll_cleantx might also run in between the scheduling of the
Tx interrupt and the call to virtnet_poll_tx, right? The Tx and Rx
interrupts racing.

If I can reproduce the report, I can also test how much this helps in practice.

> > Fix up by disabling the callbacks before polling the tx vq.
>
>
> It is not clear why we want to poll TX completions from ndo_start_xmit() in napi mode ?

Yes, we can simply exclude that. The original napi-tx patch did not
make that change, but not for any strong reason.
