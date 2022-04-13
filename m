Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B304FFBAC
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 18:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235517AbiDMQsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 12:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237072AbiDMQs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 12:48:27 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657386A017;
        Wed, 13 Apr 2022 09:46:04 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id p21so2551462ioj.4;
        Wed, 13 Apr 2022 09:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8GFQwLqRtDMmyy6jTScqi2CyOUvHmy6pFf5FG85R2pM=;
        b=nqB6euXBsgtEqh4dqdbB0D40E86eJ6RrG0Vx+32kUQ/yudRjhgjWlpIhRW45WK/d9/
         zC9y+ogxHBP+MQHJ//eSZjTPqY3cBZg5oC6vgx5C/3UTqmP0F9tQCFgV6tq511tOn+a3
         7c4H2xlAiR4On8TMRYFxU7FypCBzFeSagUjvJK15Y0GwHusPcUUMgUm6aNrQG2cVLseR
         tx41/Fv+2cRJeY/4UYQ/vPFuk6gB+fxnfOscsvbUNHaSMwnK5XFlDbdn53BbUBwBJao3
         unvPxgu/adD9HLwT0Cdtk0m4XgW390HgNSvQXIDGObZq8QOplTdudjwGU66DIFrfJ8yn
         gn3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8GFQwLqRtDMmyy6jTScqi2CyOUvHmy6pFf5FG85R2pM=;
        b=HpQ9Uqz07LO5312HIMCklNqqP/n8FsxZNLyOjxDB5SRmxKOrYD5PlGnDJKojuWJpDG
         Vzb/eZpCViheAEPaDsvXRvRhzsBM92vQ4gjUu9O0/87ICp3wvTM98TL8BSVrwTDSUH3D
         6dvbyq59GQvysg02XXZpRehugUD0rUhztKuIYDZf601M7m3Q5d0pyzhY5RkVe1EOxh5T
         SwsAxsTb+9wO4HvaxYNIVc6+sL8BD4KJhpHqoUfxhPlz9CiyPa9DueO/KoCUsj15nQ/2
         pjTQO620hOdze+cXChma1AOU9D2iFpshRkx6fgEXvYiyaFCOGMfI62qaFzWvX/PyX+9L
         DyVQ==
X-Gm-Message-State: AOAM532YVeO/RCDnbRjJfBJl8L3HJZHw2Xi3a4x/AWv58Z0QlIq2P4e5
        7EwUkSPRmdKB3zSEDvdDGKPigSd2VgOzcrgEyFA=
X-Google-Smtp-Source: ABdhPJyZ3zkPRWoWmGhtHEbfqFV7vuVEMvcP51UvmwXj6EXRc9qHVixHAXmWrBErXuOpHX2NiNQUdJPvM3oDo9G7Mmw=
X-Received: by 2002:a05:6638:33a3:b0:326:3e11:3f3b with SMTP id
 h35-20020a05663833a300b003263e113f3bmr5361029jav.93.1649868363559; Wed, 13
 Apr 2022 09:46:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220407125224.310255-1-jolsa@kernel.org> <20220407125224.310255-5-jolsa@kernel.org>
 <CAEf4BzbE1n3Lie+tWTzN69RQUWgjxePorxRr9J8CuiQVUfy-kA@mail.gmail.com>
 <20220412094923.0abe90955e5db486b7bca279@kernel.org> <20220413124419.002abd87@rorschach.local.home>
In-Reply-To: <20220413124419.002abd87@rorschach.local.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 Apr 2022 09:45:52 -0700
Message-ID: <CAEf4BzaA+vr6V24dG7JCHHmedp2TcJv4ZnuKB=zXzuOpi-QYFg@mail.gmail.com>
Subject: Re: [RFC bpf-next 4/4] selftests/bpf: Add attach bench test
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
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

On Wed, Apr 13, 2022 at 9:44 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 12 Apr 2022 09:49:23 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> > > I'm really curious how did you manage to attach to everything in
> > > available_filter_functions because when I'm trying to do that I fail.
> > > available_filter_functions has a bunch of functions that should not be
> > > attachable (e.g., notrace functions). Look just at __bpf_tramp_exit:
> > >
> > >   void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr);
>
> Did you only use the "notrace" on the prototype? I see the semicolon at
> the end of your comment. It only affects the actual function itself,
> not the prototype.

notrace is both on declaration and on definition, see kernel/bpf/trampoline.c:

void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr)
{
        percpu_ref_put(&tr->pcref);
}


>
> -- Steve
