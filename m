Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6E642F19C
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 15:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235560AbhJONDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 09:03:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47722 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233950AbhJONDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 09:03:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634302873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xXqOotKBI86MAPAyKtRqjtlYyDq6iJ0xKNQOjSoSQ7g=;
        b=AJKPYS3+pnEd9cY5Yzt4QZL2vtVkyFIxvzwrQqfjcDqSCh2XVLNVj5u7a7WrALoAeoMFKq
        v8grFQcIg9xEti09DuEQE4AvkJBD4FKJyBHp+lcldzeFWBrUrUfiDMvIZKaM6IOa2q/TBW
        wRAJKV7k1Km6yNe3H0NE0yPuOeyenWg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-zIzGOoKYPIGh9D75EqcFJQ-1; Fri, 15 Oct 2021 09:01:12 -0400
X-MC-Unique: zIzGOoKYPIGh9D75EqcFJQ-1
Received: by mail-ed1-f71.google.com with SMTP id l22-20020aa7c316000000b003dbbced0731so8172014edq.6
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 06:01:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xXqOotKBI86MAPAyKtRqjtlYyDq6iJ0xKNQOjSoSQ7g=;
        b=NI18t6iWUtAWUsXRyAEXPaiz/nqGTOmZwVJTxe6VGR/kT42ZfFznrvqAA+F/+V0vOI
         kn+mulSDoyoMzmgCsF4t4Tk3FN8cvxKDCFwwynAa0iu1kOgQPg4I1zwRedjeGOrE0+Hp
         HiwlIshrLgmRgHCDJSAZUA1PRHQ23CctlxOHuyao6PIRInvSY2PZixPRBc8Xgy0H7yyl
         vMRoHA5C7N8XkBZz4akOxc7pct/KarBDdDNItg5PPbU8GJCaAFUhFq06gqWkJyLwEdhL
         tpsLWgCexdYuYqD9zYau080Dx9dEXpOiVmul10zs19U5aUCGKQvw5C7f3Pju2+R3JjMR
         2F6w==
X-Gm-Message-State: AOAM530xG5EZZWSvFicRatmsqt4KQ4T3sjPsppvWiOmlV+QUaICVOG7b
        dP/+K7eJDQj2/c+YoydgphvVMFPo9ufIh0Bj1Ofak6K4WZR5gQtt4cyEMhvQSXoj41HoY9YpA0K
        G88q4XxE4HaLkCk90
X-Received: by 2002:a17:906:1749:: with SMTP id d9mr6661195eje.178.1634302871118;
        Fri, 15 Oct 2021 06:01:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPL7J4lh6lO87caBdDpsxZJ18ztvNW9fybwMRAts3YNtZ9Bt2JYZEVvs8FRCuBEX8GqqKD7w==
X-Received: by 2002:a17:906:1749:: with SMTP id d9mr6661154eje.178.1634302870749;
        Fri, 15 Oct 2021 06:01:10 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q23sm4441169ejr.0.2021.10.15.06.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 06:01:09 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4169A18025F; Fri, 15 Oct 2021 15:01:09 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next 0/2] net/sched: implement L4S style
 ce_threshold_ect1 marking
In-Reply-To: <163429440706.6571.2942933078477320787.git-patchwork-notify@kernel.org>
References: <20211014175918.60188-1-eric.dumazet@gmail.com>
 <163429440706.6571.2942933078477320787.git-patchwork-notify@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 15 Oct 2021 15:01:09 +0200
Message-ID: <875yty1lyi.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

patchwork-bot+netdevbpf@kernel.org writes:

> Hello:
>
> This series was applied to netdev/net-next.git (master)
> by David S. Miller <davem@davemloft.net>:

Erm, huh? We were in the middle of a discussion of this :/

-Toke

