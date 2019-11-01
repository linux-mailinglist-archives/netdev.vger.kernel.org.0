Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AACD7EBC42
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 04:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbfKADL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 23:11:29 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42873 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbfKADL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 23:11:28 -0400
Received: by mail-io1-f66.google.com with SMTP id k1so9396669iom.9
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 20:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=mefi6RY7aL3E+ALKnM/5oy8n8uJyUxFhdCAVjiSfMRE=;
        b=Kx2LTo7WDAiaxpY20vSDhzyvd+BX0ClGOFo/SxzcPdkONyFErtz+mU6FsW9qKKSbNN
         vuKI9KRn9ejbUDK1esIt7S87tnygMVHYiRK6xztKgipe68qLHo2IdiTdDfF9z+WTjVDO
         0tRnLo+kpF6bI6kSNAz4S2QUR55nSHgRiZug5aSc8Iut0mn63rAi/ZrvN4ULBbdh07TQ
         +qym4Qfs5nDSkSSN46tfQadWd7hsVKycWwuH2bo3BwBiQItMTyul4Dp5UqD5TYIzOmEb
         hSRoMwawLEot72Y4x6tQkTMzfQ7CJXeGI9xkWA4GfuRyUlosBJENuNTxOMfiRxzC9fOz
         S3ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mefi6RY7aL3E+ALKnM/5oy8n8uJyUxFhdCAVjiSfMRE=;
        b=aMm1dWrfJm3CGHEmkAGL7ENeZPbS+L7VcGZE5LIeCl+qBvSuNNVFYqDbisoKWtmA/M
         lJpK0BICabxGUmV9eUQW5ALJ5zd2ngfU5OmioKII/ylTlmD38xHgvQ9kUsEaFJOfY5MG
         kdv6yI32KbHNwgOVybav4id7TSJRFPiSAAMHFaIsuAsNXSMcBqSnLFrDYT2xKoTHFMHP
         dXcCEwOrcDa94GpZ4xJfGhdTYyqyS0+NkF+etHYf+IrbSCiDpAahb99sHN7zoZwpWj16
         VQ/7G6ak9YzJf4c2Nzc7CRRRNiM3hW0nFbwXAvabnT7G80GcOokOVXAVT+oB1tsl/T8Y
         Vl9g==
X-Gm-Message-State: APjAAAXF8pVhy7ADV2yS7otgX+0Iuksk5CkYrkU1xhjKfjQyoOk/81/Y
        ikIwn0euNiVCGA8Ek4jvf30tglHu
X-Google-Smtp-Source: APXvYqwsHEBNWifRvzHwdZWoiS6NvCYuNpNIloarP1UJF3bfL0v0N0ZBilH4nj0mCPOuwOnzCrEqzw==
X-Received: by 2002:a05:6638:392:: with SMTP id y18mr3883353jap.98.1572577887599;
        Thu, 31 Oct 2019 20:11:27 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:e0f1:25db:d02a:8fc2])
        by smtp.googlemail.com with ESMTPSA id q3sm814249ill.0.2019.10.31.20.11.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2019 20:11:26 -0700 (PDT)
Subject: Re: [PATCH net-next] net: icmp: use input address in traceroute
To:     Francesco Ruggeri <fruggeri@arista.com>, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, davem@davemloft.net,
        netdev@vger.kernel.org
References: <20191101004414.2B2F995C102D@us180.sjc.aristanetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2706bf00-c156-a71e-01f8-be64de0dd32f@gmail.com>
Date:   Thu, 31 Oct 2019 21:11:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191101004414.2B2F995C102D@us180.sjc.aristanetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/19 6:44 PM, Francesco Ruggeri wrote:
> Even with icmp_errors_use_inbound_ifaddr set, traceroute returns the
> primary address of the interface the packet was received on, even if
> the path goes through a secondary address. In the example:
> 
>                     1.0.3.1/24
>  ---- 1.0.1.3/24    1.0.1.1/24 ---- 1.0.2.1/24    1.0.2.4/24 ----
>  |H1|--------------------------|R1|--------------------------|H2|
>  ----            N1            ----            N2            ----
> 
> where 1.0.3.1/24 is R1's primary address on N1, traceroute from
> H1 to H2 returns:
> 
> traceroute to 1.0.2.4 (1.0.2.4), 30 hops max, 60 byte packets
>  1  1.0.3.1 (1.0.3.1)  0.018 ms  0.006 ms  0.006 ms
>  2  1.0.2.4 (1.0.2.4)  0.021 ms  0.007 ms  0.007 ms
> 
> After applying this patch, it returns:
> 
> traceroute to 1.0.2.4 (1.0.2.4), 30 hops max, 60 byte packets
>  1  1.0.1.1 (1.0.1.1)  0.033 ms  0.007 ms  0.006 ms
>  2  1.0.2.4 (1.0.2.4)  0.011 ms  0.007 ms  0.007 ms
> 
> Original-patch-by: Bill Fenner <fenner@arista.com>
> Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
> 
> ---
>  net/ipv4/icmp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 4298aae74e0e..a72fbdf1fb85 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -682,7 +682,8 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
>  			dev = dev_get_by_index_rcu(net, inet_iif(skb_in));
>  
>  		if (dev)
> -			saddr = inet_select_addr(dev, 0, RT_SCOPE_LINK);
> +			saddr = inet_select_addr(dev, iph->saddr,
> +						 RT_SCOPE_LINK);
>  		else
>  			saddr = 0;
>  		rcu_read_unlock();
> 

Change looks good to me, so for that
Reviewed-by: David Ahern <dsahern@gmail.com>

In this case and your ipv6 patch you have a set of commands to show this
problem and verify the fix. Please submit both in a test script under
tools/testing/selftests/net/. Also, veth pairs is a better way to
connect namespaces than macvlan on a dummy device. See any of the fib*
tests in that directory. Those all serve as good templates for a
traceroute test script.


