Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B889E50F190
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 08:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343540AbiDZHA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 03:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343520AbiDZHAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 03:00:25 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9494EF7F
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 23:57:18 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id m20so13342842ejj.10
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 23:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ksEc5iEBVuFj8Hvb8gyaIju5XMDKPgadO2YJzSyHmLc=;
        b=vO+5bLcw+6imYtC3IGxGsc25F6BFUK63cwbGCfo1Twny+UGRQOXt2dM+ndIu3f4klR
         6V2ZchxkchvGI/bKtpJMhc8EQQeIVb4ZT83ShAsk6PgVnosAemzN9uzgz08e+5gLECMq
         ApRbCLUvXPOnGu9LMLsMfvsA4XPf3nRTM4A+NMzmsuOKAXoiWohetDTtmEVVsnWO3sby
         nXCdMzNDzfy8klp3Mh+uAyp0Sb/UsZE9bGIV98Gt7IdqAyBIUsfli3RsBdeKlpCX9HuG
         jD4jmMGx/mfqXAPg26A4R8IMC3W26yozjUdELfSt/0sSKjQWmgPGFJDAVcdv4PwBCzVV
         DH6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ksEc5iEBVuFj8Hvb8gyaIju5XMDKPgadO2YJzSyHmLc=;
        b=Ypzizo3wIRZjOVIkU6So2T2YROzudBs26ukjCDBpPlMwqeb6W34nNN2agyeIkmqtB+
         2vcFv6c0QTlg0xiUeqGBZ7vqGjjZI8oZ/jQpe4vJ9ZHHbmow8SzbVq0u2bWq1U50Nq9p
         qVetc8p7b9tQAa7WIhaQSpbjZBo4UmOv8IR+xhUGgphDi/5fqINt16DDJF/ji2uo8B3O
         RK65KkVuo6hupDIldzY63b6z+f6YLOUYMa+B3fZLUOcfPP8YAbA2niP4hlzad0DKtJRW
         ltg2UAxfquciVqGwbs86esN/yfbsLtxTSzXsPfuz+xPtkTfDDuCK+ikKQ1suCwNkd2Z1
         zaEg==
X-Gm-Message-State: AOAM530giWZ7URxENIC9nb1R+1hDOFFv8GawvEI0e98u6o1vRETnG7Uh
        r31EqzZKeguLK5MJE4m2HTlwLA==
X-Google-Smtp-Source: ABdhPJzMv+9Uv0TXOOySedoLQLgXbN0znXsrbcXulUGbKo16M5v3IRroASqVKi2QtgfB2J9sio7k8g==
X-Received: by 2002:a17:907:3d89:b0:6ef:eebf:1708 with SMTP id he9-20020a1709073d8900b006efeebf1708mr20719856ejc.620.1650956236983;
        Mon, 25 Apr 2022 23:57:16 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id n10-20020a170906700a00b006efdb748e8dsm4393004ejj.88.2022.04.25.23.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 23:57:16 -0700 (PDT)
Date:   Tue, 26 Apr 2022 08:57:15 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YmeXyzumj1oTSX+x@nanopsycho>
References: <20220425034431.3161260-1-idosch@nvidia.com>
 <20220425090021.32e9a98f@kernel.org>
 <Ymb5DQonnrnIBG3c@shredder>
 <20220425125218.7caa473f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425125218.7caa473f@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 25, 2022 at 09:52:18PM CEST, kuba@kernel.org wrote:
>On Mon, 25 Apr 2022 22:39:57 +0300 Ido Schimmel wrote:
>> > :/ what is a line card device? You must provide document what you're
>> > doing, this:
>> > 
>> >  .../networking/devlink/devlink-linecard.rst   |   4 +
>> > 
>> > is not enough.
>> > 
>> > How many operations and attributes are you going to copy&paste?
>> > 
>> > Is linking devlink instances into a hierarchy a better approach?  
>> 
>> In this particular case, these devices are gearboxes. They are running
>> their own firmware and we want user space to be able to query and update
>> the running firmware version.
>
>Nothing too special, then, we don't create "devices" for every
>component of the system which can have a separate FW. That's where
>"components" are intended to be used..

*
Sure, that is why I re-used components :)
But you have to somehow link the component to the particular gearbox on
particular line card. Say, you need to flash GB on line card 8. This is
basically providing a way to expose this relationship to user. Also, the
"lc info" shows the FW version for gearboxes. As Ido mentioned, the GB
versions could be listed in "devlink dev info" in theory. But then, you
need to somehow expose the relationship with line card as well.

I don't see any simpler iface than this.


>
>> The idea (implemented in the next patchset) is to let these devices
>> expose their own "component name", which can then be plugged into the
>> existing flash command:
>> 
>>     $ devlink lc show pci/0000:01:00.0 lc 8
>>     pci/0000:01:00.0:
>>       lc 8 state active type 16x100G
>>         supported_types:
>>            16x100G
>>         devices:
>>           device 0 flashable true component lc8_dev0
>>           device 1 flashable false
>>           device 2 flashable false
>>           device 3 flashable false
>>     $ devlink dev flash pci/0000:01:00.0 file some_file.mfa2 component lc8_dev0
>
>IDK if it's just me or this assumes deep knowledge of the system.
>I don't understand why we need to list devices 1-3 at all. And they
>don't even have names. No information is exposed. 

There are 4 gearboxes on the line card. They share the same flash. So if
you flash gearbox 0, the rest will use the same FW.
I'm exposing them for the sake of completeness. Also, the interface
needs to be designed as a list anyway, as different line cards may have
separate flash per gearbox.

What's is the harm in exposing devices 1-3? If you insist, we can hide
them.


>
>There are many components on any networking device, including plenty
>40G-R4 -> 25G-R1 gearboxes out there.
>
>> Registering a separate devlink instance for these devices sounds like an
>> overkill to me. If you are not OK with a separate command (e.g.,
>> DEVLINK_CMD_LINECARD_INFO_GET), then extending DEVLINK_CMD_INFO_GET is
>> also an option. We discussed this during internal review, but felt that
>> the current approach is cleaner.
>
>I don't know what you have queued, so if you don't need a full devlink
>instance (IOW line cards won't need more individual config) that's fine.

Yeah, incoparable, the devlink dev and line card device - gearbox.


>For just FW flashing you can list many devices and update the
>components... no need to introduce new objects or uAPI.

Please see * above.


>
>> > Would you mind if I revert this?  
>> 
>> I can't stop you, but keep in mind that it's already late here and that
>> tomorrow I'm AFK (reserve duty) and won't be able to tag it. Jiri should
>> be available to continue this discussion tomorrow morning, so probably
>> best to wait for his feedback.
>
>Sure, no rush.
