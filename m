Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F95597BB3
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 04:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242863AbiHRCxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 22:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234590AbiHRCxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 22:53:34 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F10F2CDE7;
        Wed, 17 Aug 2022 19:53:33 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id f30so362606pfq.4;
        Wed, 17 Aug 2022 19:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=zqEYAgqAH2cK449M53AT+DTcN9ZYkAGI/fTYa7ksTKw=;
        b=PuNlCfM1hvs2flVb2fdsWD8v2Wf9crRmWanfXO2xckk/Z6BxeXOTlPgMKAXwTFWFdH
         faAk6XekAA23AHWVYMaMHqEhpaSu4CwuS0Uk+EzjfRqwDO4UBFtTfrXpFdmUVfvLqPVP
         pE15xYQHUWxO6pRuADq+vRHlN/JukihlKHVQW5ygACZP7Rqo9w7yft0woxm9RitaNfdQ
         nnzy13XTLQC7HP/cejSA4MTegPqd4lUCsrmkpAvrSu0dhyEj1iuaryKm8PURuh4EqhA8
         Ci9zBVJfxpjVrglI9ID7aXm8uu6w9dxRmg2hmpqJU8A3ju5BZPYlP5MaoaaOZhqboduz
         7M6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=zqEYAgqAH2cK449M53AT+DTcN9ZYkAGI/fTYa7ksTKw=;
        b=aVaC71rgikEMaPbpd9i0mtSChSESmQ9k3NUlWsD62faz02PMPHxyHIYisXxSpqRQGP
         AgPN0wUP5s4mZ74f5ZOkE9TLkV65MqLhEIewTd/2+PoBp59ZIHM2wWMgWuqh1NWYfGSX
         93PwzREsBwqoG+hGmKXvQcjYkcsE7h/EsFggU3VSGQFT+EANg11K4sxsND6aDkHvz+Oe
         xAuCtxq4qQtuV5HWpqgpK5T/XXofcCckidyHmdXolTV7Q+Cjvo+7BdzrqlDRR07kyWsB
         +YPBvLGDvH3ax0qvRGJNZqTtF7gF1wibXP3Abo1iJFvoJvKEhIbRlRoyTmW2ZMomyOXa
         JnCw==
X-Gm-Message-State: ACgBeo17taWzgyBJzJ5ReUq47/w4JhDmuc5iPfzaTZPbpHbyG+xEH63M
        5zUOxVQInygDjOFMjsyrA1A=
X-Google-Smtp-Source: AA6agR6ijoaVjM/iEmu8UCY931fjkqErtGSPyajnVEyFbwHxOTRAMmIDYr1Jrfgdhr1g9cP0Pgn8rA==
X-Received: by 2002:a65:6699:0:b0:427:d453:7627 with SMTP id b25-20020a656699000000b00427d4537627mr931947pgw.233.1660791212692;
        Wed, 17 Aug 2022 19:53:32 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-61.three.co.id. [116.206.12.61])
        by smtp.gmail.com with ESMTPSA id q28-20020a63f95c000000b00428c216467csm208990pgk.32.2022.08.17.19.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 19:53:31 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id E3B4E103A2E; Thu, 18 Aug 2022 09:53:26 +0700 (WIB)
Date:   Thu, 18 Aug 2022 09:53:26 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Adel Abouchaev <adel.abushaev@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, dsahern@kernel.org,
        shuah@kernel.org, imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [net-next v2 1/6] Documentation on QUIC kernel Tx crypto.
Message-ID: <Yv2pplw71IXv6L4/@debian.me>
References: <adel.abushaev@gmail.com>
 <20220817200940.1656747-1-adel.abushaev@gmail.com>
 <20220817200940.1656747-2-adel.abushaev@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SI8WxUFW2yusZmkO"
Content-Disposition: inline
In-Reply-To: <20220817200940.1656747-2-adel.abushaev@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SI8WxUFW2yusZmkO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 17, 2022 at 01:09:35PM -0700, Adel Abouchaev wrote:
> Add documentation for kernel QUIC code.
>=20

The documentation LGTM.

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--SI8WxUFW2yusZmkO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYv2poAAKCRD2uYlJVVFO
o+l4AQCb5bXIjXhOkwpTiqa+WH/EB4u6BdTZ+l4/QSwNwMxmwwD+P09Ru0sSBPde
7PgSPNZVB1l2Y45Yrxzde/WwdN8hDgo=
=p/s2
-----END PGP SIGNATURE-----

--SI8WxUFW2yusZmkO--
