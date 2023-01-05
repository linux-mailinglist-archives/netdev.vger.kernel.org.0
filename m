Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B8565E77E
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjAEJQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbjAEJQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:16:45 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD98C39FA7
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 01:16:43 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id t15so26608923wro.9
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 01:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7gk+pG6+QIgYw8+4F2t1cimwLQqGNiECzVUQdRIE204=;
        b=S2UkZoF/Fb7Wd0GxetG76/obNCsp67VSt4xHPlnI0jHWEZnqgrnatAfOfdTOgDq1F8
         x1AKcf/5NtU/vF0gFVgb0+ZLnyv95Ev2c9AD63eDVqGpX06utn4vkEFh/qkF9hFKQqVJ
         Sq/H6raZ0yQap2aCMkcUCR0HX01nUzaci67bSDn7le4IeGRk0rfngTdyJvYjYVJcKLT1
         PCDy5BiZdglF+t+N2Krb5AmkRCshcLLCUbmur1Gg4x8ynnWfNbU1lb2uMXdWY4cNL62y
         gJLdbH/Axunnb4v+x3yDm3cYji/Nox1qJadsJ8cyZOrwyVyHZnhMs0Dg0sLCK5A9MUUP
         M+9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7gk+pG6+QIgYw8+4F2t1cimwLQqGNiECzVUQdRIE204=;
        b=nAcSLuDCkOSFLJpW/tutJ22P4fto/+wc0Egq0LtSKOBG7VK9s155VRgi7lAai39OXW
         8eCCFGdNFXAdmbxcF1ZL48qyZkNXaMYWkm/9elXthjC2HcJGer5fOuwb0GZ9ID2wFd61
         OBBi4wIhOCZ+HSZUwNdAmC3mLkcSFdnftkN6rScjhLFsnmPUpu+EtcAaVUw/MpmyQUPR
         bjf13gv1ZtTLC3fjVm/8ZMI8h6b0nItL+EZcUxlrik+gNPsHO/JMIEdQs3qgGySwgWh9
         k3zganYMV+iJntA46k8H2UMS/lBS9iBBPOisq/0BBStcXHR0kCBtqUnZea572C6Y7XHo
         WCtQ==
X-Gm-Message-State: AFqh2kofSXfuaDraa8XqDzZ5OuqYaMN0gxfNsiRmGlxhndx+CQ9MUOPE
        lL28LDf2KuilxaS9T7sAUUtpqA==
X-Google-Smtp-Source: AMrXdXsH6kWVbMdyUMf02D6K1GDl1jc0nk8akOpiK91OVUBQrOxM4LDETxcs/v1a70vW15oFUrDH/w==
X-Received: by 2002:a05:6000:18f:b0:29c:63ac:ec34 with SMTP id p15-20020a056000018f00b0029c63acec34mr6765842wrx.4.1672910202262;
        Thu, 05 Jan 2023 01:16:42 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id b2-20020adff242000000b0023662245d3csm36491352wrp.95.2023.01.05.01.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 01:16:41 -0800 (PST)
Date:   Thu, 5 Jan 2023 10:16:40 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next v2 03/15] devlink: split out core code
Message-ID: <Y7aVeL0QlqiM8sOq@nanopsycho>
References: <20230105040531.353563-1-kuba@kernel.org>
 <20230105040531.353563-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105040531.353563-4-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 05, 2023 at 05:05:19AM CET, kuba@kernel.org wrote:
>Move core code into a separate file. It's spread around the main
>file which makes refactoring and figuring out how devlink works
>harder.
>
>Move the xarray, all the most core devlink instance code out like
>locking, ref counting, alloc, register, etc. Leave port stuff in
>leftover.c, if we want to move port code it'd probably be to its
>own file.
>
>Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Btw, I don't think it is correct to carry Jacob's review tag around when
the patches changed (not only this one).
