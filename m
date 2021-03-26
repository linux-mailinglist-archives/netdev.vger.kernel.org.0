Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0656934A3F0
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 10:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhCZJPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 05:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhCZJO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 05:14:58 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBBEC0613AA;
        Fri, 26 Mar 2021 02:14:58 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id u19so4177697pgh.10;
        Fri, 26 Mar 2021 02:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SgzpydaaxwAbGB41ZE8dOawZX1Tt0vq9BgQwoxPWDsI=;
        b=p+dzsKL5dajHrKnmHkRDfA3aHRTsIFFavDozBICFP2NsQzLyuxVR4qFmtYv7F7vMhL
         NK+7a03cTxrU+P4RaZ0IPTS7B/MqF706nRAYRBhRBDDRsLFJKr+lAPlYpAf1atkqP7BN
         q5qAgtR+zW6K04bLEGPKx+RsczCf18VVkUm3BvOqGYs0Hg72QqPoCQOq1Xmj0uPN6F1f
         oc7C4NEJGyHedR18wRiSS0JbedRgt+R10aH0LuYRwYm8u1xfSXZ37RUNC4YrfW4YK6in
         PiT5JOTlgizIGkXvMg1nRp56Ravui5zDXHITTohcWOYDgxSxXqnc44msgFfhrO/I+vtP
         czzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SgzpydaaxwAbGB41ZE8dOawZX1Tt0vq9BgQwoxPWDsI=;
        b=oNVhT0UC7xLKvG19cfuhEorm2p23CxiWqvIALe19iSBASeFUeZzcatVlElhj5L4gCf
         a3OfLGalBYWhuFMorchpWiq3vQOOktOivTS/dQ2D/ECzw8fwXIHbCuBXU1/azHY5J63Y
         +xL+4fL58mJybRMcBpznUnZDjqJWu7xrSui21kkygbsK/8rfKyirDX1SQVKeh3aHo22T
         /U8buM1+TTUn1LPXy+/TCndnw2X32J/DHUk6r3v0qMsUW+81dldu4Lvikz1ACb9dMzRF
         LhoEzPINv7RdEeFxLx9L/lKLH60C3xCtnrKE2jU+r9oEnw0ruQqnyNk1J7V1dMG/cb/t
         QHCA==
X-Gm-Message-State: AOAM531XMhDDhXEnR7MTowGWaO2FRUk8FJHlaxcpJ4OzhrRybe7BCekx
        NP/KbbPglqBhui0OyCOd9XsL6t0NLEmh1O8WNgIvUin384LsYEZa
X-Google-Smtp-Source: ABdhPJxrn+f/cdezqSL0SDAlUgGhU0pFWajEJ3ptyxcMLkkjJMBAz/8PxmWvsCuoHw098Cc2ERDdD8TxdFafqG4Q/cU=
X-Received: by 2002:a63:c646:: with SMTP id x6mr11815660pgg.126.1616750097843;
 Fri, 26 Mar 2021 02:14:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210324141337.29269-1-ciara.loftus@intel.com> <20210324141337.29269-2-ciara.loftus@intel.com>
In-Reply-To: <20210324141337.29269-2-ciara.loftus@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 26 Mar 2021 10:14:47 +0100
Message-ID: <CAJ8uoz0VpWpcKQyWoDAY3=WwBotUvMQ2Nk5t33WJJK-a8QmWpg@mail.gmail.com>
Subject: Re: [PATCH bpf 1/3] libbpf: ensure umem pointer is non-NULL before dereferencing
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 3:46 PM Ciara Loftus <ciara.loftus@intel.com> wrote:
>
> Calls to xsk_socket__create dereference the umem to access the
> fill_save and comp_save pointers. Make sure the umem is non-NULL
> before doing this.
>
> Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
>
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  tools/lib/bpf/xsk.c | 3 +++
>  1 file changed, 3 insertions(+)

Thank you for the fix!

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 526fc35c0b23..443b0cfb45e8 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -1019,6 +1019,9 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
>                        struct xsk_ring_cons *rx, struct xsk_ring_prod *tx,
>                        const struct xsk_socket_config *usr_config)
>  {
> +       if (!umem)
> +               return -EFAULT;
> +
>         return xsk_socket__create_shared(xsk_ptr, ifname, queue_id, umem,
>                                          rx, tx, umem->fill_save,
>                                          umem->comp_save, usr_config);
> --
> 2.17.1
>
