Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20F836277E
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236085AbhDPSJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244363AbhDPSJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 14:09:13 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35D5C061756
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 11:08:45 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id p16so10450500plf.12
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 11:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8sHr1KWLYr6hUO2+6Muh8EPhx1F9Tk8jR0NrChU25Qw=;
        b=sbEXaiiHsn3/aSCb6k95Aihy0B3zcE8x0t+7bwBKOEWSw41rec5+GbSmBF+x3vx1W+
         22CrjlXWaHoiS4q4DLqsFhuLaMUxCI3s9iBTVJrsCbwKIf1jvEyvfo4/39HSO6Y1OPTB
         kXinE7pzB/pIxaVPpuS0hN65eM5JWBoeW4iK9wAbCviURxQayXdM5s3G6C9jPXR+9Acx
         +o6dG5dzwQXaOa1dKA8eJiQdhjPU72dHDgNDwH3pZDK9ftzIT9m1LtOSPG6j0w8yAMhh
         CDFTk6TA6U4C4YF7DnVHigczZ2qBFNr7Eyzdn5xKNYwVBPCAvlaRhZM1pMRZDhD2f3GK
         cZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8sHr1KWLYr6hUO2+6Muh8EPhx1F9Tk8jR0NrChU25Qw=;
        b=J1m3tENMu0dfh84wRjGmbI6891JBfxCaBYlprpNOmPZvJ/RhDQzfFwRPEFb7Lv8qqx
         wBBcFJn+9gY35akrFuE8zIKHR1PKTwp4CvjRPu4vSC84kaM2Dp93pL4x4s5hIu0N0BfJ
         UWs3yb7Tfe8MDq0hK7IhWpR7te9RH6TK7tV7csxoQCWdax3VPJQe1K3wRsdj4FQJjxGV
         TkZ+s3Vwk05+gg+nBZElBpgDXKUsR+KuloB0UXY8lng1AuG4DWFqBzgaDKo2TJeP39Gg
         IDEjLxpOoQWRaZ0ADY1QsKwfTChfoL6qyjG4PkcHxBZrVO9LDzP7LRktKwVkYZw/ZBEQ
         iAEA==
X-Gm-Message-State: AOAM532d4GhM+Y38dPnM9+F8EpXlyCUxg8MdYxdsgwpXIFasLNLgqiVE
        6LlrUlSwdU0Z7gp7uqCVF9Fg0Q==
X-Google-Smtp-Source: ABdhPJyR0UqNjrwgaE5FPswaP50mdYiX9Xg7XwWgE+Ls0+GtsSCX9wkO/QEQHFbjOXib9i6gAOaJRg==
X-Received: by 2002:a17:90a:528b:: with SMTP id w11mr11115174pjh.162.1618596525196;
        Fri, 16 Apr 2021 11:08:45 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id x29sm2543765pga.70.2021.04.16.11.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 11:08:44 -0700 (PDT)
Date:   Fri, 16 Apr 2021 11:08:36 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Haiyang Zhang <haiyangz@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH v7 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <20210416110836.67a4a88e@hermes.local>
In-Reply-To: <MW2PR2101MB0892EE955B75C2442E266DB9BF4C9@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210416060705.21998-1-decui@microsoft.com>
        <20210416094006.70661f47@hermes.local>
        <MN2PR21MB12957D66D4DB4B3B7BAEFCA5CA4C9@MN2PR21MB1295.namprd21.prod.outlook.com>
        <MW2PR2101MB0892EE955B75C2442E266DB9BF4C9@MW2PR2101MB0892.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Apr 2021 17:58:45 +0000
Dexuan Cui <decui@microsoft.com> wrote:

> > >
> > > This probably should be a separate patch.
> > > I think it is trying to address the case of VF discovery in Hyper-V/Azure where
> > > the reported
> > > VF from Hypervisor is bogus or confused.  
> > 
> > This is for the Multi vPorts feature of MANA driver, which allows one VF to
> > create multiple vPorts (NICs). They have the same PCI device and same VF
> > serial number, but different MACs.
> > 
> > So we put the change in one patch to avoid distro vendors missing this
> > change when backporting the MANA driver.
> > 
> > Thanks,
> > - Haiyang  
> 
> The netvsc change should come together in the same patch with this VF
> driver, otherwise the multi-vPorts functionality doesn't work properly.
> 
> The netvsc change should not break any other existing VF drivers, because
> Hyper-V NIC SR-IOV implementation requires the the NetVSC network
> interface and the VF network interface should have the same MAC address,
> otherwise things won't work.
> 
> Thanks,
> Dexuan

Distro vendors should be able to handle a patch series.
Don't see why this could not be two patch series.
