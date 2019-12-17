Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C319F1226E8
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 09:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfLQIqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 03:46:51 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54383 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726716AbfLQIqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 03:46:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576572409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=03mvPsY7xasEEB7ziDGo/lAPtpDV+P7ujRg7IbN9j1o=;
        b=RHeQX14tf4Kjz3+sdDvk4QzMGsstapo2BzX3ArO2HRLnoq7wVLNB4fDJYZga6m76FxYHaR
        ssGdDOQOhS6IzLPUZullSC927heRupx1wCDBWW3UuQJZGd+KVTtKjrMiktw5/F3BWCo7Jq
        O0K6A4QHZaseRbrkiyy/6HhnfBpgt9o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-tUJVge8qMsuKt0ZXiec_SA-1; Tue, 17 Dec 2019 03:46:48 -0500
X-MC-Unique: tUJVge8qMsuKt0ZXiec_SA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18E381800D42;
        Tue, 17 Dec 2019 08:46:46 +0000 (UTC)
Received: from carbon (ovpn-200-37.brq.redhat.com [10.40.200.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E7FE5D9C9;
        Tue, 17 Dec 2019 08:46:37 +0000 (UTC)
Date:   Tue, 17 Dec 2019 09:46:35 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Luigi Rizzo <rizzo@iet.unipi.it>
Cc:     "Jubran, Samih" <sameehj@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNl?= =?UTF-8?B?bg==?= 
        <toke@redhat.com>, "Kiyanovski, Arthur" <akiyano@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, brouer@redhat.com
Subject: Re: XDP multi-buffer design discussion
Message-ID: <20191217094635.7e4cac1c@carbon>
In-Reply-To: <CA+hQ2+jp471vBvRna7ugdYyFgEB63a9tgCXZCOjEQkT+tZTM1g@mail.gmail.com>
References: <BA8DC06A-C508-402D-8A18-B715FBA674A2@amazon.com>
        <b28504a3-4a55-d302-91fe-63915e4568d3@iogearbox.net>
        <5FA3F980-29E6-4B91-8150-9F28C0E09C45@amazon.com>
        <20190823084704.075aeebd@carbon>
        <67C7F66A-A3F7-408F-9C9E-C53982BCCD40@amazon.com>
        <20191204155509.6b517f75@carbon>
        <ec2fd7f6da44410fbaeb021cf984f2f6@EX13D11EUC003.ant.amazon.com>
        <20191216150728.38c50822@carbon>
        <CA+hQ2+jp471vBvRna7ugdYyFgEB63a9tgCXZCOjEQkT+tZTM1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019 20:15:12 -0800
Luigi Rizzo <rizzo@iet.unipi.it> wrote:

> On Mon, Dec 16, 2019 at 6:07 AM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> >
> > See answers inlined below (please get an email client that support
> > inline replies... to interact with this community)
> >
> > On Sun, 15 Dec 2019 13:57:12 +0000
> > "Jubran, Samih" <sameehj@amazon.com> wrote:  
> ...
> > > * Why should we provide the fragments to the bpf program if the
> > > program doesn't access them? If validating the length is what
> > > matters, we can provide only the full length info to the user with no
> > > issues.  
> >
> > My Proposal#1 (in [base-doc]) is that XDP only get access to the
> > first-buffer.  People are welcome to challenge this choice.
> >
> > There are a several sub-questions and challenges hidden inside this
> > choice.
> >
> > As you hint, the total length... spawns some questions we should answer:
> >
> >  (1) is it relevant to the BPF program to know this, explain the use-case.
> >
> >  (2) if so, how does BPF prog access info (without slowdown baseline)  
> 
> For some use cases, the bpf program could deduct the total length
> looking at the L3 header. 

Yes, that actually good insight.  I guess the BPF-program could also
use this to detect that it doesn't have access to the full-lineary
packet this way(?)

> It won't work for XDP_TX response though.

The XDP_TX case also need to be discussed/handled. IMHO need to support
XDP_TX for multi-buffer frames.  XDP_TX *can* be driver specific, but
most drivers choose to convert xdp_buff to xdp_frame, which makes it
possible to use/share part of the XDP_REDIRECT code from ndo_xdp_xmit.

We also need to handle XDP_REDIRECT, which becomes challenging, as the
ndo_xdp_xmit functions of *all* drivers need to be updated (or
introduce a flag to handle this incrementally).


Sameeh, I know you have read the section[1] on "Storage space for
multi-buffer references/segments", and you updated the doc in git-tree.
So, you should understand that I want to keep this compatible with how
SKB stores segments, which will make XDP_PASS a lot easier/faster.
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

[1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org#storage-space-for-multi-buffer-referencessegments

