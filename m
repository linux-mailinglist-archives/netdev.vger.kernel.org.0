Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0EA06B2FC9
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 22:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbjCIVrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 16:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjCIVrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 16:47:31 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23076F2094
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 13:47:30 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id n6so3500022plf.5
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 13:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1678398449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rKDfFwZhmkmLZDm9l0rTqpnlaQMPI2SK9ENmYxDocYA=;
        b=4+WzIuT39d2r7aXEN8eJDwYbv2g6cMlRaLqhnYPhzyZb5R0ozDt6W5b8DDCRNEpjqR
         hbmAIvsBcMEVF9wJ6J8Sc6NJUBW5+741tfUMHziM4LOMqJyH4Qpwve0MQThAA23NDlfd
         8bEiCN8kzkzVV385innEIVdzvEI/hDnkQPPzZPb26ztSRl5u2jsKB84L+u3EZKUKOGmK
         q67qmjDM54y/AWq13QjUE6AobOTtu6FfRvJIrQst2aBc/FmahUaW4vjyCKolXG7MtFOw
         YAj0n77u2HIc0OPKZAY0NxJp4ONqELEgexwt9Sby56Wymc5OXqU7Kik8YxkF9dn2U0n1
         1d5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678398449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rKDfFwZhmkmLZDm9l0rTqpnlaQMPI2SK9ENmYxDocYA=;
        b=cTkHg1+eObPPgKtzSA1QGgujstdcdtSN7I8gwpeK30DFOfKeIC3zHOapD9sKPRWtUY
         QcKAcBg6rOFh7CM6JLuA12yapjuGKJvOFhkpN2N894nIwCwXAO8IEer2R1MBNkjBPrJx
         yMWWMhTYClrvE0F7tMCEPAGZX5dq9F69fQ57aS21RaegK7UY4xO6+T+Lp/ChLLhvrZMV
         uj0cDTA5Lfe8WkFh4oX7RVXaJzbhHooC/nbqse4R3zTjdfFX60XThXCWaX5pTul+NT86
         0wH3CEyT09xxsMcR6Hy4Jgm4qhcJ1/ngvES9V90HzGB7+XKCm/Q6nddzI3NNm3pH3Oaw
         1bXA==
X-Gm-Message-State: AO0yUKUotOr2XcVrRMd44qrmyZtcW8vwAMAbbD1fUXV7D/iuNccaAy+B
        oXiBAGySJSvx53iL3YZD6x2XlQG5udvu4pdxTzh6Eg==
X-Google-Smtp-Source: AK7set9F+iAY3qJdHLt98/pE7EzhmhW1yYufMFhGjn7Z8NS5RrY7x2uYHYt8T3MWkhU+J/713JokSA==
X-Received: by 2002:a17:90b:1e0a:b0:234:c07f:c04d with SMTP id pg10-20020a17090b1e0a00b00234c07fc04dmr23480224pjb.49.1678398449550;
        Thu, 09 Mar 2023 13:47:29 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id o12-20020a17090ab88c00b00234a2f6d9c0sm32721pjr.57.2023.03.09.13.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 13:47:29 -0800 (PST)
Date:   Thu, 9 Mar 2023 13:47:27 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] man/netem: rework man page
Message-ID: <20230309134727.340b9520@hermes.local>
In-Reply-To: <ZAnrnrKzuE3Mj8K7@corigine.com>
References: <20230308184702.157483-1-stephen@networkplumber.org>
        <ZAnrnrKzuE3Mj8K7@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Mar 2023 15:22:22 +0100
Simon Horman <simon.horman@corigine.com> wrote:

> On Wed, Mar 08, 2023 at 10:47:02AM -0800, Stephen Hemminger wrote:
> > Cleanup and rewrite netem man page.
> > Incorporate the examples from the old LF netem wiki
> > so that it can be removed/deprecated.
> > 
> > Reported-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>  
> 
> Thanks Stephen,
> 
> some minor editing suggestions from my side.

Thanks for the review comments, which I incorporated before
pushing the final version.
