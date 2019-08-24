Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D50D9B990
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 02:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfHXA1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 20:27:01 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36036 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfHXA1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 20:27:01 -0400
Received: by mail-qt1-f195.google.com with SMTP id z4so12958408qtc.3
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 17:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=5XKCwUxxTjFFPmzE6bcngiAwm3ZhPKgG5LUrorq0has=;
        b=YjwjL9SnH4eReTvij2IJ8miS2ZMnnwL4gJqagxPbrRHMlIMMtOsycKNFbJdRQPU4hX
         mVd22U1W4Kl1stabnfCkEQrxIYgJs+L++GhBsqxM5KJgTKHWPLJ/9WrpLyah2Wt16lBv
         hqREVmI6tqKhvrpZZd7xJ58uFAG6ZH0chw3LgL1mpIAFt8hhvizGbhl7TG8ss0bxVmP3
         K9udb9UyVw/GWs7HRIvJ1GOG9VFT63co3WU26ouNAAE6pvIV9s0xQH1UgmGqVP7JHnc5
         SNOsQMDJlyagrCTqEfu5CtGYGqOzLASAX2IhF2PI0t4qIdWLGpXZq6h/vNEo6Tqk1XNM
         m/0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=5XKCwUxxTjFFPmzE6bcngiAwm3ZhPKgG5LUrorq0has=;
        b=FZglF0PEh43M8OXDupGLX22w+xZk4lcKhtlUeX0yKyNFt3v+9G7fMc4EmQ4Aknsmci
         6eLQOJ+Rik5eb7t4F1fmuEP+KzTrndQKCDf/5GLSG8HGguwwR/um69+hGTThrz2xdmyN
         BhcvDWP/PTkrehD07SMD7WRElSuL9/9Xg7c/Eu3k00XyNE4RwSQjh0C7d0E+Uw8y2xIw
         XbqmHb+oDp9bn29Czu18RQM/2GZLxFtytsIe8pZsasI0kAyTJyIrcocci2JVZuBhwvMk
         gX51X1xdGTxuEeXux8TneuqwE4i6Z0Ha5r9nU58TWIaIBpz9JOhCPxfpIwtZa1+yfwHE
         3vrQ==
X-Gm-Message-State: APjAAAWDowiVsH/goXa+RQ5S0P/A+xZx2VxqHNmpMko3eMxVoaLYonJ7
        w1ecl/u0fkyUWsdpRIoaV2NGAw==
X-Google-Smtp-Source: APXvYqxc3mNp4i/ZCyzX7CuVfmpUMuLo5pd224/Uxe0kJ9jvP/M27xIqPETCz9QqyqKe8E5w7Y0lQw==
X-Received: by 2002:a0c:8791:: with SMTP id 17mr6313281qvj.215.1566606420058;
        Fri, 23 Aug 2019 17:27:00 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id k49sm2471853qtc.9.2019.08.23.17.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2019 17:26:59 -0700 (PDT)
Date:   Fri, 23 Aug 2019 17:26:48 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, pablo@netfilter.org
Subject: Re: [PATCH net-next v2 03/10] net: sched: refactor block offloads
 counter usage
Message-ID: <20190823172648.7777e2b6@cakuba.netronome.com>
In-Reply-To: <20190823185056.12536-4-vladbu@mellanox.com>
References: <20190823185056.12536-1-vladbu@mellanox.com>
        <20190823185056.12536-4-vladbu@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Aug 2019 21:50:49 +0300, Vlad Buslov wrote:
> @@ -1201,14 +1199,11 @@ static int u32_reoffload_knode(struct tcf_proto *tp, struct tc_u_knode *n,
>  			cls_u32.knode.link_handle = ht->handle;
>  	}
>  
> -	err = cb(TC_SETUP_CLSU32, &cls_u32, cb_priv);
> -	if (err) {
> -		if (add && tc_skip_sw(n->flags))
> -			return err;
> -		return 0;
> -	}
> -
> -	tc_cls_offload_cnt_update(block, &n->in_hw_count, &n->flags, add);
> +	err = tc_setup_cb_reoffload(block, tp, add, cb, TC_SETUP_CLSU32,
> +				    &cls_u32, cb_priv, &n->flags,
> +				    &n->in_hw_count);
> +	if (err && add && tc_skip_sw(n->flags))
> +		return err;

Could this be further simplified by adding something along the lines of:

	if (!add || !tc_skip_sw(*flags))
		err = 0;

to tc_setup_cb_reoffload() ?

>  
>  	return 0;
>  }
