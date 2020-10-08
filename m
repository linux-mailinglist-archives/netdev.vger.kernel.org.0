Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E5028731B
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 13:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729748AbgJHLGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 07:06:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47963 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725852AbgJHLGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 07:06:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602155207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F8qhO75Bqse1Dybd3b485G4TSpgL9h8SxeBa6huwTzo=;
        b=bEUN5bDjS/AGjONA4RLeHW/vBfBJJkf4Cm7gOdv+KCQytQBb/yKaxe3R0EyG4fHLzCukN/
        D0OpFxhdHjRkcYILATEEp0zyi1XE1HLMLNr8S629LZfWKgroqypAG0VGDwrrCdGJa4UJis
        88ILtBXeq0fGxywN76rsGTUMDXuUPRs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-d6SroyxLMaiOr5dTpbYglg-1; Thu, 08 Oct 2020 07:06:45 -0400
X-MC-Unique: d6SroyxLMaiOr5dTpbYglg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6226284A5EF;
        Thu,  8 Oct 2020 11:06:43 +0000 (UTC)
Received: from carbon (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E8B6F10023A7;
        Thu,  8 Oct 2020 11:06:33 +0000 (UTC)
Date:   Thu, 8 Oct 2020 13:06:32 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>
Cc:     bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eyal Birger <eyal.birger@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next V2 1/6] bpf: Remove MTU check in
 __bpf_skb_max_len
Message-ID: <20201008130632.0c407bad@carbon>
In-Reply-To: <CANP3RGeU4sMjgAjXHVRc0ES9as0tG2kBUw6jRZhz6vLTTtVEVA@mail.gmail.com>
References: <160208770557.798237.11181325462593441941.stgit@firesoul>
        <160208776033.798237.4028465222836713720.stgit@firesoul>
        <CANP3RGeU4sMjgAjXHVRc0ES9as0tG2kBUw6jRZhz6vLTTtVEVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Oct 2020 16:46:10 -0700
Maciej =C5=BBenczykowski <maze@google.com> wrote:

> >  static u32 __bpf_skb_max_len(const struct sk_buff *skb)
> >  {
> > -       return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
> > -                         SKB_MAX_ALLOC;
> > +       return IP_MAX_MTU;
> >  } =20
>=20
> Shouldn't we just delete this helper instead and replace call sites?

It does seem wrong to pass argument skb into this function, as it is
no-longer used...

Guess I can simply replace __bpf_skb_max_len with IP_MAX_MTU.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

