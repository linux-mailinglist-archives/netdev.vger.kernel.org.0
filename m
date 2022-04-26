Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 898AF5102FD
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 18:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352868AbiDZQRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 12:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232878AbiDZQRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 12:17:52 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9CC9E9CA;
        Tue, 26 Apr 2022 09:14:44 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id r28so1917446iot.1;
        Tue, 26 Apr 2022 09:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xQ7JAlrZNbN+4UBwUPLrm9e0Bc1f0Mue3TCyhSjw9fg=;
        b=PsVMgd1FSGWf0143r+osiQHexPkmN4qYX84UIUdvP77H+bOL/n1Csk4f3feLmicwvY
         ynYfrVCub9IAoFSxVMC+DO1k+lPMppP8KZtxdIr5Y9Tc87kzwFNf5LufTAwSTY0DFhZq
         Ol8Snp6N4dxtAMQziNX0KTnJclrJMka5G3OZT2fo60XcWvgwcm5QzncrNDFqCK6QtQdZ
         4aNcc1xMZR9vze55pliLo2gv7zkfKLiy3JOdRF5Q476eP4j42Ktl6CyMCvghV0NIz1PH
         f6BTrZTabsYCDoZZIc+6wI3hSd4fOTelba3xSV+FRJL/SCVxfbPVHaoXQnut4bGXF+Em
         3/RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xQ7JAlrZNbN+4UBwUPLrm9e0Bc1f0Mue3TCyhSjw9fg=;
        b=xzSdyuTpa1gAJLdX6iroPhOEtYNM4622V/yiTkaSG0sjFVAPtY+jyfggWxkyciaStz
         /DnW+kONrWRNmWpGOaIwy23lemeSnPMIog1M77i1Fzdv6c40EZOPVib4StRxhLhalkXP
         OuI+SywmfsLKJUPTtdkL4JoXW6oeFsHdj/+nhWGtrstnX8osfuDbjTcsD7lMhpCgT1So
         MVm5Gbh5XzAPu3ZVtZDuG1cvI2QwNx5vxBITuccEZOc+6SeOshMRKERHsus2DvcaU6Bk
         qIrV9bdxValO6k8/X9zF1yCHFVjUFTBoMiBJ04+kKqZFbUwmmyyavUhQQfJiMyYEyx7N
         4vMQ==
X-Gm-Message-State: AOAM533hpqUsVufWsmK9Jy0f0WDZMl09mihldfpIN3BVFyrug43K38IV
        gKYfVg8XjfQxEUhOmLGc/8fqjfSV9e5EBjrMFJ4=
X-Google-Smtp-Source: ABdhPJzhqrR9Z509Ybk1zXarEfqo7oMWYwEwzmJk6yr2Ce+F4Fl9Vv6Knh2saA4O4OhmeM5y7MRL1sU7iskXWMQLEQY=
X-Received: by 2002:a02:c519:0:b0:32a:e80c:a618 with SMTP id
 s25-20020a02c519000000b0032ae80ca618mr5775965jam.140.1650989683956; Tue, 26
 Apr 2022 09:14:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220423140058.54414-1-laoar.shao@gmail.com> <20220423140058.54414-4-laoar.shao@gmail.com>
 <CAEf4BzapX1CKCX5VWwMkbm5yHukq36UxwcXDduQCMW=-VEEv4Q@mail.gmail.com>
In-Reply-To: <CAEf4BzapX1CKCX5VWwMkbm5yHukq36UxwcXDduQCMW=-VEEv4Q@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Wed, 27 Apr 2022 00:14:07 +0800
Message-ID: <CALOAHbDWvRAe=O-cG1nOMgant38g68u0t9HsDy4RDO7bh=hnUA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/4] bpftool: Fix incorrect return in generated
 detach helper
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 2:47 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sat, Apr 23, 2022 at 7:02 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > There is no return value of bpf_object__detach_skeleton(), so we'd
> > better not return it, that is formal.
> >
> > Fixes: 5dc7a8b21144 ("bpftool, selftests/bpf: Embed object file inside skeleton")
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  tools/bpf/bpftool/gen.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> > index 7678af364793..8f76d8d9996c 100644
> > --- a/tools/bpf/bpftool/gen.c
> > +++ b/tools/bpf/bpftool/gen.c
> > @@ -1171,7 +1171,7 @@ static int do_skeleton(int argc, char **argv)
> >                 static inline void                                          \n\
> >                 %1$s__detach(struct %1$s *obj)                              \n\
> >                 {                                                           \n\
> > -                       return bpf_object__detach_skeleton(obj->skeleton);  \n\
> > +                       bpf_object__detach_skeleton(obj->skeleton);         \n\
>
> It's not incorrect to return the result of void-returning function in
> another void-returning function. C compiler allows this and we rely on
> this property very explicitly in macros like BPF_PROG and BPF_KPROBE.
> So if anything, it's not a fix, at best improvement, but even then
> quite optional.

Right, the C compiler allows it.
I won't change it.

-- 
Regards
Yafang
