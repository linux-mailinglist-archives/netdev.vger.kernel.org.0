Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269B7514892
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 13:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358729AbiD2Ly6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 07:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358737AbiD2Ly5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 07:54:57 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38038C6F12
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 04:51:37 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id i5so10429498wrc.13
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 04:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I2haHTMbUX8+YFDbq2xMC5mP1C3/hhfbqacX+dzMDFo=;
        b=IJKkc07QuOGNpIXJvAlsIVV5+tlfRNQ+/j6OZj0yspxgcIASvshneTJ8u0CPSprXAE
         RFhGJSbtwQ7sQ4Jge7fVUZOMD/4W5Lkxy98somIl6UdX12jbv7XE00iJwJUW4AO5a+VY
         e7SHS/DQWbTS1oo7O7UosC+ElD4YP8aKOKqhZcastftLBs0TKJE+i9BHp0Aw5UJQlSRN
         AMNkCTsxf9PS1VR0DG5YqWvz02G9s0e5MpuqgfLqQEuPdEexcKPqftVgEf2kombbdWPN
         Lk3Vc/KOe94ZYtuppM8VAF0HF1gQzCkEUuLKNy3FW2bGTAI4jFkxyp42hXjIHnhdh+xm
         j/kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I2haHTMbUX8+YFDbq2xMC5mP1C3/hhfbqacX+dzMDFo=;
        b=4QuMvtEi7Pps6nnD4EsgOmQBK6tJCewDUcrFC8VZ3wsqgAN9EWAStqN3rChl5ENUiX
         VkaqweNG3fpEkM4tpcfMZpOk2uCtU9iVTYDhAKzu46XapRiYq+MO/oQweFICCZFiaDwH
         Esr4gMKIq1PMCBlSaP1/ZaXRqLe9wQQfXTI4kTV405fmFFAAuaV/ThVQidRA5QKvIqa1
         g8L8aNVNG51t9UPn6xMWx4SbQcPiT+GDl93aDOGaQtptWIA1BGuXPVo7dLmqRmphWmCp
         ybEDAVMYMkcDETsaPjyXBb86VDcw+o8yzJ9C5TKItjM2FbenjBCD1urL+pj1W3MLrzEp
         3eTA==
X-Gm-Message-State: AOAM531zzDpos06OvshnXL+euPs9z4GGdHiDQxizEfx1zNwb5sCsPD7Y
        +GbtHBHb4v1v0P1dyHVNaCKswQ==
X-Google-Smtp-Source: ABdhPJzkEYlhDkxLrxGg4MU6KVG4WPuPdKewY2UcOLjYkvPmHAQcqfznb20k1L4p0omm+zh+I1C0EQ==
X-Received: by 2002:adf:fb82:0:b0:207:8b12:8d15 with SMTP id a2-20020adffb82000000b002078b128d15mr29966745wrr.1.1651233095585;
        Fri, 29 Apr 2022 04:51:35 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o11-20020a05600c4fcb00b00391447f7fd4sm2870102wmq.24.2022.04.29.04.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 04:51:34 -0700 (PDT)
Date:   Fri, 29 Apr 2022 13:51:33 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YmvRRSFeRqufKbO/@nanopsycho>
References: <20220425034431.3161260-1-idosch@nvidia.com>
 <20220425090021.32e9a98f@kernel.org>
 <Ymb5DQonnrnIBG3c@shredder>
 <20220425125218.7caa473f@kernel.org>
 <YmeXyzumj1oTSX+x@nanopsycho>
 <20220426054130.7d997821@kernel.org>
 <Ymf66h5dMNOLun8k@nanopsycho>
 <20220426075133.53562a2e@kernel.org>
 <YmjyRgYYRU/ZaF9X@nanopsycho>
 <20220427071447.69ec3e6f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427071447.69ec3e6f@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Apr 27, 2022 at 04:14:47PM CEST, kuba@kernel.org wrote:
>On Wed, 27 Apr 2022 09:35:34 +0200 Jiri Pirko wrote:
>> >> The relationship-by-name sounds a bit fragile to me. The names of
>> >> components are up to the individual drivers.  
>> >
>> >I asked you how the automation will operate. You must answer questions
>> >if you want to have a discussion. Automation is the relevant part.  
>> 
>> Automation, not sure. It would probably just see type of gearbox and
>> flash it. Not sure I understand the question, perhaps you could explain?
>> Plus, the possibility is to auto-flash the GB from driver directly.
>> 
>> 
>> >You're not designing an interface for SDK users but for end users.  
>> 
>> Sure, that is the aim of this API. Human end user. That is why I wanted
>> the user to see the relationships between devlink dev, line cards and
>> the gearboxes on them. If you want to limit the visibility, sure, just
>> tell me how.
>
>Okay, we have completely different views on what the goals should be.
>Perhaps that explains the differences in the design.

I don't think so. I'm just a bit confused that you say "You're not designing
an interface for SDK users but for *end users*" and now you say that
primary is automation. Nevertheless, both are equally important and the
iface should work for both or them, I believe.


>
>Of the three API levels (SDK, automation, human) I think automation
>is the only one that's interesting to us in Linux. SDK interfaces are
>necessarily too low level as they expose too much of internal details
>to standardize. Humans are good with dealing with uncertainty and
>diverse so there's no a good benchmark.
>
>The benchmark for automation is - can a machine use this API across
>different vendors to reliably achieve its goals. For FW info/flashing
>the goal is keeping the FW versions up to date. This is documented:
>
>https://www.kernel.org/doc/html/latest/networking/devlink/devlink-flash.html#firmware-version-management
>
>What would the pseudo code look like with "line cards" in the picture?
>Apply RFC1925 truth 12.

Something like this:

$lc_count = array_size(devlink-lc-info[$handle])

for ($lcnum = 0; $lcnum < $lc_count; lcnum++):
    $dev_count = array_size(devlink-lc-info[$handle][$lcnum])

    for ($devnum = 0; $devnum < $dev_count; $devnum++):
    
        # Get unique HW design identifier (gearbox id)
        $hw_id = devlink-lc-info[$handle][$lcnum][$devnum]['fw.psid']

        # Find out which FW flash we want to use for this device
        $want_flash_vers = some-db-backed.lookup($hw_id, 'flash')

        # Update flash if necessary
        if $want_flash_vers != devlink-lc-info[$handle][$lcnum][$devnum]['fw']:
            $file = some-db-backed.download($hw_id, 'flash')
            $component = devlink-lc[$handle][$lcnum][$devnum]['component']
            devlink-dev-flash($handle, $component, $file)

devlink-reload()

Clear indexes, not squashed somewhere in middle of string.


>
>> >> There is no new command for that, only one nested attribute which
>> >> carries the device list added to the existing command. They are no new
>> >> objects, they are just few nested values.  
>> >
>> >DEVLINK_CMD_LINECARD_INFO_GET  
>> 
>> Okay, that is not only to expose devices. That is also to expose info
>> about linecards, like HW revision, INI version etc. Where else to put
>> it? I can perhaps embed it into devlink dev info, but I thought separate
>> command would be more suitable. object cmd, object info cmd. It is
>> more clear I believe.
>
>> >> If so, how does the user know if/when to flash it?
>> >> If not, where would you list it if devices nest is not the correct place?  
>> >
>> >Let me mock up what I had in mind for you since it did not come thru 
>> >in the explanation:
>> >
>> >$ devlink dev info show pci/0000:01:00.0
>> >    versions:
>> >        fixed:
>> >          hw.revision 0
>> >          lc2.hw.revision a
>> >          lc8.hw.revision b
>> >        running:
>> >          ini.version 4
>> >          lc2.gearbox 1.1.3
>> >          lc8.gearbox 1.2.3  
>> 
>> Would be rather:
>> 
>>           lc2.gearbox0 1.1.3
>>           lc2.gearbox1 1.2.4
>
>I thought you said your gearboxes all the the same FW? 
>Theoretically, yes. Theoretically, I can also have nested "line cards".

Well, yeah. I was under impresion that possibility of having multiple
devices on the same LC is not close to 0. But I get your point.

Let's try to figure out he iface as you want it:
We will have devlink dev info extended to be able to provide info
about the LC/gearbox. Let's work with same prefix "lcX." for all
info related to line card X.

First problem is, who is going to enforce this prefix. It is driver's
responsibility to provide the string which is put out. The solution
would be to have a helper similar to devlink_info_version_*_put()
called devlink_info_lc_version_*_put() that would accept lc pointer and
add the prefix. Does it make sense to you?

We need 3 things:
1) current version of gearbox FW 
   That is easy, we have it - "versions"
   (DEVLINK_ATTR_INFO_VERSION_* nested attrs). We can have multiple
   nests that would carry the versions for individiual line cards.
   Example:
       versions:
           fixed:
             hw.revision 0
             lc2.hw.revision a
             lc8.hw.revision b
           running:
             ini.version 4
             lc2.gearbox.fw.version 1.1.3
             lc8.gearbox.fw.version 1.2.3
2) HW id (as you have it in your pseudocode), it is PSID in case of
   mlxsw. We already have PSID for ASIC:
   ....
   This should be also easy, as this is exposed as "fixed version" in a
   same way as previous example.
   Example:
       versions:
           fixed:
             lc2.gearbox.fw.psid XXX
             lc8.gearbox.fw.psid YYY
3) Component name
   This one is a bit tricky. It is not a version, so put it under
   "versions" does not make much sense.
   Also, there are more than one. Looking at how versions are done,
   multiple nests of attr type DEVLINK_ATTR_INFO_VERSION_* are put to
   the message. So we can introduce new attr DEVLINK_ATTR_INFO_FLASH_COMPONENT
   and put one per linecard/gearbox.
   Here arain we need some kind of helper to driver to call to put this
   into msg: devlink_info_lc_flash_component_put()
   Example:
     pci/0000:01:00.0:
       driver mlxsw_spectrum3
       flash_components:
         lc2.gearbox.fw
         lc8.gearbox.fw

    Then the flashing of the gearbox will be done by:
    # devlink dev flash pci/0000:01:00.0 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2 component lc2.gearbox.fw

    Maybe this would call for some sort of API between driver and devlink to
    register individial components. devlink.c can then sanitize the
    input value of the component according to the registered list.

    Even withot that I think this would be valuable anyway to let the
    user know what are the supported component names.

What do you think? If you agree, I can jump into implementing this and
you can feel free to revert this patchset.



>
>>           lc8.gearbox0 1.2.3
>> 
>> Okay, I see. So instead of having clear api with relationships and
>> clear human+machine readability we have squahed indexes into strings.
>> I fail to see the benefit, other than no-api-extension :/ On contrary.
>
>Show me the real life use for all the "clear api with relationships"
>and I'll shut up.

See the pseudo-code above.


>
>I would not take falling back to physical (HW) hierarchy for the API
>design as a point of pride. Seems lazy if I'm completely honest.

I got that. I spent a lot of time to find a good abstraction though.


>Someone else's HW may have a different hierarchy, and you're just
>forcing the automation engineer iterate over irrelevant structures
>("devices").

Well, "linecard device" could be anything on th LC, from gearbox to
whatever. It should fit. But I get your point.


>
>My hunch is that automation will not want to deal with line cards
>separately, and flash the entire devices in one go to a tested and
>verified bundle blob provided by the vendor. If they do want to poke 
>at line cards - the information is still there in what I described.
>
>> >$ devlink lc show pci/0000:01:00.0 lc 8
>> >pci/0000:01:00.0:
>> >  lc 8 state active type 16x100G
>> >    supported_types:
>> >      16x100G
>> >    versions: 
>> >      lc8.hw.revision (a) 
>> >      lc8.gearbox (1.2.3)
>> >
>> >Where the data in the brackets is optionally fetched thru the existing
>> >"dev info" API, but rendered together by the user space.  
>> 
>> Quite odd. I find it questionable to say at least to mix multiple
>> command netlink outputs into one output.
>
>Really? So we're going to be designing kernel APIs so that each message
>contains complete information and can't contain references now?

Can you give me an exapmple of devlink or any other iproute2 app cmd
that actually does something similar to this?



>
>> The processing of it would be a small nightmare considering the way
>> how the netlink message processing works in iproute2 :/
