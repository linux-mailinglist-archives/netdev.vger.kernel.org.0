Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4101640A8B
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 17:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbiLBQYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 11:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234048AbiLBQYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 11:24:09 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D1C37F82
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 08:20:38 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ud5so12688366ejc.4
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 08:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y8LFScKqDqzJLrtmOOWlBwZ43NPyTwr4I3sDAVqBnGc=;
        b=7s8mLbD6VDNc/lOLdjSMH1X/KN4UtySwF8Rioh+6fuONHVoJ3Rs6jsAMwB1lRaLbEa
         wmLEK33GR1k9uCEthryrvIxDzAme+CRxhr13biSKLAwQj176m5zgHrs6S8U6NZMdKzv3
         5FpUeQD5l85J2CCMg1YktcyfTGWGhlVFEdnhZwxsz6BHg9UizNUcNO6EFJccL5vH8+8N
         2rvIgmfrIcvUYtBxFkyCwQJWoVWoM2nxOa3sLHd1vnSCJiE0sC5kKLrhCbG4Vanhxrr4
         4rbcbzE8+5SG5AHPk9txwGTCRq7BVvhWSOtpuUfcqtBTn+1+lsA06JSlhbe1FHvh9hbk
         tm7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y8LFScKqDqzJLrtmOOWlBwZ43NPyTwr4I3sDAVqBnGc=;
        b=L3WK/6XE1nF9vU8pyNW1MW5+3bZjKUJ1kpC9YgxERwxHtDUeKk7H/4XAYH3LBi9s4c
         RWNsjNrJj6w6S7Uq7+F/gl8MOMs7gmADU+Us6THoPbhRsOeDgsyGC3UcCHzSfCv4nykd
         t/aU+g20bqJkuxoB51EwX1hC61cRgOkNSkG6P4LE0hmIEGZpKNPjA/DiZUQqmlnlFpeC
         ZLyT/j7mRGgDV5b/zDbexJtokjuSXZWJW5ZuQDxdUuakbKAMaEAuuzaiFs4JdDeKxLhX
         EyI5AbUwfo69qnd3VohEmilLsHPedAXSk9v4PPpDVHnHqqgmsjvYJwDIiAHg1Hn/UN8P
         Bnfg==
X-Gm-Message-State: ANoB5pkc2eNFO2YGh3xoUBs5JdZQ+282STphg2/kHHCKEsx9ciLfInjp
        LpRfD7ONv63bIQ7ElAZjy7cJvg==
X-Google-Smtp-Source: AA0mqf5i6upWvhvjXMNyRH65grYqmXIUmKbfuBXzercxFOECmsfQ/bU491DNLSWw5XLYfNioxXgZNw==
X-Received: by 2002:a17:906:99c8:b0:7b5:ff35:6715 with SMTP id s8-20020a17090699c800b007b5ff356715mr41992388ejn.255.1669998036795;
        Fri, 02 Dec 2022 08:20:36 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id fg7-20020a056402548700b0046b847d6a1csm3052642edb.21.2022.12.02.08.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 08:20:35 -0800 (PST)
Date:   Fri, 2 Dec 2022 17:20:34 +0100
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
Message-ID: <Y4ol0o5Gpe8ZgAas@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <20221129213724.10119-5-vfedorenko@novek.ru>
 <Y4dPaHx1kT3A80n/@nanopsycho>
 <DM6PR11MB4657D9753412AD9DEE7FAB7D9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4n0H9BbzaX5pCpQ@nanopsycho>
 <DM6PR11MB465721310114ECA13F556E8A9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB465721310114ECA13F556E8A9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 02, 2022 at 03:39:17PM CET, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Friday, December 2, 2022 1:49 PM
>>
>>Fri, Dec 02, 2022 at 12:27:32PM CET, arkadiusz.kubalewski@intel.com wrote:
>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>Sent: Wednesday, November 30, 2022 1:41 PM
>>>>
>>>>Tue, Nov 29, 2022 at 10:37:24PM CET, vfedorenko@novek.ru wrote:
>>>>>From: Vadim Fedorenko <vadfed@fb.com>
>>
>>[...]
>>
>>
>>>>>+static int ptp_ocp_dpll_get_attr(struct dpll_device *dpll, struct
>>>>dpll_attr *attr)
>>>>>+{
>>>>>+	struct ptp_ocp *bp = (struct ptp_ocp *)dpll_priv(dpll);
>>>>>+	int sync;
>>>>>+
>>>>>+	sync = ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
>>>>>+	dpll_attr_lock_status_set(attr, sync ? DPLL_LOCK_STATUS_LOCKED :
>>>>DPLL_LOCK_STATUS_UNLOCKED);
>>>>
>>>>get,set,confuse. This attr thing sucks, sorry :/
>>>
>>>Once again, I feel obligated to add some explanations :)
>>>
>>>getter is ops called by dpll subsystem, it requires data, so here value
>>>shall be set for the caller, right?
>>>Also have explained the reason why this attr struct and functions are
>>>done this way in the response to cover letter concerns.
>>
>>Okay, I will react there.
>
>Thanks!
>
>>
>>
>>>
>>>>
>>>>
>>>>>+
>>>>>+	return 0;
>>>>>+}
>>>>>+
>>>>>+static int ptp_ocp_dpll_pin_get_attr(struct dpll_device *dpll,
>>>>>+struct
>>>>dpll_pin *pin,
>>>>>+				     struct dpll_pin_attr *attr) {
>>>>>+	dpll_pin_attr_type_set(attr, DPLL_PIN_TYPE_EXT);
>>>>
>>>>This is exactly what I was talking about in the cover letter. This is
>>>>const, should be put into static struct and passed to
>>>>dpll_device_alloc().
>>>
>>>Actually this type or some other parameters might change in the
>>>run-time,
>>
>>No. This should not change.
>>If the pin is SyncE port, it's that for all lifetime of pin. It cannot turn
>>to be a EXT/SMA connector all of the sudden. This should be definitelly
>>fixed, it's a device topology.
>>
>>Can you explain the exact scenario when the change of personality of pin
>>can happen? Perhaps I'm missing something.
>>
>
>Our device is not capable of doing this type of switch, but why to assume
>that some other HW would not? As I understand generic dpll subsystem must not
>be tied to any HW, and you proposal makes it exactly tied to our approaches.
>As Vadim requested to have possibility to change pin between source/output
>"states" this seems also possible that some HW might have multiple types
>possible.

How? How do you physically change from EXT connector to SyncE port? That
does not make sense. Topology is given. Let's go back to Earth here.


>I don't get why "all of the sudden", DPLLA_PIN_TYPE_SUPPORTED can have multiple
>values, which means that the user can pick one of those with set command.
>Then if HW supports it could redirect signals/setup things accordingly.

We have to stritly distinguis between things that are given, wired-up,
static and things that could be configured.


>
>>
>>
>>>depends on the device, it is up to the driver how it will handle any
>>>getter, if driver knows it won't change it could also have some static
>>>member and copy the data with: dpll_pin_attr_copy(...);
>>>
>>>>
>>>>
>>>>>+	return 0;
>>>>>+}
>>>>>+
>>>>>+static struct dpll_device_ops dpll_ops = {
>>>>>+	.get	= ptp_ocp_dpll_get_attr,
>>>>>+};
>>>>>+
>>>>>+static struct dpll_pin_ops dpll_pin_ops = {
>>>>>+	.get	= ptp_ocp_dpll_pin_get_attr,
>>>>>+};
>>>>>+
>>>>> static int
>>>>> ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>>>> {
>>>>>+	const u8 dpll_cookie[DPLL_COOKIE_LEN] = { "OCP" };
>>>>>+	char pin_desc[PIN_DESC_LEN];
>>>>> 	struct devlink *devlink;
>>>>>+	struct dpll_pin *pin;
>>>>> 	struct ptp_ocp *bp;
>>>>>-	int err;
>>>>>+	int err, i;
>>>>>
>>>>> 	devlink = devlink_alloc(&ptp_ocp_devlink_ops, sizeof(*bp), &pdev-
>>>>>dev);
>>>>> 	if (!devlink) {
>>>>>@@ -4230,6 +4263,20 @@ ptp_ocp_probe(struct pci_dev *pdev, const
>>>>>struct
>>>>pci_device_id *id)
>>>>>
>>>>> 	ptp_ocp_info(bp);
>>>>> 	devlink_register(devlink);
>>>>>+
>>>>>+	bp->dpll = dpll_device_alloc(&dpll_ops, DPLL_TYPE_PPS, dpll_cookie,
>>>>pdev->bus->number, bp, &pdev->dev);
>>>>>+	if (!bp->dpll) {
>>>>>+		dev_err(&pdev->dev, "dpll_device_alloc failed\n");
>>>>>+		goto out;
>>>>>+	}
>>>>>+	dpll_device_register(bp->dpll);
>>>>
>>>>You still have the 2 step init process. I believe it would be better
>>>>to just have dpll_device_create/destroy() to do it in one shot.
>>>
>>>For me either is ok, but due to pins alloc/register as explained below
>>>I would leave it as it is.
>>
>>Please don't, it has no value. Just adds unnecesary code. Have it nice and
>>simple.
>>
>
>Actually this comment relates to the other commit, could we keep comments
>in the threads they belong to please, this would be much easier to track.
>But yeah sure, if there is no strong opinion on that we could change it.

Ok.


>
>>
>>>
>>>>
>>>>
>>>>>+
>>>>>+	for (i = 0; i < 4; i++) {
>>>>>+		snprintf(pin_desc, PIN_DESC_LEN, "sma%d", i + 1);
>>>>>+		pin = dpll_pin_alloc(pin_desc, PIN_DESC_LEN);
>>>>>+		dpll_pin_register(bp->dpll, pin, &dpll_pin_ops, bp);
>>>>
>>>>Same here, no point of having 2 step init.
>>>
>>>The alloc of a pin is not required if the pin already exist and would
>>>be just registered with another dpll.
>>
>>Please don't. Have a pin created on a single DPLL. Why you make things
>>compitated here? I don't follow.
>
>Tried to explain on the cover-letter thread, let's discuss there please.

Ok.


>
>>
>>
>>>Once we decide to entirely drop shared pins idea this could be probably
>>>done, although other kernel code usually use this twostep approach?
>>
>>No, it does not. It's is used whatever fits on the individual usecase.
>
>Similar to above, no strong opinion here from me, for shared pin it is
>certainly useful.
>
>>
>>
>>>
>>>>
>>>>
>>>>>+	}
>>>>>+
>>>>> 	return 0;
>>>>
>>>>
>>>>Btw, did you consider having dpll instance here as and auxdev? It
>>>>would be suitable I believe. It is quite simple to do it. See
>>>>following patch as an example:
>>>
>>>I haven't think about it, definetly gonna take a look to see if there
>>>any benefits in ice.
>>
>>Please do. The proper separation and bus/device modelling is at least one
>>of the benefits. The other one is that all dpll drivers would happily live
>>in drivers/dpll/ side by side.
>>
>
>Well, makes sense, but still need to take a closer look on that.
>I could do that on ice-driver part, don't feel strong enough yet to introduce

Sure Ice should be ready.


>Changes here in ptp_ocp.

I think that Vadim said he is going to look at that during the call. My
commit introducing this to mlxsw is a nice and simple example how this
could be done in ptp_ocp.


>
>Thank you,
>Arkadiusz
>
>>
>>
>>>
>>>Thanks,
>>>Arkadiusz
>>>
>>>>
>>>>commit bd02fd76d1909637c95e8ef13e7fd1e748af910d
>>>>Author: Jiri Pirko <jiri@nvidia.com>
>>>>Date:   Mon Jul 25 10:29:17 2022 +0200
>>>>
>>>>    mlxsw: core_linecards: Introduce per line card auxiliary device
>>>>
>>>>
>>>>
>>>>
>>>>>
>>>>> out:
>>>>>@@ -4247,6 +4294,8 @@ ptp_ocp_remove(struct pci_dev *pdev)
>>>>> 	struct ptp_ocp *bp = pci_get_drvdata(pdev);
>>>>> 	struct devlink *devlink = priv_to_devlink(bp);
>>>>>
>>>>>+	dpll_device_unregister(bp->dpll);
>>>>>+	dpll_device_free(bp->dpll);
>>>>> 	devlink_unregister(devlink);
>>>>> 	ptp_ocp_detach(bp);
>>>>> 	pci_disable_device(pdev);
>>>>>--
>>>>>2.27.0
>>>>>
