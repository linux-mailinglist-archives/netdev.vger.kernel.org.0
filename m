Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022351B5169
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 02:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgDWAjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 20:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726112AbgDWAjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 20:39:15 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B1EC03C1AA
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 17:39:15 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t16so1636405plo.7
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 17:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wUakctYHwfp/MLrgLo7Q01GjcLl9cKCqsbFUgDqcwNU=;
        b=SkE9F4C6u6poTIe5Q8SXmqR54IzjLZK904m2DTS7Dv0E0nTfuf5I9PQZwhzxdDE7Z1
         sdKcTD7ldwll0QKZrWBKRSRZMt5mngrUnSMrVW2ayq4HglA1kqjpUf9e2IACYsSryw3C
         CGxoIzYnPc2hbYxVZ+GEEIqrZiZXC5/bgZzJ8MJPkOvvAr998GctWNgB/U3O2IaA4nnT
         EZwAfFL5IyoRvcUu+Tfi1+cU6WaSHIkZlPt1ZU5Fk29j4SU1y1uSOtllsI995f16lXr6
         lc9pLl9mqfKu+DnlLrH32QKUKFdOfKBC+gF+NhyxvMfxTxcVIAs9FcFgqjOawV4JbdM3
         akgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wUakctYHwfp/MLrgLo7Q01GjcLl9cKCqsbFUgDqcwNU=;
        b=Fih7lGoYAtoZADHzn5DRsr21Pzyzbj/IQIPDItXdKwkY2ffcnVhNyw6UYik44xMX+3
         1rSPhD9WWWC8+pn6fwA+Nyj0T3TWQZgTwoL/phQEQUDi/eOEswb9dsHjUYQ1uXTtPKu2
         /PiPpifXfnaYPaMCcBrEDBy9S+bjHIhDOLSAHccyxgsXva2G2V1kTZNv/qkJTXIwjRTD
         QVT7pB2j6cF8GSSZjucysBYS3b+JNPJVvyF4w+G2XR7fUOSFInQI6/+Pyo0HzJI5WXeZ
         l9hg1SeOpULWiFoJbAf9xS6ponM6rABQ1qtifCwCqE9TwPOUyDb3v0VNHuHKQe7sersE
         bVSw==
X-Gm-Message-State: AGi0PuZxR8AmumgNGOfUwElPvA4aCT0O40w4naw4KxAAOLbJ0Qn7IVQx
        SkX219IxDq58BQ75EyzjdCk=
X-Google-Smtp-Source: APiQypK6s7LLgevd+MfnwdBb5rg6sxWy8JOJA5fEztwLmuz/22VotGQQnq4b3zlN+o3tH21MA4qn1g==
X-Received: by 2002:a17:902:bcc4:: with SMTP id o4mr1293699pls.233.1587602355122;
        Wed, 22 Apr 2020 17:39:15 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:b150])
        by smtp.gmail.com with ESMTPSA id a9sm421108pgv.18.2020.04.22.17.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 17:39:14 -0700 (PDT)
Date:   Wed, 22 Apr 2020 17:39:11 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 04/16] net: Add BPF_XDP_EGRESS as a
 bpf_attach_type
Message-ID: <20200423003911.tzuu6cxtg7olvvko@ast-mbp.dhcp.thefacebook.com>
References: <20200420200055.49033-5-dsahern@kernel.org>
 <87ftcx9mcf.fsf@toke.dk>
 <856a263f-3bde-70a7-ff89-5baaf8e2240e@gmail.com>
 <87pnc17yz1.fsf@toke.dk>
 <073ed1a6-ff5e-28ef-d41d-c33d87135faa@gmail.com>
 <87k1277om2.fsf@toke.dk>
 <154e86ee-7e6a-9598-3dab-d7b46cce0967@gmail.com>
 <875zdr8rrx.fsf@toke.dk>
 <783d0842-a83f-c22f-25f2-4a86f3924472@gmail.com>
 <87368v8qnr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87368v8qnr.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 05:51:36PM +0200, Toke Høiland-Jørgensen wrote:
> David Ahern <dsahern@gmail.com> writes:
> 
> > On 4/22/20 9:27 AM, Toke Høiland-Jørgensen wrote:
> >> And as I said in the beginning, I'm perfectly happy to be told why I'm
> >> wrong; but so far you have just been arguing that I'm out of scope ;)
> >
> > you are arguing about a suspected bug with existing code that is no way
> > touched or modified by this patch set, so yes it is out of scope.
> 
> Your patch is relying on the (potentially buggy) behaviour, so I don't
> think it's out of scope to mention it in this context.

Sorry for slow reply.
I'm swamped with other things atm.

Looks like there is indeed a bug in prog_type_ext handling code that
is doing
env->ops = bpf_verifier_ops[tgt_prog->type];
I'm not sure whether the verifier can simply add:
prog->expected_attach_type = tgt_prog->expected_attach_type;
and be done with it.
Likely yes, since expected_attach_type must be zero at that point
that is enforced by bpf_prog_load_check_attach().
So I suspect it's a single line fix.
A selftest to prove or disprove is necessary, of course.

Thanks Toke for bringing it to my attention.
