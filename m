Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA6E8E63AB
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 16:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfJ0PVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 11:21:30 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42011 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726996AbfJ0PVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 11:21:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572189688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LsaLVyKdbpm6nEeF+BMRxdrAuNPhQ+esghjO+poSKeQ=;
        b=USkINlq11ZVyM5jr6/vWMIPsaJ69IYZi/LND6m1LW7vACi1jrouaoantWNhybnwIygigTk
        9eLJ70ksFSFy2fdYxr2c78JEwAQsPmO+kGiOsZHprYgc+c5TMDlRFPkX/zIa4ekPvFI0mr
        c0QlyIoxThRUIIUKLa+WLsG0WFY18Ek=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-HD5T9TLqPdSaBqGAq3fOew-1; Sun, 27 Oct 2019 11:21:27 -0400
Received: by mail-lf1-f72.google.com with SMTP id r21so1357139lff.1
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 08:21:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=MtfGITaRDzUY/+4h6Vxbvb6pbf08Pb4luPlPhypEp9I=;
        b=HN1dkZ13PiwHQpk5XX4ixCYpy0lUJkSY+N6sVKZayRW9/4IuC4iryj6V4Rlg/5HGTP
         m0dG6C54d2N8/7dwbVDZOiSvfJiT+kYiRLsKzCNXR0uURs7C/VkmTUZAApuFp989ZQnw
         sVcNi2Z+LfhdzIY3uEPQKXH95WD0FCBDId39QlqrqVggkpgr/N3wZ04/urtuTSEP9wuC
         49FAj6fS81nDJQ1BGoltPGgRZhCMNPliBY6DezmZnMZXOe2Km8DIE2aOS4vRW6DQoG65
         BobdLeR8xT3o6fYwwAHM8JIG5A4eV6CCD4CjU+XDSgm5Zaeld7pFyTg4OcUXsd0JmCtE
         IzCw==
X-Gm-Message-State: APjAAAUajEGIx06ewilPvW8EK+6HOMofjV6ZzBjufERaFr53+hvDx2Cu
        mmPo+eBvfVH1UE87mXu+UAdwMzNrSBISTS+AuVfkW4pox5ZvN22gj9PkhgC7MVyAS9hXuClxVuo
        bpkG8Yc0HujkiCrZn
X-Received: by 2002:a2e:b4e8:: with SMTP id s8mr8986726ljm.73.1572189685866;
        Sun, 27 Oct 2019 08:21:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxVLPJs2/APvcQtaAZRXGtd2dvvnV0IxBQKssQ5XAzEUetzhBKfeR9HKJUOmlkJ1sLyxpB1Mw==
X-Received: by 2002:a2e:b4e8:: with SMTP id s8mr8986716ljm.73.1572189685694;
        Sun, 27 Oct 2019 08:21:25 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id p193sm5249364lfa.18.2019.10.27.08.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 08:21:24 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BBFB41818B6; Sun, 27 Oct 2019 16:21:23 +0100 (CET)
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
In-Reply-To: <a7f3d86b-c83c-7b0d-c426-684b8dfe4344@gmail.com>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com> <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch> <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com> <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch> <87h840oese.fsf@toke.dk> <5db128153c75_549d2affde7825b85e@john-XPS-13-9370.notmuch> <87sgniladm.fsf@toke.dk> <a7f3d86b-c83c-7b0d-c426-684b8dfe4344@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 27 Oct 2019 16:21:23 +0100
Message-ID: <87zhhmrz7w.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: HD5T9TLqPdSaBqGAq3fOew-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toshiaki Makita <toshiaki.makita1@gmail.com> writes:

>> Yeah, you are right that it's something we're thinking about. I'm not
>> sure we'll actually have the bandwidth to implement a complete solution
>> ourselves, but we are very much interested in helping others do this,
>> including smoothing out any rough edges (or adding missing features) in
>> the core XDP feature set that is needed to achieve this :)
>
> I'm very interested in general usability solutions.
> I'd appreciate if you could join the discussion.
>
> Here the basic idea of my approach is to reuse HW-offload infrastructure=
=20
> in kernel.
> Typical networking features in kernel have offload mechanism (TC flower,=
=20
> nftables, bridge, routing, and so on).
> In general these are what users want to accelerate, so easy XDP use also=
=20
> should support these features IMO. With this idea, reusing existing=20
> HW-offload mechanism is a natural way to me. OVS uses TC to offload=20
> flows, then use TC for XDP as well...

I agree that XDP should be able to accelerate existing kernel
functionality. However, this does not necessarily mean that the kernel
has to generate an XDP program and install it, like your patch does.
Rather, what we should be doing is exposing the functionality through
helpers so XDP can hook into the data structures already present in the
kernel and make decisions based on what is contained there. We already
have that for routing; L2 bridging, and some kind of connection
tracking, are obvious contenders for similar additions.

-Toke

