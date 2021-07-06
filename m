Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776ED3BDF16
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 23:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhGFVrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 17:47:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34543 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229811AbhGFVrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 17:47:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625607876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XwnIbM427oR/65dd6Qq3FeqQhr5cMU/5n4IUb56RPqo=;
        b=UxNG+WiYSI7aeOKgLj1WeRlxnI7i+ncF6ZHVeBOyY6lIqfFILkwbh/uYpntJ5mw20NHSFl
        mR1yJ0912sgKVW/RZ1wfwmt/sDg0aRDjFiYCb0iNiMw9DYTK+vAgYBgJGhJJ0Lgkih92a/
        e1tT2g5cGQYV27zrVsPYvATKQ2yQhgg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-CCiAZtyqOnqwRUO9zdemMQ-1; Tue, 06 Jul 2021 17:44:35 -0400
X-MC-Unique: CCiAZtyqOnqwRUO9zdemMQ-1
Received: by mail-ed1-f72.google.com with SMTP id f20-20020a0564020054b0290395573bbc17so195320edu.19
        for <netdev@vger.kernel.org>; Tue, 06 Jul 2021 14:44:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=XwnIbM427oR/65dd6Qq3FeqQhr5cMU/5n4IUb56RPqo=;
        b=juEgINiM5hCjtcn/EQTW+mHzAiUFFMmTEDxNuPdf65eIaSIeDIsDSoDYA8TdtAuT8v
         b/5VwHvKRnTTI/gboEpe6x2gG4z+I/KVvRDRtEz5eg9JWi1doG54f4QcqPvhS0+9ya6o
         QUydoeNFutOpfNMSsh79Uya1ZOqkSdUaVgwPEVnxSh5xkWZRJnc1rXnCEcu71DP1GK05
         QYNnfXz5x++D4W69zJCSnJi+BGodMDxxdMUKWzam6vVKDHziRFMKN6I9/qAr5VJL7dMC
         7YtFkJ9rqjq8oOl5wJe8xTQPGNAzRXAA+P3D1dzTDQTU4vtP9PMR6Wj0fmixl76Tpv1N
         vrmw==
X-Gm-Message-State: AOAM533iXevm5zmlgrgtRlbKJfcESuKIzWc7nZXPKz75qxOiz4v0eOZd
        pNyYVD6MrS4JsFyYVRfvriqVIgnuLEcknZqldoWIndjFeMUc3rbMLxqZH+3FuoW7giISlQ+vfka
        0H5gfoDcBznKXE4fq
X-Received: by 2002:a05:6402:308f:: with SMTP id de15mr25613258edb.151.1625607873789;
        Tue, 06 Jul 2021 14:44:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTylF9xQ4eYo13dNnGtIF9XDses/N8lwWMln+Lkr4vVHBOs+X83jp79QUNe8gtcKtSYr7GOA==
X-Received: by 2002:a05:6402:308f:: with SMTP id de15mr25613247edb.151.1625607873579;
        Tue, 06 Jul 2021 14:44:33 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id l14sm6143571ejx.103.2021.07.06.14.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 14:44:33 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4FCE118072E; Tue,  6 Jul 2021 23:44:32 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, dsahern@kernel.org,
        brouer@redhat.com, jasowang@redhat.com, alexander.duyck@gmail.com,
        saeed@kernel.org, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, tirthendu.sarkar@intel.com
Subject: Backwards compatibility for XDP multi-buff (was: Re: [PATCH v9
 bpf-next 08/14] bpf: add multi-buff support to the bpf_xdp_adjust_tail()
 API)
In-Reply-To: <60d495a914773_2e84a2082d@john-XPS-13-9370.notmuch>
References: <cover.1623674025.git.lorenzo@kernel.org>
 <863f4934d251f44ad85a6be08b3737fac74f9b5a.1623674025.git.lorenzo@kernel.org>
 <60d2744ee12c2_1342e208f7@john-XPS-13-9370.notmuch>
 <4F52EE5B-1A3F-46CE-9A39-98475CA6B684@redhat.com>
 <60d495a914773_2e84a2082d@john-XPS-13-9370.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 06 Jul 2021 23:44:32 +0200
Message-ID: <8735srxglb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changing the subject to address this point specifically:

> Right that was my conclusion as well. Existing programs might have
> subtle side effects if they start running on multibuffer drivers as
> is. I don't have any good ideas though on how to handle this.

So I had a chat about this with Lorenzo, Eelco and Jesper today, and
promised I'd summarise our discussion to you all, so this is my attempt
at that. Please excuse the long email, I'm just trying to be
comprehensive :)

So first off, a problem description: If an existing XDP program is
exposed to an xdp_buff that is really a multi-buffer, it may end up with
subtle and hard-to-debug bugs: If it's parsing the packet it'll only see
part of the payload and not be aware of that fact, and if it's
calculating the packet length, that will also only be wrong (only
counting the first fragment).

So what to do about this? First of all, to do anything about it, XDP
programs need to be able to declare themselves "multi-buffer aware" (but
see point 1 below). We could try to auto-detect it in the verifier by
which helpers the program is using, but since existing programs could be
perfectly happy to just keep running, it probably needs to be something
the program communicates explicitly. One option is to use the
expected_attach_type to encode this; programs can then declare it in the
source by section name, or the userspace loader can set the type for
existing programs if needed.

With this, the kernel will know if a given XDP program is multi-buff
aware and can decide what to do with that information. For this we came
up with basically three options:

1. Do nothing. This would make it up to users / sysadmins to avoid
   anything breaking by manually making sure to not enable multi-buffer
   support while loading any XDP programs that will malfunction if
   presented with an mb frame. This will probably break in interesting
   ways, but it's nice and simple from an implementation PoV. With this
   we don't need the declaration discussed above either.

2. Add a check at runtime and drop the frames if they are mb-enabled and
   the program doesn't understand it. This is relatively simple to
   implement, but it also makes for difficult-to-understand issues (why
   are my packets suddenly being dropped?), and it will incur runtime
   overhead.

3. Reject loading of programs that are not MB-aware when running in an
   MB-enabled mode. This would make things break in more obvious ways,
   and still allow a userspace loader to declare a program "MB-aware" to
   force it to run if necessary. The problem then becomes at what level
   to block this?

   Doing this at the driver level is not enough: while a particular
   driver knows if it's running in multi-buff mode, we can't know for
   sure if a particular XDP program is multi-buff aware at attach time:
   it could be tail-calling other programs, or redirecting packets to
   another interface where it will be processed by a non-MB aware
   program.

   So another option is to make it a global toggle: e.g., create a new
   sysctl to enable multi-buffer. If this is set, reject loading any XDP
   program that doesn't support multi-buffer mode, and if it's unset,
   disable multi-buffer mode in all drivers. This will make it explicit
   when the multi-buffer mode is used, and prevent any accidental subtle
   malfunction of existing XDP programs. The drawback is that it's a
   mode switch, so more configuration complexity.

None of these options are ideal, of course, but I hope the above
explanation at least makes sense. If anyone has any better ideas (or can
spot any flaws in the reasoning above) please don't hesitate to let us
know!

-Toke

