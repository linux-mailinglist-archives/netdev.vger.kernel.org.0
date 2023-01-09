Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C165866206C
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 09:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236745AbjAIImf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 03:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236820AbjAIImU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 03:42:20 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F87F263B
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 00:42:20 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id o13so4520230pjg.2
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 00:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NJwadrY+D6HJt0k/5q3XmcWHdu7zbfqAEwy5DPmoebQ=;
        b=g5uE6/FzufnyovB3z1jwgyn/N1QhVh7kFVw+WgMIFaxAA4Y05JRBWJS2VnTHONud9k
         6J9/bU5vKXIrPa+kJ2MPYKjYoA2cMzfjxC4wKgtieyNAT4TU/E4rTJCUsYLJyIWLX/xV
         J8GIT2NSCdY7r6CLVTabbSlUikB2DfoMmvYTpKNFRl85mMVY3hUx5AF3Xsla2Rh0IO+8
         ImxbIrr9qwcJ7VHQd88fpLKgtm4sZSXIC53GbH9FvP7buiQWKY6y56y/pv7/iIqY53ni
         Uc28dsxmEHZKyIyNH/XUmbWol6nuTGH/lIWEPb6zai3DRtkGTjf9qr9XMXWwZo/m9lO+
         Alqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NJwadrY+D6HJt0k/5q3XmcWHdu7zbfqAEwy5DPmoebQ=;
        b=Yyi8ZaJR6W4pflBQ6SJTNn7T9Co9rEq1c/Snr04QhLQcVHbyCklo8fXD9I2qG/9Luo
         OnVvHRXxZzoEFStz0dc4cTiNNqU4J4whLOmsyUii6j/6R/ooAZXRA1tG9V5br/fg5pBz
         95W1CU7/FJx3EVw/OOFZtUPZord9+46NT4Yy0cq1i3HFOw3b0QdSbNbx9eyZAWSonVCm
         gdMJxdR+hHWO0SMUhgJJIqwX+mgcjjZxw31U9/5s+bkW5qvT1KsE8H+9S/KhUrg3Luqt
         NsD+OEfDo+NoXhaigmxr6GSbE+ipHEdjoOdVpSFDtIwBv8MD+7Qzw0l8DgH4AYP/8nGW
         2zYA==
X-Gm-Message-State: AFqh2kq142zzzr79PrmTdhMnIbnQUReJ0LgsiK4kvmitQk/sGNzxlwEx
        pVHLh/5apSNzRBy/MUf0Po6lkw==
X-Google-Smtp-Source: AMrXdXttOhFtCm9vqNhQURXNCvAD7Rk4tB7AzsJa0JpXnzaS+xhWFKzAZWOFw39foU+DkgDSRo/4Gg==
X-Received: by 2002:a05:6a20:3c93:b0:9d:efbe:a113 with SMTP id b19-20020a056a203c9300b0009defbea113mr84135639pzj.35.1673253739634;
        Mon, 09 Jan 2023 00:42:19 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id q18-20020a170902bd9200b00186b7443082sm5508686pls.195.2023.01.09.00.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 00:42:19 -0800 (PST)
Date:   Mon, 9 Jan 2023 09:42:16 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v2 3/9] devlink: remove linecard reference
 counting
Message-ID: <Y7vTaOHx+/AHZepR@nanopsycho>
References: <20230107101151.532611-1-jiri@resnulli.us>
 <20230107101151.532611-4-jiri@resnulli.us>
 <Y7rmTO+Pf2QIM/sN@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7rmTO+Pf2QIM/sN@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jan 08, 2023 at 04:50:36PM CET, idosch@nvidia.com wrote:
>On Sat, Jan 07, 2023 at 11:11:44AM +0100, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> As long as the linecard live time is protected by devlink instance
>
>s/live/life/
>
>> lock, the reference counting is no longer needed. Remove it.
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>>  net/devlink/leftover.c | 14 ++------------
>>  net/devlink/netlink.c  |  5 -----
>>  2 files changed, 2 insertions(+), 17 deletions(-)
>
>devlink_linecard_put() needs to be removed from
>net/devlink/devl_internal.h

Missed this. Fixed.
