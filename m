Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0142EFEBAD
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 11:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfKPKrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 05:47:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32839 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727000AbfKPKrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 05:47:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573901244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7gF0eJeuiZodSAhORXmoP5s14B2XONiOXpf6C0HyEY4=;
        b=ROMJcx61sSzZOE4Qwjt6RNvkEzJfMAkLZnyhFcN30/XQB1oc9Sxra6moSZdzq2JFJM2Xoc
        DeXH6umn643L2D8PA8KT/tl9ZCpvmv+6W9tgdRZJgJpgCDa6wXCGmK6/8x9Gv7DGn6YsVq
        FuZ5pmuckXQw2wjN5vx89ZHP9/2XGAc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-5Aq7myTPN0CNbvF4tTnNcQ-1; Sat, 16 Nov 2019 05:47:18 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8290E1005502;
        Sat, 16 Nov 2019 10:47:16 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16AF86055F;
        Sat, 16 Nov 2019 10:47:08 +0000 (UTC)
Date:   Sat, 16 Nov 2019 11:47:07 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Jonathan Lemon" <jonathan.lemon@gmail.com>
Cc:     "Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>,
        netdev@vger.kernel.org,
        "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
        "Saeed Mahameed" <saeedm@mellanox.com>,
        "Matteo Croce" <mcroce@redhat.com>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>,
        "Tariq Toukan" <tariqt@mellanox.com>, brouer@redhat.com
Subject: Re: [net-next v1 PATCH 3/4] page_pool: block alloc cache during
 shutdown
Message-ID: <20191116114707.0bfde142@carbon>
In-Reply-To: <8FD50D75-44C3-4C67-984E-0B85ADE6BAA5@gmail.com>
References: <157383032789.3173.11648581637167135301.stgit@firesoul>
        <157383036914.3173.12541360542055110975.stgit@firesoul>
        <8FD50D75-44C3-4C67-984E-0B85ADE6BAA5@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 5Aq7myTPN0CNbvF4tTnNcQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Nov 2019 10:38:21 -0800
"Jonathan Lemon" <jonathan.lemon@gmail.com> wrote:

> Case 1:
> Now, if the driver screws up and tries to re-use the pool and allocate
> another packet, it enters __page_pool_get_cached(), which will decrement
> the alloc.count, and return NULL.  This causes a fallback to
> __get_alloc_pages_slow(), which bumps up the pool inflight count.

I can see that I made a mistake, and cannot use NULL as the poison
value. Let me drop this patch, so others (and yours) can go in before
merge window.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

