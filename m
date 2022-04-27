Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8D75112A1
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 09:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358908AbiD0HjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 03:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358912AbiD0Hiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 03:38:51 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B52140A1C
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 00:35:38 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id n32-20020a05600c3ba000b00393ea7192faso656098wms.2
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 00:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=zar+HJXoBjKuN5D6+PfovrHfV2sZDF7f4KubrwbnB9M=;
        b=vBkCYK/ChQzPu/rwzp4KojRRFX8bXyGhgCE/Wztp734MpRX4q8fPCJad92aa/FdjLx
         f/VZwJfYxD7Xz1/fWZ1s5xD0ZQDuS3wXzoZfQ7+xQy40umuc1WASvW5s2pn2n8vw15/f
         58lx4TZm51JLd74GnyL+jKYih8i76rF/s8dI8iOQmx5VqXyJLS1Lh24nuKhEXp0RrF+G
         KJrLvp9MMdGCOrCR6KBjTCXqlgdbatuQ5UKwVztZsUUhjMIGPybnLqRZf4mJvprILF0a
         PWieY4YjmpDIQmQ05inbwAtENBWk8kGyQoV7y3XG7AtyLnQbJXrhXA1JMYHtPIDnL3+C
         l5vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zar+HJXoBjKuN5D6+PfovrHfV2sZDF7f4KubrwbnB9M=;
        b=FdJ+2bDdMj2mIY/g+PrIDpxFDJ23BJQd1e8lG5f8SmXDoYIy9qOQdHMAX2ssk/MJ9x
         2Sdt6lem3t2YgShJvmxXIp+9vswvtVnm8N8F9ZRwmLoxBQCwH8HEMIEPWjf/sKQP1lHB
         CDORrhKzZdaR90cZQgHEtIuPHqJcRMOEy3TQbwgFKPqn7+tHHV74KPFf1wLbrdoKu73R
         NQdlMzb9FOCPFAdwHsRgNqxZKVC9D/0D+fHVwt212evAMM1fRpRDR3I+QT2ojJ1B6bEQ
         8w/xaZ0FSPo+R0x5kJeNT3E/Xwht5ZV7NIrbEMFZudJMRmhC4MOf02D86Sh6KNrczmSr
         rCBw==
X-Gm-Message-State: AOAM532KYPR9zGrFev5Bqr1RiPiuZMOhE2lJw6rFZL4STfjyxfZ4XqpZ
        fs7hnlODZqa5lICx5WvGfsNEeQ==
X-Google-Smtp-Source: ABdhPJzDKCD+DzT7BwDSyTEFb67gv7szvc8dFs86b+duwxLZ8joGlmymxQ75NymjCk+9gok4vJ4O4Q==
X-Received: by 2002:a05:600c:3d18:b0:38e:c876:190c with SMTP id bh24-20020a05600c3d1800b0038ec876190cmr33674634wmb.19.1651044936577;
        Wed, 27 Apr 2022 00:35:36 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id e3-20020a05600c4e4300b00393e40b41d6sm963085wmq.15.2022.04.27.00.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 00:35:35 -0700 (PDT)
Date:   Wed, 27 Apr 2022 09:35:34 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YmjyRgYYRU/ZaF9X@nanopsycho>
References: <20220425034431.3161260-1-idosch@nvidia.com>
 <20220425090021.32e9a98f@kernel.org>
 <Ymb5DQonnrnIBG3c@shredder>
 <20220425125218.7caa473f@kernel.org>
 <YmeXyzumj1oTSX+x@nanopsycho>
 <20220426054130.7d997821@kernel.org>
 <Ymf66h5dMNOLun8k@nanopsycho>
 <20220426075133.53562a2e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220426075133.53562a2e@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Apr 26, 2022 at 04:51:33PM CEST, kuba@kernel.org wrote:
>On Tue, 26 Apr 2022 16:00:10 +0200 Jiri Pirko wrote:
>> >> But you have to somehow link the component to the particular gearbox on
>> >> particular line card. Say, you need to flash GB on line card 8. This is
>> >> basically providing a way to expose this relationship to user.
>> >> 
>> >> Also, the "lc info" shows the FW version for gearboxes. As Ido
>> >> mentioned, the GB versions could be listed in "devlink dev info" in
>> >> theory. But then, you need to somehow expose the relationship with
>> >> line card as well.  
>> >
>> >Why would the automation which comes to update the firmware care 
>> >at all where the component is? Humans can see what the component 
>> >is by looking at the name.  
>> 
>> The relationship-by-name sounds a bit fragile to me. The names of
>> components are up to the individual drivers.
>
>I asked you how the automation will operate. You must answer questions
>if you want to have a discussion. Automation is the relevant part.

Automation, not sure. It would probably just see type of gearbox and
flash it. Not sure I understand the question, perhaps you could explain?
Plus, the possibility is to auto-flash the GB from driver directly.


>You're not designing an interface for SDK users but for end users.

Sure, that is the aim of this API. Human end user. That is why I wanted
the user to see the relationships between devlink dev, line cards and
the gearboxes on them. If you want to limit the visibility, sure, just
tell me how.


>
>> >If we do need to know (*if*!) you can list FW components as a lc
>> >attribute, no need for new commands and objects.  
>> 
>> There is no new command for that, only one nested attribute which
>> carries the device list added to the existing command. They are no new
>> objects, they are just few nested values.
>
>DEVLINK_CMD_LINECARD_INFO_GET

Okay, that is not only to expose devices. That is also to expose info
about linecards, like HW revision, INI version etc. Where else to put
it? I can perhaps embed it into devlink dev info, but I thought separate
command would be more suitable. object cmd, object info cmd. It is
more clear I believe.


>
>> >IMHO we should either keep lc objects simple and self contained or 
>> >give them a devlink instance. Creating sub-objects from them is very  
>> 
>> Give them a devlink instance? I don't understand how. LC is not a
>> separate device, far from that. That does not make any sense to me.
>
>You can put a name of another devlink instance as an attribute of a lc.
>See below.
>
>> >worrying. If there is _any_ chance we'll need per-lc health reporters 
>> >or sbs or params(🤢) etc. etc. - let's bite the bullet _now_ and create
>> >full devlink sub-instances!  
>> 
>> Does not make sense to me at all. Line cards are detachable PHY sets in
>> essence, very basic functionality. They does not have buffers, health
>> and params, I don't think so. 
>
>I guess the definition of a "line card" has become somewhat murky over
>the years, since the olden days of serial lines.
>
>Perhaps David and others can enlighten us but what I'm used to hearing
>about as a line card these days in a chassis system is a full-on switch.
>Chassis being effectively a Clos network in a box, the main difference
>being the line cards talk cells to the backplane, not full packets.

That is a different device model comparing what we have.
These are like "nested switches". If they are separate devices with
everything, they can be modeled as separate devlink device instances.
No problem. Different case though.


>
>Back in my Netronome days we called those detachable front panel gear
>boxes "phy mods". Those had nowhere near the complexity of a real line
>card. Sounds like that's more aligned with what you have.

Yep.


>
>To summarize, since your definition of a line card is a bit special,
>the less uAPI we add to fit your definition we add the better.

Tell me where to cut it so it still makes sense.


>
>> >> I don't see any simpler iface than this.  
>> >
>> >Based on the assumptions you've made, maybe, but the uAPI should
>> >abstract away the irrelevant details. I'm questioning the assumptions.  
>> 
>> Is the FW version of gearbox on a line card irrelevand detail?
>
>Not what I said.

That is why I'm asking :)


>
>> If so, how does the user know if/when to flash it?
>> If not, where would you list it if devices nest is not the correct place?
>
>Let me mock up what I had in mind for you since it did not come thru 
>in the explanation:
>
>$ devlink dev info show pci/0000:01:00.0
>    versions:
>        fixed:
>          hw.revision 0
>          lc2.hw.revision a
>          lc8.hw.revision b
>        running:
>          ini.version 4
>          lc2.gearbox 1.1.3
>          lc8.gearbox 1.2.3

Would be rather:

          lc2.gearbox0 1.1.3
          lc2.gearbox1 1.2.4
          lc8.gearbox0 1.2.3

Okay, I see. So instead of having clear api with relationships and
clear human+machine readability we have squahed indexes into strings.
I fail to see the benefit, other than no-api-extension :/ On contrary.


>
>$ devlink lc show pci/0000:01:00.0 lc 8
>pci/0000:01:00.0:
>  lc 8 state active type 16x100G
>    supported_types:
>      16x100G
>    versions: 
>      lc8.hw.revision (a) 
>      lc8.gearbox (1.2.3)
>
>Where the data in the brackets is optionally fetched thru the existing
>"dev info" API, but rendered together by the user space.

Quite odd. I find it questionable to say at least to mix multiple
command netlink outputs into one output. The processing of it would
be a small nightmare considering the way how the netlink message
processing works in iproute2 :/


>
>> >> There are 4 gearboxes on the line card. They share the same flash. So
>> >> if you flash gearbox 0, the rest will use the same FW.  
>> >
>> >o_0 so the FW component is called lcX_dev0 and yet it applies to _all_
>> >devices, not just dev0?! Looking at the output above I thought other
>> >devices simply don't have FW ("flashable false").  
>> 
>> Yes, device 0 is "flash master" (RW). 1-3 are RO. I know it is a bit
>> confusing. Maybe Andy's suggestion of "shared" flag of some sort might
>> help.
>> 
>> >> I'm exposing them for the sake of completeness. Also, the interface
>> >> needs to be designed as a list anyway, as different line cards may
>> >> have separate flash per gearbox.
>> >> 
>> >> What's is the harm in exposing devices 1-3? If you insist, we can hide
>> >> them.  
>> >
>> >Well, they are unnecessary (this is uAPI), and coming from the outside
>> >I misinterpreted what the information reported means, so yeah, I'd
>> >classify it as harmful :(  
>> 
>> UAPI is the "devices nest". It has to be list one way or another
>> (we may need to expose more gearboxes anyway). So what is differently
>> harmful with having list [0] or list [0,1,2,3] ?
