Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C167583A8B
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 10:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbiG1Iqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 04:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbiG1Iqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 04:46:35 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEF113D29
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 01:46:33 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id v17so1270551wrr.10
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 01:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qZcMYCh7Sif1qWuZEL6tY48/pEN0AlQQi7iaVP3n73A=;
        b=uSEHSyrjxJ7gaeIns3aXu3DEtcW5SJSd3d5XDdXqVsDaZelOGbtgdCLb0rj8kosa0U
         JYVEic4FR+loiuiqzqduJHQ0ncJrkHnKCt5QFHd23AzSO5LvieASJUFQGuiImlwwS7Vo
         H1hkZYdr7Vxt8jt5XgdbO0cFBvgMK5sKSbeJaWcxo5+CZYexwgmvf0pWKsw6K7P0cPdv
         IOghTrO3r1KpywaplBJlt8vYVp++dMaNrsg0YdRndq1YwonRpMbNKWfKmb/zQ6AQbn1x
         6aSuJbQuQtx2+MlYus9bs8Efw7Gbc3mDsAaQ9gY1wZcxE3t92td+G7oPPbBYwMN7DnDy
         VR1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qZcMYCh7Sif1qWuZEL6tY48/pEN0AlQQi7iaVP3n73A=;
        b=rhoWTvdmNiaUeSV+z0q3z6bSItqApIBDllkM6C1rKVUMWcovlUITeF/UVhZvyc88dI
         VNS727DuuByqqGRrSznYOP9h0j0UuCgVklPfxwoygkH2jJ4sp+/9V6HPsFc4M633tSpG
         1xh5PRTIYSm7HCa8cC8wGhxhQjW/mdNDBVC0Hug5s6HsmGiDZ8KsKeeQzN5PoRS+h4n/
         KHrmgIWn19jEUsaME1EAiU10v19GnKHskWj6GyoBWqBYeYfCaU3Z3Hcbj28VqvPVGoGr
         TybJmMhKPm0L/kjAlC45coj+14jc60SoYRTfLqVWv3LkkjrnYxcwiVLybK6zRHj2dhGK
         RMyg==
X-Gm-Message-State: AJIora+He1M1EZKirGYjjJYUzjqMxhmCLV1/THruY6WegNwvdUK9c20X
        F0vcnSowZV1D9TqfW9ildi3wug==
X-Google-Smtp-Source: AGRyM1td3AuC7b+812Bc6BSzh2R/sSG0oT9aOreijEep/Rir5Rxmwof1xKK6aqUPPQboop9GykZFZA==
X-Received: by 2002:adf:fc08:0:b0:21e:d133:3500 with SMTP id i8-20020adffc08000000b0021ed1333500mr4745053wrr.353.1658997991644;
        Thu, 28 Jul 2022 01:46:31 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id z14-20020a5d44ce000000b0021dd8e1309asm305124wrr.75.2022.07.28.01.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 01:46:30 -0700 (PDT)
Date:   Thu, 28 Jul 2022 10:46:29 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Moshe Shemesh <moshe@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/9] net: devlink: remove region snapshot ID
 tracking dependency on devlink->lock
Message-ID: <YuJM5UMZW7uTKDmS@nanopsycho>
References: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
 <1658941416-74393-2-git-send-email-moshe@nvidia.com>
 <20220727185851.22ee74aa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727185851.22ee74aa@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 28, 2022 at 03:58:51AM CEST, kuba@kernel.org wrote:
>On Wed, 27 Jul 2022 20:03:28 +0300 Moshe Shemesh wrote:
>> So resolve this by removing dependency on devlink->lock for region
>> snapshot ID tracking by using internal xa_lock() to maintain
>> shapshot_ids xa_array consistency.
>
>xa_lock() is a spin lock, right?  s/GFP_KERNEL/GFP_ATOMIC/

Correct, will fix.
