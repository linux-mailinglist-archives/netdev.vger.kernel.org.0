Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D871D3DDDF0
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 18:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbhHBQtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 12:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhHBQtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 12:49:21 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C33C06175F;
        Mon,  2 Aug 2021 09:49:10 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c16so20303833plh.7;
        Mon, 02 Aug 2021 09:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oNZPc57psRzc4SpvXgutcnyNtEY7iJ7TN/eALuzAAak=;
        b=HQaqv3/xiSaIFj/69P2YGGTBVMq0Yxb1LE5e3kjaM35yRW1h1hVUsSwRGevudlYLP/
         gWwXAs1qKAuoLXWxkb+y7xLDLVxZRtkawr9hycVD50BRfhrfjNCsnDTobhlxYdS72p8I
         EG2CwzI8tfKIBrqaqDn/NzeM6JvC/RQMEqrK8glX9tE9nOTTxOe4FipVXtaCYYZhwwx1
         rQR2u9Zcslgf4XJmlA5E+ehG0Wrh6+5bv3SKIu/AUdjW2FbjbFw+dOItcZkNROdck/ua
         NiViC00+5FOOlpaSQD4+r5hk1gjfhr/TBLon6I9U91YvqwypdbnGT1xUtvMomieLakmK
         k6tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oNZPc57psRzc4SpvXgutcnyNtEY7iJ7TN/eALuzAAak=;
        b=KlFvNQYBw8WDLRWRpoa009mFG+5FcAD4YYHXODMFzdUsk2nvWJoQgk8IuAHWO6/fAH
         RiJM9Les8iG5/DRpd3RTgPu8WrnfJGDBV/E4bZYhcCyuN39nlMtgA87RIYZagjsr39DR
         ee5xmDhjaLcGW7olYR5wlK6ML9QHQ2WeDBBQdT3H9iCjtdV/b4HoPUVF/1gMzpbZwSwy
         DUXozpTLSiTgzbaBugi0MEihCmI0FyI9DaCkwQf5XulT17T+iPPqN/+aYsw4x3f5r7C/
         ccwl6WtnDudufN1uAhMahsnrpVt8/OEbVihglZwRNFyFc9+LLH1x+EGtibAMc1rq4nfw
         HdBQ==
X-Gm-Message-State: AOAM532gBZMeTD/W13llcOjYCcbQeYzc/DlhIyJyU9Hn0HQox8iV9USk
        /O7VDyVS1obN1vVUCHaiHZo=
X-Google-Smtp-Source: ABdhPJxNzGuRmCkcB5lxAkv5+Hij2CzC5OOIrqElQnqMRH2+TKkUS1eq3pWmGzRIIl6ZJBmvBOgmdQ==
X-Received: by 2002:a17:90b:1495:: with SMTP id js21mr18397651pjb.2.1627922950483;
        Mon, 02 Aug 2021 09:49:10 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id c21sm2143687pfo.193.2021.08.02.09.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 09:49:10 -0700 (PDT)
Date:   Mon, 2 Aug 2021 09:49:07 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Message-ID: <20210802164907.GA9832@hoboy.vegasvil.org>
References: <20210802145937.1155571-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802145937.1155571-1-arnd@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 04:59:33PM +0200, Arnd Bergmann wrote:

> This is a recurring problem in many drivers, and we have discussed
> it several times befores, without reaching a consensus. I'm providing
> a link to the previous email thread for reference, which discusses
> some related problems, though I can't find what reasons there were
> against the approach with the extra Kconfig dependency.

Quoting myself in the thread from 12 Nov 2020:

   This whole "implies" thing turned out to be a colossal PITA.

   I regret the fact that it got merged.  It wasn't my idea.

This whole thing came about because Nicolas Pitre wanted to make PHC
core support into a module and also to be able to remove dynamic posix
clock support for tinification.  It has proved to be a never ending
source of confusion.

Let's restore the core functionality and remove "implies" for good.

Thanks,
Richard
