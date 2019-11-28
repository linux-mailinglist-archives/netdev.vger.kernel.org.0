Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 948C810C2DD
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 04:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfK1DdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 22:33:03 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:44967 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727113AbfK1DdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 22:33:02 -0500
Received: by mail-pj1-f65.google.com with SMTP id w8so11197902pjh.11;
        Wed, 27 Nov 2019 19:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VZufOeI6EHnATdk+crGenMQXH1a1O/8tB/n0iGNLkV8=;
        b=dKQtPlN91MNy87OySN9B18nRHCSvt9bTQlxOGxhPhkhLnRVVYy630ue5Ia/NYZnKTS
         BM3QmJpHmWoi5B+VzPN8eAGyQBqBURKxfWpCMq4dVNHg2zDFOtMbh6hnIyQY/72vI4OB
         Vz8OM7iimW4JCTrBO8pcHIqPm/IAukMHlWDJE5P2sp+jIGvVXAc2t1ewEPfyjxuQTOnj
         inGA002wU5as6GPAhKBzVr/pMjMwPEmA6Hv3XKNCMoEGLAkG4lpZ9c1R02aDQy4rgibK
         h+0cijupCMC+UVfsbSL86wxmKi86P5WMLRISxyLfYE9x2fvwmYpBZQ6GbUhBxgG6vLR+
         0Tlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VZufOeI6EHnATdk+crGenMQXH1a1O/8tB/n0iGNLkV8=;
        b=ZR00iOB34vkuM3Z2D9bwTgtUqUTSpZEqgteisYYogzR/l2ESbfkceoKuwftAlbeTvN
         0TE7L2x2LRe1mqSZ1vVPkxNeWIkXjlp0/bAH0m/YhEEjTSQMu3kB7UgJZhMJK5+9qa20
         V7IAfFroaE8na6yVZdVEIYFbbfXjSH64KRcn4+hvPUwYKsMtEDkWkH/+IdCobwZDLZIN
         wPjrbYmDmwssWpGz5JeSooT4rEgsxAHP9pkspwvQ0+aLavXcvXsR3gJXVJgIqv0Iv/Rz
         uM1uo4VloifDHdmyCdrq+/5bWtxmup04G0do72xWm7UW6j0i+00fs/Ji0i44dwiz5xKP
         pZ+A==
X-Gm-Message-State: APjAAAVRuEKL1fXhG05Dxe0E9gGXy9qpkw2dZfmsIDNo7gqvm8CjeciC
        4Tqed1RFPBwYKNtBaiPAm9I=
X-Google-Smtp-Source: APXvYqxribCE1N5toVJebzazASUvHWYS7YA66p7nDo+H1p+nZMKgBJT3LsQrl8bmwxM+QDhzryBd5Q==
X-Received: by 2002:a17:902:8a8e:: with SMTP id p14mr7493221plo.72.1574911979995;
        Wed, 27 Nov 2019 19:32:59 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::faaf])
        by smtp.gmail.com with ESMTPSA id t8sm2932493pjg.17.2019.11.27.19.32.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Nov 2019 19:32:59 -0800 (PST)
Date:   Wed, 27 Nov 2019 19:32:57 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [RFC net-next 00/18] virtio_net XDP offload
Message-ID: <20191128033255.r66d4zedmhudeaa6@ast-mbp.dhcp.thefacebook.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
 <20191126123514.3bdf6d6f@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191126123514.3bdf6d6f@cakuba.netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 12:35:14PM -0800, Jakub Kicinski wrote:
> 
> I'd appreciate if others could chime in.

The performance improvements are quite appealing.
In general offloading from higher layers into lower layers is necessary long term.

But the approach taken by patches 15 and 17 is a dead end. I don't see how it
can ever catch up with the pace of bpf development. As presented this approach
works for the most basic programs and simple maps. No line info, no BTF, no
debuggability. There are no tail_calls either. I don't think I've seen a single
production XDP program that doesn't use tail calls. Static and dynamic linking
is coming. Wraping one bpf feature at a time with virtio api is never going to
be complete. How FDs are going to be passed back? OBJ_GET_INFO_BY_FD ?
OBJ_PIN/GET ? Where bpffs is going to live ? Any realistic XDP application will
be using a lot more than single self contained XDP prog with hash and array
maps. It feels that the whole sys_bpf needs to be forwarded as a whole from
guest into host. In case of true hw offload the host is managing HW. So it
doesn't forward syscalls into the driver. The offload from guest into host is
different. BPF can be seen as a resource that host provides and guest kernel
plus qemu would be forwarding requests between guest user space and host
kernel. Like sys_bpf(BPF_MAP_CREATE) can passthrough into the host directly.
The FD that hosts sees would need a corresponding mirror FD in the guest. There
are still questions about bpffs paths, but the main issue of
one-feature-at-a-time will be addressed in such approach. There could be other
solutions, of course.

