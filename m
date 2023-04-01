Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCF16D30D0
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 14:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjDAMtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 08:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDAMts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 08:49:48 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A62BBDF4
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 05:49:45 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id t10so99971928edd.12
        for <netdev@vger.kernel.org>; Sat, 01 Apr 2023 05:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1680353384;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3ewVCP+wDJHX46RNaKAZarx7ThtmmaIaa+PN5mp/uXI=;
        b=KjoCp7+uXnJLPnyG7tx0qBq+jW2fO0pUeHxkLnG2pfZRO45BJ2F7oFWMNPVoes+kSv
         SN/87ysk/WTWanPqKDYoFmasrbGoIXR3RFI5Fz/mZQ7qt7D/lbsNCU1XVfe+Ki3nQuYs
         BYJONtvqyweOdKlBwq8+pB9aeVIgHKkmEHppCEiy5Upltb/1QTFoIl/e9yqsY/ivBnC4
         XqXUJL0N6gbMWGCvRS427wQ2bSeHLPC+7VVozrjNW4Wp2v7W2phYz4tVNpby0TTXUdnm
         7VpBx4Ubong80KWZYgNHRG8OI4ofwEo/zfD5aWIAVKIiUKZAzoQE2hpHlRztcYZumvgH
         Fw5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680353384;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ewVCP+wDJHX46RNaKAZarx7ThtmmaIaa+PN5mp/uXI=;
        b=QxGc0O7m2IhtLge8AFTRk574YteNgWMKMsChPAb59fWS7rdsWVi8s8REUPMZJ7tgZh
         gHRoBB4D02nnUIp8zf9raizDc/6S/NZCsQvIJ02D+DuW/vkrpj9ckp7OFR4QvxMH+zbW
         3sFBOv3tuDJn9DAlH9ETT6nJE814vjqXtQfZwEIOavkTd6mvAeuuwaj4T4M5ZjdJSCFU
         GTPoBQoLAsNN5TfJun0Z7w3ReeyJhz0nwh9JAg0JSJJD/MlDlbuI0xt9pH+KERIfOd4t
         b9ef2cjwXrlx6bqpeNh1QEO8IbnPthAbPLvdyT7/9+6+p9SHrFtvjK23GjsqeZZ6Oiv8
         Z6HQ==
X-Gm-Message-State: AAQBX9eckGDbpqModZBcZyznAmoCMkf+07otwMuPUB7KX0vxHjXlWq/g
        0ls9Pc44nBLk+zsRXfoE5XQLuA==
X-Google-Smtp-Source: AKy350adyWbn7jQXnTGpzPFF4lXd+Au+soeUfPr6sJfOYwooSsz1o63aMbbl5rmMFD3s3DKr3f0MMg==
X-Received: by 2002:aa7:d3cc:0:b0:502:ef8:1c80 with SMTP id o12-20020aa7d3cc000000b005020ef81c80mr31270334edr.21.1680353383732;
        Sat, 01 Apr 2023 05:49:43 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id f24-20020a50a6d8000000b004acbda55f6bsm2070677edc.27.2023.04.01.05.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Apr 2023 05:49:42 -0700 (PDT)
Date:   Sat, 1 Apr 2023 14:49:41 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, poros <poros@redhat.com>,
        mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Message-ID: <ZCgoZWjFcivWmDNJ@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-3-vadfed@meta.com>
 <ZA9Nbll8+xHt4ygd@nanopsycho>
 <2b749045-021e-d6c8-b265-972cfa892802@linux.dev>
 <ZBA8ofFfKigqZ6M7@nanopsycho>
 <DM6PR11MB4657120805D656A745EF724E9BBE9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZBGOWQW+1JFzNsTY@nanopsycho>
 <c7da39fb-f60d-ac0c-ddc3-cb9b9280081d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7da39fb-f60d-ac0c-ddc3-cb9b9280081d@linux.dev>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Mar 28, 2023 at 05:22:04PM CEST, vadim.fedorenko@linux.dev wrote:
>On 15/03/2023 09:22, Jiri Pirko wrote:
>> Tue, Mar 14, 2023 at 06:50:57PM CET, arkadiusz.kubalewski@intel.com wrote:
>> > > From: Jiri Pirko <jiri@resnulli.us>
>> > > Sent: Tuesday, March 14, 2023 10:22 AM
>> > > 
>> > > Mon, Mar 13, 2023 at 11:59:32PM CET, vadim.fedorenko@linux.dev wrote:
>> > > > On 13.03.2023 16:21, Jiri Pirko wrote:
>> > > > > Sun, Mar 12, 2023 at 03:28:03AM CET, vadfed@meta.com wrote:

[...]


>> > > > > > +static int
>> > > > > > +dpll_msg_add_dev_handle(struct sk_buff *msg, const struct dpll_device
>> > > > > > *dpll)
>> > > > > > +{
>> > > > > > +	if (nla_put_u32(msg, DPLL_A_ID, dpll->id))
>> > > > > 
>> > > > > Why exactly do we need this dua--handle scheme? Why do you need
>> > > > > unpredictable DPLL_A_ID to be exposed to userspace?
>> > > > > It's just confusing.
>> > > > > 
>> > > > To be able to work with DPLL per integer after iterator on the list deducts
>> > > > which DPLL device is needed. It can reduce the amount of memory copies and
>> > > > simplify comparisons. Not sure why it's confusing.
>> > > 
>> > > Wait, I don't get it. Could you please explain a bit more?
>> > > 
>> > > My point is, there should be not such ID exposed over netlink
>> > > You don't need to expose it to userspace. The user has well defined
>> > > handle as you agreed with above. For example:
>> > > 
>> > > ice/c92d02a7129f4747/1
>> > > ice/c92d02a7129f4747/2
>> > > 
>> > > This is shown in dpll device GET/DUMP outputs.
>> > > Also user passes it during SET operation:
>> > > $ dplltool set ice/c92d02a7129f4747/1 mode auto
>> > > 
>> > > Isn't that enough stable and nice?
>> > > 
>> > 
>> > I agree with Vadim, this is rather to be used by a daemon tools, which
>> > would get the index once, then could use it as long as device is there.
>> 
>> So basically you say, you can have 2 approaches in app:
>> 1)
>> id = dpll_device_get_id("ice/c92d02a7129f4747/1")
>> dpll_device_set(id, something);
>> dpll_device_set(id, something);
>> dpll_device_set(id, something);
>> 2):
>> dpll_device_set("ice/c92d02a7129f4747/1, something);
>> dpll_device_set("ice/c92d02a7129f4747/1, something);
>> dpll_device_set("ice/c92d02a7129f4747/1, something);
>> 
>> What is exactly benefit of the first one? Why to have 2 handles? Devlink
>> is a nice example of 2) approach, no problem there.
>> 
>> Perhaps I'm missing something, but looks like you want the id for no
>> good reason and this dual-handle scheme just makes things more
>> complicated with 0 added value.
>
>I would like to avoid any extra memory copies or memory checks when it's
>possible to compare single u32/u64 index value. I might be invisible on a
>single host setup, but running monitoring at scale which will parse and
>compare string on every get/event can burn a bit of compute capacity.

Wait, that does not make any sense what so ever.
Show me numbers and real usecase. A sane app gets once at start, then
processes notifications. You have a flow where string compare on a
netlink command makes difference to int compare? Like tens of thousands
of netlink cmds per second? I doubt that. If yes, it is a misuse. Btw,
the string compare would be your last problem comparing the overhead of
Netlink processing with ioctl for example.

Your dual handle scheme just adds complexicity, confusion with 0 added
value. Please drop it. I really don't understand the need to defend this
odd approach :/

[...]


>> > > > > > +
>> > > > > > +	return dpll_pre_dumpit(cb);
>> > > > > > +}
>> > > > > > +
>> > > > > > +int dpll_pin_post_dumpit(struct netlink_callback *cb)
>> > > > > > +{
>> > > > > > +	mutex_unlock(&dpll_pin_xa_lock);
>> > > > > > +
>> > > > > > +	return dpll_post_dumpit(cb);
>> > > > > > +}
>> > > > > > +
>> > > > > > +static int
>> > > > > > +dpll_event_device_change(struct sk_buff *msg, struct dpll_device
>> > > > > > *dpll,
>> > > > > > +			 struct dpll_pin *pin, struct dpll_pin *parent,
>> > > > > > +			 enum dplla attr)
>> > > > > > +{
>> > > > > > +	int ret = dpll_msg_add_dev_handle(msg, dpll);
>> > > > > > +	struct dpll_pin_ref *ref = NULL;
>> > > > > > +	enum dpll_pin_state state;
>> > > > > > +
>> > > > > > +	if (ret)
>> > > > > > +		return ret;
>> > > > > > +	if (pin && nla_put_u32(msg, DPLL_A_PIN_IDX, pin-
>> > > > > > dev_driver_id))
>> > > > > > +		return -EMSGSIZE;
>> > > > > 
>> > > > > I don't really understand why you are trying figure something new and
>> > > > > interesting with the change notifications. This object mix and random
>> > > > > attrs fillup is something very wrong and makes userspace completely
>> > > > > fuzzy about what it is getting. And yet it is so simple:
>> > > > > You have 2 objects, dpll and pin, please just have:
>> > > > > dpll_notify()
>> > > > > dpll_pin_notify()
>> > > > > and share the attrs fillup code with pin_get() and dpll_get() callbacks.
>> > > > > No need for any smartness. Have this dumb and simple.
>> > > > > 
>> > > > > Think about it more as about "object-state-snapshot" than "atomic-change"
>> > > > 
>> > > > But with full object-snapshot user space app will lose the information about
>> > > > what exactly has changed. The reason to have this event is to provide the
>> > > > attributes which have changed. Otherwise, the app should have full snapshot
>> > > > and
>> > > > compare all attributes to figure out changes and that's might not be great
>> > > > idea.
>> > > 
>> > > Wait, are you saying that the app is stateless? Could you provide
>> > > example use cases?
>> > > 
>> > >From what I see, the app managing dpll knows the state of the device and
>> > > pins, it monitors for the changes and saves new state with appropriate
>> > > reaction (might be some action or maybe just log entry).
>> > > 
>> > 
>> > It depends on the use case, right? App developer having those information knows
>> > what has changed, thus can react in a way it thinks is most suitable.
>> > IMHO from user perspective it is good to have a notification which actually
>> > shows it's reason, so proper flow could be assigned to handle the reaction.
>> 
>> Again, could you provide me specific example in which this is needed?
>> I may be missing something, but I don't see how it can bring
>> and benefit. It just makes the live of the app harder because it has to
>> treat the get and notify messages differently.
>> 
>> It is quite common for app to:
>> init:
>> 1) get object state
>> 2) store it
>> 3) apply configuration
>> runtime:
>> 1) listen to object state change
>> 2) store it
>> 3) apply configuration
>> 
>> Same code for both.
>
>Well, I'm thinking about simple monitoring app which will wait for the events
>and create an alert if the changes coming from the event differ from the
>"allowed configs". In this case no real reason to store whole object state,
>but the changes in events are very useful.

No problem. But as I wrote elsewhere in this thread, make sure that msg
format of a change message is the same as the format of get cmd message.
Basically think of it as a get cmd message filtered to have only
attrs which changed. Same nesting and everything. Makes it simple for
the app to have same parsing code for get/dump/notification messages.

[...]
