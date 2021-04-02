Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898BB352E7F
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 19:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbhDBRfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 13:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhDBRfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 13:35:04 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316C6C0613E6;
        Fri,  2 Apr 2021 10:35:02 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id g10so2794888plt.8;
        Fri, 02 Apr 2021 10:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BMBDLVBHReXrptTsoHAndpojA7TxC5isHE8cJZNoRik=;
        b=PsgFSvfkjq36ChFMniqiCXeatRfJey9RpMwyFwXYiWWrW30nEqsNsDtrMCp1Mh/kvI
         wAQCL/nYrGfbPAQrwuvUi6BR0AvA4Vv4S+u1dN5GgmrismCjIIzQosNMSPLJWHVj7dm9
         HIatkDo1VsfoByRpQQYD6oIYK4z5X43MGzi4ngC+5hoeCxlPTU3AO38rZnvxDT5l/j9H
         ra59BPPrPhF47Y7AOS1YmdEnWGwS7iUNlbz7yFi4x/BItbkpP7yG/zv/tzS335OdVFJJ
         19xbzEITqg5HD5+HzYTW76wZjs7WLveYT3KMQaJ6IypUtPoqOvTTkNzHuRuQtAWNRGcv
         PhlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BMBDLVBHReXrptTsoHAndpojA7TxC5isHE8cJZNoRik=;
        b=Jv6OMszbH3x9kIqgi7GH/sXsMgQjXzgjWwG0wAbmkhFmeAD9cFCtwsWiLzwiZONf+T
         LPLT10oiceLEd+P3jLdax2unYIntoNnDghsz8phctLFyCdKjaQuokUpitJcKgbZNoTPw
         GVDqsxc5OTcwFQCys5Yf+tXfOFfUj95UKn+qJhIFvE2l4+SdMDte9ckcDNLERP6AsSKB
         +KTcPazkadVIlBbzioCtPe7RRB2pZidiayWyXQVvJBln7lISTzRpqaZY/auAW1lLi2Dj
         fppqCRtiEUihluDciLhf5kL0SuTw9w6o7tjY+zj/aCFhti6tGe5XYXjPEek2sSOsVN26
         Aqvw==
X-Gm-Message-State: AOAM531/Ee2De60aQDshaR4vdJA5E+VDMnxp2tDpYU2bGXn+7ZAgLoDk
        9s6gftL5/5USN8IYYH0nE1/ylQLe1zfNSwuANOk=
X-Google-Smtp-Source: ABdhPJx/6nxRu7rPD1Xe98bgH4WhOPjIM3VBD91fy+uPji1W2gGr/7Vl413mHWMnHiwGLnqVOgBglFH3p/VULny209U=
X-Received: by 2002:a17:902:8347:b029:e7:4a2d:6589 with SMTP id
 z7-20020a1709028347b02900e74a2d6589mr14007273pln.64.1617384901714; Fri, 02
 Apr 2021 10:35:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <B42B247A-4D0B-4DE9-B4D3-0C452472532D@fb.com> <CAM_iQpW-cuiYsPsu4mYZxZ1Oixffu2pV1TFg1c+eg9XT3wWwPQ@mail.gmail.com>
 <E0D5B076-A726-4845-8F12-640BAA853525@fb.com>
In-Reply-To: <E0D5B076-A726-4845-8F12-640BAA853525@fb.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 2 Apr 2021 10:34:50 -0700
Message-ID: <CAM_iQpWdO7efdcA2ovDsOF9XLhWJGgd6Be5qq0=xLphVBRE_Gw@mail.gmail.com>
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

On Thu, Apr 1, 2021 at 1:17 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Apr 1, 2021, at 10:28 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Wed, Mar 31, 2021 at 11:38 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>
> >>> On Mar 31, 2021, at 9:26 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >>>
> >>> From: Cong Wang <cong.wang@bytedance.com>
> >>>
> >>> (This patch is still in early stage and obviously incomplete. I am sending
> >>> it out to get some high-level feedbacks. Please kindly ignore any coding
> >>> details for now and focus on the design.)
> >>
> >> Could you please explain the use case of the timer? Is it the same as
> >> earlier proposal of BPF_MAP_TYPE_TIMEOUT_HASH?
> >>
> >> Assuming that is the case, I guess the use case is to assign an expire
> >> time for each element in a hash map; and periodically remove expired
> >> element from the map.
> >>
> >> If this is still correct, my next question is: how does this compare
> >> against a user space timer? Will the user space timer be too slow?
> >
> > Yes, as I explained in timeout hashmap patchset, doing it in user-space
> > would require a lot of syscalls (without batching) or copying (with batching).
> > I will add the explanation here, in case people miss why we need a timer.
>
> How about we use a user space timer to trigger a BPF program (e.g. use
> BPF_PROG_TEST_RUN on a raw_tp program); then, in the BPF program, we can
> use bpf_for_each_map_elem and bpf_map_delete_elem to scan and update the
> map? With this approach, we only need one syscall per period.

Interesting, I didn't know we can explicitly trigger a BPF program running
from user-space. Is it for testing purposes only?

But we also want the timer code itself to change the expire time too, it is
common to adjust the expire time based on the size of the workset, for
example, the number of elements in a hashmap.

With the current design, both kernel and user-space can modify the
expire time with map update API's.

Thanks.
