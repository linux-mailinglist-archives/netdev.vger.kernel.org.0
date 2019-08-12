Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62B8D8A311
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 18:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfHLQLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 12:11:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40012 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfHLQLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 12:11:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=acc3WF35LR8BXEDMGJ13kNusezGrO1SutQPhnhxeBCw=; b=eWv3m7KcDGlqFNO3Yad5F/wta
        m7r6ZVcp6p6MSp20w6n8sMza+rI0sCCtzdzvaJ3TzrPH21tYKbUNwBRcoKYULQcpISRzRUw85wPWX
        PsDY+oNVtbEx/9pBa5rePj62z8keperADcjWaAvzkFnSsKY345OTrNIthz+2TUHzE5cOWR1nQL9pV
        lY8CrO1+2H7TfGMCYSXJaR56QaxhZx/+FDrHEe8+SXzPddYMWzy1qxH9jq45Zx0MJpd8nC7dAwgyl
        OP15PscPVMaZDv5PNPv33OCBIwPjsr/wUnwyfOFDKXWPo1I8DXPQZSi7T8L6pC6oze7JjUqqSr4Dh
        I0o92n8GQ==;
Received: from [179.182.166.35] (helo=coco.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hxCv9-0005tS-LL; Mon, 12 Aug 2019 16:11:43 +0000
Date:   Mon, 12 Aug 2019 13:11:37 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Jonathan =?UTF-8?B?TmV1c2Now6RmZXI=?= <j.neuschaefer@gmx.net>
Cc:     linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        xdp-newbies@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Documentation: sphinx: Don't parse socket() as
 identifier reference
Message-ID: <20190812131137.74a4ddf3@coco.lan>
In-Reply-To: <20190812160708.32172-2-j.neuschaefer@gmx.net>
References: <20190812160708.32172-1-j.neuschaefer@gmx.net>
        <20190812160708.32172-2-j.neuschaefer@gmx.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, 12 Aug 2019 18:07:05 +0200
Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net> escreveu:

> With the introduction of Documentation/sphinx/automarkup.py, socket() is
> parsed as a reference to the in-kernel definition of socket. Sphinx then
> decides that struct socket is a good match, which is usually not
> intended, when the syscall is meant instead. This was observed in
> Documentation/networking/af_xdp.rst.
>=20
> Prevent socket() from being misinterpreted by adding it to the Skipfuncs
> list in automarkup.py.
>=20
> Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
> ---
>=20
> v2:
> - block socket() in Documentation/sphinx/automarkup.py, as suggested by
>   Jonathan Corbet
>=20
> v1:
> - https://lore.kernel.org/lkml/20190810121738.19587-1-j.neuschaefer@gmx.n=
et/
> ---
>  Documentation/sphinx/automarkup.py | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/sphinx/automarkup.py b/Documentation/sphinx/au=
tomarkup.py
> index a8798369e8f7..5b6119ff69f4 100644
> --- a/Documentation/sphinx/automarkup.py
> +++ b/Documentation/sphinx/automarkup.py
> @@ -26,7 +26,8 @@ RE_function =3D re.compile(r'([\w_][\w\d_]+\(\))')
>  # just don't even try with these names.
>  #
>  Skipfuncs =3D [ 'open', 'close', 'read', 'write', 'fcntl', 'mmap',
> -              'select', 'poll', 'fork', 'execve', 'clone', 'ioctl']
> +              'select', 'poll', 'fork', 'execve', 'clone', 'ioctl',
> +              'socket' ]

Both patches sound OK on my eyes. Yet, I would just fold them into
a single one.

In any case:

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
>=20
>  #
>  # Find all occurrences of function() and try to replace them with
> --
> 2.20.1
>=20



Thanks,
Mauro
