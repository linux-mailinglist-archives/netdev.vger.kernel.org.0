Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49309640A58
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 17:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbiLBQP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 11:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbiLBQP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 11:15:28 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E7BAD305
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 08:15:27 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id vp12so12646724ejc.8
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 08:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kaxyw0y6A96dV/JlLT84d98tXLfc2Ox7qoi5kR5vbqA=;
        b=HVEuKvGdJJwpqJIx6DmExSfkDyGnZlNyygIYTlta3lzPcId1r8utFVifV5qbv4i8ir
         9auwDIW5WWjtXB/so4pdurJQhtsBXVOA6EATAhXfmHzKISMkSy5NQb/Trl9ALTWCvNdC
         l7IOnYwM3hq5BUGgQqjUxMbW87/ih4evxmgSc50ExZwqnpeGpM57n/8T91sEokWFAJmD
         pEpqHMrfzRIBLEh1jhvTriObUggWd8x8haWYMq0YKqOy8BOEaWBgX0qKeeDqyzzj31ir
         XLNJIvRSEaDjjhkNUevN9J787IxYzImg2DjmeZ30Q1eiOhds3cWOY7VhOwKpaKjRDou8
         HxMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kaxyw0y6A96dV/JlLT84d98tXLfc2Ox7qoi5kR5vbqA=;
        b=BzsbBW+dkxz2AI56svsLk7KEQHLUtu1xbWOeP2RBs9IhFUuTe+NYMGug8oS3u+19pu
         3A/MJIaksqsFQuPCB41jDsIEqydlRehs4/S9fz+JJy1Fh8KnHBZH0qTbs59gvlOyO1d3
         ofnjwkX6cwczMtCA5uqVaa6RYyZFclNan9DIYmcaNtj2bpsUIV972fmzDC8OYTfvQ27U
         VtwnC2hhdWLTqx4DHNCrCuvVQDLOn56ifPo9x5vXILr0KmZECi/27UhDtUUF5+rvCmbm
         Uxwena8uStkC9FFYq3QFoWfTIMjt+0moecrxoLQlch7nnz1Pqmdp+8twqATwkQVRze94
         5paw==
X-Gm-Message-State: ANoB5pmuTAswhZbDraVRkwlgNG5ZdtuV1VOanFCD4qOsfP/9CXwJxi7j
        CKEI/Z3d40DRR7iCQSW1D2l7sg==
X-Google-Smtp-Source: AA0mqf6+H+O0fs0gpI1xdx4NW+EjICIlxrx+pqx+gxEZkmJGbe4CuPeoEg5jYfgWO+qF5znsRhaHCw==
X-Received: by 2002:a17:907:9116:b0:78a:16ad:8250 with SMTP id p22-20020a170907911600b0078a16ad8250mr49303168ejq.747.1669997725853;
        Fri, 02 Dec 2022 08:15:25 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f23-20020aa7d857000000b0045cf4f72b04sm3044464eds.94.2022.12.02.08.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 08:15:25 -0800 (PST)
Date:   Fri, 2 Dec 2022 17:15:23 +0100
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
Message-ID: <Y4okm5TrBj+JAJrV@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <20221129213724.10119-3-vfedorenko@novek.ru>
 <Y4eGxb2i7uwdkh1T@nanopsycho>
 <DM6PR11MB4657DE713E4E83E09DFCFA4B9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4nyBwNPjuJFB5Km@nanopsycho>
 <DM6PR11MB4657C8417DEB0B14EC35802E9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB4657C8417DEB0B14EC35802E9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 02, 2022 at 03:54:33PM CET, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Friday, December 2, 2022 1:40 PM
>>
>>Fri, Dec 02, 2022 at 12:27:35PM CET, arkadiusz.kubalewski@intel.com wrote:
>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>Sent: Wednesday, November 30, 2022 5:37 PM Tue, Nov 29, 2022 at
>>>>10:37:22PM CET, vfedorenko@novek.ru wrote:
>>>>>From: Vadim Fedorenko <vadfed@fb.com>
>>
>>[...]
>>
>>
>>>>>+static int
>>>>>+dpll_msg_add_pin_netifindex(struct sk_buff *msg, const struct
>>>>dpll_pin_attr *attr)
>>>>>+{
>>>>>+	unsigned int netifindex; // TODO: Should be u32?
>>>>>+
>>>>>+	if (dpll_pin_attr_netifindex_get(attr, &netifindex))
>>>>>+		return 0;
>>>>>+	if (nla_put_u32(msg, DPLLA_PIN_NETIFINDEX, netifindex))
>>>>
>>>>I was thinking about this. It is problematic. DPLL has no notion of
>>>>network namespaces. So if the driver passes ifindex, dpll/user has no
>>>>clue in which network namespace it is (ifindexes ovelay in multiple
>>>>namespaces).
>>>>
>>>>There is no easy/nice solution. For now, I would go without this and
>>>>only have linkage the opposite direction, from netdev to dpll.
>>>
>>>Well, makes sense to me.
>>>Although as I have checked `ip a` showed the same ifindex either if
>>>port was in the namespace or not.
>>
>>That is not the problem. The problem is, that you can have following two
>>netdevs with the same ifindex each in different netns.
>>1) netdev x: ifindex 8, netns ns1
>>2) netdev y: ifindex 8, netns ns2
>>
>
>OK, I now see your point what is the confusion.
>Thanks for explanation.
>But I am still not sure how to make it this way in Linux, if interface added to
>netns uses original netdev ifindex, and driver after reload receives new
>(previously unused ifindex) what would be the steps/commands to make it as you
>described? 

As I said, I don't see a way to have the ifindex exposed throught dpll
at all. I believe we should do it only the other way around. Assign
dpll_pin pointer to struct net_device and expose this over new attr
IFLA_DPLL_PIN over RT netlink.


>
>>>Isn't it better to let the user know ifindex, even if he has to iterate
>>>all the namespaces he has created?
>>
>>Definitelly not. As I showed above, one ifindex may refer to multiple
>>netdevice instances.
>>
>>
>>[...]
>>
>>
>>>>>+	DPLLA_NETIFINDEX,
>>>>
>>>>Duplicate, you have it under pin.
>>>
>>>The pin can have netifindex as pin signal source may originate there by
>>>Clock recovery mechanics.
>>>The dpll can have ifindex as it "owns" the dpll.
>>
>>DPLL is not owned by any netdevice. That does not make any sense.
>>Netdevice may be "child" of the same PCI device as the dpll instance.
>>But that's it.
>
>Sure, I won't insist on having it there, as I said, thought Maciej have seen
>a benefit with such traceability, unfortunately I cannot recall what was it.
>
>
>Thanks,
>Arkadiusz
> 
>>
>>
>>>Shall user know about it? probably nothing usefull for him, although
>>>didn't Maciej Machnikowski asked to have such traceability?
