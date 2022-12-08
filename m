Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC01E646A4D
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiLHITs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiLHITr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:19:47 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9FF554B34
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 00:19:45 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id k22-20020a05600c1c9600b003d1ee3a6289so452810wms.2
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 00:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+ooZMmcXmue9Kff8N53hMPJTTgiGiij9AU+p0PJ+cCc=;
        b=gBTegd3lDddfvLEV8PCf95btZ5bNtfpI+r1f4/qU6r0tO4nOOd/QWehcomQiADr3eY
         lfCVOh2qus5dYL1RwIJHmiplPFBnQ2dT//eh+qc7cppPwWcWOWj+9+tofGR+yYCfaNm7
         uaf9IauUFff7HKnVo/o9EVS3CuyZWh5aZBLeE53b6TugixryVyCaVWPRh7gpabsXTWbA
         MvV/kBejKR6CMWPWjyQcaoSFzDjMHdghG6gE1JXtzumsAwReqR8PvqhfUOfeilYrDimk
         gHqnZaGi9wXnADHQgvF9ZrmY1DrFz1FkXKM7c2r3s01S8FViPpGjNz2bYf0YDwjIdIOa
         WMyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ooZMmcXmue9Kff8N53hMPJTTgiGiij9AU+p0PJ+cCc=;
        b=G8VkjtLHfWNwxjCPrsbhLPZBHhfcjLD7GW+hOSEAp3i8LBtydXk1oUexr4Fi+0TDD+
         inYTXFv2qz7mUtXGtTbZx0kas78ZaD3CRsqXZU/xUAICAHFnf8dPxHbtgrav8RMBLAtx
         EtfFqnAgSDIN52DxqwCZ0c+kakmNcysWpTjHL84K9FQyytwkVSfnXlRjq4JkJ1fT8Jdo
         02BKBYZzUkEgIdX8VYSj6QfsSe6QKh08b28oHLpLgPqw+NC0v6P1j8cHueBPGNCefpp6
         gCccJmrz4axsT+a0IFJfJ05HI0C21r0oBrihC0zWm0KckrCXasx0yxb3LCDX+42Y0jV8
         JYXw==
X-Gm-Message-State: ANoB5pm5Dr2S5frN3GfSADOF3NKa6QcQPt3sdZ3esjafn9RCRMXz5Cnt
        cE4UEKz7twiZFgFhpHQhTKRYPQ==
X-Google-Smtp-Source: AA0mqf4FlqFSBN6BMTqW7YQJU+FKtB8ZjUAaHwUTE3dANSHLjZWSZP2fDCOberBjx39aATSVZIXKAg==
X-Received: by 2002:a05:600c:1f19:b0:3d0:7026:49f7 with SMTP id bd25-20020a05600c1f1900b003d0702649f7mr1752807wmb.30.1670487584391;
        Thu, 08 Dec 2022 00:19:44 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id z15-20020a7bc7cf000000b003cf894dbc4fsm3959338wmk.25.2022.12.08.00.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 00:19:43 -0800 (PST)
Date:   Thu, 8 Dec 2022 09:19:42 +0100
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
Message-ID: <Y5GeHtp01ievZ0Sf@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <20221129213724.10119-5-vfedorenko@novek.ru>
 <Y4dPaHx1kT3A80n/@nanopsycho>
 <DM6PR11MB4657D9753412AD9DEE7FAB7D9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4n0H9BbzaX5pCpQ@nanopsycho>
 <DM6PR11MB465721310114ECA13F556E8A9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4ol0o5Gpe8ZgAas@nanopsycho>
 <DM6PR11MB4657F675331EB623C52656F69B1D9@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB4657F675331EB623C52656F69B1D9@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 08, 2022 at 01:35:02AM CET, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Friday, December 2, 2022 5:21 PM
>>
>>Fri, Dec 02, 2022 at 03:39:17PM CET, arkadiusz.kubalewski@intel.com wrote:
>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>Sent: Friday, December 2, 2022 1:49 PM
>>>>
>>>>Fri, Dec 02, 2022 at 12:27:32PM CET, arkadiusz.kubalewski@intel.com
>>wrote:
>>>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>>>Sent: Wednesday, November 30, 2022 1:41 PM
>>>>>>
>>>>>>Tue, Nov 29, 2022 at 10:37:24PM CET, vfedorenko@novek.ru wrote:
>>>>>>>From: Vadim Fedorenko <vadfed@fb.com>
>>>>
>>>>[...]
>>>>
>>>>
>>>>>>>+static int ptp_ocp_dpll_get_attr(struct dpll_device *dpll, struct
>>>>>>dpll_attr *attr)
>>>>>>>+{
>>>>>>>+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>>>>>>>+	int sync;
>>>>>>>+
>>>>>>>+	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
>>>>>>>+	dpll_attr_lock_status_set(attr, sync ? DPLL_LOCK_STATUS_LOCKED
>>:
>>>>>>DPLL_LOCK_STATUS_UNLOCKED);
>>>>>>
>>>>>>get,set,confuse. This attr thing sucks, sorry :/
>>>>>
>>>>>Once again, I feel obligated to add some explanations :)
>>>>>
>>>>>getter is ops called by dpll subsystem, it requires data, so here value
>>>>>shall be set for the caller, right?
>>>>>Also have explained the reason why this attr struct and functions are
>>>>>done this way in the response to cover letter concerns.
>>>>
>>>>Okay, I will react there.
>>>
>>>Thanks!
>>>
>>>>
>>>>
>>>>>
>>>>>>
>>>>>>
>>>>>>>+
>>>>>>>+	return 0;
>>>>>>>+}
>>>>>>>+
>>>>>>>+static int ptp_ocp_dpll_pin_get_attr(struct dpll_device *dpll,
>>>>>>>+struct
>>>>>>dpll_pin *pin,
>>>>>>>+				     struct dpll_pin_attr *attr) {
>>>>>>>+	dpll_pin_attr_type_set(attr, DPLL_PIN_TYPE_EXT);
>>>>>>
>>>>>>This is exactly what I was talking about in the cover letter. This is
>>>>>>const, should be put into static struct and passed to
>>>>>>dpll_device_alloc().
>>>>>
>>>>>Actually this type or some other parameters might change in the
>>>>>run-time,
>>>>
>>>>No. This should not change.
>>>>If the pin is SyncE port, it's that for all lifetime of pin. It cannot
>>turn
>>>>to be a EXT/SMA connector all of the sudden. This should be definitelly
>>>>fixed, it's a device topology.
>>>>
>>>>Can you explain the exact scenario when the change of personality of pin
>>>>can happen? Perhaps I'm missing something.
>>>>
>>>
>>>Our device is not capable of doing this type of switch, but why to assume
>>>that some other HW would not? As I understand generic dpll subsystem must
>>not
>>>be tied to any HW, and you proposal makes it exactly tied to our
>>approaches.
>>>As Vadim requested to have possibility to change pin between source/output
>>>"states" this seems also possible that some HW might have multiple types
>>>possible.
>>
>>How? How do you physically change from EXT connector to SyncE port? That
>>does not make sense. Topology is given. Let's go back to Earth here.
>>
>
>I suppose by using some kind of hardware fuse/signal selector controlled by
>firmware/driver. Don't think it is out of space, just depends on hardware.

Can you describe this in more details please? I still don't follow how
it makes sense to allow user to for example change EXT connector to
SyncE port. If the pins are muxed, we already have model for that. But
the same pin physical type change? How?


>
>>
>>>I don't get why "all of the sudden", DPLLA_PIN_TYPE_SUPPORTED can have
>>multiple
>>>values, which means that the user can pick one of those with set command.
>>>Then if HW supports it could redirect signals/setup things accordingly.
>>
>>We have to stritly distinguis between things that are given, wired-up,
>>static and things that could be configured.
>>
>
>This is supposed to be generic interface, right?
>What you insist on, is to hardcode most of it in software, which means that
>hardware designs would have to follow possibilities given by the software.

Sure it is generic. I don't want to hardcode anything. Just the driver
exposes whatever is in HW. If something can change in HW using
configuration, driver/UAPI can expose it. However, what's the point of
exposing something in UAPI which is static in HW? It only introduces
confusion for the UAPI consumer.



>
>>
>>>
>>>>
>>>>
>>>>>depends on the device, it is up to the driver how it will handle any
>>>>>getter, if driver knows it won't change it could also have some static
>>>>>member and copy the data with: dpll_pin_attr_copy(...);
>>>>>
>>>>>>
>>>>>>
>>>>>>>+	return 0;
>>>>>>>+}
>>>>>>>+
>>>>>>>+static struct dpll_device_ops dpll_ops = {
>>>>>>>+	.get	= ptp_ocp_dpll_get_attr,
>>>>>>>+};
>>>>>>>+
>>>>>>>+static struct dpll_pin_ops dpll_pin_ops = {
>>>>>>>+	.get	= ptp_ocp_dpll_pin_get_attr,
>>>>>>>+};
>>>>>>>+
>>>>>>> static int
>>>>>>> ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>>>>>> {
>>>>>>>+	const u8 dpll_cookie[DPLL_COOKIE_LEN] = { "OCP" };
>>>>>>>+	char pin_desc[PIN_DESC_LEN];
>>>>>>> 	struct devlink *devlink;
>>>>>>>+	struct dpll_pin *pin;
>>>>>>> 	struct ptp_ocp *bp;
>>>>>>>-	int err;
>>>>>>>+	int err, i;
>>>>>>>
>>>>>>> 	devlink = devlink_alloc(&ptp_ocp_devlink_ops, sizeof(*bp),
>>&pdev-
>>>>>>>dev);
>>>>>>> 	if (!devlink) {
>>>>>>>@@ -4230,6 +4263,20 @@ ptp_ocp_probe(struct pci_dev *pdev, const
>>>>>>>struct
>>>>>>pci_device_id *id)
>>>>>>>
>>>>>>> 	ptp_ocp_info(bp);
>>>>>>> 	devlink_register(devlink);
>>>>>>>+
>>>>>>>+	bp->dpll = dpll_device_alloc(&dpll_ops, DPLL_TYPE_PPS,
>>dpll_cookie,
>>>>>>pdev->bus->number, bp, &pdev->dev);
>>>>>>>+	if (!bp->dpll) {
>>>>>>>+		dev_err(&pdev->dev, "dpll_device_alloc failed\n");
>>>>>>>+		goto out;
>>>>>>>+	}
>>>>>>>+	dpll_device_register(bp->dpll);
>>>>>>
>>>>>>You still have the 2 step init process. I believe it would be better
>>>>>>to just have dpll_device_create/destroy() to do it in one shot.
>>>>>
>>>>>For me either is ok, but due to pins alloc/register as explained below
>>>>>I would leave it as it is.
>>>>
>>>>Please don't, it has no value. Just adds unnecesary code. Have it nice
>>and
>>>>simple.
>>>>
>>>
>>>Actually this comment relates to the other commit, could we keep comments
>>>in the threads they belong to please, this would be much easier to track.
>>>But yeah sure, if there is no strong opinion on that we could change it.
>>
>>Ok.
>>
>>
>>>
>>>>
>>>>>
>>>>>>
>>>>>>
>>>>>>>+
>>>>>>>+	for (i = 0; i < 4; i++) {
>>>>>>>+		snprintf(pin_desc, PIN_DESC_LEN, "sma%d", i + 1);
>>>>>>>+		pin = dpll_pin_alloc(pin_desc, PIN_DESC_LEN);
>>>>>>>+		dpll_pin_register(bp->dpll, pin, &dpll_pin_ops, bp);
>>>>>>
>>>>>>Same here, no point of having 2 step init.
>>>>>
>>>>>The alloc of a pin is not required if the pin already exist and would
>>>>>be just registered with another dpll.
>>>>
>>>>Please don't. Have a pin created on a single DPLL. Why you make things
>>>>compitated here? I don't follow.
>>>
>>>Tried to explain on the cover-letter thread, let's discuss there please.
>>
>>Ok.
>>
>>
>>>
>>>>
>>>>
>>>>>Once we decide to entirely drop shared pins idea this could be probably
>>>>>done, although other kernel code usually use this twostep approach?
>>>>
>>>>No, it does not. It's is used whatever fits on the individual usecase.
>>>
>>>Similar to above, no strong opinion here from me, for shared pin it is
>>>certainly useful.
>>>
>>>>
>>>>
>>>>>
>>>>>>
>>>>>>
>>>>>>>+	}
>>>>>>>+
>>>>>>> 	return 0;
>>>>>>
>>>>>>
>>>>>>Btw, did you consider having dpll instance here as and auxdev? It
>>>>>>would be suitable I believe. It is quite simple to do it. See
>>>>>>following patch as an example:
>>>>>
>>>>>I haven't think about it, definetly gonna take a look to see if there
>>>>>any benefits in ice.
>>>>
>>>>Please do. The proper separation and bus/device modelling is at least one
>>>>of the benefits. The other one is that all dpll drivers would happily
>>live
>>>>in drivers/dpll/ side by side.
>>>>
>>>
>>>Well, makes sense, but still need to take a closer look on that.
>>>I could do that on ice-driver part, don't feel strong enough yet to
>>introduce
>>
>>Sure Ice should be ready.
>>
>>
>>>Changes here in ptp_ocp.
>>
>>I think that Vadim said he is going to look at that during the call. My
>>commit introducing this to mlxsw is a nice and simple example how this
>>could be done in ptp_ocp.
>>
>
>Yes, though first need to find a bit of time for it :S
>
>Thank you,
>Arkadiusz
>
>>
>>>
>>>Thank you,
>>>Arkadiusz
>>>
>>>>
>>>>
>>>>>
>>>>>Thanks,
>>>>>Arkadiusz
>>>>>
>>>>>>
>>>>>>commit bd02fd76d1909637c95e8ef13e7fd1e748af910d
>>>>>>Author: Jiri Pirko <jiri@nvidia.com>
>>>>>>Date:   Mon Jul 25 10:29:17 2022 +0200
>>>>>>
>>>>>>    mlxsw: core_linecards: Introduce per line card auxiliary device
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>>>
>>>>>>> out:
>>>>>>>@@ -4247,6 +4294,8 @@ ptp_ocp_remove(struct pci_dev *pdev)
>>>>>>> 	struct ptp_ocp *bp = pci_get_drvdata(pdev);
>>>>>>> 	struct devlink *devlink = priv_to_devlink(bp);
>>>>>>>
>>>>>>>+	dpll_device_unregister(bp->dpll);
>>>>>>>+	dpll_device_free(bp->dpll);
>>>>>>> 	devlink_unregister(devlink);
>>>>>>> 	ptp_ocp_detach(bp);
>>>>>>> 	pci_disable_device(pdev);
>>>>>>>--
>>>>>>>2.27.0
>>>>>>>
