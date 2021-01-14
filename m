Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53452F5685
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbhANBtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729910AbhANAhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 19:37:07 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA5CC061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 16:36:08 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id t16so5678027ejf.13
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 16:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jQ3q+WhHl8XDnkyZLfZf/0r0zfEDCNob+tkx0k0QqDs=;
        b=EcxfSC+XBd7QTI/9aOZyXzSQ6d9kkDq5CbPinLzDVkFA9Y24N8Sh/a/CPsjW64eOyR
         0TOu0q87IS4G5qQtLBsVcY65rtVae+PAjI0nuZbMdv2RLgQNpKAY9U8QUqWWLA9dca6Q
         AStgFD4XrFHSnBuRF+BqFEmdgpfUP+6FdZ9mWScK0Pv3z/Ko6PFnAcCsBWR24XChawzZ
         iDGpxEEGITO0yrGvD9mu0Hdt2FV5IIRu56Udlj5jkJOjQg1qtGeNzBESfCjG75aubTU8
         vO8vUR97CG98lWrrKBcgfF97J6hFVp3Uf2EWJZqgbgSCVS/ApYH/gtE/6IGL4Lq4oN4z
         OP4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jQ3q+WhHl8XDnkyZLfZf/0r0zfEDCNob+tkx0k0QqDs=;
        b=am5eiT4dnFExBIdvuy3K1gDEyUpxp4V7vM5cMWpKNEeEz8HLWIiffSrnn6UMSuO9Lv
         ewn1/BYoXAenAYch7kwN96iF35FLy1WI+Z/S69nzz8Ejb+XOJladwSOPVkpM/PTrVDYC
         Q4EQmiA71l/eRW4YdhEiHq2BCjv5lE2EP3dI+8MlfK2OZabFtKW+yB+/9N4IEhwqSL52
         yxL/Zn5KMXMFG8Zhca17OvovdZGGgUcCrFxzw4eJFoat/m2tP8aE6Vt7WLsu8WlAKZ1b
         BO2qG2vNIuoFWui8HupIUPRhK6S5k4OTPiTy83aFrTi4ZQ0HAaDkXaOxkBFSd7/rVSLm
         Qt/w==
X-Gm-Message-State: AOAM530X5pAVlw7QIis0fZjZRuYAZS4x8mx/nO9uYwvprmk+qkKMPwTL
        u5wdx189p+i/QOhF/t3K82A=
X-Google-Smtp-Source: ABdhPJzwbfUki6LodktUvkUDXNvDYnRUWslvIq/I2UiGV18Uoo12LrvSzYryyf0G9U8+0/77juTUqw==
X-Received: by 2002:a17:906:ec9:: with SMTP id u9mr3447479eji.400.1610584567154;
        Wed, 13 Jan 2021 16:36:07 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h12sm922445edb.16.2021.01.13.16.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 16:36:06 -0800 (PST)
Date:   Thu, 14 Jan 2021 02:36:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5 net-next 2/5] net: dsa: Don't offload port attributes
 on standalone ports
Message-ID: <20210114003605.cncsgffxiashxvpv@skbuf>
References: <20210113084255.22675-1-tobias@waldekranz.com>
 <20210113084255.22675-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113084255.22675-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 09:42:52AM +0100, Tobias Waldekranz wrote:
> In a situation where a standalone port is indirectly attached to a
> bridge (e.g. via a LAG) which is not offloaded, do not offload any
> port attributes either. The port should behave as a standard NIC.
> 
> Previously, on mv88e6xxx, this meant that in the following setup:
> 
>      br0
>      /
>   team0
>    / \
> swp0 swp1
> 
> If vlan filtering was enabled on br0, swp0's and swp1's QMode was set
> to "secure". This caused all untagged packets to be dropped, as their
> default VID (0) was not loaded into the VTU.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
