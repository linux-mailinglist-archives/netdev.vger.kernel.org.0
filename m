Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26CF850FFE0
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 16:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344484AbiDZODd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 10:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351358AbiDZODb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 10:03:31 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93015DFA7
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 07:00:13 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id p18so17292590edr.7
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 07:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=QRUz6nJ+APvaydf53NPJH0a0bYcfsG99h8bYMIKy/6c=;
        b=OqLXHov7veJfp4iNfqguOo036SbQmeinwv2A1M+cRIO3p2HdayrHUP9cnnZkipl6Oy
         YB1wEmRHzFIMOK0PTA4TM/wJ6pxmO9IEwKb7gx33Y/k4vdogLYMPNj2DqBkRtCER2sRi
         K6N3IYy3eQPM13JEzm/8cUab8xiULl2jO+bQYTjBd3O+ojYiiufD2gsDsW03+B3Dj1+w
         t48EaM/ZMrWvPDHLkW/xGiy8RIn5LxbFaiqyGnqc2v1UFT5zGXVBoG3+ddTsJJSgu0Xi
         WccZtfPfFPS4LiQ4mTCmDRimbTTvF5DNVbI0dOFJya+SkUqQ5PqTqoexFYAPQGCSLQ6m
         AH1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=QRUz6nJ+APvaydf53NPJH0a0bYcfsG99h8bYMIKy/6c=;
        b=s+rvF0y4SFJLiimTdhl4f+f8Q3tK3JGEOIDHH1aJuM0/CskdqgCjvordKwnglp2lSp
         2ssNU7s+1CEm2Lp/ThUT/m9SMBeFJVG+sbBWnTYQ4Nc2b5LVz6fPjhtDQreokuzcxCp2
         6Rek0Wxl4y+nSlbPw1DkTcnuI59vcSm54w2P3EIiIlxG0L/RX20rHLdZx8oam0VmmtfS
         M1CRyM5DMrVjCBZSPvpH5hcUc4R2zsKdc8zx0WdsvAvSx9CEYHZKeErD3nURPkQkZY8o
         HIMaMlD3Tf0kgUioOmEBx4jn74Px6DbMSOsQolN26WBEAkxRs5mnwiiQ2uYug85VDqB1
         8FrQ==
X-Gm-Message-State: AOAM532lNUEYDY/pM89JuJfsPOkL0nnLwyzpXAHraxv2CfiTCarbjQZ0
        +7EJyIzVYPppD9ltRdJVNUrHBg==
X-Google-Smtp-Source: ABdhPJwxOJkjYHFo19ai/g03c6MPG/E84AfimwB6fqxMV+6JLEW0qX9WAEpDnbGughbk8aUUIj3s7g==
X-Received: by 2002:a05:6402:948:b0:425:ea37:96b8 with SMTP id h8-20020a056402094800b00425ea3796b8mr10193600edz.90.1650981611726;
        Tue, 26 Apr 2022 07:00:11 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l2-20020a50cbc2000000b00425d7bd65f0sm4255650edi.0.2022.04.26.07.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 07:00:11 -0700 (PDT)
Date:   Tue, 26 Apr 2022 16:00:10 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <Ymf66h5dMNOLun8k@nanopsycho>
References: <20220425034431.3161260-1-idosch@nvidia.com>
 <20220425090021.32e9a98f@kernel.org>
 <Ymb5DQonnrnIBG3c@shredder>
 <20220425125218.7caa473f@kernel.org>
 <YmeXyzumj1oTSX+x@nanopsycho>
 <20220426054130.7d997821@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220426054130.7d997821@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Apr 26, 2022 at 02:41:30PM CEST, kuba@kernel.org wrote:
>On Tue, 26 Apr 2022 08:57:15 +0200 Jiri Pirko wrote:
>> >> In this particular case, these devices are gearboxes. They are running
>> >> their own firmware and we want user space to be able to query and update
>> >> the running firmware version.  
>> >
>> >Nothing too special, then, we don't create "devices" for every
>> >component of the system which can have a separate FW. That's where
>> >"components" are intended to be used..  
>> 
>> *
>> Sure, that is why I re-used components :)
>
>Well, right, I guess you did reuse them a little :)

I use them a lot. It is not visible in this patchset, but in the
flashing follow-up patchset.


>
>> But you have to somehow link the component to the particular gearbox on
>> particular line card. Say, you need to flash GB on line card 8. This is
>> basically providing a way to expose this relationship to user.
>> 
>> Also, the "lc info" shows the FW version for gearboxes. As Ido
>> mentioned, the GB versions could be listed in "devlink dev info" in
>> theory. But then, you need to somehow expose the relationship with
>> line card as well.
>
>Why would the automation which comes to update the firmware care 
>at all where the component is? Humans can see what the component 
>is by looking at the name.

The relationship-by-name sounds a bit fragile to me. The names of
components are up to the individual drivers.


>
>If we do need to know (*if*!) you can list FW components as a lc
>attribute, no need for new commands and objects.

There is no new command for that, only one nested attribute which
carries the device list added to the existing command. They are no new
objects, they are just few nested values.


>
>IMHO we should either keep lc objects simple and self contained or 
>give them a devlink instance. Creating sub-objects from them is very

Give them a devlink instance? I don't understand how. LC is not a
separate device, far from that. That does not make any sense to me.


>worrying. If there is _any_ chance we'll need per-lc health reporters 
>or sbs or params(🤢) etc. etc. - let's bite the bullet _now_ and create
>full devlink sub-instances!

Does not make sense to me at all. Line cards are detachable PHY sets in
essence, very basic functionality. They does not have buffers, health
and params, I don't think so. 


>
>> I don't see any simpler iface than this.
>
>Based on the assumptions you've made, maybe, but the uAPI should
>abstract away the irrelevant details. I'm questioning the assumptions.

Is the FW version of gearbox on a line card irrelevand detail?
If so, how does the user know if/when to flash it?
If not, where would you list it if devices nest is not the correct place?


>
>> >> The idea (implemented in the next patchset) is to let these devices
>> >> expose their own "component name", which can then be plugged into
>> >> the existing flash command:
>> >> 
>> >>     $ devlink lc show pci/0000:01:00.0 lc 8
>> >>     pci/0000:01:00.0:
>> >>       lc 8 state active type 16x100G
>> >>         supported_types:
>> >>            16x100G
>> >>         devices:
>> >>           device 0 flashable true component lc8_dev0
>> >>           device 1 flashable false
>> >>           device 2 flashable false
>> >>           device 3 flashable false
>> >>     $ devlink dev flash pci/0000:01:00.0 file some_file.mfa2
>> >> component lc8_dev0  
>> >
>> >IDK if it's just me or this assumes deep knowledge of the system.
>> >I don't understand why we need to list devices 1-3 at all. And they
>> >don't even have names. No information is exposed.   
>> 
>> There are 4 gearboxes on the line card. They share the same flash. So
>> if you flash gearbox 0, the rest will use the same FW.
>
>o_0 so the FW component is called lcX_dev0 and yet it applies to _all_
>devices, not just dev0?! Looking at the output above I thought other
>devices simply don't have FW ("flashable false").

Yes, device 0 is "flash master" (RW). 1-3 are RO. I know it is a bit
confusing. Maybe Andy's suggestion of "shared" flag of some sort might
help.


>
>> I'm exposing them for the sake of completeness. Also, the interface
>> needs to be designed as a list anyway, as different line cards may
>> have separate flash per gearbox.
>> 
>> What's is the harm in exposing devices 1-3? If you insist, we can hide
>> them.
>
>Well, they are unnecessary (this is uAPI), and coming from the outside
>I misinterpreted what the information reported means, so yeah, I'd
>classify it as harmful :(

UAPI is the "devices nest". It has to be list one way or another
(we may need to expose more gearboxes anyway). So what is differently
harmful with having list [0] or list [0,1,2,3] ?

