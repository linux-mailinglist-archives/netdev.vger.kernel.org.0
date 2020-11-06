Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639222A91EB
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 10:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgKFJAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 04:00:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44488 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725835AbgKFJAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 04:00:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604653224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=he4A2qRDDhagMH7Jn8XWRMdBJcrftH5FW7crWt5oWTM=;
        b=HFGq7pS04UuS5dzwo4F1E2G//B2D8r+p8N09HCbqI3tVr1Hf1vcgiOSBLTBop4A8LWD9GM
        yrIdjcbB3MfGPV+PlxzT3OhnKFQOjk3dRoEoh1JyKChkJSNcWORXqT0adz86TTz174+9tL
        W4Ga2N2ThIy8pK2Y2Y4jak7La3MvXow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-WqMMeZOqOv2O7JDkEdZiHg-1; Fri, 06 Nov 2020 04:00:20 -0500
X-MC-Unique: WqMMeZOqOv2O7JDkEdZiHg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E207188C124;
        Fri,  6 Nov 2020 09:00:18 +0000 (UTC)
Received: from localhost (unknown [10.40.193.217])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EE00F19D6C;
        Fri,  6 Nov 2020 09:00:08 +0000 (UTC)
Date:   Fri, 6 Nov 2020 10:00:07 +0100
From:   Jiri Benc <jbenc@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
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
Message-ID: <20201106100007.10049857@redhat.com>
In-Reply-To: <CAEf4BzbQz5ZqoB3TEtM-4e=Ndx9WCGN16Be8-JoK+mvUyAGC3w@mail.gmail.com>
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
        <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net>
        <ec50328d-61ab-71fb-f266-5e49e9dbf98e@gmail.com>
        <CAEf4BzbQz5ZqoB3TEtM-4e=Ndx9WCGN16Be8-JoK+mvUyAGC3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 12:45:39 -0800, Andrii Nakryiko wrote:
> That's not true. If you need new functionality like BTF, CO-RE,
> function-by-function verification, etc., then yes, you have to update
> kernel, compiler, libbpf, sometimes pahole. But if you have an BPF
> application that doesn't use and need any of the newer features, it
> will keep working just fine with the old kernel, old libbpf, and old
> compiler.

I'm fine with this.

It doesn't work that well in practice, we've found ourselves chasing
problems caused by llvm update (problems for older bpf programs, not
new ones), problems on non-x86_64 caused by kernel updates, etc. It can
be attributed to living on the edge and it should stabilize over time,
hopefully. But it's still what the users are experiencing and it's
probably what David is referring to. I expect it to smooth itself over
time.

Add to that the fact that something that is in fact a new feature is
perceived as a bug fix by some users. For example, a perfectly valid
and simple C program, not using anything shiny but a basic simple loop,
compiles just fine but is rejected by the kernel. A newer kernel and a
newer compiler and a newer libbpf and a newer pahole will cause the
same program to be accepted. Now, the user does not see that for this,
a new load of BTF functionality had to be added and all those mentioned
projects enhanced with substantial code. All they see is their simple
hello world test program did not work and now it does.

I'm not saying I have a solution nor I'm saying you should do something
about it. Just trying to explain the perception.

 Jiri

