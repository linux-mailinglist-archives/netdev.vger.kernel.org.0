Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A66653451
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 17:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiLUQsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 11:48:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiLUQsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 11:48:31 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BC42496C
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 08:48:29 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id d14so22750246edj.11
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 08:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7JYErs6CEFZrMcJJO9HO5MhR2qwZbQM44JGOgPHgmJc=;
        b=KuDpndTKTPVCurP5UelV7ySsZ6TX3hwWVdvFj26bSA6hA/j4lNaa2m+1tmyflIJxR2
         Q4RJ2ARVDjZz5FJ064e8NGeHTWsT/l/OqhZzqTKQP/8/OzpBc5hHdUhr6fc/PZlzC/BA
         7SR9zDGid5QhBHZn/PyqnPgQCh+5wTg+ymhjd3pWVHb39T2vA9CGGEDv/oqDW1Omp+cQ
         SyFgb8HDrPMdaXshcSSV7aOp50y/If7XkkDtkZ+WTE7ngfxOc6ZbhICnrMK8skeHDMhA
         vZCeYbBdEbutPZSxncmnbAPPIRRTSoravjXw4ocWsOGvzXdAzwuPVtGRlBV94JjEXbB7
         Zf0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7JYErs6CEFZrMcJJO9HO5MhR2qwZbQM44JGOgPHgmJc=;
        b=f5YsQDWO3KHU86RuCYA9N/CA23F7qhF269+qP3jopfJlcIT3T6IJ5ELhHvUwH51QmB
         QojEB5vRinyn0749TR1O6fTKxjcH3rr23SasdU8d6N6jI8ogPjFOHo4o1aOigBsRp7Sr
         XCt/XtydUOs2I3frGRrNY9hbdSg3FrvDhEJMePjxKNzGT6QtYvexy+PpAL52nY2Q3app
         d3PPsaHF2TMw3wnYVj+D/patyW5ekAZgwAhPJSZTjddfDzHjTqjayR2JYB36Mo8wBx2k
         ZPVftLTigG58/quhNd/k+WVT3O281z85OGfGmA6sWLxH5usIMav6zesjXy3TBwlFxI3K
         LZ1g==
X-Gm-Message-State: AFqh2kqFL48FPSnAjHbHY2uWmK7kSxlZeU9/34ZzknQzyYrdCVo1LRb2
        ttBu1wF70nVwPjqc2Kqc1W2i/96A2NhmLTSMlrLBiw==
X-Google-Smtp-Source: AMrXdXs1/F7Th/9cK5UIIFnQcbxJMutY2Mq+LYSWn33R5nzzANPOu/6/6a0wOLEN35v+ZDA4UPHMdr99CuRUfGtXrKI=
X-Received: by 2002:a50:c90b:0:b0:464:1297:8412 with SMTP id
 o11-20020a50c90b000000b0046412978412mr238276edh.50.1671641308032; Wed, 21 Dec
 2022 08:48:28 -0800 (PST)
MIME-Version: 1.0
References: <20221217175612.1515174-1-csander@purestorage.com> <71c526c6bf99171fef334ab9d51f78777e7b9df5.camel@redhat.com>
In-Reply-To: <71c526c6bf99171fef334ab9d51f78777e7b9df5.camel@redhat.com>
From:   Caleb Sander <csander@purestorage.com>
Date:   Wed, 21 Dec 2022 08:48:17 -0800
Message-ID: <CADUfDZr_ecu-Vap_oPLPUJTiCaeUftErazDj702Ld2KDwvGUbQ@mail.gmail.com>
Subject: Re: [PATCH] qed: allow sleep in qed_mcp_trace_dump()
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>, netdev@vger.kernel.org,
        Joern Engel <joern@purestorage.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 1:55 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Sat, 2022-12-17 at 10:56 -0700, Caleb Sander wrote:
> > By default, qed_mcp_cmd_and_union() waits for 10us at a time
> > in a loop that can run 500K times, so calls to qed_mcp_nvm_rd_cmd()
> > may block the current thread for over 5s.
> > We observed thread scheduling delays of over 700ms in production,
> > with stacktraces pointing to this code as the culprit.
>
> IMHO this is material eligible for the net tree...
>
> >
> > qed_mcp_trace_dump() is called from ethtool, so sleeping is permitted.
> > It already can sleep in qed_mcp_halt(), which calls qed_mcp_cmd().
> > Add a "can sleep" parameter to qed_find_nvram_image() and
> > qed_nvram_read() so they can sleep during qed_mcp_trace_dump().
> > qed_mcp_trace_get_meta_info() and qed_mcp_trace_read_meta(),
> > called only by qed_mcp_trace_dump(), allow these functions to sleep.
> > It's not clear to me that the other caller (qed_grc_dump_mcp_hw_dump())
> > can sleep, so it keeps b_can_sleep set to false.
>
> ...but we need a suitable Fixes tag here. Please repost specifying the
> target tree into the subject and adding the relevant tag, thanks!

Sure, I can do that, but I would like to get some sign-off from the
driver authors.
The last time we attempted to fix this bug, we were told our change
could cause the driver to sleep in atomic contexts. So it would be great to hear
from QLogic (now Marvell) whether this fix is acceptable.

Thanks,
Caleb
