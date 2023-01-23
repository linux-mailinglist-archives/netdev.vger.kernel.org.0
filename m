Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C61678185
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 17:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbjAWQdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 11:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233166AbjAWQdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 11:33:23 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40B12B612
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 08:33:20 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id s67so9389158pgs.3
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 08:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eIyeR/Jqsucv7tljbxuF2NsWpN9ZLMM10wqA6VnPC/k=;
        b=jGHpPFVzXFGljnC8Apl/jSseC1f8cklRPfLICkpodYvupcBlt77FgWUl3spJZZUze4
         +b9rx38evVW2I0y1k/lrDIpl3C9YIM8RvLBYGlfg7dssVdpmVtCaSJ7G37UpZ2bJze4T
         hL77JihMgJoXPyfczrdFIvqtYP1c82nfCKvtXAVybx6bGSLM6YvcRVRGYcYsHcVS1qbr
         G13RLmTnHuQ3LSG+O9GikF8H/h6ZGqlzdPD4ahDuDy+XBcQD4+eCzyCvhFao3LkaZJVN
         a9C3zxEFSJZWEfp1k7elfyIdF36i6x4PzKAASCaSAp+gUBgCdBZIJHQTqeucRMF3AuGJ
         qHWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eIyeR/Jqsucv7tljbxuF2NsWpN9ZLMM10wqA6VnPC/k=;
        b=FKbTqbYDqs/P5YXNHF8gqY/mPAinuJnlwubrcmNNOrCwX51VM3loK6BKApM3PsfN7D
         j+pGP/3XCfdSvNV4yshgrurF50/YI7g+6aicqZjZ3fgryVyIFq7ezYRLVucGggOAN+OJ
         syssu7I4LjHGDJJKVbcPl+J2LG+rA/aQ3tuQ3i2HgQiHAV1pK2dvbETDCTFg09dMS9Ca
         HkEPKMX87RMFkNQyQ01ZrQhuRLs1emSooOMj1ecDijLoxCI3dGDhuj8Bu6q1DCINheGw
         BB2N488TAnqsSOsJNGSt5SSHjvXT+FEFmdXZqG8v3A+8IoQVdMujhhWO6wDxaXHqDRcM
         ewug==
X-Gm-Message-State: AFqh2krzPhuZtAamo8Vqux+KEZO94icPDau37FgpP1kCxStyMddh0lNP
        QAUkV8dAk9lMwn7Id9uv+6Z0xQ==
X-Google-Smtp-Source: AMrXdXuxO1M0Nsnycvf1Nd2W6A8QDJdennBlONfGpdsASbMgLGlXVKLrav0lqYLhaPC0pCpNCN6ofw==
X-Received: by 2002:a62:38d8:0:b0:582:ca4d:f6a7 with SMTP id f207-20020a6238d8000000b00582ca4df6a7mr49986563pfa.4.1674491600080;
        Mon, 23 Jan 2023 08:33:20 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id k6-20020aa79d06000000b00576259507c0sm16830068pfp.100.2023.01.23.08.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 08:33:19 -0800 (PST)
Date:   Mon, 23 Jan 2023 08:33:17 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Diederik de Haas <didi.debian@cknow.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:BONDING DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/bonding: Fix full name of the GPL
Message-ID: <20230123083317.252f0313@hermes.local>
In-Reply-To: <6d9053c6-b56e-51f4-db47-79264f1f5672@wanadoo.fr>
References: <20230122182048.54710-1-didi.debian@cknow.org>
        <6d9053c6-b56e-51f4-db47-79264f1f5672@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Jan 2023 20:52:33 +0100
Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> Le 22/01/2023 =C3=A0 19:20, Diederik de Haas a =C3=A9crit=C2=A0:
> > Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
> > ---
> >   drivers/net/bonding/bonding_priv.h | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/net/bonding/bonding_priv.h b/drivers/net/bonding/b=
onding_priv.h
> > index 48cdf3a49a7d..353972436e5b 100644
> > --- a/drivers/net/bonding/bonding_priv.h
> > +++ b/drivers/net/bonding/bonding_priv.h
> > @@ -8,7 +8,7 @@
> >    * (c) Copyright 1999, Thomas Davis, tadavis@lbl.gov
> >    *
> >    *	This software may be used and distributed according to the terms
> > - *	of the GNU Public License, incorporated herein by reference.
> > + *	of the GNU General Public License, incorporated herein by reference.
> >    *
> >    */
> >    =20
>=20
> Hi,
>=20
> maybe a SPDX-License-Identifier: could be added and these few lines=20
> removed instead?

Yes, that is the correct fix. Please don't update the boilerplate.
