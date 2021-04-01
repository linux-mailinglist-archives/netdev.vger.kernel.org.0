Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450D8351807
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 19:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235890AbhDARnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234665AbhDARjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:39:03 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF3BC0319D9;
        Thu,  1 Apr 2021 10:28:24 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so5042066pjb.0;
        Thu, 01 Apr 2021 10:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DCSwYaITEXQEtOU9ZD5TxRNN3tBhbIlUXlHRNkWJ4G0=;
        b=qQQ/vLHND0Pm7FoXvew0tIzmLeRM+qIP0Ujxammay52iRgrrFXs4C3nsXIGvEUzWmY
         4tLBBtY7scDoqzjzIGiNmBPUYVkLvtI1Q3LtsgxlY0EUIfdwDrk8EPp4hZpUHaTNfvHE
         bDu4M/nKDpnkgAX2yh95uFbFWp1jiAfJvxDN+5VQqMQWz8JrZdGS/LxuUoANVQse+uMQ
         WPDXg7cpRnS5ukjn9CWkj40LCeXPqFhNFXgzGJCvagGDbaXUHq/L24T+CzU86mtCpqsH
         XooFnu2Wl6C+h7ZaDQm1/M4QWvx8GIbmmDMe+ZjajvV+ZrSGKKVc87h81eBNVMstsVLN
         YHpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DCSwYaITEXQEtOU9ZD5TxRNN3tBhbIlUXlHRNkWJ4G0=;
        b=mVqA4BjyvkY2f8ye2cy75LDRp8HQpoEMlSGJsBSkjnRy4g40iyr1xGFzVcXxYmaeb9
         8EYnLNB3CwoQ0hrI25cJHMAud+9aBkUOzb17Jtdc2OFuAhhFFY6M8SXIaSDgN5cfJdzq
         66FegRQ+CCuYS/ct8yT1pdEGaaTp7yXmh8koIbk6RfvAGi/oxA+iQJuq+ZY7FmF/0P0v
         YgP+H+YGIaxLBlXNFehsb0GW7RReHe6Gx7ic1GBI4Wr37+L0dmZFMhKv8xmsZi+qJrUg
         qpd797Nqmr9cgpAbcoMHnkr++Z7b3lJ+GldqWVkGAjEUZ2fq9Zpctg8vQxYoAXgXjdB5
         1f8Q==
X-Gm-Message-State: AOAM530j8YgDCUgA3vLP71F8bEd69Giso2H7SRJlFFwu2DK2vHbzzPc1
        BROAk4M0x5pxVUZreN/Sokx1L/2bxTKLesGy7lQ=
X-Google-Smtp-Source: ABdhPJwuRg9c87ReRDYEl/MFlZj8f+JRwd8nbe3KpkmGKzBacN9tlwCCWEr2kLZwmSTneY14fAN+W55rfS/fi5VrJlw=
X-Received: by 2002:a17:90a:7061:: with SMTP id f88mr9971510pjk.56.1617298104093;
 Thu, 01 Apr 2021 10:28:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com> <B42B247A-4D0B-4DE9-B4D3-0C452472532D@fb.com>
In-Reply-To: <B42B247A-4D0B-4DE9-B4D3-0C452472532D@fb.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 1 Apr 2021 10:28:12 -0700
Message-ID: <CAM_iQpW-cuiYsPsu4mYZxZ1Oixffu2pV1TFg1c+eg9XT3wWwPQ@mail.gmail.com>
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

On Wed, Mar 31, 2021 at 11:38 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Mar 31, 2021, at 9:26 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > (This patch is still in early stage and obviously incomplete. I am sending
> > it out to get some high-level feedbacks. Please kindly ignore any coding
> > details for now and focus on the design.)
>
> Could you please explain the use case of the timer? Is it the same as
> earlier proposal of BPF_MAP_TYPE_TIMEOUT_HASH?
>
> Assuming that is the case, I guess the use case is to assign an expire
> time for each element in a hash map; and periodically remove expired
> element from the map.
>
> If this is still correct, my next question is: how does this compare
> against a user space timer? Will the user space timer be too slow?

Yes, as I explained in timeout hashmap patchset, doing it in user-space
would require a lot of syscalls (without batching) or copying (with batching).
I will add the explanation here, in case people miss why we need a timer.

>
> >
> > This patch introduces a bpf timer map and a syscall to create bpf timer
> > from user-space.
> >
> > The reason why we have to use a map is because the lifetime of a timer,
> > without a map, we have to delete the timer before exiting the eBPF program,
> > this would significately limit its use cases. With a map, the timer can
> > stay as long as the map itself and can be actually updated via map update
> > API's too, where the key is the timer ID and the value is the timer expire
> > timer.
> >
> > Timer creation is not easy either. In order to prevent users creating a
> > timer but not adding it to a map, we have to enforce this in the API which
> > takes a map parameter and adds the new timer into the map in one shot.
>
> I think we don't have to address "creating a timer but not adding it to a map"
> problem in the kernel. If the user forgot it, the user should debug it.

Good point. Initially the timer is created in kernel-space, now it is in user
space, so it is probably fine to create it without a map. But we would have
to provide more syscalls for users to manage the timer, so using a map
still has an advantage of not adding more syscalls.

Thanks.
