Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C42425A183C
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 20:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242468AbiHYSBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 14:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239959AbiHYSBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 14:01:32 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8D9BB926
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:01:30 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id m16so123982wru.9
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=V3rvlgPNKsDmC6UL5dXYZgk3cANtUxsUR90LqKgOAbQ=;
        b=a6PffmLt+X6pz4ybd2Ida2TTy6EB//YQIi59NlbWkZo+1IhI3DlfHtlSCUZMKoilxs
         AXa/bltqmk2GK6m5I7WWUWbA/bSHH81l4yL6Ti0Qz0dSRb4ohIPzKPjiMDmmfYVKvwHX
         eE0w3XkJSyYI/LNB+WneBeYxO37+MT1OxYlR7JkVCycOtILprZFng1ywVl6EEdb+r9z3
         d+GilnHv1cMTk3PiEAxyur+9vJX5TPfYM9mQFqjdhbZGEWlfxiWnxfrFsnuEngLUeU5A
         08gkkZD7c+WzIY6e3fifHlyc9xGPZWdwtPhfv/pstPL3OJed1JuzBjPQ6BvAIP1D6hEu
         uOWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=V3rvlgPNKsDmC6UL5dXYZgk3cANtUxsUR90LqKgOAbQ=;
        b=Uz4wCvKQOWQd0bObCRtFq8BeWVv+nHxaSyVWuY87/0qcJPPeM7bLybSu14S45RsoSn
         Q6nKO/EUw9wDYPygN/7UwCqMlDAq6NfpMIXRHgSf0Z6W6Yfoev2cbn7G66GmEEWz6zZi
         4TKC2jympkkQHcb81FN8+kRLijGYrNH8g3CMWvFrUHRuB6Mg1X0J6EaZI/a3VkV77DxT
         NYd4hAo8BDiCUNVp6br1E7jQKj3V6uEJv5EMCddfobgKFfJWw485nk5LWgWH+c8cvwvj
         Xh7ph3uRCilQ3a9kO9sxS0Kar8nbnWbRk/BAA56FV3g1vIxTH/LqBeBGfJe/TQ2h8I82
         Cq7w==
X-Gm-Message-State: ACgBeo3Z8tpvSvyypnhJJfSbS8vqi+DjM4ZPooM9WSOH9eG7YPqkjenC
        Yv2avVWiWgEVJ4xHbJ7gHMC2rQ==
X-Google-Smtp-Source: AA6agR5sIba1irFAGNCFMqOXrLQiFUj+uRicgN0ULEE+D+0rOrfc8apRcnAGT9/SWC3oeu4qLWq1sg==
X-Received: by 2002:a05:6000:1ac6:b0:225:2e67:6ba4 with SMTP id i6-20020a0560001ac600b002252e676ba4mr3156298wry.321.1661450489190;
        Thu, 25 Aug 2022 11:01:29 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r6-20020adfdc86000000b0021e13efa17esm21024963wrj.70.2022.08.25.11.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 11:01:28 -0700 (PDT)
Date:   Thu, 25 Aug 2022 20:01:27 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net_sched: remove impossible conditions
Message-ID: <Ywe495TKpyYuIWks@nanopsycho>
References: <Ywd4NIoS4aiilnMv@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ywd4NIoS4aiilnMv@kili>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Aug 25, 2022 at 03:25:08PM CEST, dan.carpenter@oracle.com wrote:
>We no longer allow "handle" to be zero, so there is no need to check
>for that.
>
>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>---
>This obviously is low priority so it could go to net-next instead.

It should. Does not fix anything.
