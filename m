Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF156662094
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 09:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234070AbjAIIvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 03:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234147AbjAIIuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 03:50:18 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC31175B8
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 00:44:25 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d9so8745349pll.9
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 00:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C3ut7IeFEVyxT8k+RiaqPVnHnGMcfIVVOFwK2EZxKLc=;
        b=h7aOg1RUuewuLfXfUMRYJmS+slA9z/Sg6ZWyr4DMhUqYTyqd+fj/iDCFunDTGiTIOr
         FHmSkNbOOi4BR+GTpkidh0Pk4WFh4vecNDR9d0WfphTAuL67Vcf3emdFCpjhPuI+pkL0
         ibzllDsZgLLPyMl2apyReLU1ldY51BmIkWAp3DFMprV1YiQ0VDO2NxRf/Kphgnb1MgE1
         ElySEyFeKLIJ5WHgoHzSjEz6gk9b/ZM6uh5zeRREn4gYfH6zFtq3mQY0U5j6Syf2u7Ka
         FEBlgGzroGmyBUxh5wbLeBsWKMJbhxXLn82uDLhh2184L5MQmZ9G/7l0ibshmB74R6nS
         f1FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C3ut7IeFEVyxT8k+RiaqPVnHnGMcfIVVOFwK2EZxKLc=;
        b=1p9voKhg155fBz3cBXzIVfeVQyrDJcxw8TZ/TTXeOsEUWRt9Jp7D8Y1xFOM4rNuhRQ
         8YFFxq1osgCexgUnFaoYvI2ej2oGdgdzko2xoEewEdS8FfQ4nOrNudoDueCTAUxpYbyY
         XURdburydB20kfLj/nTSQJfXs8dwfXjKYcW0aRb3hqI8C9WDJoY6tFMzxNPQXhuhOr5G
         e8jkDVAMYq2A0G56Cqopx4tV550CX+/UcaAfFlEBNwj2J+zAgHr0839m+y5EZ5JZzO2w
         CNIA1rUlweOHx38177rxCcniIvC/dBgVlFw/vBGznQtzLbz7Jh1V4sisgPt91XejsDPQ
         lYiw==
X-Gm-Message-State: AFqh2kpztbzTdGoJDQepf35dFdtCsu1HnkBlhPWLRx+0S+oBjhy0ZqZB
        OnEA9Yo9fTUROVoJeAia3zkd9Q==
X-Google-Smtp-Source: AMrXdXsbqRanJ6uypQHYfoG+zca4lzjeuKaVaND7yFuK9rXJxtnYIE8lSkDlC2fbKY4Yk9n8Cxd+qA==
X-Received: by 2002:a17:902:7488:b0:193:27da:e61d with SMTP id h8-20020a170902748800b0019327dae61dmr5079064pll.68.1673253851823;
        Mon, 09 Jan 2023 00:44:11 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id q6-20020a17090311c600b00186985198a4sm5507829plh.169.2023.01.09.00.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 00:44:11 -0800 (PST)
Date:   Mon, 9 Jan 2023 09:44:08 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v2 4/9] devlink: remove reporters_lock
Message-ID: <Y7vT2IwhmJ5PK6F1@nanopsycho>
References: <20230107101151.532611-1-jiri@resnulli.us>
 <20230107101151.532611-5-jiri@resnulli.us>
 <Y7rvQkoatRhKMwGI@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7rvQkoatRhKMwGI@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jan 08, 2023 at 05:28:50PM CET, idosch@nvidia.com wrote:
>On Sat, Jan 07, 2023 at 11:11:45AM +0100, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Similar to other devlink objects, convert the reporters list to be
>> protected by devlink instance lock. Alongside add unlocked versions
>> of health reporter create functions and remove port-specific destroy
>> function which is no longer needed.
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>>  .../ethernet/mellanox/mlx5/core/en/health.c   |  12 ++
>>  .../mellanox/mlx5/core/en/reporter_rx.c       |   6 +-
>>  .../mellanox/mlx5/core/en/reporter_tx.c       |   6 +-
>>  drivers/net/ethernet/mellanox/mlxsw/core.c    |   8 +-
>>  drivers/net/netdevsim/health.c                |  20 +--
>>  include/net/devlink.h                         |  20 +--
>>  net/devlink/core.c                            |   2 -
>>  net/devlink/devl_internal.h                   |   1 -
>>  net/devlink/leftover.c                        | 131 +++++++-----------
>>  9 files changed, 96 insertions(+), 110 deletions(-)
>
>This is quite difficult to review because there are multiple changes
>squashed into one patch:
>
>1. Addition of locked versions of both device and port health reporter
>while refactoring the code to share code paths.
>
>2. Removal of the reporters mutex.
>
>3. Partial conversion of drivers to use the locked APIs. The conversion
>of mlxsw and netdevsim is trivial because they hold the instance lock
>during probe, but the conversion of mlx5 is less trivial. I would split
>it into a separate patch.

Yeah, I was thinking about splitting this, however since the new lock
needs to be used on locked path with different helpers, it is not easy
to find a good split, was a bit lazy to do that. Anyway, let me think
and try again. Thanks!
