Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C712227FD3
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 14:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729944AbgGUMTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 08:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbgGUMTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 08:19:46 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC71BC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 05:19:45 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id r12so20895325wrj.13
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 05:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8mBfzMys2tB0ms3cMyQcDPl1KQkA0T16UWeGV/Gqdkg=;
        b=uVvBZi3vPvn8hk6R40rlluinH98QzRwY4pdji4J1IpNj62hT27RKDzlYIC25b5oACN
         KDYsKJDmrMOXdTX+ugcIGsZkjxUrYUmBCdpAfE/pzGeMjkoU38MPYwpEPBBsRatLoF9c
         BXVWeh+rV4WWlIDogIvu5UIjxdnO12DOOXxStgqRB6jzlskA31A9jO/T5t8fagH7eZVz
         riu8LtDY6UmOIxBcTND/7kldvt6UDItlOVA/HAeytT72AZ3qzjZ2G9SwwFMkTWXTq2Fp
         fAWvCTjFClkR77y+jxRQ4NMgPcSeXDf15v17E35I9Ciig8G0W+ILbtwPMcZaqkzqaXfm
         qyGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8mBfzMys2tB0ms3cMyQcDPl1KQkA0T16UWeGV/Gqdkg=;
        b=l5F1XnaVqz6Vedf7mh30kDgJoZI9O5kmv6Rt3c+KEq0QY0u5tx4TP9ST7cdRfdFhXz
         BbJghIH8gz2npYzMPkxn6+PoPTjTCEmZJAvla3L0fKFEOXITg5dBNKAg8JK1q8FiZNlD
         gH3s3o878+6fVrLzsEXJGMN3lu0QyetDCYtSORKr14H600W+kbZAkjng2VTmYZI1qZib
         Njb2LXOmvqttEv8dLTPhmLrnywY3ppsiUw2Jx0yYGlcH8jgw1LQXektJ7+yj4N6lBFr4
         yTDM4GPeY4ew6YNGo7wUKxg/LZqB7+OgJZA42d6izl5KS4d6R3C4j4ufJNYMP2uTn8gj
         bEhA==
X-Gm-Message-State: AOAM531Ji2T4pITViVFDQA8Eo46Q1MzpbBN9yZWYeh48UgFBvCRRbpr1
        ubjQQmffqi/ax5Q6gorgqIcSZxijVMU=
X-Google-Smtp-Source: ABdhPJyNbKcn1j6l26KKvl1DAqP37PsZPw54+07Em7B0iNghPEnCY/cEOrxao0sptF6ivo8ulZAWoA==
X-Received: by 2002:adf:e98c:: with SMTP id h12mr5335972wrm.3.1595333984616;
        Tue, 21 Jul 2020 05:19:44 -0700 (PDT)
Received: from localhost (ip-89-103-111-149.net.upcbroadband.cz. [89.103.111.149])
        by smtp.gmail.com with ESMTPSA id m9sm3087652wml.45.2020.07.21.05.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 05:19:44 -0700 (PDT)
Date:   Tue, 21 Jul 2020 14:19:43 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Moshe Shemesh <moshe@mellanox.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [RFC v2 net-next] devlink: Add reset subcommand.
Message-ID: <20200721121943.GA2205@nanopsycho>
References: <1593516846-28189-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200630125353.GA2181@nanopsycho>
 <CAACQVJqxLhmO=UiCMh_pv29WP7Qi4bAZdpU9NDk3Wq8TstM5zA@mail.gmail.com>
 <20200701055144.GB2181@nanopsycho>
 <CAACQVJqac3JGY_w2zp=thveG5Hjw9tPGagHPvfr2DM3xL4j_zg@mail.gmail.com>
 <20200701094738.GD2181@nanopsycho>
 <CAACQVJqjE-N4M0hLuptdicpfgRxV6ZhdYm0+zxjnzP=tndHUpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAACQVJqjE-N4M0hLuptdicpfgRxV6ZhdYm0+zxjnzP=tndHUpA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 21, 2020 at 11:51:21AM CEST, vasundhara-v.volam@broadcom.com wrote:
>On Wed, Jul 1, 2020 at 3:17 PM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Wed, Jul 01, 2020 at 11:25:50AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >On Wed, Jul 1, 2020 at 11:21 AM Jiri Pirko <jiri@resnulli.us> wrote:
>> >>
>> >> Tue, Jun 30, 2020 at 05:15:18PM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >> >On Tue, Jun 30, 2020 at 6:23 PM Jiri Pirko <jiri@resnulli.us> wrote:
>> >> >>
>> >> >> Tue, Jun 30, 2020 at 01:34:06PM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >> >> >Advanced NICs support live reset of some of the hardware
>> >> >> >components, that resets the device immediately with all the
>> >> >> >host drivers loaded.
>> >> >> >
>> >> >> >Add devlink reset subcommand to support live and deferred modes
>> >> >> >of reset. It allows to reset the hardware components of the
>> >> >> >entire device and supports the following fields:
>> >> >> >
>> >> >> >component:
>> >> >> >----------
>> >> >> >1. MGMT : Management processor.
>> >> >> >2. DMA : DMA engine.
>> >> >> >3. RAM : RAM shared between multiple components.
>> >> >> >4. AP : Application processor.
>> >> >> >5. ROCE : RoCE management processor.
>> >> >> >6. All : All possible components.
>> >> >> >
>> >> >> >Drivers are allowed to reset only a subset of requested components.
>> >> >>
>> >> >> I don't understand why would user ever want to do this. He does not care
>> >> >> about some magic hw entities. He just expects the hw to work. I don't
>> >> >> undestand the purpose of exposing something like this. Could you please
>> >> >> explain in details? Thanks!
>> >> >>
>> >> >If a user requests multiple components and if the driver is only able
>> >> >to honor a subset, the driver will return the components unset which
>> >> >it is able to reset.  For example, if a user requests MGMT, RAM and
>> >> >ROCE components to be reset and driver resets only MGMT and ROCE.
>> >> >Driver will unset only MGMT and ROCE bits and notifies the user that
>> >> >RAM is not reset.
>> >> >
>> >> >This will be useful for drivers to reset only a subset of components
>> >> >requested instead of returning error or silently doing only a subset
>> >> >of components.
>> >> >
>> >> >Also, this will be helpful as user will not know the components
>> >> >supported by different vendors.
>> >>
>> >> Your reply does not seem to be related to my question :/
>> >I thought that you were referring to: "Drivers are allowed to reset
>> >only a subset of requested components."
>> >
>> >or were you referring to components? If yes, the user can select the
>> >components that he wants to go for reset. This will be useful in the
>> >case where, if the user flashed only a certain component and he wants
>> >to reset that particular component. For example, in the case of SOC
>> >there are 2 components: MGMT and AP. If a user flashes only
>> >application processor, he can choose to reset only application
>> >processor.
>>
>> We already have notion of "a component" in "devlink dev flash". I think
>> that the reset component name should be in-sync with the flash.
>>
>> Thinking about it a bit more, we can extend the flash command by "reset"
>> attribute that would indicate use wants to do flash&reset right away.
>>
>> Also, thinking how this all aligns with "devlink dev reload" which we
>> currently have. The purpose of it is to re-instantiate driver instances,
>> but in case of mlxsw it means friggering FW reset as well.
>>
>> Moshe (cced) is now working on "devlink dev reload" extension that would
>> allow user to ask for a certain level of reload: driver instances only,
>> fw reset too, live fw patching, etc.
>>
>> Not sure how this overlaps with your intentions. I think it would be
>> great to see Moshe's RFC here as well so we can aligh the efforts.
>Are the patches posted yet?

I don't think so.

Moshe?

