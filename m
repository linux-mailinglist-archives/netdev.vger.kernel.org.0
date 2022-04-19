Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA0F506B89
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242765AbiDSL6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242761AbiDSL6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:58:30 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C245B1CB01
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 04:55:47 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id c10so22129334wrb.1
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 04:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CxuKsriwf8Qyr7T53RY5PK61DI7Ap2mIZW59z24JAAk=;
        b=jbAZByy/wWns9cCYq+YfghOkeckEang10j2/sF11gJ5IdBCuHgxOOJzLuPBUo48faI
         46z17MnwRMYQ1tpM+IS0kAqIfarsF+7JvTeEObvbl1x9hr65AXLbZ1wlFRmKJ2Kejaoe
         wqVH+VmyGrmkb3QhMskC1oL3DQ9QBXJCpM08U8Oh4KJzVlw0Bx/26Id7wtFEwCRxfWV+
         nNj7RRm4MIm1r1P0CWI6dV9S7JilIC9EXVX5hUBiEmQjLNbrIJPRVeNVP7lAkd09Kvf3
         QdcFC+GsChhosblwpWF8nQFcKSeSg+Etrj3+2AgD86Lmh/pZi73lt/i0NJKdw/Ts4M/6
         Nqlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CxuKsriwf8Qyr7T53RY5PK61DI7Ap2mIZW59z24JAAk=;
        b=uZqDqzPGR6YJRBNaQTkZ8zcYlgYLCKVn4DCWb5QgaAWMA0obFsKRBe2FoxdecJ1jFg
         AWjSOF8vToHVPzbOPoDafeQmNed2tclI/rlTEr50AW8aWSF3j6/Ft2sPiW4+xkTbTkow
         hbHX3bv02sKqmPdQ3Ae1i2F9xr53LJmZSOCCrCltLaHwniKlRMwO4/8UlCgpi/ncWYL8
         LbZmJwIH6itZU4Pqt4tOoP2o+vfUlR6dzfjzbJtCzNtVDxtNlKI+ue0LDLCMsEhSdhAr
         ssid+HVplVoqSxLg8vqQMVgBUUbI5DtXlLc3AQW5il64ujl3QwcfrwPUP9uJxhlsHNm6
         nmPA==
X-Gm-Message-State: AOAM532LlJBtSyd+ECjDM3TAnskOxBMUxpOD4e8mJo8JNqhbUpOwZz7U
        SVLmWiwyYRSEmReZEaTYLEFEIQ==
X-Google-Smtp-Source: ABdhPJzK++p0Oo7xcRsu30HTEsQmWw3t9C47JAoCvzeTFZEirUNOoulh1RFR6vQPNfXukUQOZYG/kw==
X-Received: by 2002:adf:e112:0:b0:206:d12:9c3a with SMTP id t18-20020adfe112000000b002060d129c3amr11151639wrz.391.1650369346228;
        Tue, 19 Apr 2022 04:55:46 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id s17-20020adfdb11000000b001f02d5fea43sm12702613wri.98.2022.04.19.04.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 04:55:45 -0700 (PDT)
Date:   Tue, 19 Apr 2022 13:55:44 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/17] Introduce line card support for modular
 switch
Message-ID: <Yl6jQHXYa8MvEyX3@nanopsycho>
References: <20220418064241.2925668-1-idosch@nvidia.com>
 <4d86acf1-d449-92d7-f8c7-bd0edc9e5107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d86acf1-d449-92d7-f8c7-bd0edc9e5107@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 18, 2022 at 04:31:30PM CEST, dsahern@gmail.com wrote:
>On 4/18/22 12:42 AM, Ido Schimmel wrote:
>> Jiri says:
>> 
>> This patchset introduces support for modular switch systems and also
>> introduces mlxsw support for NVIDIA Mellanox SN4800 modular switch.
>> It contains 8 slots to accommodate line cards - replaceable PHY modules
>> which may contain gearboxes.
>> Currently supported line card:
>> 16X 100GbE (QSFP28)
>> Other line cards that are going to be supported:
>> 8X 200GbE (QSFP56)
>> 4X 400GbE (QSFP-DD)
>> There may be other types of line cards added in the future.
>> 
>> To be consistent with the port split configuration (splitter cabels),
>> the line card entities are treated in the similar way. The nature of
>> a line card is not "a pluggable device", but "a pluggable PHY module".
>> 
>> A concept of "provisioning" is introduced. The user may "provision"
>> certain slot with a line card type. Driver then creates all instances
>> (devlink ports, netdevices, etc) related to this line card type. It does
>> not matter if the line card is plugged-in at the time. User is able to
>> configure netdevices, devlink ports, setup port splitters, etc. From the
>> perspective of the switch ASIC, all is present and can be configured.
>> 
>> The carrier of netdevices stays down if the line card is not plugged-in.
>> Once the line card is inserted and activated, the carrier of
>> the related netdevices is then reflecting the physical line state,
>> same as for an ordinary fixed port.
>> 
>> Once user does not want to use the line card related instances
>> anymore, he can "unprovision" the slot. Driver then removes the
>> instances.
>> 
>> Patches 1-4 are extending devlink driver API and UAPI in order to
>> register, show, dump, provision and activate the line card.
>> Patches 5-17 are implementing the introduced API in mlxsw.
>> The last patch adds a selftest for mlxsw line cards.
>> 
>> Example:
>> $ devlink port # No ports are listed
>> $ devlink lc
>> pci/0000:01:00.0:
>>   lc 1 state unprovisioned
>>     supported_types:
>>        16x100G
>>   lc 2 state unprovisioned
>>     supported_types:
>>        16x100G
>>   lc 3 state unprovisioned
>>     supported_types:
>>        16x100G
>>   lc 4 state unprovisioned
>>     supported_types:
>>        16x100G
>>   lc 5 state unprovisioned
>>     supported_types:
>>        16x100G
>>   lc 6 state unprovisioned
>>     supported_types:
>>        16x100G
>>   lc 7 state unprovisioned
>>     supported_types:
>>        16x100G
>>   lc 8 state unprovisioned
>>     supported_types:
>>        16x100G
>> 
>> Note that driver exposes list supported line card types. Currently
>> there is only one: "16x100G".
>> 
>> To provision the slot #8:
>> 
>> $ devlink lc set pci/0000:01:00.0 lc 8 type 16x100G
>> $ devlink lc show pci/0000:01:00.0 lc 8
>> pci/0000:01:00.0:
>>   lc 8 state active type 16x100G
>>     supported_types:
>>        16x100G
>> $ devlink port
>> pci/0000:01:00.0/0: type notset flavour cpu port 0 splittable false
>> pci/0000:01:00.0/53: type eth netdev enp1s0nl8p1 flavour physical lc 8 port 1 splittable true lanes 4
>> pci/0000:01:00.0/54: type eth netdev enp1s0nl8p2 flavour physical lc 8 port 2 splittable true lanes 4
>> pci/0000:01:00.0/55: type eth netdev enp1s0nl8p3 flavour physical lc 8 port 3 splittable true lanes 4
>> pci/0000:01:00.0/56: type eth netdev enp1s0nl8p4 flavour physical lc 8 port 4 splittable true lanes 4
>> pci/0000:01:00.0/57: type eth netdev enp1s0nl8p5 flavour physical lc 8 port 5 splittable true lanes 4
>> pci/0000:01:00.0/58: type eth netdev enp1s0nl8p6 flavour physical lc 8 port 6 splittable true lanes 4
>> pci/0000:01:00.0/59: type eth netdev enp1s0nl8p7 flavour physical lc 8 port 7 splittable true lanes 4
>> pci/0000:01:00.0/60: type eth netdev enp1s0nl8p8 flavour physical lc 8 port 8 splittable true lanes 4
>> pci/0000:01:00.0/61: type eth netdev enp1s0nl8p9 flavour physical lc 8 port 9 splittable true lanes 4
>> pci/0000:01:00.0/62: type eth netdev enp1s0nl8p10 flavour physical lc 8 port 10 splittable true lanes 4
>> pci/0000:01:00.0/63: type eth netdev enp1s0nl8p11 flavour physical lc 8 port 11 splittable true lanes 4
>> pci/0000:01:00.0/64: type eth netdev enp1s0nl8p12 flavour physical lc 8 port 12 splittable true lanes 4
>> pci/0000:01:00.0/125: type eth netdev enp1s0nl8p13 flavour physical lc 8 port 13 splittable true lanes 4
>> pci/0000:01:00.0/126: type eth netdev enp1s0nl8p14 flavour physical lc 8 port 14 splittable true lanes 4
>> pci/0000:01:00.0/127: type eth netdev enp1s0nl8p15 flavour physical lc 8 port 15 splittable true lanes 4
>> pci/0000:01:00.0/128: type eth netdev enp1s0nl8p16 flavour physical lc 8 port 16 splittable true lanes 4
>> 
>> To uprovision the slot #8:
>> 
>> $ devlink lc set pci/0000:01:00.0 lc 8 notype
>> 
>
>are there any changes from the last RFC?
>
>https://lore.kernel.org/netdev/20210122094648.1631078-1-jiri@resnulli.us/

Yes, many of them, I din't track them. Mainly, the RFC was backed by
netdevsim implementation, this is mlxsw with actual HW underneath.
