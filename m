Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE04144124
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbgAUQAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 11:00:23 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36912 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729240AbgAUQAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 11:00:22 -0500
Received: by mail-pf1-f194.google.com with SMTP id p14so1713895pfn.4;
        Tue, 21 Jan 2020 08:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DiBYNmXcXzLpV1vT3exTVSZVbWSYf4SQdXKVlOWQPJI=;
        b=W3ymVDlnQNVtZCOKp2Eh6TE37/5Bz94g+01nragD/ut9cwR/XJTvL6vyt+AFjmrbP6
         Ot6gjD9vnHbI2v07CeDAzHMWDmEBlO4SmsJpNe7jIwnuQlQQi5LDNVqR295GxRXL5YmT
         jdZ0V+x2c58lzaontIgXHJNVhdyRcd7c25jpEN95sv3tz+UKQROR2cfbM4WPXmjVdGmX
         OSh6ONgPP1cgnnA78VBOe5wgAydLCcz6w8tOEV/mqi1dy27QJFF95apxwQR/qV+w9fTB
         pOLUrCAcXcx/B4LtgaNsaf1OjbKpwDwgdf9+PAwF5hLXZAvBMXl7q1t5MQYy4O8YFfLn
         BhWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DiBYNmXcXzLpV1vT3exTVSZVbWSYf4SQdXKVlOWQPJI=;
        b=G76PTbfdJdj6eZ8/asR9SPe4aqN5JBumYMm7hLDHquHBw0rMO10z3uMH+2zJNrpKcN
         ArNKArxKTzm4BoGnK9fzr1UEUbjdw5SvV5XQmQxJ9xfGl7oze9YFq8OHPj5FugNK4cCy
         KbtuKIgXIfnTQG5uV0RDVKbFHkdbw5/4XBuV7GH+03k4C1Eg/5a4r/qb/qD/0Gmrf/ud
         b3l1Q9478PGp0KC3s3dawAdFARHkjOBRV3bcu36xVQpFV9t/Qm6Mi5tbU4NDSw2Y3UNV
         pRNzSbsask1pUKPGT5aIQ4qAWAWpZda0OlTp/jy5jAc3P9arzKkfNr/AncbW9Onnym/g
         iFEw==
X-Gm-Message-State: APjAAAU2rsBpVDufJ5jGZzlMjDPKKGEfu6RmXvdcWPDA77A+EoO/+erw
        hexuc6J4ytOpNYzZkLAH2Io=
X-Google-Smtp-Source: APXvYqwQeo6pAprxZlgMFKBrW7OuTr97rXRoi0L3MNG9QBcZ9VVLPwshA85FOe6JcNbTeNIgyBeRXw==
X-Received: by 2002:a63:70e:: with SMTP id 14mr6020005pgh.266.1579622421955;
        Tue, 21 Jan 2020 08:00:21 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:8f80])
        by smtp.gmail.com with ESMTPSA id r37sm3854097pjb.7.2020.01.21.08.00.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jan 2020 08:00:21 -0800 (PST)
Date:   Tue, 21 Jan 2020 08:00:19 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Introduce dynamic program extensions
Message-ID: <20200121160018.2w4o6o5nnhbdqicn@ast-mbp.dhcp.thefacebook.com>
References: <20200121005348.2769920-1-ast@kernel.org>
 <20200121005348.2769920-2-ast@kernel.org>
 <5e26aa0bc382b_32772acafb17c5b410@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e26aa0bc382b_32772acafb17c5b410@john-XPS-13-9370.notmuch>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 11:36:43PM -0800, John Fastabend wrote:
> 
> > +
> > +	t1 = btf_type_skip_modifiers(btf1, t1->type, NULL);
> > +	t2 = btf_type_skip_modifiers(btf2, t2->type, NULL);
> 
> Is it really best to skip modifiers? I would expect that if the
> signature is different including modifiers then we should just reject it.
> OTOH its not really C code here either so modifiers may not have the same
> meaning. With just integers and struct it may be ok but if we add pointers
> to ints then what would we expect from a const int*?
> 
> So whats the reasoning for skipping modifiers? Is it purely an argument
> that its not required for safety so solve it elsewhere? In that case then
> checking names of functions is also equally not required.

Function names are not checked by the kernel. It's purely libbpf and bpf_prog.c
convention. The kernel operates on prog_fd+btf_id only. The names of function
arguments are not compared either.

The code has to skip modifiers. Otherwise the type comparison algorithm will be
quite complex, since typedef is such modifier. Like 'u32' in original program
and 'u32' in extension program would have to be recursively checked.

Another reason to skip modifiers is 'volatile' modifier. I suspect we would
have to use it from time to time in original placeholder functions. Yet new
replacement function will be written without volatile. The placeholder may need
volatile to make sure compiler doesn't optimize things away. I found cases
where 'noinline' in placeholder was not enough. clang would still inline the
body of the function and remove call instruction. So far I've been using
volatile as a workaround. May be we will introduce new function attribute to
clang.

Having said that I share your concern regarding skipping 'const'. For 'const
int arg' it's totally ok to skip it, since it's meaningless from safety pov,
but for 'const int *arg' and 'const struct foo *arg' I'm planning to preserve
it. It will be preserved at the verifier bpf_reg_state level though. Just
checking that 'const' is present in extension prog's BTF doesn't help safety.
I'm planing to make the verifier enforce that bpf prog cannot write into
argument which type is pointer to const struct. That part is still wip. It will
be implemented for global functions first and then for extension programs.
Currently the verifier rejects any pointer to struct (other than context), so
no backward compatibility issues.
