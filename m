Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C7A32F755
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 01:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhCFAlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 19:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbhCFAlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 19:41:44 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65571C06175F
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 16:41:44 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id dx17so7014050ejb.2
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 16:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BoI581D21P7s+j9xy2IVWqN5SmEXGgwbSMY/DrdAr6Q=;
        b=cez5SrjiulA7cXSgfuhugPQ6f46wjfnQ4n+iN37dOY4EroW10ZG7eF//zNQePgn4N/
         jOKcrEh/5gOOCj0KP5Xxp/x99NTohHtUxZ8bF9TB8p63SNLXtJkJhLjK3YC7Hl/pZW9P
         +YDk6kiOgN8GUsDi38f01SzlykDTbogjkK77pfEbMSshVsziMRVMWp9JKFxDHhKgX6cF
         JxfLzXPpcBHiYxhW38mVe9PTzEosLqqHR36UyUM2DwlmzyTGCCQ0VcauQyYr3voj5yF6
         8LG1LF3AHA23DCSjGaJ+A2Fj0CpbiaShx0CQEpcHFMOSZidjUce1oREmeEXwYiXeVZTT
         wwRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BoI581D21P7s+j9xy2IVWqN5SmEXGgwbSMY/DrdAr6Q=;
        b=t08BQcglD1bHq0nz51WEWozlmY4DeqrVVCqPQ1nd2txaQIPxH2IWZDy/Ls5AjkA12R
         G8rg8ymKXmoCT4AdN4TQ/IFIj3uBjnC1iwcFGV2PbpMABFiuVqpJqC+ZtkAAGCfpBz1G
         mhIGeLx8/bQ4+9kAmmEbKQ7XOvuh4/Ufdfy9QRLaIDN/ooLRshEZT0hI0KWZM6mzZFLp
         KOi8sJK+90TLvitOTc0xcnvws0BRMgyt3Xay0ENm4/JCpASQMjA4LPZ/sFpf12qY4B7S
         uJrgJHPXGlPkg0+eHDt7fPTtDdXpen5xrrENu7CUVMXEBm+aso1qQoslXM+er14Wl6Hn
         vQ9Q==
X-Gm-Message-State: AOAM5337z9WCTBDEMwStK2AD/9yR0yPQgFaCGE2nmuWYgrktSkcvPd0Y
        Ydc0dgVn7toQjPDX55VQBI0=
X-Google-Smtp-Source: ABdhPJxwQL+wldK2JdFf7YInqBunNRyHPSv5duYqZ2zP8RI2W6YS9xTGuH2b6df6SFP4gRSvnjHq8Q==
X-Received: by 2002:a17:906:7389:: with SMTP id f9mr4688321ejl.423.1614991302995;
        Fri, 05 Mar 2021 16:41:42 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id lu5sm2409628ejb.97.2021.03.05.16.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 16:41:42 -0800 (PST)
Date:   Sat, 6 Mar 2021 02:41:41 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] net: dsa: Avoid VLAN config corruption
Message-ID: <20210306004141.2ykprg7uoztief2w@skbuf>
References: <20210306002455.1582593-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210306002455.1582593-1-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 06, 2021 at 01:24:53AM +0100, Tobias Waldekranz wrote:
> The story here is basically:
> 
> 1. Bridge port attributes should not be offloaded if an intermediate
>    stacked device (a LAG) is not offloaded. (5696c8aedfcc)
> 
> 2. (1) broke VLAN filtering events from being processed by DSA, we
>    must accept that orig_dev can be the bridge itself. (99b8202b179f)
> 
> 3. (2) broke regular old VLAN configuration, as events generated to
>    notify the ports that a new VLAN was created in the bridge were now
>    interpreted as that VLAN being added to the port.
> 
> Which brings us to this series, which tries to put an end to this saga
> by reverting (2) and then provides a new fix for that issue which
> accepts that orig_dev may be the bridge master, but only for
> applicable attributes, and never for switchdev objects.
> 
> I am not really sure about the process here. Is it fine to revert even
> if that re-introduces a bug that is then fixed in a followup commit,
> or should this be squashed to a single commit?
> 
> Tobias Waldekranz (2):
>   Revert "net: dsa: fix SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING getting
>     ignored"
>   net: dsa: Always react to global bridge attribute changes
> 
>  net/dsa/dsa_priv.h | 10 +---------
>  net/dsa/slave.c    | 17 +++++++++++++++--
>  2 files changed, 16 insertions(+), 11 deletions(-)
> 
> -- 
> 2.25.1
> 

I will take a look at these patches tomorrow, David please don't apply
them, I would like to get some sleep first.
