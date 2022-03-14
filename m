Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7710E4D8560
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 13:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236212AbiCNMtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 08:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242195AbiCNMsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 08:48:25 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CC83C726
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 05:43:39 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id y22so19703808eds.2
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 05:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9kP0ABPRlE2CwYQ+yP0KAMz4/slWRqKdyoLNgLogXGc=;
        b=NCrSVt2mr+iswjOUH9WuKVSwn6hSAdWARalVY9Oph3lO/zVYvclycKCNPfFwe8cqTl
         PI4rAsAccdxRPTp9r5rBeF0DrvUT2o2q5qBnbByCh8J6e2O0bLS4LfVdFTbEZUQnkqAG
         lajgLifz+3VAY36ymEPhq5cDwxtP1x/MYS9lJ6+fAtt7M4xYSkGlA7I+xH8R3/RafqW2
         ugMOdDf0/lD/7SRnxh2I1dTYGqqWDVWM5dK97BX8tURZZ4i9xSH8yrETh4gFyU50fIiQ
         HhNNKPXeKc7btCuuS2g0eWo44FECiXWIpe8LHTqXZkkFs35EJyfJr0cWY6mRzLendSbe
         Ubbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9kP0ABPRlE2CwYQ+yP0KAMz4/slWRqKdyoLNgLogXGc=;
        b=nAA0TJk23V3hhbrWoGg9cDQ0oZl7ga+xZDZJqy6t9PSHBsSk1exQLfMcr+zyfuRae1
         7AtlPZ4chczno4MAzqf5P2YECpu3C2LXuQlANwZIdPwJeKbGqMtlHEjUQSeLx2VBXkbL
         dOrcvA2wbtWZ0i2FGxL9Wl4wjc4whJ3dEQ0ygPCpBayrVNOvOCH3Iqidv8Wjpg44d4gE
         7FjefPlssF/VL5zIM9htE8cxU5sIONCCFury7KjUMrViCU/eK6kDsGO0KcfxLCmTs9XE
         e4Yx7lyrpX372pih/Bnypvt8QUCsbvHQhdWPMUVxqefvVkeA8o51JA+Q1iC7P0YngTr1
         fcFQ==
X-Gm-Message-State: AOAM5304HFnoXBwGhZ81os0PxyQBgXNkyTwXb2EH1Vfi3LU/fGi1rAFi
        my9MhLPC7vhaCcrZ4ShTxno5vg==
X-Google-Smtp-Source: ABdhPJykeP8UGiKsxJ8Zw01JzVpiyLzLDgJup6oOUxr6Ed/ZMvgkXSbEyT6pTme/zgdtmpQKLHyYDg==
X-Received: by 2002:a05:6402:d4:b0:418:7193:da1 with SMTP id i20-20020a05640200d400b0041871930da1mr8009962edu.57.1647261817811;
        Mon, 14 Mar 2022 05:43:37 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id k7-20020aa7c047000000b004132d3b60aasm7830133edo.78.2022.03.14.05.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 05:43:37 -0700 (PDT)
Date:   Mon, 14 Mar 2022 13:43:36 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, leonro@nvidia.com
Subject: Re: [RFT net-next 1/6] devlink: expose instance locking and add
 locked port registering
Message-ID: <Yi84eMBqIPJocXHs@nanopsycho>
References: <20220310001632.470337-1-kuba@kernel.org>
 <20220310001632.470337-2-kuba@kernel.org>
 <YinBchYsWd/x8kiu@nanopsycho>
 <20220310120624.4c445129@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YisTMpcWif02S1VC@nanopsycho>
 <20220311083332.48c7155a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311083332.48c7155a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Mar 11, 2022 at 05:33:32PM CET, kuba@kernel.org wrote:
>On Fri, 11 Mar 2022 10:15:30 +0100 Jiri Pirko wrote:
>>> The goal is for that API to be the main one, we can rename the devlink_
>>> to something else at the end. The parts of it which are not completely
>>> removed.  
>> 
>> Okay. So please have it as:
>> devl_* - normal
>> __devl_* - unlocked
>
>Isn't it fairly awkward for the main intended API to have __ in the
>name? __ means unsafe / make sure you know what you're doing.
>
>There's little room for confusion here, we have locking asserts
>everywhere.

Well, I think it is common to have "__" prefixed for unlocked variant.
Idk.
