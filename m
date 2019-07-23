Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5BE72109
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 22:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389038AbfGWUqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 16:46:20 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:44493 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731769AbfGWUqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 16:46:20 -0400
Received: by mail-pl1-f180.google.com with SMTP id t14so21031262plr.11;
        Tue, 23 Jul 2019 13:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EvnVDt/59AD3bIzQWyLxIw1SMkK4sG1nqlno4j30I9c=;
        b=HyIwnxhuKSmwlJyg2WqZr4igWe/AB2QMz00Px0PRuDOadANEQkB9oU0YYBDd8fgHOH
         Inuokl/wWCg7DAIR3ByZlopJavgMS4AcmIXnurCwcNt495NsQ/NCMKQqH6tvmDlzQFqP
         j2RDmgLNzK2dpKV6Rhcqv3aBy95GbHah3FLSkjckuaadgiontdlpP+PAkrK3KbldWzAt
         6Z4GPr++TQEIU7Bu6Kq2MF4mD9EVV7xhUpzVjwc4KhdL3fr3IoTCeciBh8Dtq8Q3oVG8
         sHO8MFiI95v+yYlFdWQK/XO0YT71Zc5r5iPPYhL558XDYdLFBoWlGeobXc1dOZh3gClQ
         biLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EvnVDt/59AD3bIzQWyLxIw1SMkK4sG1nqlno4j30I9c=;
        b=t6OYqXXO7uGjz3Y0b0aQURwtEYps3DhjSmtnLrmF3slosBeVNMTh+2qdkqzEeBVgFH
         RzAgtR449FeFnNBljFexNW4O4b20v90Gb1PzXEVdnbbK6ifzJTVl4GFVi6FDuv4YFnrI
         I5dZ6vXpKdjPF8+3fwH4ogoIuyhlCYnZvSVYh4hu6baTEtMTKkYBHADaH6xiPtg0+jce
         traIdJlgztShPTc3DOJBnq7VZabj4/A0Ju29B5y5e0zrq5BbMFSCBuJKUoowmP4n3lyH
         qD8snG0cYvoW1rgm7Q05BYGkDF3LjH8aCrvGDR93J388DLN4yl8HYCZRgfINYHhzrGn3
         IWYg==
X-Gm-Message-State: APjAAAWcHdfexs3I1O5iijqzSe8QthcV1JzVk5FC3nZRMTHOozkYp5jX
        XAZCTaAjBekz+K8TJeb0fyE=
X-Google-Smtp-Source: APXvYqyjxOMwg1QsuotRNX+uJIF5IzUumpcJGWrCCYsleNf/T1k2qJmBu2rNWmTwavfNgy1piS4zkA==
X-Received: by 2002:a17:902:2868:: with SMTP id e95mr77018365plb.319.1563914779685;
        Tue, 23 Jul 2019 13:46:19 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::3:46e3])
        by smtp.gmail.com with ESMTPSA id n140sm46357271pfd.132.2019.07.23.13.46.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 13:46:18 -0700 (PDT)
Date:   Tue, 23 Jul 2019 13:46:16 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Petar Penkov <ppenkov.kernel@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>, yhs@fb.com
Subject: Re: [bpf-next 6/6] selftests/bpf: add test for bpf_tcp_gen_syncookie
Message-ID: <20190723204615.a6tia3f6fipdoht2@ast-mbp>
References: <20190723002042.105927-1-ppenkov.kernel@gmail.com>
 <20190723002042.105927-7-ppenkov.kernel@gmail.com>
 <CACAyw9-qQ8KbQk6Q6dg0+A337ZbSpot-sHpH_tSxFaQmUfhLyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw9-qQ8KbQk6Q6dg0+A337ZbSpot-sHpH_tSxFaQmUfhLyQ@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 10:37:29AM +0100, Lorenz Bauer wrote:
> On Tue, 23 Jul 2019 at 01:20, Petar Penkov <ppenkov.kernel@gmail.com> wrote:
> > +static __always_inline __s64 gen_syncookie(void *data_end, struct bpf_sock *sk,
> > +                                          void *iph, __u32 ip_size,
> > +                                          struct tcphdr *tcph)
> > +{
> > +       __u32 thlen = tcph->doff * 4;
> > +
> > +       if (tcph->syn && !tcph->ack) {
> > +               // packet should only have an MSS option
> > +               if (thlen != 24)
> > +                       return 0;
> 
> Just for my own understanding: without this the verifier complains since
> thlen is not a known value, even though it is in bounds due to the check below?

the verifier understands only constant part of the packet pointer.
Without additional 'if' above the statement:
if ((void *)tcph + thlen > data_end)
will add variables length 'thlen' to pkt pointer which will become
another pkt pointer (with different id).
That pointer would need 'pkt + const_range > data_end' to have valid access.

We hit this issue in the past when folks wanted to use bpf_csum_diff() helper
with variable size.
It's possible to extend the verifier to support that but it's intrusive,
since variable part would need to passed around to a bunch of check* functions.
I think it's tricky, but doable. Looking forward to patches :)

> > +
> > +               if ((void *)tcph + thlen > data_end)
> > +                       return 0;
> > +
> > +               return bpf_tcp_gen_syncookie(sk, iph, ip_size, tcph, thlen);
> > +       }
> > +       return 0;
> > +}
> > +
> 
> -- 
> Lorenz Bauer  |  Systems Engineer
> 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
> 
> www.cloudflare.com
