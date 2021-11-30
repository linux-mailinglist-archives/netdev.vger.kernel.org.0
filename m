Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EDE463AD7
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 17:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243005AbhK3QEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 11:04:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20561 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230185AbhK3QEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 11:04:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638288052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3xvWJ05rDVJlEI37bM9I9CFoclSIgoKtEqO80qhVKPA=;
        b=TeMq+Dat9tkZybZrfLcJ5NHbolo41ofOVH1Tpk646oyMJP8GQX2zuyFiM7XiY9Q9kBnLYd
        wIksJOFo5mUuFrsHMx1x5JCMi69FfHtwm2wMyW2HxbTieUaWPDLX9asc6VIdOavVo9B87g
        ypCt2zXUJf3+GCekidOoB6Q/C6sbpRM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-289-Y4OK31yvO6yll4HnjvdiVw-1; Tue, 30 Nov 2021 11:00:49 -0500
X-MC-Unique: Y4OK31yvO6yll4HnjvdiVw-1
Received: by mail-ed1-f70.google.com with SMTP id t9-20020aa7d709000000b003e83403a5cbso17382976edq.19
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 08:00:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=3xvWJ05rDVJlEI37bM9I9CFoclSIgoKtEqO80qhVKPA=;
        b=n4rdY6YwVGWH+oD9vVMWA4FUQdlg744qNzBhIBq4qItsRsu0BlKCEpIzdbQ5qexcHS
         Jkq/jL5Qovaa15bo6IIa1vWnxir9bIo4OK/c1DUJJofgh3aoSLNtHSaDgcfP1IjKh27N
         zTJqIGfup6i5Eb4hXczivZp+XJyp+MsI6TGH9GG7JLBIyfiyB9Hq55JYTAiv4HIyU+NG
         yk4dUovgoljweOxKn2BL1y7CQfyc1QLH1zs7dg8pMmAyMspD43Yzdlzhq6oA7gLABrfa
         wKKgZUiSe+2MaG4ggcumrEPWt9+vo+mUT2hZNz6lVX322q9KJHYlh6B1XVGtb3V1/Y3r
         t2wA==
X-Gm-Message-State: AOAM531d7xueuN2wFyCXcUIZ4Q9Cm+cG/6xU2eqCIf4DmjQyyjRHnXiK
        Wu60U003kS+x2pCPV389G9w/WtzA22NgrRo53Xq2703QCuRjflkBXS4D4tvIdTQ2YTS554Cmddt
        KTmLZNzF3ZVsjsXEe
X-Received: by 2002:a17:907:d17:: with SMTP id gn23mr67412055ejc.25.1638288048317;
        Tue, 30 Nov 2021 08:00:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwCQoQaHvKD5TqMaO0KA+5raYgBz0M/C7dgcKuQ1dX7Frr5ECe9FkilwSFgvBdLGBlZzoFiOA==
X-Received: by 2002:a17:907:d17:: with SMTP id gn23mr67411996ejc.25.1638288047977;
        Tue, 30 Nov 2021 08:00:47 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id go10sm9506400ejc.115.2021.11.30.08.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 08:00:46 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 001D01802A0; Tue, 30 Nov 2021 17:00:45 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org,
        davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Hangbin Liu <liuhangbin@gmail.com>, Xiumei Mu <xmu@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH net 06/10] wireguard: device: reset peer src endpoint
 when netns exits
In-Reply-To: <20211129153929.3457-7-Jason@zx2c4.com>
References: <20211129153929.3457-1-Jason@zx2c4.com>
 <20211129153929.3457-7-Jason@zx2c4.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 30 Nov 2021 17:00:45 +0100
Message-ID: <874k7t8wgi.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> Each peer's endpoint contains a dst_cache entry that takes a reference
> to another netdev. When the containing namespace exits, we take down the
> socket and prevent future sockets from being created (by setting
> creating_net to NULL), which removes that potential reference on the
> netns. However, it doesn't release references to the netns that a netdev
> cached in dst_cache might be taking, so the netns still might fail to
> exit. Since the socket is gimped anyway, we can simply clear all the
> dst_caches (by way of clearing the endpoint src), which will release all
> references.
>
> However, the current dst_cache_reset function only releases those
> references lazily. But it turns out that all of our usages of
> wg_socket_clear_peer_endpoint_src are called from contexts that are not
> exactly high-speed or bottle-necked. For example, when there's
> connection difficulty, or when userspace is reconfiguring the interface.
> And in particular for this patch, when the netns is exiting. So for
> those cases, it makes more sense to call dst_release immediately. For
> that, we add a small helper function to dst_cache.
>
> This patch also adds a test to netns.sh from Hangbin Liu to ensure this
> doesn't regress.
>
> Test-by: Hangbin Liu <liuhangbin@gmail.com>
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Cc: Hangbin Liu <liuhangbin@gmail.com>
> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Fixes: 900575aa33a3 ("wireguard: device: avoid circular netns references")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

