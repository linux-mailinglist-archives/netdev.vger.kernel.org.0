Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96142150F4D
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 19:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgBCSY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 13:24:57 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:43507 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729037AbgBCSY5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 13:24:57 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 3364223d
        for <netdev@vger.kernel.org>;
        Mon, 3 Feb 2020 18:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=v/RhtGqW9pZQWsh+J/RhtbLwTBo=; b=xvc/8h
        aWfHBlvsrF9NUbOoJcQ+0Zj2RwIZvoVKFpkmSgYPNQgpFxuyLXEOGfcyGX/9XdXn
        66fZJJzWmWPaXn2D1oUe82aFsA6XemhoNEgDqeqI+MuIVXnovp/N5M/sV8J3OalH
        s77m4d3Moi5uiGN1XPfChCSxA0Bhf8gOXjtISXdpcMKYVI31K82RDBQuM4+8xbo2
        mPf9bYk2B1xEpH4Jgd4oKe8qE3xN/N8/h/NM1UD3LJFpsaAus2XuBfXe1hh/q25b
        PPKtnuOszCqyLo/5dSN4AyuZEV14md4vG1sF7v+33flVamfWPo1DSqNzFzRX/i3j
        3LJ5OKypOXK51z2g==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7d76ecee (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 3 Feb 2020 18:24:12 +0000 (UTC)
Received: by mail-ot1-f45.google.com with SMTP id g64so14523690otb.13
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 10:24:54 -0800 (PST)
X-Gm-Message-State: APjAAAXDAZzH55NNpDAYATystz1AnKnR38RE1rwd9FcQydLrKGImFZJR
        OHVPePJYtr9E2uMTXq7W6awq9R+IwPwiaF1yg38=
X-Google-Smtp-Source: APXvYqyl3P00X16a0ayt89NNM1VCqEYQo63LBY2XNGicvBCuwVwizfrwTk7HaB3RD4LiU72+3aj6SlW2Ws2Hbq2DPFg=
X-Received: by 2002:a9d:6745:: with SMTP id w5mr19094643otm.52.1580754293959;
 Mon, 03 Feb 2020 10:24:53 -0800 (PST)
MIME-Version: 1.0
References: <20200203171951.222257-1-edumazet@google.com> <CAHmME9r3bROD=jAH-598_DU_RUxQECiqC6sw=spdQvHQiiwf=g@mail.gmail.com>
 <efaa70a3-5c71-3cc0-ffe4-e8401d598992@gmail.com>
In-Reply-To: <efaa70a3-5c71-3cc0-ffe4-e8401d598992@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 3 Feb 2020 19:24:42 +0100
X-Gmail-Original-Message-ID: <CAHmME9r+Nzb7wbD5-Oa4SpNukLsyXf3O8GYgrjsvyeUjHzM=Cw@mail.gmail.com>
Message-ID: <CAHmME9r+Nzb7wbD5-Oa4SpNukLsyXf3O8GYgrjsvyeUjHzM=Cw@mail.gmail.com>
Subject: Re: [PATCH net] wireguard: fix use-after-free in root_remove_peer_lists
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 3, 2020 at 7:18 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> I will let you work on a lockdep issue that syzbot found :)

Indeed, somehow I had missed that Dmitry added the wireguard netlink
interface, assuming that I needed to stop being lazy and add it
myself. Working my way through the backlog since Jan 29 now to see
what I'm missing out on.
