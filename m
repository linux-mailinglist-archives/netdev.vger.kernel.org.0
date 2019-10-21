Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8585ADE22F
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 04:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfJUCih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 22:38:37 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44855 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbfJUCih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 22:38:37 -0400
Received: by mail-pg1-f195.google.com with SMTP id e10so6794755pgd.11;
        Sun, 20 Oct 2019 19:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HZLZ6/+Y+2oD+0VED/8sYQUD1paZQLVenJnVsraGrX4=;
        b=UUoyYfgZ+cadgoyYVLVHKq1lpQbBC7f2psDGCLxdBLml7zkfahc3hzK2KXC4S/cJAq
         dvYkuZnXY2/2vGNL2+RJFapCSko4tngOLP7YbwM5HcbuEhNIqvdaQOmjoZVokh8tW+Ik
         Aq5BJdwf4SnPR+z2gLVEjFLLmUNaxj5GP3dcqMICT8EOEgllyCTH4p2ZldlM7Yk4Gsxd
         Vd7t+VUw48AiMllqm5MYK2q3Q/ZjzJxReMi+Bn3D/UawRFYAzkcK3aWCJNckDQbY9+iY
         +J/YOXvvwvJjlBzgB/BGOcf+efut9EwALmoeqUG9CfBIRpJMBqpH5xHZYJwK3in9Kawb
         8wjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HZLZ6/+Y+2oD+0VED/8sYQUD1paZQLVenJnVsraGrX4=;
        b=axLnCABNX8ZHN1USDoNenHtAMD0plgiZST3p4pO1HzhjLCHHUP4INC32jV/Cqgj0IB
         XjPzKXgByYhHR2XNoQ2203OI07gS4HV/vE3Dgmj8byLkLH33Oy6ZMCxjTCBCIWSGPkiI
         eg5k/LnQHDmxGAXiJA17EC5MaPXVa8So2gt/qEmb96AwPEsfUZikOho8YO+Hjs+i0Vo4
         zqfBOEExnoxqKq+XuJsg39rcL2qfLeO1gkbf0s5Dn15HxTht0smUSSws0omP5sdlgmg5
         pa9gRp8VQPHTb4ITFswjd8jdKQyQsv9KAe86kKzi58CsqaFsDx1PvYBLhS/IoQBZUxH3
         qnMA==
X-Gm-Message-State: APjAAAU6nROKTHRmNcr4Y7zdWcVCf4nIEKo4352/6Np2fF/xtb+DkY4W
        8V6DK0+YeLVd+hoIiMGQS971z86g
X-Google-Smtp-Source: APXvYqziUYNKc2K7rE9GGPbbJk38L1X1OwlxZoTYxtgcir5FDc9jLJhyfQdAOusODQACsMMbvcNcnw==
X-Received: by 2002:a63:1c03:: with SMTP id c3mr22244220pgc.198.1571625516429;
        Sun, 20 Oct 2019 19:38:36 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id u3sm12746614pfn.134.2019.10.20.19.38.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2019 19:38:35 -0700 (PDT)
Subject: Re: [PATCH net-next 03/16] net: dsa: use ports list in dsa_to_port
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-4-vivien.didelot@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8c3de1d7-018b-dd2a-d3ef-73633f73d712@gmail.com>
Date:   Sun, 20 Oct 2019 19:38:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191020031941.3805884-4-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/2019 8:19 PM, Vivien Didelot wrote:
> Use the new ports list instead of accessing the dsa_switch array
> of ports in the dsa_to_port helper.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> ---
>  include/net/dsa.h | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 6ff6dfcdc61d..938de9518c61 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -285,7 +285,14 @@ struct dsa_switch {
>  
>  static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
>  {
> -	return &ds->ports[p];
> +	struct dsa_switch_tree *dst = ds->dst;
> +	struct dsa_port *dp;

I would initialize this to NULL and always return dp

> +
> +	list_for_each_entry(dp, &dst->ports, list)
> +		if (dp->ds == ds && dp->index == p)
> +			return dp;

and do a break here, but this is strictly identical to your code, so it
boils down to a matter of preference.

Do you possibly need to use list_for_ech_entry_safe() here, especially
for the code paths that deal with the unregistering of a switch/switch
fabric? That also raises the question of locking as well, which can be
punted on the caller if that is appropriate.

Other than that:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
