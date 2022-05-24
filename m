Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184B6532C42
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 16:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238278AbiEXObz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 10:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238232AbiEXObx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 10:31:53 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31E141602
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 07:31:49 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id gh17so22706219ejc.6
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 07:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JmHkgCUTxFxrgfqJcmvDD3MoOGOVBWLqafzYTKj1s/c=;
        b=Nbp3fE/j8KC54kgw6PNaoXobwFgwC1x3u01siIrJ5EE1S5HmRaxEqsJjmEfpecEv5u
         jHrilvt+JrHjjA8YjBQzvr7iQ0trjC6XA+2G2UfcmI84p7wXDBwUWBr8QkT8xHEJvQo7
         ThkQQrovOTBDsrqwoee58kzp8jCdTUwcHYW1Ls7tDor4wGAJUSnh/j3tFDglH9IBJNAs
         x/aPU0O/nVtNHeNYQZE2nw4crp5hpIgQb5RMAZBwaM8Y0OufqwO/popSXvpemp+KoVaS
         nZ7qzqlge5iHYL2k0YPEi7f6fXn2amNmnc78jHGxSJFFHhD/ryKdEqBJfug+uTr+aZd8
         ZP9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JmHkgCUTxFxrgfqJcmvDD3MoOGOVBWLqafzYTKj1s/c=;
        b=BrPK2SpeQMQ1jFGzIK/NN9xpFk36Edc3FAS/6bqhiUSUdg+mZc7P0Tyh7EN0Q6Px13
         E9MJpM5xlaFfASnUe/Z5LU6Gw1dwf3ToG3k0sbg9yzthZmY8JKC/qamns9b8hySFdOZO
         /VLXyDEQgP8H2F7N2BPmPRDp+OtCQeX1afN7sdv/NDn5iPNhUVAJW1+r4NoTuzGCikeV
         qLpqDfXL4aX3Y8zNPmI/Ehetx6A3x+eLfrxT9BVM9LOlcKaezpSwwybzwaWJ8qf9+XAM
         fAbkkWcbqifpdHvOv+b2aXLBw8fzIUV49J3ZLaVipMU9JlurMRsPp+C/2gSe3WjYkyKb
         OOpA==
X-Gm-Message-State: AOAM533v2PxOlHXEFbWvAdTj9i5I+YS6ZwBqI09AazJRn3ukF9F8LVKi
        ApWMjJkpF2PCda9fsUzadbeoDA==
X-Google-Smtp-Source: ABdhPJwF8yu52r6pJ25ykEvWMhqvBkiVgUvkmfZ+2Ws9N/sL97eErDlrhqrwjyKVJDufQH//ZZ+Niw==
X-Received: by 2002:a17:907:3fa2:b0:6fe:d043:3fd1 with SMTP id hr34-20020a1709073fa200b006fed0433fd1mr10875080ejc.700.1653402707884;
        Tue, 24 May 2022 07:31:47 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ck7-20020a170906c44700b006fec63e564bsm3117075ejb.30.2022.05.24.07.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 07:31:46 -0700 (PDT)
Date:   Tue, 24 May 2022 16:31:45 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YozsUWj8TQPi7OkM@nanopsycho>
References: <20220427071447.69ec3e6f@kernel.org>
 <YmvRRSFeRqufKbO/@nanopsycho>
 <20220429114535.64794e94@kernel.org>
 <Ymw8jBoK3Vx8A/uq@nanopsycho>
 <20220429153845.5d833979@kernel.org>
 <YmzW12YL15hAFZRV@nanopsycho>
 <20220502073933.5699595c@kernel.org>
 <YotW74GJWt0glDnE@nanopsycho>
 <20220523105640.36d1e4b3@kernel.org>
 <Yox/TkxkTUtd0RMM@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yox/TkxkTUtd0RMM@nanopsycho>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 24, 2022 at 08:46:38AM CEST, jiri@resnulli.us wrote:
>Mon, May 23, 2022 at 07:56:40PM CEST, kuba@kernel.org wrote:
>>On Mon, 23 May 2022 11:42:07 +0200 Jiri Pirko wrote:
>>> Mon, May 02, 2022 at 04:39:33PM CEST, kuba@kernel.org wrote:
>>> >On Sat, 30 Apr 2022 08:27:35 +0200 Jiri Pirko wrote:  
>>> >> Now I just want to use this component name to target individual line
>>> >> cards. I see it is a nice fit. Don't you think?  
>>> >
>>> >Still on the fence.  
>>> 
>>> Why?
>>
>>IIRC my concern was mixing objects. We have component name coming from
>>lc info, but then use it in dev flash.
>
>Sure. I considered that. The thing is, even if you put the lc component
>names to output of "devlink dev info", you would need to provide lc
>objects as well (somehow) - to contain the versions.
>
>But the component name is related to lc object listed in "devlink lc",
>so "devlink lc info" sounds line the correct place to put it.
>
>If you are concern about "devlink dev flash" using component name from
>"devlink lc info", I would rather introduce "devlink lc flash" so you
>have a match. But from what I see, I don't really see the necessity for
>this match. Do you?

Okay, we can eventually avoid using component name at all for now,
considering one flash object per linecard (with possibility to extend by
component later on). This would look like:

$ devlink lc info pci/0000:01:00.0 lc 8
pci/0000:01:00.0:
  lc 8
    versions:
        fixed:
          hw.revision 0
	  fw.psid MT_0000000749
        running:
          ini.version 4
          fw 19.2010.1310

$ devlink lc flash pci/0000:01:00.0 lc 8 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2

I have to admit I like this.
We would reuse the existing DEVLINK_CMD_FLASH_UPDATE cmd and when
DEVLINK_ATTR_LINECARD_INDEX attribute is present, we call the lc-flash
op. How does this sound?


>
>
>>
>>> >> I see that the manpage is mentioning "the component names from devlink dev info"
>>> >> which is not actually implemented, but exactly what I proposed.  
>>> >
>>> >How do you tie the line card to the component name? lc8_dev0 from 
>>> >the flashing example is not present in the lc info output.  
>>> 
>>> Okay, I will move it there. Makes sense.
>>
>>FWIW I think I meant my comment as a way to underline that what you
>>argue for is not what's implemented (assuming your "not actually
>>implemented" referred to the flashing). I was trying to send you back 
>>to the drawing board rather than break open a box of band-aides.
>
>Sure, lets do this right, I don't want to band-aide anything...
