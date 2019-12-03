Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F946110317
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 18:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfLCRBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 12:01:20 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:42363 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbfLCRBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 12:01:19 -0500
Received: by mail-qv1-f68.google.com with SMTP id q19so1808058qvy.9;
        Tue, 03 Dec 2019 09:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=10sAMBZMUjFRsxR8aABeO1fVDktZCwcXIz8Qs0BHrSI=;
        b=bY77NiQkC69ov7j7OMLKkUXv6HhSowFkfYiDrdT5MFbfThUXtqBo0fzqZq+McugIVR
         Q2QfuUadPMWiGjz4Vdu+S8qoCsTOkSExFSHJD7xV3SM/IjGKWQV+9ckB97Ev33USoYkM
         TzkTtdEZWGzt/TbReefLvdSPrMonuXVK5cYQgJHIZCA+LuEoBJo2iQM2Z4b24hYZSvgb
         7ByROBx5EPuzD3EhiuwVqB3DMS5MB5E0a09Sv8ImxbvrKW6W68Cvr8By+qApje890sKN
         8RBrvnIkZNH3iY+i4bocTfPL4JdCR6qQJX6DJSHNmAOpm3OhVjdhVTkXonnaLRnFnRO0
         AFjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=10sAMBZMUjFRsxR8aABeO1fVDktZCwcXIz8Qs0BHrSI=;
        b=UG4xotlAx0b0MmIEXJZx/4RlpGzzw5lOeGnMJWrBcMVMZXLLg6JQDXt/cTGvt3lEKE
         m+UwuAYiEUcGsyOyGd33yTFIQvanKpf3+3I9QuUCsczehqFyP4IRkY8WAyvTFX41cPl5
         vtbBy5TDWbK4n+IbF5xWV1RRzUprltSUJeZoq7Y3tayHMcDi8ZZh5n3zgV9IaT0rvZMI
         vyWW7yiae/tH0jvg/ZchGT5R6efGKgqAhwOuPYaNuPEp8bPXGv97UacsY08p8r3HkmK0
         E5EFyACdDeTp3SJ8wGaskIaRqSrbQvWAlQLgGyPHyWgVxj8kA3qHW5TXHaCSmqt24d6S
         /5Ag==
X-Gm-Message-State: APjAAAXmMitp/LwpOJ4+a9buUWmO2tn/i1i3lNcpCtpV8q+mAcUeOrKL
        Y0UK6yJ/juAohls29GcKcvE+jXPvOk3B7w==
X-Google-Smtp-Source: APXvYqzU6RtFIOwEITHm1Sqpx6zVqf5CvLcV04Vc9oAuR1Wi3o/5oFzruFpcsdbB9tUU46vP3NflIA==
X-Received: by 2002:a05:6214:429:: with SMTP id a9mr6176316qvy.200.1575392478385;
        Tue, 03 Dec 2019 09:01:18 -0800 (PST)
Received: from localhost.localdomain ([177.220.176.179])
        by smtp.gmail.com with ESMTPSA id c184sm2066760qke.118.2019.12.03.09.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 09:01:17 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 6038EC3B9B; Tue,  3 Dec 2019 14:01:14 -0300 (-03)
Date:   Tue, 3 Dec 2019 14:01:14 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Laura Abbott <labbott@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] netfilter: nf_flow_table_offload: Correct memcpy size
 for flow_overload_mangle
Message-ID: <20191203170114.GB377782@localhost.localdomain>
References: <20191203160345.24743-1-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203160345.24743-1-labbott@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 03, 2019 at 11:03:45AM -0500, Laura Abbott wrote:
> The sizes for memcpy in flow_offload_mangle don't match
> the source variables, leading to overflow errors on some
> build configurations:
> 
> In function 'memcpy',
>     inlined from 'flow_offload_mangle' at net/netfilter/nf_flow_table_offload.c:112:2,
>     inlined from 'flow_offload_port_dnat' at net/netfilter/nf_flow_table_offload.c:373:2,
>     inlined from 'nf_flow_rule_route_ipv4' at net/netfilter/nf_flow_table_offload.c:424:3:
> ./include/linux/string.h:376:4: error: call to '__read_overflow2' declared with attribute error: detected read beyond size of object passed as 2nd parameter
>   376 |    __read_overflow2();
>       |    ^~~~~~~~~~~~~~~~~~
> make[2]: *** [scripts/Makefile.build:266: net/netfilter/nf_flow_table_offload.o] Error 1
> 
> Fix this by using the corresponding type.
> 
> Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> Seen on a Fedora powerpc little endian build with -O3 but it looks like
> it is correctly catching an error with doing a memcpy outside the source
> variable.

Hi,

It is right but the fix is not. In that call trace:

flow_offload_port_dnat() {
...
        u32 mask = ~htonl(0xffff);
        __be16 port;
...
        flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
	                            (u8 *)&port, (u8 *)&mask);
}

port should have a 32b storage as well, and aligned with the mask.

> ---
>  net/netfilter/nf_flow_table_offload.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index c54c9a6cc981..526f894d0bdb 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -108,8 +108,8 @@ static void flow_offload_mangle(struct flow_action_entry *entry,
>  	entry->id = FLOW_ACTION_MANGLE;
>  	entry->mangle.htype = htype;
>  	entry->mangle.offset = offset;
> -	memcpy(&entry->mangle.mask, mask, sizeof(u32));
> -	memcpy(&entry->mangle.val, value, sizeof(u32));
                                   ^^^^^         ^^^ which is &port in the call above
> +	memcpy(&entry->mangle.mask, mask, sizeof(u8));
> +	memcpy(&entry->mangle.val, value, sizeof(u8));

This fix would cause it to copy only the first byte, which is not the
intention.

>  }
>  
>  static inline struct flow_action_entry *
> -- 
> 2.21.0
> 
