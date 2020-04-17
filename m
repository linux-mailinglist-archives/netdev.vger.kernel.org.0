Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B934A1AE797
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 23:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgDQV32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 17:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgDQV31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 17:29:27 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73112C061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 14:29:25 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id c63so4088139qke.2
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 14:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IiEbcNaplikrc29++oJEQ14AOhZabHANzN9JHabZrII=;
        b=CcGwn62EI72GGPgPovjsc5zykLqzOjuCXOR6Lpa89UiEt8E60CsNsMnzctkmr9gmhb
         dap/mEp2jEY9Oyf8Z/+FP1ZM0JLY5Mbna9Bt/Y9pFSVeukS82eA66fGujwfXOfQpnjd9
         b+ZP22bbiDBhmTp8pAJysoIm4ihaEBhfkB4jgFiENykqJldjHBFWy42D5Qnmz3nGm3TK
         fMk/3pRtSyNkZJQcLFVf+ypgXJp8lz1shdHQFOAMSQJcQkWzdA8mhxNkx5qPiO3tzrBz
         dDUJEWjgQNwv6W67Gcv1xQFo7UqXaRZt0lLkC43lUK3YScmJxX3wJ70qczn9tLsx4+xG
         IyTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IiEbcNaplikrc29++oJEQ14AOhZabHANzN9JHabZrII=;
        b=PXO+ycIz+e3jWrZngpivLcIypTlr9b0fDOK8Sr5zmbaeaAiyCWel/kYMl3FnmVd23t
         MfdeHjc7wzFYzmv/S5odHt3kfayaU/mBki0UJW0GcmF+B1iFnGXhFu+NP3ri1ikQG5cj
         Pqzv8p0eX30ShrjeQmWUO+educr6SkPoYI8332j6Niqj92qsXs8zUk2HLU6QySKpXHEM
         HFIJifoPrfQnnzKMONUXlSSVzEd7QyE5FS1HQl8bvzxiAqGp0f/8NMEe5EY0HNHbVcpX
         ZKjE6bYVUgLnYTb3m1ooVd3tYUicN4ihGmzdfmQHjRmDHXbliRh0DHnvCWFOGicnBiu2
         VFuw==
X-Gm-Message-State: AGi0PuaaAd8/EY1UmIy7CAXfj4c9T9mowwSaEl9RXTit4NZjZuQbcNOY
        uPZnQX2QuYJmv2+Bi6LmRK4=
X-Google-Smtp-Source: APiQypJ//9gyfjGalqFvnptedzHmb7wemdy7kS6JjxyaZGfj+rhbJEgoXLpPX38SaZi+xHyJIvxuDA==
X-Received: by 2002:a37:68cd:: with SMTP id d196mr5434279qkc.188.1587158964649;
        Fri, 17 Apr 2020 14:29:24 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:d897:9718:2ec7:8952? ([2601:282:803:7700:d897:9718:2ec7:8952])
        by smtp.googlemail.com with ESMTPSA id p10sm18397441qtu.14.2020.04.17.14.29.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 14:29:24 -0700 (PDT)
Subject: Re: [PATCH RFC-v5 bpf-next 09/12] dev: Support xdp in the Tx path for
 xdp_frames
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        toke@redhat.com, toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200413171801.54406-1-dsahern@kernel.org>
 <20200413171801.54406-10-dsahern@kernel.org> <20200417103055.51a25b2d@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4bd9f68f-ca64-66a5-d05b-567032e2a48d@gmail.com>
Date:   Fri, 17 Apr 2020 15:29:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200417103055.51a25b2d@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/17/20 2:30 AM, Jesper Dangaard Brouer wrote:
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 1bbaeb8842ed..f23dc6043329 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -4720,6 +4720,76 @@ u32 do_xdp_egress_skb(struct net_device *dev, struct sk_buff *skb)
>>  }
>>  EXPORT_SYMBOL_GPL(do_xdp_egress_skb);
>>  
>> +static u32 __xdp_egress_frame(struct net_device *dev,
>> +			      struct bpf_prog *xdp_prog,
>> +			      struct xdp_frame *xdp_frame,
>> +			      struct xdp_txq_info *txq)
>> +{
>> +	struct xdp_buff xdp;
>> +	u32 act;
>> +
>> +	xdp.data_hard_start = xdp_frame->data - xdp_frame->headroom;
> 
> You also need: minus sizeof(*xdp_frame).

Updated. thanks.

> 
> The BPF-helper xdp_adjust_head will not allow BPF-prog to access the
> memory area that is used for xdp_frame, thus it still is safe.
> 
> 
>> +	xdp.data = xdp_frame->data;
>> +	xdp.data_end = xdp.data + xdp_frame->len;
>> +	xdp_set_data_meta_invalid(&xdp);
>> +	xdp.txq = txq;
> 
> I think this will be the 3rd place we convert xdp-frame to xdp_buff,
> perhaps we should introduce a helper function call.

> 
>> +	act = bpf_prog_run_xdp(xdp_prog, &xdp);
>> +	act = handle_xdp_egress_act(act, dev, xdp_prog);
>> +
>> +	/* if not dropping frame, readjust pointers in case
>> +	 * program made changes to the buffer
>> +	 */
>> +	if (act != XDP_DROP) {
>> +		int headroom = xdp.data - xdp.data_hard_start;
>> +		int metasize = xdp.data - xdp.data_meta;
>> +
>> +		metasize = metasize > 0 ? metasize : 0;
>> +		if (unlikely((headroom - metasize) < sizeof(*xdp_frame)))
>> +			return XDP_DROP;
>> +
>> +		xdp_frame = xdp.data_hard_start;
> 
> Is this needed?

removed.

> 
>> +		xdp_frame->data = xdp.data;
>> +		xdp_frame->len  = xdp.data_end - xdp.data;
>> +		xdp_frame->headroom = headroom - sizeof(*xdp_frame);
>> +		xdp_frame->metasize = metasize;
>> +		/* xdp_frame->mem is unchanged */
> 
> This looks very similar to convert_to_xdp_frame.

yes, except the rxq references since rxq is not set.

> Maybe we need an central update_xdp_frame(xdp_buff) call?
> 
> 
> Untested code-up:
> 

sure, that should work.
