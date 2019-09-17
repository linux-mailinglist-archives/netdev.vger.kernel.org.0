Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90D04B4B68
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 11:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfIQJ7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 05:59:20 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37533 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfIQJ7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 05:59:20 -0400
Received: by mail-lj1-f194.google.com with SMTP id l21so1094292lje.4
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 02:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gXQeuDzZv0W01zkJmKOuEfyUQZW+5cCZ42SQRk6FQac=;
        b=0BZLzROz8+m2zvK2Kd27n+bBCnOLnQFF60agazzOe80f6F6zyldeeDV8c+3LEvzFFe
         JMTmy3ANskSVi7ohfXAdjMAoqnP8/73s6I1rm8WFcR0FnpeqZsTkiya5wozOYJ3MSa2q
         6TBpqt5NF6Rzx8uzs4mIYxtTrgQbEo1SXtyI0rPUSW9cW6zp14wNznjjT51mPyHzSSGH
         87brNOcPH5qK8tnLTUXqDEykmZ1u13n2SPdHN2fQwMU5SA7v8p06u46cV4xg4SsK0Ofp
         HlmJ4T34+yf+N/wocSx5b84rNpnqJOoDH5RiNEu1iabLYLo3fOxWsUAGEBNTCqyTKKp6
         wntQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gXQeuDzZv0W01zkJmKOuEfyUQZW+5cCZ42SQRk6FQac=;
        b=ZPrAJfe5FhOGl0nKg6HljfOoj1gjH/JCexOE8yn7+8C/nQAtl1CjQmwWCtfCBlhlj0
         qVsNGJhEXbMfT/2rRSD/sWP55HpkoB9Byb307eNmdLL+govLbUOHEUmdEgT3fes1ydmH
         i5J8RePu1NCAtI6WN8CoHFZQlKzhq9yK32UNBmntoyYOvAwm65KJ66VVf7si35FNrZzr
         YBJDFhKzeKqZaIdz8wjJVRR9K1JDkhiUak03pDfNrUUSjrkctQmgVNn7UzD2np1fuC4H
         n3Yy8BEGkxufz7B+iKQiOSE5GIjuM5eISbaij7JmMJ5nJzJrQUWwT8GQfjvyNVbKQlev
         XY3Q==
X-Gm-Message-State: APjAAAV7lMwCGlcFKjz1bbhwAQmeWZFb7cuW0I+27tKvkVsBMkv6KfUL
        mAHY9OhvfdOwWgmVxpBX0qNkng==
X-Google-Smtp-Source: APXvYqy7oz2EQV3cbvoPWszregBHfGY5VkPbbYu4JC2WcrPbNJVxdO3DGpRqvXegzozFu0EstQ6wlA==
X-Received: by 2002:a2e:8744:: with SMTP id q4mr1358935ljj.77.1568714358524;
        Tue, 17 Sep 2019 02:59:18 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:6e6:a4e9:5101:fe11:ada5:769e? ([2a00:1fa0:6e6:a4e9:5101:fe11:ada5:769e])
        by smtp.gmail.com with ESMTPSA id z8sm393968lfg.18.2019.09.17.02.59.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 02:59:17 -0700 (PDT)
Subject: Re: [PATCH v2] ixgbe: Use memset_explicit directly in crypto cases
To:     zhong jiang <zhongjiang@huawei.com>, jakub.kicinski@netronome.com,
        davem@davemloft.net
Cc:     anna.schumaker@netapp.com, trond.myklebust@hammerspace.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1568691910-21442-1-git-send-email-zhongjiang@huawei.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <98a942fb-0c47-ffa6-4c9c-f30b5d6f750e@cogentembedded.com>
Date:   Tue, 17 Sep 2019 12:59:13 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1568691910-21442-1-git-send-email-zhongjiang@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 17.09.2019 6:45, zhong jiang wrote:

> It's better to use memset_explicit() to replace memset() in crypto cases.

    But you're using memzero_explicit() below?

> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>   drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> index 31629fc..7e4f32f 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> @@ -960,10 +960,10 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
>   	return 0;
>   
>   err_aead:
> -	memset(xs->aead, 0, sizeof(*xs->aead));
> +	memzero_explicit(xs->aead, sizeof(*xs->aead));
>   	kfree(xs->aead);
>   err_xs:
> -	memset(xs, 0, sizeof(*xs));
> +	memzero_explicit(xs, sizeof(*xs));
>   	kfree(xs);
>   err_out:
>   	msgbuf[1] = err;
> @@ -1049,7 +1049,7 @@ int ixgbe_ipsec_vf_del_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
>   	ixgbe_ipsec_del_sa(xs);
>   
>   	/* remove the xs that was made-up in the add request */
> -	memset(xs, 0, sizeof(*xs));
> +	memzero_explicit(xs, sizeof(*xs));
>   	kfree(xs);
>   
>   	return 0;

MBR, Sergei
