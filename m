Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784AD6655F7
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 09:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbjAKIX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 03:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbjAKIX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 03:23:28 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE121000
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 00:23:27 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id c9so10831783pfj.5
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 00:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/MzsfDCeDeadN331AwqKYc1pcPgQNKIBIX5x5onQ+6k=;
        b=HK+0zB0aQm7Vu21wzVpHZH/NvVPe+s+ao9+Ifh9F0tNg3DCkb6z/nqe2A1msvxxgcT
         SUUk3kGo3Ajr4xyj78dG6D/sjxM673cUj1g7Geei7vMItT/XuAabAVMCdHNxEG2RIDQ3
         /v4P1bO5n15rCpbktkCaK/Zq2yJRTv7JKwJDtbECm2o79O7YkHU1m0L0VTZBzBuSqfxl
         SMx76B45sco85TdirjjiBIqww/dkuHxPJTLrpJk1PfMXYVgUwa4qVeSnMWxgGkZAuoIK
         OZJI868jIQrVaV3LDOqjuVorh/EmitKuxceojvYh2yhvPiNsZZjJRDS3cGm18SwW55DC
         PLsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/MzsfDCeDeadN331AwqKYc1pcPgQNKIBIX5x5onQ+6k=;
        b=KjNC76C3ZVuvrgO25RsVO3wVqts6eboESJMrAr3J+ePKsimQQisrFsWhn3NJJ/L+hN
         O37FvOXtPuu1fSyNsGLU/4skN7aI35/cpHjUToGMkGBTeh4vEKYt+oOpXnZvaPfwyeGo
         GX5Na8VH3KIDRvd8aq6oJjfJ/RHJl+JC8h2nbC4qfd7oyxprclKAxWChu9sjBBDFWghK
         c004VF4fj4i1LeW+nvZqVQ79+GivpbAp/sSw+OE8Gt2JCECk/6nVE3f33mriWq1lrvOs
         +f6Od44icJUNodiLzfGha1Kiwym7lGn9NfzWDwhM8BjdCbgMKav1ey9pXBZjxMY1FHLH
         cEEA==
X-Gm-Message-State: AFqh2kom+owG81pfvdSigvDhWQ0MZpEr/5kiCfSqcIQNW0yGq4ywJPIC
        bDYjNE76JE9AnR6aKInLseKKZQ==
X-Google-Smtp-Source: AMrXdXsyvFJYoCBTFyOWiBvcBUwZl7AVm+0OdUlsOMNXQYQz1UjFYGOaUKHpXKXaxhfEqrUPGhGHWw==
X-Received: by 2002:a62:a514:0:b0:580:8c2c:d0ad with SMTP id v20-20020a62a514000000b005808c2cd0admr62429819pfm.13.1673425406496;
        Wed, 11 Jan 2023 00:23:26 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id m190-20020a6258c7000000b005821c109cebsm4809842pfb.199.2023.01.11.00.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 00:23:26 -0800 (PST)
Date:   Wed, 11 Jan 2023 09:23:23 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        michael.chan@broadcom.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, tariqt@nvidia.com, saeedm@nvidia.com,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v3 01/11] devlink: remove devlink features
Message-ID: <Y75x+1+z4VzBx/ip@nanopsycho>
References: <20230109183120.649825-1-jiri@resnulli.us>
 <20230109183120.649825-2-jiri@resnulli.us>
 <20230109165500.3bebda0a@kernel.org>
 <Y70PyuHXJZ3gD8dG@nanopsycho>
 <20230110125915.62d428fb@kernel.org>
 <Y75nBEpxIWrDj9mF@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y75nBEpxIWrDj9mF@unreal>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 11, 2023 at 08:36:36AM CET, leon@kernel.org wrote:
>On Tue, Jan 10, 2023 at 12:59:15PM -0800, Jakub Kicinski wrote:
>> On Tue, 10 Jan 2023 08:12:10 +0100 Jiri Pirko wrote:
>> >> Right, but this is not 100% equivalent because we generate the
>> >> notifications _before_ we try to reload_down:
>> >>
>> >>	devlink_ns_change_notify(devlink, dest_net, curr_net, false);
>> >>	err = devlink->ops->reload_down(devlink, !!dest_net, action, limit, extack);
>> >>	if (err)
>> >>		return err;
>> >>
>> >> IDK why, I haven't investigated.  
>> > 
>> > Right, but that is done even in other cases where down can't be done. I
>> > I think there's a bug here, down DEL notification is sent before calling
>> > down which can potentially fail. I think the notification call should be
>> > moved after reload_down() call. Then the bahaviour would stay the same
>> > for the features case and will get fixed for the reload_down() reject
>> > cases. What do you think?
>> 
>> I was gonna say that it sounds reasonable, and that maybe we should 
>> be in fact using devlink_notify_register() instead of the custom
>> instance-and-params-only devlink_ns_change_notify().
>> 
>> But then I looked at who added this counter-intuitive code
>> and found out it's for a reason - see 05a7f4a8dff19.
>> 
>> So you gotta check if mlx5 still has this problem...
>
>I don't see anything in the tree what will prevent the issue
>which I wrote in 05a7f4a8dff19.

Okay. I will remove this patch from the set and address this in a
separate patchset. Thanks!

>
>Thanks
