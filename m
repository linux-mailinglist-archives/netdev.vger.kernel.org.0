Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDEAE63B8
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 16:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfJ0PYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 11:24:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25673 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727319AbfJ0PYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 11:24:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572189869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k0PF6fDa4IHrKYA/cwKAZkTPLP3n9Ork1zMp9PtEt4U=;
        b=Mpz3E9KVMQ0xC52YzPo4Tz7kKO9qNp/NyRNgNojyfBiRFCQC6YBSiHcCPK380HXYxO0dkn
        Unv9xtqqr93KpZ7Xt5gCfSM5K5l4UcpDKueS+YygEP7Vq2Sf+fmMNlrOgtZM1wSQYMaul1
        +OSPT3uIwb06+7bzBGl5uKyZxWgZQRA=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-qt8f8K2AMzimJrF5FD_Pqw-1; Sun, 27 Oct 2019 11:24:27 -0400
Received: by mail-lj1-f197.google.com with SMTP id 205so1446881ljf.13
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 08:24:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=k0PF6fDa4IHrKYA/cwKAZkTPLP3n9Ork1zMp9PtEt4U=;
        b=fPxfuWrusTPwSZq2uSbIu5De29wb2MrtK6b/dX1OGjQOQ/2bmj1+pUt4vKY1+6NE0k
         /SoiqZipAFd8MbWLF08izQzaJsVzh3YoiJz6uphbkLt+XCk7Hx3O2NJJ+HMQznA3edNW
         2lmdvTNAKyr5rDTGBSPJyOFY16efnWPub7R3g9LgNTr1ffHzAdhU66BLP+AkqB8kWKDe
         KB8lEp/35yVdveCZRcor1lJDe2XIjYXJVt+GYlAbLCXJo/Fwyv4Uw36lUIq8e0fiQpm5
         n6jSdmyPzDL0+mWkCFeob1aSzbZfCvq8SNCLK9lgecaYVs0P2kvu6EyvxOrFXt8RQzNX
         MAEQ==
X-Gm-Message-State: APjAAAU1zAuXnb1yXE+jHCCucTxiIzqHSnI632tMvOyjZgvBo5ekH/4j
        tOxJ13reznDpIXGp7S97frEoycoQxK1P3ZMEs6QIe3JgXmJDZU/eP6T7WGA1XFUe4wJYYLOd/2s
        LYARqSIqHt2dCEDQf
X-Received: by 2002:ac2:57cb:: with SMTP id k11mr422573lfo.87.1572189866050;
        Sun, 27 Oct 2019 08:24:26 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzCX6pcIFHS8vTHfvaGy23y34eKpDgWZoOBBqOkCVB20JMYYV2lMdxl4FbPoE3QfgopaVeaVg==
X-Received: by 2002:ac2:57cb:: with SMTP id k11mr422552lfo.87.1572189865846;
        Sun, 27 Oct 2019 08:24:25 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id 4sm4114513ljv.87.2019.10.27.08.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 08:24:25 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 858011818B6; Sun, 27 Oct 2019 16:24:24 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
In-Reply-To: <282d61fe-7178-ebf1-e0da-bdc3fb724e4b@gmail.com>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com> <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch> <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com> <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch> <87h840oese.fsf@toke.dk> <282d61fe-7178-ebf1-e0da-bdc3fb724e4b@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 27 Oct 2019 16:24:24 +0100
Message-ID: <87wocqrz2v.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: qt8f8K2AMzimJrF5FD_Pqw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toshiaki Makita <toshiaki.makita1@gmail.com> writes:

> On 19/10/23 (=E6=B0=B4) 2:45:05, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> John Fastabend <john.fastabend@gmail.com> writes:
>>=20
>>> I think for sysadmins in general (not OVS) use case I would work
>>> with Jesper and Toke. They seem to be working on this specific
>>> problem.
>>=20
>> We're definitely thinking about how we can make "XDP magically speeds up
>> my network stack" a reality, if that's what you mean. Not that we have
>> arrived at anything specific yet...
>>=20
>> And yeah, I'd also be happy to discuss what it would take to make a
>> native XDP implementation of the OVS datapath; including what (if
>> anything) is missing from the current XDP feature set to make this
>> feasible. I must admit that I'm not quite clear on why that wasn't the
>> approach picked for the first attempt to speed up OVS using XDP...
>
> Here's some history from William Tu et al.
> https://linuxplumbersconf.org/event/2/contributions/107/
>
> Although his aim was not to speed up OVS but to add kernel-independent=20
> datapath, his experience shows full OVS support by eBPF is very
> difficult.

Yeah, I remember seeing that presentation; it still isn't clear to me
what exactly the issue was with implementing the OVS datapath in eBPF.
As far as I can tell from glancing through the paper, only lists program
size and lack of loops as limitations; both of which have been lifted
now.

The results in the paper also shows somewhat disappointing performance
for the eBPF implementation, but that is not too surprising given that
it's implemented as a TC eBPF hook, not an XDP program. I seem to recall
that this was also one of the things puzzling to me back when this was
presented...

-Toke

