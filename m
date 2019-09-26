Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBD31BEB10
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 06:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfIZEC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 00:02:27 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35821 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfIZEC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 00:02:27 -0400
Received: by mail-wr1-f66.google.com with SMTP id v8so975324wrt.2
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 21:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NFq+QfC8eEEmM+AmXLpYp9OtSoVz1JPbH4dBDpzsshY=;
        b=oBHPcO6KVTJ8djKftpHbDleRtssOwcZxAeUm/qsNzM8bgljJWVuw/lsghsnlB0cxt0
         DHe4NTV2FHNg1fDUqWXzkdLP3inmhyg5cuRXDwXv9u4nZGepL/f0bzdV/iuWfCLHnok+
         v3B7ctLbis+fFH8t90cMgTKVC2FomSgQdQEpf+rjyAJum5kkoK9SZfGvOnq0XMIVsYY0
         Qn/DQc+7i10RKXeXlXqKBuLaoVh6qy/FvH7wKxDecQQ8BpimixDNoVnINFQJ1WJBxvEe
         Hd6+YWD7fzxJXAoJ4Ds9pfTBnOwjaAXGtctpV1krT9/XZXfU0T6mu+uw7c5tZH+U8Um6
         SwfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NFq+QfC8eEEmM+AmXLpYp9OtSoVz1JPbH4dBDpzsshY=;
        b=QsxprozZyj8SDXmKd7q9B9dI29NWUoqLvOVzpjOcjWYJ6qQs/8NF7ps9b9HYBuLmeG
         hsjFdXaRkQiZunMRvmOhFNgKsNaxje++t3wAAUd6v5o5Z35dNDhWp+81gxkUA3aI/RQr
         wlISJZv4JEXpGNPJLxwkmvuX8eyFu24IT+L8pszwhCP4sB2sHT1B1QDLZNYM6fYHgjA5
         KI5U1s6awvzVASCfBdooyEVkQ15ShV6dYe+j8LaftLSbZ4BprYlUB5stSUfDcDYDdZ/f
         3Uw5bVvcXb3+8Vpd688w+hZfcIR+Lbwl+z1FPTbLbJfCu5dBwquBVM39drgkJDOfUdNf
         9q6Q==
X-Gm-Message-State: APjAAAWJGgHXR/UBgzg+GlbGnW4A0NmAx8VPlLyW9Z1ld17szmWvx/a+
        vwTFWtogPAY3FN4bbFEBE4c=
X-Google-Smtp-Source: APXvYqyIshdEjFfwK60IQk7dC44Gc5SilN4EUYjeSzXmqg81WF/Cqtfxx36a69j1PNUJSJjtIg1vmw==
X-Received: by 2002:adf:f1c3:: with SMTP id z3mr1067711wro.147.1569470545287;
        Wed, 25 Sep 2019 21:02:25 -0700 (PDT)
Received: from localhost (195-70-108-137.stat.salzburg-online.at. [195.70.108.137])
        by smtp.gmail.com with ESMTPSA id r28sm1530529wrr.94.2019.09.25.21.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 21:02:24 -0700 (PDT)
Date:   Wed, 25 Sep 2019 21:02:23 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org,
        Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Christopher Hall <christopher.s.hall@intel.com>
Subject: Re: [net-next v2 2/2] net: reject ptp requests with unsupported flags
Message-ID: <20190926040222.GB21883@localhost>
References: <20190926022820.7900-1-jacob.e.keller@intel.com>
 <20190926022820.7900-3-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926022820.7900-3-jacob.e.keller@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 25, 2019 at 07:28:20PM -0700, Jacob Keller wrote:
> This patch may not be correct for individual drivers, especially
> regarding the rising vs falling edge flags. I interpreted the default
> behavior to be to timestamp the rising edge of a pin transition.

So I think this patch goes too far.  It breaks the implied ABI.
 
> diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
> index fd3071f55bd3..2867a2581a36 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ptp.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
> @@ -521,6 +521,10 @@ static int igb_ptp_feature_enable_i210(struct ptp_clock_info *ptp,
>  
>  	switch (rq->type) {
>  	case PTP_CLK_REQ_EXTTS:
> +		/* Reject requests with unsupported flags */
> +		if (rq->extts.flags & ~(PTP_ENABLE_FEATURE | PTP_RISING_EDGE))
> +			return -EOPNOTSUPP;

This HW always time stamps both edges, and that is not configurable.
Here you reject PTP_FALLING_EDGE, and that is clearly wrong.  If the
driver had been really picky (my fault I guess), it should have always
insisted on (PTP_RISING_EDGE | PTP_FALLING_EDGE) being set together.
But it is too late to enforce that now, because it could break user
space programs.

I do agree with the sentiment of checking the flags at the driver
level, but this needs to be done case by case, with the drivers'
author's input.

(The req.perout.flags can be done unconditionally in all drivers,
since there were never any valid flags, but req.extts.flags needs
careful attention.)

Thanks,
Richard
