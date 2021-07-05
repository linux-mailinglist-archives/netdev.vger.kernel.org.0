Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D853BC204
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 19:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhGERJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 13:09:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22096 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229753AbhGERJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 13:09:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625504790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KuRy89eXRByFxlnTN23uE6bhIohFVEQlDPFd8c6xtSg=;
        b=NIK/2adLFFIyPAa2rthe+Uhpc6pI1el/FZ3yV8vMNeChpzRiry0YFQdKxRFPV3z3WTc8eG
        FJtEJ/xlkV1giJ/U8blSzKMTc6JynV0IFZZVc8xhWHxcV9qR2Gf0z5Su/CfQbbfEleDJwT
        xD4EanjLb4FeB2qoEkq/8opkWNu1xIQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-s2cihlHANQOlfpQPp53EeA-1; Mon, 05 Jul 2021 13:06:29 -0400
X-MC-Unique: s2cihlHANQOlfpQPp53EeA-1
Received: by mail-ed1-f70.google.com with SMTP id d5-20020a0564020785b02903958939248aso9343161edy.15
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 10:06:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=KuRy89eXRByFxlnTN23uE6bhIohFVEQlDPFd8c6xtSg=;
        b=oVS+9LX8oRuY1XBlwfhpkZq0NDBF0rwwikUQ05ekT+RcZnzN4RvNxtlwusb/k/ERSV
         xxRBbY2XdrBfgGR0+lCg+xvcCal95ygrFQtAbtmVINbUZwF0EhCwJ10STP5pqBfcKAJq
         rBouwLxYjLf3plKLmgbiads45iEtQClIIq6FrunWPzg5h0jeNo/L5gQaJvtSDx3FZd/4
         pDSQDPEgsi7eEjGcoFQMu4JPoB53pvMmYUiFB3WasPpxF6wngp9XI1xP73lFySZFF7tY
         AYRCiQTSm/o6zJYFVfDtHCRnjxZ2FIfVuG2zsuqAYMGhmuCJRQb+/pqu3+K1hrGwBJDv
         iY3A==
X-Gm-Message-State: AOAM531xk+2x5T69ZKJekTtrXLCjKI8yZX2gYoZXEPPWja2++jNDQ5J7
        5X1pnlyA82b+iVmBvhhhmw8w+rqRlSE6IUVqIQwF94RQiw31kUbCZlTuYsLMCLJnwmtW05Pvx9t
        tMBlwkv4aHewO9d0K
X-Received: by 2002:aa7:c352:: with SMTP id j18mr17349728edr.67.1625504788079;
        Mon, 05 Jul 2021 10:06:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwneJgqJmKUm7lMhmUUKbEhjFjPR6z10Dv09ddqoEicPZlix5wWcSXu7hx55pTRnnUYqwL4+w==
X-Received: by 2002:aa7:c352:: with SMTP id j18mr17349702edr.67.1625504787894;
        Mon, 05 Jul 2021 10:06:27 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id e16sm5842643edr.86.2021.07.05.10.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 10:06:27 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BCFB9180639; Mon,  5 Jul 2021 19:06:26 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, joamaki@gmail.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCH v2 intel-next 0/4] XDP_TX improvements for ice
In-Reply-To: <20210705164338.58313-1-maciej.fijalkowski@intel.com>
References: <20210705164338.58313-1-maciej.fijalkowski@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 05 Jul 2021 19:06:26 +0200
Message-ID: <87sg0sy9kd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> Hi,
>
> this is a second revision of a series around XDP_TX improvements for ice
> driver. When compared to v1 (which can be found under [1]), two new
> patches are introduced that are focused on improving the performance for
> XDP_TX as Jussi reported that the numbers were pretty low on his side.
> Furthermore the fallback path is now based on static branch, as
> suggested by Toke on v1. This means that there's no further need for a
> standalone net_device_ops that were serving the locked version of
> ndo_xdp_xmit callback.
>
> Idea from 2nd patch is borrowed from a joint work that was done against
> OOT driver among with Sridhar Samudrala, Jesse Brandeburg and Piotr
> Raczynski, where we working on fixing the scaling issues for Tx AF_XDP
> ZC path.
>
> Last but not least, with this series I observe the improvement of
> performance by around 30%.

Wow, "but not least" indeed! :D
You can't just drop that at the end like that! I want details -
whaddyamean, "by around 30%"? In all cases? Only for TX? Gimme numbers! :)

-Toke

