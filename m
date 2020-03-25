Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5B4C192E1E
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgCYQY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:24:27 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:38409 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727386AbgCYQY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 12:24:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585153465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zT46TZ1bGDDsS4ozd6cMIQY8lMRr0fO+F44xU1Czd/w=;
        b=Z+b1z98Iz370uO2RYsSFnXRG5qjUgfdvMhPWODswW3lvkVYo7cpJf6f5f7nR9aDawbvVkY
        NeH4WIQEdbyjlOm9yFJHhZ27ZtqT4EnwmvdTM/fxvUG7wFkqBJjKoQ4JCxwY8UYwXH/EDj
        qmzcFGkoX5CKaVt/pP2UHvRb2Y2myVQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-ut5MQ4OOPxS5-eShxl7gTw-1; Wed, 25 Mar 2020 12:24:23 -0400
X-MC-Unique: ut5MQ4OOPxS5-eShxl7gTw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF802107B79F;
        Wed, 25 Mar 2020 16:24:21 +0000 (UTC)
Received: from ovpn-114-87.ams2.redhat.com (ovpn-114-87.ams2.redhat.com [10.36.114.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00E7E92D22;
        Wed, 25 Mar 2020 16:24:19 +0000 (UTC)
Message-ID: <7e385f0c1edca94a882bdadf46f4ddb97d59a64a.camel@redhat.com>
Subject: Re: [PATCH net-next] net: use indirect call wrappers for
 skb_copy_datagram_iter()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Date:   Wed, 25 Mar 2020 17:24:18 +0100
In-Reply-To: <0f5c5e35-fc51-19c3-2ce3-c8ac17887c6c@gmail.com>
References: <20200325022321.21944-1-edumazet@google.com>
         <ace8e72488fbf2473efaed9fc0680886897939ab.camel@redhat.com>
         <CA+FuTSdO_WBhrRj5PNdXppywDNkMKJ4hLry+3oSvy8mavnxw0g@mail.gmail.com>
         <2b5f096a143f4dea9c9a2896913d8ca79688b00f.camel@redhat.com>
         <0f5c5e35-fc51-19c3-2ce3-c8ac17887c6c@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-03-25 at 09:07 -0700, Eric Dumazet wrote:
> 
> On 3/25/20 9:00 AM, Paolo Abeni wrote:
> 
> > For the record, I have 2 others item on my list, I hope to have time to
> > process some day: the ingress dst->input and the default ->enqueue  and
> > ->dequeue
> 
> What is the default ->enqueue() and ->dequeue() ?

The idea is (or should I say 'was' ?!?) to tie it to NET_SCH_DEFAULT,
so it depends on your config...

> For us, this is FQ.
> 
> (Even if we do not select NET_SCH_DEFAULT and leave pfifo_fast as the 'default' qdisc)

... this one will see no benefit.

Just out of sheer curiosity, why don't you set NET_SCH_DEFAULT?

Thanks,

Paolo

