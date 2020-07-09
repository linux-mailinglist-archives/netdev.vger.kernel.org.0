Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED3121A7A8
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgGITTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgGITTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:19:52 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4F4C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 12:19:52 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id q3so2990101ilt.8
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 12:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e+IoUrpArH/wKOzyEOXndDlbWL0Itple+7d9IhNHvUc=;
        b=bIl5LL8rQlUOBT+wxeIJzeYCsNd5aWeSpIFALZL01P0N9lIKFid2qQF5NHfZtKN2aa
         hbx5pIKkwbvwHl3eiJ0LgEgMJHL3ZmjASWLhxUV0bV1YouSHZe8ZY0rZ2jntQ1j8JLwz
         jLDUaO/sGMAd6DgKcCWG97apuu/AHYeSVd5UgOHtwCIh0GOw+7a9in0dlpZEdEQjXvs2
         mreKD4nkgfFY3xL1g5qwWEjUMltQVj8PzXpnd3xnAuAw1uuX5WedWhIOcIohG12OoKVV
         8o9CWUHa5uMkzx6Q/0LZUmdg2dF9VBz3nji1MDEw2OyCL4wfJMt6TrZLT59FCwYi0S06
         LQcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e+IoUrpArH/wKOzyEOXndDlbWL0Itple+7d9IhNHvUc=;
        b=qKfHOUjl3Wjr9JdH9gPP3YLxhgJ3thBB5o7+ENHfG8SJnLLlnFp30o14f0ine9PpuO
         LXdRYCZ/muYxHu3ooGb0Cc+WGgAYITCcNGf0OY4FWJMRf+Vf8rHZvusGmcJOAjo4Rl5+
         lczA+/GsV+BkDFBeH0RLGYTriCcGffw/Z4t94NrBFULpCeMPuQ/+4CmkZNjpFA4R4LEG
         M9CJ1eennHNjNCFRbRHZvWP0DnaENcyKGVZmvuqM6V83n/VHXVMY9bcOAOX9HF9cvLeG
         I+UrKWrcSDa0j4sab20LmcVoy5ywDPnZscUjBRrN++VbcM9aDs+KY8TUuF8/kkp/bTe0
         +o7g==
X-Gm-Message-State: AOAM532+IO0UxJAWXDTJ4cAUaowhBSMWgV266sqSNla6s1CtJwyZNNB9
        /J7UHqmEVKz3L1ChGYZYbViMo/SUm68mdcoXR70=
X-Google-Smtp-Source: ABdhPJzZ26UyPi0qPZmgu3v5iADs1mgoSru4mY9WU3kNtbYI5y1zVudVRoEbJDzPDSxL7Vbkd0PfcipDfsQM2q+UXuI=
X-Received: by 2002:a92:b655:: with SMTP id s82mr50112780ili.268.1594322391776;
 Thu, 09 Jul 2020 12:19:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200702185256.17917-1-xiyou.wangcong@gmail.com>
 <20200708153327.GA193647@roeck-us.net> <CAM_iQpWLcbALSZDNkiCm7zKOjMZV8z1XnC5D0vyiYPC6rU3v8A@mail.gmail.com>
 <fe638e54-be0e-d729-a20f-878d017d0da7@roeck-us.net> <CAM_iQpWWXmrNzNZc5-N=bXo2_o58V0=3SeFkPzmJaDL3TVUeEA@mail.gmail.com>
 <38f6a432-fadf-54a6-27d0-39d205fba92e@roeck-us.net> <CAM_iQpVk=54omCG8rrDn7GDg9KxKATT4fufRHbn=BSDKWyTu7w@mail.gmail.com>
 <e0387ee2-56b8-c780-8d33-c477a875e2df@roeck-us.net>
In-Reply-To: <e0387ee2-56b8-c780-8d33-c477a875e2df@roeck-us.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 9 Jul 2020 12:19:40 -0700
Message-ID: <CAM_iQpW6dW0avuhKhifuvHYYzsoC7Na6JA4UPzjnPGqSDgzE3w@mail.gmail.com>
Subject: Re: [Patch net v2] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?Q?Dani=C3=ABl_Sonck?= <dsonck92@gmail.com>,
        Zhang Qiang <qiang.zhang@windriver.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Roman Gushchin <guro@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 12:13 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 7/9/20 11:51 AM, Cong Wang wrote:
> > On Thu, Jul 9, 2020 at 10:10 AM Guenter Roeck <linux@roeck-us.net> wrote:
> >>
> >> Something seems fishy with the use of skcd->val on big endian systems.
> >>
> >> Some debug output:
> >>
> >> [   22.643703] sock: ##### sk_alloc(sk=000000001be28100): Calling cgroup_sk_alloc(000000001be28550)
> >> [   22.643807] cgroup: ##### cgroup_sk_alloc(skcd=000000001be28550): cgroup_sk_alloc_disabled=0, in_interrupt: 0
> >> [   22.643886] cgroup:  #### cgroup_sk_alloc(skcd=000000001be28550): cset->dfl_cgrp=0000000001224040, skcd->val=0x1224040
> >> [   22.643957] cgroup: ###### cgroup_bpf_get(cgrp=0000000001224040)
> >> [   22.646451] sock: ##### sk_prot_free(sk=000000001be28100): Calling cgroup_sk_free(000000001be28550)
> >> [   22.646607] cgroup:  #### sock_cgroup_ptr(skcd=000000001be28550) -> 0000000000014040 [v=14040, skcd->val=14040]
> >> [   22.646632] cgroup: ####### cgroup_sk_free(): skcd=000000001be28550, cgrp=0000000000014040
> >> [   22.646739] cgroup: ####### cgroup_sk_free(): skcd->no_refcnt=0
> >> [   22.646814] cgroup: ####### cgroup_sk_free(): Calling cgroup_bpf_put(cgrp=0000000000014040)
> >> [   22.646886] cgroup: ###### cgroup_bpf_put(cgrp=0000000000014040)
> >
> > Excellent debugging! I thought it was a double put, but it seems to
> > be an endian issue. I didn't realize the bit endian machine actually
> > packs bitfields in a big endian way too...
> >
> > Does the attached patch address this?
> >
>
> Partially. I don't see the crash anymore, but something is still odd - some of my
> tests require a retry with this patch applied, which previously never happened.
> I don't know if this is another problem with this patch, or a different problem.
> Unfortunately, I'll be unable to debug this further until next Tuesday.

Make sure you test the second patch I sent, not the first one. The first one
is still incomplete and ugly too. The two bits must be the last two,
so correcting
the if test is not sufficient, we have to fix the whole bitfield packing.

Thanks!
