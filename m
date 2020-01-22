Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7DBE145BBA
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 19:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgAVSuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 13:50:40 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53295 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725884AbgAVSuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 13:50:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579719039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zNoxYuq2B3SzCdTu7t8JXyerWPxIHsDXZRdxz774RaE=;
        b=hy/SHPoGNW/rRScwMZsyVfeVpESVYipxokkxr+iSJVgMtRzf3KAvQ/yjzg2rcVXWZdE3fM
        2TNnzjDtZG+d5DJhiCo/O/JHeIU4DtlA8OPBa3WCNOAQ87X5FEltgFCFiORwq1PomLTgkq
        qtOqStNLlyWPZyJo8TTf/m+QrrlMkys=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-WTWIMSK5MouXDmAstx0OhQ-1; Wed, 22 Jan 2020 13:50:37 -0500
X-MC-Unique: WTWIMSK5MouXDmAstx0OhQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C9EF100550E;
        Wed, 22 Jan 2020 18:50:35 +0000 (UTC)
Received: from carbon (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9EA015D9C9;
        Wed, 22 Jan 2020 18:50:26 +0000 (UTC)
Date:   Wed, 22 Jan 2020 19:50:24 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Jubran, Samih" <sameehj@amazon.com>
Cc:     Luigi Rizzo <rizzo@iet.unipi.it>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNl?= =?UTF-8?B?bg==?= 
        <toke@redhat.com>, "Kiyanovski, Arthur" <akiyano@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, brouer@redhat.com
Subject: Re: XDP multi-buffer design discussion
Message-ID: <20200122195024.4bacf33a@carbon>
In-Reply-To: <9258f0767307489cb54428a8c1d91a0d@EX13D11EUB003.ant.amazon.com>
References: <BA8DC06A-C508-402D-8A18-B715FBA674A2@amazon.com>
 <b28504a3-4a55-d302-91fe-63915e4568d3@iogearbox.net>
 <5FA3F980-29E6-4B91-8150-9F28C0E09C45@amazon.com>
 <20190823084704.075aeebd@carbon>
 <67C7F66A-A3F7-408F-9C9E-C53982BCCD40@amazon.com>
 <20191204155509.6b517f75@carbon>
 <ec2fd7f6da44410fbaeb021cf984f2f6@EX13D11EUC003.ant.amazon.com>
 <20191216150728.38c50822@carbon>
 <CA+hQ2+jp471vBvRna7ugdYyFgEB63a9tgCXZCOjEQkT+tZTM1g@mail.gmail.com>
 <20191217094635.7e4cac1c@carbon>
 <CA+hQ2+jzz2dZONYbW_+H6rE+u50a+r8p5yLtAWWSJFvjmnBz1g@mail.gmail.com>
 <fda0d409b60b4e0a94a0ed4f53f4a3cc@EX13D11EUB003.ant.amazon.com>
 <20191219114438.0bcb33ea@carbon>
 <CA+hQ2+jUH52s==wYqWwJ5zZkDsiAFJ7+fz43BmqS4y84Lphzpg@mail.gmail.com>
 <9258f0767307489cb54428a8c1d91a0d@EX13D11EUB003.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 19 Jan 2020 07:34:00 +0000 "Jubran, Samih" <sameehj@amazon.com> wro=
te:

[...]
>=20
> We have two proposed design solutions.  One (Jesper=E2=80=99s) seems easi=
er
> to implement and gives the average XDP developer the framework to
> deal with multiple buffers.  The other (Luigi=E2=80=99s) seems more compl=
ete
> but raises a few questions:
>
> 1.	The netdev's callback might be too intrusive to the net
> drivers and requires the driver to somehow save context of the
> current processed packet
>
> 2.	The solution might be an overkill to the average XDP
> developer.  Does the average XDP developer really need full access to
> the packet?
>=20
> Since Jesper's design is easier to implement as well as leaves a way
> for future extension to Luigi's design, I'm going to implement and
> share it with you.

Thanks for letting us know you are still working on this.

_WHEN_ you hit issue please feel free to reach out to me. (p.s. I'll be
in Brno at DevConf.cz the next couple of days. But will be back
Tuesday and back on IRC at Freenode channel #xdp nick:netoptimizer).

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

