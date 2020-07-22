Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552B92296A1
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgGVKvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgGVKvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 06:51:41 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE68C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 03:51:41 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id o8so1504176wmh.4
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 03:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zAkTxWtSLEOhX7D94sw/c0ZedEzd4K7rjZgkbwXY/bg=;
        b=VWcYeXKP2QgM4b7JZsOsq8XyJMZxsKq1qa5pGdTi2un+La18wpRklmOuXHd3UizokB
         mwU1H6kqhG//mXmzFBBv6rRuCjbaNRT7dohZrsgAIYeK3kOwXdFGwcu2KymIc6J9UMuB
         ON3FTbTdmA16pMjb7bckfF09+DBv8cXjJYgCuw4Z+QJiqX96CV2PHTmM0ygpmhI0XG0L
         34XXxhneqonCwq1/VX1J6SJh5ZeA956J9uvozGRWg5JUOMaxNXGCrWu/fJ38zscFb0pR
         4hm0OIfpyg4LMoekEVvJ4XUESuYS/emugVVc78UEHTsfW+IkQmgFWqzy+M6wyMrAVuQK
         M1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zAkTxWtSLEOhX7D94sw/c0ZedEzd4K7rjZgkbwXY/bg=;
        b=CojboFwIid5z12vg3fdvIIB/K6WDpKLSaibBr6dOlsDwBv3JY5BATZnrdHgOlsN3Pr
         NA8iaYbwJeBLfcWs6aFF3lSOZO6jfDs7KNqPSp5r0Kx/cTg9TGZ4zKoXzou/cEeIunh5
         ma6voc1MZzx2KD4lukGJz4Z+vTlX5kkkueAFLDnP2jotOv6lM/n3xfOgf+hDzyr+xS8J
         G0gBMgkj/ZwWbUvs9Na5BeFSnfLMSToHrzgJMwczxMrzXgIhF0LK08CkBMYEOd9DPO/o
         q04NF4z25HnInBDEjqVf1pwKDn5oKTITI8jOvwTtZoDINa15eSAC6FloW9lxJdA5Trba
         Oc7g==
X-Gm-Message-State: AOAM533U1j9XS/RVkEaDstxhQQBtqpl9kqb9SdbAtQyBdLwOmzb/qCM1
        ukmMbWsnJPTWVumh49buFErysA==
X-Google-Smtp-Source: ABdhPJwPlcb7pmpLXGZ8dQaqyFfXsbnLHyQXK7NRL0nFQ+zxgUkNikIForuRWj0MdSdkTwKqWjE9BQ==
X-Received: by 2002:a1c:2045:: with SMTP id g66mr7650257wmg.184.1595415100365;
        Wed, 22 Jul 2020 03:51:40 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id i67sm7031771wma.12.2020.07.22.03.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 03:51:39 -0700 (PDT)
Date:   Wed, 22 Jul 2020 12:51:39 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kubakici@wp.pl>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        Tom Herbert <tom@herbertland.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to flash
 update
Message-ID: <20200722105139.GA3154@nanopsycho>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
 <20200717183541.797878-7-jacob.e.keller@intel.com>
 <20200720100953.GB2235@nanopsycho>
 <20200720085159.57479106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200721135356.GB2205@nanopsycho>
 <20200721100406.67c17ce9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721100406.67c17ce9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 21, 2020 at 07:04:06PM CEST, kubakici@wp.pl wrote:
>On Tue, 21 Jul 2020 15:53:56 +0200 Jiri Pirko wrote:
>> Mon, Jul 20, 2020 at 05:51:59PM CEST, kubakici@wp.pl wrote:
>> >On Mon, 20 Jul 2020 12:09:53 +0200 Jiri Pirko wrote:  
>> >> This looks odd. You have a single image yet you somehow divide it
>> >> into "program" and "config" areas. We already have infra in place to
>> >> take care of this. See DEVLINK_ATTR_FLASH_UPDATE_COMPONENT.
>> >> You should have 2 components:
>> >> 1) "program"
>> >> 2) "config"
>> >> 
>> >> Then it is up to the user what he decides to flash.  
>> >
>> >99.9% of the time users want to flash "all". To achieve "don't flash
>> >config" with current infra users would have to flash each component   
>> 
>> Well you can have multiple component what would overlap:
>> 1) "program" + "config" (default)
>> 2) "program"
>> 3) "config"
>
>Say I have FW component and UNDI driver. Now I'll have 4 components?
>fw.prog, fw.config, undi.prog etc? Are those extra ones visible or just

Visible in which sense? We don't show components anywhere if I'm not
mistaken. They are currently very rarely used. Basically we just ported
it from ethtool without much thinking.


>"implied"? If they are visible what version does the config have?

Good question. we don't have per-component version so far. I think it
would be good to have it alonside with the listing.


>
>Also (3) - flashing config from one firmware version and program from
>another - makes a very limited amount of sense to me.
>
>> >one by one and then omit the one(s) which is config (guessing which 
>> >one that is based on the name).
>> >
>> >Wouldn't this be quite inconvenient?  
>> 
>> I see it as an extra knob that is actually somehow provides degradation
>> of components.
>
>Hm. We have the exact opposite view on the matter. To me components
>currently correspond to separate fw/hw entities, that's a very clear
>meaning. PHY firmware, management FW, UNDI. Now we would add a
>completely orthogonal meaning to the same API. 

I understand. My concern is, we would have a component with some
"subparts". Now it is some fuzzy vagely defined "config part",
in the future it might be something else. That is what I'm concerned
about. Components have clear api.

So perhaps we can introduce something like "component mask", which would
allow to flash only part of the component. That is basically what Jacob
has, I would just like to have it well defined.


>
>Why?
>
>In the name of "field reuse"?
>
>> >In case of MLX is PSID considered config?  
>> 
>> Nope.
>
