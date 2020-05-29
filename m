Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571671E793A
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 11:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgE2JW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 05:22:56 -0400
Received: from mga03.intel.com ([134.134.136.65]:58466 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgE2JWz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 05:22:55 -0400
IronPort-SDR: po+Rh+KuiIzoqfeQ+HGBzCSw2ecwAMz9QbR/6KpOOeO61nHKXIkTK23m+gyL6+PGQ+4jVqlNdr
 2Dsqc8CcfYaw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 02:22:55 -0700
IronPort-SDR: 1Xj1C1O0pgSJ2WSOdmZ/In1Xx/hkP4t33kAUPtFWU3if0MV/azVq9A2agljxXNdy4z1P+kB+uj
 QTeiINh3V61A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,448,1583222400"; 
   d="scan'208";a="256454017"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga007.jf.intel.com with ESMTP; 29 May 2020 02:22:52 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jebE7-009aHF-8z; Fri, 29 May 2020 12:22:55 +0300
Date:   Fri, 29 May 2020 12:22:55 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Yi Wang <wang.yi59@zte.com.cn>
Cc:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        hkallweit1@gmail.com, snelson@pensando.io,
        xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.liang82@zte.com.cn, Liao Pingfang <liao.pingfang@zte.com.cn>
Subject: Re: [PATCH] net: atm: Replace kmalloc with kzalloc in the error
 message
Message-ID: <20200529092255.GW1634618@smile.fi.intel.com>
References: <1590714102-15651-1-git-send-email-wang.yi59@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590714102-15651-1-git-send-email-wang.yi59@zte.com.cn>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 09:01:42AM +0800, Yi Wang wrote:
> From: Liao Pingfang <liao.pingfang@zte.com.cn>
> 
> Use kzalloc instead of kmalloc in the error message according to
> the previous kzalloc() call.

Looking into the context (atomic!) and error message itself I would rather drop
message completely.

> Signed-off-by: Liao Pingfang <liao.pingfang@zte.com.cn>
> ---
>  net/atm/lec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/atm/lec.c b/net/atm/lec.c
> index ca37f5a..33033d7 100644
> --- a/net/atm/lec.c
> +++ b/net/atm/lec.c
> @@ -1537,7 +1537,7 @@ static struct lec_arp_table *make_entry(struct lec_priv *priv,
>  
>  	to_return = kzalloc(sizeof(struct lec_arp_table), GFP_ATOMIC);
>  	if (!to_return) {
> -		pr_info("LEC: Arp entry kmalloc failed\n");
> +		pr_info("LEC: Arp entry kzalloc failed\n");
>  		return NULL;
>  	}
>  	ether_addr_copy(to_return->mac_addr, mac_addr);
> -- 
> 2.9.5
> 

-- 
With Best Regards,
Andy Shevchenko


