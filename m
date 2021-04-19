Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD88363F80
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 12:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238561AbhDSKXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 06:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238512AbhDSKXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 06:23:03 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384D5C06174A;
        Mon, 19 Apr 2021 03:22:34 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id o5so35224293qkb.0;
        Mon, 19 Apr 2021 03:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=363VWPLcAU951lFrOwLAp4x5JJh1Vw/iAvcAFa7MyZk=;
        b=R5XQ5iZqatSvkNTU0qHCUsd0p3WT01/W6ntNqMUmTduyEm8YkOXTdWM+oK7ac+tcoA
         NRmOJX4f9vdm9iTRu91lqQRl70RW/TSL+7MtEm5wLDZfwkOYlSjr9fbNTNh0B39Kkowt
         Bi5WZpYn1Yk1+IA8xtPcgYX06Hc33xaf5QMYf98EMh39ixuRDZYsdE44bN8c3rKjNycy
         jnZyz9fV93XN3GZEzzlU5szM0TFi6FCAXCFHq/Ps8ZSC0T1AxjC3mG1EKcJOT97anYWt
         U3yn+hc4TLXFo1m12iRukb3HKdEu392+NfVNdvyNa/vpzSe/a3swEafL+a3B1hbuQLS1
         hhHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=363VWPLcAU951lFrOwLAp4x5JJh1Vw/iAvcAFa7MyZk=;
        b=bIywzl1my8NHAvWAiXi1qnU9dYmoQOVmpzLg9qB3O4YYqSScR/sYxYiU2V7N+xtOQD
         U6q+Lo5sezkHXKYMoYr6u61lCVpdSjHaLJM8lRZdLyBO/Ocyj34L13whrh3aBzgZsxWB
         4YfxCp1q7gb0QbmXQvwmvp/J86Q7c9b1ebO2DIYwoxkqbxGXLqOuuj/ozzNgWefEaQ1X
         dBy5o73gfU2IlAyWwemK8Yvq6fkO0rK3wkSTbkWDXWdcVb0dmqB25v8jCaQLLhiSHN4v
         JNIW8ElA8SUiQdNZtgHkiJNpP2AqwJBVIqyeLLHO4gysKVUWfnCIjWbI6zIaSyIreIGf
         aSWg==
X-Gm-Message-State: AOAM5339/Sk3gMsvN1tkHE6qQYfh/y4IBNOYIuzRIZndJWAI8MlLZCWp
        xz/lvgvSUdTGrWckWlAu5uj87pf0AsOJPQ==
X-Google-Smtp-Source: ABdhPJwv0PfWbwbywYMr0ja8rTRSIwkz72j7PM0deJVOZmAzf8SeX58JgPPuNxZ50gh2CISo9QcD3Q==
X-Received: by 2002:a37:814:: with SMTP id 20mr10509400qki.230.1618827753300;
        Mon, 19 Apr 2021 03:22:33 -0700 (PDT)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [199.96.183.179])
        by smtp.gmail.com with ESMTPSA id z17sm8506175qtf.10.2021.04.19.03.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 03:22:32 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 19 Apr 2021 06:22:31 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jiangshanlai@gmail.com, saeedm@nvidia.com, leon@kernel.org,
        davem@davemloft.net, kuba@kernel.org, bvanassche@acm.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 0/2] workqueue: Have 'alloc_workqueue()' like macros
 accept a format specifier
Message-ID: <YH1Z57+iJxBT3S3b@slm.duckdns.org>
References: <cover.1618780558.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1618780558.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Christophe.

On Sun, Apr 18, 2021 at 11:25:52PM +0200, Christophe JAILLET wrote:
> Improve 'create_workqueue', 'create_freezable_workqueue' and
> 'create_singlethread_workqueue' so that they accept a format
> specifier and a variable number of arguments.
> 
> This will put these macros more in line with 'alloc_ordered_workqueue' and
> the underlying 'alloc_workqueue()' function.

Those interfaces are deprecated and if you're doing anything with the users,
the right course of action would be converting them to use one of the
alloc_workqueue interfaces.

Thanks.

-- 
tejun
