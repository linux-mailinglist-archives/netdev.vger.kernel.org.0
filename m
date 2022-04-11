Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6996A4FC68A
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 23:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbiDKVOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 17:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiDKVOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 17:14:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77C6D15822
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 14:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649711540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W1IfkRErZdIDPAHBVvFJA6wr4RD9bRlXtOYrlQMcUqY=;
        b=MAr5xP6sP39djvjXJoV2gQj8nMsArLVcBhPJn37IPckdRvZISqDIiUas1XvmKjpkFrDfqN
        dloSG9STxCAf0hIh2lidPzN0YDvu8rsi7waihHOgpMlRWhALT14+VGroAF6ZETjPSAB62f
        qVmOmnTJcLODysN9z+5EQlX19rHe3+E=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-ZQZrvORLPxGXiBXsbKSRGQ-1; Mon, 11 Apr 2022 17:12:19 -0400
X-MC-Unique: ZQZrvORLPxGXiBXsbKSRGQ-1
Received: by mail-wm1-f70.google.com with SMTP id z16-20020a05600c0a1000b0038bebbd8548so212304wmp.3
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 14:12:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W1IfkRErZdIDPAHBVvFJA6wr4RD9bRlXtOYrlQMcUqY=;
        b=f6ed69C4V2wabaAFmACl6MAzzxgf6x9p1+JeyjxG1quCvBOEbuCtWKrZgIwmdfBaTf
         fzYJpssSBiOJzWxWbmSjF6n6z0A8lckXodpfz3ioXCVu4EQT955es7fopPptd4lcB1Ag
         Q8Ab8G3WFIsUmZTaZ77CERq3rrPJ1GRJmh0O18ClWTx2FKaQnH7icv+DY8737EHDBAdZ
         Czh4c9QX6fkVzHFa2gEL4l3pZf/hDayodhmaXgHP2Cpi3GUfriFsirSXVHO0A5kBTybK
         nIuazsqrdhKKYR+vX/yQ5z2ZwhoSFAbjQNmDgKKB5GcoadbQQDXT/XgpQc5vxvS8xFo0
         pCvw==
X-Gm-Message-State: AOAM533+YtM+q88s9AGwjJYfjU5G7cNHC8P3cwuJG0+WmNRFJtlx3ON0
        0PzARobjUKXaB47OxeOQC1Prt24YOPnLAG0lcE+PatO+/ByDtp1v3tg84hE7E2FXchNgSA8Ak9+
        AUg8AHVFOcWkyneVE
X-Received: by 2002:a5d:6ac9:0:b0:207:ac33:802a with SMTP id u9-20020a5d6ac9000000b00207ac33802amr1754081wrw.349.1649711537759;
        Mon, 11 Apr 2022 14:12:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6R9qBEDStI8HRT9KdmvW4W6jG/mkmgAfBOdgCXUdxROLWpPA98CDNNo9GUcF4WuPcMBr05w==
X-Received: by 2002:a5d:6ac9:0:b0:207:ac33:802a with SMTP id u9-20020a5d6ac9000000b00207ac33802amr1754070wrw.349.1649711537515;
        Mon, 11 Apr 2022 14:12:17 -0700 (PDT)
Received: from localhost (net-93-71-56-156.cust.vodafonedsl.it. [93.71.56.156])
        by smtp.gmail.com with ESMTPSA id a1-20020a056000188100b002041a652dfdsm27802732wri.25.2022.04.11.14.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 14:12:17 -0700 (PDT)
Date:   Mon, 11 Apr 2022 23:12:15 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, ilias.apalodimas@linaro.org,
        jbrouer@redhat.com, andrew@lunn.ch, jdamato@fastly.com
Subject: Re: [PATCH v4 net-next 0/2] net: mvneta: add support for
 page_pool_get_stats
Message-ID: <YlSZr7BUfvraXwIh@lore-desk>
References: <cover.1649689580.git.lorenzo@kernel.org>
 <20220411133552.04344b93@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="c1oNovHQurdwcANz"
Content-Disposition: inline
In-Reply-To: <20220411133552.04344b93@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--c1oNovHQurdwcANz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 11 Apr 2022 17:11:40 +0200 Lorenzo Bianconi wrote:
> > Introduce page_pool stats ethtool APIs in order to avoid driver duplica=
ted
> > code.
>=20
> Does not apply at the time of posting.

Yep, sorry. This series depends on the following patch I posted:

"v2: page_pool: Add recycle stats to page_pool_put_page_bulk"
https://lore.kernel.org/netdev/CAC_iWjJZYBR2OAUJuqrUU+UxX3G17OLZ6sgchOhfaWg=
B=3DreGTw@mail.gmail.com/T/#t

I will repost when it is merged.

Regards,
Lorenzo
>=20
> If series depends on other patches people post it as RFC until
> dependencies are merged.
>=20

--c1oNovHQurdwcANz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYlSZrgAKCRA6cBh0uS2t
rFf3AP4h1GYyrgtuWYmfnHfYfhXbtW/wMqvaXJi2nFf7M8/vCwEA3PFmGl5RBVLq
6IkHFJEGrr3rlVHvUHNRdJpGDw1aKQA=
=of42
-----END PGP SIGNATURE-----

--c1oNovHQurdwcANz--

