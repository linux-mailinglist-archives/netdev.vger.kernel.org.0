Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CC823D10C
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgHETzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728048AbgHEQqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 12:46:16 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CBBC061A13
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 04:03:01 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id k8so5908699wma.2
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 04:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vywA2wspQfpo/+2soJmF21VREcdXyi5ZnRQZUMSV7tA=;
        b=Ru8oOB0onYaJd4dRPmoeLEHLVVGRjqx5C4IoMZb0HqJdoDmXduW8/4B9rUnBZGhD8K
         zfRkoVZv2cXuTqIlnNhmvqWA2np6FcWGRig+L7ITcOSv3J45FO9/skC9G8j1xe1t12LB
         Dw7niNYMPCfLN8cNP9yfs3imZY5YaGjVUUkWmucTiqylveFJYXUxqBlmMGGHsE5FfUP9
         gwr38uStrRpITFhsTu761NUCjKyK6w+YRLVwAqzPu/tp77mKYOwxMdVNtFlWQX6wrUbu
         S4P4+jTh0C2maJvlZWMAYjJjkd+udl/gMkg0lQ90V+Gc53ctKfsXYeXhfD+6IcQMW4Vv
         oyCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vywA2wspQfpo/+2soJmF21VREcdXyi5ZnRQZUMSV7tA=;
        b=p43HVNmiW52rXr61/Agn+6QKrottj+OStwuy5no35Ff42tim8/vnWuoHVaa5tqBIOz
         7M/g62IqPOQ6OthSZd8PYl+bSBbqUE+ASfYB7AIRYP7LvqtSGnudUkRdfuXiC96KocYQ
         FhExxE8r03H35NxETbpICKMEjxSidrqPoSNZIdA4gF0+G9cFaSmeqp4LEC2QUXqo/5SL
         6N8ZdKp9xaRnDpTtM0Tz+uhI4CA5g7MuXLpHGLqAqwNKaINcYwg0WKb86f6b7zGt9N8Q
         MgnbZ/XoRa/nYVolJAdEijTe8rDWWZW/HXLE4GQ4GQqgCQQ26YzAPa5dKe63UZyKE1u3
         +47g==
X-Gm-Message-State: AOAM530gVLKk/7pHHhuGemJkNNsbtU4qdrhZw5dysFK0xjmdqOhBw+18
        X9JLFXlQDEkF7KFFe/2VH063yQ==
X-Google-Smtp-Source: ABdhPJzQKjkuR+MDx3lQMLXUCtgZ2s5ZKz50uJAR51nGFVSoXuuOAIozL5n3MTkEFf15k20m0J9qGA==
X-Received: by 2002:a7b:c7d5:: with SMTP id z21mr2906047wmk.145.1596625379899;
        Wed, 05 Aug 2020 04:02:59 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id d14sm2274189wre.44.2020.08.05.04.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 04:02:59 -0700 (PDT)
Date:   Wed, 5 Aug 2020 13:02:58 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
Message-ID: <20200805110258.GA2169@nanopsycho>
References: <20200728130653.7ce2f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <04f00024-758c-bc19-c187-49847c24a5a4@mellanox.com>
 <20200729140708.5f914c15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3352bd96-d10e-6961-079d-5c913a967513@mellanox.com>
 <20200730161101.48f42c5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <0f2467fd-ee2e-1a51-f9c1-02f8a579d542@mellanox.com>
 <20200803141442.GB2290@nanopsycho>
 <20200803135703.16967635@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200804100418.GA2210@nanopsycho>
 <20200804133946.7246514e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804133946.7246514e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 04, 2020 at 10:39:46PM CEST, kuba@kernel.org wrote:
>On Tue, 4 Aug 2020 12:04:18 +0200 Jiri Pirko wrote:
>> Mon, Aug 03, 2020 at 10:57:03PM CEST, kuba@kernel.org wrote:
>> >I was trying to avoid having to provide a Cartesian product of
>> >operation and system disruption level, if any other action can
>> >be done "live" at some point.
>> >
>> >But no strong feelings about that one.
>> >
>> >Really, as long as there is no driver-specific defaults (or as 
>> >little driver-specific anything as possible) and user actions 
>> >are clearly expressed (fw-reset does not necessarily imply
>> >fw-activation) - the API will be fine IMO.  
>> 
>> Clear actions, that is what I'm fine with.
>> 
>> But not sure how you think we can achieve no driver-specific defaults.
>> We have them already :/ I don't think we can easily remove them and not
>> break user expectations.
>
>AFAIU the per-driver default is needed because we went too low 
>level with what the action constitutes. We need maintain the higher
>level actions.
>
>The user clearly did not care if FW was reset during devlink reload
>before this set, so what has changed? The objective user has is to

Well for mlxsw, the user is used to this flow:
devlink dev flash - flash new fw
devlink dev reload - new fw is activated and reset and driver instances
are re-created.


>activate their config / FW / move to different net ns. 
>
>Reloading the driver or resetting FW is a low level detail which
>achieves different things for different implementations. So it's 
>not a suitable abstraction -> IOW we need the driver default.

I'm confused. So you think we need the driver default?


>
>
>The work flow for the user is:
>
>0. download fw to /lib/firmware
>1. devlink flash $dev $fw
>2. if live activation is enabled
>   yes - devlink reload $dev $live-activate
>   no - report machine has to be drained for reboot
>
>fw-reset can't be $live-activate, because as Jake said fw-reset does
>not activate the new image for Intel. So will we end up per-driver
>defaults in the kernel space, and user space maintaining a mapping from

Well, that is what what is Moshe's proposal. Per-driver kernel default..
I'm not sure what we are arguing about then :/


>a driver to what a "level" of reset implies.
>
>I hope this makes things crystal clear. Please explain what problems
>you're seeing and extensions you're expecting. A list of user scenarios
>you foresee would be v. useful.
