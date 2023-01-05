Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A11D65E76F
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbjAEJOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjAEJOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:14:17 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329755017A
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 01:14:16 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id w1so23352034wrt.8
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 01:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xsz2XqTaz8WpPOMfqFh7ZrdRTI04i1Y08aAvpfggKzI=;
        b=aXvDvOFPlk27I+JhhqNxvox8nY2C2yrJY5Sl5U5rNKGPHtjIb7TSY8HTQ570s24mna
         oP7TrdZ0m5FUsOad9hjNkGdqRlsLd3tLcYO2AUESWLOUCVPqFJPcSmALc1LrNCZueAUr
         zFefss+hyMi+58ej3oYLeq3iuMJg0YTX3wiqJBiyRUvM9uJpBqTSqvl8VtN4J2LLrAnF
         KIC+zDt6Ac384U89FvqmlACAdJx8epg9sRJCHK0O2HHcMzl93Jej7HbmfLN2Mn7M63md
         znySZor78G7qVNBBZu/y+BCdvinH0xA+UnUaVM0hqVeEj+0tSnsu+z6YSvrA9wHLLIed
         E7Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xsz2XqTaz8WpPOMfqFh7ZrdRTI04i1Y08aAvpfggKzI=;
        b=fOJlRS5bht7TkpsuNi8GFhGQDKC+tq3f2oOAoOORiYLUouxXoBkbIJLhl2cZP6UcWQ
         ZWBMB/7Kse/afIbBD3QhpaeRzq26EoIBlAjqUMV0JbVC6BY//1k1Vq2U+yq8C0l1UTxw
         5l014eLkgphwXLkYtE+ZTTqr1OycxOJ2zTpf158Y8tT6sa/xymZA00P/Pd5+IJfJVgKw
         mtr3dWkIkabMVBmnlTFtVKkmCpc3J3jkqALotK1BBY5CxJbttQv9udkTv/6j/mIxr65o
         uR41u5eGLhp3Pvw++G+gNsWMqgmKA0+dR0Al4xjy8Wr1DVxoXSAP/6ZmRY8c421bV5fR
         U0jA==
X-Gm-Message-State: AFqh2kppV7/LalZtWxkrh7hBsDFMVnPUR0ilGLzB08kmE66PQwDH3Szb
        KgTUr2I8eR9HiY549VUPiqc/FQ==
X-Google-Smtp-Source: AMrXdXtITn/1PLTImkxvQyNTxfFKeoPvbO5WsX00eRyVSq6cj8s4wru0hxVMApAdpVT3hltGUZr4Cg==
X-Received: by 2002:a5d:40d2:0:b0:2b3:b40d:8e49 with SMTP id b18-20020a5d40d2000000b002b3b40d8e49mr712786wrq.26.1672910054806;
        Thu, 05 Jan 2023 01:14:14 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id m16-20020adffe50000000b00241bd7a7165sm40362758wrs.82.2023.01.05.01.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 01:14:14 -0800 (PST)
Date:   Thu, 5 Jan 2023 10:14:13 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next v2 01/15] devlink: move code to a dedicated
 directory
Message-ID: <Y7aU5YfMHO7hr+SR@nanopsycho>
References: <20230105040531.353563-1-kuba@kernel.org>
 <20230105040531.353563-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105040531.353563-2-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 05, 2023 at 05:05:17AM CET, kuba@kernel.org wrote:
>The devlink code is hard to navigate with 13kLoC in one file.
>I really like the way Michal split the ethtool into per-command
>files and core. It'd probably be too much to split it all up,
>but we can at least separate the core parts out of the per-cmd
>implementations and put it in a directory so that new commands
>can be separate files.
>
>Move the code, subsequent commit will do a partial split.
>
>Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
