Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC8FDEE75
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 15:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbfJUNyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 09:54:37 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30731 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728699AbfJUNyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 09:54:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571666075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8TSkad7Fzoi5A8T4oLQcTFjBEExfCBaBhToFCxzB1tc=;
        b=FSsf1LqoTI0JwjUz57qECDQ2PfV+n/5ZliDmZ64aOVk5+RIaEUlD5H9WTdih6528+Lp/QC
        N/5iwwbU3vmNMrQkosmr1+2j6H/JLL41yhY8J+Rad4kSaa/3YbW50XzSfomp6IeZmZc8FQ
        P4TPaK2wujEBy7IUkK8dYk546yV/hpk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-JfHUz7qkNTapHwIHEPx4IA-1; Mon, 21 Oct 2019 09:54:32 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B4F31005500;
        Mon, 21 Oct 2019 13:54:31 +0000 (UTC)
Received: from krava (unknown [10.43.17.61])
        by smtp.corp.redhat.com (Postfix) with SMTP id 74C9E54560;
        Mon, 21 Oct 2019 13:54:29 +0000 (UTC)
Date:   Mon, 21 Oct 2019 15:54:28 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH] bpftool: Try to read btf as raw data if elf read fails
Message-ID: <20191021135428.GB32718@krava>
References: <20191018103404.12999-1-jolsa@kernel.org>
 <d8620b04-346a-11eb-000f-34d0f9f0cd51@fb.com>
MIME-Version: 1.0
In-Reply-To: <d8620b04-346a-11eb-000f-34d0f9f0cd51@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: JfHUz7qkNTapHwIHEPx4IA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 04:48:25PM +0000, Andrii Nakryiko wrote:
> On 10/18/19 3:34 AM, Jiri Olsa wrote:
> > The bpftool interface stays the same, but now it's possible
> > to run it over BTF raw data, like:
>=20
> Oh, great, I had similar patch laying around for a while, never got to=20
> cleaning it up, though, so thanks for picking this up!
>=20
> >=20
> >    $ bpftool btf dump file /sys/kernel/btf/vmlinux
> >    libbpf: failed to get EHDR from /sys/kernel/btf/vmlinux
>=20
> We should implement this so that we don't get an extra log output with=20
> errors. I've been thinking about checking first few bytes of the file.=20
> If that matches BTF_MAGIC, then try to parse it as raw BTF, otherwise=20
> parse as ELF w/ BTF. Does it make sense?

ok, sounds good

jirka

