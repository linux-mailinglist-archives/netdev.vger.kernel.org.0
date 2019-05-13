Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD3B1BFB9
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 01:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfEMXFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 19:05:16 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39575 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbfEMXFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 19:05:15 -0400
Received: by mail-pg1-f193.google.com with SMTP id w22so7533800pgi.6
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 16:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ClSQw8ycEIIMQiIBxg9FdUvY7G6QgeWAD+x2eOpvAXA=;
        b=R/2KTcWRwnIXYNDjiLDd3shxRbS8G0DBxdB8Qy8s95MKg1RMJODSLnUFDLhXBcmQ5z
         Nof4ATB84T/kUJ3rueMamQKZgIANiCKUfyrjz31P3MUR0NyLvt0omozmFxri3vszkCQc
         akEuDePzDv+ohxb8RO9bwRxiBELiWj21/WWVRAKJQEnF4zYK4V4fou6LfEQx5t8oVi3L
         uers4z+kM1973r6ObZlzzENAU8fnsbyUmQncDUwn31qkBKGr6BbI4S0WsEQCz04c+6M+
         qAEyVcRM8R4r0w80JuCS57f5r/nbpLY2UQzVnY6qKu7zuDgyaX8z6mqFX1mJTk0OxgLe
         mXgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ClSQw8ycEIIMQiIBxg9FdUvY7G6QgeWAD+x2eOpvAXA=;
        b=PgCVowiUuiHI2YK0RG/44iNsvsjbYCVwPzajUe1XxwRQT3t/IFm1tZN3J3AKwiNXen
         bxNrfErvja4H/uMGPVWvoAbYq7quSWy/3JJ0KwejLqWKPdxyOiUEGTAiZ63aE6TSGCHD
         u98IDqqgTrRQ5tNOGD1iNFDY/Y0P+WXZYfm1punKKJ31RWkhYDDMwieljStXap2rYT3H
         9ZKGzuas3k7XGkxt2Znd6vQEUol7tZoa8bDJ3r88B++Y+8NClc6zSLDBHfVGjKWYkJLl
         lhIViGabMFdft8vjR+QMZdoRHDiduWlQuBXg4uOpt/bkctg4x5aRsfjzMxxXxoHCLDV2
         9IoQ==
X-Gm-Message-State: APjAAAWlKbnJzJUcedh+TCxLFsm4fOzx6QN/beRqozx5zfyPXfpqATM2
        RTZ0yQveGyCECbq4D0Zx8vfdbQ==
X-Google-Smtp-Source: APXvYqy1YmyEWgT2uzXvu2WwT5J6UaGme+PcUzptgCYmTHmO9565PrR7j4LrYxY49rsNY3DVbG0N8w==
X-Received: by 2002:a63:fd0c:: with SMTP id d12mr34983924pgh.391.1557788714740;
        Mon, 13 May 2019 16:05:14 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id d85sm3556653pfd.94.2019.05.13.16.05.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 13 May 2019 16:05:14 -0700 (PDT)
Date:   Mon, 13 May 2019 16:05:13 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Subject: Re: [PATCH bpf 1/2] flow_dissector: support
 FLOW_DISSECTOR_KEY_ETH_ADDRS with BPF
Message-ID: <20190513230513.GA10244@mini-arch>
References: <20190513185402.220122-1-sdf@google.com>
 <CAF=yD-LO6o=uZ-aT-J9uPiBcO4f2Zc9uyGZ+f7M7mPtRSB44gA@mail.gmail.com>
 <20190513210239.GC24057@mini-arch>
 <CAF=yD-JKbzuoF_q7gPRjMNCBexn4pxgQ6pTeQSRfPXmwWk5dzg@mail.gmail.com>
 <CAF=yD-Lg16ETT09=fRd2FTx2FJoGZ9K0s-JHrhv-9OMTqE+5BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-Lg16ETT09=fRd2FTx2FJoGZ9K0s-JHrhv-9OMTqE+5BQ@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/13, Willem de Bruijn wrote:
> On Mon, May 13, 2019 at 5:21 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Mon, May 13, 2019 at 5:02 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > >
> > > On 05/13, Willem de Bruijn wrote:
> > > > On Mon, May 13, 2019 at 3:53 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > > >
> > > > > If we have a flow dissector BPF program attached to the namespace,
> > > > > FLOW_DISSECTOR_KEY_ETH_ADDRS won't trigger because we exit early.
> > > >
> > > > I suppose that this is true for a variety of keys? For instance, also
> > > > FLOW_DISSECTOR_KEY_IPV4_ADDRS.
> >
> > > I though the intent was to support most of the basic stuff (eth/ip/tcp/udp)
> > > without any esoteric protocols.
> >
> > Indeed. But this applies both to protocols and the feature set. Both
> > are more limited.
> >
> > > Not sure about FLOW_DISSECTOR_KEY_IPV4_ADDRS,
> > > looks like we support that (except FLOW_DISSECTOR_KEY_TIPC part).
> >
> > Ah, I chose a bad example then.
> >
> > > > We originally intended BPF flow dissection for all paths except
> > > > tc_flower. As that catches all the vulnerable cases on the ingress
> > > > path on the one hand and it is infeasible to support all the
> > > > flower features, now and future. I think that is the real fix.
> >
> > > Sorry, didn't get what you meant by the real fix.
> > > Don't care about tc_flower? Just support a minimal set of features
> > > needed by selftests?
> >
> > I do mean exclude BPF flow dissector (only) for tc_flower, as we
> > cannot guarantee that the BPF program can fully implement the
> > requested feature.
> 
> Though, the user inserting the BPF flow dissector is the same as the
> user inserting the flower program, the (per netns) admin. So arguably
> is aware of the constraints incurred by BPF flow dissection. And else
> can still detect when a feature is not supported from the (lack of)
> output, as in this case of Ethernet address. I don't think we want to
> mix BPF and non-BPF flow dissection though. That subverts the safety
> argument of switching to BPF for flow dissection.
Yes, we cannot completely avoid tc_flower because we use it to do
the end-to-end testing. That's why I was trying to make sure "basic"
stuff works (it might feel confusing that tc_flower {src,dst}_mac
stop working with a bpf program installed).

TBH, I'd not call this particular piece of code that exports src/dst
addresses a dissection. At this point, it's a well-formed skb with
a proper l2 header and we just copy the addresses out. It's probably
part of the reason the original patch didn't include any skb->protocol
checks.
