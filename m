Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC30A1BA222
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 13:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgD0LQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 07:16:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30371 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726504AbgD0LQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 07:16:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587986189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hD6TvcwoaxnpatDhL2yc1rJ75nNrA3t4B8TIWv1F9Ek=;
        b=J5mJj2Vn2xRw4wHtCoLwiWkiC9HDUzJlbxUMmY6KTUWF3uPi1YA0EDLOYyCsu5koAS6naQ
        Sgd342gvQ6RZk/KckD5qq0FewjjoF4FRt7lF6zo/25sXLIpe/RYHPjXZP4QRWK9EhRkfQy
        AqFFhueoBmQ1SnBSjoT2Q7YT1sKYWr4=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-hTeXnCDwNpShZfLAvkmIww-1; Mon, 27 Apr 2020 07:16:27 -0400
X-MC-Unique: hTeXnCDwNpShZfLAvkmIww-1
Received: by mail-lj1-f199.google.com with SMTP id e18so3063908ljg.7
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 04:16:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hD6TvcwoaxnpatDhL2yc1rJ75nNrA3t4B8TIWv1F9Ek=;
        b=OJeEEcphCAi2WvxkgTQ2KdpQkYWz3QN8+U7j3SzrMwkCXvW/qSd5/XAOkt+2EnsCRn
         JGsjqhfSvmskiu2jZVzyn/RWy6Lsrs91K0uyKI0R6ovdH2iz6Crne/rJb655kXYlg8AW
         LGhi9bysdrnWkoWJrSg4hVzB1e3+aHThCE15dxXAPU/t3cm5L7hx+e1/FKQMeQc39jR1
         vVniyYwzjldnC+6wTkcIzHh4UlBZpYLr/T2pzs2OwraegQFwHzWU8mWm6wwDxN4gHAnJ
         YVtqP/SR/gETcpjGWx/PW7NVuctRBUduzCg9xc7xzzuF1JW9EeGspdlJ2HDK2nc0rrqo
         3kjA==
X-Gm-Message-State: AGi0PuaYaz2Q+NOBfgQ1gmSOB6uytsVkqPdMAHqpSCFUfYhFcv+s6OcN
        hMsR3Ze5ZdvU5XYSBa4cfUr2VNhrW7BYpDNI5euOMXrlsZsxsKMDO7cfX2Yiq4MyYtRnADHdhLV
        32i5oAq3W/TMg5gWg
X-Received: by 2002:a19:ee06:: with SMTP id g6mr15271438lfb.90.1587986185729;
        Mon, 27 Apr 2020 04:16:25 -0700 (PDT)
X-Google-Smtp-Source: APiQypKRbN7zRpQeD5IYGxjkR2jlDMhJNXtkVQSvlyg1zyE+zynK/w/3Kv/OeocI00+5Yxo4YddA3w==
X-Received: by 2002:a19:ee06:: with SMTP id g6mr15271425lfb.90.1587986185508;
        Mon, 27 Apr 2020 04:16:25 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id c10sm2914702lfc.7.2020.04.27.04.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 04:16:24 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id ED4CE1814FF; Mon, 27 Apr 2020 13:16:22 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH RFC v2] net: xdp: allow for layer 3 packets in generic skb handler
In-Reply-To: <20200427102229.414644-1-Jason@zx2c4.com>
References: <CAHmME9qXrb0ktCTeMJwt6KRsQxOWkiUNL6PNwb1CT7AK4WsVPA@mail.gmail.com> <20200427102229.414644-1-Jason@zx2c4.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 27 Apr 2020 13:16:22 +0200
Message-ID: <87ftcpyy9l.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> A user reported a few days ago that packets from wireguard were possibly
> ignored by XDP [1]. We haven't heard back from the original reporter to
> receive more info, so this here is mostly speculative. Successfully nerd
> sniped, Toke and I started poking around. Toke noticed that the generic
> skb xdp handler path seems to assume that packets will always have an
> ethernet header, which really isn't always the case for layer 3 packets,
> which are produced by multiple drivers. This patch is untested, but I
> wanted to gauge interest in this approach: if the mac_len is 0, then we
> assume that it's a layer 3 packet, and in that case prepend a pseudo
> ethhdr to the packet whose h_proto is copied from skb->protocol, which
> will have the appropriate v4 or v6 ethertype. This allows us to keep XDP
> programs' assumption correct about packets always having that ethernet
> header, so that existing code doesn't break, while still allowing layer
> 3 devices to use the generic XDP handler.

Seems to me like this would work; let's see if anyone else has any
comments :)

-Toke

