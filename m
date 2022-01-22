Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B9B496958
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 03:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbiAVCJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 21:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiAVCJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 21:09:05 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A90C06173B;
        Fri, 21 Jan 2022 18:09:02 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id pf13so10746525pjb.0;
        Fri, 21 Jan 2022 18:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xyOk/FAZbm+ohK6OiqKf0XpTyeWorsmSl49Ig0dTZjA=;
        b=DYhZevV3RNBny+PzXz27B5E2YfbZ0WGvUBHjnATxP46EGzxXny2aD/ZSwnG5Afc30k
         WR6maAkSYPMTWJ50pWJx4u57zASfu4+YYPNZWMrEuPl0Rad4HH68Z/rOfWDBKn7+Cxvb
         nZzHNEDpoESyO0+MGaT15KwhAp8sKYtFBdZm+uu2xo4DwqQ3iIggwSuzLfy7n7yuQaMl
         Gbw944B1GuAphGhiko0zXhC7uTTkaKAijTAg9j556N/AsqZ82OSiw+1Bd32U54eC1GTt
         4IVYcf8GQ9ZEDIGnQvEM0pyyjOOCXKt5RSdiBQcRdL9ZGwRNN2/mjX9ykNjzvrI7Ovv4
         JawQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xyOk/FAZbm+ohK6OiqKf0XpTyeWorsmSl49Ig0dTZjA=;
        b=KSF4amzn+S9aG7cLZDz6G0l0Sr+rbchDWjsNMMf4deo+7D7Y2kUQpFUnpG8/jDw6GW
         sNT7sD53n5admLoRSU2HwDaWJEc00e0RohMmXoqac26VsBDYlmZDtoYw4bIODHFykziI
         JG/aTh13sTqyfQXhYnZZvc2Qr7o16+2JixwnV5W+vsp+66ZFOyvgwQnWXfOWa3yniCTq
         NKJzWE6o/rW8L4Hb9eXdb4ws08rPAN7PLfT0tSEbconOCYXGAV8s4fPz1NTCmg7KRyq1
         XJv3eudbA88G4pJjqTH6qay3WyZ3T9mMB5KYI91ICdcQd8PaJ7fUprw5Nl/Ix+bc52/G
         loVA==
X-Gm-Message-State: AOAM532B3iOSKcT6bTGdO7G6xTOXWEhcTt43w0M5xQErwLyTaIWRBEfN
        m7BkgWueThesxYzKTXXS8f0=
X-Google-Smtp-Source: ABdhPJx+1iq4y2x+etprTIGzbhs/wzRvN3S8nrtBF5D60XjHIgp2dxEzdegfW34h0ZS/fexqvlDKyg==
X-Received: by 2002:a17:902:ecc1:b0:14a:e540:6c84 with SMTP id a1-20020a170902ecc100b0014ae5406c84mr6076869plh.120.1642817337350;
        Fri, 21 Jan 2022 18:08:57 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id s12sm637141pfd.112.2022.01.21.18.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 18:08:56 -0800 (PST)
Date:   Fri, 21 Jan 2022 18:08:54 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Message-ID: <20220122020854.GA23783@hoboy.vegasvil.org>
References: <20220103232555.19791-4-richardcochran@gmail.com>
 <20220120164832.xdebp5vykib6h6dp@skbuf>
 <Yeoqof1onvrcWGNp@lunn.ch>
 <20220121040508.GA7588@hoboy.vegasvil.org>
 <20220121145035.z4yv2qsub5mr7ljs@skbuf>
 <20220121152820.GA15600@hoboy.vegasvil.org>
 <20220121162327.4p3iqbtt4qtnknhp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121162327.4p3iqbtt4qtnknhp@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 04:23:27PM +0000, Vladimir Oltean wrote:
> On Fri, Jan 21, 2022 at 07:28:20AM -0800, Richard Cochran wrote:
> > On Fri, Jan 21, 2022 at 02:50:36PM +0000, Vladimir Oltean wrote:
> > > So as I mentioned earlier, the use case would be hardware performance
> > > testing and diagnosing. You may consider that as not that important, but
> > > this is basically what I had to do for several months, and even wrote
> > > a program for that, that collects packet timestamps at all possible points.
> > 
> > This is not possible without making a brand new CMSG to accommodate
> > time stamps from all the various layers.
> > 
> > That is completely out of scope for this series.
> > 
> > The only practical use case of this series is to switch from PHY back to MAC.
> 
> I don't think my proposal is out of scope.

I don't see a way to implement your proposal at all.

If you want to implement your proposal and submit a patch series, I
will gladly drop mine in favor of yours.  Otherwise, my series solves
a real world problem and improves the stack at least a little bit.

Thanks,
Richard


