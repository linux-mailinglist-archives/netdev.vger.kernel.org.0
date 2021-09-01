Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E013FD559
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 10:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243218AbhIAI21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 04:28:27 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:42472
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243197AbhIAI20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 04:28:26 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 13C2940183
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 08:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630484842;
        bh=aY9gv2ACWx7j3apMcyMOxIKcp1JCAh1Z5IMtKt0nhIM=;
        h=To:References:From:Subject:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=k24WAxYapbiTmVS95ZYcF4i4FfTwhCGSl6QhO4EjgzhQx4qbO/1BKFH+RoliJ0/dy
         NyJkauhA3BBtUPiHle6ZrfXCF40l1/POiHGlU3RduYxMt5JDqY8LGQ2pFiRTLsUZ11
         kLhttF5vOLMQwkzpfb8rR6mo3wpO7BUsWx5Y1I/7mO+TEDInYT20x/EU618UslDiSP
         k8H4mlAb7ZmnW7atunfYOwAChMyoW0dLKH6eufU//PCpqO56/0ov3caWLgn5HxkwPX
         SaVfWhyM7tesMWyHljOkP2LX+mEU4pCB78CBoDdIJDfUMNlRs5a8A0R8u0LPIsVixY
         3ByOJ1e4CzTIQ==
Received: by mail-wm1-f71.google.com with SMTP id r125-20020a1c2b830000b0290197a4be97b7so734500wmr.9
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 01:27:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aY9gv2ACWx7j3apMcyMOxIKcp1JCAh1Z5IMtKt0nhIM=;
        b=KJC3orBRFfENQfQj7MLzBfiu3QrQcs5c0jYUkiC32tFsKlCPLihNllg9B8wm8z+2rg
         E8BB/vd9+2dj/ni5UF5b45S8QUcjCRUKYXWk9vOzKjC8OwDr5dg5G7pfIICfsT65WXKG
         udzFAtVA/Gy1dDbOhQ+FvyIICn31I0fj9ngDDGksS2B3HQLjRz1/PQXOPpODBYS6oOHn
         niVSkaqjGWK59pVM78l68nFec+Wn7xRefRoVkfK62r+t9pieDpbx8IG2trr8yO3SYae3
         zu55BAGibLgSBQrJdLlGTWeQFI7r919Vy7M3R5GsL69qCQzu0DzQmdGw0DZHjOi0ZVi/
         zqbA==
X-Gm-Message-State: AOAM532Efhsbs36cA2vYw998e9jr1akCMB8n+St6mX5kgWxX18MvIPYX
        sEvaPZfxyFPcKDm7KMQBymeroqircLXYRuoOaIZmEDv2Vu3Sadx3TmHF23MkWv90RpnE7Weey0U
        kLOOg2LaJFZlGZBZwaQu0DmnWrofRD1qXCw==
X-Received: by 2002:adf:dcc7:: with SMTP id x7mr35684085wrm.173.1630484841772;
        Wed, 01 Sep 2021 01:27:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWt9eZtbHgzVv7IfVksi6sTwwtO+mAxETcyROAjIvwdGWXWrsH9fTsBf5WMpK8rR6D6C8zwQ==
X-Received: by 2002:adf:dcc7:: with SMTP id x7mr35684070wrm.173.1630484841615;
        Wed, 01 Sep 2021 01:27:21 -0700 (PDT)
Received: from [192.168.3.211] ([79.98.113.249])
        by smtp.gmail.com with ESMTPSA id c13sm20767112wru.73.2021.09.01.01.27.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 01:27:21 -0700 (PDT)
To:     LinMa <linma@zju.edu.cn>, linux-nfc@lists.01.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <5b6649e2.af5bf.17ba04c8d62.Coremail.linma@zju.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: Re: [linux-nfc] set dev->rfkill to NULL in device cleanup routine
Message-ID: <2a052383-6c82-d3a4-fc61-5ecd7b7c49d9@canonical.com>
Date:   Wed, 1 Sep 2021 10:27:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <5b6649e2.af5bf.17ba04c8d62.Coremail.linma@zju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/09/2021 09:39, LinMa wrote:
> In nfc_unregister_device() function, the dev->rfkill is forgotten to set to NULL after the rfkill_destroy(). This may lead to possible cocurrency UAF in other functions like nfc_dev_up().

Commit msg should be wrapper at 75 char.
https://elixir.bootlin.com/linux/v5.13/source/Documentation/process/submitting-patches.rst#L124


Use also scripts/get_maintainers.pl to get list of people and lists
you need to CC. You skipped Networking maintainers and two mailing lists.

> 
> The FREE chain is like
> 

Please trim multiple blank lines and organize the commit msg to be readable.
No need to paste existing code into the commit msg.

> 
> void nfc_unregister_device(struct nfc_dev *dev)
> {
>   int rc;
>   pr_debug("dev_name=%s\n", dev_name(&dev->dev));
>   if (dev->rfkill) {
>     rfkill_unregister(dev->rfkill);
>     rfkill_destroy(dev->rfkill);
>   // ......
> }
> 
> 
> 
> The USE chain is like
> 
> 
> static int nfc_genl_dev_up(struct sk_buff *skb, struct genl_info *info)
> {
>   struct nfc_dev *dev;
>   int rc;
>   u32 idx;
>   if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
>     return -EINVAL;
>   idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
>   dev = nfc_get_device(idx);
>   if (!dev)
>     return -ENODEV;
>   rc = nfc_dev_up(dev);
> 
>   // ......
> }
> 
> 
> int nfc_dev_up(struct nfc_dev *dev)
> {
>   int rc = 0;
>   pr_debug("dev_name=%s\n", dev_name(&dev->dev));
>   device_lock(&dev->dev);
>   if (dev->rfkill && rfkill_blocked(dev->rfkill)) { // dev->rfkill is not NULL here
>     rc = -ERFKILL;
>     goto error;
>   }
>   // ......
> }
> 
> 
> The FREE chain and USE chain can be like below (as there is no locking protection).

Something is missing.

> 
> 
> Therefore, the below patch can be added.

Use imperative form:
https://elixir.bootlin.com/linux/v5.13/source/Documentation/process/submitting-patches.rst#L89

> 
> 
> Signed-off-by: Lin Ma <linma@zju.edu.cn>
> ---
>  net/nfc/core.c | 1 +
>  1 file changed, 1 insertion(+)
> diff --git a/net/nfc/core.c b/net/nfc/core.c
> index 573c80c6ff7a..d0b3224e65d7 100644
> --- a/net/nfc/core.c
> +++ b/net/nfc/core.c
> @@ -1157,6 +1157,7 @@ void nfc_unregister_device(struct nfc_dev *dev)
>   if (dev->rfkill) {
>   rfkill_unregister(dev->rfkill);
>   rfkill_destroy(dev->rfkill);
> + dev->rfkill = NULL;

This is not a valid patch. Does not match the code.
For example, use git format-patch and git send-email.

About the topic:
Your code does not prevent a race condition, since you say there is no
locking. Even if you move dev->rfkill=NULL before rfkill_unregister(),
still nfc_dev_up() could happen between.

The questions are:
1. Whether nfc_unregister_device() can happen after nfc_get_device()?
2. Whether netlink nfc_genl_dev_up() can happen after nfc_unregister_device()
started.



>   }
>   if (dev->ops->check_presence) {
> --
> 2.32.0
> _______________________________________________
> Linux-nfc mailing list -- linux-nfc@lists.01.org
> To unsubscribe send an email to linux-nfc-leave@lists.01.org
> %(web_page_url)slistinfo%(cgiext)s/%(_internal_name)s
> 


Best regards,
Krzysztof
