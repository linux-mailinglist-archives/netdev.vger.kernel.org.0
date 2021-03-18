Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4E633FE1D
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 05:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhCREL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 00:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhCRELR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 00:11:17 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D065C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 21:11:17 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x184so2577733pfd.6
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 21:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U3xSrRwd5qNNP/aO60/BRmXVbc9mdOa6P3z2AyIMmzM=;
        b=TTzNrOFG6Pl/GmR3PoYNnNGCMXEyIlWZXWXLruzsjjJoxcBfZ8Z/nfj9zsZl2DmHih
         IzBmQNaR1YEiazD4IomNO8AsDGGY/krxzZi4kflYptwQ40SonwmYz/CUveYra8k5vEs7
         fDQmwx58KpT5CwGROcwKhAWSOUVEqQ2pialhlNxEPNzfeYvNVgW88Kq7MYTQyQuI2nbY
         Wst9gcXeU3hBoRE0RsNLuAkxrsR5QDzYx4nj1By4zpRUcvp2CNJdzV2dF3ZWaNl2aRMr
         atogDOadKEijvl4DtvdUGRlL2FAuPhGaHkPMkzux/+tdQvbOqkaEtOvq8Hypy9mH4+Ab
         IMlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U3xSrRwd5qNNP/aO60/BRmXVbc9mdOa6P3z2AyIMmzM=;
        b=tudmkCQm0vOc9ivUejENqGhMskdS9EE/nH1EgFau6ozu8rT2vTIZO3nlHRd2yjqy0I
         KZaBB+iWmGZa3Qc5sLMlgGWoF0GatQ3QA89d9sCPz+tgB9ZO2wq5frfgfjnoHIlgqaYG
         hvOXCUmmAN29BY7okkmpSyl2x08cCgHXPPZonTScfBYP7db3qree4NPnAKHvX8IMDtbr
         FEVgPz+Tl4HvZpbe1N3EJ6bxRpp+jpszRTavAQXPswpwUanMheevF5zkNbaIjfZ0awGb
         Jimlt5w3+Oj++pZCVTaUZAj5VDRvdFAI2VvD0NjgKu/rEUJvoxW46l9v+FTFeOp7CoEq
         dKpg==
X-Gm-Message-State: AOAM531Kje6+aHi+Yg+6nBMPYx6hBWy5Ln0CMUDYbgNglOh8/sdajvJD
        R9qyUwjNM0uwopEtvGeekhAQWA==
X-Google-Smtp-Source: ABdhPJzE0tQXDTrjzCjV9EX8Old7mt46Wd6TwHg0Kh+3CY7DfYKjv8ebzaAxSF87VFjXyngoF5Gb1Q==
X-Received: by 2002:aa7:808d:0:b029:1ed:993c:3922 with SMTP id v13-20020aa7808d0000b02901ed993c3922mr2096080pff.75.1616040676830;
        Wed, 17 Mar 2021 21:11:16 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id d10sm536815pgl.72.2021.03.17.21.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 21:11:16 -0700 (PDT)
Date:   Wed, 17 Mar 2021 21:11:08 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Bohac <jbohac@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH] net: check all name nodes in  __dev_alloc_name
Message-ID: <20210317211108.5b2cdc77@hermes.local>
In-Reply-To: <20210318034253.w4w2p3kvi4m6vqp5@dwarf.suse.cz>
References: <20210318034253.w4w2p3kvi4m6vqp5@dwarf.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Mar 2021 04:42:53 +0100
Jiri Bohac <jbohac@suse.cz> wrote:

>  		for_each_netdev(net, d) {
> +			struct netdev_name_node *name_node;
> +			list_for_each_entry(name_node, &d->name_node->list, list) {
> +				if (!sscanf(name_node->name, name, &i))
> +					continue;
> +				if (i < 0 || i >= max_netdevices)
> +					continue;
> +
> +				/*  avoid cases where sscanf is not exact inverse of printf */
> +				snprintf(buf, IFNAMSIZ, name, i);
> +				if (!strncmp(buf, name_node->name, IFNAMSIZ))
> +					set_bit(i, inuse);
> +			}

Rather than copy/paste same code two places, why not make a helper function?
