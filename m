Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5109522DCE7
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 09:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgGZHSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 03:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgGZHSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 03:18:37 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D46DC0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 00:18:36 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id r2so6743922wrs.8
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 00:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UuGCzb23a9vNaZgj9bZ+1wVQLH60bFkunWT09OfCsq4=;
        b=eTbKLuVk6Lx1BJEs1ra/6YS8oIn6DnFXWWytHyE1NVBvPDAggc4C0BCUkXyVWevPCE
         zalv/GeN+C4h0LCG7YD1cn4hXUyk9LgpT2fXKdtPgQ7fRi0aOz8vsKnUm32fyQu3VcEC
         RZD6KdSyNBqzNejU682kM4XJBXnutzHjHetxrijY/hvsACxkIoWQjSSADvTkfHNoHmIs
         IeTmKKS+V5CpiMe+sZWrNVDanszk8Gxz1NnvZUlR7i1JdlHyYVirrtPsxzFbIGL1QKdz
         KU97Btl+nIm4m5eTip7dJFuPiYuxxzJTapEIBHcWA5gd1mp190XJF1QMmQdgZ1zJT5nM
         sEvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UuGCzb23a9vNaZgj9bZ+1wVQLH60bFkunWT09OfCsq4=;
        b=btjZ2iY7jvP0oEJAxTOFLL/Avjkq7PmrYpHSXDAk7tEOvZJC+G2heO/SiQuQ1Wy0St
         X10klM1pOMU73PXV+kg2wCCWcadBXX3aC5Nf1yaS1v1b48MgcMlQvrHBT8zvSNDjEs85
         aBnFBrfxuMaiGR0mV9IWwmWObY4ypbAnxYSz1YiRapsdW2P7/fiKPE0vTAIKD1FzG3LJ
         9vCZGEH0GMK6u/6cGvjtGKjdB5AVf7CTwDS5tqM7U9JbTT1gfJl93/YyMpoj2S+xGKFA
         FUHIHTL9XuFcm1nqA6JLWLRntjV17GP5hWfEhGq3MH3b5AdMabtkXXf5jgEiChrDYPg1
         FAdA==
X-Gm-Message-State: AOAM533MJeTUgZA5ABycbDF9SqM6OJJekxzOt7j5BlI3GsJzwWwXG+af
        Kim6S8ShKrCnGpRB3yEtmkDtkQ==
X-Google-Smtp-Source: ABdhPJz8HbdEVORUaFBJWlyBrOy/4TIc9xQaV5iinQbtfEgnXsLxsfq+7BzcY7gcClSCfyRdbmNHzA==
X-Received: by 2002:adf:f812:: with SMTP id s18mr6009601wrp.96.1595747915383;
        Sun, 26 Jul 2020 00:18:35 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id c10sm7849567wro.84.2020.07.26.00.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2020 00:18:35 -0700 (PDT)
Date:   Sun, 26 Jul 2020 09:18:34 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to flash
 update
Message-ID: <20200726071834.GC2216@nanopsycho>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
 <20200717183541.797878-7-jacob.e.keller@intel.com>
 <20200720100953.GB2235@nanopsycho>
 <20200720085159.57479106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200721135356.GB2205@nanopsycho>
 <20200721100406.67c17ce9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200722105139.GA3154@nanopsycho>
 <02874ECE860811409154E81DA85FBB58C8AF3382@fmsmsx101.amr.corp.intel.com>
 <20200722095228.2f2c61b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7d3a4dfb-ca4d-039a-9fad-2dcb5dbd9600@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d3a4dfb-ca4d-039a-9fad-2dcb5dbd9600@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 22, 2020 at 08:21:22PM CEST, jacob.e.keller@intel.com wrote:
>
>
>On 7/22/2020 9:52 AM, Jakub Kicinski wrote:
>> On Wed, 22 Jul 2020 15:30:05 +0000 Keller, Jacob E wrote:
>>>> So perhaps we can introduce something like "component mask", which would
>>>> allow to flash only part of the component. That is basically what Jacob
>>>> has, I would just like to have it well defined.
>>>
>>> So, we could make this selection a series of masked bits instead of a
>>> single enumeration value.
>> 
>> I'd still argue that components (as defined in devlink info) and config
>> are pretty orthogonal. In my experience config is stored in its own
>> section of the flash, and some of the knobs are in no obvious way
>> associated with components (used by components).
>> 
>> That said, if we rename the "component mask" to "update mask" that's
>> fine with me.
>> 
>> Then we'd have
>> 
>> bit 0 - don't overwrite config
>> bit 1 - don't overwrite identifiers
>> 
>> ? 
>> 
>> Let's define a bit for "don't update program" when we actually need it.
>> 
>
>
>Ok. And this can be later extended with additional bits with new
>meanings should the need arise.
>
>Additionally, drivers can ensure that the valid combination of bits is
>set. the drivers can reject requests for combinations that they do not
>support.

Makes sense.

>
>I can make that change.
>
>My preference is that "0" for a bit means do not overwrite while "1"
>means overwrite. This way, if/when additional bits are added, drivers
>won't need to be updated to reject such requests. If we make "1" the "do
>not overwrite" then we'd have a case where drivers must update to ensure
>they reject requests which don't set the bit.

0 should be default and driver should bahave accordingly.


>
>Thanks,
>Jake
