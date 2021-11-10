Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E66644C56F
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 17:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhKJQzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 11:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhKJQzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 11:55:44 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E72EC061764;
        Wed, 10 Nov 2021 08:52:57 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so2266100pjb.1;
        Wed, 10 Nov 2021 08:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JX1uiI3suEcZUq7PYk0EbJHTEZrQx+EN8b5Kv3OTMVs=;
        b=q7c+R34pwI77JcdZMGsCmuS7ZcOX8BkoJix+FW2N543T1BvlLna8+oR1PdjI+AIRcQ
         hA+QYiUagCwUXFiP0FYFQOKDZzBlguy6z9ZDo3YmNhdbe4tCnddqWPi9aSbbqAot+pQn
         6RyvksQ+7kfoTLzi2vNt1b1QuI7hyIHbZ1n8a1ehjzOmsTIU3CMyPxIaVyDEuLLHm00P
         xcTO24sbLViukvNJJiL/+j7pkwcOkL26ooeanvguJNf3TITeMLAgdn3aaXdPWiUEU4Tr
         /BH6Y4bhnN+zgiX4PZ11OurKgCNAuV//QwGRf72DClfdMAgP0RdnqXwyGhVt8rV00j3/
         pgkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JX1uiI3suEcZUq7PYk0EbJHTEZrQx+EN8b5Kv3OTMVs=;
        b=GHsdPldll1dQ25zpwLCxqr6as4mD+6S7bM0AZOMsjWA1wwBR2gLR5D63Mz74opnPgz
         aOQ0WvbxxiSghtEGyrH5/dz6d1eVRa4t+em1OI9ckyGqI/rGiYLhpmxoZ6nNDaxFiy6S
         pZYucKx6baM1sed1jMGrL8ipGqVy4MR1vDYOpLViW36tNeAqb8tET/iDPZiuzuhBys0o
         sUOCPtwDtq46TzqADedpJmQn9yzaFkuOeiL3GuTN8Xd2FTx24rG/c9N+pPu5nwVr0P4l
         AiTZ02MIbt5N0Y7qJlWywjHYbfZHOlqIjAqeR1oKIux2+HFavFznq4pT2E3vpON7mb8s
         nUew==
X-Gm-Message-State: AOAM533QmFn60t1efh+lCruH9oG91ojYVwVlPlqyVTsxpcC38+WrHElS
        PoCr7Db/9lt4cQMrxwb+zDmvKAF6f/X9/zr07eU=
X-Google-Smtp-Source: ABdhPJyXHreXiyCdWHOfLJyIW/z/B5Ktd7wSrV5jxc0QSBt0wJ6nr1PXFqLRClO1o3556Zlvw25WwrLS6xM2CyjjRUk=
X-Received: by 2002:a17:90b:4c03:: with SMTP id na3mr345403pjb.62.1636563176628;
 Wed, 10 Nov 2021 08:52:56 -0800 (PST)
MIME-Version: 1.0
References: <20211108164620.407305-1-me@ubique.spb.ru> <20211108164620.407305-3-me@ubique.spb.ru>
 <20211109064837.qtokqcxf6yj6zbig@amnesia> <CAEf4BzbaFSwSA9R1FgeD=CXdOi3iWW1QR7cF0jEnRmw6tZpiAQ@mail.gmail.com>
 <20211110073235.4cwxqxeit3hgdluf@amnesia>
In-Reply-To: <20211110073235.4cwxqxeit3hgdluf@amnesia>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 10 Nov 2021 08:52:45 -0800
Message-ID: <CAADnVQLMT=HdG5K59NAZvaxjqzQmyF2b8fgVbCK8L7RM5NdrgQ@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] selftests/bpf: Add tests for allowed helpers
To:     Dmitrii Banshchikov <me@ubique.spb.ru>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>,
        John Stultz <john.stultz@linaro.org>, sboyd@kernel.org,
        Peter Ziljstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Steven Rostedt <rosted@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 9, 2021 at 11:32 PM Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
> >
> > Won't hurt, probably. But I wonder if it will be much easier to add
> > all those programs as C code and test from test_progs? Instead of all
> > this assembly.
> >
> > You can put all of them into a single file and have loop that disabled
> > all but one program at a time (using bpf_program__set_autoload()) and
> > loading it and validating that the load failed. WDYT?
>
> Will give it a try, thanks.

Please keep asm tests as well. They're useful too.
