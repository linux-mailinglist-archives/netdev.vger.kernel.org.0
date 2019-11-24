Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9EB6108554
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 23:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKXWin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 17:38:43 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27003 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726855AbfKXWin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 17:38:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574635122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/G9Wi4bZIYtsLMYWyzhkBqJDx6M9Zopv+NNCrBqV6+0=;
        b=FdK68jZGiLe/estV9mizwJbCFqvWXu6XOHLXR7D5hgnEupQA/WYlZveev4FKr8rX5Y1FJ/
        wNzpnkJDNDvImPzGvi3on6My41ErzhceEcUHp64fIP3HryHwJvbCMieMNY7BiFtXwAiNkn
        8v3Z7GoRaH67TZsAiU5F1R/FsfnFQLI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-kUO5aoyyOeCAi-UKsva4bQ-1; Sun, 24 Nov 2019 17:38:36 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CCF9A1007269;
        Sun, 24 Nov 2019 22:38:34 +0000 (UTC)
Received: from krava (ovpn-204-42.brq.redhat.com [10.40.204.42])
        by smtp.corp.redhat.com (Postfix) with SMTP id 542E25C1D4;
        Sun, 24 Nov 2019 22:38:28 +0000 (UTC)
Date:   Sun, 24 Nov 2019 23:38:27 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        linux-audit@redhat.com, Jiri Olsa <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Subject: Re: [PATCH] bpf: emit audit messages upon successful prog load and
 unload
Message-ID: <20191124223742.GA20575@krava>
References: <20191120213816.8186-1-jolsa@kernel.org>
 <8c928ec4-9e43-3e2a-7005-21f40fcca061@iogearbox.net>
 <CAADnVQKu-ZgFTaSMH=Q-jMOYYvE32TF2b2hq1=dmDV8wAf18pg@mail.gmail.com>
 <CAHC9VhQbQoXacbTCNJPGNzFOv30PwLeiWu4ROQFU46=saTeTNQ@mail.gmail.com>
 <20191122002257.4hgui6pylpkmpwac@ast-mbp.dhcp.thefacebook.com>
 <CAHC9VhRihMi_d-p+ieXyuVBcGMs80SkypVxF4gLE_s45GKP0dg@mail.gmail.com>
 <20191122192353.GA2157@krava>
 <CAHC9VhRi0JtKgHyAOdAJ=_--vL1VbK7BDq1FnRQ_GwW9P4J_zA@mail.gmail.com>
 <20191123085719.GA1673@krava>
 <20191123100340.771bfd25@cakuba.netronome.com>
MIME-Version: 1.0
In-Reply-To: <20191123100340.771bfd25@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: kUO5aoyyOeCAi-UKsva4bQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 10:03:40AM -0800, Jakub Kicinski wrote:
> On Sat, 23 Nov 2019 09:57:19 +0100, Jiri Olsa wrote:
> > Alexei already asked Dave to revert this in previous email,
> > so that should happen
>=20
> Reverted in net-next now.
>=20
> But this is not really how this should work. You should post a proper
> revert patch to netdev for review, with an explanation in the commit
> message etc.

I had no idea I need to post the revert, sorry
will do next time

thanks,
jirka

