Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF0756ADB5
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 19:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388279AbfGPRcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 13:32:47 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38856 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbfGPRcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 13:32:46 -0400
Received: by mail-pl1-f195.google.com with SMTP id az7so10462120plb.5
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 10:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=V0sbNsaidT+gQ2geXGklvqF6ZrsIq76ulbkBrPZwXFg=;
        b=B1uUguXOVC6831nCwG0Nxtlmdq97LDeYm6JLBjVkPxeCVODinIfks5Kh2GoEOA+G2L
         jEctCX9Ownmy/NvBTCJpjHWKAriFTTDoSEIJ2WC3FjILOQQmCrKPwUC72gChRxC1jsh1
         Jiz7CC1ExTTTRiv+fMb3xjtTkTFweu5kEDwGJKMr3DqRVFbdMOchGFULY3mZAO2C+y+E
         04Zs3PQ6PjWF9rp08A3L5PVS9kn00z4buRfiIg5GFHgTCwQ/7+lpc40gimOKTNrHwE/F
         aPF6st/2efoLYrww/75xlUuEOk5c5Sf71NYABoTIbbaFJ2iRWFwoHs/Ng8/8+n1E+hBz
         gq1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=V0sbNsaidT+gQ2geXGklvqF6ZrsIq76ulbkBrPZwXFg=;
        b=hKlx9gHX0CPgXAmc7gY1wIlq4Bc0KtmPABkiAroLfzi9lzFaH+qb0CQ8whPAtm690G
         vSUURWCwwzykO4TB9IIWhKIYgfM7s5gZbRALYvAd19Z89xsD4kGJQE/FwW760Z4phApJ
         cY0yev3pcEKqQHFPvFP564v2nfbuCow2PLELc0VLbBx+ghxRcwTj8Rj+XD/iJJQrn5+9
         Exqnzqo7eKLZMQK8L392tGaOOOa9HV8fe+cVZNoI2bJKM3manco7iRTF7QE1ugVhOcnR
         0WSq9BlhuGopAX/rUCVsGQ0oymGfKQRV0pJrv4zRbvkduS/EYuJ5DhChKN4179VSus8n
         /OFg==
X-Gm-Message-State: APjAAAVkX9oti61VJd38jN6zyXbAHL4mofSc9B/Lq8zMYbQr6whSBg8A
        M9Yq+dV906f3y0n1SelxE4A=
X-Google-Smtp-Source: APXvYqxp8lS5L0lH7SF38h2BXZLuKZ5BeJt1AoDaVw4wlgxXNz3h2plXmxOFJhE/sfF+zm3pfq+Qmw==
X-Received: by 2002:a17:902:b688:: with SMTP id c8mr36804343pls.243.1563298366111;
        Tue, 16 Jul 2019 10:32:46 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id x14sm24528342pfq.158.2019.07.16.10.32.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 10:32:45 -0700 (PDT)
Date:   Tue, 16 Jul 2019 10:32:44 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Martin Lau <kafai@fb.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf] bpf: net: Set sk_bpf_storage back to NULL for cloned
 sk
Message-ID: <20190716173244.GA14834@mini-arch>
References: <20190611214557.2700117-1-kafai@fb.com>
 <20190709163321.GB22061@mini-arch>
 <20190716054624.ea6sbbzn62grde2n@kafai-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716054624.ea6sbbzn62grde2n@kafai-mbp>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/16, Martin Lau wrote:
> On Tue, Jul 09, 2019 at 09:33:21AM -0700, Stanislav Fomichev wrote:
> > On 06/11, Martin KaFai Lau wrote:
> > > The cloned sk should not carry its parent-listener's sk_bpf_storage.
> > > This patch fixes it by setting it back to NULL.
> > Have you thought about some kind of inheritance for listener sockets'
> > storage? Suppose I have a situation where I write something
> > to listener's sk storage (directly or via recently added sockopts hooks)
> > and I want to inherit that state for a freshly established connection.
> > 
> > I was looking into adding possibility to call bpf_get_listener_sock form
> > BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB callback to manually
> > copy some data form the listener socket, but I don't think
> > at this point there is any association between newly established
> > socket and the listener.
> Right, at that point, the child sk has no reference back
> to the listener's sk.
> 
> After a quick look, the listener sk may not always be available
> also (e.g. the backlog processing case).  Hence, adding
> the listener sk to the bpf running ctx is not obvious
> either.
> 
> > 
> > Thoughts/ideas?
> I think cloning the listener's bpf sk storage could be added
> to the existing sk cloning logic.  It seems to be a more straight
> forward approach instead of figuring out the right place to call
> another bpf prog to clone it.
> 
> Quick thoughts out of my head:
> 1. Default should be not-to-clone.  Have a way (a map's flag?) to opt-in.
> 2. The listener's sk storage could be being modified while being cloned.
>    One possibility is to check if the value has bpf_spin_lock.
>    If there is, lock it before cloning.
Thanks for suggestion! An optional inherit/clone flag to
bpf_sk_storage_get seems like a good option. I'll try to play with it,
will probably get back with an rfc at some point.
