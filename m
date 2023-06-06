Return-Path: <netdev+bounces-8247-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A1D1723451
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 03:05:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78D501C20DCB
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 01:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15B61375;
	Tue,  6 Jun 2023 01:05:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026797F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 01:05:34 +0000 (UTC)
X-Greylist: delayed 1126 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 05 Jun 2023 18:05:32 PDT
Received: from bongo.yew.relay.mailchannels.net (bongo.yew.relay.mailchannels.net [23.83.220.21])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9C8106
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 18:05:31 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 07D33541748
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:46:42 +0000 (UTC)
Received: from pdx1-sub0-mail-a232.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 931E3541171
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:46:41 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1686012401; a=rsa-sha256;
	cv=none;
	b=kfnxFT+SicQc8Z52f26H64ZYoJfWVMHFeLAUR5a51283Lq5oUXvUyQ14ZeFs5mU+5Ny1Lg
	yih0OZjGi+ByndZbld69/dXodBde6WjNH68sc5bHu6PceA8vdya6J4bm5TP3LmofZHnwpC
	d1Gxv1XBpjLhtLetYbGsrc4vTrGPrKd0lfhNy9QOjIEbBFH8V48pUysEkuYnFAFyZlDu57
	/GeHMh/5FClYdbWdC2XvZNkKmZtc6xQJl2ZBhDLPpUYc8kPDpdvw8IMvEFwigqtAdrYd3R
	QuYLR5dok31eTkUIWmk9eKPec7Z8g89vHqYRJoyWLcHGRmwUqKSGdfH6Kz7RnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1686012401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=30Pm4xz1UlaCRE7iqpDJat0fxdm1zNEZBrIPg1VFjPA=;
	b=HCXg9gw6tP83DcvIG7CHlaEBtzIru9t+UAnGUV4/vus7Bb3G4CneIZtHD2Uu7/7YO7armk
	tqQ+ZtnPARZYdZyP9XdT69+k3S6m7l9DdLLboUmytVkvYT+jFvQAVEr9hWQU1s8gQXi9xs
	R978uDRlr37+X/60tHYhyhr6mhBZo78SMh3Xbnk0uH+yKESuaofXOFzAAL6J6a8E3T+nNz
	aO5c+9XMy2d1QRNgBJh+BzorEJ7gSF0jza49KA1V18WDInn/JY/kmBLPsz+7nd0p+gmJaZ
	uM7QHrfJJ9RS7lamxLiplymG69J+MABLx/c95KTYT2pLneiIJTDEv3mGKZOl8w==
ARC-Authentication-Results: i=1;
	rspamd-56648fb6f9-h5qjr;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Good
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Tasty-Hook: 7fc30c3741e821e6_1686012401827_583341205
X-MC-Loop-Signature: 1686012401827:3951812792
X-MC-Ingress-Time: 1686012401827
Received: from pdx1-sub0-mail-a232.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.127.59.22 (trex/6.8.1);
	Tue, 06 Jun 2023 00:46:41 +0000
Received: from kmjvbox (c-73-93-64-36.hsd1.ca.comcast.net [73.93.64.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a232.dreamhost.com (Postfix) with ESMTPSA id 4QZsHN5cvFzvV
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 17:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1686012400;
	bh=30Pm4xz1UlaCRE7iqpDJat0fxdm1zNEZBrIPg1VFjPA=;
	h=Date:From:To:Cc:Subject:Content-Type:Content-Transfer-Encoding;
	b=r3U3/n3Udn+774UyOUt2mmHnvq5ReXmfwZD6PALez0allvnBn1UEjLG2p0YjqHoj8
	 SZ0UaWb6wehWoeW7IXFQRhlHGXkWnWyNc2DFcFnE+khJ5Jh3T44nvEvt/i4zJSVyDa
	 oeoxwkvByhPj7S5lRAypnCykFibWxPCz5hGWNCzU=
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e0062
	by kmjvbox (DragonFly Mail Agent v0.12);
	Mon, 05 Jun 2023 17:41:39 -0700
Date: Mon, 5 Jun 2023 17:41:39 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Krister Johansen <kjlx@templeofstupid.com>, bpf <bpf@vger.kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	clang-built-linux <llvm@lists.linux.dev>,
	stable <stable@vger.kernel.org>
Subject: Re: [PATCH bpf] bpf: search_bpf_extables should search subprogram
 extables
Message-ID: <20230606004139.GE1977@templeofstupid.com>
References: <20230605164955.GA1977@templeofstupid.com>
 <CAADnVQK7PQxj5jjfUu9sO524yLMPqE6vmzcipno1WYoeu0q-Gw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQK7PQxj5jjfUu9sO524yLMPqE6vmzcipno1WYoeu0q-Gw@mail.gmail.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 04:30:29PM -0700, Alexei Starovoitov wrote:
> On Mon, Jun 5, 2023 at 9:50 AM Krister Johansen <kjlx@templeofstupid.com> wrote:
> > +                       if (!aux->func[i]->aux->num_exentries ||
> > +                           aux->func[i]->aux->extable == NULL)
> > +                               continue;
> > +                       e = search_extable(aux->func[i]->aux->extable,
> > +                           aux->func[i]->aux->num_exentries, addr);
> > +               }
> > +       }
> 
> something odd here.
> We do bpf_prog_kallsyms_add(func[i]); for each subprog.
> So bpf_prog_ksym_find() in search_bpf_extables()
> should be finding ksym and extable of the subprog
> and not the main prog.
> The bug is probably elsewhere.

I have a kdump (or more) of this bug so if there's additional state
you'd like me to share, let me know.  With your comments in mind, I took
another look at the ksym fields in the aux structs.  I have this in the
main program:

  ksym = {
    start = 18446744072638420852,
    end = 18446744072638423040,
    name = <...>
    lnode = {
      next = 0xffff88d9c1065168,
      prev = 0xffff88da91609168
    },
    tnode = {
      node = {{
          __rb_parent_color = 18446613068361611640,
          rb_right = 0xffff88da91609178,
          rb_left = 0xffff88d9f0c5a578
        }, {
          __rb_parent_color = 18446613068361611664,
          rb_right = 0xffff88da91609190,
          rb_left = 0xffff88d9f0c5a590
        }}
    },
    prog = true
  },

and this in the func[0] subprogram:

  ksym = {
    start = 18446744072638420852,
    end = 18446744072638423040,
    name = <...>
    lnode = {
      next = 0xffff88da91609168,
      prev = 0xffffffff981f8990 <bpf_kallsyms>
    },
    tnode = {
      node = {{
          __rb_parent_color = 18446613068361606520,
          rb_right = 0x0,
          rb_left = 0x0
        }, {
          __rb_parent_color = 18446613068361606544,
          rb_right = 0x0,
          rb_left = 0x0
        }}
    },
    prog = true
  },

That sure looks like func[0] is a leaf in the rbtree and the main
program is an intermediate node with leaves.  If that's the case, then
bpf_prog_ksym_find may have found the main program instead of the
subprogram.  In that case, do you think it's better to skip the main
program's call to bpf_prog_ksym_set_addr() if it has subprograms instead
of searching for subprograms if the main program is found?

-K

