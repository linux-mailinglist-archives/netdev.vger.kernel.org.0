Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB863539BA5
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 05:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349397AbiFAD17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 23:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349395AbiFAD1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 23:27:55 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FFB18357;
        Tue, 31 May 2022 20:27:54 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id wh22so1075695ejb.7;
        Tue, 31 May 2022 20:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J39UhBjjnDpafrDsNPr2Gdl9TPpMr8y2boRWlbNP7J4=;
        b=HJ1kaTxNNmYmYaYi+ZJWG33nXpwFP5DUcIqg+jC0xV3pkvYqP/r8MVamEw1YpWs9Jb
         F7h5siPPkaYa1wtcv/Eb9zC7BYHdBdAZOChohtSQuhxUK0N+rXbQXMpDnlQVka+BESjW
         EUXYU6Bfayl1NaS/yruKG0yM/7+DESUnUCqvCQkCas7bh/ax6IwJlgur97RM+0PO0eAM
         QCxGjFJEgUfwAOzKJP0y0swqYikofGaAksGzHz8Cd35fUbxNuLdxYRZYkbodD5oIz6+r
         FAHoF46m6po0pJZSrjk7B7309j/3JEgBfCxVxUCH6aotKLOu8/zMI9/2HvE2//HW5o73
         tuKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J39UhBjjnDpafrDsNPr2Gdl9TPpMr8y2boRWlbNP7J4=;
        b=o/e29fquv2gfh6pufNQeXTFBCdtD1n8bchuyhYOQacoq174VemTrc22eExlGEmoDtw
         ukPB9MxtEzCA9pyxgyDfh3dyuS8HgnIZPiX/JE02uo5VjZSUdd992RRIOhDviZM27Ug5
         9dL2q2Gj3Y++9NiPTxYkVrJlY4xmNF28qafBLtLlSPi2L3ifYpxw/HmRD8/4iIMDw4rp
         IHSVSEHtbomrsY7wqAgKMDhMy/G0m8p/Ov1i8UXjedtnblWPCOKlujJnJ03yvDOJzkhu
         i70ehn3r+oV67j85jbwPSqq6AZmy0+X9TZN+p/nGlImn9iBvJaoeYdDu315IAEGOTEgs
         6uEw==
X-Gm-Message-State: AOAM530Aju7aFv5FeVYzUtYHiyINBpSZafJmdIIalALDX/U9n56GU62z
        CfyQaWjyYjhIAACDKfaS38/cooN5JXB4+aU640zcQ4Eq/K0=
X-Google-Smtp-Source: ABdhPJyvjLlC0cqVGNnYIrYT6Axv68/EpnywaEDHhFh4he2UDC971HcFeVOMaMAJtfVXDWAon1DvmtrA7uWTkry5mu8=
X-Received: by 2002:a17:907:9494:b0:6fa:78f3:eb9b with SMTP id
 dm20-20020a170907949400b006fa78f3eb9bmr55017894ejc.704.1654054072559; Tue, 31
 May 2022 20:27:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220530081201.10151-1-imagedong@tencent.com> <20220530081201.10151-3-imagedong@tencent.com>
 <20220530131311.40914ab7@kernel.org>
In-Reply-To: <20220530131311.40914ab7@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 1 Jun 2022 11:27:41 +0800
Message-ID: <CADxym3bQ96s_tsQeE_1_TFNafTvzQfRr9WLB40urZCgn4a2C0A@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] net: skb: use auto-generation to convert
 skb drop reason to string
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Menglong Dong <imagedong@tencent.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 4:13 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 30 May 2022 16:12:00 +0800 menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > It is annoying to add new skb drop reasons to 'enum skb_drop_reason'
> > and TRACE_SKB_DROP_REASON in trace/event/skb.h, and it's easy to forget
> > to add the new reasons we added to TRACE_SKB_DROP_REASON.
> >
> > TRACE_SKB_DROP_REASON is used to convert drop reason of type number
> > to string. For now, the string we passed to user space is exactly the
> > same as the name in 'enum skb_drop_reason' with a 'SKB_DROP_REASON_'
> > prefix. Therefore, we can use 'auto-generation' to generate these
> > drop reasons to string at build time.
> >
> > The new header 'dropreason_str.h'
>
> Not any more.
>
> > will be generated, and the
> > __DEFINE_SKB_DROP_REASON() in it can do the converting job. Meanwhile,
> > we use a global array to store these string, which can be used both
> > in drop_monitor and 'kfree_skb' tracepoint.
>
> > diff --git a/include/net/dropreason.h b/include/net/dropreason.h
> > index ecd18b7b1364..460de425297c 100644
> > --- a/include/net/dropreason.h
> > +++ b/include/net/dropreason.h
> > @@ -3,6 +3,8 @@
> >  #ifndef _LINUX_DROPREASON_H
> >  #define _LINUX_DROPREASON_H
> >
> > +#include <linux/kernel.h>
>
> Why?

Oh, you noticed it. To simplify the code in dropreason_str.c, as
EXPORT_SYMBOL() is used. Okay, I'll move it to the generation
part.

>
> > +dropreason_str.c
> > \ No newline at end of file
>
> Heed the warning.
>
> > diff --git a/net/core/Makefile b/net/core/Makefile
> > index a8e4f737692b..3c7f99ff6d89 100644
> > --- a/net/core/Makefile
> > +++ b/net/core/Makefile
> > @@ -4,7 +4,8 @@
> >  #
> >
> >  obj-y := sock.o request_sock.o skbuff.o datagram.o stream.o scm.o \
> > -      gen_stats.o gen_estimator.o net_namespace.o secure_seq.o flow_dissector.o
> > +      gen_stats.o gen_estimator.o net_namespace.o secure_seq.o \
> > +      flow_dissector.o dropreason_str.o
> >
> >  obj-$(CONFIG_SYSCTL) += sysctl_net_core.o
> >
> > @@ -39,3 +40,23 @@ obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
> >  obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
> >  obj-$(CONFIG_BPF_SYSCALL) += bpf_sk_storage.o
> >  obj-$(CONFIG_OF)     += of_net.o
> > +
> > +clean-files := dropreason_str.c
> > +
> > +quiet_cmd_dropreason_str = GEN     $@
> > +cmd_dropreason_str = awk -F ',' 'BEGIN{ print "\#include <net/dropreason.h>\n"; \
> > +     print "const char * const drop_reasons[] = {" }\
> > +     /^enum skb_drop/ { dr=1; }\
> > +     /\}\;/ { dr=0; }\
> > +     /^\tSKB_DROP_REASON_/ {\
> > +             if (dr) {\
> > +                     sub(/\tSKB_DROP_REASON_/, "", $$1);\
> > +                     printf "\t[SKB_DROP_REASON_%s] = \"%s\",\n", $$1, $$1;\
> > +             }\
> > +     } \
> > +     END{ print "};\nEXPORT_SYMBOL(drop_reasons);" }' $< > $@
> > +
> > +$(obj)/dropreason_str.c: $(srctree)/include/net/dropreason.h
> > +     $(call cmd,dropreason_str)
>
> I'm getting this:
>
>   awk: cmd. line:1: warning: regexp escape sequence `\;' is not a known regexp operator
>

Enn...I think this warning comes from the "/\}\;/ { dr=0; }\" part.
Let me do more investigation.

Thanks!
Menglong Dong
