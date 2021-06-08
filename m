Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2064B3A0545
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 22:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhFHUtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 16:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230344AbhFHUtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 16:49:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D574661108
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 20:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623185267;
        bh=mcI35kHV0JJco7NcBUiwhXPXtIYMiLQNLWTobPK/6dA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hMLP0TiTf/rlAItJY0yOu8+An288eItwYKCNeaUpr+fA/retrsXsKqkTraed1MTy5
         cis9rMf6zn3feLOqCI57P9YixzsB7x69dAYNzq2g1Gb8p4VoOv7Kpuj9IJFoMV4Q7v
         utviNGA/62QxgSWz2kuKLACzVBWQ/DS8StJNXJBg/jnmYjuV47+GChz+gV4FO7dgXl
         S+FA8dwXkFZK7hncPOP++PABXTHXhBAcC3Hp0YZY4p0do4W/U4PgsuR0B4pdu1SBQO
         Sgfn5xN90j5DGqtmGtl6VFioqTtZkIpTt3c9bp+hTOz5QdV1xgHyNg2HeMAFu/JGXg
         /NmaUTMdBgEWw==
Received: by mail-wm1-f51.google.com with SMTP id f16-20020a05600c1550b02901b00c1be4abso2876438wmg.2
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 13:47:47 -0700 (PDT)
X-Gm-Message-State: AOAM533ZwHE9NAYzqrEVNmcWyMMp05a/eYWI0+JfODp/KhC9jnV6+m4J
        kneCqnRLRuHMEVuNwt64sJqSLMG8oP8XAdGPd+M=
X-Google-Smtp-Source: ABdhPJz9WvKKOCykcHi6LIrB7XUT4cG5Dx5PgqmMFK8NNggb9Xk+jazbQlj6njatTnmFE09pYsr0W5JgO1ML9vRzVPc=
X-Received: by 2002:a1c:c90f:: with SMTP id f15mr6318798wmb.142.1623185266414;
 Tue, 08 Jun 2021 13:47:46 -0700 (PDT)
MIME-Version: 1.0
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com>
 <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com>
 <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com>
 <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
 <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
 <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
 <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
 <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
 <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com>
 <60B6C4B2.1080704@gmail.com> <CAK8P3a0iwVpU_inEVH9mwkMkBxrxbGsXAfeR9_bOYBaNP4Wx5g@mail.gmail.com>
 <60BEA6CF.9080500@gmail.com> <CAK8P3a12-c136eHmjiN+BJfZYfRjXz6hk25uo_DMf+tvbTDzGw@mail.gmail.com>
 <60BFD3D9.4000107@gmail.com>
In-Reply-To: <60BFD3D9.4000107@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 8 Jun 2021 22:45:55 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0Wry54wUGpdRnet3WAx1yfd-RiAgXvmTdPd1aCTTSsFw@mail.gmail.com>
Message-ID: <CAK8P3a0Wry54wUGpdRnet3WAx1yfd-RiAgXvmTdPd1aCTTSsFw@mail.gmail.com>
Subject: Re: Realtek 8139 problem on 486.
To:     Nikolai Zhubr <zhubr.2@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 8, 2021 at 10:32 PM Nikolai Zhubr <zhubr.2@gmail.com> wrote:
>
> 08.06.2021 10:44, Arnd Bergmann:
> [...]
> > However, it should not lead to any missed interrupts with my patch:
> > at any point in time, you have either all hardware interrupts enabled,
> > or you are in napi polling mode and are guaranteed to call the poll
>
> For this to work, napi_complete should likely be called with some
> different condition instead?
> E.g.:
>
> -        if (work_done < budget) {
> +        if ((work_done < budget) && !status) {
>
> Otherwise polling would possibly be shut down before all non-rx events
> are cleared?
> For some reason such 'corrected' version does not work here though
> (Communication fails completely). Probably I'm still missing something.

The idea was that all non-rx events that were pending at the start of the
function have been Acked at this point, by writing to the IntrMask
register before processing the particular event. If the same kind of event
arrives after the Ack, then opening in the mask should immediately trigger
the interrupt handler, which reactivates the poll function.

If you instead want to re-arm the poll function every time that 'status'
was non-zero, you would have to also return 'budget' to the caller, like

+      if (status)
+             work_done = budget; /* pretend RX is still busy */
        if (work_done < budget) {

I think that should also work, but it seems more expensive since it would
always go back into the poll function after a non-RX event, rather than
only going back into the irq handler if a new event has just arrived.

        Arnd
