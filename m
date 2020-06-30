Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E1820F900
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 18:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389572AbgF3QCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 12:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbgF3QCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 12:02:40 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B89C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 09:02:40 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id j202so10336722ybg.6
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 09:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ElgPBnfD3o6+hgmKBDLNbmYkxozn/mDE03dS8QWO8aA=;
        b=HRyS04FTtucaxJjHGmGeom3Llq5J8PSfo2KMYl+wLA1KoRtlW97eA1wg0U4JHnRQvY
         86gSF4sNLOEHk8gu6GuMR2IyNGcKa6OUphGW17CRXi9L4aNLTQVZXkmSR9lBmRgepN66
         1Ae3vvN/96CSVG8QJ+4w5kc7YfugPvD4bGSWakCk6g7HTWHalwgozfe0HZDFPtgx4OKv
         Ofngl0IXVGRZWtasO84FIzFPuAc5HKRj9SjT3wI0i9t99FLJK9FRAAPODDd7zPPlgMgX
         uZpdDDQJb2tGRmtupnS9xrs9iA5SAeKrkuFurptLTWAcBomR3xldtK4GU00CQ8VcQqkQ
         mqMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ElgPBnfD3o6+hgmKBDLNbmYkxozn/mDE03dS8QWO8aA=;
        b=EUoA6KC416Q7cL05c60tcOjh86IlygLiRuqAtgmTxWm9qUf/EIXzSdvcDJbuW0bRmI
         Cbftk+dfag7njN8beQTgRHoOPQ94YOTV3sH7IBW9nLGzWIG26hbkTe9FhVr67qChsMdg
         L1hpFh1DlvMWiW66oU/PIJLrgT3a5iTi/5cgVliHCH6+bLkwD095UmVCQoD3Mp0JzVY1
         9G0LMb6LtYnZPLP7f7aNxfTR0teeQ/1cyGIYZp+MhPBeIVPTWn4tduMXRgqv1OSOQjgI
         KxESFbOxIVSWCIIOYZbC0OboScZvW9JOqJ7Snu0D3+YuSDxcSaFeNO34rK1rQS9WAm2h
         chwA==
X-Gm-Message-State: AOAM533GwrYaNoH/R0fjBtl5Gaj0dE1VZRXnkBUZNCMonOYHGaWtdoqX
        MDm1gIslUXzQTda5FSMbByF//CMTKNV+KtLPTz2msw==
X-Google-Smtp-Source: ABdhPJzlDMtFTzc/t7BBb8SrA/XcwkcwsEcA23ytHiWZ41boCK7vcEkDKVj+0QPf4Bgs1VBKJHA+aquJoRWuteDGp0U=
X-Received: by 2002:a25:aa70:: with SMTP id s103mr35863574ybi.492.1593532958731;
 Tue, 30 Jun 2020 09:02:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200630010625.469202-1-Jason@zx2c4.com> <20200630010625.469202-3-Jason@zx2c4.com>
In-Reply-To: <20200630010625.469202-3-Jason@zx2c4.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Tue, 30 Jun 2020 12:02:01 -0400
Message-ID: <CA+FuTScmNarsVr7htyyJPoyn1pn-Bjn=oX89domPDro5sT2qqA@mail.gmail.com>
Subject: Re: [PATCH net v2 2/8] net: ipip: implement header_ops->parse_protocol
 for AF_PACKET
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Hans Wippel <ndev@hwipl.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 9:06 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Ipip uses skb->protocol to determine packet type, and bails out if it's
> not set. For AF_PACKET injection, we need to support its call chain of:
>
>     packet_sendmsg -> packet_snd -> packet_parse_headers ->
>       dev_parse_header_protocol -> parse_protocol
>
> Without a valid parse_protocol, this returns zero, and ipip rejects the
> skb. So, this wires up the ip_tunnel handler for layer 3 packets for
> that case.
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Acked-by: Willem de Bruijn <willemb@google.com>

For all protocols, really. But it probably doesn't add much to repeat
this in each patch.
