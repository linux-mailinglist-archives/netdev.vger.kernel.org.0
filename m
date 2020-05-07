Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA851C9E6D
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 00:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgEGWZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 18:25:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31548 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726579AbgEGWZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 18:25:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588890343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y31RC39EIR5bFhiqWVOWKHXJN5kd0IOfEjfi+f9WskY=;
        b=CW4DkGaYJL/PqRofgWPlsNxeMJllpDgviZSVBZXa4N6cX2EWyPgtfhmlqgCA9RiHtm6DSw
        NVwXHcROM3Ma+GEA88FaUV1Xtv7z0ahk14Po7wz5gz7xW6KYq2ltpoiICR9Smw0SDl+NqA
        Ahm3NiwAI68X6axMhj8NZvnVUA3ljVQ=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-pp_CIS3ZNje-1zbkLOBxHA-1; Thu, 07 May 2020 18:25:41 -0400
X-MC-Unique: pp_CIS3ZNje-1zbkLOBxHA-1
Received: by mail-lj1-f198.google.com with SMTP id e2so1383160ljp.11
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 15:25:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Y31RC39EIR5bFhiqWVOWKHXJN5kd0IOfEjfi+f9WskY=;
        b=LhHVohu4Zia6h5YdmvgJ6A2dkXrAH0kYDoMuw1H1SoxMxjFwFvzmBUXGDJtDZB7/m5
         vX1yd4rqF8M6+1oetykSZy6Byc8iE8B+aWfpOiS4IOJs61vBKersRHHKf7ks2m4bBcKZ
         tT0roH/PgWFufa8LuXaZIQLxJ/JsK7zxFkwmIYHSSWJqboU/FojORUNhssbTYmFv4IPn
         KO9IU4qwylFiI6hGdjJyY3pbcYgdBvITUF9hu/39gHZIpj+ADQtsyvmxM6z8gu4ww5/h
         2tLFS0EWI0a8vqeuLsIvLRNClup4ZAHWlxHsHDE1rDgugtzVvswPqXIhXj98jiJf5YsO
         xzMw==
X-Gm-Message-State: AGi0Pua1p0XnQKrWyWqCuzwofEdSDys0DUW6SJhvp1H3P3GAqm9pU6Ne
        I76yHfwrYp+lqjwNJoewGECykK5/HHWUdQ6Q3owFQfcFTHAmREwtSU1jFCaasYhERd8bUn7LPX+
        UCbEZWdpy7bpPAel/
X-Received: by 2002:a2e:7308:: with SMTP id o8mr9759893ljc.16.1588890339426;
        Thu, 07 May 2020 15:25:39 -0700 (PDT)
X-Google-Smtp-Source: APiQypIiITs85tCkxagqkrtudU4EnBUgqkBT6CYtHQWvqlA4zwmZLjXT0IamFJcTlbpf00x54mAeaw==
X-Received: by 2002:a2e:7308:: with SMTP id o8mr9759881ljc.16.1588890339182;
        Thu, 07 May 2020 15:25:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b4sm4639729lfo.33.2020.05.07.15.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 15:25:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A4EF91804E9; Fri,  8 May 2020 00:25:36 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBl?= =?utf-8?B?bA==?= 
        <bjorn.topel@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: XDP bpf_tail_call_redirect(): yea or nay?
In-Reply-To: <5eb44eb03f8e1_22a22b23544285b87a@john-XPS-13-9370.notmuch>
References: <CAJ+HfNidbgwtLinLQohwocUmoYyRcAG454ggGkCbseQPSA1cpw@mail.gmail.com> <877dxnkggf.fsf@toke.dk> <CAJ+HfNhvzZ4JKLRS5=esxCd7o39-OCuDSmdkxCuxR9Y6g5DC0A@mail.gmail.com> <871rnvkdhw.fsf@toke.dk> <5eb44eb03f8e1_22a22b23544285b87a@john-XPS-13-9370.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 08 May 2020 00:25:36 +0200
Message-ID: <87eervidr3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>>=20
>> > On Thu, 7 May 2020 at 15:44, Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>> >>
>> >> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>> >>
>> >> > Before I start hacking on this, I might as well check with the XDP
>> >> > folks if this considered a crappy idea or not. :-)
>> >> >
>> >> > The XDP redirect flow for a packet is typical a dance of
>> >> > bpf_redirect_map() that updates the bpf_redirect_info structure with
>> >> > maps type/items, which is then followed by an xdp_do_redirect(). Th=
at
>> >> > function takes an action based on the bpf_redirect_info content.
>> >> >
>> >> > I'd like to get rid of the xdp_do_redirect() call, and the
>> >> > bpf_redirect_info (per-cpu) lookup. The idea is to introduce a new
>> >> > (oh-no!) XDP action, say, XDP_CONSUMED and a built-in helper with
>> >> > tail-call semantics.
>> >> >
>> >> > Something across the lines of:
>> >> >
>> >> > --8<--
>> >> >
>> >> > struct {
>> >> >         __uint(type, BPF_MAP_TYPE_XSKMAP);
>> >> >         __uint(max_entries, MAX_SOCKS);
>> >> >         __uint(key_size, sizeof(int));
>> >> >         __uint(value_size, sizeof(int));
>> >> > } xsks_map SEC(".maps");
>> >> >
>> >> > SEC("xdp1")
>> >> > int xdp_prog1(struct xdp_md *ctx)
>> >> > {
>> >> >         bpf_tail_call_redirect(ctx, &xsks_map, 0);
>> >> >         // Redirect the packet to an AF_XDP socket at entry 0 of the
>> >> >         // map.
>> >> >         //
>> >> >         // After a successful call, ctx is said to be
>> >> >         // consumed. XDP_CONSUMED will be returned by the program.
>> >> >         // Note that if the call is not successful, the buffer is
>> >> >         // still valid.
>> >> >         //
>> >> >         // XDP_CONSUMED in the driver means that the driver should =
not
>> >> >         // issue an xdp_do_direct() call, but only xdp_flush().
>> >> >         //
>> >> >         // The verifier need to be taught that XDP_CONSUMED can only
>> >> >         // be returned "indirectly", meaning a bpf_tail_call_XXX()
>> >> >         // call. An explicit "return XDP_CONSUMED" should be
>> >> >         // rejected. Can that be implemented?
>> >> >         return XDP_PASS; // or any other valid action.
>> >> > }
>
> I'm wondering if we can teach the verifier to recognize tail calls,
>
> int xdp_prog1(struct xdp_md *ctx)
> {
> 	return xdp_do_redirect(ctx, &xsks_map, 0);
> }
>
> This would be useful for normal calls as well. I guess the question here
> is would a tail call be sufficient for above case or do you need the
> 'return XDP_PASS' at the end? If so maybe we could fold it into the
> helper somehow.
>
> I think it would also address Toke's concerns, no new action so
> bpf developers can just develope like normal but "smart" developers
> will try do calls as tail calls.

This is certainly an interesting idea! Functional languages tend to
auto-optimise tail calls, so detecting them is certainly possible, at
least for the compiler. I suppose this could be a follow-on
optimisation, though, couldn't it? From the PoV of the surrounding code
(in the kernel), it doesn't really matter if the behaviour was signalled
by an explicit flag added in the code, or if this flag was automatically
added by the compiler.

> Not sure it can be done without driver changes though.

Well yeah, that's hard to know in the abstract, obviously. My point is
just that we should look very hard indeed before we decide it can't :)

-Toke

