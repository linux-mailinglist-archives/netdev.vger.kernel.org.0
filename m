Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 432CB1086F6
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 05:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfKYERW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 23:17:22 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:35373 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbfKYERW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 23:17:22 -0500
Received: by mail-io1-f65.google.com with SMTP id x21so14669917ior.2;
        Sun, 24 Nov 2019 20:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=N6bJp5PonV9AvhYp3A8huV47kv/I3nYsue0SrrRDAS0=;
        b=AaK3pZ9Dwof9YezzXNYHj2BlwZaXd1olbKV8COPqVYU8jTBydsjObZWlxx+qAI5XDP
         P0C0MEBvGJrp32YlP6WZgclGPV1fhzTFN0xWe1RqydjgvqhAQbedt+HyQp7bc2haVPB9
         b7RLtXJYYRS1UmLJl1IjVNaZziJ4tVc507uzUe9ilAMiWimJB9K1FkZAOQqK4yD5JErP
         BaJ20kQkiRw6pbBGZL8OXN2W4GRLwr6M7v33wqtU0B501v9TGa5f3rpHvd7q+RFa2G02
         TP4us9weO3rrgEWhFfLfTzTBdNJDUFGXR4DNFrQTcFNsuzKNdRZcvttN+fb/Hh5b7ozX
         WNAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=N6bJp5PonV9AvhYp3A8huV47kv/I3nYsue0SrrRDAS0=;
        b=Uju60rP2/wjsIydUgN3Z2ogpoGMgk41ATvEg79CdD60SP4izUJ6d5fC2xu3wa7CNEa
         2d4t5eGL/xN8gTPPav9XWx2AyArAvsCK1wysDbEwxz3IJciqwXIC2Tf8hvWnG9qmEYwE
         g5nMSoZErOzf+n7xdSv1eeYtfmeV+CAL/xZs8Gjqzw87kVox2DRV9ZGHbLNO2PjVPR08
         0A/ShaPNDldUb32BqQw25ViWucCBcQtxs+QpDl5MBreo3lmR44zSjLsnx1WbIyV6jMQ6
         X5zk8BNsO5p0YRM2ugqne3Qfpfyzw8ADLIDjnea7u1yT6N4p29TUDDWbl+NWLpATNrOU
         1gig==
X-Gm-Message-State: APjAAAWCfZ6Hefea2AuLnCSpIAMU3OUZp+7GwRKSHAgWMhpc9Zf19GfH
        MOJ5g3WVz23UwFA9Hx5Am8MWPFAR
X-Google-Smtp-Source: APXvYqxdQ9Zv4nrgP83NeEPkNn+UXx7tvG5aeFsxsS/ogduHBkNSMW/GZH92Qi+XR6Rflk65Z836zQ==
X-Received: by 2002:a6b:f401:: with SMTP id i1mr16688383iog.241.1574655441435;
        Sun, 24 Nov 2019 20:17:21 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id p8sm1832873ilk.11.2019.11.24.20.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 20:17:20 -0800 (PST)
Date:   Sun, 24 Nov 2019 20:17:12 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5ddb55c87d06c_79e12b0ab99325bc69@john-XPS-13-9370.notmuch>
In-Reply-To: <20191125012440.crbufwpokttx67du@ast-mbp.dhcp.thefacebook.com>
References: <20191123110751.6729-1-jakub@cloudflare.com>
 <20191123110751.6729-6-jakub@cloudflare.com>
 <20191125012440.crbufwpokttx67du@ast-mbp.dhcp.thefacebook.com>
Subject: Re: [PATCH bpf-next 5/8] bpf: Allow selecting reuseport socket from a
 SOCKMAP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Sat, Nov 23, 2019 at 12:07:48PM +0100, Jakub Sitnicki wrote:
> > SOCKMAP now supports storing references to listening sockets. Nothing keeps
> > us from using it as an array of sockets to select from in SK_REUSEPORT
> > programs.
> > 
> > Whitelist the map type with the BPF helper for selecting socket. However,
> > impose a restriction that the selected socket needs to be a listening TCP
> > socket or a bound UDP socket (connected or not).
> > 
> > The only other map type that works with the BPF reuseport helper,
> > REUSEPORT_SOCKARRAY, has a corresponding check in its update operation
> > handler.
> > 
> > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> > ---

[...]

> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 49ded4a7588a..e3fb77353248 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -8723,6 +8723,8 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
> >  	selected_sk = map->ops->map_lookup_elem(map, key);
> >  	if (!selected_sk)
> >  		return -ENOENT;
> > +	if (!sock_flag(selected_sk, SOCK_RCU_FREE))
> > +		return -EINVAL;
> 
> hmm. I wonder whether this breaks existing users...

There is already this check in reuseport_array_update_check()

	/*
	 * sk must be hashed (i.e. listening in the TCP case or binded
	 * in the UDP case) and
	 * it must also be a SO_REUSEPORT sk (i.e. reuse cannot be NULL).
	 *
	 * Also, sk will be used in bpf helper that is protected by
	 * rcu_read_lock().
	 */
	if (!sock_flag(nsk, SOCK_RCU_FREE) || !sk_hashed(nsk) || !nsk_reuse)
		return -EINVAL;

So I believe it should not cause any problems with existing users. Perhaps
we could consolidate the checks a bit or move it into the update paths if we
wanted. I assume Jakub was just ensuring we don't get here with SOCK_RCU_FREE
set from any of the new paths now. I'll let him answer though.

> Martin,
> what do you think?

More eyes the better.

> Could you also take a look at other patches too?
> In particular patch 7?
> 

Agreed would be good to give 7/8 a look I'm not too familiar with the
selftests there.
