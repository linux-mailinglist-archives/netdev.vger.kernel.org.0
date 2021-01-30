Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960C830940F
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 11:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhA3KJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 05:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbhA3CJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 21:09:52 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE31C0613ED;
        Fri, 29 Jan 2021 18:09:06 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id by1so15701525ejc.0;
        Fri, 29 Jan 2021 18:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MU9ukK+giuaa3vu2E7Y8gSnqk8uNjtWUT/IiFfJuCvg=;
        b=XO1gGsWSECIsiMXBzGrrArDzAsM9KTkefej8iUINdq93tWd4bgtKe+Y3vsozz9KdcM
         HgxJ1A+g9vJC/53WkdpRusTcShYlGcWhVNI24VkfL8LHb7HHSEGMh5fd/EJlDOSLQm9T
         5l5Nsejwm+VEXj9fhiLjkaOCvzpjUCUKLVF4/iF9HrHxWdXhaoyjHH7bYJVfMIv5kdj0
         NmqdcEPB/wcWKf4+kimiKdfoimfmVQ7uSuHjEiP9cHI5jS2diIKlSuGGjc4YSSLU5kmY
         eDghgrPVfLuzK19lCwYfZVtRMhqxHF0i6/LeF6HHms8FgdKUvE69dnbGIdmqfTjWXrWm
         VDgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MU9ukK+giuaa3vu2E7Y8gSnqk8uNjtWUT/IiFfJuCvg=;
        b=dkTuQ/7jvnoNpvGiaNGicZHIRH6EUqmhIJeQiSHjvjLHPO4ZGnDj0q7ntBJJjEJaQF
         OXdrDFYAhjT485yBPECfX/LEjaukQ3Tc+Jd8ACa/tbhrFsovtf/TxzYbvXZjnzXb2PAZ
         H7d/cJqUiQGo4zmvv7kYgBckEkOyrQJ36Ds9hayHiZh7qcwl2ed7JUjaEYEaM09qq+lN
         YKw2z9enlxLj1BoS1HizSWUJieQ/2ABN9dVH1QLPxDtxgPFBN4kiD+v1g6Du94lZ7iBR
         J5IH7ARG55UKr1nJ3WX5IhEup7QNdohOPRih0rLlfetrZ3AKulH2tyTM9RDjJkp6BkRB
         gS7Q==
X-Gm-Message-State: AOAM531wAScaEoVSdglyInOjqg7mxfgc9GBrlXFe5TsVhh41GKt0F0Q2
        ImB1ZHT9hzIWsoORZx2rXc4=
X-Google-Smtp-Source: ABdhPJx88NB5VkNqaWKmj2OwT4yNsC9zvpVCwXN2ythxR0UW/m28CF9b06H1Ngz/y9pDA48x6AzGLg==
X-Received: by 2002:a17:906:578e:: with SMTP id k14mr7108279ejq.243.1611972544062;
        Fri, 29 Jan 2021 18:09:04 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id bk2sm4670563ejb.98.2021.01.29.18.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 18:09:03 -0800 (PST)
Date:   Sat, 30 Jan 2021 04:09:02 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        kuba@kernel.org, vivien.didelot@gmail.com, davem@davemloft.net,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 0/8] net: dsa: microchip: DSA driver support for
 LAN937x switch
Message-ID: <20210130020902.546lmczy75pgdadi@skbuf>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
 <bb729a8b-0ea1-e05d-f410-ed049e793d04@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb729a8b-0ea1-e05d-f410-ed049e793d04@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 09:55:58AM -0800, Florian Fainelli wrote:
> Could you also feed back to your hardware organization to settle on a
> tag format that is not a snowflake? Almost *every* switch you have has a
> different tagging format, this is absurd. All other vendors in tree have
> been able to settle on at most 2 or 3 different tagging formats over
> their switching product life span (for some vendors this dates back 20
> years ago).

You can't stop them from innovating, Florian :(
