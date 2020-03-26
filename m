Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05945194179
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgCZO3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:29:54 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39917 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727798AbgCZO3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:29:54 -0400
Received: by mail-pj1-f66.google.com with SMTP id z3so1962692pjr.4;
        Thu, 26 Mar 2020 07:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+cg7/vNMMOsNUi/4m6oa2Zr/yCuH8pUcG9soKF+ye0M=;
        b=FoT/5OsjuwqF3LGtq0NGlSwiQiABbGVpz1Ubm9nz4qpYemVxoyU4+5p0au6CvFEv0T
         dP8lM+AQo/UDkSm6tro+/zfh4REKRahYDjFf0o0EKCHV+gPUOXHlwvuLf4UKdzFz7wCF
         a/R3GcnhjpygHHNkBHi/COsruloz5Hh9Y78/7hOwHdhmlyMiCEdwJd1/cSyZsE6j4ZLy
         Q91EJE0byzw2JZF4bwrL7xsKJfofrA00BLPpwk8pjFRh2kWOnxBpX1kIT8rC3R+9R0qQ
         e9nzP20yGNCWeBlHfYaR32OXK7hXGIHqVjyfSb/wOjUCrvRuMC66R/UQTTIw4oFWS/Fd
         pmUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+cg7/vNMMOsNUi/4m6oa2Zr/yCuH8pUcG9soKF+ye0M=;
        b=HyPdxfBAT+hBDzVG8dr3YUT6lcprTerFJLBv+P+aqB+q3tN6PkN5q5zCgDKjXu+AaE
         HR3z3POeLOyjGEov+gcRR0jec4NeghdSjJYDdtIj1qpa3UjGZRYzLLJXRzDtAvj3lwcc
         tkhZRX8mS2nyXCMDTFc/CS4N9MOa6ACU+j1YzNS7S8jEtKuG3/KT2EeKZoslMpgL7aoA
         2hnjKXtTBfchx8NShf3QjRmjXZeng4vGaqC/VCkJc6K3yLc+5sMbdaRAqHO9QVM2l89x
         qse17px1mjnjAX/fVOENpk5AEXl9jnGGEJX5YiJJuRbFp4pv+/hNFrT2bWagqyqE3B1z
         2yhQ==
X-Gm-Message-State: ANhLgQ1u8yQKuy8zu0kU/y+wQa+pU00eAQ/75j15YCMoeGNxkFVrR6k+
        pmxzyw7RCQrdFsx/lnUmESgOvo8x
X-Google-Smtp-Source: ADFU+vvRPcavRwefyV3uIlhwFkQ82uJPgQ9Vv20Y60NzXTHS14gVTEZYA21QnYrQoHK2iqHkp0XMHw==
X-Received: by 2002:a17:90a:fb47:: with SMTP id iq7mr256650pjb.191.1585232992872;
        Thu, 26 Mar 2020 07:29:52 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id e187sm1827120pfe.50.2020.03.26.07.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 07:29:52 -0700 (PDT)
Date:   Thu, 26 Mar 2020 07:29:50 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 06/11] net: ethernet: ti: cpts: move tx
 timestamp processing to ptp worker only
Message-ID: <20200326142950.GE20841@localhost>
References: <20200320194244.4703-1-grygorii.strashko@ti.com>
 <20200320194244.4703-7-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320194244.4703-7-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 09:42:39PM +0200, Grygorii Strashko wrote:
> Now the tx timestamp processing happens from different contexts - softirq
> and thread/PTP worker. Enabling IRQ will add one more hard_irq context.
> This makes over all defered TX timestamp processing and locking
> overcomplicated. Move tx timestamp processing to PTP worker always instead.
> 
> napi_rx->cpts_tx_timestamp
>  if ptp_packet then
>     push to txq
>     ptp_schedule_worker()
> 
> do_aux_work->cpts_overflow_check
>  cpts_process_events()

Since cpts_overflow_check() is performing new functions, consider
renaming it to match.

Thanks,
Richard

