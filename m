Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3E5350EAB
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 08:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbhDAGBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 02:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbhDAGBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 02:01:07 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DEAC0613E6;
        Wed, 31 Mar 2021 23:01:07 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id r193so1025516ior.9;
        Wed, 31 Mar 2021 23:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=06y1qDdm9ehv2aJ33VAMzR7RKpCaEtAz7uhrKJ60mxg=;
        b=a17lqAMJYXlKpH8d97gDcuihF9k+s5JGy/dvs8rKnosvZvz0JRTYkAAWPzI2y+X68Q
         R77dcfFZwAw0fq6NWkh8Bim1BchDa84si2g3ABiAeHDA+1118BulRHn5HrX8S3hfBveF
         UGAJc1MbrS1TxGKiUH/lEDwYlHfIUTQZqpwgDIy6TfY0nH7vBfqUgVNSlNLFSPcj2bRa
         298wO2tPW3uqyvF9sILsgOEXsjELsaEFMIlAVXc5oyAFmFvKRC+xx/p/5mEwqfGv1hWx
         hzI0dk6ra83OMn6dluf+fDVPHjHz8h6Yv8yWnlZc7jWxGSohzF9HoUNSriKZRETRntd0
         /OmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=06y1qDdm9ehv2aJ33VAMzR7RKpCaEtAz7uhrKJ60mxg=;
        b=iTZx/LNGeQpkWgSAqvQpJSi5tOVRS8Motf94nJC2nkEsv7NBOZJufa1QloDZPsuY0M
         7U1oaH9IGoUThVT8lgo0uGnSSzpiuhy132gug16cK9X9eNxjXY9oQvVuhf0xjonD90/I
         KAvL0jAa+o8KVu9Lc5IgZydgePqMjSCIglp9o3u74j0USQeCjaZvFakf6B9e6RdkIFPG
         mzaeC09KzdeO5HnMRmSJ5N5c2OVsZ00N0qYauaoRgpfnSnXZhdT6njztXZ1n1+xmkqTZ
         reET6KdNXWJseNQfZp+ozxydVsfHp1rGYY+bNBUdvyW52WIGp9qepL+BULPtQA7F3b8l
         1fbg==
X-Gm-Message-State: AOAM5332PnXdM5Gt1YX8szxypQSzydlPUKm+wCAyzlGFo87FWoxLAIMa
        9jOAkVryBKBxbYMpnCRaBkU=
X-Google-Smtp-Source: ABdhPJwcq17ij/DtCkCl3cigFcxX7mliHh+fsQmSIobFdFrMvO0ks8t3RJfUI8L3oFD5jJ/OUIuWfw==
X-Received: by 2002:a6b:d20e:: with SMTP id q14mr5353279iob.200.1617256866891;
        Wed, 31 Mar 2021 23:01:06 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id x6sm2228152ioh.19.2021.03.31.23.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 23:01:06 -0700 (PDT)
Date:   Wed, 31 Mar 2021 23:00:58 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <6065619aa26d1_938bb2085e@john-XPS-13-9370.notmuch>
In-Reply-To: <20210331023237.41094-12-xiyou.wangcong@gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
 <20210331023237.41094-12-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v8 11/16] udp: implement ->read_sock() for
 sockmap
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> This is similar to tcp_read_sock(), except we do not need
> to worry about connections, we just need to retrieve skb
> from UDP receive queue.
> 
> Note, the return value of ->read_sock() is unused in
> sk_psock_verdict_data_ready(), and UDP still does not
> support splice() due to lack of ->splice_read(), so users
> can not reach udp_read_sock() directly.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Thanks this is easier to read IMO. One nit below.

Acked-by: John Fastabend <john.fastabend@gmail.com>

[...]

>  
> +int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> +		  sk_read_actor_t recv_actor)
> +{
> +	int copied = 0;
> +
> +	while (1) {
> +		struct sk_buff *skb;
> +		int err, used;
> +
> +		skb = skb_recv_udp(sk, 0, 1, &err);
> +		if (!skb)
> +			return err;
> +		used = recv_actor(desc, skb, 0, skb->len);
> +		if (used <= 0) {
> +			if (!copied)
> +				copied = used;
> +			break;
> +		} else if (used <= skb->len) {
> +			copied += used;
> +		}

This 'else if' is always true if above is false right? Would be
impler and clearer IMO as,

               if (used <= 0) {
		        if (!copied)
				copied = used;
			break;
               }
               copied += used;

I don't see anyway for used to be great than  skb->len.

> +
> +		if (!desc->count)
> +			break;
> +	}
> +
> +	return copied;
> +}
> +EXPORT_SYMBOL(udp_read_sock);
> +
