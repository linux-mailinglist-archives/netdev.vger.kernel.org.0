Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323C81E47D0
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 17:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbgE0Pnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 11:43:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27117 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726807AbgE0Pnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 11:43:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590594213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yabDvg3WIGVp4rsMrvMkXgd3BA7Zi2wIu9XcvoJ6urE=;
        b=QqlojAnyW12KAwqxnkSEuQm2kTrvhwvc+0yDjUT+Z7keBDiODo86gPR+H4e4G+RliIvYbL
        ggGVZ/Bm3qVemXdYfscM31R0jcT3/gNp/ggNSkw9/fauUxI+G9Gqf97uaVU4M2bD3Wszlv
        NtK76eBBmMXGUfP5uUcO8FZUhgh8VsE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-P7ywudlTPESzTGowh_CIOQ-1; Wed, 27 May 2020 11:43:31 -0400
X-MC-Unique: P7ywudlTPESzTGowh_CIOQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3761474;
        Wed, 27 May 2020 15:43:29 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 235D510013D7;
        Wed, 27 May 2020 15:43:20 +0000 (UTC)
Date:   Wed, 27 May 2020 17:43:18 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next 4/5] bpftool: Add SEC name for xdp programs
 attached to device map
Message-ID: <20200527174318.38aa5e2d@carbon>
In-Reply-To: <87o8q91ky1.fsf@toke.dk>
References: <20200527010905.48135-1-dsahern@kernel.org>
        <20200527010905.48135-5-dsahern@kernel.org>
        <87367l3dcd.fsf@toke.dk>
        <18823a44-09ba-0b45-2ce3-f34c08c6ea5f@gmail.com>
        <87o8q91ky1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 May 2020 17:01:10 +0200
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> David Ahern <dsahern@gmail.com> writes:
>=20
> > On 5/27/20 4:02 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote: =20
> >> David Ahern <dsahern@kernel.org> writes:
> >>  =20
> >>> Support SEC("xdp_dm*") as a short cut for loading the program with
> >>> type BPF_PROG_TYPE_XDP and expected attach type BPF_XDP_DEVMAP. =20
> >>=20
> >> You're not using this in the selftest; shouldn't you be? Also, the
> >> prefix should be libbpf: not bpftool:, no?
> >>  =20
> >
> > The selftest is exercising kernel APIs - what is allowed and what is
> > not. =20
>=20
> Sure, but they also de facto serve as example code for features that are
> not documented anywhere else, so just seemed a bit odd to me that you
> were not using this to mark the programs.
>=20
> Anyway, not going to insist if you prefer explicitly setting
> expected_attach_type...

I actually think that it is better to demonstrate that it is possible to se=
t:=09

 attr.expected_attach_type =3D BPF_XDP_DEVMAP;

Because people will be grepping the source code to find examples ;-)

We could add a comment, that say SEC("xdp_dm") can be used as short cut.
--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

