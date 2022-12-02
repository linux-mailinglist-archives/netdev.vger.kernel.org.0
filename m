Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8885164071C
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 13:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbiLBMsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 07:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbiLBMsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 07:48:36 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3219E478
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 04:48:35 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id ml11so11319997ejb.6
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 04:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AT0KbpDr/o1zMwkliKr6eks9jc+exErBv7eT8T8pj78=;
        b=skePfRc3JK5U9CKJh6ersO7UP25S5G4SHdxxFzsJKpzlVQ6hGv2q5VOYiRx7WmnXpn
         BNQauBNM0e46G/mWjMEC4+iipBqfouArZ9uQn3UrTbUkmPlwP435V8kiNz/mwxgycyxN
         +m4zeDDo3DJcdntArFveir7heK1/rPbaGLWbLqD6rebzjagzRvUbNM7JEZ4ym/6EywKF
         KMksm8dbbhmDqTTSz5ACVsUV2c3gk9dgmrRyhicQFUDqUqAzTrWl4V1t56gSOz6EDaar
         g+RUMMS89wnVhdrX3R4LkkYLWAm4Kq2Z1ocbt9kO4n7i0CeeEV6iwCb3VKeguH1SbKbT
         e9lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AT0KbpDr/o1zMwkliKr6eks9jc+exErBv7eT8T8pj78=;
        b=Jj0nuNd5N1eDd1XMDn5R/hRYLG3idccjHF4NbYaLGMhdjWsbXNTdRFOJs7V8l15c60
         yL3/aHPQEBdelpT2BFgnRMxA5wXZozg4bM4ee65eKTV4PeIxlzso2Fl4DDRZU7gLN4Xw
         bTkbn1RciEP8j/68HZ8ujZC6fr5bElTPkWPta1xRb/BgpxXspdGA/7zExq9rrsvSKyNq
         Lg+8ralr6+0hEOKdoz5dUFFS3XjS4JXvxOn12Ad1T5y9Imj6X030SBq6Ec3Bt0FUx/GH
         V1/9cIOOLpBCGPW4NP1MV09cNKhGzNVo0RkpgQhMbG3GsKj2tQwHRqiRmPSJAgnXEJGu
         sZkA==
X-Gm-Message-State: ANoB5pmM9J1/xHDGMIP8wD0egdPWh3Aq1f0KoDKS6gvg4DSsY6sAB0PT
        KxdNLAkFVOms0xf5CapX9I0IpA==
X-Google-Smtp-Source: AA0mqf7jWlSapASGV7QpFArGzZKGyztzyAmsT17+Oylni66HWxNUNyk9jUexCfpd8FjM1Nw6MdfrUg==
X-Received: by 2002:a17:906:1ecf:b0:7ad:902c:d1d6 with SMTP id m15-20020a1709061ecf00b007ad902cd1d6mr47737298ejj.143.1669985313640;
        Fri, 02 Dec 2022 04:48:33 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ky1-20020a170907778100b0072a881b21d8sm2959163ejc.119.2022.12.02.04.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 04:48:32 -0800 (PST)
Date:   Fri, 2 Dec 2022 13:48:31 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vadim Fedorenko <vadfed@fb.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v4 4/4] ptp_ocp: implement DPLL ops
Message-ID: <Y4n0H9BbzaX5pCpQ@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <20221129213724.10119-5-vfedorenko@novek.ru>
 <Y4dPaHx1kT3A80n/@nanopsycho>
 <DM6PR11MB4657D9753412AD9DEE7FAB7D9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB4657D9753412AD9DEE7FAB7D9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 02, 2022 at 12:27:32PM CET, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Wednesday, November 30, 2022 1:41 PM
>>
>>Tue, Nov 29, 2022 at 10:37:24PM CET, vfedorenko@novek.ru wrote:
>>>From: Vadim Fedorenko <vadfed@fb.com>

[...]


>>>+static int ptp_ocp_dpll_get_attr(struct dpll_device *dpll, struct
>>dpll_attr *attr)
>>>+{
>>>+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>>>+	int sync;
>>>+
>>>+	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
>>>+	dpll_attr_lock_status_set(attr, sync ? DPLL_LOCK_STATUS_LOCKED :
>>DPLL_LOCK_STATUS_UNLOCKED);
>>
>>get,set,confuse. This attr thing sucks, sorry :/
>
>Once again, I feel obligated to add some explanations :)
>
>getter is ops called by dpll subsystem, it requires data, so here value shall
>be set for the caller, right?
>Also have explained the reason why this attr struct and functions are done this
>way in the response to cover letter concerns.

Okay, I will react there.


>
>>
>>
>>>+
>>>+	return 0;
>>>+}
>>>+
>>>+static int ptp_ocp_dpll_pin_get_attr(struct dpll_device *dpll, struct
>>dpll_pin *pin,
>>>+				     struct dpll_pin_attr *attr)
>>>+{
>>>+	dpll_pin_attr_type_set(attr, DPLL_PIN_TYPE_EXT);
>>
>>This is exactly what I was talking about in the cover letter. This is
>>const, should be put into static struct and passed to
>>dpll_device_alloc().
>
>Actually this type or some other parameters might change in the run-time,

No. This should not change.
If the pin is SyncE port, it's that for all lifetime of pin. It cannot
turn to be a EXT/SMA connector all of the sudden. This should be
definitelly fixed, it's a device topology.

Can you explain the exact scenario when the change of personality of pin
can happen? Perhaps I'm missing something.



>depends on the device, it is up to the driver how it will handle any getter,
>if driver knows it won't change it could also have some static member and copy
>the data with: dpll_pin_attr_copy(...);
>
>>
>>
>>>+	return 0;
>>>+}
>>>+
>>>+static struct dpll_device_ops dpll_ops = {
>>>+	.get	= ptp_ocp_dpll_get_attr,
>>>+};
>>>+
>>>+static struct dpll_pin_ops dpll_pin_ops = {
>>>+	.get	= ptp_ocp_dpll_pin_get_attr,
>>>+};
>>>+
>>> static int
>>> ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>> {
>>>+	const u8 dpll_cookie[DPLL_COOKIE_LEN] = { "OCP" };
>>>+	char pin_desc[PIN_DESC_LEN];
>>> 	struct devlink *devlink;
>>>+	struct dpll_pin *pin;
>>> 	struct ptp_ocp *bp;
>>>-	int err;
>>>+	int err, i;
>>>
>>> 	devlink = devlink_alloc(&ptp_ocp_devlink_ops, sizeof(*bp), &pdev-
>>>dev);
>>> 	if (!devlink) {
>>>@@ -4230,6 +4263,20 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct
>>pci_device_id *id)
>>>
>>> 	ptp_ocp_info(bp);
>>> 	devlink_register(devlink);
>>>+
>>>+	bp->dpll = dpll_device_alloc(&dpll_ops, DPLL_TYPE_PPS, dpll_cookie,
>>pdev->bus->number, bp, &pdev->dev);
>>>+	if (!bp->dpll) {
>>>+		dev_err(&pdev->dev, "dpll_device_alloc failed\n");
>>>+		goto out;
>>>+	}
>>>+	dpll_device_register(bp->dpll);
>>
>>You still have the 2 step init process. I believe it would be better to
>>just have dpll_device_create/destroy() to do it in one shot.
>
>For me either is ok, but due to pins alloc/register as explained below I would
>leave it as it is.

Please don't, it has no value. Just adds unnecesary code. Have it nice
and simple.


>
>>
>>
>>>+
>>>+	for (i = 0; i < 4; i++) {
>>>+		snprintf(pin_desc, PIN_DESC_LEN, "sma%d", i + 1);
>>>+		pin = dpll_pin_alloc(pin_desc, PIN_DESC_LEN);
>>>+		dpll_pin_register(bp->dpll, pin, &dpll_pin_ops, bp);
>>
>>Same here, no point of having 2 step init.
>
>The alloc of a pin is not required if the pin already exist and would be just
>registered with another dpll.

Please don't. Have a pin created on a single DPLL. Why you make things
compitated here? I don't follow.


>Once we decide to entirely drop shared pins idea this could be probably done,
>although other kernel code usually use this twostep approach?

No, it does not. It's is used whatever fits on the individual usecase.


>
>>
>>
>>>+	}
>>>+
>>> 	return 0;
>>
>>
>>Btw, did you consider having dpll instance here as and auxdev? It would
>>be suitable I believe. It is quite simple to do it. See following patch
>>as an example:
>
>I haven't think about it, definetly gonna take a look to see if there any
>benefits in ice.

Please do. The proper separation and bus/device modelling is at least
one of the benefits. The other one is that all dpll drivers would
happily live in drivers/dpll/ side by side.



>
>Thanks,
>Arkadiusz
>
>>
>>commit bd02fd76d1909637c95e8ef13e7fd1e748af910d
>>Author: Jiri Pirko <jiri@nvidia.com>
>>Date:   Mon Jul 25 10:29:17 2022 +0200
>>
>>    mlxsw: core_linecards: Introduce per line card auxiliary device
>>
>>
>>
>>
>>>
>>> out:
>>>@@ -4247,6 +4294,8 @@ ptp_ocp_remove(struct pci_dev *pdev)
>>> 	struct ptp_ocp *bp = pci_get_drvdata(pdev);
>>> 	struct devlink *devlink = priv_to_devlink(bp);
>>>
>>>+	dpll_device_unregister(bp->dpll);
>>>+	dpll_device_free(bp->dpll);
>>> 	devlink_unregister(devlink);
>>> 	ptp_ocp_detach(bp);
>>> 	pci_disable_device(pdev);
>>>--
>>>2.27.0
>>>
