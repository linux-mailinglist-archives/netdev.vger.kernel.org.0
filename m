Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA111F4777
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 21:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731735AbgFITrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 15:47:55 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22255 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731710AbgFITry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 15:47:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591732072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xB1oD9kpoB9pl4KWasJnll/v8m3IdFvCXccjs79r90A=;
        b=Y+pODCoOgepihoCAV2Y+UAH+cCeVh4YpmbHHc1gc5gTk4tRJVK7ag2ODW39fVEiPgxJ6Vl
        3psoJ3ksexiuttjtxecnDCMvfUfWBCIjdHKbWtlCirF38HwvgvMxxyrIQHgG1wK5O4CQbl
        OOlbq8oQmwrwG3ld+L7ltBpHxMtgbPU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-m599dA6bONumsBGiETV6Hg-1; Tue, 09 Jun 2020 15:47:49 -0400
X-MC-Unique: m599dA6bONumsBGiETV6Hg-1
Received: by mail-ed1-f69.google.com with SMTP id x3so8300775eds.14
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 12:47:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=xB1oD9kpoB9pl4KWasJnll/v8m3IdFvCXccjs79r90A=;
        b=eBLBgN/CNKDdxzVmKoj4HrdBb9SWIf1c63ywN3lIxTlOmi+TAiCFnvkY1x9f/DlGxq
         qtkrYtZ4ojpIH7yAfwBht4cXXJWd+QzcZV8dxiviU5a2GdEbo+p6PFg2uIxnvTm0+oly
         5La1wALr7u8a6is8sp/MjL84E1oJ7cS/IdujbKegF3Mq8VfUxvo5DK+mJXls/dtnum6B
         E8LXrMtXk7/mExVrbkTaNX/XCpNw4uotfksjeXPkT3D2IhNhjUWUz1Il7O3Cm9lyZe8C
         DwopUlsBDcct4jZA45NobfXS35Db7kJ9RrhqZSk0Aibq8/zt/GfJGgL6dHGbVUUyXn4I
         e5nw==
X-Gm-Message-State: AOAM530Sgkug/nBVPjGJffEfZGNcI04HQDQULlCmsPdeW9IHQHSPjJ7f
        hRdG05xrUWWoCCdeOL6c/C72C0sG6ceiJqS2ZtfNrMS9tg9tikF0M/IFzeocy35p0JSMjWqhytQ
        +Sm67o3hkHAtzQ2Kx
X-Received: by 2002:a17:906:1d55:: with SMTP id o21mr26230173ejh.491.1591732068630;
        Tue, 09 Jun 2020 12:47:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyf1sNKkLWeyTjzQSEoqtchZN5z8CNGMjaxb4kfu1oo54GerCMlQme8NBryBKoVoCUZzk2NIA==
X-Received: by 2002:a17:906:1d55:: with SMTP id o21mr26230158ejh.491.1591732068366;
        Tue, 09 Jun 2020 12:47:48 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id p6sm13932648ejb.71.2020.06.09.12.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 12:47:47 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0A9B8180654; Tue,  9 Jun 2020 21:47:47 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        brouer@redhat.com, maciej.fijalkowski@intel.com
Subject: Re: [RFC PATCH bpf-next 2/2] i40e: avoid xdp_do_redirect() call when "redirect_tail_call" is set
In-Reply-To: <20200609172622.37990-3-bjorn.topel@gmail.com>
References: <20200609172622.37990-1-bjorn.topel@gmail.com> <20200609172622.37990-3-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 09 Jun 2020 21:47:46 +0200
Message-ID: <87r1uo81i5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> If an XDP program, where all the bpf_redirect_map() calls are tail
> calls (as defined by the previous commit), the driver does not need to
> explicitly call xdp_do_redirect().
>
> The driver checks the active XDP program, and notifies the BPF helper
> indirectly via xdp_set_redirect_tailcall().
>
> This is just a naive, as-simple-as-possible implementation, calling
> xdp_set_redirect_tailcall() for each packet.

Do you really need the driver changes? The initial setup could be moved
to bpf_prog_run_xdp(), and xdp_do_redirect() could be changed to an
inline wrapper that just checks a flag and immediately returns 0 if the
redirect action was already performed. Or am I missing some reason why
this wouldn't work?

-Toke

