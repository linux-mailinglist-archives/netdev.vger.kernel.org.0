Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BE03A5A63
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 22:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbhFMUjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 16:39:03 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:56091 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbhFMUjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 16:39:00 -0400
Received: by mail-pj1-f68.google.com with SMTP id k7so8552292pjf.5;
        Sun, 13 Jun 2021 13:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VC3KerRn6YrYEUjc2O+x3trwv6OLFRvrxXMj5RQd/oM=;
        b=luNJG2o+BZ2953pU0sSbuPhj/FIPDUtkxDuUp+AqiyujVbYiksEvO8RmbqmonCqDnR
         R1xxKKyIy+WxlpdXVL+NBhusrB9BXLy+WGqBFA1Sq2FJ4t6wK80v+lurHFqWj9uTGwrU
         iKk47P84L/a7xw9UtyHI1ODVRH4yxmHfhO0xHZWt/1yZy3TAteBYwxo84FDeTbrcT7eq
         0bYw1ki81DkhaLSBwbffdnNTQ99qDvEm0N+ITpFQG3bVLKH+fNuvL3ai/CDUnSt4wsv5
         RbpEnljCbmHJkVbufRde4I17mI2icMk021LKrrXqeIiCPf+j38bFiuKLApvUs3NDE+PT
         Fx3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VC3KerRn6YrYEUjc2O+x3trwv6OLFRvrxXMj5RQd/oM=;
        b=J/kXYLhF80A9dQNvHKQOmczaOlcakkrWXPZTYrzCAffIIJNkwoVGGhN+b2N+zW9cHM
         yavKyYEpBTicbjHe9YFnF9UZZJfgTO/6ttXi4V9wspnS0XLoxxqNYCC2/6pDQGPj8ibf
         8pJO0+VchoRFUGD76VbjFga+C6dfy7P0Ca5VXAA5sn9t3rTMDuF64RHg7dBk7MtXK6yJ
         qlfdT8JfZxhH01LoWPHYYV9nhe4DWIWMdW8Ho33v4PBNX+haxd7kfr/42WcI7Emfaccq
         Xfhaaa+J3Xj5gwNHmzRA3cTs4aVpYDipGnNN1G7HWq0aptoW/f277kgOm6F7Z1Rvn6Wd
         vEVQ==
X-Gm-Message-State: AOAM531Fbu6ZuqIhMnrOEhGef7gHmPpQQZd0gNM3yiUb/O853fpW9DY5
        wGzSbcPtaLeYAu2cr2hq8zMGUfngu/M=
X-Google-Smtp-Source: ABdhPJyNz/t5z+KeC55aG53ZOSFT0T/S+9TvoUxCszBpSqFlR+XMnn6o4IYVAYv4dnyoaLh19tJQHA==
X-Received: by 2002:a17:90a:c002:: with SMTP id p2mr11392844pjt.132.1623616559056;
        Sun, 13 Jun 2021 13:35:59 -0700 (PDT)
Received: from localhost ([2409:4063:4d05:9fb3:bc63:2dba:460a:d70e])
        by smtp.gmail.com with ESMTPSA id m3sm11027177pfh.174.2021.06.13.13.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 13:35:58 -0700 (PDT)
Date:   Mon, 14 Jun 2021 02:04:38 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Vlad Buslov <vladbu@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
Message-ID: <20210613203438.d376porvf5zycatn@apollo>
References: <20210528195946.2375109-1-memxor@gmail.com>
 <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
 <20210607033724.wn6qn4v42dlm4j4o@apollo>
 <CAM_iQpVCnG8pSci2sMbJ1B5YE-y=reAUp82itgrguecyNBCUVQ@mail.gmail.com>
 <20210607060724.4nidap5eywb23l3d@apollo>
 <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
 <20210608071908.sos275adj3gunewo@apollo>
 <CAM_iQpXFmsWhMA-RO2j5Ph5Ak8yJgUVBppGj2_5NS3BuyjkvzQ@mail.gmail.com>
 <20210613025308.75uia7rnt4ue2k7q@apollo>
 <30ab29b9-c8b0-3b0f-af5f-78421b27b49c@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30ab29b9-c8b0-3b0f-af5f-78421b27b49c@mojatatu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 01:57:16AM IST, Jamal Hadi Salim wrote:
> Hi,
>
> Sorry - but i havent kept up with the discussion so some of this
> and it is possible I may be misunderstanding some things you mention
> in passing below (example that you only support da mode or the classid being
> able to be handled differently etc).
> XDP may not be the best model to follow since some things that exist
> in the tc architecture(example ability to have multi-programs)
> seem to be plumbed in later (mostly because the original design intent
> for XDP was to make it simple and then deployment follow and more
> features get added)
>
> Integrating tc into libbpf is a definete bonus that allows with a
> unified programmatic interface and a singular loading mechanism - but
> it wasnt clear why we loose some features that tc provides; we have
> them today with current tc based loading scheme. I certainly use the
> non-da scheme because over time it became clear that complex
> programs(not necessarily large code size) are a challenge with ebpf
> and using existing tc actions is valuable.
> Also, multiple priorities are  important for the same reason - you
> can work around them in your singular ebpf program but sooner than
> later you will run out "tricks".
>

Right, also I'm just posting so that the use cases I care about are clear, and
why they are not being fulifilled in some other way. How to do it is ofcourse up
to TC and BPF maintainers, which is why I'm still waiting on feedback from you,
Cong and others before posting the next version.

> We do have this monthly tc meetup every second monday of the month.
> Unfortunately it is short notice since the next one is monday 12pm
> eastern time. Maybe you can show up and a high bandwidth discussion
> (aka voice) would help?
>

That would be best, please let me know how to join tomorrow. There are a few
other things I was working on that I also want to discuss with this.

> cheers,
> jamal
>
