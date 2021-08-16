Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4713EE097
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 01:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbhHPXzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 19:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbhHPXzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 19:55:14 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67955C061764;
        Mon, 16 Aug 2021 16:54:42 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id oa17so29068510pjb.1;
        Mon, 16 Aug 2021 16:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4PjLjvPfXT6Ggu3+t/3QP9ZYwtLwsOxNZwtphc9DHvg=;
        b=CSEOy5KO9iJTDIo3e37VnNXhTN22pbnAt5piZzqfDuw22OvJCuHL2liA37WQxtshTe
         2UPZFMEwEGj18zaR5Y6GNbhN7Spso/idQpqzlyjPjBcXMZ3pZZrG3kFQRFRqFwvgrAAc
         nDp1sxWDXoGO81ZpkgqudfjzNREc53948zr6wlsohTAX4mYRZF+6olvs2Sx3YfcianP2
         gMt6mP9Z1ySAFCV7OXZruILfMIuls0EfVEd25d8k/vpnTIsc0zjVF3JTh5Ricv1TfrpC
         ILxWHJxynUmswpwTU9c4KA7RCDx7YSIL1ZgdIjdyw3tvWqELDrvZio3LRRHiyk4P/BvD
         tT6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4PjLjvPfXT6Ggu3+t/3QP9ZYwtLwsOxNZwtphc9DHvg=;
        b=DoY4LKgQD67mvVFFjeINJ8opF14TGGvnYvvIvdM/VsVbds1JWRZ82x2OzDmxuCO2lE
         abCvLp4k/gT5iFBMcs6fPBrBHWWItTyfehCtIA9SZ7tRrsBTL+EYnCz7+fWZMQN0w2kd
         Yi+igIEbdOtLOn6FHoS5tayaGLk5M7470dWt7RLIgXTafK/YLYvYC3kQvU6F7QB9iU3M
         LkdvBmmyIvJ/JHrrvkkgSa0DFiYpl89j+A7Dj5E/8Hc98GSN+AiMKsCqnkWdZCnJ5Yvd
         StCfm8/EKaQUkdSXL3JfOWdRNM8EWd8lJggmvtKEs7FFn94RGNdJ8O1vB5Ew0PRMipwQ
         FytA==
X-Gm-Message-State: AOAM530vl3saT6WRwka13HYB/szDbB3afxFCclPsFD6a/YEvyVHK5Gxm
        /Ymtv93MPX92fgtdbgh1lWM=
X-Google-Smtp-Source: ABdhPJyR9MZhcHW80mqUzt9wrkKCjfK4t8KnWh9xQXq9WiK1alp/wk2DT4zGO9AZJak/kcTRB5Q51Q==
X-Received: by 2002:a17:902:fe82:b029:12d:61a2:3674 with SMTP id x2-20020a170902fe82b029012d61a23674mr511388plm.60.1629158082029;
        Mon, 16 Aug 2021 16:54:42 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 31sm316012pgy.26.2021.08.16.16.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 16:54:41 -0700 (PDT)
Date:   Mon, 16 Aug 2021 16:54:38 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Cc:     linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        arnd@arndb.de, nikolay@nvidia.com, cong.wang@bytedance.com,
        colin.king@canonical.com, gustavoars@kernel.org
Subject: Re: [RFC net-next 2/7] selftests/ptp: Add usage of PTP_DPLL_GETSTATE
 ioctl in testptp
Message-ID: <20210816235438.GB24680@hoboy.vegasvil.org>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
 <20210816160717.31285-3-arkadiusz.kubalewski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816160717.31285-3-arkadiusz.kubalewski@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 06:07:12PM +0200, Arkadiusz Kubalewski wrote:
> Allow get Digital Phase Locked Loop state of ptp enabled device
> through ptp related ioctl PTP_DPLL_GETSTATE.

So I think this should go into ethtool instead.

Thanks,
Richard
