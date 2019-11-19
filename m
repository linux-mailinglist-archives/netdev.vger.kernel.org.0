Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3BC21028D0
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 17:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbfKSQA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 11:00:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22648 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728443AbfKSQA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 11:00:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574179227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KFQgOXKdcqVR725cIUY92plMBj047wuNX7Vjz6FMKAk=;
        b=H456H4qevKtd9szaF+epmPN6jq4eAAlHjPqbxCk3XcU1BxJ5KTbDR8Oyysa7r2oKZdZL/H
        Gk4hYpTZw3jrCx86zt13RNQBav4keaDOk0FGZU1ctPLLs/X737A/LTtvcDXtU8I3qwZAZe
        wEmvBouvXWhNaiXvP4iafhfsj+ETK8Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-Jmeb5-wNNOyZ_bqPDIbm4g-1; Tue, 19 Nov 2019 11:00:24 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CCF0802691;
        Tue, 19 Nov 2019 16:00:23 +0000 (UTC)
Received: from ovpn-117-12.ams2.redhat.com (ovpn-117-12.ams2.redhat.com [10.36.117.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 215A41001925;
        Tue, 19 Nov 2019 16:00:21 +0000 (UTC)
Message-ID: <f3a53240733bee0322100e9747b6c2e1049b058c.camel@redhat.com>
Subject: Re: [PATCH net-next v3 1/2] ipv6: introduce and uses route look
 hints for list input
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>
Date:   Tue, 19 Nov 2019 17:00:21 +0100
In-Reply-To: <5bb4b0b2-cc12-2cce-0122-54bd72ab04e7@gmail.com>
References: <cover.1574165644.git.pabeni@redhat.com>
         <422ebfbf2fcb8a6ce23bcd97ab1f7c3a0c633cbd.1574165644.git.pabeni@redhat.com>
         <5bb4b0b2-cc12-2cce-0122-54bd72ab04e7@gmail.com>
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: Jmeb5-wNNOyZ_bqPDIbm4g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 2019-11-19 at 08:39 -0700, David Ahern wrote:
> +static struct sk_buff *ip6_extract_route_hint(struct net *net,
> > +=09=09=09=09=09      struct sk_buff *skb)
> > +{
> > +=09if (IS_ENABLED(IPV6_SUBTREES) || fib6_has_custom_rules(net))
>=20
> ... but basing on SUBTREES being disabled is going to limit its use. If
> no routes are source based (fib6_src is not set), you should be able to
> re-use the hint with SUBTREES enabled. e.g., track fib6_src use with a
> per-namespace counter - similar to fib6_rules_require_fldissect.

Thank you for the feedback! Would you consider this as an intermediate
step? e.g. get these patches in, and then I'll implement subtree
support?=20
I'm asking because I don't have subtree setup handy, it will a little
time to get there.

Thanks!

Paolo

