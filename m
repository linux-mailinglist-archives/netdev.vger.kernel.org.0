Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8010432640C
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 15:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhBZO2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 09:28:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21977 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229545AbhBZO2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 09:28:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614349645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hbU00v6H8L3aZNZVsFY0LE/Fhe74AG+o+sFHGaq7+VU=;
        b=gAf0EU7yPWJolBlKMrkp6d9EK6QKrxzTTUdxnJ6/FWsxZcVOJdrPl8exHRQJlNEfVigFu8
        OxKZTsN5k08peibu8E0o4nU+Uo/WhVGdojHaFeVPUmd2amgSf0y9/hz+jREa7fkgE59Ypa
        G5SzJGRy/6ds84THSS8mJKlz+v+CSkA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-mJOBp3CJM_61rkfQobWE9Q-1; Fri, 26 Feb 2021 09:27:22 -0500
X-MC-Unique: mJOBp3CJM_61rkfQobWE9Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 301D66D4E0;
        Fri, 26 Feb 2021 14:27:20 +0000 (UTC)
Received: from carbon (unknown [10.36.110.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDFF510013D6;
        Fri, 26 Feb 2021 14:27:13 +0000 (UTC)
Date:   Fri, 26 Feb 2021 15:27:10 +0100
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, maciej.fijalkowski@intel.com, hawk@kernel.org,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH bpf-next v4 1/2] bpf, xdp: make bpf_redirect_map() a map
 operation
Message-ID: <20210226152710.31a6f26e@carbon>
In-Reply-To: <694101a1-c8e2-538c-fdd5-c23f8e2605bb@intel.com>
References: <20210226112322.144927-1-bjorn.topel@gmail.com>
        <20210226112322.144927-2-bjorn.topel@gmail.com>
        <87sg5jys8r.fsf@toke.dk>
        <694101a1-c8e2-538c-fdd5-c23f8e2605bb@intel.com>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Feb 2021 12:40:33 +0100
Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> wrote:

> @Jesper Do you have a CPUMAP benchmark that you can point me to? I just
> did functional testing for CPUMAP

I usually just use the xdp_redirect_cpu samples/bpf program.

Your optimization will help the RX enqueue side, but the bottleneck for
CPUMAP is the remote CPU dequeue.  You should still be able to see that
RX-side performance improve, and that should be enough (even-though
packets are dropped before reaching remote CPU).  I'm not going to ask
you to test scale out to more CPUs.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

