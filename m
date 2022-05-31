Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88065539446
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 17:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345891AbiEaPvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 11:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239673AbiEaPvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 11:51:42 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEBFC40
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 08:51:39 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e25so8649601wra.11
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 08:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BCiumnALI0pTPPzMX23rnJBXXXUc3ACKNcpDkM4M1sk=;
        b=eO5iTJwpctPZRwmPIDmJp0RU0qexonf8HJZqMspZWuqta19tS8aRpZqXUd881bKzSj
         B+YmfSiIUi9t2ulukd3E6fq+dt4kiVdYxqCDhUKw5BrQqsSfPSWHrmrU4AmC4P2hj3dt
         Zd9yc4BthQDaeohJhflofUmg07vjuhO60c1dT/jbuZzB5aVmkWotC4fwbc9LzvAwWwUz
         S5/iJ3LvJZJRGPEru4u1zuU7hmKdJFbJ7ToG6b/Hrok/rHeXdGlVCT8Tt7gipOs8qfCe
         CcTi0EBr4l3udm9wDzcVLoEEPG4hbo/3EwHK4JIZ+ZcjLSPBPqJgNVWsIfkIEeW8pFnr
         PR2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BCiumnALI0pTPPzMX23rnJBXXXUc3ACKNcpDkM4M1sk=;
        b=uFPjwp6mDveYeRc+jv7soESjk9f+lnOGM6g9jSTfBFOB3N+Awbe84XyvJItefwd4lt
         qHmoOluESbogoOLLcEPkWSDOiSj3/5b4dwcMoHgufYK+f4frgSnBKd+q1HAA95nOCTMN
         y4jWNHzNCyq7iCSUS77GAhLpx1hPbJOLf7q/KWKgljOsTIq3F5QMGISl0FSxUhvfgMUp
         38l52E9deXaZYhQFR5Sp9bJTXGaTsO8Pfg1+xI5WsHU9UB3AyLw1+0NDf2CIMK8BwMRF
         K60Z4LYPUxvAgVLtmorUteWBfgSEuKzWe7Y+DJa+oPzwXlFrFBWwFwaUSQnUSdGwEBsS
         Ac0w==
X-Gm-Message-State: AOAM5335c7WzElvKqWkCcSR8+flN1RC3HpvfdSiPRduxg9BvddYe0/cv
        mT2I6/zqw2+ZinqjIuXVlR9XQg==
X-Google-Smtp-Source: ABdhPJxaEHplu+wLg+7vIWXSKrQjOas4omuzBu66LUpushcFwKeGdlbQpcfs+9aWxXq65cE8C/5fZA==
X-Received: by 2002:a05:6000:348:b0:210:323c:769a with SMTP id e8-20020a056000034800b00210323c769amr9743188wre.411.1654012298220;
        Tue, 31 May 2022 08:51:38 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o4-20020a5d4744000000b0020fe4c5e94csm11557195wrs.19.2022.05.31.08.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 08:51:37 -0700 (PDT)
Date:   Tue, 31 May 2022 17:51:36 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YpY5iKHR073DNF7D@nanopsycho>
References: <Yo9obX5Cppn8GFC4@nanopsycho>
 <20220526103539.60dcb7f0@kernel.org>
 <YpB9cwqcSAMslKLu@nanopsycho>
 <20220527171038.52363749@kernel.org>
 <YpHmrdCmiRagdxvt@nanopsycho>
 <20220528120253.5200f80f@kernel.org>
 <YpM7dWye/i15DBHF@nanopsycho>
 <20220530125408.3a9cb8ed@kernel.org>
 <YpW/n3Nh8fIYOEe+@nanopsycho>
 <20220531080555.29b6ec6b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220531080555.29b6ec6b@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 31, 2022 at 05:05:55PM CEST, kuba@kernel.org wrote:
>On Tue, 31 May 2022 09:11:27 +0200 Jiri Pirko wrote:
>> >Nevermind, I think we can iterate over all the groupings.
>> >Since I hope you agreed that component has an established  
>> 
>> Yeah, component=version. I will send a RFC soon that tights it together.
>> 
>> >meaning can we use group instead?  
>> 
>> Group of what? Could you provide me example what you mean?
>
>Group of components. As explained component has an existing meaning,
>we can't reuse the term with a different one now.

I still don't follow. I don't want to reuse it.
Really, could you be more specific and show examples, please?


>
>> >> Sorry, I'm a bit lost. Could you please provide some example about how
>> >> you envision it? For me it is a guessing game :/
>> >> My guess is you would like to add to the version nest where
>> >> DEVLINK_ATTR_INFO_VERSION_NAME resides for example
>> >> DEVLINK_ATTR_LINECARD_INDEX?
>> >> 
>> >> Correct?  
>> >
>> >Yup.  
>> 
>> Hmm, in that case, I'm not sure how to do this. As cmd options and       
>> outputs should match, we would have:                                     
>>                                                           
>> devlink dev info                                                         
>> lc2.fw 19.2010.1310                                                      
>>                                                                          
>> here lc2 and fw are concatenated from DEVLINK_ATTR_LINECARD_INDEX and DEVLINK_ATTR_INFO_VERSION_NAME
>
>lc2 is the group name.
>                                                     
>> Now on devlink dev flash side, when I pass "component lc2.fw", how could 
>> the "devlink dev flash" know to divide it to DEVLINK_ATTR_LINECARD_INDEX 
>> and FLASH_COMPONENT? Should I parse the cmd line option and figure the
>> "lcX." prefix into an attribute?
>>                                                        
>> Or, we would have to have something like:                                    
>> devlink dev flash pci/0000:01:00.0 lc 2 component fw file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2
>
>Yup, it'll make DaveA happy as well.
>
>> But to be consistent with the output, we would have to change "devlink   
>> dev info" to something like:                                             
>> pci/0000:01:00.0:                                                        
>>   versions:                                                              
>>       running:                                                           
>>         fw 1.2.3                                                         
>>         fw.mgmt 10.20.30                                                 
>>         lc 2 fw 19.2010.1310                                             
>
>Yup.

Set, you say "yup" but below you say it should be in a separate nest.
That is confusing me.


>                                                            
>> But that would break the existing JSON output, because "running" is an array:
>>                 "running": {                                             
>>                     "fw": "1.2.3",                                       
>>                     "fw.mgmt": "10.20.30"                                
>>                 },                                                       
>
>No, the lc versions should be in separate nests. Since they are not
>updated when flashing main FW mixing them into existing versions would
>break uAPI.

Could you please draw it out for me exacly as you envision it? We are
dancing around it, I can't really understand what exactly do you mean.


>
>> So probably better to stick to "lcx.y" notation in both devlink dev info
>> and flash and split/squash to attributes internally. What do you think?
>
>BTW how do you intend to activate the new FW? Extend the reload command?

Not sure now. Extending reload is an option. Have to think about it.

