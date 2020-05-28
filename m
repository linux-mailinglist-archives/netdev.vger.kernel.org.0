Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3B81E570B
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 07:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgE1Fvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 01:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgE1Fvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 01:51:53 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9863CC05BD1E;
        Wed, 27 May 2020 22:51:52 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id c71so1853867wmd.5;
        Wed, 27 May 2020 22:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HRgq7bWPbVQ6VGJrp0fBqbpNe57Tc4L7lPuzDuEESlg=;
        b=n59iHBOs0c4xNGvFK3+wSzh5TPGRlTyQDPz1ALrbhYPHN3mCKBt74pDF7oxQVGF6gZ
         TLzSKYlbuU5qaZwM2yzrt+i97z2eXsUv+xw9DfaYukVljsVyUdM5rlCEqP9LuKxIcz8X
         1zzX7DuG1HZfDFycO4N9CbXq3nvStyvHAGU6l+Oi9PAt+wy4SPrLotkSv75sDGTUaZgO
         teGi6SfsIw115R974AkwgxXDOiBR8HSkJm4k47C5D4aOgC3GcQ6WqJwQLyxInhXKl8xJ
         qdLvjkXcDRK4MBzyZWZIeYeYhxCJ0jBmlRJkAkbvp+CiPm5m/OsKPrp0G4qOtKoaW4Ce
         ayCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HRgq7bWPbVQ6VGJrp0fBqbpNe57Tc4L7lPuzDuEESlg=;
        b=OQP93SHFyY4UZSguTFKsALk7NsKnMx8t6rpgqFKjs9t9/Apf9Y7qWLIu6PRCobyvLI
         m/8diV39Sz3Pw8GpSIDT75jSlcDemu6xWye/VXKYXO8penZ99i5Ff2lHxMJ3xjIaNhgQ
         UZfulxQW2bR0stUL38WoyTe5JokzJ5PC7xhwGakUX2H3dpzKXPofp+yDaoErofdnxRHV
         NxErDnVxATOD4GhY0nmsgM2Dbp4EABZAzKCgVdMUspWdno076kdK4ECeEGda7jJdH3v6
         oW9ZxxJj8FMn3S6FnhR+Uy6pKtazOhUnX601jh3lzcJn+Us98H3FkYi8PFkpndWHf/lF
         w8UQ==
X-Gm-Message-State: AOAM532dSfGEx6GzgwmK/KGeeZUShtPf63Je/YyjA4SR+eIv54b8bpgF
        ZOhsLqj9w/xdYocldJCw+5PlVevxTYhCeeeP/H4=
X-Google-Smtp-Source: ABdhPJw+ZEhrUFHQwLzvaDPoOl7NpS6cyRPzYipDAwFJdmB0gXgU7yXBzVHZbcd4OQZZLlzz0dvTQnUcs/SYsVro7lE=
X-Received: by 2002:a1c:4189:: with SMTP id o131mr1695442wma.110.1590645110880;
 Wed, 27 May 2020 22:51:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200527095640.270986-1-jonas.falkevik@gmail.com>
In-Reply-To: <20200527095640.270986-1-jonas.falkevik@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 28 May 2020 13:59:06 +0800
Message-ID: <CADvbK_duBhNhPMrR2ZGkhgAhR555MNHLQM9SS95KVZDnJ=WiQQ@mail.gmail.com>
Subject: Re: [PATCH v2] sctp: check assoc before SCTP_ADDR_{MADE_PRIM,ADDED} event
To:     Jonas Falkevik <jonas.falkevik@gmail.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 5:57 PM Jonas Falkevik <jonas.falkevik@gmail.com> wrote:
>
> Make sure SCTP_ADDR_{MADE_PRIM,ADDED} are sent only for associations
> that have been established.
>
> These events are described in rfc6458#section-6.1
> SCTP_PEER_ADDR_CHANGE:
> This tag indicates that an address that is
> part of an existing association has experienced a change of
> state (e.g., a failure or return to service of the reachability
> of an endpoint via a specific transport address).
>
> Signed-off-by: Jonas Falkevik <jonas.falkevik@gmail.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>

> ---
> Changes in v2:
>  - Check asoc state to be at least established.
>    Instead of associd being SCTP_FUTURE_ASSOC.
>  - Common check for all peer addr change event
>
>  net/sctp/ulpevent.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
> index c82dbdcf13f2..77d5c36a8991 100644
> --- a/net/sctp/ulpevent.c
> +++ b/net/sctp/ulpevent.c
> @@ -343,6 +343,9 @@ void sctp_ulpevent_nofity_peer_addr_change(struct sctp_transport *transport,
>         struct sockaddr_storage addr;
>         struct sctp_ulpevent *event;
>
> +       if (asoc->state < SCTP_STATE_ESTABLISHED)
> +               return;
> +
>         memset(&addr, 0, sizeof(struct sockaddr_storage));
>         memcpy(&addr, &transport->ipaddr, transport->af_specific->sockaddr_len);
>
> --
> 2.25.4
>
