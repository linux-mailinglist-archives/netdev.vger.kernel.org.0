Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFBD3A1ADC
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 18:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbhFIQ2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 12:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbhFIQ2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 12:28:13 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFED1C061574;
        Wed,  9 Jun 2021 09:26:08 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id s19so13646511ioc.3;
        Wed, 09 Jun 2021 09:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=mHOuSpV1DJgmCAKmIUcUMMVFXp6nbRlAinOju3HfWJw=;
        b=N0GmsESgrWWDmFyFzj0KJA3unP9WJroZHiYj0HOaw29KSDb62MEnsgAglI9Y7Q2//9
         SfBuFOkUU8v8wjAZzWtV/zV7mDeZzzC2WovaYrHbHr4jpVWZaK8CwQdWa5y6wSMuoJPE
         pFEXpQacrZcatVzd0KYOpxOW69j9WEiCj/0VTw6YLFcZucslzGBvCRcgh+x9wiy4S9mz
         acUvRk+xmzL4V7Oc7BOQMrF1ylOMSTR5YMdQDf/7stufz5xRWmAy7sFBaA5Tx0gfx6Lf
         g4OI/XEp7hsL2A8gsmirpbCvB4wJKl3kX4q9erqb7x1ztMBjqq/UX4Rt6qCa1u9IfCZB
         PEXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=mHOuSpV1DJgmCAKmIUcUMMVFXp6nbRlAinOju3HfWJw=;
        b=CozPmOn7nWT2jCmcW+yOfcPNgmIMv7gDmbjibdYMe/vLj8JulXOTPAjRjdQeETr1gO
         JBEKAB7OnDdpeoPH2FnS8M7Jpy2q0fPzzexAKwguHmBtizhd9NP0Iu7vZ2OrEowSmeho
         KNyZf1r+b+2q4/v35xp5qz7ufGcYkDGdZfebNLnOtjkccoyfBOZA7CIF40RFeVzMVhj4
         rXIbXmP+f/eDI6IMCoZcHAg5cRILaIIZMrIRxyZRoN0xEHGqnTdPc44pO1DToI7KsrZt
         PQT8knbecLO8XmrZjdzVwJLYLuTgyMb0L4TeNywDBmew0lxw7fE7/7eIwrCdrxTchUO1
         OaFA==
X-Gm-Message-State: AOAM533zMqCA6R9v0+Vg1VhXgd4FGwcqAVaxOlgKK9Q79+Gq1anDWzX/
        0KhvEt5+Eiv7kjvmE7jcZTg=
X-Google-Smtp-Source: ABdhPJxKNT1G8dmb8j36fXGNMuaNm8Y5aZqKr0KQF9zkRC1YoYO9VL8vBl0jRLY9uzTArUGSt0nV2w==
X-Received: by 2002:a05:6602:2bfa:: with SMTP id d26mr228462ioy.13.1623255968043;
        Wed, 09 Jun 2021 09:26:08 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id h26sm203555ioh.34.2021.06.09.09.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 09:26:07 -0700 (PDT)
Date:   Wed, 09 Jun 2021 09:26:01 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <60c0eb99aa8c2_98621208ad@john-XPS-13-9370.notmuch>
In-Reply-To: <20210609155704.GB12061@ranger.igk.intel.com>
References: <162318053542.323820.3719766457956848570.stgit@john-XPS-13-9370>
 <162318063321.323820.18256758193426055338.stgit@john-XPS-13-9370>
 <20210609155704.GB12061@ranger.igk.intel.com>
Subject: Re: [PATCH bpf 2/2] bpf: selftest to verify mixing bpf2bpf calls and
 tailcalls with insn patch
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski wrote:
> On Tue, Jun 08, 2021 at 12:30:33PM -0700, John Fastabend wrote:
> > This adds some extra noise to the tailcall_bpf2bpf4 tests that will cause
> > verifier to patch insns. This then moves around subprog start/end insn
> > index and poke descriptor insn index to ensure that verify and JIT will
> > continue to track these correctly.
> 
> This test is the most complicated one where I tried to document the scope
> of it on the side of prog_tests/tailcalls.c. I feel that it would make it
> more difficult to debug it if under any circumstances something would have
> been broken with that logic.
> 
> Maybe a separate test scenario? Or is this an overkill? If so, I would
> vote for moving it to tailcall_bpf2bpf1.c and have a little comment that
> testing other bpf helpers mixed in is in scope of that test.

I like pushing it into the complex test to get the most instruction
patching combinations possible.

> 
> > 
> > Reviewed-by: Daniel Borkmann <daniel@iogearbox.net>
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  .../selftests/bpf/progs/tailcall_bpf2bpf4.c        |   17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
> > index 9a1b166b7fbe..0d70de5f97e2 100644
> > --- a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
> > +++ b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
> > @@ -2,6 +2,13 @@
> >  #include <linux/bpf.h>
> >  #include <bpf/bpf_helpers.h>
> >  
> > +struct {
> > +	__uint(type, BPF_MAP_TYPE_ARRAY);
> > +	__uint(max_entries, 1);
> > +	__uint(key_size, sizeof(__u32));
> > +	__uint(value_size, sizeof(__u32));
> > +} nop_table SEC(".maps");
> > +
> >  struct {
> >  	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
> >  	__uint(max_entries, 3);
> > @@ -11,9 +18,19 @@ struct {
> >  
> >  static volatile int count;
> >  
> > +__noinline
> > +int subprog_noise(struct __sk_buff *skb)
> > +{
> > +	__u32 key = 0;
> > +
> > +	bpf_map_lookup_elem(&nop_table, &key);
> > +	return 0;
> > +}
> > +
> >  __noinline
> >  int subprog_tail_2(struct __sk_buff *skb)
> >  {
> > +	subprog_noise(skb);
> >  	bpf_tail_call_static(skb, &jmp_table, 2);
> >  	return skb->len * 3;
> >  }
> > 
> > 


