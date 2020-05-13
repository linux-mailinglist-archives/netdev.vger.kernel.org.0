Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6411D1A3E
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389551AbgEMQB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389537AbgEMQBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:01:24 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EE8C061A0C;
        Wed, 13 May 2020 09:01:23 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id j2so187312qtr.12;
        Wed, 13 May 2020 09:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gDEGyQnYOplCe+b2bduCD1NxRiNW5Fcu+RuIWNa1OVw=;
        b=IXyjPELcQyD5gdttArcdwU7+1LQqG6/ZBgarATcp7ASUXUIw60bmvRmFlawI8eROc1
         ID95lZbsfppvCnFJ/whBX/fUV21HjSdb1ffl38pin+rX6Aov45DhRq8DOBOdsEF425p2
         ms5vUVofiC4bJtuWMTsRQC08fCTxEqTbBUbRR+W84QKvtxP2FMy1Fl0Rqmvf0Pc2YKlC
         eK5y8Jcj4r969++jesYOjSfDN85ruV/9pFPQZvJs9ipGmpMwyy9jHdIC61Krod6zu/jK
         pTmZMSYV8hvUfD44+cCKIpIWpV7aMeF3wtNjbGfPHqbV5fgT5AX+TnSSsa/81Si0JulZ
         lmuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gDEGyQnYOplCe+b2bduCD1NxRiNW5Fcu+RuIWNa1OVw=;
        b=uLag9w6XijBequS5JTfk3gf/cIxZQhqr9qLXPJE4PvuwZE/aY/LUieE6K9KgGh6Q/F
         rbs57APFvqIG5kRwY8Ht9rws3NlXQ6+NRSoGGV+FweLhE++pV4J2+Ezeb4VkQF3qKa+Y
         Dv68x9KtJU3T/XHxeSJf0TYMdzjMXu8w75BjAo2tKoFZNmxW/D/XGbTe7uQpC62oz8BY
         gTqT22THvEI2PbwvwtK0Rg1c/Sp//IYz/xZbZ4BWZlCkRO7P2bf8D2MU2ibas/iFBCZR
         D+NQCD/V6GXevEpCIiFMXdQdfTrE45W/BQM+RYddfHVjIIeWZ/pxlDy73pxkW/gw+Mzb
         wTkQ==
X-Gm-Message-State: AGi0PubG4hYv8qz6p/7aqXYmQ3MDX41PP3e5MxmH7hXrzb9k5MhQCoDQ
        lZx0JzlyA142RxiNE+A5rGQ=
X-Google-Smtp-Source: APiQypLEa5DbO43gtfzf8xyX7id6nt1AixGK016BmPhbJ+nK7lrYw/rkTIrTyRfLg1cXu5uVimMK0w==
X-Received: by 2002:ac8:5311:: with SMTP id t17mr16856713qtn.42.1589385682534;
        Wed, 13 May 2020 09:01:22 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:f4e9:6bc3:5a0:7baf:1a14])
        by smtp.gmail.com with ESMTPSA id y140sm156177qkb.127.2020.05.13.09.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 09:01:21 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 6E656C08DA; Wed, 13 May 2020 13:01:16 -0300 (-03)
Date:   Wed, 13 May 2020 13:01:16 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jonas Falkevik <jonas.falkevik@gmail.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>
Subject: Re: [PATCH] sctp: check assoc before SCTP_ADDR_{MADE_PRIM,ADDED}
 event
Message-ID: <20200513160116.GA2491@localhost.localdomain>
References: <CABUN9aCXZBTdYHSK5oSVX-HAA1wTWmyBW_ked_ydsCjsV-Ckaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABUN9aCXZBTdYHSK5oSVX-HAA1wTWmyBW_ked_ydsCjsV-Ckaw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 04:52:16PM +0200, Jonas Falkevik wrote:
> Do not generate SCTP_ADDR_{MADE_PRIM,ADDED} events for SCTP_FUTURE_ASSOC assocs.

How did you get them?

I'm thinking you're fixing a side-effect of another issue here. For
example, in sctp_assoc_update(), it first calls sctp_assoc_add_peer()
to only then call sctp_assoc_set_id(), which would generate the event
you might have seen. In this case, it should be allocating IDR before,
so that the event can be sent with the right assoc_id already.

> 
> These events are described in rfc6458#section-6.1
> SCTP_PEER_ADDR_CHANGE:
> This tag indicates that an address that is
> part of an existing association has experienced a change of
> state (e.g., a failure or return to service of the reachability
> of an endpoint via a specific transport address).
> 
> Signed-off-by: Jonas Falkevik <jonas.falkevik@gmail.com>
> ---
>  net/sctp/associola.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 437079a4883d..0c5dd295f9b8 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -432,8 +432,10 @@ void sctp_assoc_set_primary(struct sctp_association *asoc,
>          changeover = 1 ;
> 
>      asoc->peer.primary_path = transport;
> -    sctp_ulpevent_nofity_peer_addr_change(transport,
> -                          SCTP_ADDR_MADE_PRIM, 0);
> +    if (sctp_assoc2id(asoc) != SCTP_FUTURE_ASSOC)
> +        sctp_ulpevent_nofity_peer_addr_change(transport,
> +                              SCTP_ADDR_MADE_PRIM,
> +                              0);
> 
>      /* Set a default msg_name for events. */
>      memcpy(&asoc->peer.primary_addr, &transport->ipaddr,
> @@ -714,7 +716,10 @@ struct sctp_transport *sctp_assoc_add_peer(struct
> sctp_association *asoc,
>      list_add_tail_rcu(&peer->transports, &asoc->peer.transport_addr_list);
>      asoc->peer.transport_count++;
> 
> -    sctp_ulpevent_nofity_peer_addr_change(peer, SCTP_ADDR_ADDED, 0);
> +    if (sctp_assoc2id(asoc) != SCTP_FUTURE_ASSOC)
> +        sctp_ulpevent_nofity_peer_addr_change(peer,
> +                              SCTP_ADDR_ADDED,
> +                              0);
> 
>      /* If we do not yet have a primary path, set one.  */
>      if (!asoc->peer.primary_path) {
> --
> 2.25.3
