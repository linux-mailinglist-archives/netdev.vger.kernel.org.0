Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1E9109546
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 22:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbfKYVxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 16:53:08 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45556 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfKYVxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 16:53:08 -0500
Received: by mail-lf1-f67.google.com with SMTP id 203so12253024lfa.12;
        Mon, 25 Nov 2019 13:53:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XkRgDrEt7xzx/syrzYXXT4cApNXjq2/kEFLNeHp9+qg=;
        b=ERlzkI8Zekt2L5iGgIbMhY5/BsfR4+K2EbCpyJDVKHVBLBCvB3x5169UQJ4TLgHwB6
         rHmktjxeZhGtat6lMimIMkLgX0KaJWsltQQKXuPVM+jQZYRC5pNu8GzCvbnO3b65bo31
         aw8CaSP6TNP1szyb3iqsxvepNADwWywAeWjEJDmZuSAQZvi/7BG8cfkKhVVTvEKSxZmF
         VwdZyYs2t8etGdoZ874SJ8g6TrcbN/+a9GUJAeEgKHHy/8sIwrH16ouZto/v1flU39nI
         PMpNl1q/RkbL+nhvL05k6uWIZYwnQ2WoEztniiYPtdBxrz6q5mDijOKUNOXk43Mq+Q7Y
         pv+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XkRgDrEt7xzx/syrzYXXT4cApNXjq2/kEFLNeHp9+qg=;
        b=L/Os6Yq86fvWkiZxY2bwId1URpzt/RYkhKmg7rOOb6qQbIoNEBI+T+hsK2XPxCRTRh
         Xurz8mJjnc3gBDyIdNMq3Z86RZoW9LMm12FNGQcl3p2sNPTxqWVfPljGKUuqMW44oKjB
         Cm6essaylJkOEKRrvTn6A1sK4bz+88kyI2z0T7MXqWiAIkRTQFBTvmW4fyT69Zdw9210
         bWtd8OfkIbyjbssFPwrR+KcbZCQA62RuLzpkQwoD1hHWog1UB6DIUs0tUxK8Cr6eh6Ym
         HuDVPPPRWesXKIq3a5YQIhbdYcyxtlfBAjTfmwe7AfN+s9tV+h77DMtcUduzHKi6PhNL
         tKXQ==
X-Gm-Message-State: APjAAAW0tkWaeLndVU7C37Elf2Fii9XufPnmjugx+CUA6V1jwJbvMVEx
        A40aipTCf0UX1Qpu/V/5Zz2IvIk3S6F4yRfniIU=
X-Google-Smtp-Source: APXvYqzVMDpVPS/0yse9kP0C7QQ3+VjbW0gDDpHDoWlX4vV5llfTQVR2wXkWuYJLH+7WuJNeMengUvGbuZwOpeLHBNc=
X-Received: by 2002:ac2:47ec:: with SMTP id b12mr16855821lfp.162.1574718785832;
 Mon, 25 Nov 2019 13:53:05 -0800 (PST)
MIME-Version: 1.0
References: <20191123220835.1237773-1-andriin@fb.com> <5ddc3b355840f_2b082aba75a825b46@john-XPS-13-9370.notmuch>
 <CAEf4Bzbii9W=Frc3aPLrLsCWq1fFJXADhhQ4w7_d15ucqBuWHg@mail.gmail.com> <5ddc3eada4ad1_78092ad33cdb65c0b0@john-XPS-13-9370.notmuch>
In-Reply-To: <5ddc3eada4ad1_78092ad33cdb65c0b0@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 25 Nov 2019 13:52:54 -0800
Message-ID: <CAADnVQKa-ThGGnO5vYEAPfNZUYd76AD1MqqAExNyf+PQMpSqOw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] mm: implement no-MMU variant of vmalloc_user_node_flags
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 25, 2019 at 12:51 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > On Mon, Nov 25, 2019 at 12:36 PM John Fastabend
> > <john.fastabend@gmail.com> wrote:
> > >
> > > Andrii Nakryiko wrote:
> > > > To fix build with !CONFIG_MMU, implement it for no-MMU configurations as well.
> > > >
> > > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > > Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
> > > > Reported-by: kbuild test robot <lkp@intel.com>
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
