Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27F4354A03
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 03:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbhDFBYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 21:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbhDFBYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 21:24:34 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205FEC06174A;
        Mon,  5 Apr 2021 18:24:28 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x26so2553856pfn.0;
        Mon, 05 Apr 2021 18:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hYzRS/wlypVqH0IvoJw9sUm1GUja/CbTWzU5hFzc+Ec=;
        b=lkulRVRVkX+0E2oD0A1twR7gLHyDGbTjlIOAjqRkxGVaH3esCB4vzXE8wmbEgrl7xT
         0+DIMLvy0VU/oJWMen1qfh8UogTsP/WtCwEMt0Q+WNEiaGgABxIDC8kGDRbKBmKpBp3H
         JzbnJlRi0L5yfEohgRLpnxTwki4+eivePZce4kIB44fy4VuQWwjFRPJyhnYwXVKdRTJX
         W5hEjLrCHCDx8g+I8xtog1IIELeq7SrLr/C7V0gw1aUjFQQ4ELUWKfz8XuO50k3NBYxa
         sG6UQoW8KuBL6+svut3o8cyXvCRPxeSWMgaTylcBpsqwO3fh14tYTRfRTKYyt5tUwcFY
         zyMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hYzRS/wlypVqH0IvoJw9sUm1GUja/CbTWzU5hFzc+Ec=;
        b=QxTIkxChw+2nJoDzPCTVSAmpy623s2hzzYygpr2u/q6F8bTjqB9rOfazTcMkacEy2Y
         RJGRf57VHFlmlIcTXLYx3me1faaBDs/QApqW+A8A65Sd5ME4xdCmAqRSEtSf+q7NbZ9f
         NsWH2UB02gUhJ9MZ5Bb3tu9ZccXoJ6gsTaxRpOrA8oOKEwOdxl7Gu61Mh37GCpisjmJF
         K5kOgWnlWM1aGt2bC0LeVKmjssnNw0QuAoYOIRgD2OTBj6QJ0QSke59wqeWBOLFALyMO
         UTeYluHjyEwqyjaJAIbmNEuF2//Mx5kwoiRTlX/Lj68fdOOsq9fAn6kdh+NPNcWdQ9jk
         IzlQ==
X-Gm-Message-State: AOAM533DEhIdHXSTdGeXsvG4bpZcugjrjdscmkgkKFb3AH79tlJSP190
        XrN04iFpevhqCyB0DVHgw3yIphn/yh3wC7xgki0=
X-Google-Smtp-Source: ABdhPJzwDn337PkZFxgIXjO8aJUR5f6UneqrvgRL88O0Ehw6yBtUKg1OoJLto0P+7ASULP+r86BWjoP7kivYnB0wUTY=
X-Received: by 2002:a65:45c3:: with SMTP id m3mr10581271pgr.179.1617672267689;
 Mon, 05 Apr 2021 18:24:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <B42B247A-4D0B-4DE9-B4D3-0C452472532D@fb.com> <CAM_iQpW-cuiYsPsu4mYZxZ1Oixffu2pV1TFg1c+eg9XT3wWwPQ@mail.gmail.com>
 <E0D5B076-A726-4845-8F12-640BAA853525@fb.com> <CAM_iQpWdO7efdcA2ovDsOF9XLhWJGgd6Be5qq0=xLphVBRE_Gw@mail.gmail.com>
 <93BBD473-7E1C-4A6E-8BB7-12E63D4799E8@fb.com> <CAM_iQpXEuxwQvT9FNqDa7y5kNpknA4xMNo_973ncy3iYaF-NTA@mail.gmail.com>
 <390A7E97-6A9A-48E4-A0B0-D1B9F5EB3308@fb.com> <CAM_iQpVZdju0KhTV1_jQYjad4p++hNAfikH5FsaOCZrcGFFDYA@mail.gmail.com>
 <93C90E13-4439-4467-811C-C6E410B1816D@fb.com> <CAM_iQpXrnXU85J=fa5+QjRqgo_evGfkfLU9_-aVdoyM_DJU2nA@mail.gmail.com>
 <DCAF6E05-7690-4B1D-B2AD-633B58E8985F@fb.com>
In-Reply-To: <DCAF6E05-7690-4B1D-B2AD-633B58E8985F@fb.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 5 Apr 2021 18:24:16 -0700
Message-ID: <CAM_iQpW+=-RsxfYU_fWm+=9MSr6EzCvKwUayH3FyaPpopAtpWQ@mail.gmail.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
To:     Song Liu <songliubraving@fb.com>
Cc:     "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>,
        "duanxiongchun@bytedance.com" <duanxiongchun@bytedance.com>,
        "wangdongdong.6@bytedance.com" <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 5, 2021 at 6:08 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Apr 5, 2021, at 4:49 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Fri, Apr 2, 2021 at 4:31 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>
> >>> On Apr 2, 2021, at 1:57 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >>>
> >>> Ideally I even prefer to create timers in kernel-space too, but as I already
> >>> explained, this seems impossible to me.
> >>
> >> Would hrtimer (include/linux/hrtimer.h) work?
> >
> > By impossible, I meant it is impossible (to me) to take a refcnt to the callback
> > prog if we create the timer in kernel-space. So, hrtimer is the same in this
> > perspective.
> >
> > Thanks.
>
> I guess I am not following 100%. Here is what I would propose:
>
> We only introduce a new program type BPF_PROG_TYPE_TIMER. No new map type.
> The new program will trigger based on a timer, and the program can somehow
> control the period of the timer (for example, via return value).

Like we already discussed, with this approach the "timer" itself is not
visible to kernel, that is, only manageable in user-space. Or do you disagree?

>
> With this approach, the user simply can create multiple timer programs and
> hold the fd for them. And these programs trigger up to timer expiration.

Sure, this is precisely why I moved timer creation to user-space to solve
the refcnt issue. ;)

>
> Does this make sense?

Yes, except kernel-space code can't see it. If you look at the timeout map
I had, you will see something like this:

val = lookup(map, key);
if (val && val->expires < now)
   rearm_timer(&timer); // the timer periodically scans the hashmap

For conntrack, this is obviously in kernel-space. The point of the code is to
flush all expired items as soon as possible without doing explicit deletions
which are obviously expensive for the fast path.

Thanks.
