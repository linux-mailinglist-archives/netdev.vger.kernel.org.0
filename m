Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC004538BD7
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 09:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244440AbiEaHLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 03:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236425AbiEaHLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 03:11:31 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBE487A0A
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 00:11:30 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id rq11so24794274ejc.4
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 00:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wAoGiMky5RXQtM4Hp7qwPxCAMIEA2ov16kHxdtH7ZAs=;
        b=RK46LnUKAPDMpJS4rDmLgEzdmc8kZNvu/JxPYoWYoznIJzG9mKIr11b+q8kS7nTMp2
         ORnY1uf/ZXim8ve/7d9VUnsdgFSth97Q5d9z83cW7KrxQS9+6IDg6mbOdfnhW8tE8XUZ
         seF0jUHGufIeH385gUO08jwtgIZaPG1R4Tu5te1odw3rIufj1t8zLg9TUBho+8rHnznd
         CWBYY0c3JsI7Za+etaqmWg7uCK+66ZaKSKuYbBnlmcf71Khtb2ISjf/9sOlEOqyh4+UH
         kUSEtsQMpslRn3yqLyqZz3ZRrDDvYCtVEoQuxQuMRS3FRqLV9i0/bMhg+GTf5RwXge6a
         U2jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wAoGiMky5RXQtM4Hp7qwPxCAMIEA2ov16kHxdtH7ZAs=;
        b=o0TquQNZmFlWLq6LhD80O9NSg4KDaqDrNtA8THrbrBxc0n7T49bz6DcNlt2C1/gN5N
         Ag4Vq/rIYKstVXHVa0JFMZTdLU1BuxWuhvAdzQmtqY0hL5WdYFkoi9TR1uodAkE1PJAD
         KVFtb8wLVYNqCUlzxvSdpVanmV98JzG+JQOPJfz8sBmfY0iOoKAER04bGj5SwiZ1FjTj
         WWSzMkXmh0kGxkjR3g0QMjni1xdnkp4ETfa61UJL5py5y3OMsSpiJsqKze+W7IAPYKPF
         o50OGwELSTV9bYu1HcROE6qQUMnbX6V77zszvf+p/mxIvp5r3f6U9XoX+8A6GtxbBOui
         jO5g==
X-Gm-Message-State: AOAM530Su4xkF6G1iqHA645jQJJl8TidYG/6314qJZnDpFxNhqfnnhXs
        DDzphU3KkurhH6KMsiKGe+9Lkg==
X-Google-Smtp-Source: ABdhPJy45ghXvW7AM/xvCmypSvYohuA7LNPqw0oUZ6vj1Yt8vst0pmK/Df0rU1hhxWgfilyzUkMR4g==
X-Received: by 2002:a17:906:3b8d:b0:6fe:94ac:2a78 with SMTP id u13-20020a1709063b8d00b006fe94ac2a78mr53309453ejf.547.1653981089028;
        Tue, 31 May 2022 00:11:29 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j24-20020a170906255800b006fee2570067sm4561142ejb.23.2022.05.31.00.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 00:11:28 -0700 (PDT)
Date:   Tue, 31 May 2022 09:11:27 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YpW/n3Nh8fIYOEe+@nanopsycho>
References: <Yo3KvfgTVTFM/JHL@nanopsycho>
 <20220525085054.70f297ac@kernel.org>
 <Yo9obX5Cppn8GFC4@nanopsycho>
 <20220526103539.60dcb7f0@kernel.org>
 <YpB9cwqcSAMslKLu@nanopsycho>
 <20220527171038.52363749@kernel.org>
 <YpHmrdCmiRagdxvt@nanopsycho>
 <20220528120253.5200f80f@kernel.org>
 <YpM7dWye/i15DBHF@nanopsycho>
 <20220530125408.3a9cb8ed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530125408.3a9cb8ed@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, May 30, 2022 at 09:54:08PM CEST, kuba@kernel.org wrote:
>On Sun, 29 May 2022 11:23:01 +0200 Jiri Pirko wrote:
>> >Let's step back and look from the automation perspective again.
>> >Assuming we don't want to hardcode matching "lc$i" there how can 
>> >a generic FW update service scan the dev info and decide on what
>> >dev flash command to fire off?  
>> 
>> Hardcode matching lc$i? I don't follow. It is a part of the
>> version/component name.
>> So if devlink dev info outputs:
>> lc2.fw 19.2010.1310
>> then you use for devlink dev flash:
>> devlink dev flash pci/0000:01:00.0 component lc2.fw file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2
>> Same name, same string.
>> 
>> What am I missing?
>
>Nevermind, I think we can iterate over all the groupings.
>Since I hope you agreed that component has an established

Yeah, component=version. I will send a RFC soon that tights it together.

>meaning can we use group instead?

Group of what? Could you provide me example what you mean?


>
>> >> Also, to avoid free-form, I can imagine to have per-linecard info_get() op
>> >> which would be called for each line card from devlink_nl_info_fill() and
>> >> prefix the "lcX" automatically without driver being involved.
>> >> 
>> >> Sounds good?  
>> >
>> >Hm. That's moving the matryoshka-ing of the objects from the uAPI level
>> >to the internals. 
>> >
>> >If we don't do the string prefix but instead pass the subobject info to
>> >the user space as an attribute per version we can at least avoid
>> >per-subobject commands (DEVLINK_CMD_LINECARD_INFO_GET). Much closer to
>> >how health reporters are implemented than how params are done, so I
>> >think it is a good direction.  
>> 
>> Sorry, I'm a bit lost. Could you please provide some example about how
>> you envision it? For me it is a guessing game :/
>> My guess is you would like to add to the version nest where
>> DEVLINK_ATTR_INFO_VERSION_NAME resides for example
>> DEVLINK_ATTR_LINECARD_INDEX?
>> 
>> Correct?
>
>Yup.

Hmm, in that case, I'm not sure how to do this. As cmd options and       
outputs should match, we would have:                                     
                                                                         
devlink dev info                                                         
lc2.fw 19.2010.1310                                                      
                                                                         
here lc2 and fw are concatenated from DEVLINK_ATTR_LINECARD_INDEX and DEVLINK_ATTR_INFO_VERSION_NAME
                                                                         
Now on devlink dev flash side, when I pass "component lc2.fw", how could 
the "devlink dev flash" know to divide it to DEVLINK_ATTR_LINECARD_INDEX 
and FLASH_COMPONENT? Should I parse the cmd line option and figure the
"lcX." prefix into an attribute?
                                                                         
Or, we would have to have something like:                                    
devlink dev flash pci/0000:01:00.0 lc 2 component fw file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2
                                                                         
But to be consistent with the output, we would have to change "devlink   
dev info" to something like:                                             
pci/0000:01:00.0:                                                        
  versions:                                                              
      running:                                                           
        fw 1.2.3                                                         
        fw.mgmt 10.20.30                                                 
        lc 2 fw 19.2010.1310                                             
                                                                         
But that would break the existing JSON output, because "running" is an array:
                "running": {                                             
                    "fw": "1.2.3",                                       
                    "fw.mgmt": "10.20.30"                                
                },                                                       

So probably better to stick to "lcx.y" notation in both devlink dev info
and flash and split/squash to attributes internally. What do you think?
