Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 120A61286BF
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 04:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfLUDVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 22:21:54 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42639 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfLUDVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 22:21:53 -0500
Received: by mail-pg1-f195.google.com with SMTP id s64so5898178pgb.9;
        Fri, 20 Dec 2019 19:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ju5v3AjkEO2xnqkCXCFuiKcXWoSkK3WTFjgA+J3XmS8=;
        b=sWi4v4D1UYUFxivWgas5Ucin1pW1krBSmf4pCdlImtCAXuhgdk/F3/Z8kq+HE7/9ZO
         +c/YGxg15Dj1MUWIg21VWWsmAdvECZ3KmNTyfbj9szvzKV9ZbTvmOGfu5p32nciJlbGT
         Wh/wqee9ttNgDusFEP+VR4yLMlaFarylKDTDgCm79EJFIcBboWnWd6T5E1F+gbJ8RqGU
         ggSpDHDbav2y05tz64hQJka0OHsoMeMDmieSxMPk3k7jIIjDNRVCfIxA6hIw/3ouG0mE
         kH0SBgT7aNpfGE4iKi685LA3rPZd1CaiwRl0LjiTNk2wGV3IvDFyAXB2doaRbLoyvFpF
         VbLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ju5v3AjkEO2xnqkCXCFuiKcXWoSkK3WTFjgA+J3XmS8=;
        b=StEdcpjsjBE/G9A1Q00P8GVz70r6s8VFu94mWH8Bnx+82kHEhddhQns7xVn0L2Jjgp
         0zZG10Pf5GTdwOPYjhC0k1ZJdabQFXGgBemAOaoTy4zuMsqCVt0g/2wQPPeIh+g8hMWm
         hgrPFuvj5mJ/gARHO/EWox7yBKc1kdTKnljq1+yLSp1lj5zmypK/DYksiwoSteQracx8
         pw3HzmcXEOks6/Ndzgr+UKXc55uVbYuYf8G4Vb7Tq22e6LCFDyY+7kIiVOu23o0zxaJw
         L+nyglfIsfSKft2BXhzwWjXNLGhlQJ3LXwmGcPro0PnAp8AUdLfeOyvU2kLSZZtnyW5J
         gErw==
X-Gm-Message-State: APjAAAUgLjnfFQfssBctD1YOQENp++DJfqp3mMq+hFuQcYBDDjtPyjfl
        rVQgERZDemNY72r1CJ5hK9s=
X-Google-Smtp-Source: APXvYqxjs4JVBBjRyFkW24NUPjQHrx9slMBlt7XCD1QYAq/UUCDSK9IUcVx1QvHp3kPy7MEuBC92MQ==
X-Received: by 2002:a65:620d:: with SMTP id d13mr276125pgv.252.1576898512957;
        Fri, 20 Dec 2019 19:21:52 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::a07b])
        by smtp.gmail.com with ESMTPSA id b2sm15851268pjq.3.2019.12.20.19.21.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Dec 2019 19:21:52 -0800 (PST)
Date:   Fri, 20 Dec 2019 19:21:49 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/3] bpftool: add extra CO-RE mode to btf dump
 command
Message-ID: <20191221032147.b7s2zm5pkzatbu57@ast-mbp.dhcp.thefacebook.com>
References: <20191219070659.424273-1-andriin@fb.com>
 <20191219070659.424273-2-andriin@fb.com>
 <20191219170602.4xkljpjowi4i2e3q@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYKf=+WNZv5HMv=W8robWWTab1L5NURAT=N7LQNW4oeGQ@mail.gmail.com>
 <20191219220402.cdmxkkz3nmwmk6rc@ast-mbp.dhcp.thefacebook.com>
 <CAEf4Bzayg2UZi1H1NZaFgAUabtS5a=-yCE7NsUmtaO7kS5CJmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzayg2UZi1H1NZaFgAUabtS5a=-yCE7NsUmtaO7kS5CJmw@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 09:40:31AM -0800, Andrii Nakryiko wrote:
> 
> This one is a small line-number-wise. But the big difference between
> `format c` and `format core` is that the latter assumes we are dumping
> *vmlinux's BTF* for use with *BPF CO-RE from BPF side*. `format c`
> doesn't make any assumptions and faithfully dumps whatever BTF
> information is provided, which can be some other BPF program, or just
> any userspace program, on which pahole -J was executed.

When 'format c' was introduced it was specifically targeting CO-RE framework.
It is useful with BPF_CORE_READ macro and with builtin_preserve_access_index.
Then we realized that both macro and builtin(({ ... })) are quite cumbersome to
use and came with new clang attribute((preserve_access_index)) which makes
programs read like normal C without any extra gotchas. Obviously it's nice if
vmlinux.h already contains this attribute. Hence the need to either add extra
flag to bpftool to emit this attribute or just emit it by default. So
introducing new 'format core' (which is 99% the same as 'format c') and
deprecating 'format c' to 'this is just .h dump of BTF' when it was around for
few month only is absolutely no go. You need to find a way to extend 'format c'
without breaking existing users. Yes. Likely there are no such users, but that
doesn't matter. Once new api is introduced we have to stick to it. 'format c'
is such api.
