Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87A04FB72
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 16:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfD3O12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 10:27:28 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41127 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbfD3O12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 10:27:28 -0400
Received: by mail-pf1-f193.google.com with SMTP id 188so7132851pfd.8
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 07:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NJ820opc72NfFQC4FzQX5BYEremBecDKVvJduxy3BWY=;
        b=F70hH3jkPyxrdHlrYLvmXWAf5xLaP3WLwHRccgeIqZOiLjj5g0zfjAmEkJUhRuD/w4
         xz6epjc7P+unZvaj2umZuWdKK9gwEiiDABlj5/xjaZL+JRVUH29ba7hR8dcPoVltfwRx
         ydhwkL7/3oqp3bWJwrm0jFsVisPs4xjhEbNz5UF3vIysP3G56JgTNmF/pRfiAtcS0EqF
         y1xPQYWc/ZoehwRAXe14d+gu8Hk+ikEuWpIb1fC1y9CywiLkVrOoHQGK26A6jsj1mBLG
         jpRlpqxp8kXYZEZMWEK6e9sUvkLXas/KGwxGJnIMHEeMtHiOUmsVDoYFFppvTPZAASuR
         qhUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NJ820opc72NfFQC4FzQX5BYEremBecDKVvJduxy3BWY=;
        b=X9t4v53dJXx03hexj2ToWJRYlDhTuMs/rIL2/EKSJh93UVgIqlNQuwTXZ/obAw3Xch
         bZfxQspbF74+jTIXOaUuyngm4um357iqQnZhUH4sBbbJ5ggqs5qZ2CcdVafXRnkSMhiP
         /bw7URMXkneo1S+7XmKzwhgVpxyLjjG7P3VebPPOq4FaHXdMKU7kUBxRLrUAJ7SOXBRM
         jPbxBT/wQlj31HRg/qKVOzIKSpOUcqpqVp5R49GQGAavVdB0m2OucZsJNlGkn8CmYNMD
         GoiwGJGn9CNz+N3UIgbf79hBSgVMcwAohRzpzzildT99FkcIw5c0oDmlIOp9fcKkI9m0
         zldg==
X-Gm-Message-State: APjAAAW+z48S6GaX1qTHDd3Mi31BFuI3eTxGHY7n0fs2nkCk1ppeAHEg
        KtLnGRqZ2b9YSYSOauFPfx6gQ0xB
X-Google-Smtp-Source: APXvYqyIKtvo0zeTcWydD9S63qsHWR8m56QglS+bseh8DPagmHzHLej+d13QhqAvWo6TLOoGsu3tWg==
X-Received: by 2002:a62:3501:: with SMTP id c1mr47375599pfa.184.1556634447080;
        Tue, 30 Apr 2019 07:27:27 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:d859:1e96:87dc:4109? ([2601:282:800:fd80:d859:1e96:87dc:4109])
        by smtp.googlemail.com with ESMTPSA id b7sm83726725pfj.67.2019.04.30.07.27.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 07:27:25 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 1/3] ipv4: Move cached routes to fib_nh_common
To:     Ido Schimmel <idosch@mellanox.com>,
        David Ahern <dsahern@kernel.org>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20190429161619.23671-1-dsahern@kernel.org>
 <20190429161619.23671-2-dsahern@kernel.org> <20190430064033.GA20104@splinter>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <822f60dd-a206-827e-ad26-b867ffd2e507@gmail.com>
Date:   Tue, 30 Apr 2019 08:27:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190430064033.GA20104@splinter>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/19 12:40 AM, Ido Schimmel wrote:
> On Mon, Apr 29, 2019 at 09:16:17AM -0700, David Ahern wrote:
>>  /* Release a nexthop info record */
>> @@ -491,9 +491,15 @@ int fib_nh_common_init(struct fib_nh_common *nhc, struct nlattr *encap,
>>  		       u16 encap_type, void *cfg, gfp_t gfp_flags,
>>  		       struct netlink_ext_ack *extack)
>>  {
>> +	int err;
>> +
>> +	nhc->nhc_pcpu_rth_output = alloc_percpu_gfp(struct rtable __rcu *,
>> +						    gfp_flags);
>> +	if (!nhc->nhc_pcpu_rth_output)
>> +		return -ENOMEM;
>> +
>>  	if (encap) {
>>  		struct lwtunnel_state *lwtstate;
>> -		int err;
>>  
>>  		if (encap_type == LWTUNNEL_ENCAP_NONE) {
>>  			NL_SET_ERR_MSG(extack, "LWT encap type not specified");
> 
> Failure here will leak 'nhc->nhc_pcpu_rth_output'
> 

ugh, thanks for catching that.

