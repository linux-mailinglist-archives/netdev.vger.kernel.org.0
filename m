Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400A03760FA
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 09:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbhEGHLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 03:11:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55251 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235147AbhEGHK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 03:10:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620371400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mHFmcONkXExZESpq4UoLZEwTMca0lsijd9NH0tbhjEQ=;
        b=YG/OQ0FYKVUHhw42GnjO0zgLIIpu9DhLpkkx4awuvxJlXGU7D76oPScrEr0ZXukopEyWPC
        gM6nIYUhrOUTxf4osLbP4cj4lVZMFyvh6LJWgr+moFZhgPaldHeUmV/Lf6DrMvnTI3lCxy
        tBqlaksmyzweH2RwRCE6O+yKCX6YZ+k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-m_5erc8tN4OfX8b4AaS8ng-1; Fri, 07 May 2021 03:09:56 -0400
X-MC-Unique: m_5erc8tN4OfX8b4AaS8ng-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 485B31008060;
        Fri,  7 May 2021 07:09:54 +0000 (UTC)
Received: from oldenburg.str.redhat.com (ovpn-112-137.ams2.redhat.com [10.36.112.137])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6449E10016F9;
        Fri,  7 May 2021 07:09:45 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Michal =?utf-8?Q?Such=C3=A1nek?= <msuchanek@suse.de>,
        Jiri Olsa <jolsa@redhat.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: linux-next failing build due to missing cubictcp_state symbol
References: <316e86f9-35cc-36b0-1594-00a09631c736@fb.com>
        <20210423175528.GF6564@kitsune.suse.cz>
        <20210425111545.GL15381@kitsune.suse.cz>
        <20210426113215.GM15381@kitsune.suse.cz>
        <20210426121220.GN15381@kitsune.suse.cz>
        <20210426121401.GO15381@kitsune.suse.cz>
        <49f84147-bf32-dc59-48e0-f89241cf6264@fb.com> <YIbkR6z6mxdNSzGO@krava>
        <YIcRlHQWWKbOlcXr@krava> <20210427121237.GK6564@kitsune.suse.cz>
        <20210430174723.GP15381@kitsune.suse.cz>
        <3d148516-0472-8f0a-085b-94d68c5cc0d5@suse.com>
        <6c14f3c8-7474-9f3f-b4a6-2966cb19e1ed@kernel.org>
Date:   Fri, 07 May 2021 09:10:05 +0200
In-Reply-To: <6c14f3c8-7474-9f3f-b4a6-2966cb19e1ed@kernel.org> (Jiri Slaby's
        message of "Mon, 3 May 2021 08:11:50 +0200")
Message-ID: <87lf8rf29e.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Jiri Slaby:

> The dot makes the difference, of course. The question is why is it
> there? I keep looking into it. Only if someone has an immediate
> idea...

We see the failure on aarch64 as well, with 8404c9fbc84b741
(from Linus' tree).

As far as I can tell, the core issue is that BTF_ID is applied to a
symbol which is defined as static on the C side (and even in a different
translation unit, but this aspect doesn't really matter).  The compiler
can and will change symbol names, calling conventions and data layout
for static functions/variables, so this is never going to work reliably.
It is possible to inhibit these optimizations by using __attribute__
((used)).  But I'm pretty sure that BTF generation fails to work
properly if there are symbol name collisions, so I think it's better to
drop the static and rely on duplicate symbol checks from the linker
(which of course does not happen for C entities declared static).

Thanks,
Florian

