Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8004333CF
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbhJSKtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 06:49:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21672 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234955AbhJSKtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 06:49:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634640410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4nrLBM3NsQieUDKXr4P0L2GzipRr5/UzD7TwlBZ4Zvc=;
        b=YicDyOqZsVv+fB1RHvjgqbaETkjsszKvEdX1024PiXVpO1lD+5a9PvMy9beTX4dPndhhIo
        jERcCtFFkSLsPupLRuMeNWb+db+TAVc+CnU59w/tJgZxQ2iHxRDp+wbeAXz0JvkBB5q/Q5
        hNZO4YOVRejmaLXOEdk1AKTXXk+H4lE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-U203GhikNxm4oodBerQ3tQ-1; Tue, 19 Oct 2021 06:46:49 -0400
X-MC-Unique: U203GhikNxm4oodBerQ3tQ-1
Received: by mail-ed1-f71.google.com with SMTP id d3-20020a056402516300b003db863a248eso17167462ede.16
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 03:46:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=4nrLBM3NsQieUDKXr4P0L2GzipRr5/UzD7TwlBZ4Zvc=;
        b=EpHzqSY8qp/JdBaCvoPgAIqGF2nGfFQp+Z8CiAp47XgZnhxQLZSOGcPIIx1HVU2Bqi
         4WOutwpfjZSxxY2tZSkbyXOPN/2K7yegijFH3GHE9I/jGTRVelExSJT3OY9MrtcFKcoU
         hAmFj50naTWW34J9cJ1OeD1GEy8G+TEQDLxegtdrkNDy8ExESplCSbHBZ7k9hWybNYFl
         0HeE0fAshS+s5lmySHLBFkT/CkedMorL9Wx9xO0BFyMsoDjF5O6i50DMDmS50RhYQ+la
         10leedDW/rVyCcNTVtAjyTVwYYGNSWn3hTrMn4b/y/4Z9yjxjoE2yx41UFeMpx4zukn1
         zUxg==
X-Gm-Message-State: AOAM530HvpqHPZ54Gdq2uV9I0iKI64odEv5qVoVow5DL65u1ZVAnIAhf
        V9Tk6WOx5Y0WDhln8RDoL+JQRxTrkeU8hBiQWQejpcPt6QS9mrCuCKSTLgMK+ONOo3xqtjVoah1
        rFvEXQBrKu+mf0E/n
X-Received: by 2002:a17:906:a08d:: with SMTP id q13mr36552880ejy.465.1634640407838;
        Tue, 19 Oct 2021 03:46:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxT8fm6ezbb3raDRutQqjr7VIr9M/xHyv8QHqBGGrw0o3cMH1m/KQ1MnNTQgUO8x4wbG3D17Q==
X-Received: by 2002:a17:906:a08d:: with SMTP id q13mr36552801ejy.465.1634640406922;
        Tue, 19 Oct 2021 03:46:46 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id p23sm11996272edw.94.2021.10.19.03.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 03:46:46 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AEAE3180263; Tue, 19 Oct 2021 12:46:44 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH net-next 2/2] net: sched: remove one pair of atomic
 operations
In-Reply-To: <20211019003402.2110017-3-eric.dumazet@gmail.com>
References: <20211019003402.2110017-1-eric.dumazet@gmail.com>
 <20211019003402.2110017-3-eric.dumazet@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 19 Oct 2021 12:46:44 +0200
Message-ID: <87y26pguln.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:

> From: Eric Dumazet <edumazet@google.com>
>
> __QDISC_STATE_RUNNING is only set/cleared from contexts owning qdisc lock.
>
> Thus we can use less expensive bit operations, as we were doing
> before commit f9eb8aea2a1e ("net_sched: transform qdisc running bit into =
a seqcount")
>
> Fixes: 29cbcd858283 ("net: sched: Remove Qdisc::running sequence counter")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Ahmed S. Darwish <a.darwish@linutronix.de>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Tested-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

