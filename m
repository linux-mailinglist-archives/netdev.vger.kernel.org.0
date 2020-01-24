Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43F06148CCB
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 18:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731616AbgAXRP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 12:15:56 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45541 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730514AbgAXRP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 12:15:56 -0500
Received: by mail-ed1-f67.google.com with SMTP id v28so3102552edw.12
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 09:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8XQW8flWhdw7ecyQdH1aoatnxodXwLODjDkGAXOiLy4=;
        b=G2zsBg9zvuVeuPxnUFgecEss89UtZpgw2XkR/Chj6xW/DFJhjYigWjIbgnw8hxnorq
         Mfjoe4A4McogCuXvkcYflRSXnrcshKDsV3fR1GmI0qyksriGK1XDc8uATj6iXbgL1Eqw
         ZTjQdnzuoU52c5f2bfJW/a8usXrksR/tFVFtD2FGWisuiMs/6n1LzKCGnzxX0ks32V3W
         zwmQ8EicPBTAgW2jWqkke60qHvmMRy+vezFsGBu83skb4md07J+GYddsWbG7TUZH/DJx
         T4Ua1Ps/PtDcwZz0LJs0EsPJzpJKRqHCCCW8MRnCHapw1aI2ZGtL2KRabZ/YzUP8b7tf
         KZ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8XQW8flWhdw7ecyQdH1aoatnxodXwLODjDkGAXOiLy4=;
        b=dLATvUl6Gi0ZLClqyT3zqBs+47EbNMc0ywwb6l8aETsvZqDtufKMX7nFvs8nIEzb7W
         7dpqgfVYNr+4IBZhLgsExKA5FkhCXkVCEFigzIr6xQVkIVCj9uZzgGCnj7R6yzVAuTkq
         9nXaB+tdkwAA+b8k25yyhUQ/DrS8MN4l3i3x55LrhI3h6Wjyup19jffL6w35RAL3vYee
         3oRMlUhXv45Q7XNyi81SumtOGgZbjF85BBe2sjBpO1Gzogk/4iCB6rIoddClNqBnGpzU
         L4Bk7HT1tq3dsEC/cRsKHn8HRS7y4H/RfvAp1Eu7wPM6jifgTwXpoV2BqH7IGZvS0OJF
         4spQ==
X-Gm-Message-State: APjAAAXGcHU1oDguQ1ZvBu1+MvmnBWWwa+WHhE6KBew8FOipUNM0xF8e
        D1Zzrp5rs1GObnapZEqQ6pN/4Q2I+36HzzTxYLoA1A==
X-Google-Smtp-Source: APXvYqxD15ggf9UfDqkSIz3xPF45TnKzIfw3Av7ddlJQzVzg7Nbko/ypeRrsxpzb8kDn00tpkRe0T5aqHNeo9fIUxNU=
X-Received: by 2002:a17:906:31c6:: with SMTP id f6mr3778132ejf.17.1579886153996;
 Fri, 24 Jan 2020 09:15:53 -0800 (PST)
MIME-Version: 1.0
References: <20200122203253.20652-1-lrizzo@google.com> <875zh2bis0.fsf@toke.dk>
 <953c8fee-91f0-85e7-6c7b-b9a2f8df5aa6@iogearbox.net> <87blqui1zu.fsf@toke.dk>
 <CAMOZA0Kmf1=ULJnbBUVKKjUyzqj2JKfp5ub769SNav5=B7VA5Q@mail.gmail.com>
 <875zh2hx20.fsf@toke.dk> <CAMOZA0JSZ2iDBk4NOUyNLVE_KmRzYHyEBmQWF+etnpcp=fe0kQ@mail.gmail.com>
 <b22e86ef-e4dd-14a3-fb1b-477d9e61fefa@iogearbox.net> <87r1zpgosp.fsf@toke.dk>
 <CAMOZA0+neBeXKDyQYxwP0MqC9TqGWV-d3S83z_EACH=iOEb6mw@mail.gmail.com> <87r1zog9cj.fsf@toke.dk>
In-Reply-To: <87r1zog9cj.fsf@toke.dk>
From:   Luigi Rizzo <lrizzo@google.com>
Date:   Fri, 24 Jan 2020 09:15:42 -0800
Message-ID: <CAMOZA0KZOyEjJj3N7WQNRYi+n91UKkWihQRjxdrbCs9JdM5cbg@mail.gmail.com>
Subject: Re: [PATCH] net-xdp: netdev attribute to control xdpgeneric skb linearization
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 7:31 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Luigi Rizzo <lrizzo@google.com> writes:
>
...
> > My motivation for this change is that enforcing those guarantees has
> > significant cost (even for native xdp in the cases I mentioned - mtu >
> > 1 page, hw LRO, header split), and this is an interim solution to make
> > generic skb usable without too much penalty.
>
> Sure, that part I understand; I just don't like that this "interim"
> solution makes generic and native XDP diverge further in their
> semantics...

As a matter of fact I think it would make full sense to use the same approa=
ch
to control whether native xdp should pay the price converting to linear buf=
fers
when the hw cannot guarantee that.

To me this seems to be a case of "perfect is enemy of good":..

cheers
luigi


>
> > In the long term I think it would be good if the xdp program could
> > express its requirements at load time ("i just need header, I need at
> > least 18 bytes of headroom..") and have the netdev or nic driver
> > reconfigure as appropriate.
>
> This may be interesting to include in the XDP feature detection
> capabilities we've been discussing for some time. Our current thinking
> is that the verifier should detect what a program does, rather than the
> program having to explicitly declare what features it needs. See
> https://github.com/xdp-project/xdp-project/blob/master/xdp-project.org#no=
tes-implementation-plan
> for some notes on this :)
>
> -Toke
>
