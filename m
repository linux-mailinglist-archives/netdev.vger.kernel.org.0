Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BC62A91B1
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 09:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgKFIou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 03:44:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38098 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726632AbgKFIou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 03:44:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604652288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DT/PsucpA6dWIy6yN3m+MGrO9uGGY4UCT/lAMkVwp7I=;
        b=WvS40asB2Qghn0gUq4ac7y3wJainMMhNRAgJwVTLau5ywAkGoXus1nBtqWrNmtO9NwlBbj
        dp7nSySuVn8yTKHcnA6C98Vq8JKh9cGBI7ee86G45lVeg85vlTj1IfBL2feO0HR61jAzO9
        um73ow22wfN5Kl22NOc1Ztwj61fMRsE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-Fli1WwA1N--MyKGNLQn3hQ-1; Fri, 06 Nov 2020 03:44:46 -0500
X-MC-Unique: Fli1WwA1N--MyKGNLQn3hQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9738D107B29E;
        Fri,  6 Nov 2020 08:44:31 +0000 (UTC)
Received: from localhost (unknown [10.40.193.217])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C90D5D9CA;
        Fri,  6 Nov 2020 08:44:26 +0000 (UTC)
Date:   Fri, 6 Nov 2020 09:44:25 +0100
From:   Jiri Benc <jbenc@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201106094425.5cc49609@redhat.com>
In-Reply-To: <CAEf4BzaSfutBt3McEPjmu_FyxyzJa_xVGfhP_7v0oGuqG_HBEw@mail.gmail.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
        <20201029151146.3810859-1-haliu@redhat.com>
        <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
        <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
        <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
        <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
        <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
        <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
        <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
        <20201104021730.GK2408@dhcp-12-153.nay.redhat.com>
        <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
        <bb04a01a-8a96-7a6a-c77e-28ee63983d9a@solarflare.com>
        <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
        <07f149f6-f8ac-96b9-350d-b289ef16d82f@solarflare.com>
        <CAEf4BzaSfutBt3McEPjmu_FyxyzJa_xVGfhP_7v0oGuqG_HBEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 12:19:00 -0800, Andrii Nakryiko wrote:
> I'll just quote myself here for your convenience.

Sorry, I missed your original email for some reason.

>   Submodule is a way that I know of to make this better for end users.
>   If there are other ways to pull this off with shared library use, I'm
>   all for it, it will save the security angle that distros are arguing
>   for. E.g., if distributions will always have the latest libbpf
>   available almost as soon as it's cut upstream *and* new iproute2
>   versions enforce the latest libbpf when they are packaged/released,
>   then this might work equivalently for end users. If Linux distros
>   would be willing to do this faithfully and promptly, I have no
>   objections whatsoever. Because all that matters is BPF end user
>   experience, as Daniel explained above.

That's basically what we already do, for both Fedora and RHEL.

Of course, it follows the distro release cycle, i.e. no version
upgrades - or very limited ones - during lifetime of a particular
release. But that would not be different if libbpf was bundled in
individual projects.

 Jiri

