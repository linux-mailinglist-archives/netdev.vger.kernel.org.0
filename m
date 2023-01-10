Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE3D663C6F
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 10:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238005AbjAJJLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 04:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237260AbjAJJLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:11:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A51E18
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673341851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=40jOkiS8yWB3LmYc+uhi0y8YWD9kV35XIczTXFbDkFM=;
        b=S9PTUPYGAHOENqZlpInntkqAV36uDcCLw985+JJMA39DsldZxe+kQgHUbYwotozr/RFAme
        9qWXnq9ME834/5pqZx1csuNG9ziDmGVgA7g0qKUMwVw3XJjYM21uCNjwivfeOeprbZ6Puc
        z4n036Tga5pUhQSiYQPm97R+Rqi8Z8c=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-519-TsFwF696MWyaeOeSP9K62w-1; Tue, 10 Jan 2023 04:10:50 -0500
X-MC-Unique: TsFwF696MWyaeOeSP9K62w-1
Received: by mail-wm1-f72.google.com with SMTP id m8-20020a05600c3b0800b003d96bdce12fso6023182wms.9
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:10:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=40jOkiS8yWB3LmYc+uhi0y8YWD9kV35XIczTXFbDkFM=;
        b=rXYD/VA7J5artUGzJtXbz9vgm1Er+k/mEG1XJd3Kt1yg8WMPp24+ZCiwoci/sek1LD
         O6KJF3Ms6HJUUDmnZhOJsfQy7FHdkNKCwlYn1mWFOtz+dHnactu1BsPb2LzxTmB//3cj
         E0Q2fcSxjbHv+8XK9BSMYST0VhoEwtWjTofMLx8xL3comHI/QnygjuRkco5PSnqXrm4M
         2c3lam8ZycWt4uR+HdCw1xlw/+EOSEzHvUnZYCcvDsYTPF8HmGBF06Bs71tFf+9eqFB9
         d1lv2IhDFGo7TgtKt3ItNvSDfA1V0MyE7wGeCZCuunTSSKBuBXxQoDTD8defDCWuOOTL
         wsUQ==
X-Gm-Message-State: AFqh2komg5R0dj8aW71+qxXUWUEMgWoqjQbbn1iisVXYhSyE9f9c6C4y
        HaHfRmNDSLMAEIOmZLUCR+v8egBgelvO+CLtLanYsHWcvIx5+zVeHFmCE9dcLN3SuEKDe3nr1N8
        EgRyJEOdeW1ox+3GO
X-Received: by 2002:a5d:4e0a:0:b0:27b:d6c0:78a6 with SMTP id p10-20020a5d4e0a000000b0027bd6c078a6mr32675910wrt.7.1673341849266;
        Tue, 10 Jan 2023 01:10:49 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvVaOCvhNPbHIRqx0Yew0/l74BJlBW0uh4G8Jx7gacG7NemEIR/E5YFx0KFK+NZ6XyAJIefZA==
X-Received: by 2002:a5d:4e0a:0:b0:27b:d6c0:78a6 with SMTP id p10-20020a5d4e0a000000b0027bd6c078a6mr32675902wrt.7.1673341849061;
        Tue, 10 Jan 2023 01:10:49 -0800 (PST)
Received: from localhost (net-188-216-77-84.cust.vodafonedsl.it. [188.216.77.84])
        by smtp.gmail.com with ESMTPSA id z6-20020a5d6546000000b002bc371a08adsm4407976wrv.101.2023.01.10.01.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 01:10:47 -0800 (PST)
Date:   Tue, 10 Jan 2023 10:10:45 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org
Subject: Re: [PATCH net-next] net: ethernet: mtk_wed: get rid of queue lock
 for rx queue
Message-ID: <Y70rlWO+30+y8aOJ@lore-desk>
References: <bff65ff7f9a269b8a066cae0095b798ad5b37065.1673102426.git.lorenzo@kernel.org>
 <be4814483f1b320eaaa49ba8d59d81b2a51f932b.camel@gmail.com>
 <20230109193721.7d05d24b@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Sd7F1jZC948RTp0H"
Content-Disposition: inline
In-Reply-To: <20230109193721.7d05d24b@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Sd7F1jZC948RTp0H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 09 Jan 2023 16:50:55 -0800 Alexander H Duyck wrote:
> > On Sat, 2023-01-07 at 15:41 +0100, Lorenzo Bianconi wrote:
> > > mtk_wed_wo_queue_rx_clean and mtk_wed_wo_queue_refill routines can't =
run
> > > concurrently so get rid of spinlock for rx queues.
>=20
> You say "for rx queues" but mtk_wed_wo_queue_refill() is also called
> for tx queues.

ack, but for tx queues is run just during initialization.

>=20
> > My understanding is that mtk_wed_wo_queue_refill will only be called
> > during init and by the tasklet. The mtk_wed_wo_queue_rx_clean function
> > is only called during deinit and only after the tasklet has been
> > disabled. That is the reason they cannot run at the same time correct?
> >=20
> > It would be nice if you explained why they couldn't run concurrently
> > rather than just stating it is so in the patch description. It makes it
> > easier to verify assumptions that way. Otherwise the patch itself looks
> > good to me.
>=20
> Agreed, please respin with a better commit message.
>=20

ack, I will post v2 with a better commit message.

Regards,
Lorenzo

--Sd7F1jZC948RTp0H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY70rlQAKCRA6cBh0uS2t
rOUEAP423DEnvEDEiIdhBB9om7h1BPvfvi+Btpt7TdAcRVsMogD/Sa2+JyzdqKQI
R1coJPhZut/Yfu72pOqaoEEW6oz2FwY=
=EB6f
-----END PGP SIGNATURE-----

--Sd7F1jZC948RTp0H--

