Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0643A7645
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 07:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhFOFLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 01:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhFOFLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 01:11:04 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982D5C061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 22:08:59 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id k7so20299021ejv.12
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 22:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=09R47lKbCpWZRtAc3ORA/O+p7bPMVZCUL7kYcHlzHt4=;
        b=azLNpRDxSH0DjzxWYj6dQHZYFjfbwsWy2mCWabu5sapYVMqebWkMXS6nJFBvcxj0j2
         DAiw+IsqPMCgtzKeAly/mInwvjTzZLCyub175dRba/c0g10SUqyESkDRZxZZfiKPwFEG
         D1MdtKQzFXjJUNNzjIBFxKuKR+k8OKcPuQIiXvEiG7eta0/lkZ3I6l0NfvBiwikrrSVo
         Ix0V6m39fPWKjErXLBJiBzmhXXOusOpdhQqPflEmWqw3PYWBpW7NSQtP9r+gMeXBHrY0
         07uIFMmui1AgvLEwsZIxZU4UN9abpvouLX26+HkOPh0DK0woEJY+Fzv3+sbo/KZAbxrE
         FZ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=09R47lKbCpWZRtAc3ORA/O+p7bPMVZCUL7kYcHlzHt4=;
        b=rTkh0acuhke19/LZNi4IPo1xr1jW3mPrJcDytgpURm8O5bdq4w61bF1DKWXmBAADN5
         WUDXHj2tQchhCBd6GirG+n4IGt0HDxcNxircI9lT006b3YgEAoR8OybITSiB8UlbtJfS
         TwAUpvKVySZjZPYSP75hRxHEBT81sSBaLLmA4d5GrRscjrhsVorRAZGF0dFHUJ0Aj3Fq
         Lr4eeJXxPzSZkcD6hkmc78FGav+gCkjm3xk9qcPBobsXH+iS3J+w9HcgJcDqQaT4yd86
         zuxF+evpfvhzczTAy3JNLeCXVwuf/sAgK4OUI8hEdYlP5vJnOGMQZQ5/Y8RsAAaKk8cl
         WvqA==
X-Gm-Message-State: AOAM530R2aJ/Xta4Qew3MGUmJ6anWDhjUBas4bqOL+HehsNg+0acT1I2
        8TSf8C2N0wblBU1kAnglPu8=
X-Google-Smtp-Source: ABdhPJw30li4hg6jr9xjSRltGlhr9as5Cm803aCbni0FraTj1JouOEuiGUHqF3Fr21HHgcof/JeN4Q==
X-Received: by 2002:a17:906:180a:: with SMTP id v10mr18815776eje.22.1623733738246;
        Mon, 14 Jun 2021 22:08:58 -0700 (PDT)
Received: from localhost ([185.246.22.209])
        by smtp.gmail.com with ESMTPSA id v26sm9007802ejk.70.2021.06.14.22.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 22:08:57 -0700 (PDT)
Date:   Mon, 14 Jun 2021 22:08:50 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net-next 5/8] ice: register 1588 PTP clock device object
 for E810 devices
Message-ID: <20210615050850.GB5517@localhost>
References: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
 <20210611162000.2438023-6-anthony.l.nguyen@intel.com>
 <20210611141800.5ebe1d4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ca27bafc-fdc2-c5f1-fc37-1cdf48d393b2@intel.com>
 <20210614181218.GA7788@localhost>
 <20210614115043.4e2b48da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614115043.4e2b48da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 11:50:43AM -0700, Jakub Kicinski wrote:
> tx->freq is a long, and the conversion to ppb can overflow the s32 type.
> E.g. 281474976645 will become -2 AFAICT. I hacked up phc_ctl to not do
> range checking and kernel happily accepted that value. Shall we do this?

Yes, you are right.  The range check has a bug, and your fix is good.

Thanks,
Richard


