Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDB3A4A6EC
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 18:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbfFRQbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 12:31:23 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39192 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbfFRQbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 12:31:22 -0400
Received: by mail-pg1-f193.google.com with SMTP id 196so7983070pgc.6;
        Tue, 18 Jun 2019 09:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WtfrveQ0bUvGWi+775oMSKdo/rRpDj0TtPUP6WR2xho=;
        b=k7URCFdM7+EN3pMgCqRGsJyXpqc9QY4r6Cjvy8BO8QFs9Hs1/movCJlaXfGuHmoTn2
         uZmTYE8kgQ5zAVLZGwWXB+KKRtN3hs2jLnGs8MHPWDpder5gGkHmM01H/yZ1sgJkkC28
         tKRZZcqH1IbWzkP1YJXE0ZY48y9uEhwYU8ljC4G9fz8noeu/97vNR6ffmWBqEt2uGNJJ
         x955YBhxHyjAfWHO4rVplduxhmPqOTftXY3EasG/r/++cJdtda1PRHnsbfN15KOevyLU
         QtdKHKQbQzQ/HUMoqIl85Dit9KnralCJNolQijCJGibejexx7pVk4NUY5t0htvpTggky
         8vPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WtfrveQ0bUvGWi+775oMSKdo/rRpDj0TtPUP6WR2xho=;
        b=pX9OzfAo27vriJwRUQit5JW8VADhAh8GTppiqgK2OimwL3Quj9/oyX5DONVTdlUjvu
         pvzfPLqqrfkBU6k1e2m1z78agSEQIZ/1JXxtxJbR+7T8NbalZ/zAs0qCTlr0xdwwiSzm
         Zd3SdB5+bP/aAR1wuQQ36Apcf/Pxaz9CBGIv2wzGQ8wrsS7d6ogLSEeF2IYZRNeQroBM
         An6lOKeIMikUlGFcZAOH4WkLSikxhkCWIkZ3pharUoJb/b9MUlejaaOlVHV1vjwVS/k6
         IAjkWaRkZ708f1HbZdGzGU51Ggxfr4bxFJLOX2OAamfE2OZvUc242bhruQ/KABlDQw56
         DtOg==
X-Gm-Message-State: APjAAAWV4qB+kwlgQS2OBM2nToO5CRDijkdl2jyfjSoKX59AVjCDlWhL
        3dajlBx1Le+7da5u2ky4Ppw=
X-Google-Smtp-Source: APXvYqzrWHEe11DhVkVNZWOwq/uYPHhgjgA5ECFnpdyqA0m1tOrWAJ3hBKrzk5cDHnLBRi2p2yLu9Q==
X-Received: by 2002:a63:31c7:: with SMTP id x190mr3462393pgx.376.1560875481657;
        Tue, 18 Jun 2019 09:31:21 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:ae73])
        by smtp.gmail.com with ESMTPSA id e22sm15888266pgb.9.2019.06.18.09.31.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 09:31:20 -0700 (PDT)
Date:   Tue, 18 Jun 2019 09:31:19 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v6 1/9] bpf: implement getsockopt and setsockopt
 hooks
Message-ID: <20190618163117.yuw44b24lo6prsrz@ast-mbp.dhcp.thefacebook.com>
References: <20190617180109.34950-1-sdf@google.com>
 <20190617180109.34950-2-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617180109.34950-2-sdf@google.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 11:01:01AM -0700, Stanislav Fomichev wrote:
> Implement new BPF_PROG_TYPE_CGROUP_SOCKOPT program type and
> BPF_CGROUP_{G,S}ETSOCKOPT cgroup hooks.
> 
> BPF_CGROUP_SETSOCKOPT get a read-only view of the setsockopt arguments.
> BPF_CGROUP_GETSOCKOPT can modify the supplied buffer.
> Both of them reuse existing PTR_TO_PACKET{,_END} infrastructure.
> 
> The buffer memory is pre-allocated (because I don't think there is
> a precedent for working with __user memory from bpf). This might be
> slow to do for each {s,g}etsockopt call, that's why I've added
> __cgroup_bpf_prog_array_is_empty that exits early if there is nothing
> attached to a cgroup. Note, however, that there is a race between
> __cgroup_bpf_prog_array_is_empty and BPF_PROG_RUN_ARRAY where cgroup
> program layout might have changed; this should not be a problem
> because in general there is a race between multiple calls to
> {s,g}etsocktop and user adding/removing bpf progs from a cgroup.
> 
> The return code of the BPF program is handled as follows:
> * 0: EPERM
> * 1: success, execute kernel {s,g}etsockopt path after BPF prog exits
> * 2: success, do _not_ execute kernel {s,g}etsockopt path after BPF
>      prog exits
> 
> Note that if 0 or 2 is returned from BPF program, no further BPF program
> in the cgroup hierarchy is executed. This is in contrast with any existing
> per-cgroup BPF attach_type.

This is drastically different from all other cgroup-bpf progs.
I think all programs should be executed regardless of return code.
It seems to me that 1 vs 2 difference can be expressed via bpf program logic
instead of return code.

How about we do what all other cgroup-bpf progs do:
"any no is no. all yes is yes"
Meaning any ret=0 - EPERM back to user.
If all are ret=1 - kernel handles get/set.

I think the desire to differentiate 1 vs 2 came from ordering issue
on getsockopt.
How about for setsockopt all progs run first and then kernel.
For getsockopt kernel runs first and then all progs.
Then progs will have an ability to overwrite anything the kernel returns.

