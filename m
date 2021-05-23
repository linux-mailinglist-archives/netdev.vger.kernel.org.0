Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C09E38D942
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 08:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhEWGN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 02:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbhEWGN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 02:13:57 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301BCC061574
        for <netdev@vger.kernel.org>; Sat, 22 May 2021 23:12:29 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id p39so1827806pfw.8
        for <netdev@vger.kernel.org>; Sat, 22 May 2021 23:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=L470gL120MxfdBOa1G1fgUz/mpIX/YpqeAY0lfkmt14=;
        b=cCR9WoGwv+6d+Z6FDxqg3YrChE6BLz+yjYEOoGVLB1KT2AWok+HFENI1PLgLRPkWra
         zjASLBjY2fpdcU+ry9f1MsuP7S2oJr5ynmFwWkoP1+iNgN0v5cVgp8XQMTQmLJO0mXxD
         QHClBPVuF1KgAxOSwOWpZTh4+QkX0/VTD0tvU6sRJDdX0fPxFRbbyAwkdMZ8mCdm7vCM
         3DZHA3787RgnTBxemGPJEs7q4zYcN8MVa4LHWZKQPIzXfndGWHVk5r8skaTkYTh2lMDm
         NqEHv6bGvcLQBbiHeJks9KBhWJTahOUBDdUlay93FNc8+FLwr0Y2UPKWtNDRitSfBruX
         +6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=L470gL120MxfdBOa1G1fgUz/mpIX/YpqeAY0lfkmt14=;
        b=mIy8Zn6+wgJMLrhNyH9KInC1x3wRvvdRNYfZsFM3R2/ToNu6G3v0LK8qMY/Uxp/ht2
         qIr5+d35X4/XTS+KdoCWN5smEViiYImFqYqe0Qxef+RMI+8Rc2S5cbG2U3AAXwHRDZQq
         B0mY/BIUyW/1lxnWNOGTTFJUCKFzeWNebXItQGcSuQsjm2hd9EfkCQ3cn6O0ZiQTmaC4
         eqiQRXkfdzQA5xZB9/J51RoO2e8q5Q0gEQZP7cfXV1W/qaoWD9R6y99XThE+pEKfEqEv
         SYJBLJ24V6imK9tWEmG3Dcx9qxCGkLP8fBizcM/00GqNsJGsO6p1i9ANb+SsKJe5Snvd
         Pd6g==
X-Gm-Message-State: AOAM533cxib7UpsykCNbtrbcmDUjbW7y3X+1sBUdsypcwC7jcjNyGTC/
        byW/t2XCBxvVW379txDVVtx88Q==
X-Google-Smtp-Source: ABdhPJyMP46QeiX9OmqZSELNjBTHwFbX7YqrqgaiTwX/gLneQ8e+QiYTGPvE/TwCj5yykUh1d1He0g==
X-Received: by 2002:a63:fd17:: with SMTP id d23mr7566910pgh.68.1621750348618;
        Sat, 22 May 2021 23:12:28 -0700 (PDT)
Received: from dragon (80.251.214.228.16clouds.com. [80.251.214.228])
        by smtp.gmail.com with ESMTPSA id e9sm7596247pfv.87.2021.05.22.23.12.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 22 May 2021 23:12:28 -0700 (PDT)
Date:   Sun, 23 May 2021 14:12:22 +0800
From:   Shawn Guo <shawn.guo@linaro.org>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: Re: [PATCH] brcmfmac: use ISO3166 country code and 0 rev as fallback
Message-ID: <20210523061221.GD29015@dragon>
References: <20210425110200.3050-1-shawn.guo@linaro.org>
 <b6c5713f-ebf0-9eaf-e871-d5690a6b7c10@broadcom.com>
 <20210428124228.GH15093@dragon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428124228.GH15093@dragon>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 08:42:29PM +0800, Shawn Guo wrote:
> On Wed, Apr 28, 2021 at 02:03:07PM +0200, Arend van Spriel wrote:
> > On 4/25/2021 1:02 PM, Shawn Guo wrote:
> > > Instead of aborting country code setup in firmware, use ISO3166 country
> > > code and 0 rev as fallback, when country_codes mapping table is not
> > > configured.  This fallback saves the country_codes table setup for recent
> > > brcmfmac chipsets/firmwares, which just use ISO3166 code and require no
> > > revision number.
> > 
> > I am somewhat surprised, but with the brcm-spinoffs (cypress/infineon and
> > synaptics) my understanding may have been surpassed by reality. Would you
> > happen to know which chipsets/firmwares require only ISO3166 code and no
> > rev?
> 
> The "no rev" here actually means 'rev' field being zero.  The chipset
> I'm running is a BCM43012 from Synaptics, I think.
> 
> Firmware: BCM43012/2 wl0: Apr 16 2021 15:25:36 version 18.35.389.63.t2 (wlan=r836194) FWID 01-a8c7bac

Arend,

Does it make sense?  Or is there actually a country code mapping table
I'm not aware of?

Shawn
