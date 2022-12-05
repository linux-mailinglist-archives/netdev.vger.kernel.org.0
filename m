Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763EA6426B7
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 11:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiLEKcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 05:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiLEKcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 05:32:09 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A8FBE38
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 02:32:07 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id v8so15137828edi.3
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 02:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5fpoZJPaIxa+iAwbcp/aUZH0HPeDz4PPni1VjWgLtZs=;
        b=tG60iLLOTJzz/wdBJOABaJkp41N7vWZuGWo3OfpG0y4mIn7iLlr5LFlGFQ4LRWN9de
         fDT6GRKZ4OX820ZQpxodCU4W02sEr/McVZbEDygubp1Ui5LNvYQTkGeNdzlpDYNu0maG
         Fk7M4xL8VDo29lS8R8rFx54ErIwc+FUFW8zzxaTWdtoXrKYXWi4kpKbJpezqJtc+dgK6
         nJys8tdoOw/0x8XvDw+VRnMtOE/yHDAesRrniTEMims89aIfmN6G1iDUBfylhlFn/9Pu
         fItBBy4HYjnpo2aFww0sDxbgDL5vWXHHEspLoq0vKky7e7PJo1RR0tBqyjtc9tl398Hm
         F84g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5fpoZJPaIxa+iAwbcp/aUZH0HPeDz4PPni1VjWgLtZs=;
        b=qXWu5b+xondiBCdX1k7xPhvD4I4rWxuNs2W3Ibj1XM68d4ZnHmNrJRf2XNMZsq/A/P
         TWTJFQej0C3WqIgSc2140AByu4fIhAxET1DR6H1AjLXpvjkg2QaVmMyWR19KajGnXWVd
         dL48nIlE0jkGswzCLvdIvFWWi281b2Y2G235ZdnPCOmbmcJ1aEFR6OSnTY8qvpOmF1+2
         0+EIfrILWi96oUpmcBh1fp+4xlQBfAN64zzJcGktMakc+GhonjC45VkEwmBoVsIp2wVv
         b7DvBCvO0p6aIUsVWejkNOFQpHRNvMocr+tbdJM5/rHzPqKiDiSrhYX4PPBQp7ge/gyX
         W/UA==
X-Gm-Message-State: ANoB5pkoywU4gLgfoSPzTPIGj+VOxq+hytzf2gzROXj12pJ2mB+Ik+5w
        0ooKQRbE9mfLI9topQZn2SYDLw==
X-Google-Smtp-Source: AA0mqf6uqbOB5OxqzEMjwdQ0h5HDWCr4Cs7UQe0Ido3SB9WNJ7dIV7UGBAws/2Jm7WwGS9+B1EuQZA==
X-Received: by 2002:aa7:c502:0:b0:46c:6bdc:40fd with SMTP id o2-20020aa7c502000000b0046c6bdc40fdmr7258470edq.74.1670236325970;
        Mon, 05 Dec 2022 02:32:05 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id l2-20020a056402124200b004615f7495e0sm6109204edw.8.2022.12.05.02.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 02:32:05 -0800 (PST)
Date:   Mon, 5 Dec 2022 11:32:04 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vadim Fedorenko <vadfed@fb.com>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [RFC PATCH v4 2/4] dpll: Add DPLL framework base functions
Message-ID: <Y43IpIQ3C0vGzHQW@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <20221129213724.10119-3-vfedorenko@novek.ru>
 <Y4eGxb2i7uwdkh1T@nanopsycho>
 <DM6PR11MB4657DE713E4E83E09DFCFA4B9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4nyBwNPjuJFB5Km@nanopsycho>
 <DM6PR11MB4657C8417DEB0B14EC35802E9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4okm5TrBj+JAJrV@nanopsycho>
 <20221202212206.3619bd5f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202212206.3619bd5f@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Dec 03, 2022 at 06:22:06AM CET, kuba@kernel.org wrote:
>On Fri, 2 Dec 2022 17:15:23 +0100 Jiri Pirko wrote:
>> >OK, I now see your point what is the confusion.
>> >Thanks for explanation.
>> >But I am still not sure how to make it this way in Linux, if interface added to
>> >netns uses original netdev ifindex, and driver after reload receives new
>> >(previously unused ifindex) what would be the steps/commands to make it as you
>> >described?
>>
>> As I said, I don't see a way to have the ifindex exposed throught dpll
>> at all.
>
>We can quite easily only report ifindexes in the same namespace
>as the socket, right?

Sure, hmm, thinkign about it more, this would be probably a good start.


>
>> I believe we should do it only the other way around. Assign
>> dpll_pin pointer to struct net_device and expose this over new attr
>> IFLA_DPLL_PIN over RT netlink.
>
>The ID table is global, what's the relationship between DPLLs
>and net namespaces? We tie DPLLs to a devlink instance which
>has a namespace? We pretend namespaces don't exist? :S

Well, if would be odd to put dpll itself into a namespace. It might not
have anything to do with networking, for example in case of ptp_ocp.
What would mean for a dpll to be in a net namespace?
