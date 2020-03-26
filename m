Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFD71947C0
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 20:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgCZTpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 15:45:09 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45254 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbgCZTpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 15:45:08 -0400
Received: by mail-pl1-f193.google.com with SMTP id b9so2550290pls.12;
        Thu, 26 Mar 2020 12:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sOXGQjEEKLCwjbFO0Zx0DMlBVwmlMSG+I2gRzjcAgU4=;
        b=hQ+6lhlG00FEHD3matVmJicwW35u3Y6pLUgGkGcaMrEk2aaDa49Fpi+msPTNh/IJe2
         OEjoO+y0sRRnPMYSWLkJi6Hl811iz/w62vK3nvliB9RO9iuyMMDCmY5JploIDOBF6LN2
         mp0fIsp0TqitoaBACmYuPI8X+YyYEnjz29qHz7P0GIgkxgv3czgtN9TCbu6ai0lCBSPo
         RIYC2cPATtgoZ6cgv0HVyzUbyb5H76YDtUpAWQpKvYG0bbC80/N6LTUnUJTpZodyssCr
         xiKrApEgfE/ILr0LOJ97MOjNggT+lvaP1QT7hJ6uiGPP/h9Kex/Sv6TkX3PUfoJ0j84U
         grmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sOXGQjEEKLCwjbFO0Zx0DMlBVwmlMSG+I2gRzjcAgU4=;
        b=cezlRqZgtDF8eV+0PjsbfVAQ+24uNJfXVpyqIEUAeqO467jpajAVsgdq0KC/yHy31C
         QMZ4Uty4hO0azGwY1zu0il4baiKicZXpESdrtHczp6L5c+SCCVj0QVZKxpg3NuVklxEU
         dEHby+ai6OVzm2xE8KCoTk0oNJGHodgxfn7CIqD2mEYoAAxdhsaFzKhq7FQkX1XMKV0n
         KhBe2Irx9wDa5g17mDYXTJr3bqSrwiUeTcr0kk24bTMXnZhiAY5BcdmHGBhKBcmNOBlF
         KswHK9dfU8XPGbyDPK3kYvHvk3anPKK0A+KgPQPB5zWIDTCFE2N7sqE76j8Fevm+rT3b
         WaTA==
X-Gm-Message-State: ANhLgQ3O6+HLdus0kpihX17Nxymet/Jqta3gjfUwxnoaJmn1m6LPYZ/x
        3iBhVLc3OSg9ml+1dBeKiWw=
X-Google-Smtp-Source: ADFU+vuI+aotOj1NaBDkZaxxuj1xaRDJu/Uqjr7lZG8GzyXDag0U1AVsJbOToZLaTNdAvs02+/du+w==
X-Received: by 2002:a17:90a:6501:: with SMTP id i1mr1803228pjj.32.1585251906623;
        Thu, 26 Mar 2020 12:45:06 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:c7d9])
        by smtp.gmail.com with ESMTPSA id v20sm1420618pgo.34.2020.03.26.12.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 12:45:05 -0700 (PDT)
Date:   Thu, 26 Mar 2020 12:45:03 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200326194503.6wdx4gqq7u4quzrg@ast-mbp>
References: <87tv2f48lp.fsf@toke.dk>
 <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk>
 <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com>
 <20200326104755.1ea5ac43@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326104755.1ea5ac43@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 10:47:55AM -0700, Jakub Kicinski wrote:
> On Thu, 26 Mar 2020 10:04:53 +0000 Lorenz Bauer wrote:
> > On Thu, 26 Mar 2020 at 00:16, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > > Those same folks have similar concern with XDP. In the world where
> > > container management installs "root" XDP program which other user
> > > applications can plug into (libxdp use case, right?), it's crucial to
> > > ensure that this root XDP program is not accidentally overwritten by
> > > some well-meaning, but not overly cautious developer experimenting in
> > > his own container with XDP programs. This is where bpf_link ownership
> > > plays a huge role. Tupperware agent (FB's container management agent)
> > > would install root XDP program and will hold onto this bpf_link
> > > without sharing it with other applications. That will guarantee that
> > > the system will be stable and can't be compromised.  
> > 
> > Thanks for the extensive explanation Andrii.
> > 
> > This is what I imagine you're referring to: Tupperware creates a new network
> > namespace ns1 and a veth0<>veth1 pair, moves one of the veth devices
> > (let's says veth1) into ns1 and runs an application in ns1. On which veth
> > would the XDP program go?
> > 
> > The way I understand it, veth1 would have XDP, and the application in ns1 would
> > be prevented from attaching a new program? Maybe you can elaborate on this
> > a little.
> 
> Nope, there is no veths involved. Tupperware mediates the requests 
> from containers to install programs on the physical interface for
> heavy-duty network processing like DDoS protection for the entire
> machine.

that's not what is happening.
Jakub, I strongly suggest to avoid talking about things you have no clue.
