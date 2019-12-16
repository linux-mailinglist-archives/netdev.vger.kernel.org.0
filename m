Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 709E5120EAD
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfLPQAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:00:08 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46613 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727289AbfLPQAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:00:07 -0500
Received: by mail-pf1-f194.google.com with SMTP id y14so5795483pfm.13;
        Mon, 16 Dec 2019 08:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ZfFEz4AMfQHwJUdkaHmeGzk9Gy9NzowUfwE8J24sRPQ=;
        b=H97PI86u6Y0OtDBGe0xmyYL5Hu+FB3M2Buqky1AVtaAhZyPzqXhZa7CdmoTo4Sz5jk
         I08nVRtDGbwDV5XyfhY4aSDer9EpeK/7oG28uGrW1Q6VQDWw7ihncMGKihhgzTyF2B9f
         mZiv5Y/x4aaC9VbS8IhELK35SHc3nz6xqI5kJsbN4OaZcSH68P16X+7fPHbLfgdB4STq
         q0yJqv7KdQQnKtQrnQ6lO5nU5P6VIrrm7lD32Mr+H4fLFm/rjRBv4ZAxwkhwJEl9lir2
         FjMP4qyYK6fO25EQIZNl6Q+Sss0VXduUh8jb9wVytsC/rNNu6akFPa0iy9hec/oC2CbX
         0/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ZfFEz4AMfQHwJUdkaHmeGzk9Gy9NzowUfwE8J24sRPQ=;
        b=B06P22d5CH4jSzrpiry7e4E+6jb6fSbFeoI62rFOAzQuerzjs/H6mH2ToOofc4ZOqx
         C5v2uJSOrWpq08Bk/wNXKfwalXcuB0j0z55OoD/ZP70heJGqcqPArMm3jUMzcFUHWdWE
         Ao2j61q8thLOvhPtwlIXjB/7FL6tnFgZcFWnJo3KT1ZHB49Cx7MTNUJIAWXnOFQV6q5i
         M4MsCDbKC2OOnRijtZj3hKDR2seOsV5U4XgxmFOY+60n9YOEO0qtoyGcmXa+uLJBSgnF
         5UBe+O/LoN3FzdP1o/kLfCJKg1zmWLr6pKsM1uUaHPad9IpaxKMI6O28g03PTD3jSpmq
         m3Tw==
X-Gm-Message-State: APjAAAUwVM+B6/kcS06Pnz2MSNxyMU/yPX47QhNqoriH3NZhIMnhYrLc
        j0FJurA8hD0uP1m/+LQMn/4=
X-Google-Smtp-Source: APXvYqw7NuCBWp9N/+LmCzQHoewSI+tutaQf5u43gx9FjcJNDA8CC89gCwOJNQOhmkwnQRU44MoFkw==
X-Received: by 2002:a62:3304:: with SMTP id z4mr15928598pfz.79.1576512006907;
        Mon, 16 Dec 2019 08:00:06 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:48aa])
        by smtp.gmail.com with ESMTPSA id h6sm22208257pgq.61.2019.12.16.08.00.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Dec 2019 08:00:05 -0800 (PST)
Date:   Mon, 16 Dec 2019 08:00:04 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, guro@fb.com, hannes@cmpxchg.org, tj@kernel.org
Subject: Re: [PATCH bpf-next] libbpf: Print hint about ulimit when getting
 permission denied error
Message-ID: <20191216160002.vytwcpremx2e7ae3@ast-mbp.dhcp.thefacebook.com>
References: <20191216124031.371482-1-toke@redhat.com>
 <20191216145230.103c1f46@carbon>
 <20191216155336.GA28925@linux.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191216155336.GA28925@linux.fritz.box>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 04:53:36PM +0100, Daniel Borkmann wrote:
> On Mon, Dec 16, 2019 at 02:52:30PM +0100, Jesper Dangaard Brouer wrote:
> > On Mon, 16 Dec 2019 13:40:31 +0100
> > Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> > 
> > > Probably the single most common error newcomers to XDP are stumped by is
> > > the 'permission denied' error they get when trying to load their program
> > > and 'ulimit -r' is set too low. For examples, see [0], [1].
> > > 
> > > Since the error code is UAPI, we can't change that. Instead, this patch
> > > adds a few heuristics in libbpf and outputs an additional hint if they are
> > > met: If an EPERM is returned on map create or program load, and geteuid()
> > > shows we are root, and the current RLIMIT_MEMLOCK is not infinity, we
> > > output a hint about raising 'ulimit -r' as an additional log line.
> > > 
> > > [0] https://marc.info/?l=xdp-newbies&m=157043612505624&w=2
> > > [1] https://github.com/xdp-project/xdp-tutorial/issues/86
> > > 
> > > Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> > 
> > Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > 
> > This is the top #1 issue users hit again-and-again, too bad we cannot
> > change the return code as it is UAPI now.  Thanks for taking care of
> > this mitigation.
> 
> It's an annoying error that comes up very often, agree, and tooling then
> sets it to a high value / inf anyway as next step if it has the rights
> to do so. Probably time to revisit the idea that if the user has the same
> rights as being able to set setrlimit() anyway, we should just not account
> for it ... incomplete hack:

We cannot drop it quite yet.
There are services that run under root that are relying on this rlimit
to prevent other root services from consuming too much memory.
We need memcg based alternative first before we can remove this limit.
Otherwise users have no way to restrict.

