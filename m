Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B96E19560E
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 12:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgC0LLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 07:11:23 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:36016 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726217AbgC0LLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 07:11:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585307482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qqiOcFCD3/rFVzbufpuYaK5OO8+xWz6BEOItVPyTmOM=;
        b=TlnwuMBxhJh3EEp8NA32bPYMdFctRMmJCYuzMoBwLDlt6kZjMmBaWDLpvVz7DJfsRn7Whs
        K0Z2JwPVaGapKscv6B1/SqCpbThbxZZxJmiJtFYL1nlyXYWbZUwkvckKXL8qaVY9p3GXVN
        PgjnahIebF5zvyatiRh+fNvFalQAHeQ=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-NllzaPVDMcG6qnCu7vl9cw-1; Fri, 27 Mar 2020 07:11:19 -0400
X-MC-Unique: NllzaPVDMcG6qnCu7vl9cw-1
Received: by mail-lf1-f69.google.com with SMTP id q4so3621104lff.4
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 04:11:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=qqiOcFCD3/rFVzbufpuYaK5OO8+xWz6BEOItVPyTmOM=;
        b=Z1JJPUHht+HM/iq1L58gOH/F/QQ6z8zEXMx43EAxBJJXkZ4ZlOq0xzzzVvvO4Y0Gtb
         xDSsEBqUeoFUjNuGbTpBLQdmNQzX73l5vZAnbYN+tE9uYFLO9VzBMaBz2eaVgh9VBkD6
         T2jpX+W1vOnEG8trG9CglM3PXo5VmEPEQ0KbF1XHp7LqPfBrqt+3qfAxLWDWKNj85OWg
         PQLcRTtgq/ze7rpZBKrVU6+SLrkDPWbEDi0xXP8zlxjml/1cxvDbGyO3Mma2V7ihAmLb
         a/frMz1MBSw0D9Yfcip9TWN+7STD0V6wUmmmYVgzskSHlpHrFdNPGs6kdgHTJMUYfEpu
         2m9w==
X-Gm-Message-State: AGi0PuaznwczcSd0ckEq66eRfpeBSL/kUNFUX692k4QZbVjNy+f+1rxq
        AFC5098Wdnwy/gUn5W8KHXHqd5nBendU2FZTsmrOJONlPZE3NLdiJFgulmopJM+N57NKgLMoPhM
        q6eVc3sGwD++f4MAk
X-Received: by 2002:a2e:9852:: with SMTP id e18mr7979001ljj.249.1585307477570;
        Fri, 27 Mar 2020 04:11:17 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ+k1pjLeXZQGccUP/uckxHVHP+fyP4qa8BGa4ZZb/VsFDT0iiFsMmNcrv/chbbOIqVyVo5Iw==
X-Received: by 2002:a2e:9852:: with SMTP id e18mr7978982ljj.249.1585307477351;
        Fri, 27 Mar 2020 04:11:17 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o68sm3203372lff.81.2020.03.27.04.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 04:11:16 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 57ABC18158B; Fri, 27 Mar 2020 12:11:15 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing program when attaching XDP
In-Reply-To: <20200326195340.dznktutm6yq763af@ast-mbp>
References: <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com> <87tv2f48lp.fsf@toke.dk> <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com> <87h7ye3mf3.fsf@toke.dk> <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com> <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com> <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com> <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com> <20200326195340.dznktutm6yq763af@ast-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 27 Mar 2020 12:11:15 +0100
Message-ID: <87o8sim4rw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> libxdp (and now renamed to libdispatcher, right Toke?)

Not yet :)

I want to get it to initial feature completeness for XDP first, then
think about generalising the dispatcher bits (which has additional
issues, such as figuring out how to manage the dispatcher programs for
different program types).

Current code is in [0], for those following along. There are two bits of
kernel support missing before I can get it to where I want it for an
initial "release": Atomic replace of the dispatcher (this series), and
the ability to attach an freplace program to more than one "parent".
I'll try to get an RFC out for the latter during the merge window, but
I'll probably need some help in figuring out how to make it safe from
the verifier PoV.

-Toke


[0] https://github.com/xdp-project/xdp-tools/tree/xdp-multi-prog

