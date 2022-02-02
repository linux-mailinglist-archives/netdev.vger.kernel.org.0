Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD894A694E
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243447AbiBBAnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbiBBAm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 19:42:59 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F305C061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 16:42:59 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id my12-20020a17090b4c8c00b001b528ba1cd7so4357210pjb.1
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 16:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e82YHr2cr+IdwIwy16WCVzGIEKJz2KbUmBzvc6MyDCA=;
        b=OKIbDkpIHGlG2lwP3IjswkexgsFoA4tAQvoaWtWI7M6g7RA9r6JUr/O2EkiUyRo2pN
         sqmLp90ZMBbo+1fHqZzfa6htaJyfPShGB/wZtJXKIu5VxIJ3Qhmy3D1MqbgMg3y+gp2Q
         +cqshrJEwcFnRBjMdxOHbr7fcGs5MMqxkIwlPY7ZQO+zojEKqOLJYlxMtmkzAixSJ0/q
         PDy8wErhbXAmjrdHlL4vmt2PUzdLiGvIar36sHuuqsXFgkVMLhk9Wli3UhNmARgeb+RU
         qXp/uy+5c9zhTolXRqwBiW6XL/eF64r9GFBCuVA66AQ9ehOTPGirWvRz7OXLELEUINls
         n+cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e82YHr2cr+IdwIwy16WCVzGIEKJz2KbUmBzvc6MyDCA=;
        b=DtCLiMiUer1+wnxIPKUVsUi1fj2mLlrj7XGl6SCY5MKiakErWZlqF016sw3Z8NOSHE
         pRbuA+1TiB4CK8tcIodcLE5XimY0exGXjgds4j6oze11/+6/AQIH+MODJPij6seL11JO
         V0GvjfXDQwNmyiAg8C53jQCyan9cyC8SXSynE9fgZqFfLD6m6QlH+ugc+EWPQ66y9ltG
         I+U2LE/mxxymtfMaHBvPeV41q+tL5j6T6C1ZkzmoGVoch33IEB6pk3up7uFarNr8zllO
         mVzmjJzBu7YiBH8xeXodbKkxIL+u06VfA283aIazdmBoHlvDqgwh2VWyQTWPBGNyGiNS
         xvkw==
X-Gm-Message-State: AOAM533t/6CeXmJlI43Z2aBjx8GBdwUl8cQ8Op8RSJHQDNyuizWhGnca
        Hz9jp6SkItjW/gn2mjPFvujHlUgXE/TgFkg9
X-Google-Smtp-Source: ABdhPJyVyoiQmhTMyV1jKVmAxYkaik9eoW03OANfAWBKPNuAbpAGi/gPCigdRbJ+LLU4GTm6Bk8D/w==
X-Received: by 2002:a17:902:da81:: with SMTP id j1mr29057625plx.14.1643762579028;
        Tue, 01 Feb 2022 16:42:59 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id z1sm20381313pfh.137.2022.02.01.16.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 16:42:58 -0800 (PST)
Date:   Tue, 1 Feb 2022 16:42:56 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>
Subject: Re: [PATCH iproute2] iplink: add gro_max_size attribute handling
Message-ID: <20220201164256.5a640359@hermes.local>
In-Reply-To: <20220201232715.1585390-1-eric.dumazet@gmail.com>
References: <20220201232715.1585390-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Feb 2022 15:27:15 -0800
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> From: Coco Li <lixiaoyan@google.com>
> 
> Add the ability to display or change the gro_max_size attribute.
> 
> ip link set dev eth1 gro_max_size 60000
> ip -d link show eth1
> 5: eth1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 9198 qdisc mq master eth0 state UP mode DEFAULT group default qlen 1000
>     link/ether bc:ae:c5:39:69:66 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 46 maxmtu 9600
>     <...> gro_max_size 60000
> 
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>


Looks good, could you send update to man page as well?

