Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8473FDEE79
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 15:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbfJUNzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 09:55:14 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34903 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728670AbfJUNzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 09:55:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571666113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WIAMzeyJ+ZKo3Nd2O7rto0N0RNJemAlLEIV7qe+Q9GU=;
        b=UIB+lZNzhOKOF0lAVSZaJPWrPOS4WflUSQZRwAbq4b8yySTTKYWbV56Ex99QYJeIXLh/gz
        Y+YJSvdjAo8HVegZcOIQxiiUN4uqI32dgUKUWXlJb6D9VFQeFjgwRbBE8NlnJEB3A4xReL
        rxZwB/SrK7ele2mDQYG+UfnTvf+ufu0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-RtVrPymVOQKnlGMRHgRrTA-1; Mon, 21 Oct 2019 09:55:09 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9FB3800D41;
        Mon, 21 Oct 2019 13:55:07 +0000 (UTC)
Received: from krava (unknown [10.43.17.61])
        by smtp.corp.redhat.com (Postfix) with SMTP id 54A52BAB5;
        Mon, 21 Oct 2019 13:55:03 +0000 (UTC)
Date:   Mon, 21 Oct 2019 15:55:02 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Martin Lau <kafai@fb.com>
Subject: Re: [PATCH] bpftool: Try to read btf as raw data if elf read fails
Message-ID: <20191021135502.GC32718@krava>
References: <20191018103404.12999-1-jolsa@kernel.org>
 <d8620b04-346a-11eb-000f-34d0f9f0cd51@fb.com>
 <78433b38-3f34-c97a-ee74-a9b6dee95aa2@fb.com>
MIME-Version: 1.0
In-Reply-To: <78433b38-3f34-c97a-ee74-a9b6dee95aa2@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: RtVrPymVOQKnlGMRHgRrTA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 08:04:44PM +0000, Yonghong Song wrote:

SNIP

> >> +=09FILE *f;
> >> +
> >> +=09if (stat(file, &st))
> >> +=09=09return btf;
> >> +
> >> +=09f =3D fopen(file, "rb");
> >> +=09if (!f)
> >> +=09=09return btf;
> >> +
> >> +=09buf =3D malloc(st.st_size);
> >> +=09if (!buf)
> >> +=09=09goto err;
> >> +
> >> +=09if ((size_t) st.st_size !=3D fread(buf, 1, st.st_size, f))
> >> +=09=09goto err;
> >> +
> >> +=09btf =3D btf__new(buf, st.st_size);
> >> +
> >> +err:
>=20
> Non error case can also reach here. Let us change
> label to a different name, e.g., "done"?

ok, will change

thanks,
jirka

