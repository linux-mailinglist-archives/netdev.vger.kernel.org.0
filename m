Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5642BCAD8
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 17:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbfIXPGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 11:06:35 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37448 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727834AbfIXPGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 11:06:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569337593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=47F98g0cYtJSkRl55B62bcc/hNiWgNt8iRsrYRSVUp8=;
        b=aEbhOxRgJ16EI2XOIzqkbEVPixkWBJlLWI3dPC5yi+z3H2rYp4vg9995pRmz3z7tHNUNok
        mTCMReiNT1baKGDdBtinj52z4IXdb1hQktZ9vW+8K76sy2ITJYGdPLnz7u/hPuN6VlF6RG
        mn9Iz15BDRWM2OBurgHaUbn9qaMZMpA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-seKgwc1SPwqFsGND13iZwQ-1; Tue, 24 Sep 2019 11:06:30 -0400
Received: by mail-wm1-f71.google.com with SMTP id o8so177795wmc.2
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 08:06:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lgUgNKjOg0oAOIDAqUbRojeHb+E5NGemROCfJhsOPsw=;
        b=XtgUoBTN7xNdzjgD38HZuurPYfQkkzQBmvrspgjh/phxF/z/EbrUo93NPxnHf48/V/
         RzcO4EfWSV+e2LUzYNvLREmcYPlQGIDSOdZyVfgcHL9vXz4rcwsQyYszO/j775qJpqNr
         NuF48DXFDII2pHFx5ZbfWHc2avgVdQZGyttuglLJoaJQ0l1V+2+dzadjDz7+qTM89p1h
         koAuglJdV8pulAWBHQpQKnXMc6mNCKIZdGywmiFIqDlt3PplhZnG9nSNrlhaW7edLfi/
         yO2RlzfPEsH3JRXDepNZrPP7X0NFCWzxTrFDT2yqexFe1mdtfhdr8MKUDJgh7MrjlUq8
         n6/g==
X-Gm-Message-State: APjAAAUsamhAkktCe5KYKb8q3BoL8JLeYiFZhbX3A7Nf9+H5jPNDrPQO
        xZa/Ky7GkfDz78GguYBA1pNHLpVBOQoUTzSzfnJjRt1FionOFFsdxJgr13skdmgXcBxTiyDVVmK
        yIXWrufRhuwGoT8yq
X-Received: by 2002:a7b:c758:: with SMTP id w24mr514087wmk.148.1569337589058;
        Tue, 24 Sep 2019 08:06:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxvIcJwg1iUpLLeSRbP3U6VFzm/5MMEzYXCC0tEALgjQLBhkCfgzYUhccJOWD4mzVDSZHdAow==
X-Received: by 2002:a7b:c758:: with SMTP id w24mr514065wmk.148.1569337588812;
        Tue, 24 Sep 2019 08:06:28 -0700 (PDT)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id z4sm2240342wrh.93.2019.09.24.08.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 08:06:28 -0700 (PDT)
Date:   Tue, 24 Sep 2019 17:06:26 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Takeshi Misawa <jeliantsurux@gmail.com>
Cc:     Paul Mackerras <paulus@samba.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net] ppp: Fix memory leak in ppp_write
Message-ID: <20190924150626.GA12337@linux.home>
References: <20190922074531.GA1450@DESKTOP>
MIME-Version: 1.0
In-Reply-To: <20190922074531.GA1450@DESKTOP>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: seKgwc1SPwqFsGND13iZwQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 22, 2019 at 04:45:31PM +0900, Takeshi Misawa wrote:
> When ppp is closing, __ppp_xmit_process() failed to enqueue skb
> and skb allocated in ppp_write() is leaked.
>=20
> syzbot reported :
> BUG: memory leak
> unreferenced object 0xffff88812a17bc00 (size 224):
>   comm "syz-executor673", pid 6952, jiffies 4294942888 (age 13.040s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000d110fff9>] kmemleak_alloc_recursive include/linux/kmemleak.=
h:43 [inline]
>     [<00000000d110fff9>] slab_post_alloc_hook mm/slab.h:522 [inline]
>     [<00000000d110fff9>] slab_alloc_node mm/slab.c:3262 [inline]
>     [<00000000d110fff9>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3574
>     [<000000002d616113>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
>     [<000000000167fc45>] alloc_skb include/linux/skbuff.h:1055 [inline]
>     [<000000000167fc45>] ppp_write+0x48/0x120 drivers/net/ppp/ppp_generic=
.c:502
>     [<000000009ab42c0b>] __vfs_write+0x43/0xa0 fs/read_write.c:494
>     [<00000000086b2e22>] vfs_write fs/read_write.c:558 [inline]
>     [<00000000086b2e22>] vfs_write+0xee/0x210 fs/read_write.c:542
>     [<00000000a2b70ef9>] ksys_write+0x7c/0x130 fs/read_write.c:611
>     [<00000000ce5e0fdd>] __do_sys_write fs/read_write.c:623 [inline]
>     [<00000000ce5e0fdd>] __se_sys_write fs/read_write.c:620 [inline]
>     [<00000000ce5e0fdd>] __x64_sys_write+0x1e/0x30 fs/read_write.c:620
>     [<00000000d9d7b370>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c=
:296
>     [<0000000006e6d506>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> Fix this by freeing skb, if ppp is closing.
>=20
> Fixes: 6d066734e9f0 ("ppp: avoid loop in xmit recursion detection code")
> Reported-and-tested-by: syzbot+d9c8bf24e56416d7ce2c@syzkaller.appspotmail=
.com
> Signed-off-by: Takeshi Misawa <jeliantsurux@gmail.com>
> ---
> Dear Guillaume Nault, Paul Mackerras
>=20
> syzbot reported memory leak in net/ppp.
> - memory leak in ppp_write
>=20
> I send a patch that passed syzbot reproducer test.
> Please consider this memory leak and patch.
>=20
> Regards.
> ---
>  drivers/net/ppp/ppp_generic.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.=
c
> index a30e41a56085..9a1b006904a7 100644
> --- a/drivers/net/ppp/ppp_generic.c
> +++ b/drivers/net/ppp/ppp_generic.c
> @@ -1415,6 +1415,8 @@ static void __ppp_xmit_process(struct ppp *ppp, str=
uct sk_buff *skb)
>  =09=09=09netif_wake_queue(ppp->dev);
>  =09=09else
>  =09=09=09netif_stop_queue(ppp->dev);
> +=09} else {
> +=09=09kfree_skb(skb);
>  =09}
>  =09ppp_xmit_unlock(ppp);
>  }

Thanks a lot Takeshi!

Reviewed-by: Guillaume Nault <gnault@redhat.com>
Tested-by: Guillaume Nault <gnault@redhat.com>

