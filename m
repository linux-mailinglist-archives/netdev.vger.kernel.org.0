Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13301100022
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 09:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfKRINC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 03:13:02 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42255 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726371AbfKRINB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 03:13:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574064780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9M1GO7Jcz+E4ubKpi34+wAv5/ElE1D0phJmGo13V494=;
        b=gj/YWbNdlj6AvLmKATeTpMZ4BUKb4ir4jZsxe+9epkKPhfsxZoSiXCSuvDxdjELIQQ4/Md
        0ADye8k5F6KIWX6d9LTBlagK1jdPBaMqQd/2fOmeJ7AhVQLVIezB5HkjLRZx64Izsa7AMT
        xDcAdR4wW+A6WScDx0SWgQPRc0LR1e8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-UAexkJx4NK6Eno7H6hyFfA-1; Mon, 18 Nov 2019 03:12:57 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7F02107ACC4;
        Mon, 18 Nov 2019 08:12:55 +0000 (UTC)
Received: from ovpn-117-52.ams2.redhat.com (ovpn-117-52.ams2.redhat.com [10.36.117.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7265600CD;
        Mon, 18 Nov 2019 08:12:54 +0000 (UTC)
Message-ID: <79d02669656d56dc761fe39610d9e83eec83fe59.camel@redhat.com>
Subject: Re: [PATCH net-next 0/2] net: introduce and use route hint
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        ecree@solarflare.com
Date:   Mon, 18 Nov 2019 09:12:53 +0100
In-Reply-To: <20191116.120934.1197611919693218297.davem@davemloft.net>
References: <cover.1573893340.git.pabeni@redhat.com>
         <20191116.120934.1197611919693218297.davem@davemloft.net>
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: UAexkJx4NK6Eno7H6hyFfA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2019-11-16 at 12:09 -0800, David Miller wrote:
> From: Paolo Abeni <pabeni@redhat.com>
> Date: Sat, 16 Nov 2019 10:14:49 +0100
>=20
> > This series leverages the listification infrastructure to avoid
> > unnecessary route lookup on ingress packets. In absence of policy routi=
ng,
> > packets with equal daddr will usually land on the same dst.
> >=20
> > When processing packet bursts (lists) we can easily reference the previ=
ous
> > dst entry. When we hit the 'same destination' condition we can avoid th=
e
> > route lookup, coping the already available dst.
> >=20
> > Detailed performance numbers are available in the individual commit mes=
sages.
>=20
> Looks like there are some problems with the unconditional use of
> fib{6}_has_custom_rules in this series.

Whoops... I forgot the dependency on CONFIG_IP*_MULTIPLE_TABLES. I'll
fix that in the next iteration.

Thanks,

Paolo


