Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E44D5A223E
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 19:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbfH2R26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 13:28:58 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35805 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfH2R25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 13:28:57 -0400
Received: by mail-pg1-f196.google.com with SMTP id n4so1955663pgv.2;
        Thu, 29 Aug 2019 10:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=k1jwJKoeIGFgWWFuE7oepnY67hWNv/EdFW+k150ngZA=;
        b=MwMxRQPaosFEQjOX5hk/E9slBAtBVAPt2pDyWgB9fF9YdFgBxkIJ2J5RO/nvEiTHso
         HTEeCaRXRgOvABNivvSIfrthBbkyDcxEP0hoc7NcAebLKFJgjXDso2Adyb9i9mxKa3Hf
         sXbEbrr7WXIgQWGKUH8qS5RmpdQIIA5YKGDXRBW4e1IroAhQGUrbJWGgFhozeT35SXX8
         LDlQmZbtYOpKYKQ/l7GDbhN55xu+XOxn1gPjgVERg3mcPu/X0Ab1oLvO7Biv9+Do+LkG
         EHSp8ulrdSoXA9USAUsqMlHJx9TG4pt9CFobvtx6Hnm6Rux4i17JAub/AjEy8XIYjaJ/
         eyjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=k1jwJKoeIGFgWWFuE7oepnY67hWNv/EdFW+k150ngZA=;
        b=riyF55U/Xw5rlg6nQmzsgScqUM8RB621U90OvPmcdSISzkXARiRoZF/RiYMA/FqkaU
         0K5eqKjMkQTE98qY+t76vXj4wtYGm7YvkKha+j32uMvR6Vykno81mP6UB8ZUYSgwQw6Y
         d6AKtq+e34Pd1yuWChYECKVxeBR8OH+j+dqmFd1CIGLLYwVwFOOop6W0c2iEbMNXN0Zz
         Cb4apQjf00UvfNri3LoCV+6nX4VOuqPHTG7Y4DYydz5Dc3nLuuCpQkwxPXa0rcH7+ITn
         P/CIarQKBogr9MdM+H28+wyZ5vYMUcEAz070mtAmuaC4BQ0FAiKwK1gvTuQZ3pAB81+z
         0U1A==
X-Gm-Message-State: APjAAAUdyN27JfyrRqrcYp11EE3pPtweL0ZXmrg6vvlNpdpMLDbUr2Bv
        ZmYDslCmzWY+4S4U7/+yXzs=
X-Google-Smtp-Source: APXvYqzq9kL2VP5CW2b9d6LTlMaWg4ehJUVObEWWx9R+TxZ8w9beOFzaeKjpnDMYBDv6t11X7ZWzhw==
X-Received: by 2002:a63:1b66:: with SMTP id b38mr9433057pgm.54.1567099736134;
        Thu, 29 Aug 2019 10:28:56 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:1347])
        by smtp.gmail.com with ESMTPSA id a16sm4705481pfo.33.2019.08.29.10.28.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 10:28:55 -0700 (PDT)
Date:   Thu, 29 Aug 2019 10:28:54 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 2/3] bpf: implement CAP_BPF
Message-ID: <20190829172852.xhxtd6ruwdnhvvdt@ast-mbp.dhcp.thefacebook.com>
References: <20190829051253.1927291-1-ast@kernel.org>
 <20190829051253.1927291-2-ast@kernel.org>
 <B28631A9-BB92-404A-BD58-7A737BCF10C9@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B28631A9-BB92-404A-BD58-7A737BCF10C9@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 06:04:42AM +0000, Song Liu wrote:
> 
> 
> > On Aug 28, 2019, at 10:12 PM, Alexei Starovoitov <ast@kernel.org> wrote:
> > 
> 
> [...]
> 
> > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> > index 44e2d640b088..91a7f25512ca 100644
> > --- a/tools/testing/selftests/bpf/test_verifier.c
> > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > @@ -805,10 +805,20 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
> > 	}
> > }
> > 
> > +struct libcap {
> > +	struct __user_cap_header_struct hdr;
> > +	struct __user_cap_data_struct data[2];
> > +};
> > +
> 
> I am confused by struct libcap. Why do we need it? 

because libcap is not compatible with new kernel.
It needs to be recompiled with new capability.h
Otherwise it limits max to CAP_AUDIT_READ
Any value higher it will error during cap_get_flag.
And will silently ignore it during cap_set_flag.
Not a great library decision.

Thankfully this struct above is exactly the kernel api.
One doesn't really need libcap. It's imo easier to do without it.

