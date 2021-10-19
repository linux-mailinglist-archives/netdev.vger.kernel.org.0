Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949434333CE
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235169AbhJSKsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 06:48:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21824 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234955AbhJSKsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 06:48:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634640355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IOIrnUCgcBjKXFiXRIqm2rDh9PAyHLLkpoh/3VTjQps=;
        b=A/Cgsrsub0VFPk7Jk/dtU8OYfrvDAkLcaJlWQKbTvmn313MyPCw4Yeo/1Gh/eyHrlBs/DN
        8NeIvKU1Hp+TP4MgDY/yolyYqspQ4Ye/VnVs28dvB8pJ8W84ZFJYluJy2SPry3K9ZObJlH
        ankbKeok8x3cKcuWrDX09sjUvObgPFU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-pAOCBF-_Nh6aEYB_EeVqZA-1; Tue, 19 Oct 2021 06:45:53 -0400
X-MC-Unique: pAOCBF-_Nh6aEYB_EeVqZA-1
Received: by mail-ed1-f70.google.com with SMTP id u23-20020a50a417000000b003db23c7e5e2so17216728edb.8
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 03:45:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=IOIrnUCgcBjKXFiXRIqm2rDh9PAyHLLkpoh/3VTjQps=;
        b=lINHUzBRmHqf2Xjc40Kpk3AMpA6vwehDM9eWAlna7WPV2rMMpkzlyJV6IDZst2PRPf
         PUGeRCHfXYzZdQjI5wJYUH3oIpLV1jdARDDh/p4rqEs+kazUfA9Sl2xllC+cJjeA631u
         4U4Cc/4cNC0baY8J/i06xLSiD3Azyp7SzEWsbsVHiwyblp6ienEVhRLy+CgGW9zKeaSM
         Fk5fDqkRsTCa+IudJOb+CpxiNnAjLkn0CHrvnKLYtwcSBFsXUzovK8RrCyMGEldpQSrJ
         kGfE8gBNOyTurd2u4yf/5CT7CFmz3yRKye58ezpLuy0ehguRVTk0royqxOsMlBLHrXcv
         xSNA==
X-Gm-Message-State: AOAM5308tEyaE4R+ZN224NRCnzYa750IY/QU1uizcb7xL8iVa1VdvFSj
        Lom66W//hTq8Yp2LZcBiY/IoFJueCdLGnlEu8t4YhNpY8pIyzDgLTCskAyl5082ywYFa0I42g9k
        Arn8B+Gtxf23lA8lq
X-Received: by 2002:a50:ec15:: with SMTP id g21mr27410203edr.136.1634640351752;
        Tue, 19 Oct 2021 03:45:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyF00nskOZRfgaLiHa+5ZKOZ7l8ye7vVJLEJdL5SJHj7wXuWUitKdXDJV8LcjkbOiyewYGjlA==
X-Received: by 2002:a50:ec15:: with SMTP id g21mr27410065edr.136.1634640350446;
        Tue, 19 Oct 2021 03:45:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b2sm10160102ejj.124.2021.10.19.03.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 03:45:49 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 23203180263; Tue, 19 Oct 2021 12:45:49 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH net-next 1/2] net: sched: fix logic error in
 qdisc_run_begin()
In-Reply-To: <20211019003402.2110017-2-eric.dumazet@gmail.com>
References: <20211019003402.2110017-1-eric.dumazet@gmail.com>
 <20211019003402.2110017-2-eric.dumazet@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 19 Oct 2021 12:45:49 +0200
Message-ID: <871r4hi97m.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:

> From: Eric Dumazet <edumazet@google.com>
>
> For non TCQ_F_NOLOCK qdisc, qdisc_run_begin() tries to set
> __QDISC_STATE_RUNNING and should return true if the bit was not set.
>
> test_and_set_bit() returns old bit value, therefore we need to invert.
>
> Fixes: 29cbcd858283 ("net: sched: Remove Qdisc::running sequence counter")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Ahmed S. Darwish <a.darwish@linutronix.de>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Ah! I had just finished bisecting that lockup on qdisc install and
figured I'd check the list before I started investigating further. And
indeed you had beaten me to the punch with a fix - thanks! :)

Tested-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

