Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27E1A17AA94
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 17:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgCEQew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 11:34:52 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40569 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbgCEQev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 11:34:51 -0500
Received: by mail-pl1-f195.google.com with SMTP id y1so2850989plp.7;
        Thu, 05 Mar 2020 08:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=p5aLNwUw+FNGm42RWS6uF6z2Sx/qlH7XeO3ky3AE0eI=;
        b=FAsdcu6SOg4KOpwPmOEqIpeF7EVNcDWFfPSncopT25uF4HfJ9432PaU4j0zejKZtyK
         7p5s9LjNcCjRnXRUWVnN5+17JFtS83U8+zcaYWBmYR/cyf1Dv2anKmAawuJPtnlYQ6Xm
         nCjQ+Vb0KV0OqEVMeNCZbQb3TwyfQln8DkwrmgVWjVUNcmJimGE4+ozNOpjxhOREdprF
         o+e6v8+IKlLBXegaRxhoXKU3RjIiDoFEg0RqSZTGdOuma0yWste5Iv4+h2a9XrWmOMF6
         mDgfUuRZyZel567XLl2Zqpk11PlMf3KVcDZDzPIaWp3bdJrH12ITThM8sKD1siClGEYk
         PcTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=p5aLNwUw+FNGm42RWS6uF6z2Sx/qlH7XeO3ky3AE0eI=;
        b=uAPHAVIx2ScEk0ZQ6Jhjh+94kR3ruYb4mtGG1mOuEbIuGL2CX3iVi+rCM12vNA2U8n
         1vC8tiGI9AOo7aItYA/CHi7ERxrDinQbu3QIhLN6mahdPxkBLl9TFongfLZeXP3Ee4J4
         PCjnVnIEdkmNKn9lnXcKP8GKYv6cmaY08OwtRj9cWgPD/5kMxqS3PAPXhQKcLXk0K8Aq
         sA0kLvAD+sZ7W69jSbu1/n+XvDe+ds06MFr9O4BvS7ubPaLfbthqBGiG6ByrR04Iy2w7
         8kVuCiZL5GKaRILJRNXpygMqVvLyH91YdHD5uxYKUT7D3pve8OJKAz/LUhnx39RcpJeO
         00CQ==
X-Gm-Message-State: ANhLgQ32XYBlDpvKPYFXqacWsobJq3SEyqfdttNxhobrm+q13AZPqP11
        bg3KkTlB2pRbqcGNW8BWd8w=
X-Google-Smtp-Source: ADFU+vsxhAtGdcoxXV3EKeB42lPJrag8o7YBOP+PV6kHin0SPAbUHjdxTCE4bjBBCE+yVRrSus3KFg==
X-Received: by 2002:a17:902:be08:: with SMTP id r8mr8646912pls.321.1583426090172;
        Thu, 05 Mar 2020 08:34:50 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:f0e7])
        by smtp.gmail.com with ESMTPSA id u12sm32804089pgr.3.2020.03.05.08.34.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Mar 2020 08:34:49 -0800 (PST)
Date:   Thu, 5 Mar 2020 08:34:46 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel
 abstraction
Message-ID: <20200305163444.6e3w3u3a5ufphwhp@ast-mbp>
References: <8083c916-ac2c-8ce0-2286-4ea40578c47f@iogearbox.net>
 <CAEf4BzbokCJN33Nw_kg82sO=xppXnKWEncGTWCTB9vGCmLB6pw@mail.gmail.com>
 <87pndt4268.fsf@toke.dk>
 <ab2f98f6-c712-d8a2-1fd3-b39abbaa9f64@iogearbox.net>
 <ccbc1e49-45c1-858b-1ad5-ee503e0497f2@fb.com>
 <87k1413whq.fsf@toke.dk>
 <20200304043643.nqd2kzvabkrzlolh@ast-mbp>
 <87h7z44l3z.fsf@toke.dk>
 <20200304154757.3tydkiteg3vekyth@ast-mbp>
 <874kv33x60.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <874kv33x60.fsf@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 11:37:11AM +0100, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Wed, Mar 04, 2020 at 08:47:44AM +0100, Toke Høiland-Jørgensen wrote:
> >> >
> >> >> And what about the case where the link fd is pinned on a bpffs that is
> >> >> no longer available? I.e., if a netdevice with an XDP program moves
> >> >> namespaces and no longer has access to the original bpffs, that XDP
> >> >> program would essentially become immutable?
> >> >
> >> > 'immutable' will not be possible.
> >> > I'm not clear to me how bpffs is going to disappear. What do you mean
> >> > exactly?
> >> 
> >> # stat /sys/fs/bpf | grep Device
> >> Device: 1fh/31d	Inode: 1013963     Links: 2
> >> # mkdir /sys/fs/bpf/test; ls /sys/fs/bpf
> >> test
> >> # ip netns add test
> >> # ip netns exec test stat /sys/fs/bpf/test
> >> stat: cannot stat '/sys/fs/bpf/test': No such file or directory
> >> # ip netns exec test stat /sys/fs/bpf | grep Device
> >> Device: 3fh/63d	Inode: 12242       Links: 2
> >> 
> >> It's a different bpffs instance inside the netns, so it won't have
> >> access to anything pinned in the outer one...
> >
> > Toke, please get your facts straight.
> >
> >> # stat /sys/fs/bpf | grep Device
> >> Device: 1fh/31d	Inode: 1013963     Links: 2
> >
> > Inode != 1 means that this is not bpffs.
> > I guess this is still sysfs.
> 
> Yes, my bad; I was confused because I was misremembering when 'ip'
> mounts a new bpffs: I thought it was on every ns change, but it's only
> when loading a BPF program, and I was in a hurry so I didn't check
> properly; sorry about that.
> 
> Anyway, what I was trying to express:
> 
> > Still that doesn't mean that pinned link is 'immutable'.
> 
> I don't mean 'immutable' in the sense that it cannot be removed ever.
> Just that we may end up in a situation where an application can see a
> netdev with an XDP program attached, has the right privileges to modify
> it, but can't because it can't find the pinned bpf_link. Right? Or am I
> misunderstanding your proposal?
> 
> Amending my example from before, this could happen by:
> 
> 1. Someone attaches a program to eth0, and pins the bpf_link to
>    /sys/fs/bpf/myprog
> 
> 2. eth0 is moved to a different namespace which mounts a new sysfs at
>    /sys
> 
> 3. Inside that namespace, /sys/fs/bpf/myprog is no longer accessible, so
>    xdp-loader can't get access to the original bpf_link; but the XDP
>    program is still attached to eth0.

The key to decide is whether moving netdev across netns should be allowed
when xdp attached. I think it should be denied. Even when legacy xdp
program is attached, since it will confuse user space managing part.
