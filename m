Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1377A1EADCD
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731019AbgFASsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730078AbgFASsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 14:48:42 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B93C03E96B
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 11:48:42 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id r125so4513993lff.13
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 11:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FniT9Ml6wIyy8/Ls6dQtBKpb/rENtgoXFOJ1BzcTW1E=;
        b=x2S57Z6l2Sdn0X46KG7CI1HM5t7F0NH3qrvR1gLUjfv0Rs4OZaQCSPIwGgCj1LnTSY
         edA8Myn4bTnIFOdIQLJnzgiHd1yA8xRUdClA8S40yLsYW5C6ufXEmDqLWeuRwfI4qVrw
         nioMHE4GfnUB0PSNxAzH0MlbvQ9uNXVK4BWQJVNYrub8CCWJdPaZMNE37CcP+qm6RtXm
         wW8PgIma/1st0buB3TYd9ntg38Uxo8fY4j/zvNwnBddZoAFY1ojA1/zkQK4AicrM+AD/
         9kzm4zb0JwFtJHAbsFkUDspsSoAUmi+k8Iuci3iSrwj8UcpqqQd3hZPXNb/xg+I3el41
         m3IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=FniT9Ml6wIyy8/Ls6dQtBKpb/rENtgoXFOJ1BzcTW1E=;
        b=tCfTikXayTfGhdfVMYN1dqQiheCjtsK6KlqO9WI2DKqv4t8RE2QqIexTwMlFiEmYTE
         pHeUnUAjQE7DrqvgF+/VsvtcZx1RcCSnFATJUD9bkK6l6owYErfhe3BHgqFrKnNoMqZ+
         qWaKuekuEMWx1yizBkj/HIrgCVd4FX28R7E9Ek43kQbqbiTZ8egSOjmhmhziloeU73a4
         ckP1zciHqeDZ/aWWwM71iMwXTEmuZOe1n7ykcG8A3JMOEjg/RJWBjihODMC9i7fXwPxZ
         8W7SJXhBKNrzKf/mHJthnu6CkXwl2yVorFgdq8auVmUpBrsmHzHNb5Ooa7HKORsAa8jy
         EZKQ==
X-Gm-Message-State: AOAM530LBgG4OV9UZMOcbdS+kG/OqWHFn1fipn8zGYlUO2yNXnuc0Voa
        UE/rO69GYT4H1fWBTjkZpFEZhB5Ts8g=
X-Google-Smtp-Source: ABdhPJyey34TGWOMWt0wFGaT0TVhygmHROLQ5Sx8cCp7gce/idPrPkWsdQteDdAJed2EdEm9x1Vgdw==
X-Received: by 2002:a19:6c4:: with SMTP id 187mr11842080lfg.1.1591037320300;
        Mon, 01 Jun 2020 11:48:40 -0700 (PDT)
Received: from wasted.cogentembedded.com ([2a00:1fa0:42cb:40f3:c0fd:7859:f21:5d63])
        by smtp.gmail.com with ESMTPSA id f9sm80328ljf.99.2020.06.01.11.48.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jun 2020 11:48:39 -0700 (PDT)
Subject: Re: [PATCH v3] devres: keep both device name and resource name in
 pretty name
To:     Vladimir Oltean <olteanv@gmail.com>, gregkh@linuxfoundation.org,
        arnd@arndb.de, akpm@linux-foundation.org
Cc:     bgolaszewski@baylibre.com, mika.westerberg@linux.intel.com,
        efremov@linux.com, ztuowen@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200601095826.1757621-1-olteanv@gmail.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <7d88d376-dde7-828e-ad0a-12c0cb596ac1@cogentembedded.com>
Date:   Mon, 1 Jun 2020 21:48:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20200601095826.1757621-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/01/2020 12:58 PM, Vladimir Oltean wrote:

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Sometimes debugging a device is easiest using devmem on its register
> map, and that can be seen with /proc/iomem. But some device drivers have
> many memory regions. Take for example a networking switch. Its memory
> map used to look like this in /proc/iomem:
> 
> 1fc000000-1fc3fffff : pcie@1f0000000
>   1fc000000-1fc3fffff : 0000:00:00.5
>     1fc010000-1fc01ffff : sys
>     1fc030000-1fc03ffff : rew
>     1fc060000-1fc0603ff : s2
>     1fc070000-1fc0701ff : devcpu_gcb
>     1fc080000-1fc0800ff : qs
>     1fc090000-1fc0900cb : ptp
>     1fc100000-1fc10ffff : port0
>     1fc110000-1fc11ffff : port1
>     1fc120000-1fc12ffff : port2
>     1fc130000-1fc13ffff : port3
>     1fc140000-1fc14ffff : port4
>     1fc150000-1fc15ffff : port5
>     1fc200000-1fc21ffff : qsys
>     1fc280000-1fc28ffff : ana
> 
> But after the patch in Fixes: was applied, the information is now
> presented in a much more opaque way:
> 
> 1fc000000-1fc3fffff : pcie@1f0000000
>   1fc000000-1fc3fffff : 0000:00:00.5
>     1fc010000-1fc01ffff : 0000:00:00.5
>     1fc030000-1fc03ffff : 0000:00:00.5
>     1fc060000-1fc0603ff : 0000:00:00.5
>     1fc070000-1fc0701ff : 0000:00:00.5
>     1fc080000-1fc0800ff : 0000:00:00.5
>     1fc090000-1fc0900cb : 0000:00:00.5
>     1fc100000-1fc10ffff : 0000:00:00.5
>     1fc110000-1fc11ffff : 0000:00:00.5
>     1fc120000-1fc12ffff : 0000:00:00.5
>     1fc130000-1fc13ffff : 0000:00:00.5
>     1fc140000-1fc14ffff : 0000:00:00.5
>     1fc150000-1fc15ffff : 0000:00:00.5
>     1fc200000-1fc21ffff : 0000:00:00.5
>     1fc280000-1fc28ffff : 0000:00:00.5
> 
> That patch made a fair comment that /proc/iomem might be confusing when
> it shows resources without an associated device, but we can do better
> than just hide the resource name altogether. Namely, we can print the
> device name _and_ the resource name. Like this:
> 
> 1fc000000-1fc3fffff : pcie@1f0000000
>   1fc000000-1fc3fffff : 0000:00:00.5
>     1fc010000-1fc01ffff : 0000:00:00.5 sys
>     1fc030000-1fc03ffff : 0000:00:00.5 rew
>     1fc060000-1fc0603ff : 0000:00:00.5 s2
>     1fc070000-1fc0701ff : 0000:00:00.5 devcpu_gcb
>     1fc080000-1fc0800ff : 0000:00:00.5 qs
>     1fc090000-1fc0900cb : 0000:00:00.5 ptp
>     1fc100000-1fc10ffff : 0000:00:00.5 port0
>     1fc110000-1fc11ffff : 0000:00:00.5 port1
>     1fc120000-1fc12ffff : 0000:00:00.5 port2
>     1fc130000-1fc13ffff : 0000:00:00.5 port3
>     1fc140000-1fc14ffff : 0000:00:00.5 port4
>     1fc150000-1fc15ffff : 0000:00:00.5 port5
>     1fc200000-1fc21ffff : 0000:00:00.5 qsys
>     1fc280000-1fc28ffff : 0000:00:00.5 ana
> 
> Fixes: 8d84b18f5678 ("devres: always use dev_name() in devm_ioremap_resource()")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v2:
> Checking for memory allocation errors and returning -ENOMEM.
> 
> Changes in v3:
> Using devm_kasprintf instead of open-coding it.
> 
>  lib/devres.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/devres.c b/lib/devres.c
> index 6ef51f159c54..ca0d28727cce 100644
> --- a/lib/devres.c
> +++ b/lib/devres.c
> @@ -119,6 +119,7 @@ __devm_ioremap_resource(struct device *dev, const struct resource *res,
>  {
>  	resource_size_t size;
>  	void __iomem *dest_ptr;
> +	char *pretty_name;
>  
>  	BUG_ON(!dev);
>  
> @@ -129,7 +130,15 @@ __devm_ioremap_resource(struct device *dev, const struct resource *res,
>  
>  	size = resource_size(res);
>  
> -	if (!devm_request_mem_region(dev, res->start, size, dev_name(dev))) {
> +	if (res->name)
> +		pretty_name = devm_kasprintf(dev, GFP_KERNEL, "%s %s",

   What about "%s:%s"? I suspect it'd be better on the ABI side of things?

[...]

MBR, Sergei
