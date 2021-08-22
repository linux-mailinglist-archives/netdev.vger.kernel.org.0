Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F7A3F3D26
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 04:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhHVCbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 22:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhHVCbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 22:31:41 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4D8C061575;
        Sat, 21 Aug 2021 19:31:01 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id n18so13228236pgm.12;
        Sat, 21 Aug 2021 19:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XSTqDa97zOWgSBwGLOjBEzY0W1HCbmfHTpND18fwsyA=;
        b=PhbRgYaQFfP7M8LtuZ0DJCgRqBc2hijhPP12YvRUKwgoWfGJfWjb4yDuFfii56KLZx
         UApdP4wFmmp+bk/JkRzpa0RZ0bNMO6dk2YGX3PubQBqiSvbPWBns8puXAyEgDCmG00B7
         tr1Ug/czFutolnj2Qe36ZPYYZhOAnccfghpigop6gfOoSkm04XMamwXZxuQ23biWfg5r
         QTc60M6NIaNGgnBLGkI/blXBoEWtl6MR0PEvsYzfewnZge+ORNa8GokVvugIQtnbX9vk
         Cb5bInAXy/ZIHsL06t2tqvp3KODH+/9slG/it09ZgKWWEofwipch7QXYfXPvXvEqC1LS
         OC1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XSTqDa97zOWgSBwGLOjBEzY0W1HCbmfHTpND18fwsyA=;
        b=DmYEp0x/TEUY7LIrjMzWGZHl8a19frlrdAtXv8+nlzjJm4dxexJhs+MZktL1dr/IkC
         H72o2U2Afo/wpUKiIPBeHcwxkmcusm5PJYdp5piEZDGAqgpZTp+PQ8A+MXmPmEuFR9+C
         sn/icLB46CZ7D85nnAqT58K609vdvowJlKlIVEHIRhNOouchHCO7733GTwec7H26yizo
         8m7P05w8uupR6cyP9i4P/nV/gVRl/OqAjgovdx1kHwR/ypc9JFhFOtuhUtymScrL3SGb
         atXput/w28MJRr3cFhVvq5TRiyx/B+GCc/TV3/Jb1OiJYUyzDhVYV//HaadH8nx6Cmuw
         zgIw==
X-Gm-Message-State: AOAM533WLlAqfnXeJ0JmBEq9+f9bgjbkdGE3jCnlsnMspVdlEHfo4tH7
        iwOBr3Pek7YaLRDluE7NsBY=
X-Google-Smtp-Source: ABdhPJwWkVfbhs8JZCkYB40Ea1nyaA/y97j+qEa6V5jVVdosZTc+l16NXyb9birWU12gqKpy95GIYQ==
X-Received: by 2002:a63:2541:: with SMTP id l62mr26438157pgl.183.1629599460655;
        Sat, 21 Aug 2021 19:31:00 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id mq18sm9743976pjb.45.2021.08.21.19.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 19:31:00 -0700 (PDT)
Date:   Sat, 21 Aug 2021 19:30:57 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "Bross, Kevin" <kevin.bross@intel.com>,
        "Stanton, Kevin B" <kevin.b.stanton@intel.com>,
        Ahmad Byagowi <abyagowi@fb.com>
Subject: Re: [RFC net-next 1/7] ptp: Add interface for acquiring DPLL state
Message-ID: <20210822023057.GA6481@hoboy.vegasvil.org>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
 <20210816160717.31285-2-arkadiusz.kubalewski@intel.com>
 <20210816235400.GA24680@hoboy.vegasvil.org>
 <PH0PR11MB4951762ECB04D90D634E905DEAFE9@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210818170259.GD9992@hoboy.vegasvil.org>
 <PH0PR11MB495162EC9116F197D79589F5EAFF9@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210819153414.GC26242@hoboy.vegasvil.org>
 <PH0PR11MB4951F51CBA231DFD65806CDAEAC09@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210820155538.GB9604@hoboy.vegasvil.org>
 <PH0PR11MB49518ED9AAF8B543FD8324B9EAC19@PH0PR11MB4951.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB49518ED9AAF8B543FD8324B9EAC19@PH0PR11MB4951.namprd11.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 06:30:02PM +0000, Machnikowski, Maciej wrote:

> Since the 40.5.2 is not applicable to higher-speed ethernet which
> don't use auto-negotiation, but rather the link training sequence
> where the RX side always syncs its clock to the TX side.

By "the RX side always syncs its clock to the TX side" do you mean the
RX channel synchronizes to the link partner's TX channel?

Wow, that brings back the 100 megabit scheme I guess.  That's cool,
because the same basic idea applies to the PHYTER then.

Still we are doing to need a way for user space to query the HW
topology to discover whether a given ports may be syntonized from a
second port.  I don't think your pin selection thing works unless user
space can tell what the pins are connected to.

Thanks,
Richard
