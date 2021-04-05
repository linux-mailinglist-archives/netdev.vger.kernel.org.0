Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BAB35496E
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 01:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242086AbhDEXts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 19:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237601AbhDEXts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 19:49:48 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245EFC06174A;
        Mon,  5 Apr 2021 16:49:40 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ep1-20020a17090ae641b029014d48811e37so1424050pjb.4;
        Mon, 05 Apr 2021 16:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RuxepOXsnq18AgBLMZ/EBC0rFDj8thVgw/m75jH2nK8=;
        b=ZKjzmZFzqhpy5qB58JTx6ipaZp4d1UrWJijI03RMU8E6nyssjsskdmYnFJieyKdXIw
         rKe87MABOXHvlzlT3kutkuWoHV79w3MrRHqKwmR5sS/XL6TSzd+RLJVWoztO+FWqaSIb
         Kzb2XwwYbf0zATcrMNGT4yIDHwDoDaTeVUxWs163kV5ruFMgRxS8JKl45+TbSXyC0xnJ
         Dft0kCD30eYkf6qfSDULjwE3q7NQ/EaLietg8NTcwPwBT8gXoBzPbYqyvBvbN8mvRugh
         1vYupK0O/DlOFhOny+rI3SiGN0G3JcpFwgUBEj90WgX98K/lBXlaViPvGJ/1vo4O3Aey
         NBJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RuxepOXsnq18AgBLMZ/EBC0rFDj8thVgw/m75jH2nK8=;
        b=QP7Z5cziC5lhtz5y5fT/dy04dBl6uhdght2H84nEMP6Os7Y9VOxcL7Zf8i93kw7qVz
         /ysAzMCn8KOnWM/N8yK5PcvmBqu41ZTEvyu/TftwKcfVoQIj4t17BsohPg8P4+OtMfov
         Fp9HUA4w0Gjq44Cdhbmy2LGqNarIeBTeBdW8Ro3HT8Cv+/ijwW0rx8hlJ3RZRj07Buxt
         dleQ0KGHpZMGWDJbYyYdoCF0HT8lQjV8cIuAmG8LwL8blLZmoMf1IcQpB13r5dKf2s0Z
         GdQDWG9p5rfq4aQmj8VMDCPB6ZYq7IUyN6Pi2oD0RHhcl19gu4Ue8g0rWkoqFedL/yZX
         cJQw==
X-Gm-Message-State: AOAM532RMAAV4gMgu6dJNa+VbQQJZOj7yCOEKoHpC7NoDoQtUr4wRKUZ
        O4xdHXxYFL6+0l06KpRn6PNedE33OEAceg/rVcM=
X-Google-Smtp-Source: ABdhPJxWwqX+Ja5oWo04iWSouqWoXghSXxiQMNNc8EmhNRgPF75SHp7aoBU2Q3hFlKYoNRxqG/G9KQUwkamvLTbCbAI=
X-Received: by 2002:a17:90a:31cd:: with SMTP id j13mr1570778pjf.231.1617666579589;
 Mon, 05 Apr 2021 16:49:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <B42B247A-4D0B-4DE9-B4D3-0C452472532D@fb.com> <CAM_iQpW-cuiYsPsu4mYZxZ1Oixffu2pV1TFg1c+eg9XT3wWwPQ@mail.gmail.com>
 <E0D5B076-A726-4845-8F12-640BAA853525@fb.com> <CAM_iQpWdO7efdcA2ovDsOF9XLhWJGgd6Be5qq0=xLphVBRE_Gw@mail.gmail.com>
 <93BBD473-7E1C-4A6E-8BB7-12E63D4799E8@fb.com> <CAM_iQpXEuxwQvT9FNqDa7y5kNpknA4xMNo_973ncy3iYaF-NTA@mail.gmail.com>
 <390A7E97-6A9A-48E4-A0B0-D1B9F5EB3308@fb.com> <CAM_iQpVZdju0KhTV1_jQYjad4p++hNAfikH5FsaOCZrcGFFDYA@mail.gmail.com>
 <93C90E13-4439-4467-811C-C6E410B1816D@fb.com>
In-Reply-To: <93C90E13-4439-4467-811C-C6E410B1816D@fb.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 5 Apr 2021 16:49:28 -0700
Message-ID: <CAM_iQpXrnXU85J=fa5+QjRqgo_evGfkfLU9_-aVdoyM_DJU2nA@mail.gmail.com>
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

On Fri, Apr 2, 2021 at 4:31 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Apr 2, 2021, at 1:57 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > Ideally I even prefer to create timers in kernel-space too, but as I already
> > explained, this seems impossible to me.
>
> Would hrtimer (include/linux/hrtimer.h) work?

By impossible, I meant it is impossible (to me) to take a refcnt to the callback
prog if we create the timer in kernel-space. So, hrtimer is the same in this
perspective.

Thanks.
