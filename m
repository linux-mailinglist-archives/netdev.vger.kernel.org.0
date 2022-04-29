Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4FD515471
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 21:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356678AbiD2Tck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 15:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239127AbiD2Tcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 15:32:39 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CA5CE48A
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 12:29:19 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id y21so10165305edo.2
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 12:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pvmdp/S+rdpr1c+MSgo4re+izXIGye16zXKNCwl8b7I=;
        b=mwSugLlCbQlv2FvZNao2+TCZeAJn/cNrRgODx7bXnQ/7EqlTlrJDXg6fnkezSusCo8
         86mbRb1LeJofkeff+rz3DT4pcWzTAoIuyAcCqkA3g+eSVZfCRyzoIN6JkGX/RaItGLXR
         JzhvfU9v4D02isLW8b5RpUSqb75Ff6nNuuNRjJYZ25QbqYlCHsMU5bLcTfVhyLr5X2LJ
         DWlHz+mgZxnfKSJ4lbb52wWSCpdzstQHcinbixmONNlPcRq/rHn4CgW5Np4lJiAJv/sV
         lHNVXl8ProGxWNj7vmME60UGUt4n3yrDWCMDoay3aOJDEdYz7K8PQLLn330V3k3OIb7Y
         Gf+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pvmdp/S+rdpr1c+MSgo4re+izXIGye16zXKNCwl8b7I=;
        b=BajM1GrvhIKfI1VvtrbGP1EaGIBbEVa0AnklfBERw6Vv1YIRpLCRfllycWZa3NpGzX
         SiTykjPtG4AoI3JQmaGrgzagKR3i8JIceWBWLLF2LKcW6EYrNxkvnJCCsGDUfLXsgNTE
         3d7qWhoyS8mEoKhAONcv9es41T9DUd8BiY+1sypCexWjcOmgMqSpPMe0S858Iwe4GTf9
         A3zWnwg7LIMWADnxuywGVZ9hnm8d2E6VRhZ+pGE6CasXjM3tEfHNwP1WNoTsK5kONvNM
         LTdPUNdDj+savLqY/2qMV/eW1fOYDRekMr6vWXpX/vgk2TjgD9vyqMmGK5brm7HBYAMh
         i12Q==
X-Gm-Message-State: AOAM533cc0GJoYOYavYEypNeZuGr6cN1CdLZEGl+QfHxtrbWj03ph6JX
        ojIIjUehvE9RMBylixHE5eLNwA==
X-Google-Smtp-Source: ABdhPJxovVjqVMNH4qibtbLFDT52WhI0cJsl2JxFAkkoUCCopav4BXVSZKqGj+zlLqtgQ5OL9s79xg==
X-Received: by 2002:a05:6402:27d1:b0:426:29ee:c689 with SMTP id c17-20020a05640227d100b0042629eec689mr830340ede.290.1651260558126;
        Fri, 29 Apr 2022 12:29:18 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id e13-20020a170906844d00b006f3ef214dc3sm915208ejy.41.2022.04.29.12.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 12:29:17 -0700 (PDT)
Date:   Fri, 29 Apr 2022 21:29:16 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <Ymw8jBoK3Vx8A/uq@nanopsycho>
References: <Ymb5DQonnrnIBG3c@shredder>
 <20220425125218.7caa473f@kernel.org>
 <YmeXyzumj1oTSX+x@nanopsycho>
 <20220426054130.7d997821@kernel.org>
 <Ymf66h5dMNOLun8k@nanopsycho>
 <20220426075133.53562a2e@kernel.org>
 <YmjyRgYYRU/ZaF9X@nanopsycho>
 <20220427071447.69ec3e6f@kernel.org>
 <YmvRRSFeRqufKbO/@nanopsycho>
 <20220429114535.64794e94@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220429114535.64794e94@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Apr 29, 2022 at 08:45:35PM CEST, kuba@kernel.org wrote:
>On Fri, 29 Apr 2022 13:51:33 +0200 Jiri Pirko wrote:
>> >Of the three API levels (SDK, automation, human) I think automation
>> >is the only one that's interesting to us in Linux. SDK interfaces are
>> >necessarily too low level as they expose too much of internal details
>> >to standardize. Humans are good with dealing with uncertainty and
>> >diverse so there's no a good benchmark.
>> >
>> >The benchmark for automation is - can a machine use this API across
>> >different vendors to reliably achieve its goals. For FW info/flashing
>> >the goal is keeping the FW versions up to date. This is documented:
>> >
>> >https://www.kernel.org/doc/html/latest/networking/devlink/devlink-flash.html#firmware-version-management
>> >
>> >What would the pseudo code look like with "line cards" in the picture?
>> >Apply RFC1925 truth 12.  
>> 
>> Something like this:
>> 
>> $lc_count = array_size(devlink-lc-info[$handle])
>> 
>> for ($lcnum = 0; $lcnum < $lc_count; lcnum++):
>>     $dev_count = array_size(devlink-lc-info[$handle][$lcnum])
>> 
>>     for ($devnum = 0; $devnum < $dev_count; $devnum++):
>
>Here goes the iteration I complained about in my previous message.
>Tracking FW versions makes most sense at the level of a product (as 
>in the unit of HW one can purchase from the system vendor). That
>integrates well with system tracking HW in the fleet. Product in your
>case will be a line card or populated chassis, I believe.

Well, most probably, you are right. In theory, there migth de 2 types of
devices/gearboxes on a single line card. I admit I find it unlikely now.


>
>>         # Get unique HW design identifier (gearbox id)
>>         $hw_id = devlink-lc-info[$handle][$lcnum][$devnum]['fw.psid']
>
>1) you can't use 'fw.psid' in generic logic, it's a Melvidia's invention
>2) looking at your cover letter there's no fw.psid for the device
>   reported, the automation will not work, Q.E.D.

We can make is a "symlink" to fw.hw_id or whatever. But that is not the
point here. For ASIC FW, we currently have also fw.psid.


>
>>         # Find out which FW flash we want to use for this device
>>         $want_flash_vers = some-db-backed.lookup($hw_id, 'flash')
>> 
>>         # Update flash if necessary
>>         if $want_flash_vers != devlink-lc-info[$handle][$lcnum][$devnum]['fw']:
>>             $file = some-db-backed.download($hw_id, 'flash')
>>             $component = devlink-lc[$handle][$lcnum][$devnum]['component']
>>             devlink-dev-flash($handle, $component, $file)
>> 
>> devlink-reload()
>> 
>> Clear indexes, not squashed somewhere in middle of string.
>> 
>> >I thought you said your gearboxes all the the same FW? 
>> >Theoretically, yes. Theoretically, I can also have nested "line cards".  
>> 
>> Well, yeah. I was under impresion that possibility of having multiple
>> devices on the same LC is not close to 0. But I get your point.
>> 
>> Let's try to figure out he iface as you want it:
>> We will have devlink dev info extended to be able to provide info
>> about the LC/gearbox. Let's work with same prefix "lcX." for all
>> info related to line card X.
>> 
>> First problem is, who is going to enforce this prefix. It is driver's
>> responsibility to provide the string which is put out. The solution
>> would be to have a helper similar to devlink_info_version_*_put()
>> called devlink_info_lc_version_*_put() that would accept lc pointer and
>> add the prefix. Does it make sense to you?
>> 
>> We need 3 things:
>> 1) current version of gearbox FW 
>>    That is easy, we have it - "versions"
>>    (DEVLINK_ATTR_INFO_VERSION_* nested attrs). We can have multiple
>>    nests that would carry the versions for individiual line cards.
>>    Example:
>>        versions:
>>            fixed:
>>              hw.revision 0
>>              lc2.hw.revision a
>>              lc8.hw.revision b
>>            running:
>>              ini.version 4
>>              lc2.gearbox.fw.version 1.1.3
>>              lc8.gearbox.fw.version 1.2.3
>> 2) HW id (as you have it in your pseudocode), it is PSID in case of
>>    mlxsw. We already have PSID for ASIC:
>>    ....
>>    This should be also easy, as this is exposed as "fixed version" in a
>>    same way as previous example.
>>    Example:
>>        versions:
>>            fixed:
>>              lc2.gearbox.fw.psid XXX
>>              lc8.gearbox.fw.psid YYY
>> 3) Component name
>>    This one is a bit tricky. It is not a version, so put it under
>>    "versions" does not make much sense.
>>    Also, there are more than one. Looking at how versions are done,
>>    multiple nests of attr type DEVLINK_ATTR_INFO_VERSION_* are put to
>>    the message. So we can introduce new attr DEVLINK_ATTR_INFO_FLASH_COMPONENT
>>    and put one per linecard/gearbox.
>>    Here arain we need some kind of helper to driver to call to put this
>>    into msg: devlink_info_lc_flash_component_put()
>>    Example:
>>      pci/0000:01:00.0:
>>        driver mlxsw_spectrum3
>>        flash_components:
>>          lc2.gearbox.fw
>>          lc8.gearbox.fw
>> 
>>     Then the flashing of the gearbox will be done by:
>>     # devlink dev flash pci/0000:01:00.0 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2 component lc2.gearbox.fw
>
>The main question to me is whether users will want to flash the entire
>device, or update line cards individually.

I think it makes sense to update them individually. The versions are
also reported individually. What's the benefit of not doing that. Also,
how would you name the "group" component. Sounds odd to me.


>
>What's inside mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2? Doesn't
>sound like it's FW just for a single gearbox?
>
>> >Really? So we're going to be designing kernel APIs so that each message
>> >contains complete information and can't contain references now?  
>> 
>> Can you give me an exapmple of devlink or any other iproute2 app cmd
>> that actually does something similar to this?
>
>Off the top of my head - doesn't ip has some caches for name resolution
>etc.? Either way current code in iproute2.git is hardly written on the
>stone tablets.

Not sure, that is why I thought you might have an example. Anyway, I
don't think it is important. I think that all 3 values exposed I
described above can be just in devlink dev info.

