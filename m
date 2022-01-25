Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1FB249AFFF
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380065AbiAYJW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456547AbiAYJLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:11:50 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2403C0613BD;
        Tue, 25 Jan 2022 00:59:43 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id j10so5582738pgc.6;
        Tue, 25 Jan 2022 00:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D2Pwb8PW5CwIzNE75soX35+MKq6BniCq9jN56JT7JlY=;
        b=LurrwbANv5tg9gFcE3KVTLHWLgmUGBZ7ivGJqedDXBjCImvF47nY3dV+pry1Jd+O25
         JlHdODB5mYqrE3ehzIgW/uMoXMqis0wmNHQ9TqE0iqKymiZviJGRYcphiXBkDrUeuIVW
         4IfSS+d7B6pmCd+5i3HKev2FNnYeIr2Lo2s4gEyoKeT/YfqWcDmlUAvMkypKMErz5+vA
         i5KTZpRlKe3cDAlFjEhJCsNmSU54552YAE95solEj3MH1ChdcYpzNOhoEWJ0qNy52zS0
         Rk5kUM94M9QhUU9yFPfFfkSkwsOgrvPvhH7XdZF7qJxNZ+UXvw7zXzEUUnWOR9oHF1Sa
         BFBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D2Pwb8PW5CwIzNE75soX35+MKq6BniCq9jN56JT7JlY=;
        b=R+jo51EGXVpDyBJJHHXmlqQ2mHgXLPpOIbqjYIKA1rT/CkNcxUtMa3Hn5oR4fQWgTE
         AtK8cQGPh0owjtMIRGzkyJnCItOpcNB8N6xkJ3jNpy5mcFnPykF+YfgOL2buDR4wdw3/
         WYwTl2GlTrDwW9Ze9hCYjx3XEgzAAifmd+mcQ7fbswoLQqDyh4q8I5qhS9qbEICMrchb
         WDOgdgAFfysMH0GYddSEo3SETqaQ87WESjPGZQN9973CDMQY4z/ArNKPWy4jP2av2nbR
         db58rdU0/Yv72dnlakVdvtGdlOHYwjcXd8ibgxh9In7asSO/VdqkjwsLK7FP7coToCE+
         IiBA==
X-Gm-Message-State: AOAM532Z0hZjAWXXGvsScZNYT4Ir66IUygPXB7kkSFGHWwtshfuh/osB
        5ls1VtU/dhRL9k2AbQCsRVMxrv1D6fNZKucW+uh6zFx1cmE/bZlZ
X-Google-Smtp-Source: ABdhPJzbqVHYlYUnRTSnunDpDlCqvGZAPN84D4rCKVyN24U7wwMDeAtnr74qTFMyCpUDYpcG5igCHZdaOYTCry/CUVM=
X-Received: by 2002:a05:6a00:14c7:b0:4c7:4d90:7648 with SMTP id
 w7-20020a056a0014c700b004c74d907648mr15988655pfu.51.1643101183395; Tue, 25
 Jan 2022 00:59:43 -0800 (PST)
MIME-Version: 1.0
References: <20220124165547.74412-1-maciej.fijalkowski@intel.com> <20220124165547.74412-2-maciej.fijalkowski@intel.com>
In-Reply-To: <20220124165547.74412-2-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 25 Jan 2022 09:59:32 +0100
Message-ID: <CAJ8uoz3R1zzqmRO66TVUHEhBJvTd7Lsmf-OZw7aWSE+ZWdgngg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/8] ice: remove likely for napi_complete_done
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 8:38 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Remove the likely before napi_complete_done as this is the unlikely case
> when busy-poll is used. Removing this has a positive performance impact
> for busy-poll and no negative impact to the regular case.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> index 3e38695f1c9d..e661d0e45b9b 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> @@ -1513,7 +1513,7 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
>         /* Exit the polling mode, but don't re-enable interrupts if stack might
>          * poll us due to busy-polling
>          */
> -       if (likely(napi_complete_done(napi, work_done))) {
> +       if (napi_complete_done(napi, work_done)) {
>                 ice_net_dim(q_vector);
>                 ice_enable_interrupt(q_vector);
>         } else {
> --
> 2.33.1
>
