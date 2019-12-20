Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56D21127812
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 10:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfLTJ0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 04:26:32 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26706 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727184AbfLTJ0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 04:26:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576833990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qqR8lwUOuBpvxH2x8/pvM8hypDpbA173h4KwuaI5cck=;
        b=drnfjb+f7uClnw0hktizhZORoD07ZP0PaXTGXl9faU+ajlbiWLUHum9d6DpD0TTy4FzV+p
        C9my1Fs7woiqPSyySg6/Km0jJr6wtUZkYnj2abbrgBSt/MAOmMEyFJMVzbLBGD0EdKEBax
        IzrUC++chiHRdHiVAhiZHS10wEDSSKc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-MQtIfutfNFe_4eI-r0rmsw-1; Fri, 20 Dec 2019 04:26:24 -0500
X-MC-Unique: MQtIfutfNFe_4eI-r0rmsw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0A44593C6;
        Fri, 20 Dec 2019 09:26:22 +0000 (UTC)
Received: from carbon (ovpn-200-18.brq.redhat.com [10.40.200.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5EC15C1B0;
        Fri, 20 Dec 2019 09:26:16 +0000 (UTC)
Date:   Fri, 20 Dec 2019 10:26:15 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next v2 0/8] Simplify
 xdp_do_redirect_map()/xdp_do_flush_map() and XDP maps
Message-ID: <20191220102615.45fe022d@carbon>
In-Reply-To: <20191220084651.6dacb941@carbon>
References: <20191219061006.21980-1-bjorn.topel@gmail.com>
        <CAADnVQL1x8AJmCOjesA_6Z3XprFVEdWgbREfpn3CC-XO8k4PDA@mail.gmail.com>
        <20191220084651.6dacb941@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Dec 2019 08:46:51 +0100
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> On Thu, 19 Dec 2019 21:21:39 -0800
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>=20
> > > v1->v2 [1]:
> > >   * Removed 'unused-variable' compiler warning (Jakub)
> > >
> > > [1] https://lore.kernel.org/bpf/20191218105400.2895-1-bjorn.topel@gma=
il.com/   =20
> >=20
> > My understanding that outstanding discussions are not objecting to the
> > core ideas of the patch set, hence applied. Thanks =20
>=20
> I had hoped to have time to review it in details today.  But as I don't
> have any objecting to the core ideas, then I don't mind it getting
> applied. We can just fix things in followups.

I have now went over the entire patchset, and everything look perfect,
I will go as far as saying it is brilliant.  We previously had the
issue, that using different redirect maps in a BPF-prog would cause the
bulking effect to be reduced, as map_to_flush cause previous map to get
flushed. This is now solved :-)

Thanks you Bj=C3=B8rn!

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

