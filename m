Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6264A57B4F3
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 13:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbiGTLAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 07:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbiGTLAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 07:00:32 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C58023BFF
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 04:00:30 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id y4so23263380edc.4
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 04:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C4+HHnUIuB2/v0S+7mvaPyVjpmyHFc/HVYrgbDdX/ck=;
        b=xzdceVJuHTXh9s5fbz29KbEHKtIvl/0dZgD2GZY7UeIHA2LVoOD8DKJj5B6aoMqTWm
         JSejXaYonUpOlUESeSDFodEOQI56lWcZ7afAMgdKf9f/cx8nM4Cot4k64yxg/p3enQ9o
         DcGMR77GPOfvPl+XfJlfwgepy43AO4zqea6mk/rTZgjlAr+MFeCmAdGL0HUkbrSocXev
         KP9IZ+vENnoC/qiEUT60ZGFBHQhjiM347vU/EW75k+SdKnzd27fhw+BkO9ii0edR2GRq
         QWdVB4oBPDyoJ0tqGBJ2xDowzQYp7gXjvpDqTXrahi+TDleh1SfqDLUcLKw3xr3N1KDM
         u+Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C4+HHnUIuB2/v0S+7mvaPyVjpmyHFc/HVYrgbDdX/ck=;
        b=pRva7rhnZPKOlGagqqaTOvTTSgNtjHClmISkRcrCMDUZ40R6BmMuoWxfug7v0WAee0
         MGbPM/C9mllae31o9W6u1U3kcGGEOjakNcyX8GS3zyuNJ0oHriOvddLWfwY0j+nFB6TZ
         2IFVMDHSx9nluCmWLDYZyuc9qY9lZpYabicsZ0vleM7XK7j9Hr1gPQH5si5y4zZ8ekJ0
         CzsBmFioqQpZbiNBl9aeIuJkQHA0EXFD31c3TeMNHhxodURnbkHWcrgYABiwB3kMd1UK
         9vTY1KvEfjXRxwCJnm9Wr5hsF6qYvTNEAdrAefUDqjOQFVo5mVNu8ldTJqTxXgyyDyVD
         GSLQ==
X-Gm-Message-State: AJIora+9/xKTkasdVg1jvwe5uIrOEpMx50M74ffwUumwaw/wYZstvsPc
        kXR1YGDbSBQ8G58Yk83ebHUfAsqta/2rxfXo5RE=
X-Google-Smtp-Source: AGRyM1u+6mYq2PWgMsdUM4ZJtYa805Yi+PyS4tk0i01EQv3aAN1xSsEryMXZKp3cL26rA3Sy2aWZmA==
X-Received: by 2002:a50:fa91:0:b0:43a:4f13:4767 with SMTP id w17-20020a50fa91000000b0043a4f134767mr51052843edr.10.1658314828839;
        Wed, 20 Jul 2022 04:00:28 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id 8-20020a170906328800b0072f5fa175b2sm1323654ejw.8.2022.07.20.04.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 04:00:28 -0700 (PDT)
Date:   Wed, 20 Jul 2022 13:00:27 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 01/12] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Message-ID: <YtfgS09cFbQLpCBD@nanopsycho>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-2-jiri@resnulli.us>
 <YteyloM9mtRqCI0T@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YteyloM9mtRqCI0T@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 20, 2022 at 09:45:26AM CEST, idosch@nvidia.com wrote:
>On Tue, Jul 19, 2022 at 08:48:36AM +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Remove dependency on devlink_mutex during devlinks xarray iteration.
>
>Missing motivation... Need to explain that devlink_mutex is held
>throughout every user space command and that while issuing a reload and
>registering / unregistering auxiliary devlink instances we will
>deadlock on this mutex.

Fixed.


>
>> 
>> The devlinks xarray consistency is ensured by internally by xarray.
>
>s/by//

Fixed.


>
>> There is a reference taken when working with devlink using
>> devlink_try_get(). But there is no guarantee that devlink pointer
>> picked during xarray iteration is not freed before devlink_try_get()
>> is called.
>> 
>> Make sure that devlink_try_get() works with valid pointer.
>> Achieve it by:
>> 1) Splitting devlink_put() so the completion is sent only
>>    after grace period. Completion unblocks the devlink_unregister()
>>    routine, which is followed-up by devlink_free()
>> 2) Iterate the devlink xarray holding RCU read lock.
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
