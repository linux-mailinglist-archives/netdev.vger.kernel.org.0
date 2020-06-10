Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9845E1F5478
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 14:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgFJMV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 08:21:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48177 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728595AbgFJMV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 08:21:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591791686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TajccAc98eovcAxEmobow/lDPcnemSp9A9wMVl+c6QY=;
        b=flZf5/3Sz0EEmU6II/6tjQoXWCugbeVh3hBrSyTW2HhxTyoQbM2PttrPgk03JFCuZQfo4e
        1Kz3br/6yB0J12uyECLJwEfDHIwVjIcPB0CgN46SogAI3K3bg3cjQh4DOg5V+fyGr/S/x8
        WCyu06OGexaaaqGLjSbdbUXDxPIdhFY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-04L32vYtOnSGPa6mM8RJQQ-1; Wed, 10 Jun 2020 08:21:22 -0400
X-MC-Unique: 04L32vYtOnSGPa6mM8RJQQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB99118CA26B;
        Wed, 10 Jun 2020 12:21:20 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 046FD7BA19;
        Wed, 10 Jun 2020 12:21:12 +0000 (UTC)
Date:   Wed, 10 Jun 2020 14:21:10 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        bjorn.topel@intel.com, brouer@redhat.com
Subject: Re: [RFC PATCH bpf-next 0/2] bpf_redirect_map() tail call detection
 and xdp_do_redirect() avoidance
Message-ID: <20200610142110.25fa5a14@carbon>
In-Reply-To: <87o8ps80gc.fsf@toke.dk>
References: <20200609172622.37990-1-bjorn.topel@gmail.com>
        <87o8ps80gc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>=20
> > Is this a good idea? I have only measured for AF_XDP redirects, but
> > all XDP_REDIRECT targets should benefit. For AF_XDP the rxdrop
> > scenario went from 21.5 to 23.2 Mpps on my machine. =20

Do remember that you are reporting saving 3.4 nanosec (from 21.5 to
23.2 Mpps).  For comparison a function call cost around 1.2 ns, and I
think you have avoided two function calls xdp_do_redirect() and
dev_map_enqueue() (the rest should be inlined by compiler).  Thus, that
alone account for 2.4 ns.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

