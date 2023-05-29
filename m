Return-Path: <netdev+bounces-6024-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47F8E714624
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 10:10:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0278D280E22
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7228A4437;
	Mon, 29 May 2023 08:10:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC0A2107
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:10:21 +0000 (UTC)
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A3990;
	Mon, 29 May 2023 01:10:20 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-51b33c72686so1814967a12.1;
        Mon, 29 May 2023 01:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685347820; x=1687939820;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2pERwO8sjUT5j9p5YYisC0BMTaQ2RTVQ8D853PyT37g=;
        b=bYECe3KqMW1lM6zOmAGWXvj0cOaDsPCsxctfRPcEo4p/JeB95x949LB5kAUF1bR+H/
         F56e6cfR+8nAzQaxD8Twc7gGspTwP0y0AZX6cIR/rvFNuugjUp1EQWd3KdUAauaIJ5nJ
         uApAW2760gU2jh/N3xKDyqJS83kggvoux72ctG5wIuNDBUa4C22VO/ba7OWEnbgh3aWF
         BFcPF3sZvuEwxWGFLeGXmd+AJ0Di8GwgnqZkqCa8lRUU3uQrG0O4bpmMp/jqi++OkvYa
         5yv1s10D2LKkEOC/nLPi9KPLQ+rfPzCsqu+fe+Dpnl4I+YIrmGpJ6SndSGNp1Gsg/XT9
         3pOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685347820; x=1687939820;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2pERwO8sjUT5j9p5YYisC0BMTaQ2RTVQ8D853PyT37g=;
        b=kkWvdEfgw+1hhvQznTF2e3Ry+1YgBH30G024kHAjGoHEwIg2oGrD8zkMhaDU1YVuhO
         SI602BiyrIo7uAMNA3asoBD4Vt0lwE2xnOII6ziN7xjhat5yNGqAbw3bNa0/kAh3KlH0
         MwBmJCvV2s29p6g9juzi/clcwK35DGNLotu4zHaVObPQsi4sf3IknRkLlKZWc/+mDkIP
         uVscKH/wmptwLr7E9Fa6jIXfgLOLLrJbXSXwHcP+i//ReUze2BerqJaAkz36V5DjXq0E
         zYm44O7XaF4UvcoFRTPifJ4ekJ3l9bkEvbK4VoQyyOprfcVnKudpa7oDyVsArtYHARVy
         4gsw==
X-Gm-Message-State: AC+VfDzv0hSqoP0nDZtaMrMntoKfkCrp9YLTsg4KOQNb3GYJpGWKmiL3
	nclwGTt0QgZpHQ+d9AbSABqWr22FQ7I=
X-Google-Smtp-Source: ACHHUZ4Q/yuoKlTT7swOYhDurvkAjdXaHTvytax7D+G2AvVL61nR5ycrFcPrtopCWin+AhqNc1DEzg==
X-Received: by 2002:a17:902:d50c:b0:1b0:4b65:79e4 with SMTP id b12-20020a170902d50c00b001b04b6579e4mr543002plg.20.1685347819642;
        Mon, 29 May 2023 01:10:19 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-78.three.co.id. [180.214.232.78])
        by smtp.gmail.com with ESMTPSA id n19-20020a170902969300b001a527761c31sm7594709plp.79.2023.05.29.01.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 01:10:19 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 4294B106A11; Mon, 29 May 2023 15:10:16 +0700 (WIB)
Date: Mon, 29 May 2023 15:10:15 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Christian Marangi <ansuelsmth@gmail.com>, Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-leds@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v3 03/13] Documentation: leds: leds-class:
 Document new Hardware driven LEDs APIs
Message-ID: <ZHRd5wDnMrWZlwrd@debian.me>
References: <20230527112854.2366-1-ansuelsmth@gmail.com>
 <20230527112854.2366-4-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YTDyO4TcEE14SJFj"
Content-Disposition: inline
In-Reply-To: <20230527112854.2366-4-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--YTDyO4TcEE14SJFj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 27, 2023 at 01:28:44PM +0200, Christian Marangi wrote:
> +     - hw_control_set:
> +                activate hw control. LED driver will use the provided
> +                flags passed from the supported trigger, parse them to
> +                a set of mode and setup the LED to be driven by hardware
> +                following the requested modes.
> +
> +                Set LED_OFF via the brightness_set to deactivate hw cont=
rol.
> +
> +                Return 0 on success, a negative error number on flags ap=
ply
> +                fail.
		   "... on failing to apply flags."

> +    - hw_control_get_device:
> +                return the device associated with the LED driver in
> +                hw control. A trigger might use this to match the
> +                returned device from this function with a configured
> +                device for the trigger as the source for blinking
> +                events and correctly enable hw control.
> +                (example a netdev trigger configured to blink for a
> +                particular dev match the returned dev from get_device
> +                to set hw control)
> +
> +                Return a device or NULL if nothing is currently attached.
Returns a device name?

> +
> +LED driver can activate additional modes by default to workaround the
> +impossibility of supporting each different mode on the supported trigger.
> +Example are hardcoding the blink speed to a set interval, enable special
"Examples are hardcoding ..."

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--YTDyO4TcEE14SJFj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZHRd5AAKCRD2uYlJVVFO
o6OqAPwIkuwDefE/k8PaF3t507mCbalgR2aQkpYignl1vtGOOgD+Ip2BAGGTRs6Q
B8rCmdw4Nz7QxLypkR+gaHS0rlwbIQ0=
=wtzq
-----END PGP SIGNATURE-----

--YTDyO4TcEE14SJFj--

