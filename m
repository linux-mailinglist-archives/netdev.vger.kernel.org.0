Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C711DD315
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 18:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgEUQ32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 12:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgEUQ31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 12:29:27 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0D4C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 09:29:26 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id h74so433676vka.7
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 09:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RhEeRfqdkObkhGsElXqWwZs4aE3s+Kzf3TF2yAviih0=;
        b=Hf5Um9RoLQTew03ZdQl4ZrHvgNLP0o1EtznryY+rB4QKcBAdtzpGQzxxkvXyy+GNG/
         hxJsqWg1o1/1zCZZGut0+ZE/K+YhELev9RGdB0Gz5asPwrS9qkD8I/S+eh+WP/q+cA3X
         KBzbdLUX3FLa+pwgShu8vuZOLEg4I0By5jq3SHLGJu0VjikMI5nW198wHagYWXiaC1ev
         fTLLTf+i8zgOr3+7zp7vgTcFGGhOLNRgIU47WGzT09A3jBv1EDewXvEBnMsEJc/jaRxK
         fP78dT1RE89ylNFMUVsmHaKFovqHJ8mZqtWerrhHeQxCRiR7/7b9osJFa7A3MQKOQlCA
         98iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RhEeRfqdkObkhGsElXqWwZs4aE3s+Kzf3TF2yAviih0=;
        b=fVsJRjrVD7Zcz0BHKl0z7tB2VxfXhceq+DvgM12U3e0X7jK+p8mfy3WDENlZc4Cphm
         fOUq4ConsuNU5A3LwH+VN9RP/cxqJkeXp8TPXmPHm3vS2iglFI4wL4jlRWQRjZATYGg+
         0mXG7nQS4H+gHr3oTv5BxQOavQVD7TskLTbs9GnvuxTPvmTeHpUzU1AtnbfGUo74iH6D
         SDHQ25xFuOC4ZXQ2dI/WbvRGeF9Xx7jvKZTJtSebu7RFvxhF/nQa6WoWxsyngmpEwmGJ
         E5366U2IFoZRIHOrTs1JHvvHapw9KKE2JIW7RocLySeyTvPEgmuh5oMEElWjS26VAiSM
         Oz6g==
X-Gm-Message-State: AOAM530YnagekPAL2/KEY0JGhJL7YyhStPZ5Wr4fZhAdn3GqxPJvcj10
        vUCBEI00juZ7l9Yu/EQM9WZ56KTRybWG8rcIpQE=
X-Google-Smtp-Source: ABdhPJyzTiY4qGyVKLgtRgITb1fxHS6KeLwvPcA4HYH1XluvAjTEioCD79E8t9Bq1nXBxUe8M19eJ92P16JW97X+v5g=
X-Received: by 2002:a1f:b68e:: with SMTP id g136mr8553299vkf.16.1590078565599;
 Thu, 21 May 2020 09:29:25 -0700 (PDT)
MIME-Version: 1.0
References: <1589964104-9941-1-git-send-email-vfedorenko@novek.ru> <20200520134655.15fead0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200520134655.15fead0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Pooja Trivedi <poojatrivedi@gmail.com>
Date:   Thu, 21 May 2020 12:29:22 -0400
Message-ID: <CAOrEdsmuoAUD2o8mnpTyuZFGZeZyx-6pH+1Hb-T=s2d_edmPfQ@mail.gmail.com>
Subject: Re: [net v3 0/2] net/tls: fix encryption error path
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 4:46 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 20 May 2020 11:41:42 +0300 Vadim Fedorenko wrote:
> > The problem with data stream corruption was found in KTLS
> > transmit path with small socket send buffers and large
> > amount of data. bpf_exec_tx_verdict() frees open record
> > on any type of error including EAGAIN, ENOMEM and ENOSPC
> > while callers are able to recover this transient errors.
> > Also wrong error code was returned to user space in that
> > case. This patchset fixes the problems.
>
> Thanks:
>
> Acked-by: Jakub Kicinski <kuba@kernel.org>
>
> Pooja, I think Vadim's fix to check the socket error will make changes
> to handling of -EAGAIN unnecessary, right?

Correct, yes.

> Still would be good to get
> that selftest, triggering EAGAIN should be quite simple.

Agree.
