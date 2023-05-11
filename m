Return-Path: <netdev+bounces-1653-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCACC6FEA02
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 05:06:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABB1928165C
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 03:06:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D996C17736;
	Thu, 11 May 2023 03:06:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DD37FC
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:06:11 +0000 (UTC)
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72621FCE;
	Wed, 10 May 2023 20:06:06 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1ab267e3528so57296275ad.0;
        Wed, 10 May 2023 20:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683774366; x=1686366366;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mb/zuNQK49JSoqZKwSKfTZmkk+ujcZ98MeItuBZs6L8=;
        b=bwyZE92K1QVP/JmxyndrCoWQOcxAuaGX1jlplGForAeh8CGTIOlxImtFr6pchUiXUh
         trKy+l2nAhxGL76XsXOBiL0rcW3v3g05Uom9Vg9abDSAozJ8Fip0pK8d383EKf87mlT+
         hQe06HIeEbg8XVEG4tF/uwGI6roIDpkRFYPTutkdqPG1kJnjq2j9IdhR2R6WmZHl+pOy
         QBFrdfNRG9tNPi49BS1QWu/wWTeK3AXxS92bQtNygqQq4mEzOpk8rqD5IbWaQWSZcTug
         8kDgp+KYXHW7NIDlTUJr3JIHmRulOX10b5gqQ5adfuaLkBOa7n4fasWbxBziNcRPAyOC
         GQkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683774366; x=1686366366;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mb/zuNQK49JSoqZKwSKfTZmkk+ujcZ98MeItuBZs6L8=;
        b=PzEweIZkezCwSBwDdRBdBZVUUUTLc1I9jeOvquYBmAV1G1NTpSeeY1ccEDBh5hexNZ
         oNuaSSBhNfSYhfpF/2pdNp2T5Cph2E2pV14qBzepO8btTtCAYVdCp1ajk4uEnEGUvw1G
         uX6CXhbG3UjniYR1TBT+FTl7hEuEPSP3amZMPg2y2e8cc5pVdGrb5AyE/c+z+sAPbLDN
         KYmNXwxvv6j7v5/5GfGMeVbQZfHmKM+Os0C+MQKn+7GxKbVi/hIvO44avJaseeBsgZMM
         d0+k2su8lGsuAPdkC8YEN7xcwkDPWVEPJFSr1lVnWOxC2AnhitrCnyLXFXnHGY2ysbYu
         D9VA==
X-Gm-Message-State: AC+VfDzjW45XjgdQ5HyvAJysfRzU5MTFcniQ5wj+siIKIz1YiJpfVR4J
	RuVCKEaXiNR9dvkqdvz/7tJDDVoCB9yvJw==
X-Google-Smtp-Source: ACHHUZ6DxRWILStkbEGhuxycP2yMCvHSPfP5Hy3bFVSdBAogx9o/CbCGEwkYMepCkSomZpZmCcHb/Q==
X-Received: by 2002:a17:902:ec87:b0:1a9:9ace:3e74 with SMTP id x7-20020a170902ec8700b001a99ace3e74mr24758509plg.65.1683774366252;
        Wed, 10 May 2023 20:06:06 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-26.three.co.id. [180.214.232.26])
        by smtp.gmail.com with ESMTPSA id f2-20020a170902ce8200b0019ef86c2574sm4544891plg.270.2023.05.10.20.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 20:06:05 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id AC961106778; Thu, 11 May 2023 10:06:02 +0700 (WIB)
Date: Thu, 11 May 2023 10:06:02 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Christian Marangi <ansuelsmth@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-leds@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 04/11] Documentation: leds: leds-class: Document new
 Hardware driven LEDs APIs
Message-ID: <ZFxbmnMeQO/rNUFu@debian.me>
References: <20230427001541.18704-1-ansuelsmth@gmail.com>
 <20230427001541.18704-5-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AWn32Q89nm9OZbgz"
Content-Disposition: inline
In-Reply-To: <20230427001541.18704-5-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--AWn32Q89nm9OZbgz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 27, 2023 at 02:15:34AM +0200, Christian Marangi wrote:
> +     - hw_control_set:
> +                activate hw control, LED driver will use the provided
                   "activate hw control. LED driver will use ..."
> +                flags passed from the supported trigger, parse them to
> +                a set of mode and setup the LED to be driven by hardware
> +                following the requested modes.
> +
> +                Set LED_OFF via the brightness_set to deactivate hw cont=
rol.
> +
> +    - hw_control_get:
> +                get from a LED already in hw control, the active modes,
                   "get active modes from a LED already in hw control ..."
> +                parse them and set in flags the current active flags for
> +                the supported trigger.
> +
Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--AWn32Q89nm9OZbgz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZFxbkgAKCRD2uYlJVVFO
o3uUAQCycfI5RmXv7icFa57Dzw2XngBZ3pd8MbyU02vwfYCdgAEAp89CPou30fxe
wUlacpgcoBCjcNFpSXZ67WzwxGq41wY=
=RzHE
-----END PGP SIGNATURE-----

--AWn32Q89nm9OZbgz--

