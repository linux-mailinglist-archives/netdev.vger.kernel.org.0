Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5BEFDA00
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 10:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbfKOJzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 04:55:04 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38912 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725829AbfKOJzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 04:55:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573811703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JoOxemC+N/00JSoRUgM1MoymJJnpiikYo8B7IGJfJa4=;
        b=iYhkYclnD/BSt8qejYCAwk599lv+KbsBEICNGlfIjVPbRsfrTMK76CMhvU3+54fUtlXPM7
        3El+HhHaNggVPVlZ5IHZfWkCSiV39nmd/zj9DCBXfSWdnwZhqZ1bdVMhS+L3GB95eB2r4u
        sPMGaZ087pUKabkfwhX3BrpSpevVidQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-MRYOR-J0MbG9vVUp841FLw-1; Fri, 15 Nov 2019 04:55:00 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F7B81005511;
        Fri, 15 Nov 2019 09:54:58 +0000 (UTC)
Received: from localhost (unknown [10.40.206.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EB1317BF8E;
        Fri, 15 Nov 2019 09:54:56 +0000 (UTC)
Date:   Fri, 15 Nov 2019 10:54:55 +0100
From:   Jiri Benc <jbenc@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] tcp: switch snprintf to scnprintf
Message-ID: <20191115105455.24a4dd48@redhat.com>
In-Reply-To: <20191115024106.GB18865@dhcp-12-139.nay.redhat.com>
References: <20191114102831.23753-1-liuhangbin@gmail.com>
        <557b2545-3b3c-63a9-580c-270a0a103b2e@gmail.com>
        <20191115024106.GB18865@dhcp-12-139.nay.redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: MRYOR-J0MbG9vVUp841FLw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Nov 2019 10:41:06 +0800, Hangbin Liu wrote:
> > We need to properly size the output buffers before using them,
> > we can not afford truncating silently the output.
>=20
> Yes, I agree. Just as I said, the buffer is still enough, while scnprintf
> is just a safer usage compired with snprintf.

So maybe keep snprintf but add WARN_ON and bail out of the loop if the
buffer size was reached?

=09if (WARN_ON(offs >=3D maxlen))
=09=09break;

 Jiri

