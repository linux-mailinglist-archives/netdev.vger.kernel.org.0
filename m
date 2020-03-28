Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3151919692F
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 21:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgC1U2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 16:28:07 -0400
Received: from mail-qv1-f65.google.com ([209.85.219.65]:35222 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgC1U2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 16:28:07 -0400
Received: by mail-qv1-f65.google.com with SMTP id q73so6854286qvq.2;
        Sat, 28 Mar 2020 13:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q8XoENeb4rZ6hkSUgAxe2sL1KS1u5G/Iq/aCoXNx8DA=;
        b=Abjqbnb6ZU56JZrKkfaxAgrDfo3HZBWVZweehnHFxJn3O0Z/9be+bzolBm/vLUp/Fl
         +pHmeTSLXxv2Is1IJ2XB6rDOEsPAsgPqRp/kMWupMA19NsgUah+RT0lE+1gv/jY0zBoo
         XyCNC/nO3gXUsagyX4vTabFXRQEYFSojjS+ISoJR/683ETiERVS//G1YzrLC7Tk60iE5
         UcGSIYy5f3XXEmSoppz2QogA7Tm/hrJT65lXbhuQXqkHmjZIiBtWKrc1IQm4fWUpPNS9
         goXjDnH9GyqkXweyIpzoyjxplA8b3mmNhHpf8VBZzqsUEAct9hs7PeevTqra5Gl8bA7T
         /ZoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q8XoENeb4rZ6hkSUgAxe2sL1KS1u5G/Iq/aCoXNx8DA=;
        b=a/NVp2MuI963L7XJKNCathuQpey47vPmTzupimLtInzQ8TaEtLseNtisJzoPOKAklE
         sIwXHCV+RdRESAEYglb4t3l5FmPtVc9/9PKSFJdzsl1Alw0nDANkAb+LZL7Xj+WGwD8J
         Me7seWfx0U+aP9I/4gBXHhsgEVUZKuVn8kpXQloIKmW1umB0n0K6qJmib+0t6mkBKcUe
         3/XJ4uVytDYNAC2xGo3U/mpYboi6W1YKXmWFJaX7JYQsx3lW277cMPh3hV1p9VsVtzVW
         mwKhOfMhvJF3Ta3FTJJF9QoAdJ08aabuo5y7T+WHTWoY+naNySAbkPQ0DKdU13Sr140D
         YzuA==
X-Gm-Message-State: ANhLgQ1lszm0qzzfi2gbeAIqPxMg5t7Wwoh1AYM1OwIshk37/675py8Y
        8tn/FjUOTZcSwQ6jNxGBxpS/QLVblaaW+hEsYsg7wIwS2tE=
X-Google-Smtp-Source: ADFU+vvcoMD7un+KCqVmle07hc1mv1q1tQjxA0up4lSEOsL0ct4JUAgkVR9V9Q9/bnVXZ+1cKSv9QQX+IuEiRVqZs3c=
X-Received: by 2002:a0c:bc15:: with SMTP id j21mr4998244qvg.228.1585427286264;
 Sat, 28 Mar 2020 13:28:06 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1585323121.git.daniel@iogearbox.net> <555e1c69db7376c0947007b4951c260e1074efc3.1585323121.git.daniel@iogearbox.net>
 <CAEf4BzY5dd-wXbLziCQJOgikY-qvD+GQC=9HHZGCqmM_R-2mJA@mail.gmail.com> <3e519e0e-aa52-67a5-98f6-0e259745e400@iogearbox.net>
In-Reply-To: <3e519e0e-aa52-67a5-98f6-0e259745e400@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 28 Mar 2020 13:27:55 -0700
Message-ID: <CAEf4BzZR_N0yTvgRwFtmvxk-2RLMmmOfe8LK+eeQhJH33m9bLA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/7] bpf: allow to retrieve cgroup v1 classid
 from v2 hooks
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martynas Pumputis <m@lambda.lt>,
        Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 6:56 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 3/28/20 1:41 AM, Andrii Nakryiko wrote:
> > On Fri, Mar 27, 2020 at 9:00 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >>
> >> Today, Kubernetes is still operating on cgroups v1, however, it is
> >> possible to retrieve the task's classid based on 'current' out of
> >> connect(), sendmsg(), recvmsg() and bind-related hooks for orchestrators
> >> which attach to the root cgroup v2 hook in a mixed env like in case
> >> of Cilium, for example, in order to then correlate certain pod traffic
> >> and use it as part of the key for BPF map lookups.
> >
> > Have you tried getting this classid directly from task_struct in your
> > BPF program with vmlinux.h and CO-RE? Seems like it should be pretty
> > straightforward and not requiring a special BPF handler just for that?
>
> To answer both questions (5/7 and this one) in the same mail here: my
> understanding is that this would require to install additional tracing
> programs on these hooks instead of being able to integrate them into [0]
> for usage out of sock_addr and sock progs (similar as they are available
> as well from tc from skb)?

No, not really, assuming bpf_get_current_task() helper is available
for those programs. Something like this should work, can't really
check because I don't know what classid value is supposed to be, but
all the relocations succeed, so at least typing wise it should be
good:

#include "vmlinux.h"
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_core_read.h>

static __always_inline u32 get_cgroup_classid(void)
{
        struct task_struct *task = (void *)bpf_get_current_task();
        struct cgroup_cls_state *state = (void *)BPF_CORE_READ(task,
cgroups, subsys[net_cls_cgrp_id]);

        return BPF_CORE_READ(state, classid);
}

I've cheated with conversion from `struct cgroup_subsys_state *` to
`struct cgroup_cls_state *`, given that they match right now. But it
is possible to have relocatable equivalent of container_of() macro for
CO-RE, I'd be happy to play with that and provide it as part of
bpf_core_read.h, if necessary.

Hope this clarifies what I meant by implementing with CO-RE.


>
> Thanks,
> Daniel
>
>    [0] https://github.com/cilium/cilium/blob/master/bpf/bpf_sock.c
