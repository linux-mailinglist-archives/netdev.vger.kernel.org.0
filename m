Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A436D662062
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 09:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236860AbjAIIm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 03:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233481AbjAIImA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 03:42:00 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B89B855
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 00:41:58 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id fz16-20020a17090b025000b002269d6c2d83so10850981pjb.0
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 00:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YpKakUQ3gSCj+znDO5qzszRfuE3ARCftWs9dvcbaDe8=;
        b=Ak+PuZqTXuE8pe28dwC/hV/VlWnqgit1y8Qr6OsePaKk+6Hqko9P+X3Ydgg/v1u+W8
         bBCZlSolFL4nCrCUEGXctS+xWigDjD0WAqLoBuHYZXolyadpZJs4mNha25lVjk33xmb9
         6t6DWrg0eZ/PIBs7FwgX/zZdiSuUvMfEkCmMalIq0wrOSV0X/e8SMLGUjflVPu7+upKz
         cyBmj0s18ru93ZECwAFkuEun5AWu80AMbEwGwiQxUwc/0J75bMDQlsUXhsJSKxlDT822
         /yt7iEx8vDtfouxWWpLSh6cJn7GdHwZdJBptNApgMj7h9G+mo3FET8dsZF1mYGSHIKOQ
         aYog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YpKakUQ3gSCj+znDO5qzszRfuE3ARCftWs9dvcbaDe8=;
        b=0pAa/CZ+rIc0nIfz6dnQFdKh3wghkvIRjNPnK1VVyCC5SwUApJBwBlygOZRk5f9tea
         PufW1YVriSWCUdUpCh/HMwFb93lNDTSrB8Fa90uQwRA1sug3IV2If9UkVOk4Df/Uj/dK
         goK/z8XMpqZNcAM1nq4svxz5hktAbzyLhoMMa3Ag2W4FOhXhpJFFKqf6nS7UkodgX9Y7
         Wn1fMxFWBvoixBB/6u1DGZKbkEavJWUhuFYT4ZcTZ6poyK4pQ/yh4Alosby4LjEqQSoo
         nGAyrTDV2DAQwSNBCoLyRWAnafAEGzo+q+2Q9n8bLESadvXI8GK/zWXz3SCIIZIQyyY8
         MFEw==
X-Gm-Message-State: AFqh2kqN0GWss2DE3wDYLrOGTMEzRskmHcW3OmHaeAxpO+XakjOpIWmN
        qngqc8YUZFp2vQreK2qiCQtkHw==
X-Google-Smtp-Source: AMrXdXtjU4NGOw1JAVx8iHE0wB4E48fgN+ICMmCoJVIUkqxyU01uMm12dxiImJCzp6MFSM95E1I9MQ==
X-Received: by 2002:a17:902:a406:b0:18c:1bc5:bd58 with SMTP id p6-20020a170902a40600b0018c1bc5bd58mr68179805plq.9.1673253718245;
        Mon, 09 Jan 2023 00:41:58 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id u9-20020a170902e80900b00189758e2b99sm5559994plg.92.2023.01.09.00.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 00:41:57 -0800 (PST)
Date:   Mon, 9 Jan 2023 09:41:54 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v2 1/9] devlink: remove devlink features
Message-ID: <Y7vTUqyI/LdMNPdL@nanopsycho>
References: <20230107101151.532611-1-jiri@resnulli.us>
 <20230107101151.532611-2-jiri@resnulli.us>
 <Y7rh/PvtBOY6hRuy@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7rh/PvtBOY6hRuy@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jan 08, 2023 at 04:32:12PM CET, idosch@nvidia.com wrote:
>On Sat, Jan 07, 2023 at 11:11:42AM +0100, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Devlink features were introduced to disallow devlink reload calls of
>> userspace before the devlink was fully initialized. The reason for this
>> workaround was the fact that devlink reload was originally called
>> without devlink instance lock held.
>> 
>> However, with recent changes that converted devlink reload to be
>> performed under devlink instance lock, this is redundant so remove
>> devlink features entirely.
>> 
>> Note that mlx5 used this to enable devlink reload conditionally only
>> when device didn't act as multi port slave. Move the multi port check
>> into mlx5_devlink_reload_down() callback alongside with the other
>> checks preventing the device from reload in certain states.
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>>  .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  1 -
>>  .../hisilicon/hns3/hns3pf/hclge_devlink.c     |  1 -
>>  .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |  1 -
>>  drivers/net/ethernet/intel/ice/ice_devlink.c  |  1 -
>>  drivers/net/ethernet/mellanox/mlx4/main.c     |  1 -
>>  .../net/ethernet/mellanox/mlx5/core/devlink.c |  9 +++++----
>>  drivers/net/ethernet/mellanox/mlxsw/core.c    |  1 -
>>  drivers/net/netdevsim/dev.c                   |  1 -
>>  net/devlink/core.c                            | 19 -------------------
>>  net/devlink/devl_internal.h                   |  1 -
>>  net/devlink/leftover.c                        |  3 ---
>>  11 files changed, 5 insertions(+), 34 deletions(-)
>
>devlink_set_features() needs to be removed from include/net/devlink.h as
>well

Missed this. Fixed.

