Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1572954D031
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 19:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239292AbiFORkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 13:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiFORki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 13:40:38 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586C0532EA
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 10:40:37 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id n28so17234218edb.9
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 10:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4eiUeAAPX7zy2PViAPng7Kd3iSU3Bj3nzFAkQ7gEdnQ=;
        b=mbVWG8/wpqm6H2r2kSN0f6oAArDWzb64o5e613+7lZcptgCONIFE1NgpcMXkbpr417
         2kIC28Qa4ZC8W97PPxfi300vD4PH2Eaxtys682+eJDMRddWklFnk8VvYCjZyBQQcr7+H
         ok+jwReY5S69Qzd5tnpA0da3fIUY4MeNyu/C3ljICDckmd3y8ltRWIM4+axsdKGFftZ7
         MLXau/rnVOsDDZdE1W7XMFITsSNtbPJMRlbHVd/CqK82xIlhVjfTcqCd49ar4B48VG/e
         KqkYJR3ldm90esGDTsOCSoz/CzefxdOXiNXTCPLqe0+Yuc80DxwU57TUvEs5aL1REwne
         IDuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4eiUeAAPX7zy2PViAPng7Kd3iSU3Bj3nzFAkQ7gEdnQ=;
        b=dX++gGz769DSFnvvPTgeb/shWk3tuDEYcsUXzviOQSgkzJ7yACOILK2zCM9G/deuL2
         yI9PClNhuEwSW0AamUulXuFKKBQjqWLvZoEdaw2yS6oZ/HjHNv/lN683B5FhvBadsmqJ
         lCd2xDGq9l+xHL2LLLYFI0kY5v3ZploVcjfW2Gk0EZGOXMdpVJkUKa4ux74rg9eWgIPE
         iHqT8oo2wOLVX4c69sZkishceZji+X1ZlX4/1CieiAWyh9xWdzU4OAY3JKAQ/Igouy2t
         AZOiVNa8VFyXSpDULf8FlKtqxNAW6hvoZp4LFPKj9SuB93Nr3DK6D2ru5y/eglJkxF/z
         2wqA==
X-Gm-Message-State: AJIora/fE70XobpzgyiiB7qDQdllofOGmhWIzmm5g7Rl/AM5ULcwLuHs
        KoMUMry+AKLCpr0eEnaPX6UkRg==
X-Google-Smtp-Source: AGRyM1vditfXoPujm9+Oww2GTwkNKAWLIHKKx3kviWYIzBTKo3Yy/6ZcY5V1OKeMwHKaigawX/fX0w==
X-Received: by 2002:a05:6402:3490:b0:42f:b592:f364 with SMTP id v16-20020a056402349000b0042fb592f364mr1158245edc.66.1655314835862;
        Wed, 15 Jun 2022 10:40:35 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id m6-20020a50cc06000000b0042dcdfb003esm9702507edi.53.2022.06.15.10.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 10:40:35 -0700 (PDT)
Date:   Wed, 15 Jun 2022 19:40:34 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next 00/11] mlxsw: Implement dev info and dev flash
 for line cards
Message-ID: <YqoZkqwBPoX5lGrR@nanopsycho>
References: <20220614123326.69745-1-jiri@resnulli.us>
 <Yqmiv2+C1AXa6BY3@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yqmiv2+C1AXa6BY3@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jun 15, 2022 at 11:13:35AM CEST, idosch@nvidia.com wrote:
>On Tue, Jun 14, 2022 at 02:33:15PM +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> This patchset implements two features:
>> 1) "devlink dev info" is exposed for line card (patches 3-8)
>> 2) "devlink dev flash" is implemented for line card gearbox
>>    flashing (patch 9)
>> 
>> For every line card, "a nested" auxiliary device is created which
>> allows to bind the features mentioned above (patch 2).
>
>The design choice to use an auxiliary device for each line card needs to
>be explained in the cover letter. From what I can tell, the motivation
>is to reuse the above devlink uAPI for line cards as opposed to using
>the "component" attribute or adding new uAPI. This is achieved by
>creating a devlink instance for each line card. The auxiliary device is
>needed because each devlink instance is expected to be associated with a
>device. Does this constitute proper use of the auxiliary bus?

Right, will describe this in cover letter.


>
>> 
>> The relationship between line card and its auxiliary dev devlink
>> is carried over extra line card netlink attribute (patches 1 and 3).
>> 
>> Examples:
>> 
>> $ devlink lc show pci/0000:01:00.0 lc 1
>> pci/0000:01:00.0:
>>   lc 1 state active type 16x100G nested_devlink auxiliary/mlxsw_core.lc.0
>
>Can we try to use the index of the line card as the identifier of the
>auxiliary device?

Not really. We would have a collision if there are 2 mlxsw instances.


>
>>     supported_types:
>>        16x100G
>> 
>> $ devlink dev show auxiliary/mlxsw_core.lc.0
>> auxiliary/mlxsw_core.lc.0
>
>I assume that the auxiliary device cannot outlive line card. Does that
>mean that as part of reload of the primary devlink instance the nested
>devlink instance is removed? If so, did you check the reload flow with
>lockdep to ensure there aren't any problems?

As I wrote in the other email, line card auxdev should be removed during
linecard_fini(), will add that to v2.


>
>> 
>> $ devlink dev info auxiliary/mlxsw_core.lc.0
>> auxiliary/mlxsw_core.lc.0:
>>   versions:
>>       fixed:
>>         hw.revision 0
>>         fw.psid MT_0000000749
>>       running:
>>         ini.version 4
>>         fw 19.2010.1312
>> 
>> $ devlink dev flash auxiliary/mlxsw_core.lc.0 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2
>
>How is this firmware activated? It is usually done after reload, but I
>don't see reload implementation for the line card devlink instance.

Currently, only devlink dev reload of the whole mlxsw instance or
unprovision/provision of a line card.

>
>> 
>> Jiri Pirko (11):
>>   devlink: introduce nested devlink entity for line card
>>   mlxsw: core_linecards: Introduce per line card auxiliary device
>>   mlxsw: core_linecard_dev: Set nested devlink relationship for a line
>>     card
>>   mlxsw: core_linecards: Expose HW revision and INI version
>>   mlxsw: reg: Extend MDDQ by device_info
>>   mlxsw: core_linecards: Probe provisioned line cards for devices and
>>     expose FW version
>>   mlxsw: reg: Add Management DownStream Device Tunneling Register
>>   mlxsw: core_linecards: Expose device PSID over device info
>>   mlxsw: core_linecards: Implement line card device flashing
>>   selftests: mlxsw: Check line card info on provisioned line card
>>   selftests: mlxsw: Check line card info on activated line card
>> 
>>  Documentation/networking/devlink/mlxsw.rst    |  24 ++
>>  drivers/net/ethernet/mellanox/mlxsw/Kconfig   |   1 +
>>  drivers/net/ethernet/mellanox/mlxsw/Makefile  |   2 +-
>>  drivers/net/ethernet/mellanox/mlxsw/core.c    |  44 +-
>>  drivers/net/ethernet/mellanox/mlxsw/core.h    |  35 ++
>>  .../mellanox/mlxsw/core_linecard_dev.c        | 180 ++++++++
>>  .../ethernet/mellanox/mlxsw/core_linecards.c  | 403 ++++++++++++++++++
>>  drivers/net/ethernet/mellanox/mlxsw/reg.h     | 173 +++++++-
>>  include/net/devlink.h                         |   2 +
>>  include/uapi/linux/devlink.h                  |   2 +
>>  net/core/devlink.c                            |  42 ++
>>  .../drivers/net/mlxsw/devlink_linecard.sh     |  54 +++
>>  12 files changed, 948 insertions(+), 14 deletions(-)
>>  create mode 100644 drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
>> 
>> -- 
>> 2.35.3
>> 
