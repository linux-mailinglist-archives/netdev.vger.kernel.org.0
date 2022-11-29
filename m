Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B57063C9E0
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 21:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbiK2Uv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 15:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236365AbiK2Uvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 15:51:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F4113D58
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 12:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669755020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e6YTHm9ddj51ycKVd3tWvOmE8DsgiVPRbFrXrJ2j+a4=;
        b=a8dHC5U84iZd8O1WgRxLp7UQ9dUoyx1pfsqg/HiKoU6kWoE4Fs8s8VttI8/lMKeK5w8vtV
        9MdDJH88fluxB8QRrjKi0DyVSTBkQlMSA/1Lbuj1AG9/YEaY7pJHQRsfB9os5xliBVDKSa
        ynJDHxJL4M5F6j+9Gi+Sqt6HMe6m/5Y=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-633-8uy2kiMqNg2RlCqVmLn6Vw-1; Tue, 29 Nov 2022 15:50:17 -0500
X-MC-Unique: 8uy2kiMqNg2RlCqVmLn6Vw-1
Received: by mail-ed1-f72.google.com with SMTP id m7-20020a056402430700b0045daff6ee5dso8896078edc.10
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 12:50:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e6YTHm9ddj51ycKVd3tWvOmE8DsgiVPRbFrXrJ2j+a4=;
        b=yy3hNZtPzHeiMvCeReq7SwCR4/7J7pH4/cLWvHjdsSJnG/LBM/iwQg/yF+1AlMQz57
         FtMkzDDzDb9aBKykA9682P2PKpmPiaR8KBgjgePdBs9mQBF74yrsFk/ghaH6nuClnrlh
         XmrKEdcPjhXY1xIiOVVQUztdnEcLi9qUAnZ5+79VIF0BU3LOXZWdS6h+DUQTKRy90y7a
         i63C1xez4pPIwBnavhT3Jh3q8ASDMlvo41SmFv04Il6JcgoSOhZpfHu8JRU+CFDIZBsD
         CBrPsVeweIBmp7ujY5tvZR17LlQp/9C10VlFv/KNy4KV10NES8oeVrk9oAtKf097ovaL
         4FWw==
X-Gm-Message-State: ANoB5pnRDbNQ+DSUGgCoY/DE0ROOMQtx8qKwwv9RMfOQ/ZKiz310Xbww
        z3ICUrFcXsK7eXuI8/uTJXipS5DJkG7RgEXh480mVp3MImhx0DfPSpwk121kDipfagy7XB/vjOL
        Wpm4ZQRVQp3fDv54o
X-Received: by 2002:aa7:d34b:0:b0:46a:914c:9bc9 with SMTP id m11-20020aa7d34b000000b0046a914c9bc9mr24782772edr.418.1669755016270;
        Tue, 29 Nov 2022 12:50:16 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4DSLtw0a3VL6pY53w8JHaW41rE+NRi4z6GaxNcoLERHT5Jw0Sx+mhZnhws5hbpWWpqEYQARQ==
X-Received: by 2002:aa7:d34b:0:b0:46a:914c:9bc9 with SMTP id m11-20020aa7d34b000000b0046a914c9bc9mr24782750edr.418.1669755015914;
        Tue, 29 Nov 2022 12:50:15 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id e1-20020a170906c00100b00787f91a6b16sm6560571ejz.26.2022.11.29.12.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 12:50:15 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0E92780AC52; Tue, 29 Nov 2022 21:50:14 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] [PATCH bpf-next v3 00/11] xdp: hints via kfuncs
In-Reply-To: <20221129193452.3448944-1-sdf@google.com>
References: <20221129193452.3448944-1-sdf@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 29 Nov 2022 21:50:14 +0100
Message-ID: <8735a1zdrt.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> writes:

> Please see the first patch in the series for the overall
> design and use-cases.
>
> Changes since v2:
>
> - Rework bpf_prog_aux->xdp_netdev refcnt (Martin)
>
>   Switched to dropping the count early, after loading / verification is
>   done. At attach time, the pointer value is used only for comparing
>   the actual netdev at attach vs netdev at load.

So if we're not holding the netdev reference, we'll end up with a BPF
program with hard-coded CALL instructions calling into a module that
could potentially be unloaded while that BPF program is still alive,
right?

I suppose that since we're checking that the attach iface is the same
that the program should not be able to run after the module is unloaded,
but it still seems a bit iffy. And we should definitely block
BPF_PROG_RUN invocations of programs with a netdev set (but we should do
that anyway).

>   (potentially can be a problem if the same slub slot is reused
>   for another netdev later on?)

Yeah, this would be bad as well, obviously. I guess this could happen?

-Toke

