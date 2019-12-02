Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0009610F268
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 22:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfLBVwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 16:52:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37413 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725825AbfLBVwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 16:52:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575323534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Di9sCpv5BT8GsuIxhYkS1y9UxU2ZrHzYvrCaK0XUhcw=;
        b=LVpWnsJzFdP39VhPUWkAGVtjXTzN2X5bEQgbfeKlmBRwoogCDl9BXXUmdk8Dqa0Z8m8Fz3
        wnw4p3zP24MrICaFVORab4jcbes7LFqU69qBPBRGGIpSI7o7VjIMEmv+Vzt6RowjKjnAe/
        UAOQzirYFIRv61Caz+JI+WBJW+jPg3w=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-iAwnSLT3M4iwbSkyoL-spw-1; Mon, 02 Dec 2019 16:52:13 -0500
Received: by mail-lj1-f198.google.com with SMTP id e12so127654ljk.19
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 13:52:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YFTzUgdIEES6OWFNrobgyRuyjxbIr8Dl3k8H0vcYo34=;
        b=DsZLObkR6Ezj20MK/EAnKzWXTp4E1XrNUaZATf0BGQCFengz//75s56l4KCX18F7CE
         DagmaszMmNAsFJ8iL4xQ2nTgWTYbnSOpyQMWRDEWUlJ5N45vPDCjvHkQApcs3KR6unq4
         I+QbBtf5fRPhKZZZ1Pz+ubea/u5YLJBJc1G+XdVCK3w0PxM2qIyCofTsr8YgJi5ZaRPr
         +uBHtsdeciyhGNd+6iJjD/3EU4iKhtpBGxxkjkw1gxfyd6yfsuAdyg+cK9YOxLgksXiQ
         fYvaVf2QiurF3kTachS3HAYbJcAvmwKolfdV7HOZnZntsD5+gbAMYN5SksBI/0Hvv7l3
         UK5g==
X-Gm-Message-State: APjAAAXhlXETIkDgPriQ5J3ERWwLua3T4DAnf6nQ17Uksq/t68jcUzuT
        dsz8HvkI43fsqnZP1HV75ZRBfxhF5cNaF37NZ7m0nwnLIuX90bdf2zZSRil9zWrhJXLczsEMZEq
        UGj6CXLtImmb3XbODiAriaktw6zgrkWjT
X-Received: by 2002:a19:6e43:: with SMTP id q3mr671093lfk.152.1575323531642;
        Mon, 02 Dec 2019 13:52:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqzQyIV6PzLHduf4Mo/QBzUOTW4k8J6N3+IHAsDOhYA5BkiBiRyJwQX+h0799jfFSQg08ne94gbo+O9SP1DPVUQ=
X-Received: by 2002:a19:6e43:: with SMTP id q3mr671085lfk.152.1575323531486;
 Mon, 02 Dec 2019 13:52:11 -0800 (PST)
MIME-Version: 1.0
References: <20191202184259.30416-1-marco.oliverio@tanaza.com>
In-Reply-To: <20191202184259.30416-1-marco.oliverio@tanaza.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Mon, 2 Dec 2019 22:51:35 +0100
Message-ID: <CAGnkfhzTq2HJ2Pm1sLOLaeOET926SjqRznQLy-CrMue_cpeLRg@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_queue: enqueue skbs with NULL dst
To:     Marco Oliverio <marco.oliverio@tanaza.com>
Cc:     rocco.folino@tanaza.com, netdev <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
X-MC-Unique: iAwnSLT3M4iwbSkyoL-spw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 2, 2019 at 7:43 PM Marco Oliverio <marco.oliverio@tanaza.com> w=
rote:
>
> Bridge packets that are forwarded have skb->dst =3D=3D NULL and get
> dropped by the check introduced by
> b60a77386b1d4868f72f6353d35dabe5fbe981f2 (net: make skb_dst_force
> return true when dst is refcounted).
>
> To fix this we check skb_dst() before skb_dst_force(), so we don't
> drop skb packet with dst =3D=3D NULL. This holds also for skb at the
> PRE_ROUTING hook so we remove the second check.
>
> Fixes: b60a773 ("net: make skb_dst_forcereturn true when dst is refcounte=
d")
>
> Signed-off-by: Marco Oliverio <marco.oliverio@tanaza.com>
> Signed-off-by: Rocco Folino <rocco.folino@tanaza.com>

Tested-by: Matteo Croce <mcroce@redhat.com>

--=20
Matteo Croce
per aspera ad upstream

