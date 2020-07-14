Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BAB21F340
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 15:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgGNN52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 09:57:28 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41433 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728095AbgGNN50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 09:57:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594735044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZBinmgwxUJlj0oYqhR2BRvHslB/E0uckUbNPpgAvrHM=;
        b=Z7L922esmXKE2Izq8Uu8cZxyezuky3NUV+uSPMyzNTVpoveeN2jaYghYNWRNqs8F3kbVmk
        KWOetvHto9nR3Awl0cRo0xJJtugcBCbiKA3wxbc23yX7K5voLcS8jESo9VwZ+tGuJtB5/B
        rDnAZ7h4AnfHA35SDVB+7iXyjgBfAeo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-cJeUSPF8MaiDzJNcJIXrcw-1; Tue, 14 Jul 2020 09:57:22 -0400
X-MC-Unique: cJeUSPF8MaiDzJNcJIXrcw-1
Received: by mail-wm1-f72.google.com with SMTP id g124so4105521wmg.6
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:57:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ZBinmgwxUJlj0oYqhR2BRvHslB/E0uckUbNPpgAvrHM=;
        b=bZqYffr5Es5wW7qR+ysVhaSxToPPRY6UgVzWad1t4vVKuYMnpwQKD0e2/YwVmvoQ4d
         YYdpFCJj8NF6okt7CZTN08jlySenKC1eVO7mexFzI9BlTTJ6bjG5Bnp5G1e413dhm310
         JYZDnA+2TBbvooQJXtZzpmY9iZOmiW+ABrDzS0KOUEFBzqDmN5X90mmTZYtFojvhdvJx
         Uz0Ued7nilRfJp1eY9JSU17/FjOGHJGBx0yctjAifa/03Pg2K8LGAm6tXECJ4vZBzOGG
         5NJBLm9xQoXnx5TWtUgZto/UlieZv9MCp9OEwDJczFJUJtbkPeWhrQt9BpuDbQjPBO+8
         rQxw==
X-Gm-Message-State: AOAM530835ZGBuokg8aK0yaR24x0LoN7t+ME7I+i5FcNkg2PMCHReYht
        4zRTm30lD4tfKdVyFOqaP+2CoGS2FeEbqgq8noyxLw2LLrwOll+dcKLwv5a5xvrGoTG036oG7/r
        Y444TOQwyGjBMabU5
X-Received: by 2002:adf:ec90:: with SMTP id z16mr5724561wrn.52.1594735041471;
        Tue, 14 Jul 2020 06:57:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8nyShzr50LWR0kfVtYp25AKUucCrNZUcCDwG03fM+BsRRR8/Xztl5Oy91ZYK3cZacgFcXvw==
X-Received: by 2002:adf:ec90:: with SMTP id z16mr5724514wrn.52.1594735041183;
        Tue, 14 Jul 2020 06:57:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id y7sm28719976wrt.11.2020.07.14.06.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 06:57:20 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 406F51804F0; Tue, 14 Jul 2020 15:57:18 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kicinski@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Takshak Chahande <ctakshak@fb.com>
Subject: Re: [PATCH bpf-next 2/7] bpf, xdp: add bpf_link-based XDP attachment API
In-Reply-To: <20200710224924.4087399-3-andriin@fb.com>
References: <20200710224924.4087399-1-andriin@fb.com> <20200710224924.4087399-3-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 14 Jul 2020 15:57:18 +0200
Message-ID: <877dv6gpxd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> Add bpf_link-based API (bpf_xdp_link) to attach BPF XDP program through
> BPF_LINK_CREATE command.

I'm still not convinced this is a good idea. As far as I can tell, at
this point adding this gets you three things:

1. The ability to 'lock' an attachment in place.

2. Automatic detach on fd close

3. API unification with other uses of BPF_LINK_CREATE.


Of those, 1. is certainly useful, but can be trivially achieved with the
existing netlink API (add a flag on attach that prevents removal unless
the original prog_fd is supplied as EXPECTED_FD).

2. is IMO the wrong model for XDP, as I believe I argued the last time
we discussed this :)
In particular, in a situation with multiple XDP programs attached
through a dispatcher, the 'owner' application of each program don't
'own' the interface attachment anyway, so if using bpf_link for that it
would have to be pinned somewhere anyway. So the 'automatic detach'
feature is only useful in the "xdpd" deployment scenario, whereas in the
common usage model of command-line attachment ('ip link set xdp...') it
is something that needs to be worked around.

3. would be kinda nice, I guess, if we were designing the API from
scratch. But we already have an existing API, so IMO the cost of
duplication outweighs any benefits of API unification.

So why is XDP worth it? I assume you weigh this differently, but please
explain how. Ideally, this should have been in the commit message
already...

> bpf_xdp_link is mutually exclusive with direct BPF program attachment,
> previous BPF program should be detached prior to attempting to create a new
> bpf_xdp_link attachment (for a given XDP mode). Once link is attached, it
> can't be replaced by other BPF program attachment or link attachment. It will
> be detached only when the last BPF link FD is closed.

I was under the impression that forcible attachment of bpf_links was
already possible, but looking at the code now it doesn't appear to be?
Wasn't that the whole point of BPF_LINK_GET_FD_BY_ID? I.e., that a
sysadmin with CAP_SYS_ADMIN privs could grab the offending bpf_link FD
and force-remove it? I certainly think this should be added before we
expand bpf_link usage any more...

-Toke

