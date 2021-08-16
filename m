Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181EA3EE091
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 01:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbhHPXyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 19:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbhHPXyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 19:54:36 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB72FC061764;
        Mon, 16 Aug 2021 16:54:04 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id qe12-20020a17090b4f8c00b00179321cbae7so3018554pjb.2;
        Mon, 16 Aug 2021 16:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BfKdf9a3hP34qKR/Mu7UQ/p8Ys9XbVUMS00Wm/SH9LQ=;
        b=UJFjdn57R6ZLNJdG0nVgoLuWUYaatE4olliznOIEMTOe4jP2jVkDNBSpyzoQPGFDR0
         w2Ikwnl1/uLRFDnkJsikom7nQtU17Wy909Rq+AzCda8uMx3ZhFfMEwWknBwZji7NzHfl
         uXM7X4JEcVRTetC57db52g7f/8h+sKJOgA4RAQcEJ1q72QkgWYbKUrk/EUIGxFHJ+dCx
         3Er17K7y9y+kYqJ0lJF3wGbLZK30ZhmOiA4gfhWJv/aYmydmvE2wCHKnWKYYBhFaerB6
         xAROqR8kQIscSZ2RFLm/njtx3CaJmWmA7c8tUJDyiXT7d8kGhw3G1xgFbFTAp+KsWL14
         whzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BfKdf9a3hP34qKR/Mu7UQ/p8Ys9XbVUMS00Wm/SH9LQ=;
        b=seIWRZN2fcjlwB3ISWNCTDCgAD3GYB7I5/I4NEitUgP27jLj2KAu16R2jUGe4VR1I0
         //Il5RbebplzEjrgMsmnzK+26nd/Dacbpu8sbfiP3lownw6fIcHiNYYz+ZpAsGheLrCI
         901HmmEJJlKuGPyrejaAM/LsAKaNvFGsVxm9XEao/Re1gHT9YTjmAbm/dFl1Xb7tF+Ox
         VfhPcx8k/dBH7W316gTIKe0f0ZbfvoX3BwupMapbhBsS5puUVGqnP8XXguw3yyDm/QPM
         l/d/jk4qbWmqu2n0v7sneIZ3NO/77Yu469noRFEzRJ6se6GZ5IAJtG/VeD3WwX5/2CxT
         Hbyg==
X-Gm-Message-State: AOAM533IBW2uvn+xIsId3mUrFtaC1CXFGi7/Dmd/41vC93ivGjZ/Nqw4
        4g19yXkurp+LrFe08ZHlvOY=
X-Google-Smtp-Source: ABdhPJzuObTX2O4HdVDdN2xZN1VLKtwH0j49aJ1LdWs7/hdHxR6rkYhccmayDtowJcSMryggNMIhXQ==
X-Received: by 2002:a17:90b:438e:: with SMTP id in14mr464775pjb.66.1629158044351;
        Mon, 16 Aug 2021 16:54:04 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id j21sm267883pfj.66.2021.08.16.16.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 16:54:03 -0700 (PDT)
Date:   Mon, 16 Aug 2021 16:54:01 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Cc:     linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        arnd@arndb.de, nikolay@nvidia.com, cong.wang@bytedance.com,
        colin.king@canonical.com, gustavoars@kernel.org
Subject: Re: [RFC net-next 1/7] ptp: Add interface for acquiring DPLL state
Message-ID: <20210816235400.GA24680@hoboy.vegasvil.org>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
 <20210816160717.31285-2-arkadiusz.kubalewski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816160717.31285-2-arkadiusz.kubalewski@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 06:07:11PM +0200, Arkadiusz Kubalewski wrote:
> Previously there was no common interface for monitoring
> synchronization state of Digital Phase Locked Loop.
> 
> Add interface through PTP ioctl subsystem for tools,
> as well as sysfs human-friendly part of the interface.
> 
> enum dpll_state moved to uapi definition, it is required to
> have common definition of DPLL states in uapi.

This has nothing to do with PTP, right?

So why isn't it a RTNL feature instead?

Thanks,
Richard
