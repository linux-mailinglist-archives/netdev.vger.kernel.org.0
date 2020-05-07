Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DCA1C9095
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgEGOsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:48:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51532 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726069AbgEGOsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:48:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588862899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oiC38W377BJ3/IgJ1e9+tb4MGos7IPwQLTiwdsd9aq8=;
        b=aAKgecKIvukXGYJE92pWt875kUpPRhRw83N1Pb6bCo+TxFvESh7rgEg8gt1sUGs5A+ULTd
        DHGEPttPzbY0jjTrz1OaMbgHLpN8sSWH19k7+XJ2Mce52i772FL9tdXtJTZoRRu5SouvSn
        ENv/rfgNps1Buv+aL45JW739OtcY+E8=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-KBp1Yj6yOqeuuPQuoWGjsw-1; Thu, 07 May 2020 10:48:15 -0400
X-MC-Unique: KBp1Yj6yOqeuuPQuoWGjsw-1
Received: by mail-lj1-f197.google.com with SMTP id c20so1020776lji.10
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 07:48:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=oiC38W377BJ3/IgJ1e9+tb4MGos7IPwQLTiwdsd9aq8=;
        b=QcCisl1WiW7dV2A4jli+udJnc0dQItYipKOL2pTvzBFpLJJ+QoBc1yKkP9xqnGaF2O
         tLxQ3SYxsWZmy2DQxMFVbCfW5H/uAqlKQh18lvQtWzCna4aigS56t7IPEt5SF8Y1xTGd
         1yaQV6l2VQLYLDYDU7Ho1Fk97hVXaO/QBceR1dfXrRqxyfkrn2V8wxBNXNDL6a+BOU3A
         516N2T2cpjXsGd9gBZc/Xi1pr2pASQlI6KwKNR+eaggPiZ5Vo6nxcbQhquJQwB71DJ1f
         QHLCm6lso7FCfbzMFMT6oLUay/ywT1Btd3Owx7LZEE6SM98hYOBxJoIh7VnbS+j4cQe9
         0h3g==
X-Gm-Message-State: AGi0PualKTSlvm913pN0lVTonHaPC3gQcSfM70BFToYRcz0ilUi3WNjT
        xSTyyTv2wOxYHmLFHYO6in15423G2Ql1fw6BkM13+P8QOagcUnwLtrjJLCAyyrn2xNU5O3sQymF
        HSUSiprzIPy8+J0Qo
X-Received: by 2002:a05:6512:10cd:: with SMTP id k13mr9197821lfg.173.1588862893707;
        Thu, 07 May 2020 07:48:13 -0700 (PDT)
X-Google-Smtp-Source: APiQypLDfCPyr/YBVc5U9U7yRTn2pKGYi0MG1x5YSQ0mpmOQPZpc1L8JhT8HdncOqH2gdRzOdsG45w==
X-Received: by 2002:a05:6512:10cd:: with SMTP id k13mr9197807lfg.173.1588862893416;
        Thu, 07 May 2020 07:48:13 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id p8sm3411440ljn.93.2020.05.07.07.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 07:48:12 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EBB711804E9; Thu,  7 May 2020 16:48:11 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: XDP bpf_tail_call_redirect(): yea or nay?
In-Reply-To: <CAJ+HfNhvzZ4JKLRS5=esxCd7o39-OCuDSmdkxCuxR9Y6g5DC0A@mail.gmail.com>
References: <CAJ+HfNidbgwtLinLQohwocUmoYyRcAG454ggGkCbseQPSA1cpw@mail.gmail.com> <877dxnkggf.fsf@toke.dk> <CAJ+HfNhvzZ4JKLRS5=esxCd7o39-OCuDSmdkxCuxR9Y6g5DC0A@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 07 May 2020 16:48:11 +0200
Message-ID: <871rnvkdhw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> On Thu, 7 May 2020 at 15:44, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>>
>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>>
>> > Before I start hacking on this, I might as well check with the XDP
>> > folks if this considered a crappy idea or not. :-)
>> >
>> > The XDP redirect flow for a packet is typical a dance of
>> > bpf_redirect_map() that updates the bpf_redirect_info structure with
>> > maps type/items, which is then followed by an xdp_do_redirect(). That
>> > function takes an action based on the bpf_redirect_info content.
>> >
>> > I'd like to get rid of the xdp_do_redirect() call, and the
>> > bpf_redirect_info (per-cpu) lookup. The idea is to introduce a new
>> > (oh-no!) XDP action, say, XDP_CONSUMED and a built-in helper with
>> > tail-call semantics.
>> >
>> > Something across the lines of:
>> >
>> > --8<--
>> >
>> > struct {
>> >         __uint(type, BPF_MAP_TYPE_XSKMAP);
>> >         __uint(max_entries, MAX_SOCKS);
>> >         __uint(key_size, sizeof(int));
>> >         __uint(value_size, sizeof(int));
>> > } xsks_map SEC(".maps");
>> >
>> > SEC("xdp1")
>> > int xdp_prog1(struct xdp_md *ctx)
>> > {
>> >         bpf_tail_call_redirect(ctx, &xsks_map, 0);
>> >         // Redirect the packet to an AF_XDP socket at entry 0 of the
>> >         // map.
>> >         //
>> >         // After a successful call, ctx is said to be
>> >         // consumed. XDP_CONSUMED will be returned by the program.
>> >         // Note that if the call is not successful, the buffer is
>> >         // still valid.
>> >         //
>> >         // XDP_CONSUMED in the driver means that the driver should not
>> >         // issue an xdp_do_direct() call, but only xdp_flush().
>> >         //
>> >         // The verifier need to be taught that XDP_CONSUMED can only
>> >         // be returned "indirectly", meaning a bpf_tail_call_XXX()
>> >         // call. An explicit "return XDP_CONSUMED" should be
>> >         // rejected. Can that be implemented?
>> >         return XDP_PASS; // or any other valid action.
>> > }
>> >
>> > -->8--
>> >
>> > The bpf_tail_call_redirect() would work with all redirectable maps.
>> >
>> > Thoughts? Tomatoes? Pitchforks?
>>
>> The above answers the 'what'. Might be easier to evaluate if you also
>> included the 'why'? :)
>>
>
> Ah! Sorry! Performance, performance, performance. Getting rid of a
> bunch of calls/instructions per packet, which helps my (AF_XDP) case.
> This would be faster than the regular REDIRECT path. Today, in
> bpf_redirect_map(), instead of actually performing the action, we
> populate the bpf_redirect_info structure, just to look up the action
> again in xdp_do_redirect().
>
> I'm pretty certain this would be a gain for AF_XDP (quite easy to do a
> quick hack, and measure). It would also shave off the same amount of
> instructions for "vanilla" XDP_REDIRECT cases. The bigger issue; Is
> this new semantic something people would be comfortable being added to
> XDP.

Well, my immediate thought would be that the added complexity would not
be worth it, because:

- A new action would mean either you'd need to patch all drivers or
  (more likely) we'd end up with yet another difference between drivers'
  XDP support.

- BPF developers would suddenly have to choose - do this new faster
  thing, or be compatible? And manage the choice based on drivers they
  expect to run on, etc. This was already confusing with
  bpf_redirect()/bpf_redirect_map(), and this would introduce a third
  option!

So in light of this, I'd say the performance benefit would have to be
quite substantial for this to be worth it. Which we won't know until you
try it, I guess :)

Thinking of alternatives - couldn't you shoe-horn this into the existing
helper and return code? Say, introduce an IMMEDIATE_RETURN flag to the
existing helpers, which would change the behaviour to the tail call
semantics. When used, xdp_do_redirect() would then return immediately
(or you could even turn xdp_do_redirect() into an inlined wrapper that
checks the flag before issuing a CALL to the existing function). Any
reason why that wouldn't work?

-Toke

