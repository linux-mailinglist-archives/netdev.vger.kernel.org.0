Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55076482F4
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 14:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiLINvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 08:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiLINvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 08:51:01 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9485A6ACD6;
        Fri,  9 Dec 2022 05:51:00 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id n20so11727493ejh.0;
        Fri, 09 Dec 2022 05:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MayxEdP8sGeFElsJFgC+MBaPXZ8b65rXJQ4R4+c3n94=;
        b=BHzo/UAM/xPaoyrSdelfF9IeGCylMna9VH0X9Nb2DNA12VPORtYZEOPLiVFkrApY6X
         SQ6bGl0FRKonaWucUZBOp6QFmoduHGYFEq8cMoa3PijlQK+LJ37SNEFQcXAGbPowrrzt
         ube8tJ6T77ibEmMkBy62FAHDjnauLoEA5UaTULjp/ic3Gbr+xtTe2laJ19wwLj/zs24M
         nFnd4BiGA1EZy2NmzZ7RcdyG6l3y63IQ/ofPaSZ/ADm9pYrNaZ42g8v9L6piMnFcRtFp
         maYA1yTifjN1NYlnF0jVjffkTzRu9/RgQsheT26CAM03G92qHP2TL9E794vK1yjCLYkq
         u1Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MayxEdP8sGeFElsJFgC+MBaPXZ8b65rXJQ4R4+c3n94=;
        b=f9IyrU7VSfoQA1KzHkXYa7d25BOLEIR4HN3H31TmHxeCBxA4BCOQii4LtBKUhfD4XA
         rqieiGFxl3x8CpIS/7JUYeOSbAPn8UHlXxgWBmJVxZvgD+ItZve5mRt4KHkc23yw3UJI
         OyNAejxdTjvDYfoJ3TaAbCk1NQQEafdk3moEg30oA02dyDq4A+2Oty35h07AYFdSCjI6
         NALbzgH+WNTuY+naC5pa40cwQPlzPS6mke/LDdYhRl60meV9kBdumSSIjXgTVbNfA+/a
         ZwBEUIY3IJYFmNO61vERWFlPEQA19AbJ6X+qLEKZlqR7rujXruryxkJ6nhgmAjfkY9PB
         cgag==
X-Gm-Message-State: ANoB5plG0+IBqiXPyMPlVwowEm/D+PCsEdgWGs3Vl6QYUIldqrjZiTKM
        U0nc9MgZJAcoREUAMLE4hKg=
X-Google-Smtp-Source: AA0mqf4ownPWdu+gIVnMpkqZNcezxOQgc87din9xNy9rmaIl/nBQ46g4Vb42pH3kGhMkC3RhJEPRLA==
X-Received: by 2002:a17:906:2a10:b0:7c0:cc6d:5df7 with SMTP id j16-20020a1709062a1000b007c0cc6d5df7mr5267934eje.68.1670593859029;
        Fri, 09 Dec 2022 05:50:59 -0800 (PST)
Received: from krava (2001-1ae9-1c2-4c00-726e-c10f-8833-ff22.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:726e:c10f:8833:ff22])
        by smtp.gmail.com with ESMTPSA id c10-20020a17090618aa00b007c07dfb0816sm561499ejf.215.2022.12.09.05.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 05:50:58 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 9 Dec 2022 14:50:55 +0100
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <song@kernel.org>
Cc:     Hao Sun <sunhao.th@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: BUG: unable to handle kernel paging request in bpf_dispatcher_xdp
Message-ID: <Y5M9P95l85oMHki9@krava>
References: <CACkBjsYioeJLhJAZ=Sq4CAL2O_W+5uqcJynFgLSizWLqEjNrjw@mail.gmail.com>
 <CACkBjsbD4SWoAmhYFR2qkP1b6JHO3Og0Vyve0=FO-Jb2JGGRfw@mail.gmail.com>
 <Y49dMUsX2YgHK0J+@krava>
 <CAADnVQ+w-xtH=oWPYszG-TqxcHmbrKJK10C=P-o2Ouicx-9OUA@mail.gmail.com>
 <CAADnVQJ+9oiPEJaSgoXOmZwUEq9FnyLR3Kp38E_vuQo2PmDsbg@mail.gmail.com>
 <Y5Inw4HtkA2ql8GF@krava>
 <Y5JkomOZaCETLDaZ@krava>
 <Y5JtACA8ay5QNEi7@krava>
 <Y5LfMGbOHpaBfuw4@krava>
 <Y5MaffJOe1QtumSN@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5MaffJOe1QtumSN@krava>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 12:22:37PM +0100, Jiri Olsa wrote:

SBIP

> > > > > > >
> > > > > > > I'm trying to understand the severity of the issues and
> > > > > > > whether we need to revert that commit asap since the merge window
> > > > > > > is about to start.
> > > > > > 
> > > > > > Jiri, Peter,
> > > > > > 
> > > > > > ping.
> > > > > > 
> > > > > > cc-ing Thorsten, since he's tracking it now.
> > > > > > 
> > > > > > The config has CONFIG_X86_KERNEL_IBT=y.
> > > > > > Is it related?
> > > > > 
> > > > > sorry for late reply.. I still did not find the reason,
> > > > > but I did not try with IBT yet, will test now
> > > > 
> > > > no difference with IBT enabled, can't reproduce the issue
> > > > 
> > > 
> > > ok, scratch that.. the reproducer got stuck on wifi init :-\
> > > 
> > > after I fix that I can now reproduce on my local config with
> > > IBT enabled or disabled.. it's something else
> > 
> > I'm getting the error also when reverting the static call change,
> > looking for good commit, bisecting
> > 
> > I'm getting fail with:
> >    f0c4d9fc9cc9 (tag: v6.1-rc4) Linux 6.1-rc4
> > 
> > v6.1-rc1 is ok
> 
> so far I narrowed it down between rc1 and rc3.. bisect got me nowhere so far
> 
> attaching some more logs

looking at the code.. how do we ensure that code running through
bpf_prog_run_xdp will not get dispatcher image changed while
it's being exetuted

we use 'the other half' of the image when we add/remove programs,
but could bpf_dispatcher_update race with bpf_prog_run_xdp like:


cpu 0:                                  cpu 1:

bpf_prog_run_xdp
   ...
   bpf_dispatcher_xdp_func
      start exec image at offset 0x0

                                        bpf_dispatcher_update
                                                update image at offset 0x800
                                        bpf_dispatcher_update
                                                update image at offset 0x0

      still in image at offset 0x0


that might explain why I wasn't able to trigger that on
bare metal just in qemu

jirka
