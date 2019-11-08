Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFC0F5890
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730968AbfKHUeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 15:34:50 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43645 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730914AbfKHUeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 15:34:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573245289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+lR4ssxP//HTWzfES9UNYGjVUNmi3T76+c89PlxaQp8=;
        b=i4aUDfJJbZvMnUUVY4CH5ghaSmsYd1y9wdLpykxbTCfpfOhj125nBkkqqNSTwLgj7NwJ5J
        +t8eFku04TBGQQ6lZerf/2VXYqzvZ7RnBdMO/hKElfV5UpNQR9RPAI2aNKA8LQCpb22SKP
        b+x9ZMphA6Pf5zndzQ5jsrlp1FJOhUA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-0HezUHIvMx6-ys0d9mg6OA-1; Fri, 08 Nov 2019 15:34:47 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DFC1477;
        Fri,  8 Nov 2019 20:34:46 +0000 (UTC)
Received: from localhost (ovpn-112-54.rdu2.redhat.com [10.10.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9A9E63147;
        Fri,  8 Nov 2019 20:34:44 +0000 (UTC)
Date:   Fri, 08 Nov 2019 12:34:43 -0800 (PST)
Message-Id: <20191108.123443.589945542624966129.davem@redhat.com>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net-next] net: icmp: fix data-race in cmp_global_allow()
From:   David Miller <davem@redhat.com>
In-Reply-To: <20191108183447.16085-1-edumazet@google.com>
References: <20191108183447.16085-1-edumazet@google.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 0HezUHIvMx6-ys0d9mg6OA-1
X-Mimecast-Spam-Score: 0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri,  8 Nov 2019 10:34:47 -0800

> This code reads two global variables without protection
> of a lock. We need READ_ONCE()/WRITE_ONCE() pairs to
> avoid load/store-tearing and better document the intent.
>=20
> KCSAN reported :
> BUG: KCSAN: data-race in icmp_global_allow / icmp_global_allow
 ...
> Fixes: 4cdf507d5452 ("icmp: add a global rate limitation")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied, thanks Eric.

