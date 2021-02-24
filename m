Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6020D324488
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 20:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236131AbhBXTSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 14:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235714AbhBXTSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 14:18:37 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A252C06178C;
        Wed, 24 Feb 2021 11:17:46 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id p21so2094079pgl.12;
        Wed, 24 Feb 2021 11:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PoFse0h7p1pQu5vNyVHU3FisUtli9cY5dMzNMXLo02w=;
        b=gLLRl1DlIflacsN0s7JghpcyF1iD3Kws5neEh+KNIjKmMCcb0zRWCtJqBQMuAhWEcY
         wKI0iZjyTB8bJb163wstscUn8ABUl1rKdcH1V8M07sACMGblv4EUy+05gWZ1ciBlNQwI
         oxrvTy62QyAZZBCTDsuWe3vJkgexjVeBsmeeXPLO45f+eQNKvDZS8eGQ8uBOHB2GBn/W
         2P0QeS6lKXCyLau87DNAp1c6LAuQSCJDVI8k2HZiKwz3ZGiJNE1IBz1e5iSmiV1HdS5j
         XcxRQ/dK/0ntXV5EUmTGgS4tqPFygV8EiwJKIhKme3eCI5v0VxJMXlc4aVAoqPWMpD/X
         r5Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PoFse0h7p1pQu5vNyVHU3FisUtli9cY5dMzNMXLo02w=;
        b=nFgRH2BYiIZjWrn16tqf7bpbpaKtVpBJ5Dk7SCH/DooqnyqyKwb/uSn6N/bkv+Np39
         9GuNXh0eR7gvYVWzOjPIDnVR35GsqG347FSHrOWjdcTAV5t6AzjnI8x7ECAyzKA9VDFC
         F0a+BU5+FKfa0sfUO8gMCRtkRV/a1W+o/CXexbOm/1SbSvM95iKL+YvT3N4NmnSeYaB1
         vSM2pvj26iPFVK46SQDOBbG1pmHz22XVG1HtKDmioew8nwECBjhhNLZVhnFdjacsCoDw
         7dpzF+rJ1P8SjDLvUmgHDK1/PpfwE90ZBI8Jwk3lGt7VY5TNrjn+674UNTGdubFVmdOd
         5PIg==
X-Gm-Message-State: AOAM533UboULVml8EFpWCXsiOHr9+HqXJWTcZq144Qg91oOXjML4EEAy
        Rch4dPPvz+EBN6KNEsY1eJNq73MqU2mxeRXR1kc=
X-Google-Smtp-Source: ABdhPJzaLvSkcWT3FrXlEiXWPnN0zowfYYNjUMNrENA7lvwLZ1When1abacyToNTJL5XhGNliEyuUyahBufv+37I+SU=
X-Received: by 2002:a63:4f1f:: with SMTP id d31mr31014465pgb.104.1614194265952;
 Wed, 24 Feb 2021 11:17:45 -0800 (PST)
MIME-Version: 1.0
References: <20210224081403.1425474-1-liuhangbin@gmail.com>
In-Reply-To: <20210224081403.1425474-1-liuhangbin@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Wed, 24 Feb 2021 11:17:09 -0800
Message-ID: <CALDO+SaW9UxeVjCTPPG5p9bMd+WbjnCW=PMsQOdbN6VNcn+UQQ@mail.gmail.com>
Subject: Re: [PATCH net] selftest/bpf: no need to drop the packet when there
 is no geneve opt
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yi-Hung Wei <yihung.wei@gmail.com>,
        David Miller <davem@davemloft.net>, bpf <bpf@vger.kernel.org>,
        Jiong Wang <jiong.wang@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 12:37 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> In bpf geneve tunnel test we set geneve option on tx side. On rx side we
> only call bpf_skb_get_tunnel_opt(). Since commit 9c2e14b48119 ("ip_tunnels:
> Set tunnel option flag when tunnel metadata is present") geneve_rx() will
> not add TUNNEL_GENEVE_OPT flag if there is no geneve option, which cause
> bpf_skb_get_tunnel_opt() return ENOENT and _geneve_get_tunnel() in
> test_tunnel_kern.c drop the packet.
>
> As it should be valid that bpf_skb_get_tunnel_opt() return error when
> there is not tunnel option, there is no need to drop the packet and
> break all geneve rx traffic. Just set opt_class to 0 in this test and
> keep returning TC_ACT_OK.
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---

LGTM.
Acked-by: William Tu <u9012063@gmail.com>
