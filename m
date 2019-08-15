Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E27758F46C
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732313AbfHOTWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:22:49 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37433 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732675AbfHOTWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 15:22:48 -0400
Received: by mail-qt1-f196.google.com with SMTP id y26so3536163qto.4
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 12:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=LlT4pUqJ1pdZQp31Z6TlgIrwFLzT6r/hfcXvC21i00M=;
        b=v3t2zkOZDoOfbaW3AV33GOl6aMHaGfNUUk1WeSNH5QlbZ72fZfbxobmeB7qSEA811S
         jHmiiNGVkYQsTKj5/fGs/rnkTyECZFRh/TEk1nz5tEepEp2tXuu9yk/nD40Wjcwvpvf1
         s0IETaxLoAs89QrXdcnloX2vNCJkTHUrWEQTlqbybOT017Rzyc9CKROA2lxjIIZu03pr
         e8AZo/KNIZlGRbg1LezbQgHyjRjIOH7GjdwwXxXz+c+wrT7C38vrNNABwBfhZ1nMdzqk
         eiFuoTpYd6wEScBQjDqPB0YueRvgVE4vDaKOtWfBognzhYvHCJRWIsu6k8QYDvga9JXQ
         je1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=LlT4pUqJ1pdZQp31Z6TlgIrwFLzT6r/hfcXvC21i00M=;
        b=bJHgzHaaVMhijgNfcvk2XE3K5aimjpkMVncw4ExPyZcb8dM40Me9Iz5hSWJcu/izCQ
         OrYBl2xgWc8XwJCk1ehXdJPv2ejPoFnSgsaioMfObBjNcknvipo7PEtiOBKIpmSibS35
         jPd/OoQnwm5lkFBCbJYDonr08IELFWndollh0lxoK0oxNlojRotiRqEWRWVpLKChlMta
         v0kXowsGcL/dguYMfpjug1Dodx+Zqo2wzfZPGZClFdDPNK9q9rmQNR3JisQf4mHX7bi+
         bOjfGWPj/qYbO7zlJV++/yBKun6hHoZ3+9YeCWJRd4993bw8FxLMU8iHAtaX9VldfHQt
         7/Qw==
X-Gm-Message-State: APjAAAU/M2PYyILGTwYkFR9eIQzUzKL7pDivbUqffVYiIB0uJ7KfO8b9
        6lPJYk2rYDOJlgQX7aMoCozpWw==
X-Google-Smtp-Source: APXvYqzoEaFWpei7IEEEbSmc388lyR9cT7nk5mEzKHJji4TlUy8IYaWEGh7Cy0Kg7ErZT9D3dnr22A==
X-Received: by 2002:ac8:75d9:: with SMTP id z25mr5333522qtq.207.1565896967699;
        Thu, 15 Aug 2019 12:22:47 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t2sm1678382qtq.73.2019.08.15.12.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 12:22:47 -0700 (PDT)
Date:   Thu, 15 Aug 2019 12:22:32 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, William Tu <u9012063@gmail.com>
Subject: Re: [RFC PATCH bpf-next 00/14] xdp_flow: Flow offload to XDP
Message-ID: <20190815122232.4b1fa01c@cakuba.netronome.com>
In-Reply-To: <20190815152100.GN2820@mini-arch>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
        <20190814170715.GJ2820@mini-arch>
        <14c4a876-6f5d-4750-cbe4-19622f64975b@gmail.com>
        <20190815152100.GN2820@mini-arch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Aug 2019 08:21:00 -0700, Stanislav Fomichev wrote:
> On 08/15, Toshiaki Makita wrote:
> > On 2019/08/15 2:07, Stanislav Fomichev wrote:  
> > > On 08/13, Toshiaki Makita wrote:  
> > > > * Implementation
> > > > 
> > > > xdp_flow makes use of UMH to load an eBPF program for XDP, similar to
> > > > bpfilter. The difference is that xdp_flow does not generate the eBPF
> > > > program dynamically but a prebuilt program is embedded in UMH. This is
> > > > mainly because flow insertion is considerably frequent. If we generate
> > > > and load an eBPF program on each insertion of a flow, the latency of the
> > > > first packet of ping in above test will incease, which I want to avoid.  
> > > Can this be instead implemented with a new hook that will be called
> > > for TC events? This hook can write to perf event buffer and control
> > > plane will insert/remove/modify flow tables in the BPF maps (contol
> > > plane will also install xdp program).
> > > 
> > > Why do we need UMH? What am I missing?  
> > 
> > So you suggest doing everything in xdp_flow kmod?  
> You probably don't even need xdp_flow kmod. Add new tc "offload" mode
> (bypass) that dumps every command via netlink (or calls the BPF hook
> where you can dump it into perf event buffer) and then read that info
> from userspace and install xdp programs and modify flow tables.
> I don't think you need any kernel changes besides that stream
> of data from the kernel about qdisc/tc flow creation/removal/etc.

There's a certain allure in bringing the in-kernel BPF translation
infrastructure forward. OTOH from system architecture perspective IMHO
it does seem like a task best handed in user space. bpfilter can replace
iptables completely, here we're looking at an acceleration relatively
loosely coupled with flower.

FWIW Quentin spent some time working on a universal flow rule to BPF
translation library:

https://github.com/Netronome/libkefir

A lot remains to be done there, but flower front end is one of the
targets. A library can be tuned for any application, without a
dependency on flower uAPI.

> But, I haven't looked at the series deeply, so I might be missing
> something :-)

I don't think you are :)
