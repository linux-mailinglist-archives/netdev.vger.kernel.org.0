Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3373E359BD9
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 12:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbhDIKVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 06:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234457AbhDIKUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 06:20:15 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37014C061760
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 03:20:01 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so4758429pjh.1
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 03:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gtFeJhmGJ+7JyTnNumGxRwfBuWH74EWer/oxb3y1Xi0=;
        b=kCJOKQ5ywaF+s3qKkIa1Vr/zoowQI1G7vxbz0yyOkJNda4onQ+woLS/rI/AHlNScMS
         YdsI5DxYgdfm03qkrFqYTNF7dAPT/fy5T1xT5SnhXftuzagedXVdc27loLROtu6nYFnc
         FGw3IqP1o32LAbaW/h9FL7KbLp1xgEwZnoSL7YYB/PrM5SB5ZWORuxZkjD6gDOpYjoja
         U0lRpELnMhie1MzgZvTU8Fyoma2uB+aaBJ95YyvTr1/7Ou2PgkSjAmtqPL6mv0XqS8W1
         wREt+n8hf/pSxw6kP2iYv8R4VFhSrd6PkedSdrrIMXucsATweUHmJRw2vlbCwflvGlVo
         ZoXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gtFeJhmGJ+7JyTnNumGxRwfBuWH74EWer/oxb3y1Xi0=;
        b=dkDz07Fj7j1RtG/XwoROtlvPYi3YDFQavHWrfH1qcyIA6A3EBpdADoclNGkQNbogii
         iSbNjlWbMSrCDIkhh+5U7KNXkpwi4EelnJEql5ReNA9CcQhY5mvPJc9XRS5O5mYOGCOP
         XXL8oxx/pDier4PtrbyYnNanTd8zdR9qWMwunnjiZtLpOVSu4t8u4OYoFewRmroE9Oww
         aVH1kQGIUFPX9B7BaOPoZ1PoFcTwANxTz61ObewhVpWZXKfKlL9MdJ2cGIGE+CiccRpv
         cNn+9RNRI1cTsBPFfE8/WkpSqEKpSFx9s8MqVZ+NrjRoCFHl/XpMwzEtELfi3yIUCce9
         9g8Q==
X-Gm-Message-State: AOAM530j1Bh0NoZE1uggFlHFZ1OZE4xIO4ATD9pUzusKA58+LgqlzRIx
        RNlVRWZqfoLApRFdwBZPRuI=
X-Google-Smtp-Source: ABdhPJzLzC5gjbcb85D0C+wPknnPnlu2PjeSz9g8821dPJf0Xq1ZgQeCwtg0i4LL4fiqDJHfxBLuwA==
X-Received: by 2002:a17:90a:d812:: with SMTP id a18mr7070916pjv.192.1617963600822;
        Fri, 09 Apr 2021 03:20:00 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id z25sm1920366pfn.37.2021.04.09.03.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 03:20:00 -0700 (PDT)
Date:   Fri, 9 Apr 2021 13:19:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] enetc: Use generic rule to map Tx rings to
 interrupt vectors
Message-ID: <20210409101952.iyf4svtgxvgwvxfr@skbuf>
References: <20210409071613.28912-1-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409071613.28912-1-claudiu.manoil@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 10:16:13AM +0300, Claudiu Manoil wrote:
> Even if the current mapping is correct for the 1 CPU and 2 CPU cases
> (currently enetc is included in SoCs with up to 2 CPUs only), better
> use a generic rule for the mapping to cover all possible cases.
> The number of CPUs is the same as the number of interrupt vectors:
> 
> Per device Tx rings -
> device_tx_ring[idx], where idx = 0..n_rings_total-1
> 
> Per interrupt vector Tx rings -
> int_vector[i].ring[j], where i = 0..n_int_vects-1
> 			     j = 0..n_rings_per_v-1
> 
> Mapping rule -
> n_rings_per_v = n_rings_total / n_int_vects
> for i = 0..n_int_vects - 1:
> 	for j = 0..n_rings_per_v - 1:
> 		idx = n_int_vects * j + i
> 		int_vector[i].ring[j] <- device_tx_ring[idx]
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> ---

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
