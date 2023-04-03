Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38666D4C91
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbjDCPvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbjDCPuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:50:52 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5489F3A97;
        Mon,  3 Apr 2023 08:50:29 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id mp3-20020a17090b190300b0023fcc8ce113so32999106pjb.4;
        Mon, 03 Apr 2023 08:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680537029;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DB5H55fJR1VLr/WAs2lRo3o9WITN/lrYSz7m0J6ndKo=;
        b=OaJikLqLCncWm6Ezv97cOQQbPjqf76juh9puB9T99izatTGfSA4GZm5JgyuSKVu2il
         06/IolluwQcUwf4kmZcK+UcNeepPS6JF46DuK0pUhVZ4e+xfEuzF/dtgUJGfXOd0psjK
         XJKLqckxE4FrzYGHbll4X8T2Uq+q4rBQbfVPSg+AS9+aJUh5JsPAN+pnECLVgldsCIgp
         EIimK5dr62rldl3N21MbF3mzp+dkAHOPjCTBKuETGQhmtevIBvbJL4ICEZ7gbU0iqbIq
         9oq9XtUB+ipaiiOBfUc0BtIuLNVZ+QhklbZACgCDqDSTbx5xnjOWIMIVOEr892JXcnUT
         5O/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680537029;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DB5H55fJR1VLr/WAs2lRo3o9WITN/lrYSz7m0J6ndKo=;
        b=fQ4m/Y22wFWNAZxBU6E7jgxHC+eDqVKRGvuwQp8Puw/rNbrcaSpBtgNrtFh/QcWSpW
         KLnCdp0npN9Up5IYz63Dj7mw8r1ton79MWSGSf1R2PVtFPQrIHu9XQj93cXOB72EKPUy
         C+i8Sw2PtceSJbWC7ncD3M8fDqVFsG0d1rrdeEtmiuHuM/aQ3DBmAGB7ElvB85RejtUy
         f9vhN9t2J5TvH7DWXbWzvCPOrR19Fri3BXDOdl2eTgEu4vsA5cfmexYwgBNrvq3VFRp3
         oTgA0I5DET7DpqVFHpfFRYXaUzp84oBPgey4ls8zAcTYD6GUCQSautKeRBbsaAmOuSUJ
         toxw==
X-Gm-Message-State: AO0yUKVAh8LX3xtzS1LSiWRSa9loSUOk7hxCaL/JDxpsI//ku2wgwyQ9
        B9TdNWhuQDbAQZwa4+kNLGI=
X-Google-Smtp-Source: AK7set/9V06hsGqN7e2BIK0qRdb+PwZ+DtMj99zmbrQcWUTe7rVPgoJViW4rjIjgCrxAEo34Ikadlg==
X-Received: by 2002:a05:6a20:2e90:b0:da:2fdf:385e with SMTP id bj16-20020a056a202e9000b000da2fdf385emr31150977pzb.49.1680537028548;
        Mon, 03 Apr 2023 08:50:28 -0700 (PDT)
Received: from [192.168.0.128] ([98.97.115.185])
        by smtp.googlemail.com with ESMTPSA id r14-20020a62e40e000000b00627ee6dcb84sm7058242pfh.203.2023.04.03.08.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 08:50:28 -0700 (PDT)
Message-ID: <30549453e8a40bb4f80f84e1a1427149b6b8b9e8.camel@gmail.com>
Subject: Re: [PATCH] net: Added security socket
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Denis Arefev <arefev@swemel.ru>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, trufanov@swemel.ru, vfh@swemel.ru
Date:   Mon, 03 Apr 2023 08:50:26 -0700
In-Reply-To: <20230403124323.26961-1-arefev@swemel.ru>
References: <20230403124323.26961-1-arefev@swemel.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-04-03 at 15:43 +0300, Denis Arefev wrote:
> 	Added security_socket_connect
> 	in kernel_connect
>=20
> Signed-off-by: Denis Arefev <arefev@swemel.ru>
> ---
>  net/socket.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/net/socket.c b/net/socket.c
> index 9c92c0e6c4da..9afa2b44a9e5 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -3526,6 +3526,12 @@ EXPORT_SYMBOL(kernel_accept);
>  int kernel_connect(struct socket *sock, struct sockaddr *addr, int addrl=
en,
>  		   int flags)
>  {
> +	int err;
> +
> +	err =3D security_socket_connect(sock, (struct sockaddr *)addr, addrlen)=
;
> +	if (err)
> +		return err;
> +
>  	return sock->ops->connect(sock, addr, addrlen, flags);
>  }
>  EXPORT_SYMBOL(kernel_connect);

Why would we need to be adding this? If we are already operating within
kernel space it seems like it would be more problematic than not to
have to push items out to userspace for security. Assuming an attacker
is operating at the kernel level the system is already compromised is
it not?

Also assuming we do need this why are we only dealing with connect when
we should probably also be looking at all the other kernel socket calls
then as well?

