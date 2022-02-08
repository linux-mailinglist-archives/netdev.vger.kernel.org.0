Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1464AE337
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242584AbiBHWVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386603AbiBHU7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 15:59:05 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39149C0612B8;
        Tue,  8 Feb 2022 12:59:05 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id w1so400970plb.6;
        Tue, 08 Feb 2022 12:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QbUbLD297C9LHR9dKbjFBfXBQLTZCqp5XODbPA8494E=;
        b=GR3YHCi59fIouyPxReubqzheXrTudQk8/YISzRbx4NacvXM05rBWHuJ61rR8tYCLA0
         /m/EGzBX8ZStMf/SRU/EVwZFqXcvWdk5PqtYHVf4qq5uF4DheElf0lCpP8+3ZdEJo1ok
         xHRAVI03hoyT5/eRqyJwp5m4XnVN6qMnbgTGosGxrfRxA1R//55sNkTr4syLelgvlWCh
         cRGVe1wxx0A/c3g1DX6lTRwHtCvfzSdRYdQaFMxONmINvYoX3ivwhYno4i3/yH+zWpIA
         iKfq3AOruZz4M+Z7njLWWYGZ0VXof/ioEDOD19omHbYq48IaDvFS6I7dRq0iYcqgBr6E
         ejKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QbUbLD297C9LHR9dKbjFBfXBQLTZCqp5XODbPA8494E=;
        b=UxfHKaJSIPFAX4zhIzClxVRstrywFPJnHZNzE2Xvc4PHWWicadi9xFvGih4aBI1hlz
         oo+HOe/hlU8SsgU6B2v0vxagGoXn6XBH0J98hXwr2eYwOKKeTByopH+0DdizulyqosRn
         8Fyh7T2ydfGWGb0JRK9XjbqQWyWYYw4B4BRT6j8D44ZfSoIrBeOjqwT74MXJ8EZTvLC9
         XDe0euCloeBlMCctIqVf2NTvkYumdQEWL89i6CC2mwh6lrI75jnlflH8Bm1gUpfGAOj8
         mNtiNH1/jLnLwIlXg017/zI7yjNzJ8NpZUPF9DLAh2w/YJKmMFb+qKic70x93RSE7BWo
         LSng==
X-Gm-Message-State: AOAM530Xfikj01FTh4fZHXv4lbdaLTDVM0oV0t966BhhWh7G509y3CE1
        0POjabtg0zaQlZxykcREuitA4Gt177k2tqYDxkQ=
X-Google-Smtp-Source: ABdhPJxB9Dam2j36CTMuCJ2pZ2vVkd4UZ4Fg1UbAby9D6k8q7VQ3EJ0LqOpgDc1mS5cuYaJaw1yOv5DkASUbVUl/4BI=
X-Received: by 2002:a17:902:b682:: with SMTP id c2mr6335748pls.126.1644353944609;
 Tue, 08 Feb 2022 12:59:04 -0800 (PST)
MIME-Version: 1.0
References: <20220207131459.504292-2-jakub@cloudflare.com> <202202080631.n8UjqRXy-lkp@intel.com>
 <CAADnVQKGF=YaKvzWZFO1c9bO63XHoiD=i-w-chCeSbaNoRfdwg@mail.gmail.com> <87y22lqeeb.fsf@cloudflare.com>
In-Reply-To: <87y22lqeeb.fsf@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 8 Feb 2022 12:58:53 -0800
Message-ID: <CAADnVQJ997daVetpma+FAtasJ3NsZskwvU7+-o4A=YhTydf98Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Make remote_port field in struct
 bpf_sk_lookup 16-bit wide
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     kernel test robot <lkp@intel.com>, bpf <bpf@vger.kernel.org>,
        kbuild-all@lists.01.org,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
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

On Tue, Feb 8, 2022 at 12:42 PM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Tue, Feb 08, 2022 at 08:28 PM CET, Alexei Starovoitov wrote:
> > On Mon, Feb 7, 2022 at 2:05 PM kernel test robot <lkp@intel.com> wrote:
> >> 7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1148
> >> 7c32e8f8bc33a5f Lorenz Bauer 2021-03-03 @1149   if (user_ctx->local_port > U16_MAX || user_ctx->remote_port > U16_MAX) {
> >
> > Jakub,
> > are you planning to respin and remove that check?
>
> Yes, certainly. Just didn't get to it today.
>
> Can either respin the series or send a follow-up. Whatever works.

I think respin is better.
