Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9C6EE0AF1
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 19:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730433AbfJVRpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 13:45:12 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33295 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727226AbfJVRpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 13:45:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571766310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=84NOK6JlBnakomHmdK8lEf2i89cFK17pqxVXj9BUO1k=;
        b=Bwh8qDWBDVdylOUwwGYGRPJvJpKg2tfPUOUdTb1h9Q7RbsFwurXwyVFVyHSgRe2nbRDUM+
        OqHf7DIp+hBqZaHZTeG4ieDSiZByOkSCD3MCIdMW0ESCoKsP9ySFKGykR4UYGg+gHwZdKn
        XAk/nCu2tIKWGmn7DFwBu73h10WiKIo=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-waoQBmpSMP2D07f1cb2T9w-1; Tue, 22 Oct 2019 13:45:09 -0400
Received: by mail-lj1-f200.google.com with SMTP id y12so3107385ljc.8
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 10:45:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=84NOK6JlBnakomHmdK8lEf2i89cFK17pqxVXj9BUO1k=;
        b=Ims83G183GiqgrSauh6fx1+tzNwHp/oQqv+F1mpy1uCJv0zGVaUDQ38726JpPG60ug
         x32GmMLuhsG5/y+ioHNSKRMsWjH2aX8lNX2s4FqJfIeYTWTy05s0IpjEEwuk0mEBiUto
         RIBAPl6rxhZv/KRkL+RoqRaeUbOIkdkPx0VoZY0YnmpsqlxUZGvuvptJRD3CwNcmRj7v
         cSVy9F6a0cMzLQMuxsHCb196vV1gq7RBCLiFo+sd9ThswcOksRVKLzBvBBsAOJvu4plc
         CbS3jorMGhP1IsqLBoHYSV01J2Fd+0NLEllEPkU6V9vWDRaO78kB5aDvYlyQsBI6Unpn
         I4Ag==
X-Gm-Message-State: APjAAAX4t26gXsC6jh9lj1dulxySH3i2Kt7VIqK0XlnFYWrRLW2pNUJc
        0BmmamiKggmCHYpG3GbrBkiIt9d/VtCVO5y265R7K2tUXtoeDtnyAAbD626Ux/DLLnqXMWryTKC
        MGXXZdyGvD9hnQEZd
X-Received: by 2002:a19:6759:: with SMTP id e25mr18854002lfj.80.1571766307515;
        Tue, 22 Oct 2019 10:45:07 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyWaFofKCqI5Dh4lYpflNmAetMBkkoN5rdIx4shy+jTuAP5JoYEhNPwO1ylG1Uqw2N1zImLUw==
X-Received: by 2002:a19:6759:: with SMTP id e25mr18853990lfj.80.1571766307340;
        Tue, 22 Oct 2019 10:45:07 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id a18sm5692318lfi.15.2019.10.22.10.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 10:45:06 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BF9081804B1; Tue, 22 Oct 2019 19:45:05 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
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
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
In-Reply-To: <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com> <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch> <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com> <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 22 Oct 2019 19:45:05 +0200
Message-ID: <87h840oese.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: waoQBmpSMP2D07f1cb2T9w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> I think for sysadmins in general (not OVS) use case I would work
> with Jesper and Toke. They seem to be working on this specific
> problem.

We're definitely thinking about how we can make "XDP magically speeds up
my network stack" a reality, if that's what you mean. Not that we have
arrived at anything specific yet...

And yeah, I'd also be happy to discuss what it would take to make a
native XDP implementation of the OVS datapath; including what (if
anything) is missing from the current XDP feature set to make this
feasible. I must admit that I'm not quite clear on why that wasn't the
approach picked for the first attempt to speed up OVS using XDP...

-Toke

