Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35EF064EF94
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 17:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbiLPQn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 11:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbiLPQnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 11:43:13 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009E2747E0
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 08:41:32 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so2897235pjo.3
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 08:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lZFdSkNlmYJ4wtBW/yobNXPao+0jnEO1O7654e/TH+c=;
        b=agj4pvyJg2bL3xaoZ2XNT4/u0cKPc+Uv/bg4Cc3ETRNoGQQ7pB2DjVv9hi5C6hVIB7
         UWU1tuFgfXHmsyuq7RTUqKUFdaMhvUgGhZF3Jz4aI70bc1ybBysmGOQ5IxP5ahy3jgeS
         aVEEMlDeNbsy4g+I6Rtc++zLLP2eeLrZd63EQ4GnVgjzcLO7+Sms9Wpnk9W3bZKIxxZw
         Pit1hU3UNaTk8ry7+BTeWPmY9+q9+Xf/7HYFOI4lxv5igVTYKOOANZzUO6kZmU0rHOCX
         raHgdAfBRFs4N1aeqVcmyp4k6Iadcm9yGK8cX+1W+W0h2jRc9R4DcykZ2iZdaV3Fp9dl
         bXog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lZFdSkNlmYJ4wtBW/yobNXPao+0jnEO1O7654e/TH+c=;
        b=1fslkgSYFxMPUSpB9ce0VcHzU1w/cwH6NDFraIgKngeBq45bH50/8vC/+2TRdxSxrL
         kBruVzrAOHoOLcUchgRt1k92bdLQ6g+V0nMUYRgoC87MTcX2DWGrai5iSuETW3eTZKHx
         wO00TR6St6Q16udbNZeGBtfjZZu+HIZMzQX0HIVOVe/+YGL9hoze3lgC9O7DBGv5QapU
         mHLXrfn+oHVErEVbnfVYcUn7ITXvnlf4hJTzBTIQQc5TnTDsCECppuLGBZN5RfkTl21I
         w09r3ndLtL5JLvy64JgEHLkeoQzQg0l7HI3D8L+9LAChb/YzkN8wXSsg3yK8DYIbO2Ts
         KtrQ==
X-Gm-Message-State: ANoB5pm7xSntsr45fFv8madOFINB2lHylJL2T50YycJiDfowDStMX+/c
        g/jUq9nrXmPBqgERQVwRVT4=
X-Google-Smtp-Source: AA0mqf7HxSUMiaEo/yrN8xxxG5bkvRxgkQJlx0s2sqyQWNo6o3hLCRGnIGKCPFXi9idfvy4jEEBvaA==
X-Received: by 2002:a17:90a:d244:b0:219:705c:7193 with SMTP id o4-20020a17090ad24400b00219705c7193mr33706512pjw.11.1671208891663;
        Fri, 16 Dec 2022 08:41:31 -0800 (PST)
Received: from [192.168.0.128] ([98.97.117.20])
        by smtp.googlemail.com with ESMTPSA id np2-20020a17090b4c4200b001df264610c4sm10619378pjb.0.2022.12.16.08.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 08:41:31 -0800 (PST)
Message-ID: <2eecaca2d1066d51d136a8d95b5cd2fd19e5e111.camel@gmail.com>
Subject: Re: [PATCH net] mctp: serial: Fix starting value for frame check
 sequence
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Jeremy Kerr <jk@codeconstruct.com.au>, netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Harsh Tyagi <harshtya@google.com>
Date:   Fri, 16 Dec 2022 08:41:30 -0800
In-Reply-To: <20221216034409.27174-1-jk@codeconstruct.com.au>
References: <20221216034409.27174-1-jk@codeconstruct.com.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-12-16 at 11:44 +0800, Jeremy Kerr wrote:
> RFC1662 defines the start state for the crc16 FCS to be 0xffff, but
> we're currently starting at zero.
>=20
> This change uses the correct start state. We're only early in the
> adoption for the serial binding, so there aren't yet any other users to
> interface to.
>=20
> Fixes: a0c2ccd9b5ad ("mctp: Add MCTP-over-serial transport binding")
>=20
> Reported-by: Harsh Tyagi <harshtya@google.com>
> Tested-by: Harsh Tyagi <harshtya@google.com>
> Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
> ---
>  drivers/net/mctp/mctp-serial.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/mctp/mctp-serial.c b/drivers/net/mctp/mctp-seria=
l.c
> index 7cd103fd34ef..9f9eaf896047 100644
> --- a/drivers/net/mctp/mctp-serial.c
> +++ b/drivers/net/mctp/mctp-serial.c
> @@ -35,6 +35,8 @@
>  #define BYTE_FRAME		0x7e
>  #define BYTE_ESC		0x7d
> =20
> +#define FCS_INIT		0xffff
> +
>  static DEFINE_IDA(mctp_serial_ida);
> =20
>  enum mctp_serial_state {
> @@ -123,7 +125,7 @@ static void mctp_serial_tx_work(struct work_struct *w=
ork)
>  		buf[2] =3D dev->txlen;
> =20
>  		if (!dev->txpos)
> -			dev->txfcs =3D crc_ccitt(0, buf + 1, 2);
> +			dev->txfcs =3D crc_ccitt(FCS_INIT, buf + 1, 2);
> =20
>  		txlen =3D write_chunk(dev, buf + dev->txpos, 3 - dev->txpos);
>  		if (txlen <=3D 0) {
> @@ -303,7 +305,7 @@ static void mctp_serial_push_header(struct mctp_seria=
l *dev, unsigned char c)
>  	case 1:
>  		if (c =3D=3D MCTP_SERIAL_VERSION) {
>  			dev->rxpos++;
> -			dev->rxfcs =3D crc_ccitt_byte(0, c);
> +			dev->rxfcs =3D crc_ccitt_byte(FCS_INIT, c);
>  		} else {
>  			dev->rxstate =3D STATE_ERR;
>  		}

Since the starting value isn't unique would it possibly be worthwhile
to look at adding a define to include/linux/crc-ccitt.h to be used to
handle the cases where the initial value is 0xffff? I notice there
seems to only be two starting values 0 and 0xffff for all callers so it
might make sense to centralize it in one place.

Otherwise the code itself looks good.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
