Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9280639F052
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhFHICN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhFHICI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:02:08 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4000C061574;
        Tue,  8 Jun 2021 01:00:14 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id m21so14947438lfg.13;
        Tue, 08 Jun 2021 01:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/zwC/kyfhzlU9ELEMaOUsa+R12SEwNDHqbYhuIjCnI0=;
        b=b6smCZlSuJg4PVXjTq2KZanbEL4Yja4T/OMZb6aHCQ0oTo2BkHN5R72NdLc5e37FwP
         nDd7bCIflLJ2BTDBaSwZhOCGy9bJD7n1FgY4F3X1PTnIn7SHBX/M2f9e8hkKvMuMCQq6
         AvGAI5AVyO73h2shLD2NMZK4OFNxn0uCMUx+7s3Gr/GL3NMVxPwTITIPo8XpylQQBZQf
         o84QIqD/UXCOsNocHZo9oupA+fGSHk/88o39gUkmSIMIHxrczsOkv4sHqGpJfmcaurqP
         GIMWE/clEn1hTVt4fy34qHx9YK19QPtq/ox+l3oiLFNNYzReWEZ1ZR8DsICpU+xfwZ3H
         aTRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/zwC/kyfhzlU9ELEMaOUsa+R12SEwNDHqbYhuIjCnI0=;
        b=IJenjdjdFl2aXZ9Jfsq45t6vKgBgWQKEG/MEXL9a3+fGi7qAJ6ehlTtjZ3dBexUUbB
         KySvk5tEV0yFNOqHoBcBiaDbHcZiZk8vxKhh77DUC0lUiKAsZe7d0kCT0MbhW7N8Kmwv
         LiWSHs09jXZmGs3SxZ06ho8GSSMFw+XpnHZ/xFkn9XtRv7P+1l3Yi4NZN69m6tcG09CZ
         FtfP655fhHIioxtuyxBtrjvYlV7cs5LKDeSiaIobaX+azxq1fmT2072Yqvv6PB/An/H7
         vkY7+IkFTGmhQ66G7LVSJZMnhZavI+lO24GZYI+bb5sHotgYr36QafovCEPFdxoWgxk9
         lekw==
X-Gm-Message-State: AOAM532U8bXtGvpc5xc0FW8dH7lJwHLpNiewSADe8l5b6ziP6qpEgiFR
        Oi0YSodQf8DrPov1knReZpM=
X-Google-Smtp-Source: ABdhPJx4rhGsbnzUeei4HZMeEzBjtQMeVgfHvcMrX0ZYJPTgZXLhbb/EgvzolL6zGE66voa6ImkAqQ==
X-Received: by 2002:ac2:5d4f:: with SMTP id w15mr14361525lfd.348.1623139209262;
        Tue, 08 Jun 2021 01:00:09 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id w24sm1798743lfa.143.2021.06.08.01.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 01:00:09 -0700 (PDT)
Date:   Tue, 8 Jun 2021 11:00:06 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Haakon Bugge <haakon.bugge@oracle.com>
Cc:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com" 
        <syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com>
Subject: Re: [PATCH] net: rds: fix memory leak in rds_recvmsg
Message-ID: <20210608110006.5dbca106@gmail.com>
In-Reply-To: <CF68E17D-CC8A-4B30-9B67-4A0B0047FCE1@oracle.com>
References: <20210607194102.2883-1-paskripkin@gmail.com>
        <CF68E17D-CC8A-4B30-9B67-4A0B0047FCE1@oracle.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Jun 2021 07:11:27 +0000
Haakon Bugge <haakon.bugge@oracle.com> wrote:

>=20
>=20
> > On 7 Jun 2021, at 21:41, Pavel Skripkin <paskripkin@gmail.com>
> > wrote:
> >=20
> > Syzbot reported memory leak in rds. The problem
> > was in unputted refcount in case of error.
> >=20
> > int rds_recvmsg(struct socket *sock, struct msghdr *msg, size_t
> > size, int msg_flags)
> > {
> > ...
> >=20
> > 	if (!rds_next_incoming(rs, &inc)) {
> > 		...
> > 	}
> >=20
> > After this "if" inc refcount incremented and
> >=20
> > 	if (rds_cmsg_recv(inc, msg, rs)) {
> > 		ret =3D -EFAULT;
> > 		goto out;
> > 	}
> > ...
> > out:
> > 	return ret;
> > }
> >=20
> > in case of rds_cmsg_recv() fail the refcount won't be
> > decremented. And it's easy to see from ftrace log, that
> > rds_inc_addref() don't have rds_inc_put() pair in
> > rds_recvmsg() after rds_cmsg_recv()
> >=20
> > 1)               |  rds_recvmsg() {
> > 1)   3.721 us    |    rds_inc_addref();
> > 1)   3.853 us    |    rds_message_inc_copy_to_user();
> > 1) + 10.395 us   |    rds_cmsg_recv();
> > 1) + 34.260 us   |  }
> >=20
> > Fixes: bdbe6fbc6a2f ("RDS: recv.c")
> > Reported-and-tested-by:
> > syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com
> > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>=20
> Thank for your commit and analyses. One small nit below.
>=20
> > ---
> > net/rds/recv.c | 3 ++-
> > 1 file changed, 2 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/net/rds/recv.c b/net/rds/recv.c
> > index 4db109fb6ec2..3fa16c339bfe 100644
> > --- a/net/rds/recv.c
> > +++ b/net/rds/recv.c
> > @@ -714,7 +714,7 @@ int rds_recvmsg(struct socket *sock, struct
> > msghdr *msg, size_t size,
> >=20
> > 		if (rds_cmsg_recv(inc, msg, rs)) {
> > 			ret =3D -EFAULT;
> > -			goto out;
> > +			goto out_put;
>=20
> Would a simple "break;" do it here and no need for the next hunk?
>=20
>=20
> Thxs, H=C3=A5kon
>=20

Sure! I'll send v2 soon. Thank you for feedback :)


With regards,
Pavel Skripkin
