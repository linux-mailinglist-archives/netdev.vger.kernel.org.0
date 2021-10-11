Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D17428C17
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 13:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbhJKLeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 07:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhJKLeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 07:34:23 -0400
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CCFC061570;
        Mon, 11 Oct 2021 04:32:23 -0700 (PDT)
Received: by mail-vk1-xa29.google.com with SMTP id h132so7314309vke.8;
        Mon, 11 Oct 2021 04:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eNa93UMI1KiLker/dCP3o2bqpfQeSaV3eWLJOG/vVio=;
        b=Rzena0a7V5vrmnlo5hrGRIdiwOk4le7r8evuBSiprGeSp1tonpZL+pOKEZbcKiBv4I
         cM+V8IxE53CwxcUXAgXRz/6BVMSg3FakemkeBhqIM5JqXEuEPr7psABbP9MEI9pApuZz
         cb2c97BX+/tez9QVRZzcw6a43fHfLX7gaCO08nLNQ//vymLn13VEJD+DKd88XlShGMf8
         dwZOQYXPbmSZR5FXUHFbL/YyKhLPJs7Mfvpyon6OAS/Wi3dOs0TJ2sBrt++2ZIpKRfTE
         WMucrZCpRf8Pk/Ou8zhHDxnxT2nLikZtezAlULxHmKop3+VlizUk72Tm9lbe7RKpETDU
         8I4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eNa93UMI1KiLker/dCP3o2bqpfQeSaV3eWLJOG/vVio=;
        b=Pa30HDxeift4vVngOnmRGvYfgTZ+qd9JXA7u9peEiaQJ7ecCDKpI8VH/EqOwfHxoZq
         7SZ2S1ucbbYR04Q7E3VJ9wTyGms8d5gDNzHLi+mnHUumc9isqRz5cJJvpo+XD2CDHift
         Br3TxBw8dm97OkAXGaL2IFGCOoc4F+g85BFd2BjVmNu79dU7XuaKCRjSJwpxe8KrYDBr
         Ffklo1Kb1x+Ooh6o8nCTL3Vs5rLEYKRFOAvMbAu7jzmdT3NeKq5kk7IlNr9HEset2HGs
         3GagSQx6/MO+UTxbZQcYOkwFg5PspiUy4rZ0+38efQTuDhtkmM5zmYsitQ1XDoxhm4Rn
         1Cag==
X-Gm-Message-State: AOAM533xAJRSj8I6JR6gHe1Oi4SD+ZOalBw9QD1h9VCQajkuhI5jhcYC
        3NKybgKHE2gu0WgvLUcjFqtZKvDgWUmSNyueR3I+1vw2xL5T4Q==
X-Google-Smtp-Source: ABdhPJyIMDsIEZYlK6aJkJqPNpkAlQ027vBCK30OJJFpbXI47dhL9jHszMc5chT9H+l/tMDsLwshj3qs4eRHix8apgA=
X-Received: by 2002:a1f:ab8f:: with SMTP id u137mr19235637vke.17.1633951942715;
 Mon, 11 Oct 2021 04:32:22 -0700 (PDT)
MIME-Version: 1.0
References: <20211011064524.20003-1-sakiwit@gmail.com>
In-Reply-To: <20211011064524.20003-1-sakiwit@gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 11 Oct 2021 13:31:50 +0200
Message-ID: <CAOi1vP98SM3Z7zr9vZS8C_4-mPHgbSNHiOwkKmfVKXu6xRf0+w@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ceph: fix ->monmap and err initialization
To:     =?UTF-8?B?Ss61YW4gU2FjcmVu?= <sakiwit@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 8:45 AM J=CE=B5an Sacren <sakiwit@gmail.com> wrote:
>
> From: Jean Sacren <sakiwit@gmail.com>
>
> Call to build_initial_monmap() is one stone two birds.  Explicitly it
> initializes err variable. Implicitly it initializes ->monmap via call to
> kzalloc().  We should only declare err and ->monmap is taken care of by
> ceph_monc_init() prototype.
>
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> ---
>  net/ceph/mon_client.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> index 013cbdb6cfe2..6a6898ee4049 100644
> --- a/net/ceph/mon_client.c
> +++ b/net/ceph/mon_client.c
> @@ -1153,12 +1153,11 @@ static int build_initial_monmap(struct ceph_mon_c=
lient *monc)
>
>  int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl)
>  {
> -       int err =3D 0;
> +       int err;
>
>         dout("init\n");
>         memset(monc, 0, sizeof(*monc));
>         monc->client =3D cl;
> -       monc->monmap =3D NULL;
>         mutex_init(&monc->mutex);
>
>         err =3D build_initial_monmap(monc);

Applied.

Thanks,

                Ilya
