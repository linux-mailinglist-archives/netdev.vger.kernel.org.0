Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D501660071
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 13:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbjAFMoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 07:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232803AbjAFMno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 07:43:44 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E17474589
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 04:43:44 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id w3so1565487ply.3
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 04:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6vpQLWnwm3sydikpI1FcKxllL+4DHqFBxRaBfJvohuU=;
        b=NVOgpHC1SGCPgVTVyV1VWXn+p3pVZ3s5oqEnQo5kRu4KV98iEegwnP0sXZ/evM1K3p
         pwOqJ49xcm6yAvMUjtTdhMPxau8VsnRI+p8f5KtVFZrzpDTi/xPziuu4yfCGxm5UND9B
         kVfV1i1Jq3aa8LfclvlEMQgJAEcdHqwtyqNi9+DlayNUeot5EQ/GC/yPYgl46UeQAdv8
         YRmg1ybbPEuK6AIY9XYeS+iOsMSC1S9fqxAFxW+tmU7RMpREmGL23eqcP41QhlIQjZAq
         pRuWLCk6xIFEx7XvjXrKGEQNNlFbGP25X8LIFaKA6Ms02paByEoduBGBLHkhVO9laCkc
         kqIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6vpQLWnwm3sydikpI1FcKxllL+4DHqFBxRaBfJvohuU=;
        b=eSa1V0DSGj0KZ38agVoaDMMbMuLrjplndDgvEtAfvQK36qbrtzWABBCdyQ3cMcTKaa
         7EA3Szs9wFGiFjG+ottvqLd63HemX8b7lAtMx5rzeuxbqPy+v1sM0e5djb4/eiEC9D7O
         pnmbkpp1lCvYIIR9DcN/EuJKUE48bncHsi1PaORzCQ50AxnLH45IxdPLzoxI48B1Bd7G
         TCNYR9qaDYVUC/6XjwRetxVi45hyKr/+9NosGEG+Nmnc/mBJcr0Y1oWEo5FRaTlADVbi
         GMdZIgL9807rm0R5JBda04OgdtMbDqDbZCwPmguUI+fx8y6es8oYTWoYcqlVs4g1g/FL
         SoMA==
X-Gm-Message-State: AFqh2koC8JvP4vxzE3UxCKEp9yXM5VPpgkyqPwwnzD2UuQpftj2NRgeQ
        FGpY8mxwcZMQA2LjxM/K57P2sw==
X-Google-Smtp-Source: AMrXdXteuv+nYljTO4CyeZDI+8IWYfPgVJtnQYztgVmLGOlf82wZpflq1n8jB3FU9C3pKF0ciX2NCw==
X-Received: by 2002:a17:902:8543:b0:192:9454:7b32 with SMTP id d3-20020a170902854300b0019294547b32mr31484533plo.40.1673009023563;
        Fri, 06 Jan 2023 04:43:43 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902eb8500b001801aec1f6bsm879446plg.141.2023.01.06.04.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 04:43:43 -0800 (PST)
Date:   Fri, 6 Jan 2023 13:43:40 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 6/9] devlink: don't require setting features
 before registration
Message-ID: <Y7gXfGFVDtNKY99m@nanopsycho>
References: <20230106063402.485336-1-kuba@kernel.org>
 <20230106063402.485336-7-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106063402.485336-7-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 06, 2023 at 07:33:59AM CET, kuba@kernel.org wrote:
>Requiring devlink_set_features() to be run before devlink is
>registered is overzealous. devlink_set_features() itself is
>a leftover from old workarounds which were trying to prevent
>initiating reload before probe was complete.
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

I have a patch prepared to remove this entirely. Until then, this is
fine.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
