Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCA74EDBE0
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 16:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237709AbiCaOoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 10:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbiCaOoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 10:44:22 -0400
X-Greylist: delayed 25921 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 31 Mar 2022 07:42:35 PDT
Received: from conssluserg-02.nifty.com (conssluserg-02.nifty.com [210.131.2.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F049A215928;
        Thu, 31 Mar 2022 07:42:34 -0700 (PDT)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id 22VEgKPq012732;
        Thu, 31 Mar 2022 23:42:21 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com 22VEgKPq012732
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1648737741;
        bh=Xj3diVC51HHwyTudn/M0r5QOTayxxsIWMzaIO802Bg8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NyzpaqttJpO4J1ZzydrjZpqd7D6RtCp9gc5ZaryOukEkB2uEhrhOZEzPKBiiH2Pvm
         ZAwp5rRZQ0v65p+oEbs8aetqGWncchcIk52/GtRWJNVLw1w2Do4znproVBs1S63MqO
         yPsX+oBzeMWa9c16wyGQ2FV5tMZivMUpr1Xj20sy/ShX/mC0hNPApxe1k10qh9PiJc
         erfRD+SlxyM3c1E5rxBvQ4iTP8pMDqn2rOskJbLjRRzAOoXwcXi9n7aVCIj+7z95l3
         D4rLCYt3eKmlsDUIrYNGo2Pk6kZkFlHsuT5YPi2YPvduwmEaPpnxAzZoyNFguNhp35
         XfOFKgOjyZrtw==
X-Nifty-SrcIP: [209.85.216.47]
Received: by mail-pj1-f47.google.com with SMTP id cm17so4232941pjb.2;
        Thu, 31 Mar 2022 07:42:21 -0700 (PDT)
X-Gm-Message-State: AOAM533trCg/nd7R+M3YlhFoafo/RiL3iywrKLFI7hIQAGqinfZ4h4k+
        f4zbs/+Rn9Bl7g1Lms5L9OFthAxwkuyp17udE7g=
X-Google-Smtp-Source: ABdhPJw3WCo3kJvlA+76iJNgjzue4kyy/jp0r5U7gt1FnPdlPSe1ov+p7LZDiUmtV9rQyHMr9Pj2WbAZ4WWKFJRTA3o=
X-Received: by 2002:a17:90a:8405:b0:1bc:d521:b2c9 with SMTP id
 j5-20020a17090a840500b001bcd521b2c9mr6488510pjn.119.1648737740242; Thu, 31
 Mar 2022 07:42:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220330201755.29319-1-mathieu.desnoyers@efficios.com>
 <20220330162152.17b1b660@gandalf.local.home> <CAK7LNATm5FjZsXL6aKUMhXwQAqTuO9+LmAk3LGjpAib7NZBDmg@mail.gmail.com>
 <20220331081337.07ddf251@gandalf.local.home>
In-Reply-To: <20220331081337.07ddf251@gandalf.local.home>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 31 Mar 2022 23:41:34 +0900
X-Gmail-Original-Message-ID: <CAK7LNAR_2jJWJbaUfLDaDJOuJTx_RHj_Ow5coK1k4Y5HGLRQrA@mail.gmail.com>
Message-ID: <CAK7LNAR_2jJWJbaUfLDaDJOuJTx_RHj_Ow5coK1k4Y5HGLRQrA@mail.gmail.com>
Subject: Re: [PATCH] tracing: do not export user_events uapi
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 31, 2022 at 9:13 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 31 Mar 2022 16:29:30 +0900
> Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> > Well, the intended usage of no-export-headers is to
> > cater to the UAPI supported by only some architectures.
> > We have kvm(_para).h here because not all architectures
> > support kvm.
> >
> > If you do not want to export the UAPI,
> > you should not put it in include/uapi/.
> >
> > After the API is finalized, you can move it to
> > include/uapi.
>
> So a little bit of background. I and a few others thought it was done, and
> pushed it to Linus. Then when it made it into his tree (and mentioned on
> LWN) it got a wider audience that had concerns. After they brought up those
> concerns, we agreed that this needs a bit more work. I was hoping not to do
> a full revert and simply marked the change for broken so that it can be
> worked on upstream with the wider audience. Linus appears to be fine with
> this approach, as he helped me with my "mark for BROKEN" patch.
>
> Mathieu's concern is that this header file could be used in older distros
> with newer kernels that have it implemented and added this to keep out of
> those older distros.
>
> The options to make Mathieu sleep better at night are:
>
> 1) this patch
>
> 2) move this file out of uapi.
>
> 3) revert the entire thing.
>
> I really do not want to do #3 but I am willing to do 1 or 2.

I see.

Either 1 or 2 is OK
if  you are sure this will be fixed sooner or later.


-- 
Best Regards
Masahiro Yamada
