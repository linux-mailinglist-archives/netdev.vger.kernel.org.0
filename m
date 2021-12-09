Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFD846E7E7
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 12:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbhLIMDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 07:03:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41744 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233270AbhLIMDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 07:03:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639051167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R/3SHLQZuMf9a8wTgieowqMFKjDopFuWeGtxcl3iEeo=;
        b=FTMrTFz0Gui+pEJHUziEf7cto1OFA/T8Zrrc+SL5z95K8ZmXGBcegBoE2SRfbAGzBqk3bi
        ePdnpDqa0mVBPZPQbBRydvrJj8AMRwB3L0xnNcPL7cciRd8rR2I57klV74HnbDniTK+aU2
        lmQjiiDtGjbXWr8N04Ybtj8i5Y2ltME=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-DRBmuQCiOoudrr5VitlIVg-1; Thu, 09 Dec 2021 06:59:26 -0500
X-MC-Unique: DRBmuQCiOoudrr5VitlIVg-1
Received: by mail-qt1-f199.google.com with SMTP id s8-20020ac85cc8000000b002b631ea95d4so8493233qta.4
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 03:59:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=R/3SHLQZuMf9a8wTgieowqMFKjDopFuWeGtxcl3iEeo=;
        b=SPdOccrS3xP8ERmPhRvXMZpnmaKXRNamXesh3rP1W2QpLPTXieirwj/yhm0bAbbOL9
         l1BsgcN/ccz0jB/Dc3OKud1MwzztNeXm1bXJVtoma5D34lPtYSsA7kjTqQi4QhJMFoZq
         QzgYb0KYGWP2jG6rmpxMBLClRFujcdrqDnDy7bUUjn2gjVQFZ/pPD5UY5Na76ywCDnX5
         GVgxOe9WuNl162OSCWW05cm9JgyXAa++eK8FTzCGjIoYW6kH9PCp5+CDCCxSN6a761Kh
         luO1QcTGMFBwX+ToKPj2jLzY372i+2FEEkoAKTQ7sAPyT5BqXq3cK1y75jxl8D2P8hl9
         GWJg==
X-Gm-Message-State: AOAM533uenK1qKLB48GBCKVuagLr9YnqkUYv3PXHmjxwygAXCiO24OuO
        hmzeZ5xM88TS2R5AtnSckCg9yhW0ueLt7RQi6oI8uUrqJTqjZrpXYJQYqf3cxP1c9uLfrXyxMWb
        oNyv62EpIaX9Ie+bA
X-Received: by 2002:a05:6214:5016:: with SMTP id jo22mr16317286qvb.98.1639051165577;
        Thu, 09 Dec 2021 03:59:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJywm+q3L3XP3IqVeskPe/53OKo+diW+8mvhKhNcwCjJF+4zNs7KsNKxOIGnw5VzWH8CnOPczg==
X-Received: by 2002:a05:6214:5016:: with SMTP id jo22mr16317257qvb.98.1639051165301;
        Thu, 09 Dec 2021 03:59:25 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-237-50.dyn.eolo.it. [146.241.237.50])
        by smtp.gmail.com with ESMTPSA id i6sm2987713qkn.26.2021.12.09.03.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 03:59:24 -0800 (PST)
Message-ID: <bd537766c4b70da71153a9972e6f6ee12e92ff92.camel@redhat.com>
Subject: Re: [PATCH v2 net-next] tcp: Warn if sock_owned_by_user() is true
 in tcp_child_process().
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>, edumazet@google.com
Cc:     benh@amazon.com, davem@davemloft.net, kuba@kernel.org,
        kuni1840@gmail.com, netdev@vger.kernel.org
Date:   Thu, 09 Dec 2021 12:59:21 +0100
In-Reply-To: <20211209110746.91987-1-kuniyu@amazon.co.jp>
References: <CANn89iJ12OugQTv4JHwVWKtZp88sbQKXD61PvnQWOo3009tTKQ@mail.gmail.com>
         <20211209110746.91987-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-12-09 at 20:07 +0900, Kuniyuki Iwashima wrote:
> From:   Eric Dumazet <edumazet@google.com>
> Date:   Thu, 9 Dec 2021 00:00:35 -0800
> > On Wed, Dec 8, 2021 at 5:33 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > > 
> > > While creating a child socket from ACK (not TCP Fast Open case), before
> > > v2.3.41, we used to call bh_lock_sock() later than now; it was called just
> > > before tcp_rcv_state_process().  The full socket was put into an accept
> > > queue and exposed to other CPUs before bh_lock_sock() so that process
> > > context might have acquired the lock by then.  Thus, we had to check if any
> > > process context was accessing the socket before tcp_rcv_state_process().
> > > 
> > 
> > I think you misunderstood me.
> > 
> > I think this code is not dead yet, so I would :
> > 
> > Not include a Fixes: tag to avoid unnecessary backports (of a patch
> > and its revert)
> > 
> > If you want to get syzbot coverage for few releases, especially with
> > MPTCP and synflood,
> > you  can then submit a patch like the following.
> 
> Sorry, I got on the same page.
> Let me take a look at MPTCP, then if I still think it is dead code, I will
> submit the patch.

For the records, I think the 'else' branch should be reachble with
MPTCP in some non trivial scenario, e.g. MPJ subflows 3WHS racing with
setsockopt on the main MPTCP socket. I'm unsure if syzbot could catch
that, as it needs mptcp endpoints configuration.

Cheers,

Paolo

