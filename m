Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5E42FFDD4
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 09:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbhAVICA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 03:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbhAVIB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 03:01:57 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32E9C06174A
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 00:01:16 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id m1so3472366wrq.12
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 00:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bpv+WmVQJaoNtH+Kk603V91O6Ja4QraYiRi6hd9mqmc=;
        b=Hb0NiMSWBtIhE4dZhl0VPHKUb/G7kUC0o/xR4zq6UOxICGcJWogfhCwwRpyeMNiGUF
         SwxAoyWb5DpJAsxFbm/rbpO2gtnkiwVFGsym2F8qrsvxJoPkT0GMkxDKjnxDb4HEIdSN
         YwIkCpmjqaVQN9BN8Em4l10QIWZIUYTB0Q8SV18wkGKx6o4/EqRc4fWae4BMX1lwpZrn
         IllFXdhlTmVKBxhmi2IkXS+hzB0pTWmF31UTs6X0raUve0JfQDUBMsAW0ui65aUYphyt
         /FALtVxn8hRzrH+Yg0TNEJ2pwSKHO9VwS7UDFof622i0fKoJ3vPBtO/WN1xxTi3h0lRs
         vR1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bpv+WmVQJaoNtH+Kk603V91O6Ja4QraYiRi6hd9mqmc=;
        b=uPkN2EHBr8Mxu7igtN3JLh32GQ2njzRtX2c0GMpWCSnyzPAO0YRao8gpdWPVeM6PfL
         ilEJOuNTOBRAEkvVvVHkqmfdR9wuiatBYhRNh3YDxpCs/BLasT686faIe8PbbgLCSP5r
         surg5qFB7uu50WUbeVl8IbtmufGOG6bpkciSDlKssbkE4bEsE0+X0qK0NT5QY1Vpqzsk
         5U9Z8BmTWdKJlEdWv7Qm1dtI/RsgvnukHRGLUIXr9l3VYBRX3vXSetp0Ms7g/YXEvMku
         U45cVgKycs7rhX1X8va7hSQRsKe3blVWs1xEqCZNmofbb7uvmHFrTkaYZq74zQqPsmIh
         B3Tg==
X-Gm-Message-State: AOAM531KmL2WzkkC30+tEBzyA1O5Xzeh2+Zu6X6QN16jR4sUoFKS92q5
        wtkxOGfhK22z6Sh/XXEheYwR5A==
X-Google-Smtp-Source: ABdhPJyfvysuSR6Xy0cBoYrLKouYPHRE6HNLw7ow+7RKQlFr92iuEy7/5R+ELa3QgInR5GopZBxZsA==
X-Received: by 2002:adf:bbc1:: with SMTP id z1mr3137218wrg.95.1611302475535;
        Fri, 22 Jan 2021 00:01:15 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id n12sm12270608wrg.76.2021.01.22.00.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 00:01:14 -0800 (PST)
Date:   Fri, 22 Jan 2021 09:01:13 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jacob.e.keller@intel.com, roopa@nvidia.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210122080113.GH3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210113182716.2b2aa8fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210114074804.GK3565223@nanopsycho.orion>
 <20210114153013.2ce357b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210115143906.GM3565223@nanopsycho.orion>
 <20210115112617.064deda8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210118130009.GU3565223@nanopsycho.orion>
 <2d9674de-9710-3172-3ff7-073634ad1068@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d9674de-9710-3172-3ff7-073634ad1068@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jan 18, 2021 at 11:55:45PM CET, dsahern@gmail.com wrote:
>On 1/18/21 6:00 AM, Jiri Pirko wrote:
>> 
>>> Reconfiguring routing is not the end of the world.
>> Well, yes, but you don't really want netdevices to come and go then you
>> plug in/out cables/modules. That's why we have split implemented as we
>
>And you don't want a routing daemon to use netdevices which are not
>valid due to non-existence. Best case with what you want is carrier down
>on the LC's netdevices and that destroys routing.

There are other things. The user may configure the netdev parameters in
advance, like mtu, put it in a bridge, setup TC filters on it etc.
The linecard unplug/plug does not destroy the settings. This is the same
thing with split ports and that is why we have implemented split ports
in "provision" mode as well.


>
>> do. I don't understand why do you think linecards are different.
>
>I still don't get why you expect linecards to be different than any
>other hotplug device.

It it not a device, does not have "struct device" related to it.
It is just a phy part of another device.
