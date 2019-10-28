Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A617BE7AC8
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 22:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389306AbfJ1VFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 17:05:33 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33377 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728898AbfJ1VFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 17:05:32 -0400
Received: by mail-io1-f67.google.com with SMTP id k20so2295325ior.0;
        Mon, 28 Oct 2019 14:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=A5u4Vx5FPf3awu3eXSUjiXUnQlaqcUpODPhorJw+Kqw=;
        b=de3zmmjh6MYOVQEDKCgf79eSxL7RP3zha+cHdrY/f6fzLPXkhPfeebqnmr9QB0QIY2
         lbek1CBYyVp8jxmfkMqgNpAe3HXMtdw0YU5Wr+g+rmY77lR1jvkE/5dDCpELai2aQNep
         f+qT+i8L6waYH/a1yhAp3Ke1DdP51jHpFAobwC5zToDW3Q0hnPc7aQOSqeRTXKnopeV7
         1g1PmN4ooZiBbWhEcVaz0z/YxZghrXCq+aDTcr0DrebnGEF82jyqAYAqsDF4ksIoHqMT
         5PgPL28ZabAB6CymnARidPjW00rqSJmvN6uP97OClOnApNJZ45UDnSpLRkZg/cWE/VVf
         pAww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=A5u4Vx5FPf3awu3eXSUjiXUnQlaqcUpODPhorJw+Kqw=;
        b=IenLDC6+lQRbw4sGBcfWbmcWqK5PsDIrATy0905QXl5yF9PHXvxebI3w4FnH519du0
         bZklbVpfZPtSdn/7bWDFIXA0NUxem0hyLaxJr1Sud8SpXIamlbKcXIvASrlmEQU4rtKg
         M2JRP1k4zqP77Gfw+cW58UBk69suXqMh/doX6n3B3Zbc8DtEOMXvvtV6fRopk/ZSgxev
         M6C7DoHo0uJDsWDvIcoDCS6fIjazTD+DZ3GlKeiYXi4ANraomMMFTZyZmIdrr5Rbb4mE
         vzjVTrEtE5d+Zpw4ot1AhZBp6E361GFR/Y926Ii3yqLj7/rokV2w/gcmAyKWu2T7KriT
         Xrzg==
X-Gm-Message-State: APjAAAWOorr3RT+oRoWodNlZ14V5Z2jPueFj6pmTiaRj1HYx2U/ece/H
        cSlEfkZCwNIxAjUoq2PSto8=
X-Google-Smtp-Source: APXvYqxfu56V3fnggTTHB6DQuckFcvfzl4HUVNuNNcMdGmMq+SZTHkenvtzJ/p0x/snIfh3XA4UMkQ==
X-Received: by 2002:a6b:770b:: with SMTP id n11mr20670927iom.113.1572296731658;
        Mon, 28 Oct 2019 14:05:31 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q66sm1721240ili.69.2019.10.28.14.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 14:05:31 -0700 (PDT)
Date:   Mon, 28 Oct 2019 14:05:24 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Martin Lau <kafai@fb.com>, Jakub Sitnicki <jakub@cloudflare.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>
Message-ID: <5db758142fac5_6642abc699aa5c4fd@john-XPS-13-9370.notmuch>
In-Reply-To: <20191028204255.jmkraj3xlp346xz4@kafai-mbp.dhcp.thefacebook.com>
References: <20191022113730.29303-1-jakub@cloudflare.com>
 <20191028055247.bh5bctgxfvmr3zjh@kafai-mbp.dhcp.thefacebook.com>
 <875zk9oxo1.fsf@cloudflare.com>
 <20191028204255.jmkraj3xlp346xz4@kafai-mbp.dhcp.thefacebook.com>
Subject: Re: [RFC bpf-next 0/5] Extend SOCKMAP to store listening sockets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Lau wrote:
> On Mon, Oct 28, 2019 at 01:35:26PM +0100, Jakub Sitnicki wrote:
> > On Mon, Oct 28, 2019 at 06:52 AM CET, Martin Lau wrote:
> > > On Tue, Oct 22, 2019 at 01:37:25PM +0200, Jakub Sitnicki wrote:
> > >> This patch set is a follow up on a suggestion from LPC '19 discussions to
> > >> make SOCKMAP (or a new map type derived from it) a generic type for storing
> > >> established as well as listening sockets.
> > >>
> > >> We found ourselves in need of a map type that keeps references to listening
> > >> sockets when working on making the socket lookup programmable, aka BPF
> > >> inet_lookup [1].  Initially we repurposed REUSEPORT_SOCKARRAY but found it
> > >> problematic to extend due to being tightly coupled with reuseport
> > >> logic (see slides [2]).
> > >> So we've turned our attention to SOCKMAP instead.
> > >>
> > >> As it turns out the changes needed to make SOCKMAP suitable for storing
> > >> listening sockets are self-contained and have use outside of programming
> > >> the socket lookup. Hence this patch set.
> > >>
> > >> With these patches SOCKMAP can be used in SK_REUSEPORT BPF programs as a
> > >> drop-in replacement for REUSEPORT_SOCKARRAY for TCP. This can hopefully
> > >> lead to code consolidation between the two map types in the future.
> > > What is the plan for UDP support in sockmap?
> > 
> > It's on our road-map because without SOCKMAP support for UDP we won't be
> > able to move away from TPROXY [1] and custom SO_BINDTOPREFIX extension
> > [2] for steering new UDP flows to receiving sockets. Also we would like
> > to look into using SOCKMAP for connected UDP socket splicing in the
> > future [3].
> > 
> > I was planning to split work as follows:
> > 
> > 1. SOCKMAP support for listening sockets (this series)
> > 2. programmable socket lookup for TCP (cut-down version of [4])
> > 3. SOCKMAP support for UDP (work not started)
> hmm...It is hard to comment how the full UDP sockmap may
> work out without a code attempt because I am not fluent in
> sock_map ;)
> 
> From a quick look, it seems there are quite a few things to do.
> For example, the TCP_SKB_CB(skb) usage and how that may look
> like in UDP.  "struct udp_skb_cb" is 28 bytes while "struct napi_gro_cb"
> seems to be 48 bytes already which may need a closer look.

The extra bits sockmap needs are used for redirecting between
between sockets. These will fit in the udp cb area with some
extra room to spare. If that is paticularly challenging we can
also create a program attach type which would preclude using
those bits in the sk_reuseport bpf program types. We already
have types for rx, tx, nop progs, so one more should be fine.

So at least that paticular concern is not difficult to fix.

> 
> > 4. programmable socket lookup for UDP (rest of [4])
> > 
> > I'm open to suggestions on how to organize it.
> > 
> > >> Having said that, the main intention here is to lay groundwork for using
> > >> SOCKMAP in the next iteration of programmable socket lookup patches.
> > > What may be the minimal to get only lookup work for UDP sockmap?
> > > .close() and .unhash()?
> > 
> > John would know better. I haven't tried doing it yet.
> > 
> > From just reading the code - override the two proto ops you mentioned,
> > close and unhash, and adapt the socket checks in SOCKMAP.
> Do your use cases need bpf prog attached to sock_map?

Perhaps not specifically sock_map but they do need to be consolidated
into a map somewhere IMO this has proven to be the most versatile. We
can add sockets from the various BPF hooks or from user space and have
the ability to use the existing map tools, etc.

> 
> If not, would it be cleaner to delicate another map_type
> for lookup-only use case to have both TCP and UDP support.

But we (Cilium project and above splicing use case is also interested)
will need UDP support so it will be supported regardless of the
SK_REUSEPORT_BPF so I think it makes sense to consolidate all these
use cases on to the existing sockmap.

Also sockmap supports inserting sockets from BPF and from userspace
which actually requires a bit of logic to track state, etc. Its been
in use and been beat on by various automated test tools so I think
at minimum this needs to be reused. Re-implementing this logic seems
a waste of time and it wasn't exactly trivial and took some work.

Being able to insert the sockets from XDP (support coming soon) and
from sock_ops programs turns out to be fairly powerful.

So in short I think it makes most sense to consolidate on sock_map
because

  (a) we need and will add udp support regardless,
  (b) we already handle the tricky parts inerting/removing live sockets
  (c) from this series it looks like its fairly straight forward
  (d) we get lots of shared code

Thanks,
John


> 
> > 
> > -Jakub
> > 
> > [1] https://urldefense.proofpoint.com/v2/url?u=https-3A__blog.cloudflare.com_how-2Dwe-2Dbuilt-2Dspectrum_&d=DwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=VQnoQ7LvghIj0gVEaiQSUw&m=lSo-FsOeNl_8znZZ07H8I6ZYAinPKTR5C3Cn_Ol3QYQ&s=DZgW8-2Xl1P8NU59ji4ieQLzwWpx4t3gGq_tqB0l3Bo&e= 
> > [2] https://lore.kernel.org/netdev/1458699966-3752-1-git-send-email-gilberto.bertin@gmail.com/
> > [3] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.com/
> > [4] https://urldefense.proofpoint.com/v2/url?u=https-3A__blog.cloudflare.com_sockmap-2Dtcp-2Dsplicing-2Dof-2Dthe-2Dfuture_&d=DwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=VQnoQ7LvghIj0gVEaiQSUw&m=lSo-FsOeNl_8znZZ07H8I6ZYAinPKTR5C3Cn_Ol3QYQ&s=NerUqb4j7IsGBTcni6Yxk40wf6kTkckHXn3Nx5i4mCU&e= 


