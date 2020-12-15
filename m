Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829242DB4F0
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 21:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbgLOUUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 15:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgLOUTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 15:19:23 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42988C06179C;
        Tue, 15 Dec 2020 12:12:40 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id n3so430850pjm.1;
        Tue, 15 Dec 2020 12:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D1I0ZiQaLvvtAbg2esYayXxwRuFD8q6/FTfF+1iFhLU=;
        b=eKrQAOWJgNQ7wHZjKaPn+ARcagkP3rXd3am/N6J5Bc6sStz7v8RvdRQMKXkECN6s0z
         /NZodb/XlgonNJTC4xiWtvPmD9p/tt1nn3ghR17Acvs/A3S8j+oH2vR05LXPJobXsMBm
         hSEYPwNV6Y4vohHS6wzDersnS9vPXrbYBhv0DZwM4b9QiQZRGpcwwPRc8dPHiMpZsXke
         qSlgV87HKS5sAacRLsBFVeKuzsPe0BxxLaN96+J5p6qZt0VUHEMFuJlEZhoJLaJyiQEZ
         eVf3cI8yFgrsKK3DEu7oT72GHrwiLDItO1/wdCJK9xun2fEkzwJED52svoXc4v9/CPX1
         rsGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D1I0ZiQaLvvtAbg2esYayXxwRuFD8q6/FTfF+1iFhLU=;
        b=XwNvY9Shfdzm3hmKyT8N1LOamGys5wTVliDd2z9L5x3DFZkxhKn7FvOPgDUEU/BdID
         wNjZa4RXbMPWkuccKHyC6r2r+yvBcoyQPKLPgE4S5YIJqaR9WumRohfFyPPrMK1wLRbx
         IW7RQa31oNJWDlLTuBXzdFSg5g759xan4ZtzfqoVDA4Xx9dYkmJlmcZv1BN3X1Y43X8B
         4Lh6vGY3jfuwzJ+bwyvqXcqOuPeIRcnLB3IhrvSE/sjwocYfU4sQfjMqNb6h9/5se/iO
         DlbKIHNCGVmbrY68LKkHbFfGnJkwhyMdZxXPO7cvlZWDxaevlfbV4c5R6kcEqKPyX2LT
         ndZQ==
X-Gm-Message-State: AOAM5334uwc3WWnJvlVCGdaNqW1bmbwyDgz6VowA28cdJ3kRDkmSLZvy
        baMvnAX2ekReKVG67MWXh+3XlMzn0bNvLpiIa5s5BnHOYNaiWA==
X-Google-Smtp-Source: ABdhPJzp7DwyrmatgLLN6M7AwpqwvA+FRw2hSGKFncE6z02Tx79RmSySLFMEms95DCDdJ0c9BlU7Y6FVtIYGeL/30Bw=
X-Received: by 2002:a17:902:9302:b029:da:f6b0:643a with SMTP id
 bc2-20020a1709029302b02900daf6b0643amr28947434plb.33.1608063159715; Tue, 15
 Dec 2020 12:12:39 -0800 (PST)
MIME-Version: 1.0
References: <20201214201118.148126-1-xiyou.wangcong@gmail.com> <CAEf4Bza1tAnAMVw8g4z2UviYqWxgarOXZX2JDTShYyk-NLAo6A@mail.gmail.com>
In-Reply-To: <CAEf4Bza1tAnAMVw8g4z2UviYqWxgarOXZX2JDTShYyk-NLAo6A@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 15 Dec 2020 12:12:28 -0800
Message-ID: <CAM_iQpVn1dQJGTToiccy=g5dtYkimpf=RJrQL0iSpQjP5RwetA@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 0/5] bpf: introduce timeout map
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 11:29 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Dec 14, 2020 at 12:13 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > This patchset introduces a new bpf hash map which has timeout.
>
> It's a bit too short a cover letter for a pretty major new type of
> hash maps. Please expand on the problem it's trying to solve, how you
> tested and benchmarked it, etc.

I prefer to put everything in each patch description, because `git log` is easy
to find it after merging. (I know we can retain this cover letter but
it is not directly
shown in `git log kernel/bpf/hashtab.c`)

Please reply to patch 3 if you think anything is missing in its description.

Thanks!
