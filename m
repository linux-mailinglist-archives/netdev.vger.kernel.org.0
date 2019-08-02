Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 732D97E716
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 02:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730969AbfHBALK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 20:11:10 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34151 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730943AbfHBALJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 20:11:09 -0400
Received: by mail-pg1-f194.google.com with SMTP id n9so28858826pgc.1
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 17:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=XjsD1/icALZg3awep5hLe4sw3wS4Y5d5jH+ihun/pAQ=;
        b=nBBY7aoAwKlPvM8gf3peMdE8TFgvwNrsv8fMJ9J4MeQCm3xHqXV/5pL5j9DHzddOFU
         kIG5AAr7ze/NtnyFzW+h89gg7DtaVzOeoeYqjxtEi4UCh3pTUJ70yoIFu8XJxCkP/8SJ
         h+pd8Isx3WFXWEvtHM7hyHxxxJy47YJssSouEXFzQC3g25ovQ8sAvmlkWKQzrhdH/WdR
         GS5vrN0C8u3+up3UEHmZ2uPqhvrUXG2OkQv52lv2MK4HN49i4LnTpLJZ0m//Iejad05w
         nJJwvaQ20pdACijy1y4vY1yj3Ttvmb+NmKLz2hgZXlFkSpmiSu5tkYzMF04dA4GRQUIa
         o5TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=XjsD1/icALZg3awep5hLe4sw3wS4Y5d5jH+ihun/pAQ=;
        b=sco35ENCQ8NWZbkVmTUWBLofKkxGawKmTG8xuN4JX1j+eu7Flx+t6NwjzDL7SAhPi+
         j9PAaKEyw45X5c6mEN4P9Z26d6wonD8hhNLy8wb1+bXhps8bZeYCBJxbXDkGkx7amFZa
         EvEbH3bLXH487LyXK7FBzo2qiyoNze1Iy/gixBxlASVl/LDNKRRJFtOerFF3oxDNr9tq
         wyLPZzE4m/oB/ngipqY7yyE9d3lRFui2yHbevBFY9yFBynDvYxoQ0oZHchJgtNdbNF0v
         wYWUqfTUyenQ+BrviXTA/gO3ZR4TdwLVeWUGFfek3vi9r7jSX6QzJ2/zzwgaFIwuDI7Y
         g/Xg==
X-Gm-Message-State: APjAAAUkJgof28Tg+KTfWVtb2TuH+CxFV6Jryf6N6KHHwcdeTUE96E/R
        hoo2cnkYU8uQtNY4ez65uhO1OQ==
X-Google-Smtp-Source: APXvYqyLOlywT7pP4+g9JJr0yvPmUI8NeLroMiyiXeQIQK1qTu169Sp1K8rfs6XklvHmzBc0erOQqQ==
X-Received: by 2002:a65:4189:: with SMTP id a9mr27221456pgq.399.1564704668993;
        Thu, 01 Aug 2019 17:11:08 -0700 (PDT)
Received: from Shannons-MBP.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id z6sm43027684pgk.18.2019.08.01.17.11.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 17:11:08 -0700 (PDT)
Subject: Re: [net-next 2/9] i40e: make visible changed vf mac on host
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
References: <20190801205149.4114-1-jeffrey.t.kirsher@intel.com>
 <20190801205149.4114-3-jeffrey.t.kirsher@intel.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <9a3a4675-b031-7666-f259-978d18b6db19@pensando.io>
Date:   Thu, 1 Aug 2019 17:11:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190801205149.4114-3-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/19 1:51 PM, Jeff Kirsher wrote:
> From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
>
> This patch makes changed VM mac address visible on host via
> ip link show command. This problem is fixed by copying last
> unicast mac filter to vf->default_lan_addr.addr. Without
> this patch if VF MAC was not set from host side and
> if you run ip link show $pf, on host side you'd always
> see a zero MAC, not the real VF MAC that VF assigned to
> itself.
>
> Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>   drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> index 02b09a8ad54c..21f7ac514d1f 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> @@ -2629,6 +2629,9 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
>   			} else {
>   				vf->num_mac++;
>   			}
> +			if (is_valid_ether_addr(al->list[i].addr))
> +				ether_addr_copy(vf->default_lan_addr.addr,
> +						al->list[i].addr);
>   		}
>   	}
>   	spin_unlock_bh(&vsi->mac_filter_hash_lock);

Since this copy is done inside the for-loop, it looks like you are 
copying every address in the list, not just the last one.  This seems 
wasteful and unnecessary.

Since it is possible, altho' unlikely, that the filter sync that happens 
a little later could fail, might it be better to do the copy after you 
know that the sync has succeeded?

Why is the last mac chosen for display rather than the first?  Is there 
anything special about the last mac as opposed to the first mac?

sln

