Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4465F6E750D
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 10:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbjDSI2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 04:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbjDSI2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 04:28:02 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DA7A5D5;
        Wed, 19 Apr 2023 01:27:55 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1a814fe0ddeso7689785ad.2;
        Wed, 19 Apr 2023 01:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681892875; x=1684484875;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+af7IxXhk7EkstsYqKt7TDHD3jfAa4cpanS/9jm5YmY=;
        b=jPyoNunZmjjkJwPlVRQFeqVkLgyq5MyFwBD+Z5QtnSyVnc3WrP0rWIZmmSKDUIm3U8
         2vxajacL4BH79e7VGKrM5pZJPfl8bU4FLpPh8NU8Y710he7ht0DXxTUXVwb4vHwp4JlA
         7b0ycY5cPVxzZ4h5Ma7cB5uXnnbJlUPx7fOLUH1qhxhDDlse2tAKllHYks9x0hRSWonR
         g2BSp8y/3hbiS0f8XXLGBbuTBhtkUqtwjKvlv9d7fBrvKeafhf+GNQv2wD6OUWb26kWV
         e9RokbkBNQedMWFMNgnH2uMMsi7TAhN5bm3WYj3ZaSU9lIqWV+OBOShy0ksIlClyI1jS
         f/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681892875; x=1684484875;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+af7IxXhk7EkstsYqKt7TDHD3jfAa4cpanS/9jm5YmY=;
        b=Xdkc8tfi9xhkLYniQd5xpbJLhKu06yThyJBN2uJ4T82ve1eWzZrfc5JA0DmMpwi1/E
         uTXPYJ+IjlkX0kLBcTRr4ccJxuyghDTCGcGJdrhFCz9tipptdgirmFWf2npdyOIWSIaT
         z1mnz/hGT66skAId+VRAPDu9Y+SInD7SOpHoqZSPCJfycmbBXOca2AwN4reUWQ2rniOy
         kOMtiIPxQqv6KRfX0NsWrECDZGEQlVjqBEbUn1vVGS+O6OpvpKOXR0rauQaa4ZXlNKsl
         NsC+tZhT8NuhGVJlHn3xY1SnmeQp8gAKlyA9Wq0DjDXJJ29sHr46wGJTNq8hxLy1sC+s
         hLTQ==
X-Gm-Message-State: AAQBX9dVVd6wCKCzWaq7KczPRWoYvByN0rTSzzdZuihl/xBA8s/GvLdm
        5D41E0g07tDxnmsYvT3xgd4=
X-Google-Smtp-Source: AKy350Yk3i3jqOPex9S2Qn3n4aYxmYM89INwjtaMxjiZ9KMmDYYE4fianbZdJBAIXu6acF6xChb2qw==
X-Received: by 2002:a17:902:7d96:b0:1a0:549d:399e with SMTP id a22-20020a1709027d9600b001a0549d399emr4177310plm.21.1681892874720;
        Wed, 19 Apr 2023 01:27:54 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-26.three.co.id. [116.206.28.26])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902be0a00b001a5240aa535sm10859316pls.37.2023.04.19.01.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 01:27:54 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 92D21106894; Wed, 19 Apr 2023 15:27:50 +0700 (WIB)
Date:   Wed, 19 Apr 2023 15:27:50 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Samuel Thibault <samuel.thibault@ens-lyon.org>,
        James Chapman <jchapman@katalix.com>, tparkin@katalix.com,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] PPPoL2TP: Add more code snippets
Message-ID: <ZD+mBrxdX8zugyO+@debian.me>
References: <20230418143307.hth4yjkopy5se4md@begin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8gLAiBipmBI1CmWg"
Content-Disposition: inline
In-Reply-To: <20230418143307.hth4yjkopy5se4md@begin>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--8gLAiBipmBI1CmWg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2023 at 04:33:07PM +0200, Samuel Thibault wrote:
> +  - L2TP session bridging (also called L2TP tunnel switching or L2TP mul=
tihop)
> +is supported by bridging the ppp channels of the two L2TP sessions to be
> +bridged::
> +

The list text isn't aligned, hence Sphinx warning:

Documentation/networking/l2tp.rst:475: WARNING: Block quote ends without a =
blank line; unexpected unindent.

I have applied the fixup:

---- >8 ----
diff --git a/Documentation/networking/l2tp.rst b/Documentation/networking/l=
2tp.rst
index 3664d95268c9cc..e4c67f29e3639d 100644
--- a/Documentation/networking/l2tp.rst
+++ b/Documentation/networking/l2tp.rst
@@ -472,8 +472,8 @@ RTM_NEWLINK, RTM_NEWADDR, RTM_NEWROUTE, or ioctl's SIOC=
SIFMTU, SIOCSIFADDR,
 SIOCSIFDSTADDR, SIOCSIFNETMASK, SIOCSIFFLAGS, or with the `ip` command.
=20
   - L2TP session bridging (also called L2TP tunnel switching or L2TP multi=
hop)
-is supported by bridging the ppp channels of the two L2TP sessions to be
-bridged::
+    is supported by bridging the ppp channels of the two L2TP sessions to =
be
+    bridged::
=20
         int chindx1;
         int chindx2;

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--8gLAiBipmBI1CmWg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZD+mAAAKCRD2uYlJVVFO
o+/cAPwI9Njf7XVS1+t1QvRSPo1LUrzCO1wdCnGi3VLqLP5DBQEA3kc51GoUG62l
CY//tu0IyCbwt4+lIBbvZaJzzpcpuQY=
=WN+v
-----END PGP SIGNATURE-----

--8gLAiBipmBI1CmWg--
