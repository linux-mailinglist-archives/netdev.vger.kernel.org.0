Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BBE322AE3
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 13:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbhBWM5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 07:57:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36732 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232464AbhBWM5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 07:57:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614084982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VGX4av4aELQvmxhToSs06FARrEgYr2ky959AcUMe3H4=;
        b=PUhJ/djDhmLh1c9fIwCGuSSd3uWrMIGEM+CBIR0J/KcXBHHIB5foXVpgLESTeurT4ExzIh
        2InF9OyxftJxzI7QhM9PEFKiewvnx54RgDn/+gFEjdCSJY9Gr4WUhgaaG9gVJOC9cPFZkY
        8qJHw+cdUcJIf2bcqArPiIxGL8IxahQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-SBQayoibNRm_si8Focei-A-1; Tue, 23 Feb 2021 07:56:20 -0500
X-MC-Unique: SBQayoibNRm_si8Focei-A-1
Received: by mail-wr1-f70.google.com with SMTP id i2so3762536wru.1
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 04:56:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VGX4av4aELQvmxhToSs06FARrEgYr2ky959AcUMe3H4=;
        b=gytO0lNVEsNcEXHs4J7GUJXo1IaXRseH+hi3T8lsty2EMX1Y6E1IfuMS6fGEkTxdz7
         ndmJfzJY0IX2XYPGGrf39dMMwrF4V2dyeLFInDA16NorIDzCQsehgbLwte0q+CgyxP2z
         ksC9+u7+VA4z3AmWWvC8hs1/EUgB+8CPfFeJbd3dzTK86oEwD2WT8tMEiyZem76S9CiF
         nHPAIDf2CZlmqVSWF8/d3b53j8WAwhClm8IUAFriQY6weeqyt3QDkWiAt5HIMVYB1vSb
         Cmoxz7aFHsAvnoxdlStZspCL2jBt/OYyPiII9AN233rn9DDuUf/aAkE65VLIk0xbSqfE
         ZLAQ==
X-Gm-Message-State: AOAM532IJnteLk6SE9NG3YTzZOAa3t7mexzmSaTxGOFIURms5mE/pDNP
        Ndr0+RlPhZ5mqNApIDjsiDyUKfE4pv9Hti3xVnabK4Y7nQ3MnXtALir/1qhdI7kAlaRr7aN9Hd4
        HZezuf3uMvPDXRGrX
X-Received: by 2002:a5d:4c45:: with SMTP id n5mr6795864wrt.370.1614084979570;
        Tue, 23 Feb 2021 04:56:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzOkkpVZ/w6Xbi3Y2JFXjcz0IESdg+8qMCw1uDa0yv860hSl1r4oLfkfq1xmTV0zflrBRnYxw==
X-Received: by 2002:a5d:4c45:: with SMTP id n5mr6795852wrt.370.1614084979471;
        Tue, 23 Feb 2021 04:56:19 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id z11sm533005wmf.28.2021.02.23.04.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 04:56:19 -0800 (PST)
Date:   Tue, 23 Feb 2021 07:56:16 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     jasowang@redhat.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH v2] vdpa/mlx5: Enable user to add/delete vdpa device
Message-ID: <20210223075508-mutt-send-email-mst@kernel.org>
References: <20210218074157.43220-1-elic@nvidia.com>
 <20210223072847-mutt-send-email-mst@kernel.org>
 <20210223123304.GA170700@mtl-vdi-166.wap.labs.mlnx>
 <20210223075211-mutt-send-email-mst@kernel.org>
 <20210223125442.GA171540@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223125442.GA171540@mtl-vdi-166.wap.labs.mlnx>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 02:54:42PM +0200, Eli Cohen wrote:
> On Tue, Feb 23, 2021 at 07:52:34AM -0500, Michael S. Tsirkin wrote:
> > 
> > I think I have them in the linux next branch, no?
> > 
> 
> You do.

I guest there's a conflict with some other patch in that tree then.
Can you rebase please?

-- 
MST

