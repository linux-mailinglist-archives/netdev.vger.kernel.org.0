Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E3A687CCD
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjBBMBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjBBMBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:01:38 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220E18001A
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 04:01:36 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id qw12so5324396ejc.2
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 04:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3rkSR8OqEy/2Bt8P6DPwHU7VnWfycF0LHq+7vAAoyCk=;
        b=EhFDP9qBXX7wnWi7yUi+gWF53aLbvYM127lNKAuTSp+lSE2jC96hRiYuDKKilkcufT
         V+Zp6F+ZgyIQVGLl9ZLISJcig0VKoOvIagFQWrqeESWYfSQ7C6T3YV0ewdfaLdJoLMJ7
         o9vNp2NPRNsGBehsApdUsZkvhiKqTcmaugI+XNigiXthY8R79fegSJ3n/1h0qJDFRSeg
         u5ooCPFRejDG2q5WUhTwFjZOGDLN/acBI2LKaGjZCZ/REAeYS8m0sRmXX7mS/toovijU
         JuwsnDK5h6TczqUogXaeuouPFst6+llHR42AC0H0eqGSXtQCQbXRc5wmHo524Hv7uOW4
         2h3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3rkSR8OqEy/2Bt8P6DPwHU7VnWfycF0LHq+7vAAoyCk=;
        b=OAWQCjh2zfs02kLF1OSC2BUgv56s+Rmk66k/cRz20c0boauJlo4cOwO04+YWP7wvfQ
         +ixZL3JMma+RJbHnBU+NzG8OpX4B4tpv4TwLMhZuXORozoLv6IKOwds/GzB0B4Ui5xmD
         7Y1/X93BLnAgg8/AjW1zTEYlMixTwX36H1B5vwKSzr0mccnGy3mIh5BOUXSa1jlPdxem
         cASsFdaMnSvUgump3F/Fd0owi+QYiFCEgrKpdQo8SkLEyc4o2zYLAYgKjufszETmB8uB
         +OPmm2DQ5fzeZmLpi679MqxjoXsaWpqS36qD9YLC1LeQSmDiC2XT08Ant9DhTMUqnWNQ
         4mWg==
X-Gm-Message-State: AO0yUKX56mSlwwk64oi0vPD09nyclzfiNoINIr/dSB3D35ZLUay/K2nW
        B2fig3kZFyQ/rE4MVtXXF4w+nQ==
X-Google-Smtp-Source: AK7set/3y3nIx/GSNkjczhLKeAthrhtbV1NE/OHM50AOJ8haNEYj/IIc01PjH0kEi9QUpDtgow9kfA==
X-Received: by 2002:a17:907:8f0c:b0:887:dea8:b029 with SMTP id wg12-20020a1709078f0c00b00887dea8b029mr4714107ejc.1.1675339294692;
        Thu, 02 Feb 2023 04:01:34 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id h13-20020a1709063b4d00b008787becf3a8sm11113327ejf.79.2023.02.02.04.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 04:01:33 -0800 (PST)
Date:   Thu, 2 Feb 2023 13:01:33 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com, linux-doc@vger.kernel.org, corbet@lwn.net,
        jiri@nvidia.com
Subject: Re: [PATCH v5 net-next 5/8] sfc: add devlink port support for ef100
Message-ID: <Y9umHctuXzaog7oI@nanopsycho>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
 <20230202111423.56831-6-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202111423.56831-6-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Feb 02, 2023 at 12:14:20PM CET, alejandro.lucero-palau@amd.com wrote:
>From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>
>Using the data when enumerating mports, create devlink ports just before
>netdevs are registered and remove those devlink ports after netdev has
>been unregistered.
>
>Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
