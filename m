Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F457536AB4
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 06:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345546AbiE1E1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 00:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349774AbiE1E1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 00:27:05 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CA05BE7B;
        Fri, 27 May 2022 21:26:55 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id jx22so11876239ejb.12;
        Fri, 27 May 2022 21:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AH8OnCXRC51Mg4MBO4ivuHAwds1YuEo+ZbFbIglk25k=;
        b=c0VKYFgSHpb0/8AKdLqgatVQSCC+/mDi9S4RMNPyPuqG7IF0j0cFnom/jsmvY2lpWg
         T2DucG2NXVXOD2Klh8NHl7onmOERFTK3TtK9sL5Us+4Ug54ojF1gyhh130c6DHjstucT
         NLUT3P8zzdXMrVTg07MSxJGQ5Z0SNtwk+R7RJUDdhM9iaR27ySkGT54Q7Bw6lwEMr9me
         SoWUnGE7hA0LTMx8owdpPAO7r/5hUbGOqb9qo7D4enZezrKO97kuWutagxdlyr7bHVC6
         jcbwE6d4ffpAoa3BA03Ld5Wvii1ver+hDfGhxZhwyT/xmDg019/TGHWP/NoaFbSmj3Ln
         +oiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AH8OnCXRC51Mg4MBO4ivuHAwds1YuEo+ZbFbIglk25k=;
        b=Coe1xVj7wTZEYC2WfMTuRFyj4MAdmwyrbLjn8gkzPVOytdWUDKn8y28+Rn0eGWnwrX
         y4dZBrGhMJmMCPnlpLCvF/Bd9tN+3/Ycgqq8YWCoUCetoJk27Y1be09uUGR+mYCJsO1O
         dfcayziVqmMK+QcBCsKwe7mUWZ6+HDuAojlGFZbE2oh/SJtR4GzznRg2sMI+8DOCh8PG
         UT3V8rfIvgClXjNJ4Ln7XcYyPdmOB8+/ILXCb18F06Lnj8qlE/nafAezpzQp1fXV7Q9i
         mrkpTpX/IpyX3uutRLNZUJV+fOK6BQypSS2lDVgkdm/4atMK0KnuD4Cmhj+/iITQS9L3
         3zBA==
X-Gm-Message-State: AOAM531mdDdnMcI2Bg3jrx9Fo02QbLNBOksBW/tuFOZQ6fDHqmovHzS9
        KcbNZyotvVTkd4tcGR1Di07f0AQOv2sb3SmUL0Y=
X-Google-Smtp-Source: ABdhPJx+Bye2Fi8Q2Yp/a2pdYrI2N1T2SeWCiZr66i3gzr7t/ESq3IlDhQNK/eh3WnVIs1U2wmBM8BN1dVFByGtHOk0=
X-Received: by 2002:a17:907:3f17:b0:6fe:bc5d:8d8e with SMTP id
 hq23-20020a1709073f1700b006febc5d8d8emr30880227ejc.439.1653712014572; Fri, 27
 May 2022 21:26:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220527071522.116422-1-imagedong@tencent.com>
 <20220527071522.116422-3-imagedong@tencent.com> <20220527181426.126367e5@kernel.org>
In-Reply-To: <20220527181426.126367e5@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Sat, 28 May 2022 12:26:43 +0800
Message-ID: <CADxym3YJKOmxmZPvqAJGS_WHUv5i+Cb0MSwu583wK+G6BO0MOw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: skb: use auto-generation to convert skb
 drop reason to string
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Sat, May 28, 2022 at 9:14 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 27 May 2022 15:15:21 +0800 menglong8.dong@gmail.com wrote:
> > +clean-files := dropreason_str.h
> > +
> > +quiet_cmd_dropreason_str = GEN     $@
> > +cmd_dropreason_str = echo '\n\#define __DEFINE_SKB_DROP_REASON(FN) \' > $@;\
>
> echo -n
>
> > +     sed -e '/enum skb_drop_reason {/,/}/!d' $< | \
> > +     awk -F ',' '/SKB_DROP_REASON_/{printf " FN(%s) \\\n", substr($$1, 18)}' >> $@;\
> > +     echo '' >> $@
>
> Trying to figure out when we're in the enum could be more robust
> in case more stuff gets added to the header:
>
>  | awk -F ',' '/^enum skb_drop/ { dr=1; }
>                /\}\;/           { dr=0; }
>                /^\tSKB_DROP/    { if (dr) {print $1;}}'
>
> > +$(obj)/dropreason_str.h: $(srctree)/include/linux/dropreason.h
> > +     $(call cmd,dropreason_str)
> > +
> > +$(obj)/skbuff.o: $(obj)/dropreason_str.h
>
> Since we just generate the array directly now should we generate
> a source file with it directly instead of generating a header with
> the huge define?

This seems to be a good idea, which is able to decouple the
definition of the array with skbuff.c. I'll try this.

Thanks!
Menglong Dong
