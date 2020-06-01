Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E841EADDD
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730564AbgFAStH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729029AbgFAStG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 14:49:06 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1880DC061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 11:49:06 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id 18so10361744iln.9
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 11:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OI76dp9dLkRzFg4t5THLCvXOtHY/AMTjA4ai96znBdc=;
        b=rIjMEsGgH0EmNRHuP/OQdqWu0j2hX+ZMtPz5OMjJ9zyDlzH8oRqrlvw5Se0uUCHhFr
         uFjlwpVrwFJw02C3RWU2LRSJkqc0qcGU/9MoyQzzPAZ22VqCzhKoVNp1LO+M8FfA7oZ/
         oybjtYtpc6oJqxSCpx2FwpY1etu5cz/GZaxm+GuFBfTgF2EDryQf1xdLqFVRcTu2zudi
         wtcL71vF6q3c4Qtb7PN+kQlnwuiSoX5b23kewnrrJea9hebFRyvxUGVEUVuNplo4B0wr
         EETQ2TVjHIoBQn4Ra9efmgEXpfo3lfdHnUUr/0CWA6qVlohEIFwbHZuI/Ap/rxZRj7wL
         Tbqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OI76dp9dLkRzFg4t5THLCvXOtHY/AMTjA4ai96znBdc=;
        b=d6S+UwjzDZA5F5vQIwBxm/PACaCoIra5ZKIdxWtCcLfezJQdE46nmuKdtp1d4t+NX2
         zr8SSK7OZsIkyQi0DwyFrKSXBRWBsW6/aSnRTWaHCkQ/ueSOhEHmcto6jdTDAynpEQXh
         KIfXCYPF9auZ6SLtHkzYjjjyvj5jbHzdiB1+hSVyG+XrGasdF0WDum4ExZbZb5DrbvnF
         89ikkTie8EMl5v+1Z4UW8YtrsQ1j2IRT0XJG6lon4CS8HDSBTX+FtuelfJ6n5zG7VpDY
         d/3cBwQJGUktXN2wDitglvl7N3kVOA5Cr4Gx4+VQ+1jdvd/o2PQ1Yd2Kz18yuphU1U8T
         pa8Q==
X-Gm-Message-State: AOAM531IltYTqHqIc5vWWxHXJe8sJX/q8Pmvmc8AEzNPSdUpMuy7LcFP
        BQ++j7Cg7KCpMTVRGrKeLxDDlyXOByZkPc6XMayVig==
X-Google-Smtp-Source: ABdhPJxupIaHVC8a7GArmiFnjuLmQuWl/EiQZFenyEYlmUJ0pZjfvtuhigs0fQmrbo4W/a4yRi1kLxPaCY7L1BYIX/4=
X-Received: by 2002:a92:dc89:: with SMTP id c9mr7740309iln.238.1591037345395;
 Mon, 01 Jun 2020 11:49:05 -0700 (PDT)
MIME-Version: 1.0
References: <c0284a5f2d361658f90a9cada05426051e3c490d.1590703192.git.dcaratti@redhat.com>
 <20200601.113714.711382126517958012.davem@davemloft.net>
In-Reply-To: <20200601.113714.711382126517958012.davem@davemloft.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 1 Jun 2020 11:48:54 -0700
Message-ID: <CAM_iQpWJsbdkPbrD6kve4q9auNfMVmMKp+poduuGKQ15k5CCAw@mail.gmail.com>
Subject: Re: [PATCH net-next] net/sched: fix a couple of splats in the error
 path of tfc_gate_init()
To:     David Miller <davem@davemloft.net>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>, Po Liu <Po.Liu@nxp.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Ivan Vecera <ivecera@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 1, 2020 at 11:40 AM David Miller <davem@davemloft.net> wrote:
>
> From: Davide Caratti <dcaratti@redhat.com>
> Date: Fri, 29 May 2020 00:05:32 +0200
>
> > trying to configure TC 'act_gate' rules with invalid control actions, the
> > following splat can be observed:
> >
> >  general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] SMP KASAN NOPTI
> >  KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
> >  CPU: 1 PID: 2143 Comm: tc Not tainted 5.7.0-rc6+ #168
> >  Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
> >  RIP: 0010:hrtimer_active+0x56/0x290
> >  [...]
> >   Call Trace:
> >   hrtimer_try_to_cancel+0x6d/0x330
>  ...
> > this is caused by hrtimer_cancel(), running before hrtimer_init(). Fix it
> > ensuring to call hrtimer_cancel() only if clockid is valid, and the timer
> > has been initialized. After fixing this splat, the same error path causes
> > another problem:
> >
> >  general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> >  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> >  CPU: 1 PID: 980 Comm: tc Not tainted 5.7.0-rc6+ #168
> >  Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
> >  RIP: 0010:release_entry_list+0x4a/0x240 [act_gate]
> >  [...]
> >  Call Trace:
> >   tcf_action_cleanup+0x58/0x170
>   ...
> > the problem is similar: tcf_action_cleanup() was trying to release a list
> > without initializing it first. Ensure that INIT_LIST_HEAD() is called for
> > every newly created 'act_gate' action, same as what was done to 'act_ife'
> > with commit 44c23d71599f ("net/sched: act_ife: initalize ife->metalist
> > earlier").
> >
> > Fixes: a51c328df310 ("net: qos: introduce a gate control flow action")
> > CC: Ivan Vecera <ivecera@redhat.com>
> > Signed-off-by: Davide Caratti <dcaratti@redhat.com>
>
> Applied, thanks.

You applied a wrong version. There is a V2 of this patch, and I had some
review for it.

Thanks.
