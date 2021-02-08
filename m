Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A34531315F
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 12:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbhBHLuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 06:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbhBHLp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 06:45:56 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7475CC06174A;
        Mon,  8 Feb 2021 03:45:15 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id df22so17720222edb.1;
        Mon, 08 Feb 2021 03:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9pa9egMr6HuhpySJFZ922xtVve+4BTGS+NR78QDKpmA=;
        b=seQRViNZMkrvWnMY2i5wu0KjU3Wfsa+YhEAmbH7bVQjptTdGrXj0iOCqBY5XKau/lF
         Fs6TSVcEXddjrKILQYYbay7a9toHDoY9DBU+TLWLtsuVkuCdg6JViiburY0hin1OAEmU
         1MiOtEiCM2VWB7DT+mIUqRAoLLJXtDyBXAZr3ZXgzYTn3iIX4yDV/W1YfaNuawtMsEbT
         vpTQmnP6PafDQm+rcOeJ9sR870pMYmcrCx/NjxVJcXADl1+xXNjxX753OYJfdC1vXYrd
         C8u4HzVz7JmTKuyDdNNPjy1XV8pOqXmXrfRz/Tq/CIpYvkwIDGo1ASNYEtjLBc32+u5K
         Kw+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9pa9egMr6HuhpySJFZ922xtVve+4BTGS+NR78QDKpmA=;
        b=NayejDsT3xqhn2bfcYzYIutaye25IsCVA4+L6UvRW+SXzduGilTqqMsFH87I1BXwgJ
         3BqZ4Sxt4puQWvlPP+xISoAy/70lYM2VV/XzG38XVQTlGqZWPlCkEq9oSz5+XV1AjxhK
         baZ7DyZH1OZ7Q+gBiafeVMkAxoyWutHCSJrugBwaOt5SP74M0NIhw50xr6qTw/IOcUcu
         EuzrY5rjAs/UYz+G75jAzDM5TCN1QWaKu3nw6CV81zAJ44PJSd64UuyzvnWzEGSm7Iut
         l9BsoDB3yjghzqoRfslRuIzBAiK02zrqeA1BYj9aFkU1Rj/fmYOn2HncZjvXclDu5psJ
         OzbA==
X-Gm-Message-State: AOAM532kb6rj4LqSWTDpXu/pcOgTqSHbqmmrxCKK32xw3Uk6ztxA4CEl
        edK76yfXdJsL52qXbGMIEzc=
X-Google-Smtp-Source: ABdhPJx6eGBesZL3QRG6VDx3qwW880GGzzgdxNQvaQ8IPb48/VTGhgJQZMuC4y1f5IqUAo/uMr0ZAw==
X-Received: by 2002:a05:6402:149a:: with SMTP id e26mr17017083edv.254.1612784714113;
        Mon, 08 Feb 2021 03:45:14 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id b3sm9426102edw.14.2021.02.08.03.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 03:45:13 -0800 (PST)
Date:   Mon, 8 Feb 2021 13:45:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH net-next 2/9] net: bridge: offload initial and final port
 flags through switchdev
Message-ID: <20210208114511.xtzma5byrdnr5s7r@skbuf>
References: <20210207232141.2142678-1-olteanv@gmail.com>
 <20210207232141.2142678-3-olteanv@gmail.com>
 <95dede91-56aa-1852-8fbf-71d446fa7ede@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95dede91-56aa-1852-8fbf-71d446fa7ede@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 01:37:03PM +0200, Nikolay Aleksandrov wrote:
> Hi Vladimir,
> I think this patch potentially breaks some use cases. There are a few problems, I'll
> start with the more serious one: before the ports would have a set of flags that were
> always set when joining, now due to how nbp_flags_change() handles flag setting some might
> not be set which would immediately change behaviour w.r.t software fwding. I'll use your
> example of BR_BCAST_FLOOD: a lot of drivers will return an error for it and any broadcast
> towards these ports will be dropped, we have mixed environments with software ports that
> sometimes have traffic (e.g. decapped ARP requests) software forwarded which will stop working.

Yes, you're right. The only solution I can think of is to add a "bool ignore_errors"
to nbp_flags_change, set to true from new_nbp and del_nbp, and to false from the
netlink code.

> The other lesser issue is with the style below, I mean these three calls for each flag are
> just ugly and look weird as you've also noted, since these APIs are internal can we do better?

Doing better would mean allowing nbp_flags_change() to have a bit mask with
potentially more brport flags set, and to call br_switchdev_set_port_flag in
a for_each_set_bit() loop?
