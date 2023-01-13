Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7F36690AD
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 09:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbjAMIYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 03:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240887AbjAMIXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 03:23:24 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB9056882;
        Fri, 13 Jan 2023 00:23:21 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id f3so14503094pgc.2;
        Fri, 13 Jan 2023 00:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k1/ckMgmFgbi3RU+07o59Ls7nkdE9iDSwV58pHA1aAc=;
        b=LNX0ai1rLm3fxqQ/NI7qaXnw/F7ipPtQsMXhz3rCQNMC7IgkUb0gDM4adZ0NM0/kLM
         VJrEEzv2FcxWqPlMwO5Q5HuwQOTjRS513qbIUHv3KpdiiFcYe3ACKsHnPDF6MwBYwpAJ
         DT4wvzobmqr9easaK+FI+ooDV1vEAAm0ELTUIPNjQiJhHwWBkuc5qiQFuwAI8c3QaiZW
         J7ndLP0E0zyIvzVkpqjP1PfPTc4eRf2303ob4d78JXoYft7V2tbSzbW2HBK+vIqPLPdu
         51MWkthm5PQNGJ9bc/hwEnwH/NTTNBmuGw78i2pfvjbX0AvkCOXiTznowiLKRAC6eOKj
         lSKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1/ckMgmFgbi3RU+07o59Ls7nkdE9iDSwV58pHA1aAc=;
        b=jFO9vxXp++SbEE8TDsC0yuvHcnVdaGwPisV29CHGA6SqRA1rhC+MO7whfEA6/X2zdJ
         wrUj+d+XI7FLwHNZUVB2j5wd9TICag6dhMaerFot1mfrfWmFiU694h7o3o+tsUC276Yb
         wP2sSVr1GFsVBpxPixWL+Bx00bng0bQeE1dLbfyKUAO5jaUUurOlAjdJUwNh+adN4fkO
         wof3TL47nWAEnpJymUj2WwZFhdywdESfvQ08ifmZWIvrPq08q6p9F00GmNy7end13We9
         LLslhEKKON0JxYsRX+UVQRpi7IwnEQnLpf6mHuSuyYlDW7fXUJ1wydOzq8xrMC0x5fk5
         89fw==
X-Gm-Message-State: AFqh2kpuhfHotcYlahiht3BZL14KivXKrbmiwwJi05+zSurnzygfUjuB
        z3gyfHNop3ui6s+zF+KSFzQ=
X-Google-Smtp-Source: AMrXdXtjEMLe0axPeiVK01K1WQ+V9oS52ksqegIQMgcvtYoxpifgHLVYWLsPRxG1Rokq1tqvOetaAQ==
X-Received: by 2002:a62:30c2:0:b0:580:ccae:291c with SMTP id w185-20020a6230c2000000b00580ccae291cmr65233933pfw.24.1673598200804;
        Fri, 13 Jan 2023 00:23:20 -0800 (PST)
Received: from debian.me (subs02-180-214-232-12.three.co.id. [180.214.232.12])
        by smtp.gmail.com with ESMTPSA id y29-20020aa793dd000000b0056c2e497b02sm13553641pff.173.2023.01.13.00.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 00:23:20 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id C7EFC104A90; Fri, 13 Jan 2023 15:23:17 +0700 (WIB)
Date:   Fri, 13 Jan 2023 15:23:17 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org
Subject: Re: [PATCH v2 net-next 1/1] plca.c: fix obvious mistake in checking
 retval
Message-ID: <Y8EU9bCLj6UOz7g8@debian.me>
References: <df38c69a85bf528f3e6e672f00be4dc9cdd6298e.1673538908.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="VIr47Z0aK9LAgJcZ"
Content-Disposition: inline
In-Reply-To: <df38c69a85bf528f3e6e672f00be4dc9cdd6298e.1673538908.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--VIr47Z0aK9LAgJcZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 12, 2023 at 04:56:11PM +0100, Piergiorgio Beruto wrote:
> This patch addresses a wrong fix that was done during the review
> process. The intention was to substitute "if(ret < 0)" with
> "if(ret)". Unfortunately, in this specific file the intended fix did not
> meet the code. After additional review, it seems like if(ret < 0) was
> actually the right thing to do. So this patch reverts those changes.

Try to reword the patch description without writing "This patch does foo"
(prefer imperative mood over descriptive one).

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--VIr47Z0aK9LAgJcZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY8EU9QAKCRD2uYlJVVFO
o2pEAQC26U9ol2XV4h5cE+CG9W83NqjHtLfHUUfsguzqUgGkTQEAk9e5Q7GLjpk2
E1kp0cXI/VTE7qrrqtdlKr8ZxCcMLA8=
=ZTq0
-----END PGP SIGNATURE-----

--VIr47Z0aK9LAgJcZ--
