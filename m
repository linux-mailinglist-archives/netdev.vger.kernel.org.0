Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471E13DE2E7
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 01:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbhHBXJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 19:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbhHBXJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 19:09:35 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27261C06175F;
        Mon,  2 Aug 2021 16:09:25 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id k1so21449406plt.12;
        Mon, 02 Aug 2021 16:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Djjsh3U3kf0GEGTy91dZfQ0DmMQTXFKs0ubb2qtf9XA=;
        b=hhyaaXIxPWQLMto0I8ziPj3villrDtRMFjYWpdMPc00wdBCnN1hrq1NRKraiQwglvR
         JGbcVdAdWTWLChRm1vx8dz91bd2g/PxCtY5Nzt6KfsOb24sflKhjLI7Wfph7oQdFIaWf
         Dmwd0Ul/o9fFOawyxqOk5Ua1CLmXhy+M7XzQl8UUcvo2x82S0U7h0lyvgOgFsNk9MS4+
         V0emi3Q28Ttdyv38yHM3M3zwrXSRmqLhuF9T5mNDxm1N3CZnIaZo8BN/vfYmWXh9winG
         ushjT3T/ovn5SdC4BGL6g8qbbA5sfdC7ljPYIVC5qnJ+wag4Xgu8kTIYz8w3bnXkljHr
         Gs+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Djjsh3U3kf0GEGTy91dZfQ0DmMQTXFKs0ubb2qtf9XA=;
        b=VTFY++Xbw5TaqRkrDFNVzELgGHNhs6RPMzwHzg1agOqRK1xW83OzvbIiQsVTeH6Kss
         RBSimQ45ZJ8QDQbZoD3ca6vJkUTAOT/JT08GIPoqfOqWi4BBTNskn1K+xvxxa13dc9KE
         X6cDui83MZQZyZRvHxsHfJWMXDAa7rtzEeu8bTMh9NXJUvfoHkdO0REqwz7kLGlbdcw6
         HxI1pVZS22UWrSM7oc5uisL4wiEJQDJqhataLUif7IZK0zJlJHdhJQmFQhujkr6xddGS
         jww6bRa4FzkFQumAGGsKDMlrpRu5VcNxMVmuDKz03K1XY8ySF53BSLOHZ5I7expae8d4
         y2TQ==
X-Gm-Message-State: AOAM533s/qFhM+ZQNDXv5DZdQT/4ti5+gUUT4p8tWOenUCk+/bbxtc5S
        Ro1rO8fTPMvPjJL0U5GqPYs=
X-Google-Smtp-Source: ABdhPJxF5lDXa0N5v7SXE4P1xCfBjRXp+j9ztLXti7YYk4GohVYB0VTfXZiBiGp6b8aHc5NVKchMYA==
X-Received: by 2002:a17:90b:514:: with SMTP id r20mr19213687pjz.80.1627945764662;
        Mon, 02 Aug 2021 16:09:24 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id v1sm15035565pgj.40.2021.08.02.16.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 16:09:24 -0700 (PDT)
Date:   Mon, 2 Aug 2021 16:09:21 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Message-ID: <20210802230921.GA13623@hoboy.vegasvil.org>
References: <20210802145937.1155571-1-arnd@kernel.org>
 <20210802164907.GA9832@hoboy.vegasvil.org>
 <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 07:54:20PM +0000, Keller, Jacob E wrote:
> So go back to "select"?

Why not keep it simple?

PTP core:
   Boolean PTP_1588_CLOCK

drivers:
   depends on PTP_1588_CLOCK

Also, make Posix timers always part of the core.  Tinification is a
lost cause.

Thanks,
Richard

