Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8777B1E9E5B
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 08:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgFAGjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 02:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgFAGjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 02:39:21 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C72C061A0E
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 23:39:21 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id r7so10332045wro.1
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 23:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0vmqhwI2Xer3Aa8mLnKArHNOJmddkI96BlLJSu43GpE=;
        b=ykLJPzEwUmm2WBAjiyQZ6hTmx2jp7GDofR7NeTrFn3ta8wOShZRMboX5tZ+H2XycmA
         T0ahlgzyB0v1hGivP6R46TygTAEvawFF3DLd6lyIUDf+3byhxqZDx7tR9/xK82v+3pUe
         VdpMkJEinWYwUkvRDUn8it9btKRt4QBKvHS/UQvGEq01o3AknWI0Z0q9VZqm4gWu8o8o
         qjAAi/HcqYBrpqU3Nz3wCRR+VhSwTg48NjKoDQDDb8SKDVRUrSoLmGp/MS67tW4xPC0o
         rCssl3xgn4rG6uTGcvNCtrLIrW7cDMhYkIU+oDIvCLWFEUVwlGdIGvOcmlW6fXqiwTTT
         bgyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0vmqhwI2Xer3Aa8mLnKArHNOJmddkI96BlLJSu43GpE=;
        b=BhR/aEakA/c47jVFg70jB24fTSfreeMGtZdo068AQQQ4WNqt6q4biSH/nTrQm4uR+O
         ch7iwS2moJoYADq5En3QnG/6Ocbk+vbkvxuTKlY86eKa2J9E25IFFKK+ERqFOEadZKeb
         RMB+FEW2hDqHTBK+E4nT8xR66MMKivYWGS9bTHwahjXnenjLsudgh5/c0wEDz12ZCFn5
         +7Fmpn24ls1kgeL79yfRkpaBCOZP2pqylPhSLCScHN6iHGS+l99pPcYuuKabjevrVW2u
         m6ky10fDGGjLyjK2nUWnxDIsFZJ0U8PTrJfZXFiEt4ndhFhjsLrEBp7CAEoMBlvkqiRk
         YJig==
X-Gm-Message-State: AOAM531+CvwnoY+Lpg12Y85tg8tZVcbIL6S93tXbVQ670CrQir8NoGL7
        aTTxfU5KfJQZCPfheR3YERjV1A==
X-Google-Smtp-Source: ABdhPJxlUw/7u4QJIaUWQN0OxfsHzad/CnQEEer3/eweYtX5UQY8MMdaKosFdVmnJbBH7h41btLpPQ==
X-Received: by 2002:a5d:44cf:: with SMTP id z15mr2592220wrr.164.1590993560012;
        Sun, 31 May 2020 23:39:20 -0700 (PDT)
Received: from localhost (ip-78-102-58-167.net.upcbroadband.cz. [78.102.58.167])
        by smtp.gmail.com with ESMTPSA id u3sm11926719wmg.38.2020.05.31.23.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 23:39:19 -0700 (PDT)
Date:   Mon, 1 Jun 2020 08:39:18 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH v2 net-next 1/4] devlink: Add new "allow_fw_live_reset"
 generic device parameter.
Message-ID: <20200601063918.GD2282@nanopsycho>
References: <CAACQVJpbXSnf0Gc5HehFc6KzKjZU7dV5tY9cwR72pBhweVRkFw@mail.gmail.com>
 <20200525172602.GA14161@nanopsycho>
 <CAACQVJpRrOSn2eLzS1z9rmATrmzA2aNG-9pcbn-1E+sQJ5ET_g@mail.gmail.com>
 <20200526044727.GB14161@nanopsycho>
 <CAACQVJp8SfmP=R=YywDWC8njhA=ntEcs5o_KjBoHafPkHaj-iA@mail.gmail.com>
 <20200526134032.GD14161@nanopsycho>
 <CAACQVJrwFB4oHjTAw4DK28grxGGP15x52+NskjDtOYQdOUMbOg@mail.gmail.com>
 <CAACQVJqTc9s2KwUCEvGLfG3fh7kKj3-KmpeRgZMWM76S-474+w@mail.gmail.com>
 <20200527131401.2e269ab8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CACKFLi=+Q4CkOvaxQQm5Ya8+Ft=jNMwCAuK+=5SMxAfNGGriBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKFLi=+Q4CkOvaxQQm5Ya8+Ft=jNMwCAuK+=5SMxAfNGGriBw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, May 27, 2020 at 10:57:11PM CEST, michael.chan@broadcom.com wrote:
>On Wed, May 27, 2020 at 1:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Wed, 27 May 2020 09:07:09 +0530 Vasundhara Volam wrote:
>> > Here is a sample sequence of commands to do a "live reset" to get some
>> > clear idea.
>> > Note that I am providing the examples based on the current patchset.
>> >
>> > 1. FW live reset is disabled in the device/adapter. Here adapter has 2
>> > physical ports.
>> >
>> > $ devlink dev
>> > pci/0000:3b:00.0
>> > pci/0000:3b:00.1
>> > pci/0000:af:00.0
>> > $ devlink dev param show pci/0000:3b:00.0 name allow_fw_live_reset
>> > pci/0000:3b:00.0:
>> >   name allow_fw_live_reset type generic
>> >     values:
>> >       cmode runtime value false
>> >       cmode permanent value false
>> > $ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
>> > pci/0000:3b:00.1:
>> >   name allow_fw_live_reset type generic
>> >     values:
>> >       cmode runtime value false
>> >       cmode permanent value false
>>
>> What's the permanent value? What if after reboot the driver is too old
>> to change this, is the reset still allowed?
>
>The permanent value should be the NVRAM value.  If the NVRAM value is
>false, the feature is always and unconditionally disabled.  If the
>permanent value is true, the feature will only be available when all
>loaded drivers indicate support for it and set the runtime value to
>true.  If an old driver is loaded afterwards, it wouldn't indicate
>support for this feature and it wouldn't set the runtime value to
>true.  So the feature will not be available until the old driver is
>unloaded or upgraded.
>
>>
>> > 2. If a user issues "ethtool --reset p1p1 all", the device cannot
>> > perform "live reset" as capability is not enabled.
>> >
>> > User needs to do a driver reload, for firmware to undergo reset.
>>
>> Why does driver reload have anything to do with resetting a potentially
>> MH device?
>
>I think she meant that all drivers have to be unloaded before the
>reset would take place in case it's a MH device since live reset is
>not supported.  If it's a single function device, unloading this
>driver is sufficient.
>
>>
>> > $ ethtool --reset p1p1 all
>>
>> Reset probably needs to be done via devlink. In any case you need a new
>> reset level for resetting MH devices and smartnics, because the current
>> reset mask covers port local, and host local cases, not any form of MH.
>
>RIght.  This reset could be just a single function reset in this example.
>
>>
>> > ETHTOOL_RESET 0xffffffff
>> > Components reset:     0xff0000
>> > Components not reset: 0xff00ffff
>> > $ dmesg
>> > [  198.745822] bnxt_en 0000:3b:00.0 p1p1: Firmware reset request successful.
>> > [  198.745836] bnxt_en 0000:3b:00.0 p1p1: Reload driver to complete reset
>>
>> You said the reset was not performed, yet there is no information to
>> that effect in the log?!
>
>The firmware has been requested to reset, but the reset hasn't taken
>place yet because live reset cannot be done.  We can make the logs
>more clear.
>
>>
>> > 3. Now enable the capability in the device and reboot for device to
>> > enable the capability. Firmware does not get reset just by setting the
>> > param to true.
>> >
>> > $ devlink dev param set pci/0000:3b:00.1 name allow_fw_live_reset
>> > value true cmode permanent
>> >
>> > 4. After reboot, values of param.
>>
>> Is the reboot required here?
>>
>
>In general, our new NVRAM permanent parameters will take effect after
>reset (or reboot).

Ah, you need a reboot. I was not expecting that :/ So the "devlink dev
reload" attr would not work for you. MLNX hardware can change this on
runtime.


>
>> > $ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
>> > pci/0000:3b:00.1:
>> >   name allow_fw_live_reset type generic
>> >     values:
>> >       cmode runtime value true
>>
>> Why is runtime value true now?
>>
>
>If the permanent (NVRAM) parameter is true, all loaded new drivers
>will indicate support for this feature and set the runtime value to
>true by default.  The runtime value would not be true if any loaded
>driver is too old or has set the runtime value to false.

This is a bit odd. It is a configuration, not an indication. When you
want to indicate what you support something, I think it should be done
in a different place. I think that "devlink dev info" is the place to
put it, I think that we need "capabilities" there.

