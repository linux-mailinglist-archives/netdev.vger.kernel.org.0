Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B79147425C
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 01:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388864AbfGXXv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 19:51:56 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39189 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388770AbfGXXv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 19:51:56 -0400
Received: by mail-qk1-f196.google.com with SMTP id w190so35107051qkc.6;
        Wed, 24 Jul 2019 16:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eVbSZHisblXB8XJsceIXXNLtFm8eOCsgwYNeGQOn75o=;
        b=bumidWFNQ90PjOwVLgsXEzW1J/KSBACFnfKkmtpAX+Yla/L+yRuNhonbLo+2cvKoDx
         gXeZpRS8bZhzXf4tg+luQG2Nl6orPHnEmgWdqNz8ygy8NavWTcbjz+NYOWmuKupuGdHk
         bLOyY9P3yOtUF+zyJ1f83nGwDGvJj8tflfMdqFbK+rFTF+nrvtrUHcAmQhk/sNm++e0a
         SuyuJAiwhvt6bUfni1MR8BLQhg7xCROv6cd50RbY3I3VvevT6XXymsSvcsoi5onpBIIj
         ejVPcahHPZxiRtpHoKl7VRgBaYliD6r345ELl0CaT6ZVznNW1s9j6AwIo7bch/Cy8l+L
         HCxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eVbSZHisblXB8XJsceIXXNLtFm8eOCsgwYNeGQOn75o=;
        b=pMgSF7OTas1W4t4JJnzjVax+4NYcIg4BCOFvjlWDWaR/1B6hL7qN8Lhngwdjhoakh5
         g8rrNvje2tfcgmcxP+T/tBOL8y7+VbeCM80AsDXh9qEWsMh5csgZaVSnfqzOOJYUeRWj
         ZCpgGKWDUbtVaemV8HtD45iDB6Gh3Hn4IAyvmSUXQa7WQM18BUcM5WwVhflLJGStOSjB
         AmPITLSo5d/LHoAtvZSSvdPEl2R53vsjTF+LuRqDSl5UuftaR5xnOaVA3zOF7bHXd5T1
         RjC7mZW/XzzgGpkwW1DOnf/FjcJUPAYGo/sCxhgzkjt15jZhi/283CAWcC4ReQF3B1Qz
         ShhQ==
X-Gm-Message-State: APjAAAVrwwUsl2lHPxC7HVXY7+whKnX3ILul7Xc7kcPb3PW/afGjN5hy
        PpyRQycBwfNNqaBsOyzVMV4399yu1ZQ=
X-Google-Smtp-Source: APXvYqyhFZ7i/r0tA1P+yGHyhAMVlNk0EtX7ypGaznH2+4o11lCQIaX4hA9lViI7VFt4b32x5iSsWg==
X-Received: by 2002:ae9:eb8f:: with SMTP id b137mr54676291qkg.136.1564012315175;
        Wed, 24 Jul 2019 16:51:55 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:2135:7c3d:d61c:7f11:969d])
        by smtp.gmail.com with ESMTPSA id x8sm22262220qka.106.2019.07.24.16.51.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 16:51:54 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 0A30EC0AAD; Wed, 24 Jul 2019 20:51:52 -0300 (-03)
Date:   Wed, 24 Jul 2019 20:51:51 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: nf_table_offload: Fix zero prio of
 flow_cls_common_offload
Message-ID: <20190724235151.GB4063@localhost.localdomain>
References: <1562832210-25981-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562832210-25981-1-git-send-email-wenxu@ucloud.cn>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 04:03:30PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> The flow_cls_common_offload prio should be not zero
> 
> It leads the invalid table prio in hw.
> 
> # nft add table netdev firewall
> # nft add chain netdev firewall acl { type filter hook ingress device mlx_pf0vf0 priority - 300 \; }
> # nft add rule netdev firewall acl ip daddr 1.1.1.7 drop
> Error: Could not process rule: Invalid argument
> 
> kernel log
> mlx5_core 0000:81:00.0: E-Switch: Failed to create FDB Table err -22 (table prio: 65535, level: 0, size: 4194304)
> 
> Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  net/netfilter/nf_tables_offload.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
> index 2c33028..01d8133 100644
> --- a/net/netfilter/nf_tables_offload.c
> +++ b/net/netfilter/nf_tables_offload.c
> @@ -7,6 +7,8 @@
>  #include <net/netfilter/nf_tables_offload.h>
>  #include <net/pkt_cls.h>
>  
> +#define FLOW_OFFLOAD_DEFAUT_PRIO 1U
> +
>  static struct nft_flow_rule *nft_flow_rule_alloc(int num_actions)
>  {
>  	struct nft_flow_rule *flow;
> @@ -107,6 +109,7 @@ static void nft_flow_offload_common_init(struct flow_cls_common_offload *common,
>  					struct netlink_ext_ack *extack)
>  {
>  	common->protocol = proto;
> +	common->prio = TC_H_MAKE(FLOW_OFFLOAD_DEFAUT_PRIO << 16, 0);

Note that tc semantics for this is to auto-generate a priority in such
cases, instead of using a default.

@tc_new_tfilter():
        if (prio == 0) {
                /* If no priority is provided by the user,
                 * we allocate one.
                 */
                if (n->nlmsg_flags & NLM_F_CREATE) {
                        prio = TC_H_MAKE(0x80000000U, 0U);
                        prio_allocate = true;
...
                if (prio_allocate)
                        prio = tcf_auto_prio(tcf_chain_tp_prev(chain,
                                                               &chain_info));

>  	common->extack = extack;
>  }
>  
> -- 
> 1.8.3.1
> 
