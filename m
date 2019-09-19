Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97D49B74BF
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 10:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731156AbfISILC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 04:11:02 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35577 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728879AbfISILB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 04:11:01 -0400
Received: by mail-lj1-f194.google.com with SMTP id m7so2643787lji.2
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 01:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vWTyesTFAlUWxsOS21ehxvOZi0RqYj5xXQBProg4XfE=;
        b=rXe/F5TxavfsfISyl61oHPpPYFAXtNxK0aPu9gcpBT19mU+7O3xHbvs6dr2VLalSce
         tw0Vmfoj6Q/c3tSkQv84fBpbNrrdPUQ+lTKYf1dui6MTbxsRKEOztmuazms8Qmqkb5Un
         nC5E3o2SZe7+bQ3t442b/N/Ztwl5aoqyqXa1I/EbGumP2YOweJnia73grzwEf/FF0X3g
         k4yB0wEMqCerKTFtGxfHqUnBwUYbLCFPDHiWW5K27EHHVc12TmsUlck1FvNskC/ioBze
         xJtZUy2O4Z8rYu3fVHHV43j5uKrU943eSwhP/+XSSLXvw1R/6NcY++g6iHfNdT6tNVu7
         dHqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vWTyesTFAlUWxsOS21ehxvOZi0RqYj5xXQBProg4XfE=;
        b=hI33D2B455ahzSZlD3yjrytt3cunHe3XRr0lBmb8wY1tGOusWD4Nu2QrIppHdzUSbK
         8Nw77XxRH2Sir4w5Xpq8xZKyx8j61kTu6/yB7VtIVI9CPlUMH/oIDLVwYOGZ16GnZ/EP
         VXonFGzlOGjsEsLWAE8NyR9fNfSd52/z2eh2B0Gxxn+27rBRAFJnaxbb5fr3TfD3/fAA
         zVdRlosgaC8nZxfb/h4azUmncrunWAVnvTGesq7F5oaA2XTnL+Bkrfq1BdCqWIB8rTdu
         mk0rrWRQhjhFEoQyOXQQf1kA+ssJxJ2b8GAGegjHJ0tEpIMhpcCj5lGLnbvD9Hhe+Dva
         RfSA==
X-Gm-Message-State: APjAAAVKwngJOy4rBJ0Apc+iY8aO4ul4qVPijPVMRFsaZDC0ljbxVDFg
        Ssq/koaG0SVf6vlrCeLluDBMkNPD0Lw=
X-Google-Smtp-Source: APXvYqySFAFaKFVhmmvYWK8tkiKwG5Pj5tiUig8oyYnDSzKh87/0cROlkNdH9E/pxqfsBrlxkAbLDw==
X-Received: by 2002:a2e:b055:: with SMTP id d21mr4662927ljl.236.1568880659687;
        Thu, 19 Sep 2019 01:10:59 -0700 (PDT)
Received: from chr (109-252-60-105.nat.spd-mgts.ru. [109.252.60.105])
        by smtp.gmail.com with ESMTPSA id e17sm757922ljj.104.2019.09.19.01.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 01:10:58 -0700 (PDT)
Date:   Thu, 19 Sep 2019 11:10:56 +0300
From:   Peter Mamonov <pmamonov@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH RFC] net/phy: fix Marvell PHYs probe failure when HWMON
 and THERMAL_OF are enabled
Message-ID: <20190919081055.GD9025@chr>
References: <20190918213837.24585-1-pmamonov@gmail.com>
 <20190919025016.GA12785@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919025016.GA12785@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Andrew,

On Thu, Sep 19, 2019 at 04:50:16AM +0200, Andrew Lunn wrote:
> On Thu, Sep 19, 2019 at 12:38:37AM +0300, Peter Mamonov wrote:
> > Hello,
> > 
> > Some time ago I've discovered that probe functions of certain Marvell PHYs 
> > fail if both HWMON and THERMAL_OF config options are enabled.
> 
> Hi Peter
> 
> It probably affects more then Marvell PHYs.
> 
> > The root 
> > cause of this problem is a lack of an OF node for a PHY's built-in 
> > temperature sensor.  However I consider adding this OF node to be a bit 
> > excessive solution. Am I wrong? Below you will find a one line patch which 
> > fixes the problem.
> 
> Your patch look sensible to me.
> 
> > I've sent it to the releveant maintainers three weeks 
> > ago without any feedback yet.
> 
> Could you point me at the relevant mailing list archive?

Here it is: https://marc.info/?l=linux-pm&m=156691695616377&w=2

Regards,
Peter

> 
>       Thanks
> 	Andrew
