Return-Path: <netdev+bounces-2864-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA740704545
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:26:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E17A2814F3
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 06:26:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E5491D2C8;
	Tue, 16 May 2023 06:26:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379775C9C
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 06:26:34 +0000 (UTC)
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB439E
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 23:26:31 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-96b4ed40d97so274695066b.0
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 23:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684218389; x=1686810389;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ncnk5u25n1gKhMi5UjBgWgY2AR5TG5mfySIQXV43uLs=;
        b=Kpf7UzvzzxHh5bvV+R50ESbrX1kVXjvfxkNVibVXDJtGAxWpS101Rz44PC3CFQKUee
         MbPbEX4/cAq1acTDSZnM3k911WeRpfekjBt62onyIfjBgtuSZcHwvzbyHSfn91Y2Wyyg
         rIWlPvtCtFF/z0fggAO2rPmfJKLHnVTcfNJ1+1PvZx+YRNndB1J26YQ/yHXWXdcb77LU
         tUo8ACRChqXD9dCbKGlVKdrSVj7Wi8QgYGW5Y1ER1OB76eO+I+CLXfbm+zHo3+Esc9tE
         L2X6Hoa3CCIIzFbRe3A9odykqRsD2CpOfkoIDkb9RjscYGgLLf2um9ZbJm38ka50TBD2
         mnqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684218389; x=1686810389;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ncnk5u25n1gKhMi5UjBgWgY2AR5TG5mfySIQXV43uLs=;
        b=aNsZsgEWjh+DJ1yQnImh56wRgXsVSQ4Ci4+oKLD+vn+bvZVtI9ZX7ww7YBxa6gHeh+
         EMIJsYN2NXUw3EgRryhrGFNGGrU/ZG1llRLDqhWNkpkHwT+ClxRqvYSyxgGgETq3mD3r
         t777zHyuk8+fsSeeBl9JP1g/K2wWaUGQkuLrvj30svqbYA6yx++B24ppuwYdvYTnU5E6
         n/lEj9A1n/QWN6oEFTxKLvRC5bZBQUSyzoOPQ5vu1iwGlB5D2ERwG/TJ+27hj+n28luU
         d3ROEzYLxHMBab36sC1HP/XQ6VMqlitoYCKucA/nRdSH/8B8iQx04eC9FtjSJhAkDjuE
         Lp3w==
X-Gm-Message-State: AC+VfDxJ40Lj6eb532h8BsAmvTYuy1fQTqAH/AfrITNGWkLb4ZQItjRA
	FUSol1na399/sq4hYJm7MDUAAg==
X-Google-Smtp-Source: ACHHUZ4T0YNJLV13EFOWH4PksgAdo38fAvy+qD8boms/O8jp2/miH61xuB9s88pWcSdObsm+kMYFZQ==
X-Received: by 2002:a17:907:60d6:b0:957:1df0:9cbf with SMTP id hv22-20020a17090760d600b009571df09cbfmr37389568ejc.19.1684218389369;
        Mon, 15 May 2023 23:26:29 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id a23-20020a1709065f9700b0096a3d346d6asm8170826eju.211.2023.05.15.23.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 23:26:28 -0700 (PDT)
Date: Tue, 16 May 2023 08:26:27 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc: Vadim Fedorenko <vadfed@meta.com>, Jakub Kicinski <kuba@kernel.org>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Olech, Milena" <milena.olech@intel.com>,
	"Michalik, Michal" <michal.michalik@intel.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v7 5/8] ice: implement dpll interface to control cgu
Message-ID: <ZGMiE1ByArIr8ARB@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-6-vadfed@meta.com>
 <ZFJRIY1HM64gFo3a@nanopsycho>
 <DM6PR11MB4657EAF163220617A94154A39B789@DM6PR11MB4657.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB4657EAF163220617A94154A39B789@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Tue, May 16, 2023 at 12:07:57AM CEST, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Wednesday, May 3, 2023 2:19 PM
>>
>>Fri, Apr 28, 2023 at 02:20:06AM CEST, vadfed@meta.com wrote:
>>>From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[...]


>>>+ * ice_dpll_frequency_set - wrapper for pin callback for set frequency
>>>+ * @pin: pointer to a pin
>>>+ * @pin_priv: private data pointer passed on pin registration
>>>+ * @dpll: pointer to dpll
>>>+ * @frequency: frequency to be set
>>>+ * @extack: error reporting
>>>+ * @pin_type: type of pin being configured
>>>+ *
>>>+ * Wraps internal set frequency command on a pin.
>>>+ *
>>>+ * Return:
>>>+ * * 0 - success
>>>+ * * negative - error pin not found or couldn't set in hw  */ static
>>>+int ice_dpll_frequency_set(const struct dpll_pin *pin, void *pin_priv,
>>>+		       const struct dpll_device *dpll,
>>>+		       const u32 frequency,
>>>+		       struct netlink_ext_ack *extack,
>>>+		       const enum ice_dpll_pin_type pin_type) {
>>>+	struct ice_pf *pf = pin_priv;
>>>+	struct ice_dpll_pin *p;
>>>+	int ret = -EINVAL;
>>>+
>>>+	if (!pf)
>>>+		return ret;
>>>+	if (ice_dpll_cb_lock(pf))
>>>+		return -EBUSY;
>>>+	p = ice_find_pin(pf, pin, pin_type);
>>
>>This does not make any sense to me. You should avoid the lookups and remove
>>ice_find_pin() function entirely. The purpose of having pin_priv is to
>>carry the struct ice_dpll_pin * directly. You should pass it down during
>>pin register.
>>
>>pf pointer is stored in dpll_priv.
>>
>
>In this case dpll_priv is not passed, so cannot use it.

It should be passed. In general to every op where *dpll is passed, the
dpll_priv pointer should be passed along. Please, fix this.


>But in general it makes sense I will hold pf inside of ice_dpll_pin
>and fix this.

Nope, just use dpll_priv. That's why we have it.


[...]


>>>+/**
>>>+ * ice_dpll_pin_state_set - set pin's state on dpll
>>>+ * @dpll: dpll being configured
>>>+ * @pin: pointer to a pin
>>>+ * @pin_priv: private data pointer passed on pin registration
>>>+ * @state: state of pin to be set
>>>+ * @extack: error reporting
>>>+ * @pin_type: type of a pin
>>>+ *
>>>+ * Set pin state on a pin.
>>>+ *
>>>+ * Return:
>>>+ * * 0 - OK or no change required
>>>+ * * negative - error
>>>+ */
>>>+static int
>>>+ice_dpll_pin_state_set(const struct dpll_device *dpll,
>>>+		       const struct dpll_pin *pin, void *pin_priv,
>>>+		       const enum dpll_pin_state state,
>>
>>Why you use const with enums?
>>
>
>Just show usage intention explicitly.

Does not make any sense what so ever. Please avoid it.


>>>+static int ice_dpll_rclk_state_on_pin_get(const struct dpll_pin *pin,
>>>+					  void *pin_priv,
>>>+					  const struct dpll_pin *parent_pin,
>>>+					  enum dpll_pin_state *state,
>>>+					  struct netlink_ext_ack *extack) {
>>>+	struct ice_pf *pf = pin_priv;
>>>+	u32 parent_idx, hw_idx = ICE_DPLL_PIN_IDX_INVALID, i;
>>
>>Reverse christmas tree ordering please.
>
>Fixed.
>
>>
>>
>>>+	struct ice_dpll_pin *p;
>>>+	int ret = -EFAULT;
>>>+
>>>+	if (!pf)
>>
>>How exacly this can happen. My wild guess is it can't. Don't do such
>>pointless checks please, confuses the reader.
>>
>
>From driver perspective the pf pointer value is given by external entity,
>why shouldn't it be valdiated?

What? You pass it during register, you get it back here. Nothing to
check. Please drop it. Non-sense checks like this have no place in
kernel, they only confuse reader as he/she assumes it is a valid case.


[...]


>>
>>
>>>+			pins[i].pin = NULL;
>>>+			return -ENOMEM;
>>>+		}
>>>+		if (cgu) {
>>>+			ret = dpll_pin_register(pf->dplls.eec.dpll,
>>>+						pins[i].pin,
>>>+						ops, pf, NULL);
>>>+			if (ret)
>>>+				return ret;
>>>+			ret = dpll_pin_register(pf->dplls.pps.dpll,
>>>+						pins[i].pin,
>>>+						ops, pf, NULL);
>>>+			if (ret)
>>>+				return ret;
>>
>>You have to call dpll_pin_unregister(pf->dplls.eec.dpll, pins[i].pin, ..)
>>here.
>>
>
>No, in case of error, the caller releases everything ice_dpll_release_all(..).


How does ice_dpll_release_all() where you failed? If you need to
unregister one or both or none? I know that in ice you have odd ways to
handle error paths in general, but this one clearly seems to be broken.





>
>>
>>>+		}
>>>+	}
>>>+	if (cgu) {
>>>+		ops = &ice_dpll_output_ops;
>>>+		pins = pf->dplls.outputs;
>>>+		for (i = 0; i < pf->dplls.num_outputs; i++) {
>>>+			pins[i].pin = dpll_pin_get(pf->dplls.clock_id,
>>>+						   i + pf->dplls.num_inputs,
>>>+						   THIS_MODULE, &pins[i].prop);
>>>+			if (IS_ERR_OR_NULL(pins[i].pin)) {
>>>+				pins[i].pin = NULL;
>>>+				return -ENOMEM;
>>
>>Don't make up error values when you get them from the function you call:
>>	return PTR_ERR(pins[i].pin);
>
>Fixed.
>
>>
>>>+			}
>>>+			ret = dpll_pin_register(pf->dplls.eec.dpll, pins[i].pin,
>>>+						ops, pf, NULL);
>>>+			if (ret)
>>>+				return ret;
>>>+			ret = dpll_pin_register(pf->dplls.pps.dpll, pins[i].pin,
>>>+						ops, pf, NULL);
>>>+			if (ret)
>>>+				return ret;
>>
>>You have to call dpll_pin_unregister(pf->dplls.eec.dpll, pins[i].pin, ..)
>>here.
>>
>
>As above, in case of error, the caller releases everything.

As above, I don't think it works.


[...]


>>>+	}
>>>+
>>>+	if (cgu) {
>>>+		ret = dpll_device_register(pf->dplls.eec.dpll, DPLL_TYPE_EEC,
>>>+					   &ice_dpll_ops, pf, dev);
>>>+		if (ret)
>>>+			goto put_pps;
>>>+		ret = dpll_device_register(pf->dplls.pps.dpll, DPLL_TYPE_PPS,
>>>+					   &ice_dpll_ops, pf, dev);
>>>+		if (ret)
>>
>>You are missing call to dpll_device_unregister(pf->dplls.eec.dpll,
>>DPLL_TYPE_EEC here. Fix the error path.
>>
>
>The caller shall do the clean up, but yeah will fix this as here clean up
>is not expected.

:) Just make your error paths obvious and easy to follow to not to
confuse anybody, you included.


>
>>
>>>+			goto put_pps;
>>>+	}
>>>+
>>>+	return 0;
>>>+
>>>+put_pps:
>>>+	dpll_device_put(pf->dplls.pps.dpll);
>>>+	pf->dplls.pps.dpll = NULL;
>>>+put_eec:
>>>+	dpll_device_put(pf->dplls.eec.dpll);
>>>+	pf->dplls.eec.dpll = NULL;
>>>+
>>>+	return ret;
>>>+}

[...]

