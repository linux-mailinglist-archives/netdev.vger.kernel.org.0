Return-Path: <netdev+bounces-3824-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F849708FFD
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 08:47:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF9C7281B65
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 06:47:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B873139F;
	Fri, 19 May 2023 06:47:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5719361
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 06:47:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF7AE43
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 23:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684478867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+YqEjo5KOHNsWEJneP5DrW/OFHP4h5hgOMVeUZ2R9GE=;
	b=HEy+vV8MWDe/bT/Yb4X+Zld0y0mwoLaCP6zNR/lsGExmNVr8cR0E69zrsSc9XzZltCEhGP
	yClsnsrtCiKw0ApeX/fk1t4zdYgU+QS2vNyFG1XnO8MrM5eSK0miuHpoU7TSx6qkjLlpR9
	QOdpLa80esFQJV6oZrLvXQ92uGPU4+k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-rzBu6Q_cNYWIrJD7Yx9LZw-1; Fri, 19 May 2023 02:47:46 -0400
X-MC-Unique: rzBu6Q_cNYWIrJD7Yx9LZw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f4b96aa44aso4491485e9.1
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 23:47:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684478865; x=1687070865;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+YqEjo5KOHNsWEJneP5DrW/OFHP4h5hgOMVeUZ2R9GE=;
        b=lqzB37fvdwXiEzFlVWN02IBN+0Ge1xUCMr1Yxn1tE9kkYCk9VNnGClHcfbfnjkhBBk
         SVTqjF7z7ywqgHHfxad1vCO6IjKrjY5Am6SiYneky5jVtvN14Yb13TQXML1VpSaHfNeB
         4/6mskQYmrvh3uT2set/BN3LgcN4lWAxrTCawG5gC4RqlzlmZEhctD2vscd1YKz4aSAI
         pjn2w8NEzKYtV+ejfke0/tTjxRpEowZqIo6o5Od2XaYPPNgBG+7csG5+CFSzL78MGn/1
         QIumG1MSU9um2JoM9eIfoggzgcl/9PthqvuFQWqy7wq70Kljn4TzoKxZYVa6Ob0s7ACj
         ljLg==
X-Gm-Message-State: AC+VfDwgP6xlXn1Lg5pcDqfuHgROjYcPiZ6W9CgxYflLoFHePNdWdt3k
	BdjKFlcLQx+4KWPBFNL8LUkMb8V8ZHefPHSvOPaxb3pp5ZxXjxsTFHkBF0FTg5+b3h6Jh1qzy3v
	agVTax4S/pj351+VU
X-Received: by 2002:a1c:ed12:0:b0:3f4:3:4979 with SMTP id l18-20020a1ced12000000b003f400034979mr777003wmh.2.1684478865147;
        Thu, 18 May 2023 23:47:45 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ57jPanmHQryRzvof8gy+OohfP4mEVfiEjUmcetjwWGfGaI5Hmek0Xj/oMwtuednFE5s62jfA==
X-Received: by 2002:a1c:ed12:0:b0:3f4:3:4979 with SMTP id l18-20020a1ced12000000b003f400034979mr776990wmh.2.1684478864808;
        Thu, 18 May 2023 23:47:44 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-235-104.dyn.eolo.it. [146.241.235.104])
        by smtp.gmail.com with ESMTPSA id c18-20020a7bc852000000b003f42cc3262asm1345094wml.34.2023.05.18.23.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 23:47:44 -0700 (PDT)
Message-ID: <d049ebf92a973c0f293e29722959366086ad3c37.camel@redhat.com>
Subject: Re: [RFC PATCH v7 5/8] ice: implement dpll interface to control cgu
From: Paolo Abeni <pabeni@redhat.com>
To: Jiri Pirko <jiri@resnulli.us>, "Kubalewski, Arkadiusz"
	 <arkadiusz.kubalewski@intel.com>
Cc: Vadim Fedorenko <vadfed@meta.com>, Jakub Kicinski <kuba@kernel.org>, 
 Jonathan Lemon <jonathan.lemon@gmail.com>, "Olech, Milena"
 <milena.olech@intel.com>, "Michalik, Michal" <michal.michalik@intel.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
 <mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
 "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Date: Fri, 19 May 2023 08:47:42 +0200
In-Reply-To: <ZGMiE1ByArIr8ARB@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
	 <20230428002009.2948020-6-vadfed@meta.com> <ZFJRIY1HM64gFo3a@nanopsycho>
	 <DM6PR11MB4657EAF163220617A94154A39B789@DM6PR11MB4657.namprd11.prod.outlook.com>
	 <ZGMiE1ByArIr8ARB@nanopsycho>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 2023-05-16 at 08:26 +0200, Jiri Pirko wrote:
> Tue, May 16, 2023 at 12:07:57AM CEST, arkadiusz.kubalewski@intel.com wrot=
e:
> > > From: Jiri Pirko <jiri@resnulli.us>
> > > Sent: Wednesday, May 3, 2023 2:19 PM
> > >=20
> > > Fri, Apr 28, 2023 at 02:20:06AM CEST, vadfed@meta.com wrote:
> > > > From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>=20
> [...]
>=20
>=20
> > > > + * ice_dpll_frequency_set - wrapper for pin callback for set frequ=
ency
> > > > + * @pin: pointer to a pin
> > > > + * @pin_priv: private data pointer passed on pin registration
> > > > + * @dpll: pointer to dpll
> > > > + * @frequency: frequency to be set
> > > > + * @extack: error reporting
> > > > + * @pin_type: type of pin being configured
> > > > + *
> > > > + * Wraps internal set frequency command on a pin.
> > > > + *
> > > > + * Return:
> > > > + * * 0 - success
> > > > + * * negative - error pin not found or couldn't set in hw  */ stat=
ic
> > > > +int ice_dpll_frequency_set(const struct dpll_pin *pin, void *pin_p=
riv,
> > > > +		       const struct dpll_device *dpll,
> > > > +		       const u32 frequency,
> > > > +		       struct netlink_ext_ack *extack,
> > > > +		       const enum ice_dpll_pin_type pin_type) {
> > > > +	struct ice_pf *pf =3D pin_priv;
> > > > +	struct ice_dpll_pin *p;
> > > > +	int ret =3D -EINVAL;
> > > > +
> > > > +	if (!pf)
> > > > +		return ret;
> > > > +	if (ice_dpll_cb_lock(pf))
> > > > +		return -EBUSY;
> > > > +	p =3D ice_find_pin(pf, pin, pin_type);
> > >=20
> > > This does not make any sense to me. You should avoid the lookups and =
remove
> > > ice_find_pin() function entirely. The purpose of having pin_priv is t=
o
> > > carry the struct ice_dpll_pin * directly. You should pass it down dur=
ing
> > > pin register.
> > >=20
> > > pf pointer is stored in dpll_priv.
> > >=20
> >=20
> > In this case dpll_priv is not passed, so cannot use it.
>=20
> It should be passed. In general to every op where *dpll is passed, the
> dpll_priv pointer should be passed along. Please, fix this.
>=20
>=20
> > But in general it makes sense I will hold pf inside of ice_dpll_pin
> > and fix this.
>=20
> Nope, just use dpll_priv. That's why we have it.
>=20
>=20
> [...]
>=20
>=20
> > > > +/**
> > > > + * ice_dpll_pin_state_set - set pin's state on dpll
> > > > + * @dpll: dpll being configured
> > > > + * @pin: pointer to a pin
> > > > + * @pin_priv: private data pointer passed on pin registration
> > > > + * @state: state of pin to be set
> > > > + * @extack: error reporting
> > > > + * @pin_type: type of a pin
> > > > + *
> > > > + * Set pin state on a pin.
> > > > + *
> > > > + * Return:
> > > > + * * 0 - OK or no change required
> > > > + * * negative - error
> > > > + */
> > > > +static int
> > > > +ice_dpll_pin_state_set(const struct dpll_device *dpll,
> > > > +		       const struct dpll_pin *pin, void *pin_priv,
> > > > +		       const enum dpll_pin_state state,
> > >=20
> > > Why you use const with enums?
> > >=20
> >=20
> > Just show usage intention explicitly.
>=20
> Does not make any sense what so ever. Please avoid it.
>=20
>=20
> > > > +static int ice_dpll_rclk_state_on_pin_get(const struct dpll_pin *p=
in,
> > > > +					  void *pin_priv,
> > > > +					  const struct dpll_pin *parent_pin,
> > > > +					  enum dpll_pin_state *state,
> > > > +					  struct netlink_ext_ack *extack) {
> > > > +	struct ice_pf *pf =3D pin_priv;
> > > > +	u32 parent_idx, hw_idx =3D ICE_DPLL_PIN_IDX_INVALID, i;
> > >=20
> > > Reverse christmas tree ordering please.
> >=20
> > Fixed.
> >=20
> > >=20
> > >=20
> > > > +	struct ice_dpll_pin *p;
> > > > +	int ret =3D -EFAULT;
> > > > +
> > > > +	if (!pf)
> > >=20
> > > How exacly this can happen. My wild guess is it can't. Don't do such
> > > pointless checks please, confuses the reader.
> > >=20
> >=20
> > From driver perspective the pf pointer value is given by external entit=
y,
> > why shouldn't it be valdiated?
>=20
> What? You pass it during register, you get it back here. Nothing to
> check. Please drop it. Non-sense checks like this have no place in
> kernel, they only confuse reader as he/she assumes it is a valid case.
>=20
>=20
> [...]
>=20
>=20
> > >=20
> > >=20
> > > > +			pins[i].pin =3D NULL;
> > > > +			return -ENOMEM;
> > > > +		}
> > > > +		if (cgu) {
> > > > +			ret =3D dpll_pin_register(pf->dplls.eec.dpll,
> > > > +						pins[i].pin,
> > > > +						ops, pf, NULL);
> > > > +			if (ret)
> > > > +				return ret;
> > > > +			ret =3D dpll_pin_register(pf->dplls.pps.dpll,
> > > > +						pins[i].pin,
> > > > +						ops, pf, NULL);
> > > > +			if (ret)
> > > > +				return ret;
> > >=20
> > > You have to call dpll_pin_unregister(pf->dplls.eec.dpll, pins[i].pin,=
 ..)
> > > here.
> > >=20
> >=20
> > No, in case of error, the caller releases everything ice_dpll_release_a=
ll(..).
>=20
>=20
> How does ice_dpll_release_all() where you failed? If you need to
> unregister one or both or none? I know that in ice you have odd ways to
> handle error paths in general, but this one clearly seems to be broken.
>=20
>=20
>=20
>=20
>=20
> >=20
> > >=20
> > > > +		}
> > > > +	}
> > > > +	if (cgu) {
> > > > +		ops =3D &ice_dpll_output_ops;
> > > > +		pins =3D pf->dplls.outputs;
> > > > +		for (i =3D 0; i < pf->dplls.num_outputs; i++) {
> > > > +			pins[i].pin =3D dpll_pin_get(pf->dplls.clock_id,
> > > > +						   i + pf->dplls.num_inputs,
> > > > +						   THIS_MODULE, &pins[i].prop);
> > > > +			if (IS_ERR_OR_NULL(pins[i].pin)) {
> > > > +				pins[i].pin =3D NULL;
> > > > +				return -ENOMEM;
> > >=20
> > > Don't make up error values when you get them from the function you ca=
ll:
> > > 	return PTR_ERR(pins[i].pin);
> >=20
> > Fixed.
> >=20
> > >=20
> > > > +			}
> > > > +			ret =3D dpll_pin_register(pf->dplls.eec.dpll, pins[i].pin,
> > > > +						ops, pf, NULL);
> > > > +			if (ret)
> > > > +				return ret;
> > > > +			ret =3D dpll_pin_register(pf->dplls.pps.dpll, pins[i].pin,
> > > > +						ops, pf, NULL);
> > > > +			if (ret)
> > > > +				return ret;
> > >=20
> > > You have to call dpll_pin_unregister(pf->dplls.eec.dpll, pins[i].pin,=
 ..)
> > > here.
> > >=20
> >=20
> > As above, in case of error, the caller releases everything.
>=20
> As above, I don't think it works.
>=20
>=20
> [...]
>=20
>=20
> > > > +	}
> > > > +
> > > > +	if (cgu) {
> > > > +		ret =3D dpll_device_register(pf->dplls.eec.dpll, DPLL_TYPE_EEC,
> > > > +					   &ice_dpll_ops, pf, dev);
> > > > +		if (ret)
> > > > +			goto put_pps;
> > > > +		ret =3D dpll_device_register(pf->dplls.pps.dpll, DPLL_TYPE_PPS,
> > > > +					   &ice_dpll_ops, pf, dev);
> > > > +		if (ret)
> > >=20
> > > You are missing call to dpll_device_unregister(pf->dplls.eec.dpll,
> > > DPLL_TYPE_EEC here. Fix the error path.
> > >=20
> >=20
> > The caller shall do the clean up, but yeah will fix this as here clean =
up
> > is not expected.
>=20
> :) Just make your error paths obvious and easy to follow to not to
> confuse anybody, you included.

I agree with Jiri. The error paths here and in ice_dpll_init_info() are
quite confusing and IMHO error prone.

It will get more easy toread and more consistent if every
initialization function does return an error code would leave the state
clean in case of error. That is, in case of error, such function should
cleanup all the partially allocated/initialized resources.

Note that in ice_dpll_init_info() the situation is more mixed-up as
ice_dpll_release_info() is called on most error paths, except the last
one. Memory should not leaked due to later ice_dpll_release_all(), but
it's really confusing.

Cheers,

Paolo


