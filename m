Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37B2226F3E
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 21:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731059AbgGTTsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 15:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729345AbgGTTsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 15:48:50 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227CCC061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 12:48:50 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k5so404857pjg.3
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 12:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p7rC2iD3wo0oNQ6k3NcAdhyJnspg3W/7FWg9FWMeNCc=;
        b=DpBxcSV7dp+Uc3878y4A6FTCUnFg7UG7BvM3+wUETqt1tCV6dq6NhTzzVJBusLN0BH
         oyC54D1n0lopR3swYEIlBOZPl6K6+wqRXjnmyxduQT2fnWsISQotQ5fjEK+1TX/3UN8L
         uUdwlioR+bOjGPkuiLXs0/D+vWLQvDlKRs06cilMmpKcfaFNY7kBiLF2vm6qSpJuwW+b
         x1krJjjfdhKj6YX6g6t174Ir9reWw0gL2n3OjatTzgu8HbceH4I6HT2HpfaHBlej0Vnq
         KKCHXokzyH2xz73HLkeIMq42uADogFdiLXelov1POApIiYqTmoAG0zoF6Mg/hF+S7zMY
         sFVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p7rC2iD3wo0oNQ6k3NcAdhyJnspg3W/7FWg9FWMeNCc=;
        b=N+80JJh7ScwsOhYoT1LfKoD3jREmPfX/95OtW//vAkJyyy5PBqUWnphP9Zu/QG+UKV
         ab8fIMTWWhTa71BEXvDqDf6OY/kJxmUQRVW4QdvHrtd8xKhmdz4JQpyF8As9S/xXTmej
         uE4fHaLmpUnb0bK/PKmPYIA9ahcwI5SXI35XfdW9al/jPq9txiqyuQOuVru8Ynl5sJTB
         rJYOHFLnAMgYtDAiwYfWkYYS7ukeq+VeF8G7uDctl4adsqi8zjz3YYxqf6ImTOoZJ7wd
         QE2Y3QvrMCt62Qn37BTHmooXzvruQrxrfpyLnRGr9I6/zMcO77/Ya9OZnGF5xQ9L1/2g
         4Cqw==
X-Gm-Message-State: AOAM532CSLXO0vSV/Ifamy3a/1LVJUIaSfneTe5a5BHXS5ItnH7JU1ic
        k7I2zcEW2Tp3TYRd5e4yO5PPzLp4RIaD6B/ELE3AIw==
X-Google-Smtp-Source: ABdhPJwICSn8NvlDtu0svKODEjk5OCN18c6+8Gc45Ed6tmzqHVHxoTL+znXBzO87NHsorhJrLUGH4hcsDS2kKu1JykE=
X-Received: by 2002:a17:90a:30ea:: with SMTP id h97mr1031428pjb.32.1595274529468;
 Mon, 20 Jul 2020 12:48:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200708230402.1644819-1-ndesaulniers@google.com> <CAKwvOdmXtFo8YoNd7pgBnTQEwTZw0nGx-LypDiFKRR_HzZm9aA@mail.gmail.com>
In-Reply-To: <CAKwvOdmXtFo8YoNd7pgBnTQEwTZw0nGx-LypDiFKRR_HzZm9aA@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 20 Jul 2020 12:48:38 -0700
Message-ID: <CAKwvOdkGmgdh6-4VRUGkd1KRC-PgFcGwP5vKJvO9Oj3cB_Qh6Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/2 net] bitfield.h cleanups
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, oss-drivers@netronome.com,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Alex Elder <elder@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 11:23 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Wed, Jul 8, 2020 at 4:04 PM Nick Desaulniers <ndesaulniers@google.com> wrote:
> >
> > Two patches, one that removes a BUILD_BUG_ON for a case that is not a
> > compile time bug (exposed by compiler optimization).
> >
> > The second is a general cleanup in the area.
> >
> > I decided to leave the BUILD_BUG_ON case first, as I hope it will
> > simplify being able to backport it to stable, and because I don't think
> > there's any type promotion+conversion bugs there.
> >
> > Though it would be nice to use consistent types widths and signedness,
> > equality against literal zero is not an issue.
> >
> > Jakub Kicinski (1):
> >   bitfield.h: don't compile-time validate _val in FIELD_FIT
> >
> > Nick Desaulniers (1):
> >   bitfield.h: split up __BF_FIELD_CHECK macro
> >
> >  .../netronome/nfp/nfpcore/nfp_nsp_eth.c       | 11 ++++----
> >  include/linux/bitfield.h                      | 26 +++++++++++++------
> >  2 files changed, 24 insertions(+), 13 deletions(-)
> >
> > --
> > 2.27.0.383.g050319c2ae-goog
> >
>
> Hey David, when you have a chance, could you please consider picking
> up this series?
> --

Hi David, bumping for review.
-- 
Thanks,
~Nick Desaulniers
