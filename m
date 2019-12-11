Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E3A11B32C
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388613AbfLKPlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:41:12 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:40760 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387716AbfLKPiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 10:38:19 -0500
Received: by mail-io1-f66.google.com with SMTP id x1so23094319iop.7
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 07:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G8NpVJHV6XTeInBWMRdwvp9yp0ay3o9iHO0+lBUDJ/k=;
        b=HGTsLQm4pbK0efQSfWDR/Ipv150Dfu4DvyKt9PYcCWambCrVXtT+xRx9LT2VBy+wCw
         wi5vixOPh4rqvWZ8RtFMAu2vw3bW5BnNG3AFsIT4d74u1A3yqpKfsTQO7MAAnw0W9z4A
         okDV6abRz9G5U0glsOth4Fr3qAiLDUkaUSF37KzOIScH4sl02ItMEJKYfqiexdgYv6YK
         ZyxvJoOzvK8C3SW1tsbdsS/DcrBqU6SmqtAqEpl8ytJ0i1fPGSqmn94z0IDzx5sd5kpc
         pZzwYrtWXwFLmU095Y7qIyPXcqgRKYY6nU+u9gjz01F4PbOGQTdrU4ZwjLJT6CHKpKug
         X6rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G8NpVJHV6XTeInBWMRdwvp9yp0ay3o9iHO0+lBUDJ/k=;
        b=txRQfbx2bINJ6zgdQbjpeoWlE+EDtYdtJa42abVJPXgQVhpGun7vkYvC84DTiFDM/5
         r6Trx6gEG5W8RAyMVY9I+s482RnO5CgluzB0jO9H1AFvHsxb3MmXtvkXbPL+P+KlSpMk
         zyoXXIBb5nZEOk3C8XNg7/aq1uTeWy4T5Z6YVqAGrlnn5kOoY1rFtwdNAehH/HWRFIgR
         L/Ak+5GDxTR8hOsP6okoHTLBT5iVQYQCEVl0N9KB6BFB20FrPeCc5YF1/J/JN/b8eFW4
         NwtnLaCRdCwZ2FclC3IKjXAm8irmuLR/YfO7J/FDalTy37HZcJ2+F+hHgJxhpi9ba3dv
         TcuQ==
X-Gm-Message-State: APjAAAUdmUlMx0cVfDb/Y4OCem0OKKbjq8WecOZPsP1UeYGXHCErEbUb
        zYNWJmqNO+wnoodjW1xynaM=
X-Google-Smtp-Source: APXvYqxZ1eMMXge60vDNP2pGKZYBlX+qOpqB/AIMUzBA3EM+uU4HIu3xaEowe8XsLy1otl93qgc+/Q==
X-Received: by 2002:a02:742:: with SMTP id f63mr3705350jaf.138.1576078699070;
        Wed, 11 Dec 2019 07:38:19 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:79bb:41c5:ccad:6884? ([2601:282:800:fd80:79bb:41c5:ccad:6884])
        by smtp.googlemail.com with ESMTPSA id 71sm807604ilv.19.2019.12.11.07.38.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 07:38:18 -0800 (PST)
Subject: Re: [PATCH net-next v2] net: bridge: add STP xstats
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20191210212050.1470909-1-vivien.didelot@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0e45fd22-c31b-a9c2-bf87-22c16a60aeb4@gmail.com>
Date:   Wed, 11 Dec 2019 08:38:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191210212050.1470909-1-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/19 2:20 PM, Vivien Didelot wrote:
> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
> index 1b3c2b643a02..e7f2bb782006 100644
> --- a/include/uapi/linux/if_bridge.h
> +++ b/include/uapi/linux/if_bridge.h
> @@ -156,6 +156,15 @@ struct bridge_vlan_xstats {
>  	__u32 pad2;
>  };
>  
> +struct bridge_stp_xstats {
> +	__u64 transition_blk;
> +	__u64 transition_fwd;
> +	__u64 rx_bpdu;
> +	__u64 tx_bpdu;
> +	__u64 rx_tcn;
> +	__u64 tx_tcn;
> +};
> +
>  /* Bridge multicast database attributes
>   * [MDBA_MDB] = {
>   *     [MDBA_MDB_ENTRY] = {
> @@ -261,6 +270,7 @@ enum {
>  	BRIDGE_XSTATS_UNSPEC,
>  	BRIDGE_XSTATS_VLAN,
>  	BRIDGE_XSTATS_MCAST,
> +	BRIDGE_XSTATS_STP,
>  	BRIDGE_XSTATS_PAD,
>  	__BRIDGE_XSTATS_MAX
>  };

Shouldn't the new entry be appended to the end - after BRIDGE_XSTATS_PAD

