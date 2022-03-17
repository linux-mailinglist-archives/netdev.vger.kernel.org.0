Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989CE4DC097
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 09:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiCQIDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 04:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiCQIDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 04:03:54 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607DAEBB97
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:02:37 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id qa43so8903707ejc.12
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6Gk8X2f/ZL1/pSNuiD1ougD5l9vBuahKKc4D9hm5KXg=;
        b=ltM9jDZ4y180QsUGXjN4CcMov298PK9v3oyJBkPC+xrRgI6PTVgPpXScePzk0Aa/Ca
         QKydWi73aY7wvDS1+5nFmoGKIAIy9jykJVbdN8ulmQd6vakJf6mvO2TIp/ShUv+Mb9sz
         4AptXGZwBSMlgIK1vQX+gRilZ0wGFgQYhXHF56th2M+C5CW0JM1T9P0Xa3eEBiHwVkg2
         cJO2y3yTKQPv+n/OMnZnU/Ph8rBtC6MUnLJ8IEAmOf1HcplPeXIAF25dZyg9v/28YKlt
         A9Bpl9VMd3bD3TXJa/v12bPdQ7KoqkqgtU26mE9fuhO04hU7Tl8d+eOnDmK8fmJtlgpU
         RhTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6Gk8X2f/ZL1/pSNuiD1ougD5l9vBuahKKc4D9hm5KXg=;
        b=fWGPSRNbUhqxnUMCrUYPQ+U2gHLmP0zd6Ft1gWPfjwOPqYxQ3ralo8o+uzIAfGu7Ec
         BottUmvWiswCwyia9IbKU23cGF/jy5jNqe0rDIz+6OfjnORB1jUasGAkPjz3GZwDqEwY
         +MIbrnD+ZOEdqJYRlUa/NFyLkGPs31zVFZc0YBi8WTuUzC6QdfSytkaCHayA0NHD99Pv
         MaW3/yqgKyrTwZYQ5DxA1i6OzzXZ/hQowegtsTL+9GSls7/Ll4YGrChvIummglQLwmFt
         PXACQf01o7yPqXHVEcTopr7K2kfLoMfV75yt5V7UG40ZEkqEWWxSEJhaJ69ORYDw8iv6
         UXtA==
X-Gm-Message-State: AOAM533Xxc4bxzAekxmXZ741AUWNDdR9/gMjOQPrjDLVRLMDEp6+pEq8
        lUJc/XD8h8079Fa4M1/4lRXVTg==
X-Google-Smtp-Source: ABdhPJx+5plki13ZMJa8hIz+TaUFX6/pdDiaVL59s06+WC8S55JgM44XJfoHyAJMzJvdL/8v0nMBnA==
X-Received: by 2002:a17:907:1609:b0:6db:b385:d13b with SMTP id hb9-20020a170907160900b006dbb385d13bmr3008633ejc.542.1647504155870;
        Thu, 17 Mar 2022 01:02:35 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id gl2-20020a170906e0c200b006a767d52373sm1989172ejb.182.2022.03.17.01.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 01:02:35 -0700 (PDT)
Date:   Thu, 17 Mar 2022 09:02:34 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, leonro@nvidia.com,
        saeedm@nvidia.com, idosch@idosch.org, michael.chan@broadcom.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next 2/5] devlink: add explicitly locked flavor of
 the rate node APIs
Message-ID: <YjLrGtuxKjt35Pig@nanopsycho>
References: <20220317042023.1470039-1-kuba@kernel.org>
 <20220317042023.1470039-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317042023.1470039-3-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 17, 2022 at 05:20:20AM CET, kuba@kernel.org wrote:
>We'll need an explicitly locked rate node API for netdevsim
>to switch eswitch mode setting to locked.
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
