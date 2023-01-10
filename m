Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCEA26639BF
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 08:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjAJHM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 02:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjAJHMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 02:12:25 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F9C4731E
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 23:12:14 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id y1so12270891plb.2
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 23:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OrTX+hx8iWAVZ3UD+KlkgTsnY3OsfnugxRrevPEx7s8=;
        b=w7+PTGgqLU7CmvmRTqmGidyKRiT19jFSMWpG5g5zvaMqP4Xhv+dRVpRWOH0iTN1/wX
         zOAtGfHYbI4BHvD6/jqS23tyXVcW0ynC1VZmn4g6Y4wt3+xx3plP8cdfJ/YT3jiO0iBM
         JrqjnxR4IqHBr3zmNTsCfig3/DD/RWVM5KRCJVRZtscvp2bNqBBVCx4uB/5PpDc3sSyZ
         UhHT90SJuo+OYpqk+b9WrE4DRRFH4ZSdM9HXblu93ej6c4nLkMFh85NjiCVg00zzVDd0
         XEXzTTJpOaXNEmPdhCP9/2KujTnBRGUF0EDF8Et3pOvo2H+oryyE7WpktlHUplYGNltx
         mWCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OrTX+hx8iWAVZ3UD+KlkgTsnY3OsfnugxRrevPEx7s8=;
        b=AiXkgE8X7lUblHfH/jSvN/Q9xxzzIqqxMHGWQVnh8rnQRV4EcjBLwi/3P3oqfrNxor
         Qn69KD9Cl69bUv6R3qoiGLieJT6fM4MA5Z9xroLG0TKLMFjuHWOS2FCTf+Usv1qbiPWW
         doz/MvU6Cty/eLWrSk8ompAybcdzi1+pySdrfb5/9GMC59DQxVoK0AGu9jTIdKG1E97V
         veuht4n3L/NxozZKKJquEmDjmmGVstO/4JJbQd0XklxW3x73zjc1k+QmJqiEsTd8Pb3e
         jEuEib57HGbXGN7JRzNwDuoB3AXmA2u2GrekXQk0I/H9rUJuvzDfpFKQiZWcELzvucKg
         aDCg==
X-Gm-Message-State: AFqh2kpMeXcPBmud9uG2EJZz42ocE1oiiVL3zGukJgfnbmd/PuI3QN5s
        xfwwAeRz1bMcJHOlwHd57WteWg==
X-Google-Smtp-Source: AMrXdXsioKp+ZuoqUrF3K1SNg9sQ4CvWVVgLojXNfY6lwyccIfR9Y8g2BmgN83HqaCQAmu17iqL/bA==
X-Received: by 2002:a17:902:cf08:b0:192:5283:3096 with SMTP id i8-20020a170902cf0800b0019252833096mr73912539plg.56.1673334733455;
        Mon, 09 Jan 2023 23:12:13 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id q3-20020a17090311c300b001911e0af95dsm7231327plh.240.2023.01.09.23.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 23:12:12 -0800 (PST)
Date:   Tue, 10 Jan 2023 08:12:10 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v3 01/11] devlink: remove devlink features
Message-ID: <Y70PyuHXJZ3gD8dG@nanopsycho>
References: <20230109183120.649825-1-jiri@resnulli.us>
 <20230109183120.649825-2-jiri@resnulli.us>
 <20230109165500.3bebda0a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109165500.3bebda0a@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 10, 2023 at 01:55:00AM CET, kuba@kernel.org wrote:
>On Mon,  9 Jan 2023 19:31:10 +0100 Jiri Pirko wrote:
>> Note that mlx5 used this to enable devlink reload conditionally only
>> when device didn't act as multi port slave. Move the multi port check
>> into mlx5_devlink_reload_down() callback alongside with the other
>> checks preventing the device from reload in certain states.
>
>Right, but this is not 100% equivalent because we generate the
>notifications _before_ we try to reload_down:
>
>	devlink_ns_change_notify(devlink, dest_net, curr_net, false);
>	err = devlink->ops->reload_down(devlink, !!dest_net, action, limit, extack);
>	if (err)
>		return err;
>
>IDK why, I haven't investigated.

Right, but that is done even in other cases where down can't be done. I
I think there's a bug here, down DEL notification is sent before calling
down which can potentially fail. I think the notification call should be
moved after reload_down() call. Then the bahaviour would stay the same
for the features case and will get fixed for the reload_down() reject
cases. What do you think?
