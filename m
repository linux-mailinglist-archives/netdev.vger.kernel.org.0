Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01C6DE298E
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 06:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406606AbfJXE1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 00:27:11 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36766 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfJXE1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 00:27:11 -0400
Received: by mail-io1-f68.google.com with SMTP id c16so7953324ioc.3;
        Wed, 23 Oct 2019 21:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=d5jH9KvaBj8Gt/g4n58IX0lMT/HPC62LoxmQTBDg4Cc=;
        b=KsH8aPscRq1W9od3evAQiSyNUwt9aKz58BdimUnwONKGvAuBrZvZ1s6aEhmRnVFaFZ
         39nSNvqZH+UI+oFGnHbA5mF4umxUXElW5UOG55RaPaJHICtABAJI+uecqvSN7pnNK/Mm
         IXF30wiPsMdhzazxUBLD+fVAyLgmf43IkqkxRuFZx2tR45m2+e/Sn1Az4EJo0KN0rgw7
         R5ULCgGAjp8tDX4gnXaAB0T9Y/iMl2dMYtGeeg6GlIbkyhC+ZEY4qBZmTsIh891Brl+y
         jsSVm8msKImu1G74rNiREfpo1m7fGQoDDdjtKLMU/hT/mCOqeJMiT4lQtPVj1zWOGbvR
         5TQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=d5jH9KvaBj8Gt/g4n58IX0lMT/HPC62LoxmQTBDg4Cc=;
        b=I7aoH6lTHqdAuZP0yDC546XcZaLFV/MOxxJdXBTTowM4pqCdwg/b/3/fTB8z6sjod8
         X+2wugsVGoed2/TIhjIKOrkT+Vf9AFjkhRZpfj/3g9a2c7CnI5xd3Wq6oMycXnCNImbr
         gbUdqmsvwora0GIGYnmzCDC2NDFPxlSX8rrSlW41GvPNwuPYNsw0DooLR+v1qGjDJUc0
         TxKG+gfLYZWZ3tfFDMQl9ARjzUkJrsDxA6VSPVLNhbS7t2vhPM3tMRE01D/DvS1W0B2V
         dmaB4A6YHKB1gR0yt4fuTL7NV5/w/1XFRGT/sYwpdrgow4bfaNwY7xx83Lb4ueyK4P2V
         g/4w==
X-Gm-Message-State: APjAAAUn73s/dQ9JWUWWjKotUhXvXsAo2hF2So6udnRr0ifTP66HnRdm
        AUN8pZl1SXh5COMpWWBEj70=
X-Google-Smtp-Source: APXvYqxggO2OHzr3yNotv+4nHEH29qI8GCFioDjrAcIAxxiZxfNOLcLb2z7nNNXSHfTvhiRcinlEhg==
X-Received: by 2002:a5d:8910:: with SMTP id b16mr7032917ion.157.1571891230682;
        Wed, 23 Oct 2019 21:27:10 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m17sm6938467ilb.5.2019.10.23.21.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 21:27:09 -0700 (PDT)
Date:   Wed, 23 Oct 2019 21:27:01 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
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
Message-ID: <5db128153c75_549d2affde7825b85e@john-XPS-13-9370.notmuch>
In-Reply-To: <87h840oese.fsf@toke.dk>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
 <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch>
 <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com>
 <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch>
 <87h840oese.fsf@toke.dk>
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> John Fastabend <john.fastabend@gmail.com> writes:
> =

> > I think for sysadmins in general (not OVS) use case I would work
> > with Jesper and Toke. They seem to be working on this specific
> > problem.
> =

> We're definitely thinking about how we can make "XDP magically speeds u=
p
> my network stack" a reality, if that's what you mean. Not that we have
> arrived at anything specific yet...

There seemed to be two thoughts in the cover letter one how to make
OVS flow tc path faster via XDP. And the other how to make other
users of tc flower software stack faster.

For the OVS case seems to me that OVS should create its own XDP datapath
if its 5x faster than the tc flower datapath. Although missing from the
data was comparing against ovs kmod so that comparison would also be
interesting. This way OVS could customize things and create only what
they need.

But the other case for a transparent tc flower XDP a set of user tools
could let users start using XDP for this use case without having to
write their own BPF code. Anyways I had the impression that might be
something you and Jesper are thinking about, general usability for
users that are not necessarily writing their own network.

> =

> And yeah, I'd also be happy to discuss what it would take to make a
> native XDP implementation of the OVS datapath; including what (if
> anything) is missing from the current XDP feature set to make this
> feasible. I must admit that I'm not quite clear on why that wasn't the
> approach picked for the first attempt to speed up OVS using XDP...
> =

> -Toke
> =



