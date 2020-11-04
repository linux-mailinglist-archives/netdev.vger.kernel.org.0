Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11EA42A607A
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 10:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgKDJ2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 04:28:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59417 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726434AbgKDJ2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 04:28:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604482112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IjLTjKXlCDXrw9S6rX2biZHmfLe4DCe+5yEr2yygy7A=;
        b=c1fPu0cbbWAKNVpg2caIcfPHX0G4AgZ+pzXL6t6tlEoUrkm+GtHsFuEMGs7s3+g7Rkq51y
        7YNRcIGURuE0WqljDFRSxgh/9W8Rgertr5sWOH3feudPImvngPitl324S0P0Yqyfw2l1WR
        ys4w715rjjvxZHe1DDvWkPdTgpPRl68=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-KA2r3GBOMUOuiuHpamXq3w-1; Wed, 04 Nov 2020 04:28:30 -0500
X-MC-Unique: KA2r3GBOMUOuiuHpamXq3w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA07757207;
        Wed,  4 Nov 2020 09:28:28 +0000 (UTC)
Received: from localhost (unknown [10.40.194.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AE645C1D0;
        Wed,  4 Nov 2020 09:28:17 +0000 (UTC)
Date:   Wed, 4 Nov 2020 10:28:16 +0100
From:   Jiri Benc <jbenc@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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
Message-ID: <20201104102816.472a9400@redhat.com>
In-Reply-To: <20201104024559.gxullc7e6boaupuk@ast-mbp.dhcp.thefacebook.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
        <20201029151146.3810859-1-haliu@redhat.com>
        <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
        <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
        <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
        <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
        <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
        <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
        <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
        <ce441cb4-0e36-eae6-ca19-efebb6fb55f1@gmail.com>
        <20201104024559.gxullc7e6boaupuk@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 18:45:59 -0800, Alexei Starovoitov wrote:
> libbpf is the only library I know that is backward and forward compatible.

This is great to hear. It means there will be no problem with iproute2
using the system libbpf. As libbpf is both backward and forward
compatible, iproute2 will just work with whatever version it is used
with.

> All other libraries are backwards compatible only.

Backward compatibility would be enough for iproute2 but forward
compatibility does not hurt, of course.

> The users can upgrade and downgrade libbpf version at any time.
> They can upgrade and downgrade kernel while keeping libbpf version the same.
> The users can upgrade llvm as well and libbpf has to expect unexpected
> and deal with all combinations.

This actually goes beyond what would be needed for iproute2 dynamically
linked against system libbpf.

> > How so? If libbpf is written against kernel APIs and properly versioned,
> > it should just work. A new version of libbpf changes the .so version, so
> > old commands will not load it.  
> 
> Please point out where do you see this happening in the patch set.
> See tools/lib/bpf/README.rst to understand the versioning.

If the iproute2 binaries are linked against a symbol of a newer version than
is available in the system libbpf (which should not really happen
unless the system is broken), the dynamic linker will refuse to load
it. If the binary is linked against an old version of a particular
symbol, that old version will be used, if it's still provided by the
library. Otherwise, it will not load. I don't see a problem here?

The only problem would be if a particular function changed its
semantics while retaining ABI. But since libbpf is backward and forward
compatible, this should not happen.

 Jiri

