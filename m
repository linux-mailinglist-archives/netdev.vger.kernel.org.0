Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE0B110D525
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 12:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfK2Lrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 06:47:53 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:32947 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbfK2Lrx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Nov 2019 06:47:53 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id c22c92ed;
        Fri, 29 Nov 2019 10:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=lEpJtkHaOd7GowBKrJ3B/YN/11g=; b=mrf//5
        +HFMqsM3JXCbIOHBw3KhhWGga9oJMyfgfI+imBai1aZ7nYIthunm8IpU25u+xF7g
        iYWs0/dgPCpUvQMjrfpTa/fOOZRbnvd4isoem3nfDvQQSCa2V8L/p2aAle61ckeG
        hZ97l78wfyjw7ZbYEYpQlz7ZvagvKj41VO6sC+ateR7cI52s/2mNDun2dpHLZd8J
        L9zY5otkIEQkk2Zt0NhaRwM5WPIBNyrwxA5/oqDEj2OrzDrQppWJAOoYMPd+Y3q/
        ayDgc9QNk5Lhfv60tpheEccWFaqF4qFGNHo50OA1h2qnZ8unAymixrUjpfTq6TZF
        FWNurdHM1n71U4Kg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b4d24bf9 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 29 Nov 2019 10:53:43 +0000 (UTC)
Received: by mail-ot1-f50.google.com with SMTP id m15so24667103otq.7;
        Fri, 29 Nov 2019 03:47:49 -0800 (PST)
X-Gm-Message-State: APjAAAXMsQoKmPI+ngWxStbSI6PgjhaGbMLNKy1q7p3usHjaZ3RfJCt2
        +KIotTigQPcr7fvdIuUMA7I/n2SMlQ4oN4vvTXE=
X-Google-Smtp-Source: APXvYqx3Q7DMiecStDC9+rNFKGUSNsMhh7Ix+sa+yiMKb6vcL+XWPNQk0WiF1NbH1qs0r+XJ8CX2Ds+lWDWNbQvpsSQ=
X-Received: by 2002:a9d:1e88:: with SMTP id n8mr3305587otn.369.1575028069075;
 Fri, 29 Nov 2019 03:47:49 -0800 (PST)
MIME-Version: 1.0
References: <20191127112643.441509-1-Jason@zx2c4.com> <20191128.133023.1503723038764717212.davem@davemloft.net>
 <20191129033205.GA67257@zx2c4.com> <20191128.222735.1430087391284485253.davem@davemloft.net>
In-Reply-To: <20191128.222735.1430087391284485253.davem@davemloft.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 29 Nov 2019 12:47:37 +0100
X-Gmail-Original-Message-ID: <CAHmME9p8cxUtZhegkNrCF+GgREKQA=5LQ_km35qopC-2SKtJaw@mail.gmail.com>
Message-ID: <CAHmME9p8cxUtZhegkNrCF+GgREKQA=5LQ_km35qopC-2SKtJaw@mail.gmail.com>
Subject: Re: [PATCH v1] net: WireGuard secure network tunnel
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 29, 2019 at 7:27 AM David Miller <davem@davemloft.net> wrote:
>
> From: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Date: Fri, 29 Nov 2019 04:32:05 +0100
>
> > I'm not a huge fan of doing manual skb surgery either. The annoying
> > thing here is that skb_gso_segment returns a list of skbs that's
> > terminated by the last one's next pointer being NULL. I assume it's this
> > way so that the GSO code doesn't have to pass a head around.
>
> Sorry, I missed that this was processing a GSO list which doesn't use
> double linked list semantics.
>
> So ignore my feedback on this one :-)

Okay, no problem. I'll submit some global tree-wide cleanup patches in
the way of a helper macro sometime after all the wireguard dust
settles, then, and we can assess that separately.
