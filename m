Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEB6EE759
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 19:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbfKDSZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 13:25:38 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44226 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728322AbfKDSZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 13:25:38 -0500
Received: by mail-qk1-f195.google.com with SMTP id m16so18221814qki.11
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 10:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=xN2bjej83o+NcrGfsofqGbZrcyjGlirBRXIUYnkZvyk=;
        b=dmiUF3tu36dKuA41bV62iUTur25oOazOYwBeKqTWoGLLJm+Ziajf0ZvAUOCxRAR1V8
         hnPSZUuAaZ70xgx8JFviZNQ0t8LsizwZWKZcv7H95vQB4hDAt8v8W5EBQTer7nMJDWhx
         WqBZRBL1cZxivchDOCFwH/gY40/xQeP+WSFoKaO6yu1vasx2IXUvGWeDedeXxSeJ265Q
         wgeKA3U9h8AiX8v/SO19oH1I5dVhjlSMnpbj9Qa18XO5V7QkaBX+4z9xdYeAhGhVPMMs
         LESUmp5i6O2M5twBu1Epk1T5Si1Fn4+FmB7iC+HS5kMmCzoTrH/Sn2MNdfwambw0QNSt
         YVfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=xN2bjej83o+NcrGfsofqGbZrcyjGlirBRXIUYnkZvyk=;
        b=Q0fWIkXIJP1GOJbZ8XQGnuMaVsct7evhLxA6Yc4woZfdbacr/x1z1Kz2Qq/MDf4PCm
         NhdkiUxGDPpur3r4UNA+Da1m2O/OC8nRyyOSzkx/kguELiBQCNROKALApMELL70w8+jk
         DhRGZ3sKVAhaaDfo+1aebfzCdqT+og+IqLwkU4y+dQ0itjJSce+fWdf6f6pZixNk2Cuz
         F+wXkMyM3Ah/V/4324R8ky5hscR1oVmcdXd1BQpfhWLRknN4aZGwlyfADl46xgVo5Ry6
         ZcC+K3ly5yxlSvtTqNHHIcygWYQXib24gBQCA6OicScfwAhwoj9R0vAjgk3mq504ZgaT
         XG0A==
X-Gm-Message-State: APjAAAWlDCqvFG2XhN40c2mmz1BvzoXEowDX/eq04zhwal/cjolVrIJ3
        os9lUh5c0A24BRuF90FhEaU=
X-Google-Smtp-Source: APXvYqxBSiw0snHU2aDGGJmlK/4UB9s79B1wRl37A5YtXdjUJbASpEYeQ+Lq2yoFiV7L/5VggzO3GA==
X-Received: by 2002:a37:a95:: with SMTP id 143mr22809234qkk.382.1572891937164;
        Mon, 04 Nov 2019 10:25:37 -0800 (PST)
Received: from [192.168.1.104] ([74.197.19.145])
        by smtp.gmail.com with ESMTPSA id n56sm10960737qtb.73.2019.11.04.10.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 10:25:36 -0800 (PST)
Subject: Re: Followup: Kernel memory leak on 4.11+ & 5.3.x with IPsec
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org, gregkh@linuxfoundation.org
References: <CAMnf+Pg4BLVKAGsr9iuF1uH-GMOiyb8OW0nKQSEKmjJvXj+t1g@mail.gmail.com>
 <20191101075335.GG14361@gauss3.secunet.de>
From:   JD <jdtxs00@gmail.com>
Message-ID: <f5d26eeb-02b5-20f4-14f5-e56721c97eb8@gmail.com>
Date:   Mon, 4 Nov 2019 12:25:37 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191101075335.GG14361@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/2019 2:53 AM, Steffen Klassert wrote:
> On Wed, Oct 30, 2019 at 02:30:27PM -0500, JD wrote:
>> Here are some clear steps to reproduce:
>> - On your preferred OS, install an IPsec daemon/software
>> (strongswan/openswan/whatever)
>> - Setup a IKEv2 conn in tunnel mode. Use a RFC1918 private range for
>> your client IP pool. e.g: 10.2.0.0/16
>> - Enable IP forwarding (net.ipv4.ip_forward = 1)
>> - MASQUERADE the 10.2.0.0/16 range using iptables, e.g: "-A
>> POSTROUTING -s 10.2.0.0/16 -o eth0 -j MASQUERADE"
>> - Connect some IKEv2 clients (any device, any platform, doesn't
>> matter) and pass traffic through the tunnel.
>> ^^ It speeds up the leak if you have multiple tunnels passing traffic
>> at the same time.
>>
>> - Observe memory is lost over time and never recovered. Doesn't matter
>> if you restart the daemon, bring down the tunnels, or even unload
>> xfrm/ipsec modules. The memory goes into the void. Only way to reclaim
>> is by restarting completely.
>>
>> Please let me know if anything further is needed to diagnose/debug
>> this problem. We're stuck with the 4.9 kernel because all newer
>> kernels leak memory. Any help or advice is appreciated.
> Looks like we forget to free the page that we use for
> skb page fragments when deleting the xfrm_state.
>
> Can you please try the patch below? I don't have access
> to my test environment today, so this patch is untested.
> I'll try to do some tests on Monday.
>
>
> diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
> index c6f3c4a1bd99..f3423562d933 100644
> --- a/net/xfrm/xfrm_state.c
> +++ b/net/xfrm/xfrm_state.c
> @@ -495,6 +495,8 @@ static void ___xfrm_state_destroy(struct xfrm_state *x)
>   		x->type->destructor(x);
>   		xfrm_put_type(x->type);
>   	}
> +	if (x->xfrag.page)
> +		put_page(x->xfrag.page);
>   	xfrm_dev_state_free(x);
>   	security_xfrm_state_free(x);
>   	xfrm_state_free(x);

Hello Steffen,

I left the stress test running over the weekend and everything still 
looks great. Your patch definitely resolves the leak.

Everything kernel 4.11 and above will need this fix afaik. CC'ed Greg 
KH. Will need backporting to 4.14/4.19.

Thanks again for your help and let me know if anything further is needed 
from me.

