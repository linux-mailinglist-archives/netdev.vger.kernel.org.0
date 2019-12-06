Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE03A1153B0
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 15:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfLFO40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 09:56:26 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31967 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726234AbfLFO4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 09:56:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575644184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pZiMi9GA37xMLOFTmxZhVvHZSfLZNfqkbCgqTYdRzFY=;
        b=ean+9Ue5jI6X1H2ZdbVMZfGH1BIZoyFq8wG4HlGDzj1Q0yrW6j+9INT12196kf78c115+X
        81F1OoOi/AUOGWZTDLbNNVsorqYSTN05Sw10360sbQf/VnvqmMXsxpWEsp5Fmu1ANJukDB
        Ornm6oQ28daLgao4wOTcJQhhG0hBG/M=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-7hqB8XEbMKeEXUK8BaexAA-1; Fri, 06 Dec 2019 09:56:23 -0500
Received: by mail-wr1-f69.google.com with SMTP id r2so3251052wrp.7
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 06:56:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TKbuZUAf1dCKq8jnpQSBCg+axcK4Bo/Qt06gTAOaFYo=;
        b=Ng7kYUCFojvN7KMlRsa088afq+ujBehZs26Yf5RoX/wkLEME8+ZEjylP5PISdEE7CI
         afTrcw0lqY4KhbdhBhVcwg+pvTo6TIgDfXFXL3bnnbx8jcO27urobzRYrsbjjn/wkHnJ
         nALVf61APDq5ZZKNHT3smGu9NeqWas2Nn0Vj6fMpXeG8g7pAkUK+0arYuEqOyV9yDWjj
         FUdDti0/7/bYBAIk9EGaEbpHKEDRPq4k8p4z6iMPkXuaCZiw4mG95coxPkaApZPXJmf6
         v+pVOpVKHk8+10149MwBVU53Rm6fXmxqYPlF3o9FW+V7bu/2PoZGX2nE0I6GBzARaK9U
         kETg==
X-Gm-Message-State: APjAAAWFtuhQlxKJQ7PH83M4e+JRMR55HnqF1xEZRFUx5mhVkNbpY9z/
        QZqG8NJoQf86wGAIes6yhjwZc5q7OGIG9/VaN/oZyWkzUhzEaoHQN06T+AUn7RWQ2C6ilGSLaIJ
        wRUvOMeR0dP8g0DDk
X-Received: by 2002:adf:b64e:: with SMTP id i14mr15788166wre.332.1575644181994;
        Fri, 06 Dec 2019 06:56:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqyaVmms+HbzDV1KRBndmLQS8NM9mEPWrhOpX+hnkWl6jR7C0hNyGAx2B3bhw8bgSaKH9RTz/A==
X-Received: by 2002:adf:b64e:: with SMTP id i14mr15788150wre.332.1575644181828;
        Fri, 06 Dec 2019 06:56:21 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id k20sm3385389wmj.10.2019.12.06.06.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2019 06:56:21 -0800 (PST)
Date:   Fri, 6 Dec 2019 15:56:19 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     klju@umn.edu, Michal Ostrowski <mostrows@earthlink.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pppoe: remove redundant BUG_ON() check in pppoe_pernet
Message-ID: <20191206145619.GA3930@linux.home>
References: <20191205230342.8548-1-pakki001@umn.edu>
MIME-Version: 1.0
In-Reply-To: <20191205230342.8548-1-pakki001@umn.edu>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: 7hqB8XEbMKeEXUK8BaexAA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 05, 2019 at 05:03:42PM -0600, Aditya Pakki wrote:
> Passing NULL to pppoe_pernet causes a crash via BUG_ON.
> Dereferencing net in net_generici() also has the same effect. This patch
> removes the redundant BUG_ON check on the same parameter.
>=20
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  drivers/net/ppp/pppoe.c | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
> index a44dd3c8af63..d760a36db28c 100644
> --- a/drivers/net/ppp/pppoe.c
> +++ b/drivers/net/ppp/pppoe.c
> @@ -119,8 +119,6 @@ static inline bool stage_session(__be16 sid)
> =20
>  static inline struct pppoe_net *pppoe_pernet(struct net *net)
>  {
> -=09BUG_ON(!net);
> -
>  =09return net_generic(net, pppoe_net_id);
>  }
> =20
Looks like a net-next patch, but net-next is currently closed (take a
look Documentation/networking/netdev-FAQ.rst for details).

You can add my ack when you repost:
Acked-by: Guillaume Nault <gnault@redhat.com>

