Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE7E6406F9
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 13:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbiLBMjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 07:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbiLBMjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 07:39:40 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DEFD4AC0
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 04:39:38 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id e13so6272351edj.7
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 04:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8jC7da2W+ukwOwEQYKKMGcqvppPDfTMpCFP/Jwhh/vM=;
        b=GHGxMCzfJMseZVfpWvl2V28HsXKKWJ5d7TyS9GxoG/+yyEYois2e0x/n9fxVpQWhzy
         VoQUo45+HYBUh5NYCn0lscProp+UyJLEEClGrVdEUI6Eg77fMyGVk+T/YyueqYZIsCr/
         ofhRf/ERvG3gYovGF2+x19GFUHgGqcgCW3Im0A4tfUDqYTQ8XmFc4j5IOdy8GMH05ukL
         HxURuO5SFuJRfFTkvK2b1eE6njo0XUz2lkYxeyYAxvKJRtrEFuetydHnFOJEN81QDsuR
         VATXulY4cPSio5xPRrOF+x8fBHteScBg2YnEZfoggQIYK9BU1iRRgYplvCPyHsmEAxwW
         sq8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8jC7da2W+ukwOwEQYKKMGcqvppPDfTMpCFP/Jwhh/vM=;
        b=OG0FYcLfrgB3dOW5CnSmTOHoDWAauKslwR2oppBq+/xgd2zv1SJFXgTAhBuZ3a9OQD
         SXIVYRevBnNo3Mc+z3p4jfeWTWlO3Fg+k68KgU1Q7NRzywrfXeB4luyen1FQEPYXfLEU
         vd/3AhvoUhtww1xuCiQTonovwy1I1ZAjLLQUPq30iMQU4vFrKj3V0SuwHofTPc7pnwIr
         juZHyPGtTdbQJmT1WSBxAYQMfM6phggBeqtICjgJIU4Kbx1JzvgNHsbt3j4uqZUUD6uk
         GocRxr5kvQEp6VtzO6a8Zzu6ysrs+71Cr3Re2t9QAfuhglyLwJJaZjWJkHDVFqZviFHy
         djMQ==
X-Gm-Message-State: ANoB5plW6MxzUvlP3uAT9Z7I+4od+s/rITAYmF5uyS6wKvJOCx2W8HkX
        28wEgEzBDGFL1qh+UjWG8YQApQ==
X-Google-Smtp-Source: AA0mqf6z+SAK9/8ueehDS8BhD7X+jXXxouu9P3VguQ4xI3VPnvJECeOsrYAUbmy/WuIFMqFQW0zEDA==
X-Received: by 2002:a50:ee19:0:b0:46b:51e6:2e69 with SMTP id g25-20020a50ee19000000b0046b51e62e69mr18990436eds.354.1669984776881;
        Fri, 02 Dec 2022 04:39:36 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ky1-20020a170907778100b0072a881b21d8sm2951052ejc.119.2022.12.02.04.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 04:39:36 -0800 (PST)
Date:   Fri, 2 Dec 2022 13:39:35 +0100
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
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [RFC PATCH v4 2/4] dpll: Add DPLL framework base functions
Message-ID: <Y4nyBwNPjuJFB5Km@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <20221129213724.10119-3-vfedorenko@novek.ru>
 <Y4eGxb2i7uwdkh1T@nanopsycho>
 <DM6PR11MB4657DE713E4E83E09DFCFA4B9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB4657DE713E4E83E09DFCFA4B9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 02, 2022 at 12:27:35PM CET, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Wednesday, November 30, 2022 5:37 PM
>>Tue, Nov 29, 2022 at 10:37:22PM CET, vfedorenko@novek.ru wrote:
>>>From: Vadim Fedorenko <vadfed@fb.com>

[...]


>>>+static int
>>>+dpll_msg_add_pin_netifindex(struct sk_buff *msg, const struct
>>dpll_pin_attr *attr)
>>>+{
>>>+	unsigned int netifindex; // TODO: Should be u32?
>>>+
>>>+	if (dpll_pin_attr_netifindex_get(attr, &netifindex))
>>>+		return 0;
>>>+	if (nla_put_u32(msg, DPLLA_PIN_NETIFINDEX, netifindex))
>>
>>I was thinking about this. It is problematic. DPLL has no notion of
>>network namespaces. So if the driver passes ifindex, dpll/user has no
>>clue in which network namespace it is (ifindexes ovelay in multiple
>>namespaces).
>>
>>There is no easy/nice solution. For now, I would go without this and
>>only have linkage the opposite direction, from netdev to dpll.
>
>Well, makes sense to me.
>Although as I have checked `ip a` showed the same ifindex either if port was
>in the namespace or not.

That is not the problem. The problem is, that you can have following
two netdevs with the same ifindex each in different netns.
1) netdev x: ifindex 8, netns ns1
2) netdev y: ifindex 8, netns ns2

>Isn't it better to let the user know ifindex, even if he has to iterate all
>the namespaces he has created?

Definitelly not. As I showed above, one ifindex may refer to multiple
netdevice instances.


[...]


>>>+	DPLLA_NETIFINDEX,
>>
>>Duplicate, you have it under pin.
>
>The pin can have netifindex as pin signal source may originate there by
>Clock recovery mechanics.
>The dpll can have ifindex as it "owns" the dpll.

DPLL is not owned by any netdevice. That does not make any sense.
Netdevice may be "child" of the same PCI device as the dpll instance.
But that's it.


>Shall user know about it? probably nothing usefull for him, although
>didn't Maciej Machnikowski asked to have such traceability?
