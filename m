Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818DF687FBD
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 15:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbjBBORs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 09:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjBBORr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 09:17:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBBD48636
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 06:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675347417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ipX9+91F98Xf+Nd1sRqYrlY0JTKt5n7Tl83wFb0FjyA=;
        b=AdC+WP6YKwhoz2FfyAAxHngysIbcworyqQQ1HOB1ZUweyekGfaEqInff0NHxPJ7eHN+mFy
        ylQZluyd9XzDKMyjfa3b/l7iq2cSq3dVB0TiLJpLKgL1nYE5dL2KnkdwqUVUz5UTtW6rXp
        i/v3ojG7vezWOIwK3YiiQAKqegJREAU=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-611-9o31GED_NRORGeT6yNlVvQ-1; Thu, 02 Feb 2023 09:16:55 -0500
X-MC-Unique: 9o31GED_NRORGeT6yNlVvQ-1
Received: by mail-qt1-f198.google.com with SMTP id bs11-20020ac86f0b000000b003b9b4ec27c4so985044qtb.19
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 06:16:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ipX9+91F98Xf+Nd1sRqYrlY0JTKt5n7Tl83wFb0FjyA=;
        b=bUDevGHVDRox4+jZrWaQ1o5L46zJBdXnwcnSXZsOJksE4LIS3SPIj81S2a1eF860nn
         jdevpw2um2V2vcSXHijCl2GIkHyWnona2m//S1NBYQ5pEqKAIhMO9n9AaENasWppAyib
         UZ0O5eoj4wxX0b3KxerGG4ost2j3BYvmgk07ziBKxJpUP/sSywbyrj2Z0BY20+ZeyBAx
         jchgHiO2MZG5hVY3sYgAG8oMDoemwEOFRl/HKIuIM/zvfRRChcaAdGoqEizBDt5go3pS
         bONvKvoYt3hjVOTI2YpAWBvX0qG37VxuSHO/bD+YgjO8P6Br9aBZUqMJ/5w5+ZAHExG1
         Y+4A==
X-Gm-Message-State: AO0yUKV8XsA+6NeN3EucWfE/FJWSYWzPYzgznnNPiP53USn6DcVZJK82
        1PKwOTYTZGOperpJWmECvpbPHNx1aGSUoUoWOio0uCw+4ZWIbLaO/6novKwF2q8k4JCJyn0SNYg
        D1Fxp4EKweTJZ+CDl
X-Received: by 2002:ac8:590b:0:b0:3b8:6801:90b3 with SMTP id 11-20020ac8590b000000b003b8680190b3mr12514729qty.0.1675347414749;
        Thu, 02 Feb 2023 06:16:54 -0800 (PST)
X-Google-Smtp-Source: AK7set/qAFisEAUIHFOaQ59f7FWfCZnC5CO+h3abmCSWgqneOHS1rxmiRTADjrV7hdHpVNTZfn4yKQ==
X-Received: by 2002:ac8:590b:0:b0:3b8:6801:90b3 with SMTP id 11-20020ac8590b000000b003b8680190b3mr12514697qty.0.1675347414403;
        Thu, 02 Feb 2023 06:16:54 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id ea17-20020a05620a489100b007204305dee4sm7821687qkb.19.2023.02.02.06.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 06:16:53 -0800 (PST)
Message-ID: <52212a21490af8e45588bd0e17ffc54655d44b87.camel@redhat.com>
Subject: Re: [PATCH net-next v2 2/2] amd-xgbe: add support for rx-adaptation
From:   Paolo Abeni <pabeni@redhat.com>
To:     Simon Horman <simon.horman@corigine.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, Shyam-sundar.S-k@amd.com
Date:   Thu, 02 Feb 2023 15:16:50 +0100
In-Reply-To: <Y9qdRsS5txwu3MND@corigine.com>
References: <20230201054932.212700-1-Raju.Rangoju@amd.com>
         <20230201054932.212700-3-Raju.Rangoju@amd.com>
         <Y9qdRsS5txwu3MND@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-02-01 at 18:11 +0100, Simon Horman wrote:
> On Wed, Feb 01, 2023 at 11:19:32AM +0530, Raju Rangoju wrote:
> > The existing implementation for non-Autonegotiation 10G speed modes doe=
s
> > not enable RX adaptation in the Driver and FW. The RX Equalization
> > settings (AFE settings alone) are manually configured and the existing
> > link-up sequence in the driver does not perform rx adaptation process a=
s
> > mentioned in the Synopsys databook. There's a customer request for 10G
> > backplane mode without Auto-negotiation and for the DAC cables of more
> > significant length that follow the non-Autonegotiation mode. These mode=
s
> > require PHY to perform RX Adaptation.
> >=20
> > The proposed logic adds the necessary changes to Yellow Carp devices to
> > ensure seamless RX Adaptation for 10G-SFI (LONG DAC) and 10G-KR without
> > AN (CL72 not present). The RX adaptation core algorithm is executed by
> > firmware, however, to achieve that a new mailbox sub-command is require=
d
> > to be sent by the driver.
> >=20
> > Co-developed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> > Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> > Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
>=20
> ...
>=20
> > diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/etherne=
t/amd/xgbe/xgbe.h
> > index 16e73df3e9b9..ad136ed493ed 100644
> > --- a/drivers/net/ethernet/amd/xgbe/xgbe.h
> > +++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
> > @@ -625,6 +625,7 @@ enum xgbe_mb_cmd {
> > =20
> >  enum xgbe_mb_subcmd {
> >  	XGBE_MB_SUBCMD_NONE =3D 0,
> > +	XGBE_MB_SUBCMD_RX_ADAP,
> > =20
> >  	/* 10GbE SFP subcommands */
> >  	XGBE_MB_SUBCMD_ACTIVE =3D 0,
> > @@ -1316,6 +1317,10 @@ struct xgbe_prv_data {
> > =20
> >  	bool debugfs_an_cdr_workaround;
> >  	bool debugfs_an_cdr_track_early;
> > +	bool en_rx_adap;
>=20
> nit: there is a 1 byte hole here (on x86_64)

I think even in the current form is ok. The total size of the struct is
not going to change, due to alignment, and the fields will sit in the
same cacheline in both cases.

I guess the layout could be changed later if needed.

Thanks,

Paolo

