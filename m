Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46EDD50F17C
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 08:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245648AbiDZGuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 02:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245356AbiDZGut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 02:50:49 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC1224977
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 23:47:41 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g23so14064062edy.13
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 23:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CiXcezkaTWAJHXfveze1tlFXrVDSwESEveCgZZDU9Wk=;
        b=yhuk0hmmMz9s+IDBaAF8QGJOFT9T6ud7BD2sTRiJzy4PxcEFHasEDCRlGq2NTp4D6m
         pQbRRx7w72ChmlGzc2AgNpzl0IPkzX/XwYBf4etNDXoKJIbvrF5PwHyQWdO+vsWbsXOs
         IU5WI4sVV5Jcb8DD4n2/2ESOGV0ACZLMYu2YybtUIGfWkA8A1Ed9xFn9fBSrg6TXoffR
         xVOzeT1/V89UDjDMPUuOrPysMQ00PbqX2BJr9hGhl2RcwRCcHlFGhc60KnSKSPVKNoR4
         GEjSFVPZ9jl5gir/UdUUSZF4g/gK1a/RQzL7Hz+FKqdEd8JPXSTtk5vUwwioOIW6PxOd
         YVfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CiXcezkaTWAJHXfveze1tlFXrVDSwESEveCgZZDU9Wk=;
        b=KvPUhkWpKMutLc4XIarTvXGIfn2wy1UothWvihP9CMholP2cSteQwg94FYZvclLjuA
         WYEk0Rwia//GIPrgm/q6tBBCsTJzq3TZwd1NvOFyS+63+micXP/rb4Oitu47ImBivbsk
         0QCU7gXNfQbxd7K7HfR3jCVMxmPqi4lqzeTjnPzGhGaYKsftylttR2cXcOGn4ycbrySh
         QcS++agME5l63KK0lbQ+ju6Vs7z6smRT01PrjyhlBAABRQoMs6Z/ZNUVldr273tiofJ7
         cKAP8riL26YdfCuQBMraLwxns3DisavZl50fZNaCRMNMxZQaHOmymqefhRql+Swi5Li4
         OKzw==
X-Gm-Message-State: AOAM531qibuGsM0XGONJueuDHcevzxKQ3eoSDip7lFUYvIq6Lzj5ezno
        iSbcrHN3khaiJ0Tzsn8AcYNLDg==
X-Google-Smtp-Source: ABdhPJyPmkwTVz2ZlKOYEXJ6u7apfSWJyDUreN1Mqt7ySybeRA0qkp5lP85uLljj3WQmBXu+p3NHaQ==
X-Received: by 2002:a05:6402:22e1:b0:425:d5e5:c63 with SMTP id dn1-20020a05640222e100b00425d5e50c63mr14266544edb.185.1650955659498;
        Mon, 25 Apr 2022 23:47:39 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id m10-20020a1709062b8a00b006f3a5d9e58csm986103ejg.131.2022.04.25.23.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 23:47:38 -0700 (PDT)
Date:   Tue, 26 Apr 2022 08:47:37 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YmeViVZ1XhCBCFLN@nanopsycho>
References: <20220425034431.3161260-1-idosch@nvidia.com>
 <20220425090021.32e9a98f@kernel.org>
 <Ymb5DQonnrnIBG3c@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ymb5DQonnrnIBG3c@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 25, 2022 at 09:39:57PM CEST, idosch@idosch.org wrote:
>On Mon, Apr 25, 2022 at 09:00:21AM -0700, Jakub Kicinski wrote:
>> On Mon, 25 Apr 2022 06:44:20 +0300 Ido Schimmel wrote:
>> > This patchset is extending the line card model by three items:
>> > 1) line card devices
>> > 2) line card info
>> > 3) line card device info
>> > 
>> > First three patches are introducing the necessary changes in devlink
>> > core.
>> > 
>> > Then, all three extensions are implemented in mlxsw alongside with
>> > selftest.
>> 
>> :/ what is a line card device? You must provide document what you're
>> doing, this:
>> 
>>  .../networking/devlink/devlink-linecard.rst   |   4 +
>> 
>> is not enough.
>> 
>> How many operations and attributes are you going to copy&paste?
>> 
>> Is linking devlink instances into a hierarchy a better approach?
>
>In this particular case, these devices are gearboxes. They are running
>their own firmware and we want user space to be able to query and update
>the running firmware version.
>
>The idea (implemented in the next patchset) is to let these devices
>expose their own "component name", which can then be plugged into the
>existing flash command:
>
>    $ devlink lc show pci/0000:01:00.0 lc 8
>    pci/0000:01:00.0:
>      lc 8 state active type 16x100G
>        supported_types:
>           16x100G
>        devices:
>          device 0 flashable true component lc8_dev0
>          device 1 flashable false
>          device 2 flashable false
>          device 3 flashable false
>    $ devlink dev flash pci/0000:01:00.0 file some_file.mfa2 component lc8_dev0
>
>Registering a separate devlink instance for these devices sounds like an

It is not a separate devlink device, not removetely. A devlink device is
attached to some bus on the host, it contains entities like netdevices,
etc.

Line card devices, on contrary, are accessible over ASIC FW interface,
they reside on line cards. ASIC FW is using build-in SDK to communicate
with them. There is really nothing to expose, except for the face they
are there, with some FW version and later on (follow-up patchset) to be
able to flash FW on them.

It's a gearbox. I found it odd to name it gearbox as in theory, there
might be some other single purpose device on the line card of other type
than gearbox. Therefore, "device". I admit it is a bit misleading. Idea
for a better name?


>overkill to me. If you are not OK with a separate command (e.g.,
>DEVLINK_CMD_LINECARD_INFO_GET), then extending DEVLINK_CMD_INFO_GET is
>also an option. We discussed this during internal review, but felt that

We would need to add all the line card hierarchy into info_get. That
would look a bit odd to me.


>the current approach is cleaner.
>
>> Would you mind if I revert this?

Let's see what you need to change and change it in place, if possible.


>
>I can't stop you, but keep in mind that it's already late here and that
>tomorrow I'm AFK (reserve duty) and won't be able to tag it. Jiri should
>be available to continue this discussion tomorrow morning, so probably
>best to wait for his feedback.
