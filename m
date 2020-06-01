Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5006E1E9E5C
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 08:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgFAGkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 02:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgFAGkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 02:40:05 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBD5C061A0E
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 23:40:05 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id r7so10333812wro.1
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 23:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dPpwe6f7B2LDkExsfIsWwXpb31uklpOhKkGHYqwWmSA=;
        b=B37xZWc/mt10nh4uhN3BbYdWDsmb2VBQWIS0JFmTd3XV87mLGMvgfYwKyKKFWgle6K
         4RnkQiEff06W/q9fxKkUo0wOY4EzyiDUCgYrelWJP1l8PgiTXD5um1aQSx3lQrLZK9Xu
         /9eHJI8KI4oMX46y9nQfbWUl17utAp+pHgkn8CQdw9IOiM3em1V5PeKVdz/3Xm2ztfqV
         BPISmum6vA+DLIAB8iNNPIUxACp16SMDumvN4zk5ipMQ++AIJ/VQbd6DMixYxtWJbVB8
         VKRiisUI4i9iAF54rpEH3pRl9pm8I1p6OPKdGns7jbDCjt7Uu/TJ+B4kSh7LGEE4oq0k
         85yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dPpwe6f7B2LDkExsfIsWwXpb31uklpOhKkGHYqwWmSA=;
        b=TuhOXvtoDXk0WUOzIeAp+yAQcyhARaREeM7+ISkQ6/BTaAsbOA7TNhj1urAOe8ku14
         zBLGwAUhAYsXskprH0li4vnUq/FfdVcUhrKdXZwqwqFBpD2vFvJdGS3AoCYba3kqy43l
         bUH7Y6mrOB/kD8cZIcvyLNvQ3n0vwIbXaFWaQODUTFv/P4wgO9Ub67Xk/EtZaxdWUorX
         dQ9UI+AH/eSzvXc5cxsvDxL/UFEiN6SZ3m8pIgA5yY1cP9ZyLYpMi/05A64USVFVCY+B
         8vSs3fnE3MLJOKMS/Jebobf9KBtzZ2UFf7uYTuPDS+QpnmkmzlruFHQEB0+/K8SVwDES
         Cjfw==
X-Gm-Message-State: AOAM533EfiQ+sqbIIv5Xy8l4jAtiS37FrA7BSZMpKU8ud/5zQZVaIas3
        nFj1s8neR2WL8U2Wv3v9bMIkNQ==
X-Google-Smtp-Source: ABdhPJzpDjGcnlujwz8p49VbRz+S2jaw3RhALYJyqZzhLQFDNLrwgpp/Vf06WI7yORKUi8Nb5c6Fjw==
X-Received: by 2002:a5d:5112:: with SMTP id s18mr19925701wrt.160.1590993604189;
        Sun, 31 May 2020 23:40:04 -0700 (PDT)
Received: from localhost (ip-78-102-58-167.net.upcbroadband.cz. [78.102.58.167])
        by smtp.gmail.com with ESMTPSA id k13sm10665892wmj.40.2020.05.31.23.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 23:40:03 -0700 (PDT)
Date:   Mon, 1 Jun 2020 08:40:02 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH v2 net-next 1/4] devlink: Add new "allow_fw_live_reset"
 generic device parameter.
Message-ID: <20200601064002.GE2282@nanopsycho>
References: <20200525172602.GA14161@nanopsycho>
 <CAACQVJpRrOSn2eLzS1z9rmATrmzA2aNG-9pcbn-1E+sQJ5ET_g@mail.gmail.com>
 <20200526044727.GB14161@nanopsycho>
 <CAACQVJp8SfmP=R=YywDWC8njhA=ntEcs5o_KjBoHafPkHaj-iA@mail.gmail.com>
 <20200526134032.GD14161@nanopsycho>
 <CAACQVJrwFB4oHjTAw4DK28grxGGP15x52+NskjDtOYQdOUMbOg@mail.gmail.com>
 <CAACQVJqTc9s2KwUCEvGLfG3fh7kKj3-KmpeRgZMWM76S-474+w@mail.gmail.com>
 <20200527131401.2e269ab8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CACKFLi=+Q4CkOvaxQQm5Ya8+Ft=jNMwCAuK+=5SMxAfNGGriBw@mail.gmail.com>
 <20200527141608.3c96f618@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527141608.3c96f618@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, May 27, 2020 at 11:16:08PM CEST, kuba@kernel.org wrote:
>On Wed, 27 May 2020 13:57:11 -0700 Michael Chan wrote:
>> On Wed, May 27, 2020 at 1:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
>> > On Wed, 27 May 2020 09:07:09 +0530 Vasundhara Volam wrote:  
>> > > Here is a sample sequence of commands to do a "live reset" to get some
>> > > clear idea.
>> > > Note that I am providing the examples based on the current patchset.
>> > >
>> > > 1. FW live reset is disabled in the device/adapter. Here adapter has 2
>> > > physical ports.
>> > >
>> > > $ devlink dev
>> > > pci/0000:3b:00.0
>> > > pci/0000:3b:00.1
>> > > pci/0000:af:00.0
>> > > $ devlink dev param show pci/0000:3b:00.0 name allow_fw_live_reset
>> > > pci/0000:3b:00.0:
>> > >   name allow_fw_live_reset type generic
>> > >     values:
>> > >       cmode runtime value false
>> > >       cmode permanent value false
>> > > $ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
>> > > pci/0000:3b:00.1:
>> > >   name allow_fw_live_reset type generic
>> > >     values:
>> > >       cmode runtime value false
>> > >       cmode permanent value false  
>> >
>> > What's the permanent value? What if after reboot the driver is too old
>> > to change this, is the reset still allowed?  
>> 
>> The permanent value should be the NVRAM value.  If the NVRAM value is
>> false, the feature is always and unconditionally disabled.  If the
>> permanent value is true, the feature will only be available when all
>> loaded drivers indicate support for it and set the runtime value to
>> true.  If an old driver is loaded afterwards, it wouldn't indicate
>> support for this feature and it wouldn't set the runtime value to
>> true.  So the feature will not be available until the old driver is
>> unloaded or upgraded.
>
>Setting this permanent value to false makes the FW's life easier?
>Otherwise why not always have it enabled and just depend on hosts 
>not opting in?
>
>> > > 2. If a user issues "ethtool --reset p1p1 all", the device cannot
>> > > perform "live reset" as capability is not enabled.
>> > >
>> > > User needs to do a driver reload, for firmware to undergo reset.  
>> >
>> > Why does driver reload have anything to do with resetting a potentially
>> > MH device?  
>> 
>> I think she meant that all drivers have to be unloaded before the
>> reset would take place in case it's a MH device since live reset is
>> not supported.  If it's a single function device, unloading this
>> driver is sufficient.
>
>I see.
>
>> > > $ ethtool --reset p1p1 all  
>> >
>> > Reset probably needs to be done via devlink. In any case you need a new
>> > reset level for resetting MH devices and smartnics, because the current
>> > reset mask covers port local, and host local cases, not any form of MH.  
>> 
>> RIght.  This reset could be just a single function reset in this example.
>
>Well, for the single host scenario the parameter dance is not at all
>needed, since there is only one domain of control. If user can issue a
>reset they can as well change the value of the param or even reload the
>driver. The runtime parameter only makes sense in MH/SmartNIC scenario,
>so IMHO the param and devlink reset are strongly dependent.
>
>> > > ETHTOOL_RESET 0xffffffff
>> > > Components reset:     0xff0000
>> > > Components not reset: 0xff00ffff
>> > > $ dmesg
>> > > [  198.745822] bnxt_en 0000:3b:00.0 p1p1: Firmware reset request successful.
>> > > [  198.745836] bnxt_en 0000:3b:00.0 p1p1: Reload driver to complete reset  
>> >
>> > You said the reset was not performed, yet there is no information to
>> > that effect in the log?!  
>> 
>> The firmware has been requested to reset, but the reset hasn't taken
>> place yet because live reset cannot be done.  We can make the logs
>> more clear.
>
>Thanks
>
>> > > 3. Now enable the capability in the device and reboot for device to
>> > > enable the capability. Firmware does not get reset just by setting the
>> > > param to true.
>> > >
>> > > $ devlink dev param set pci/0000:3b:00.1 name allow_fw_live_reset
>> > > value true cmode permanent
>> > >
>> > > 4. After reboot, values of param.  
>> >
>> > Is the reboot required here?
>> 
>> In general, our new NVRAM permanent parameters will take effect after
>> reset (or reboot).
>>
>> > > $ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
>> > > pci/0000:3b:00.1:
>> > >   name allow_fw_live_reset type generic
>> > >     values:
>> > >       cmode runtime value true  
>> >
>> > Why is runtime value true now?
>> >  
>> 
>> If the permanent (NVRAM) parameter is true, all loaded new drivers
>> will indicate support for this feature and set the runtime value to
>> true by default.  The runtime value would not be true if any loaded
>> driver is too old or has set the runtime value to false.
>
>Okay, the parameter has a bit of a dual role as it controls whether the
>feature is available (false -> true transition requiring a reset/reboot)
>and the default setting of the runtime parameter. Let's document that
>more clearly.

Or, don't use the param for indication as I suggested in the other
email...

