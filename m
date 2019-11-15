Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA966FE37E
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 17:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfKOQ7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 11:59:51 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:39923 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfKOQ7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 11:59:51 -0500
Received: by mail-io1-f68.google.com with SMTP id k1so11172450ioj.6;
        Fri, 15 Nov 2019 08:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JdX/13FI573A99ZfQ+b/X2YPtRW6JH4G+iSGl0lCkmw=;
        b=gJNGXYfILtD8BKM9DBlgL123F5+fDoVyi4wdgy72g4sQqk8ekWkm0ZHz53piiVdQU/
         nJ2710aaf6zMZczFGEyd/0A6b0AOqoDzwrA51ewihBh4I1f5O0cWiL2Gj6vOEdzqI9iw
         IXZJCg+F53QrkNfe5VWmG6omKn+U0a0Q0jEE9lVshElhTegI6vym8VWCtfm8cww9TYbG
         io5LPOzlWV6MPyGNrvOi9Z6oehWV+vgW85IjtB7ibkb3In0kqNhheGgt5rkiXyKi//Fz
         kQ6I8Av12VT8xxtyYwR2gHuo/Ut5smUK4DwENGTYaWIXVrWx6+vxsN1ILf8ismv2lVKf
         sYKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JdX/13FI573A99ZfQ+b/X2YPtRW6JH4G+iSGl0lCkmw=;
        b=M7KA+cCKtso6DnB+xddMgU6tZ5+HZZRsVYon9TfW1Ny4iTiMbWlvLkvoc5Y+5u0iZb
         GduxqU1QDldLtA0Edaiw+rU2udRKvL/ALfGZJbmQxOAM7WghYCntIkZEAzdGwpUrYIEf
         UG+d1+2QEXNA97z+afR4oZFlguz04DrrJIIPVUFlCe6qCoXVRHhAIcmJ7fBHZDN28Vx1
         c8VeZJrT1t4owNljUSKqpnV6xX+8EJ2IcFKjLe+Iaih1L5FYgeY0RbmFYyINUWkeeXuT
         oajXkEnbpKyFdMgq324p0wO2/+nmj7exNS8nGMknLq+EbVUcfK+hT0/U6qZ4m/GTO7cK
         p01w==
X-Gm-Message-State: APjAAAVrVZElakjxPMgkHZmHZenM5dIGcTESN4IRknbG9nTlg5xJ4+rT
        PWtfxdsBAjsCDwN5wGEDymo=
X-Google-Smtp-Source: APXvYqwHU3e4nMOXVPh1aJVXVZ9Uny2wti9DxI7DEl0LbMc4xLYNUbh8o4Q5HqqdeYXyyKE+tO4Uzg==
X-Received: by 2002:a5d:85c7:: with SMTP id e7mr1541591ios.59.1573837190358;
        Fri, 15 Nov 2019 08:59:50 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:c9ae:cf0c:82df:2536])
        by smtp.googlemail.com with ESMTPSA id i20sm1725555ile.79.2019.11.15.08.59.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 08:59:49 -0800 (PST)
Subject: Re: [PATCH] vrf: Fix possible NULL pointer oops when delete nic
To:     "wangxiaogang (F)" <wangxiaogang3@huawei.com>, dsahern@kernel.org,
        shrijeet@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hujunwei4@huawei.com, xuhanbing@huawei.com
References: <60e827cb-2bba-2b7e-55dc-651103e9905f@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7fe948a8-debd-e336-9584-e66153e90701@gmail.com>
Date:   Fri, 15 Nov 2019 09:59:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <60e827cb-2bba-2b7e-55dc-651103e9905f@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/19 11:22 PM, wangxiaogang (F) wrote:
> diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
> index b8228f5..86c4b8c 100644
> --- a/drivers/net/vrf.c
> +++ b/drivers/net/vrf.c
> @@ -1427,6 +1427,9 @@ static int vrf_device_event(struct notifier_block *unused,
>  			goto out;
> 
>  		vrf_dev = netdev_master_upper_dev_get(dev);
> +		if (!vrf_dev)
> +			goto out;
> +
>  		vrf_del_slave(vrf_dev, dev);
>  	}
>  out:

BTW, I believe this is the wrong fix. A device can not be a VRF slave
AND not have an upper device. Something is fundamentally wrong.
