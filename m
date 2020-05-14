Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6625E1D3183
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 15:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgENNmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 09:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgENNmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 09:42:15 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE76C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 06:42:14 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g14so14373931wme.1
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 06:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZnXxryCahv6w8eAwSlmptDrJQqgyzI6rCA8dW3FeYvw=;
        b=GspQTuCdKlFv4WOr1iH56Cdk//RbGHPpq33O4hAtslB/QY5Z/lLK0fKzjJIK8Det12
         sq0I4lVvfEM5tVCTRKq4soZ9p6h7+bDcDZNMTwXCIyuT744AWpzpg0Eww/0RM1nluvn+
         fHjPCQX+eAetd3t1Lw++kNTfQJ5H/ZZ1ao7V7uwN3EvimibJOoc13xJhG64O2iwURO6E
         ijAcrixlLCPlFY13N/yWgzBSMuE5TFk4N63wDZS0IEauo1s55Qmbh48WhmW9TxzeozFz
         QE6E1RDSTLVpeldpl/zFhLJ67RR4JBUCB+yc7ZpA22bAC1Y1yrtdJYMnFE6Up4zHocnp
         rKrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZnXxryCahv6w8eAwSlmptDrJQqgyzI6rCA8dW3FeYvw=;
        b=UexNZEMiox+pjhpIpDpqZX1qVoOjtN2oVyzASqoyE/6eP7AJrsImpQheS5r68gxnJh
         KrzjBFlGoAuhnYVmntk22a/UnqlguILUxQeZXL4Knzz+Q2X8en80m3ob696C7Rl8qjoM
         qVt7wCHngauWdDroiD5R0RqtTf1W2+XotPXlrRGt2m4maLHDL2XtlAQ7VTl+6XXX+Vpr
         A6UmXjGxW6N6QfqHe5f7xGxJENrXgK7EZUu2Gxz5MPDXqwBVbLpdNW/XTLYprvDXYjot
         Sb1dBeUk9iu7GAvMhCv4qvw4MjHoU6PLtP7lzPA79efcMvlO+37pOF2BR4A1RCr6o5TF
         GWuw==
X-Gm-Message-State: AOAM533uO00JMrEw2vP4y7tMsuQBk6XhOW/jJymUPJibxSitWclGqsZH
        WGZSWDiD05Z/xXcGf8XV4TO/ww==
X-Google-Smtp-Source: ABdhPJzUzsEBqs48zlrW+UMQYlEzpEYCXoYyR3x6XzsLbIdj6L7VAZBiVPYjw4wjKsjvyExxJzryWw==
X-Received: by 2002:a7b:ce08:: with SMTP id m8mr4733581wmc.97.1589463733607;
        Thu, 14 May 2020 06:42:13 -0700 (PDT)
Received: from localhost (ip-94-113-116-82.net.upcbroadband.cz. [94.113.116.82])
        by smtp.gmail.com with ESMTPSA id 81sm24625406wme.16.2020.05.14.06.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 06:42:13 -0700 (PDT)
Date:   Thu, 14 May 2020 15:42:12 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, marcelo.leitner@gmail.com,
        dcaratti@redhat.com
Subject: Re: [PATCH iproute2-next 1/2] tc: skip actions that don't have
 options attribute when printing
Message-ID: <20200514134212.GB2676@nanopsycho>
References: <20200514114026.27047-1-vladbu@mellanox.com>
 <20200514132306.29961-1-vladbu@mellanox.com>
 <20200514132306.29961-2-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514132306.29961-2-vladbu@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 14, 2020 at 03:23:05PM CEST, vladbu@mellanox.com wrote:
>Modify implementations that return error from action_until->print_aopt()
>callback to silently skip actions that don't have their corresponding
>TCA_ACT_OPTIONS attribute set (some actions already behave like this). This
>is necessary to support terse dump mode in following patch in the series.
>
>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Adding forgotten tag:
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
