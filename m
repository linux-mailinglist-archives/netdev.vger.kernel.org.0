Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B769A907EF
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 20:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbfHPSwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 14:52:42 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36038 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfHPSwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 14:52:42 -0400
Received: by mail-qt1-f194.google.com with SMTP id z4so7192388qtc.3
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 11:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Ka5b9O0v2h8EPGcPlYICwMwfBEn+9/M69P0uVVaDSv8=;
        b=gmLs/gg/DLel8Bu9H7Yty3eGVJRQ6i99RavU9NMCDZFhP9bTMB8kAxLHdlKfngUDZ4
         yM2ON5usXPTT+rPJ654L1FTqLNZ5RTorIRBgKujqZmdJBL0q3CzRrPdq1fSecetEmip6
         dOdFkGQVSxzUG0dCHw7N7pgqE5FfxtZmvu2xNQf4GA/6Q+nqF7mdqEp69qXDne4x9b1c
         eMeNT6YpvtQeuedwCcRjRTaHNNNfL9PHw0j2ZmqjBexQ8LrnnV1joWT1fUjjSdCzUeke
         9Wya0xdvduM9z/BjuuCPlBYDeC+5uDOcfxjNiQxKLcm/cqBVvSTIhcYJJqZkBI5J2w80
         Imrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Ka5b9O0v2h8EPGcPlYICwMwfBEn+9/M69P0uVVaDSv8=;
        b=nyfMsuEm8gKeOMfUFMQ+wrtjiehur9FQh8+KR7tqNKOvD98IZPI66mjnIfN7OABUi2
         P+6zKiVE7jM6if/kpd5TxPCqcqRxPRzRPAvXnxWIChjeRLGF9Qwj7Skd5Craw/8mBP9r
         bAorZ4t9VCGWeAxNEXCXaGcyKwky3uKGyAYcXTiE1g9AhT489XJOg6WLTPV2nU4Diskc
         Z0mazaJ83YykTi51qaPi6jYQapaRYTVNhvAZFUb/pksKHQFTD/N0vbGbNxLBlbsyg5+y
         JuruWHB24cKAAhv1HLA4gIfKCV9KW1imgsucXjH4JH6htTK7epvd8QfxQ1txhVO93egT
         sdOA==
X-Gm-Message-State: APjAAAWqZ0Dg4RaHOxtceDW9rz9HuZvNDECM3vJCDGAxsNi0p/m/G/B2
        Kd1xwbOwjqGVEqfk9RjivdSWhw==
X-Google-Smtp-Source: APXvYqxZUCzBEXXtP6MprT+m/pI74yj0Arh9tpzoJWrttcANn88neTR/HmiwhuViRjjaTqxX7SkNIw==
X-Received: by 2002:ac8:2642:: with SMTP id v2mr9573892qtv.333.1565981561193;
        Fri, 16 Aug 2019 11:52:41 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j6sm3289962qkd.26.2019.08.16.11.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 11:52:41 -0700 (PDT)
Date:   Fri, 16 Aug 2019 11:52:24 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
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
Message-ID: <20190816115224.6aafd4ee@cakuba.netronome.com>
In-Reply-To: <da840b14-ab5b-91f1-df2f-6bdd0ed41173@gmail.com>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
        <20190814170715.GJ2820@mini-arch>
        <14c4a876-6f5d-4750-cbe4-19622f64975b@gmail.com>
        <20190815152100.GN2820@mini-arch>
        <20190815122232.4b1fa01c@cakuba.netronome.com>
        <da840b14-ab5b-91f1-df2f-6bdd0ed41173@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Aug 2019 10:28:10 +0900, Toshiaki Makita wrote:
> On 2019/08/16 4:22, Jakub Kicinski wrote:
> > There's a certain allure in bringing the in-kernel BPF translation
> > infrastructure forward. OTOH from system architecture perspective IMHO
> > it does seem like a task best handed in user space. bpfilter can replace
> > iptables completely, here we're looking at an acceleration relatively
> > loosely coupled with flower.  
> 
> I don't think it's loosely coupled. Emulating TC behavior in userspace
> is not so easy.
> 
> Think about recent multi-mask support in flower. Previously userspace could
> assume there is one mask and hash table for each preference in TC. After the
> change TC accepts different masks with the same pref. Such a change tends to
> break userspace emulation. It may ignore masks passed from flow insertion
> and use the mask remembered when the first flow of the pref is inserted. It
> may override the mask of all existing flows with the pref. It may fail to
> insert such flows. Any of them would result in unexpected wrong datapath
> handling which is critical.
> I think such an emulation layer needs to be updated in sync with TC.

Oh, so you're saying that if xdp_flow is merged all patches to
cls_flower and netfilter which affect flow offload will be required 
to update xdp_flow as well?

That's a question of policy. Technically the implementation in user
space is equivalent.

The advantage of user space implementation is that you can add more
to it and explore use cases which do not fit in the flow offload API,
but are trivial for BPF. Not to mention the obvious advantage of
decoupling the upgrade path.


Personally I'm not happy with the way this patch set messes with the
flow infrastructure. You should use the indirect callback
infrastructure instead, and that way you can build the whole thing
touching none of the flow offload core.
