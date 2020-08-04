Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C9E23C231
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 01:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgHDXXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 19:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgHDXXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 19:23:40 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683E9C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 16:23:39 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id c6so3474590pje.1
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 16:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pfevWhfbpWSsBkNuGa8VfXiWURnK0O9u+cZ3Zi5d7C4=;
        b=CbRzREfjPuwlqSntdmb8+1XHxwSQlYiZSJQwRf57N21GLNIOCnBmHpl0HLwtFmaRKS
         5Ak4cpi5PlfWOJrrzj8de3CvVz/LDbfhGHICZ4xF8/JHo5BmsO0MEY6t6eWtDjKIXd3E
         xZZO8OeOZLBiDd7rLKxlVr86VTTxQZzlj80abfBcWtz6an+M6nMnIyoPz2Y68rEx+H7+
         5jWsBzgueuVAPX2WGIfw+4qkKS6IBLoD7mFLCdqYSDn6e8/53g82I6OCKHqtkeAf1zGz
         c3FiWQBqFAG95I6e7lqpI5zvV3CuQPcWpyR1xl/rCB6OuatfHTEPqLkbtfaUjASJycUq
         I3KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pfevWhfbpWSsBkNuGa8VfXiWURnK0O9u+cZ3Zi5d7C4=;
        b=VPsngXCOZeDtS+nEnfkiBRTzcwPJQ2rUksNq0lNFAdFHVk5ho0EVG/WDaFWtay8BQ/
         DaTychl5HvuJhQRVJ/F8MchvDv1brdDLKgT6qEemqQGsFp2Ab7aKe7hLCiFazkO4j5zV
         MTUXtcTIYEVwfgPzXBBbOeoJUraPOdbIJly5qLXJqTBrUdvaUnZ/Xyboit5JTDxAkiSk
         CTAKVXxitC5sW1eTGbx9q4I0mM7Wm6rz7QegF5JByNhJ2yLs0Ww/oeqXjiq1kceqnw1k
         EVJ4VLpLWD2viKN2z3Avqcfl77+MCg2P+wriZTuZbr2jvsmxgGB9727spRnKmK7Cn4z/
         YL3g==
X-Gm-Message-State: AOAM532ZfdnzLzytVL1v5AGqYND8zu6DEIKZcrS8kAhFKk4Vg3cZm68r
        dpYBrHsMlXFwRztDvc46NLcPV8fR
X-Google-Smtp-Source: ABdhPJyBUH6Yunsmzx9yTC4Zezpk3ZCwAB42K23Jae1NsbDBvNGSJbe/rfpOuFF+ujvP2DJeo+RnbQ==
X-Received: by 2002:a17:90a:d314:: with SMTP id p20mr449426pju.21.1596583418866;
        Tue, 04 Aug 2020 16:23:38 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id x7sm186458pfc.209.2020.08.04.16.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 16:23:38 -0700 (PDT)
Date:   Tue, 4 Aug 2020 16:23:35 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next] ptp: only allow phase values lower than 1 period
Message-ID: <20200804232335.GA27679@hoboy>
References: <20200803194921.603151-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803194921.603151-1-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 10:49:21PM +0300, Vladimir Oltean wrote:
> @@ -218,6 +218,19 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  					break;
>  				}
>  			}
> +			if (perout->flags & PTP_PEROUT_PHASE) {
> +				/*
> +				 * The phase should be specified modulo the
> +				 * period, therefore anything larger than 1
> +				 * period is invalid.
> +				 */
> +				if (perout->phase.sec > perout->period.sec ||
> +				    (perout->phase.sec == perout->period.sec &&
> +				     perout->phase.nsec > perout->period.nsec)) {
> +					err = -ERANGE;
> +					break;
> +				}

So if perout->period={1,0} and perout->phase={1,0} then the phase has
wrapped 360 degrees back to zero.

Shouldn't this code catch that case as well?

So why not test for (perout->phase.nsec >= perout->period.nsec) instead?

Thanks,
Richard
