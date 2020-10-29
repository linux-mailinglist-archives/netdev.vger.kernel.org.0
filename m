Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E9529EF8C
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 16:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgJ2PRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 11:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbgJ2PRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 11:17:05 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1F9C0613CF;
        Thu, 29 Oct 2020 08:17:05 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id n16so2574434pgv.13;
        Thu, 29 Oct 2020 08:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=820MwFgEaA13M8USX5NcXNh7ShnWbqQ8vCMeLhpqcYs=;
        b=S5RbO63BxB+kSye4StTkySYsW8Zr4FA0vnzixmEkiwTQwE1vI/VjWC2hHXLdQO05Gw
         a2OenMl3LvspcJH/IRGLgGitvwqaukn7G8DrfU3oHDyTezcCEYj6xklXXFYhOo1NNYKI
         QVPMrB3mSSSzLggNqwokNIJnKFLIwJlXJ1J1+NwtbTBbaxgqc3WCf4oBbVZlt9iVDuS+
         wsvt+vLSQKbDFDNJ80WPqsEOFSPCjg/7nS9LmMBSiUnlSpDYC5guEqq8Nqg3DIlF0yRD
         orGh7uZuojFX9L9p7wSa1qHFVzik6JXcOt89LntoOjmwSP7G1c713NE8tzeAa7uLzt6X
         EYzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=820MwFgEaA13M8USX5NcXNh7ShnWbqQ8vCMeLhpqcYs=;
        b=ew/LtF+3Yt8r5aM4n3UxTORozhhLi7Gz4g0zYpGb2E2ROErwHWMF21nYj9qChDhQHs
         S6U6D5FDwWwhSt5tw/Ge/J1WXAlcbZXMNtm8Nhjplz7JVYO471CyjTegiXdnuG5KfpVs
         WvmJUYxdo469T2bVH7DRtZa651dmGXh23OWJUpjsrXA9jZXi7dsEMJRyEXzhIykDsyEh
         lEMPo+KIzvqA2RuITR/xFN0F4JMF3cQtMb5/Am7OlTiFyB01Vcg7L9J2IjVookD8X8hH
         ayeUggBw5hEepFwAHOjhPOs6mJWf1Bd7WN9Dcg88+CBp1fIaU/p4hYrsj94ry3f+EPcE
         pgqQ==
X-Gm-Message-State: AOAM5330P1Pxglso12Z/xpsh2l0sBaJ8fYllQ673oCLSUgCaI+MZsACu
        NBCwo0ZSu0Jyvl8A3UZCJ9Y=
X-Google-Smtp-Source: ABdhPJyY7nixg8TY+WgurAXV+U5HGT8ffPpFyIyVTq773koSVeFgvAYxC4fluR9lXWYW2NDB40cO4g==
X-Received: by 2002:a17:90a:be18:: with SMTP id a24mr231009pjs.215.1603984624439;
        Thu, 29 Oct 2020 08:17:04 -0700 (PDT)
Received: from [192.168.0.104] ([49.207.222.191])
        by smtp.gmail.com with ESMTPSA id b3sm3143476pfd.66.2020.10.29.08.17.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 08:17:03 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Subject: Re: [PATCH v2] net: usb: usbnet: update __usbnet_{read|write}_cmd()
 to use new API
To:     Oliver Neukum <oneukum@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org
References: <20201010065623.10189-1-anant.thazhemadam@gmail.com>
 <20201029132256.11793-1-anant.thazhemadam@gmail.com>
Message-ID: <d8417f98-0896-25d0-e72d-dcf111011129@gmail.com>
Date:   Thu, 29 Oct 2020 20:46:59 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201029132256.11793-1-anant.thazhemadam@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 29/10/20 6:52 pm, Anant Thazhemadam wrote:
> Currently, __usbnet_{read|write}_cmd() use usb_control_msg(),
> and thus consider potential partial reads/writes being done to 
> be perfectly valid.
> Quite a few callers of usbnet_{read|write}_cmd() don't enforce
> checking for partial reads/writes into account either, automatically
> assuming that a complete read/write occurs.
>
> However, the new usb_control_msg_{send|recv}() APIs don't allow partial
> reads and writes.
> Using the new APIs also relaxes the return value checking that must
> be done after usbnet_{read|write}_cmd() is called.
>
> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com> <mailto:anant.thazhemadam@gmail.com>
> ---
> Changes in v2:
> 	* Fix build error
>
> This patch has been compile and build tested with a .config file that
> was generated using make allyesconfig, and the build error has been 
> fixed.
> Unfortunately, I wasn't able to get my hands on a usbnet adapter for testing,
> and would appreciate it if someone could do that.
>
>  drivers/net/usb/usbnet.c | 52 ++++++++--------------------------------
>  1 file changed, 10 insertions(+), 42 deletions(-)
>
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index bf6c58240bd4..2f7c7b7f4047 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -1982,64 +1982,32 @@ EXPORT_SYMBOL(usbnet_link_change);
>  static int __usbnet_read_cmd(struct usbnet *dev, u8 cmd, u8 reqtype,
>  			     u16 value, u16 index, void *data, u16 size)
>  {
> -	void *buf = NULL;
> -	int err = -ENOMEM;
>  
>  	netdev_dbg(dev->net, "usbnet_read_cmd cmd=0x%02x reqtype=%02x"
>  		   " value=0x%04x index=0x%04x size=%d\n",
>  		   cmd, reqtype, value, index, size);
>  
> -	if (size) {
> -		buf = kmalloc(size, GFP_KERNEL);
> -		if (!buf)
> -			goto out;
> -	}
> -
> -	err = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
> -			      cmd, reqtype, value, index, buf, size,
> -			      USB_CTRL_GET_TIMEOUT);
> -	if (err > 0 && err <= size) {
> -        if (data)
> -            memcpy(data, buf, err);
> -        else
> -            netdev_dbg(dev->net,
> -                "Huh? Data requested but thrown away.\n");
> -    }
> -	kfree(buf);
> -out:
> -	return err;
> +	return usb_control_msg_recv(dev->udev, 0,
> +			      cmd, reqtype, value, index, data, size,
> +			      USB_CTRL_GET_TIMEOUT, GFP_KERNEL);
>  }
>  
>  static int __usbnet_write_cmd(struct usbnet *dev, u8 cmd, u8 reqtype,
>  			      u16 value, u16 index, const void *data,
>  			      u16 size)
>  {
> -	void *buf = NULL;
> -	int err = -ENOMEM;
> -
>  	netdev_dbg(dev->net, "usbnet_write_cmd cmd=0x%02x reqtype=%02x"
>  		   " value=0x%04x index=0x%04x size=%d\n",
>  		   cmd, reqtype, value, index, size);
>  
> -	if (data) {
> -		buf = kmemdup(data, size, GFP_KERNEL);
> -		if (!buf)
> -			goto out;
> -	} else {
> -        if (size) {
> -            WARN_ON_ONCE(1);
> -            err = -EINVAL;
> -            goto out;
> -        }
> -    }
> -
> -	err = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
> -			      cmd, reqtype, value, index, buf, size,
> -			      USB_CTRL_SET_TIMEOUT);
> -	kfree(buf);
> +	if (size && !data) {
> +		WARN_ON_ONCE(1);
> +		return -EINVAL;
> +	}
>  
> -out:
> -	return err;
> +	return usb_control_msg_send(dev->udev, 0,
> +			cmd, reqtype, value, index, data, size,
> +			USB_CTRL_SET_TIMEOUT, GFP_KERNEL);
>  }
>  
>  /*

I had a v2 prepared and ready but was told to wait for a week before sending it in,
since usb_control_msg_{send|recv}() that were being used were not present in the
networking tree at the time, and all the trees would be converged by then.
So, just to be on the safer side, I waited for two weeks.
I checked the net tree, and found the APIs there too (defined in usb.h).

However the build seems to fail here,
    https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/O2BERGN7SYYC6LNOOKNUGPS2IJLDWYT7/

I'm not entirely sure at this point why this is happening, and would appreciate it if
someone could take the time to tell me if and how this might be an issue with my
patch.

Thanks,
Anant

