Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9A9BD0EE1
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 14:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731240AbfJIMdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 08:33:20 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46275 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731225AbfJIMdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 08:33:19 -0400
Received: by mail-wr1-f66.google.com with SMTP id o18so2708981wrv.13;
        Wed, 09 Oct 2019 05:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vtczsSGiPqX2EarRjg69FTPPSDg/+oHy5PBJ6riudmE=;
        b=VRKHcF33MuAVh8nJp6TdXPlcz8puGlOW1dMxMm9921cfiAdGpqfTgRYnpXPxV4yfEQ
         rmDG/XRipy5J2QrF391S1rH40u5q2O3yUuoiRyQbeIQ4toi0jtadtuvVadmy//AhZuuD
         ftjYKXFvrCPbaRonwq3L0hIZjuv4DDJ1IMoSO5TNad/vdqWVz9UoQG0UL7qqbplUM1Tf
         vtV9k+cWmTKpmcGVxLAZEfzQ/BfgivnsgyBq8zKK74r8qf29yrzwKnt7/3lo07jQFDPx
         9VyHcHBG3pidk2RsyDgimMETdHU6kbCDA0uMazDqaiM+MAYYFaZ8qWHpTjTohMAn8I+v
         DeFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vtczsSGiPqX2EarRjg69FTPPSDg/+oHy5PBJ6riudmE=;
        b=MjfoVKuGRcMrO8K0PAnmFmh41IK/MK5mS8ZNBjGep1zXNh2ixQ/cM3zU/eNhK4oKfa
         Q0Y8b56Hi7csQK/DDEc8bM/ZLKiZFL4mbeGBYZO12AA6Jh8BD1SYvHvFZDFw8pIk1sAO
         REqlWoNIfO4wJ1GCn90oPXvJOYH9W4o5IyraZYHuenZ0WM8MNs82VoLNJrgvwfL4oC0p
         TyfBoCHGjPL3dHCMm8/lnpT85fj2d5R2+P6+OPucPzbmqSsuoIZsa5NUxlj6ii1PYwct
         PSUcoPOmIiZl/n/iIzS76j2eADbMzurr1ef+xPoGKZmgyk9xLtGujaXolkslkRGqpsiV
         aMjQ==
X-Gm-Message-State: APjAAAXx2Uhn9CUelqURUFAeDNqr1CM+Zed4CZbo/L97rUqF5RF9O88+
        Pwxf01QkLgCZRoCDMjtGleNZ+OzGtRk=
X-Google-Smtp-Source: APXvYqxV4P4UsHua3rlzN/cRN7SJ3sI08LuJFjwO/Tfeazlm5xN6PUyppxrB5XdoOows7eA+mcwiJw==
X-Received: by 2002:a5d:6b03:: with SMTP id v3mr2850669wrw.182.1570624395704;
        Wed, 09 Oct 2019 05:33:15 -0700 (PDT)
Received: from [192.168.1.35] (46.red-83-42-66.dynamicip.rima-tde.net. [83.42.66.46])
        by smtp.gmail.com with ESMTPSA id t13sm4432525wra.70.2019.10.09.05.33.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 05:33:14 -0700 (PDT)
Subject: Re: [PATCH v8 1/5] nvmem: core: add nvmem_device_find
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
References: <20191009101713.12238-1-tbogendoerfer@suse.de>
 <20191009101713.12238-2-tbogendoerfer@suse.de>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <6d1d6ec0-344d-e94c-6c65-2b1d41cdc2ce@amsat.org>
Date:   Wed, 9 Oct 2019 14:33:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191009101713.12238-2-tbogendoerfer@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/19 12:17 PM, Thomas Bogendoerfer wrote:
> nvmem_device_find provides a way to search for nvmem devices with
> the help of a match function simlair to bus_find_device.
> 
> Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> ---
>   Documentation/driver-api/nvmem.rst |  2 ++
>   drivers/nvmem/core.c               | 61 +++++++++++++++++---------------------
>   include/linux/nvmem-consumer.h     |  9 ++++++
>   3 files changed, 38 insertions(+), 34 deletions(-)
> 
> diff --git a/Documentation/driver-api/nvmem.rst b/Documentation/driver-api/nvmem.rst
> index d9d958d5c824..287e86819640 100644
> --- a/Documentation/driver-api/nvmem.rst
> +++ b/Documentation/driver-api/nvmem.rst
> @@ -129,6 +129,8 @@ To facilitate such consumers NVMEM framework provides below apis::
>     struct nvmem_device *nvmem_device_get(struct device *dev, const char *name);
>     struct nvmem_device *devm_nvmem_device_get(struct device *dev,
>   					   const char *name);
> +  struct nvmem_device *nvmem_device_find(void *data,
> +			int (*match)(struct device *dev, const void *data));
>     void nvmem_device_put(struct nvmem_device *nvmem);
>     int nvmem_device_read(struct nvmem_device *nvmem, unsigned int offset,
>   		      size_t bytes, void *buf);
> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
> index 057d1ff87d5d..9f1ee9c766ec 100644
> --- a/drivers/nvmem/core.c
> +++ b/drivers/nvmem/core.c
> @@ -76,33 +76,6 @@ static struct bus_type nvmem_bus_type = {
>   	.name		= "nvmem",
>   };
>   
> -static struct nvmem_device *of_nvmem_find(struct device_node *nvmem_np)
> -{
> -	struct device *d;
> -
> -	if (!nvmem_np)
> -		return NULL;
> -
> -	d = bus_find_device_by_of_node(&nvmem_bus_type, nvmem_np);
> -
> -	if (!d)
> -		return NULL;
> -
> -	return to_nvmem_device(d);
> -}
> -
> -static struct nvmem_device *nvmem_find(const char *name)
> -{
> -	struct device *d;
> -
> -	d = bus_find_device_by_name(&nvmem_bus_type, NULL, name);
> -
> -	if (!d)
> -		return NULL;
> -
> -	return to_nvmem_device(d);
> -}
> -
>   static void nvmem_cell_drop(struct nvmem_cell *cell)
>   {
>   	blocking_notifier_call_chain(&nvmem_notifier, NVMEM_CELL_REMOVE, cell);
> @@ -532,13 +505,16 @@ int devm_nvmem_unregister(struct device *dev, struct nvmem_device *nvmem)
>   }
>   EXPORT_SYMBOL(devm_nvmem_unregister);
>   
> -static struct nvmem_device *__nvmem_device_get(struct device_node *np,
> -					       const char *nvmem_name)
> +static struct nvmem_device *__nvmem_device_get(void *data,
> +			int (*match)(struct device *dev, const void *data))
>   {
>   	struct nvmem_device *nvmem = NULL;
> +	struct device *dev;
>   
>   	mutex_lock(&nvmem_mutex);
> -	nvmem = np ? of_nvmem_find(np) : nvmem_find(nvmem_name);
> +	dev = bus_find_device(&nvmem_bus_type, NULL, data, match);
> +	if (dev)
> +		nvmem = to_nvmem_device(dev);
>   	mutex_unlock(&nvmem_mutex);
>   	if (!nvmem)
>   		return ERR_PTR(-EPROBE_DEFER);
> @@ -587,7 +563,7 @@ struct nvmem_device *of_nvmem_device_get(struct device_node *np, const char *id)
>   	if (!nvmem_np)
>   		return ERR_PTR(-ENOENT);
>   
> -	return __nvmem_device_get(nvmem_np, NULL);
> +	return __nvmem_device_get(nvmem_np, device_match_of_node);
>   }
>   EXPORT_SYMBOL_GPL(of_nvmem_device_get);
>   #endif
> @@ -613,10 +589,26 @@ struct nvmem_device *nvmem_device_get(struct device *dev, const char *dev_name)
>   
>   	}
>   
> -	return __nvmem_device_get(NULL, dev_name);
> +	return __nvmem_device_get((void *)dev_name, device_match_name);
>   }
>   EXPORT_SYMBOL_GPL(nvmem_device_get);
>   
> +/**
> + * nvmem_device_find() - Find nvmem device with matching function
> + *
> + * @data: Data to pass to match function
> + * @match: Callback function to check device
> + *
> + * Return: ERR_PTR() on error or a valid pointer to a struct nvmem_device
> + * on success.
> + */
> +struct nvmem_device *nvmem_device_find(void *data,
> +			int (*match)(struct device *dev, const void *data))
> +{
> +	return __nvmem_device_get(data, match);
> +}
> +EXPORT_SYMBOL_GPL(nvmem_device_find);
> +
>   static int devm_nvmem_device_match(struct device *dev, void *res, void *data)
>   {
>   	struct nvmem_device **nvmem = res;
> @@ -710,7 +702,8 @@ nvmem_cell_get_from_lookup(struct device *dev, const char *con_id)
>   		if ((strcmp(lookup->dev_id, dev_id) == 0) &&
>   		    (strcmp(lookup->con_id, con_id) == 0)) {
>   			/* This is the right entry. */
> -			nvmem = __nvmem_device_get(NULL, lookup->nvmem_name);
> +			nvmem = __nvmem_device_get((void *)lookup->nvmem_name,
> +						   device_match_name);
>   			if (IS_ERR(nvmem)) {
>   				/* Provider may not be registered yet. */
>   				cell = ERR_CAST(nvmem);
> @@ -780,7 +773,7 @@ struct nvmem_cell *of_nvmem_cell_get(struct device_node *np, const char *id)
>   	if (!nvmem_np)
>   		return ERR_PTR(-EINVAL);
>   
> -	nvmem = __nvmem_device_get(nvmem_np, NULL);
> +	nvmem = __nvmem_device_get(nvmem_np, device_match_of_node);
>   	of_node_put(nvmem_np);
>   	if (IS_ERR(nvmem))
>   		return ERR_CAST(nvmem);
> diff --git a/include/linux/nvmem-consumer.h b/include/linux/nvmem-consumer.h
> index 8f8be5b00060..02dc4aa992b2 100644
> --- a/include/linux/nvmem-consumer.h
> +++ b/include/linux/nvmem-consumer.h
> @@ -89,6 +89,9 @@ void nvmem_del_cell_lookups(struct nvmem_cell_lookup *entries,
>   int nvmem_register_notifier(struct notifier_block *nb);
>   int nvmem_unregister_notifier(struct notifier_block *nb);
>   
> +struct nvmem_device *nvmem_device_find(void *data,
> +			int (*match)(struct device *dev, const void *data));
> +
>   #else
>   
>   static inline struct nvmem_cell *nvmem_cell_get(struct device *dev,
> @@ -204,6 +207,12 @@ static inline int nvmem_unregister_notifier(struct notifier_block *nb)
>   	return -EOPNOTSUPP;
>   }
>   
> +static inline struct nvmem_device *nvmem_device_find(void *data,
> +			int (*match)(struct device *dev, const void *data))
> +{
> +	return NULL;
> +}
> +
>   #endif /* CONFIG_NVMEM */
>   
>   #if IS_ENABLED(CONFIG_NVMEM) && IS_ENABLED(CONFIG_OF)
> 

Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
