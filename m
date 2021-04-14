Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA9235F686
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351906AbhDNOrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349887AbhDNOrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 10:47:12 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C695EC061574;
        Wed, 14 Apr 2021 07:46:50 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d8so10224513plh.11;
        Wed, 14 Apr 2021 07:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=y3YNr7aga5ARelEpZRoG5kXAVCwy+EfMKJ2wZNKrO3k=;
        b=ML7MiXkg3x7j3dPBKlrJ7xBHHkyhcHhmiaxYaU3LP1/NqUTiDaZBe2nNTkMu2xYXB8
         07DEYWLN89VBdlJlZ1U45qTNI8zGXm4GNPHLrX/9Zdn+HGB0cVS87jjL16NHQgEiyUWi
         LSUBLSFSTWnPL+wk0DjZvz4ue/VV9SBje41l44Vh1Z61PHjkTfbxD7iOEgA1JPxq1bfV
         gvGP+C+LGUcSAwdsWcLOp8TtOyo0YeIBCuhTTjIBzeQxe0i+B15u0Agc6EyxWTt3Wp4g
         penu+1PFSffsZGCSD9igYEXSSrpMH1Lje0MYdqEVhX7h5vY6StZr83+DjrLm2ZKCB27H
         RMzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=y3YNr7aga5ARelEpZRoG5kXAVCwy+EfMKJ2wZNKrO3k=;
        b=qNmuFkFarvatsTV99q7+RGh5er2GXBqWkm1n6wxJuXFxW+nfA+f++KiIDuCLZePz8V
         PaabXOl/g9recIJnUwZWUjUNfjHZIp8IPWxsgcpS4m9CMWBwMswLWa4WegXbpkFG4LwW
         lVfKkAF6LZfUlL7Kj0dGL1bUgOZfxfpN7Dn/4iJE24knh82vbsw6pvq2Oi+KRuXU7I1r
         19yjV5y3Jmqd3eTKyXUrdCbMxdcQjou1DC1TEYkLsWwlAe/fGez6iroESdCoooGSWuvk
         b+qYpBS0Ju2SpSE8Vy+GRcrNgxUcsqNNKGsP0g3NuluYNYRwrEqQ7GgENLTdkJu+ZdXG
         pC4Q==
X-Gm-Message-State: AOAM533aXFWRw8lVOgZRwaiETlWib1z7RousxD3fh3gllbutDc4/bgvE
        1h4heGf6NcKdGB68wFrUEUo=
X-Google-Smtp-Source: ABdhPJxKK5K0A+ptCC6cs4HU1E95eLmtfVt+UNTJ9KhISNjDs3CWHt/5dPOuBfs//BQ59rrQGaAc7g==
X-Received: by 2002:a17:90a:ff07:: with SMTP id ce7mr3956535pjb.0.1618411610372;
        Wed, 14 Apr 2021 07:46:50 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id s17sm4879049pjn.44.2021.04.14.07.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 07:46:49 -0700 (PDT)
Date:   Wed, 14 Apr 2021 07:46:47 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/1] net: stmmac: Add support for external
 trigger timestamping
Message-ID: <20210414144647.GA9318@hoboy.vegasvil.org>
References: <20210414001617.3490-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414001617.3490-1-vee.khee.wong@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 08:16:17AM +0800, Wong Vee Khee wrote:
> From: Tan Tee Min <tee.min.tan@intel.com>
> 
> The Synopsis MAC controller supports auxiliary snapshot feature that
> allows user to store a snapshot of the system time based on an external
> event.
> 
> This patch add supports to the above mentioned feature. Users will be
> able to triggered capturing the time snapshot from user-space using
> application such as testptp or any other applications that uses the
> PTP_EXTTS_REQUEST ioctl request.
> 
> Cc: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Tan Tee Min <tee.min.tan@intel.com>
> Co-developed-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
