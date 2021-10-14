Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB9642DB58
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhJNOWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbhJNOWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 10:22:12 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE122C061570;
        Thu, 14 Oct 2021 07:20:07 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id g8so25100208edt.7;
        Thu, 14 Oct 2021 07:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7Pye4dG5TzjPVrX9c8oeWbQoM2y1O4UpzQfA4r8OJaA=;
        b=WwdTRvdKab+eMr3+y9HfZBaeaAsfYnX4mcEtXNjSKSOQ2SSl+BCKfBohsaYTL29FSG
         GTuq0kFig2krOZmzXe+Vp9mLJMw6M9VV8NpKTss4BySFLwnmdvuEeIwZ+/fhZ4PYPboI
         rZ2mv5TBM/0vv8YMt/F2fKSUm8bBu6eG9L9BPFp81YLbSqrIKJfrbFuRQ1fxNNO1/Sr0
         c9KTkWeMMknBILsRcIpBCUX4DG0bydF9whpQSCq6eY3xLUWMMtsiNSg/Q7S9stiGtOt6
         o6+PbwwEvtOxbFPos2uFWkmr19d4t6n4xDeeQSedphdPLSkiBq6WIkYse7IC41o1X+8p
         8z6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7Pye4dG5TzjPVrX9c8oeWbQoM2y1O4UpzQfA4r8OJaA=;
        b=rqoGW7SvMsDx2lnLKhdIv7Sqpd26mz1oKk+Gx4ydOkS+St13oYy0ciPPrSbpfW/lsO
         UMWD2yiEjxamjzLC+OeXFJKGrER6RyXAuV2AQjHltw9CjTwPn6d8vBckDJrjLjOJdWxr
         VwRlwb0S/SZyBLHXQ5ZGkZzK+r6R/1sN5ZWcU3qVYC3RdcGN63psBJL7TDz7fXz7iP/e
         Xntxhx5fuubykJMIk/uuNIV2IECzKZho4W1J+Ww3ZgbF5vDWc4yiXAmtiGy9wAb3AUTD
         0V6fj/aLlXg9/aDJbZ3JmZ/gzX7g2xQGCcYlStlPn0eozzVNsZcAtaj0jKAo7u397hnE
         y89g==
X-Gm-Message-State: AOAM533oOQuAlxMpS1UAQa57FRuk0CUhJLBJxS7gB0+059HITPsCk3bj
        211Z+EEVFo5jAY5FI9zC1ys=
X-Google-Smtp-Source: ABdhPJy0+pozCqlTwocQGfr9R46cwy6kWFFfRiMq/UXnrJH8vQXJ8/wSBT8bV0wifyFZDclOSHVWsQ==
X-Received: by 2002:a17:906:7c4f:: with SMTP id g15mr3948514ejp.373.1634221172254;
        Thu, 14 Oct 2021 07:19:32 -0700 (PDT)
Received: from skbuf ([188.25.225.253])
        by smtp.gmail.com with ESMTPSA id s3sm2107994ejm.49.2021.10.14.07.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 07:19:31 -0700 (PDT)
Date:   Thu, 14 Oct 2021 17:19:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 net-next 10/10] net: dsa: microchip: add support for
 vlan operations
Message-ID: <20211014141930.3e5x2wgitsw57v4z@skbuf>
References: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
 <20211007151200.748944-11-prasanna.vengateshan@microchip.com>
 <20211007201705.polwaqgbzff4u3vx@skbuf>
 <6c97e0771204b492f31b3d003a5fd97d789920ef.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c97e0771204b492f31b3d003a5fd97d789920ef.camel@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 11:13:36PM +0530, Prasanna Vengateshan wrote:
> > Do you have an explanation for what SW_VLAN_ENABLE does exactly?
> Enabling the VLAN mode and then act as per the VLAN table.
> Do you want me to add this explanation as a comment? or?

Yes, not all switches have the same knobs, it would be good to have a
comment about what you are changing.

> Step (0)
> > ip link add br0 type bridge vlan_filtering 1
> > ip link set lan0 master br0
> > bridge vlan add dev lan0 vid 100 pvid untagged
> Step (1)
> > bridge vlan del dev lan0 vid 100
> Step (2)
> > ip link set br0 type bridge vlan_filtering 0
> > 
> > The expectation is that the switch, being VLAN-unaware as it is currently
> > configured, receives and sends any packet regardless of VLAN ID.
> > If you put an IP on br0 in this state, are you able to ping an outside host?
> 
> I have numbered the commands above.
> Results are,
> Before Step (0). Am able to ping outside.
> After Step (0). Am not able to ping outside because the vlan table is set
> After Step (1). Am not able to ping outside
> After Step (2). Am able to ping outside because of vlan unaware mode.

This sounds okay.
