Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A06A77586
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 02:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbfG0A4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 20:56:33 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38413 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfG0A4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 20:56:32 -0400
Received: by mail-qk1-f193.google.com with SMTP id a27so40423032qkk.5
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 17:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=D+EahN2WDf0UyCF98RwKe0SRG64PvdhD02JevFEUhtM=;
        b=U0q6OZF7xUK0PumILnqjgZfuzTudsgX6VT7DF2aM+v4ai87AWV5mylM4SF26xhvDtR
         BWw0BbrcGMnsO3TQa5WfqUZki7cyqApXWDdwW4qjBxh2FLE2yUxeDBFMRICaCsj4OjjE
         lzYosjpUBd/d030OEWnB2fp3ooEHPkPgCDBXEs8W2SrbKW6F7KveRQqKEJmyjqwQihh4
         fJ1JC/1OvC2WJwc3b7k4HSSiESMFnnSot/I7r6NWEY4XJmC4Wl+GlB4W+FeMORNmrZWz
         KLPvYqpEH6mifGXU8FNDJ7hyeEgOKOtDhPcJloi1aShVhgHLsXiGRqOk+OXY2QmRPJXJ
         +qOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=D+EahN2WDf0UyCF98RwKe0SRG64PvdhD02JevFEUhtM=;
        b=tpRPHy5DmBJK6zLmuWTdWg+SorK6CiAttbgpzB9X/4XgPn6hsH48kued+FOzwDFTDt
         YEwUuLRuXxGYe6y8XtGseHnYVgll4dQMlWxsu1ZjgRdRGQJzDdq1vzBpBK0eettuOw9v
         PCXM/nfN2mOm62cb+rDi46gFFIXJfmaoCj9hCMipxhAg9CTn9J8qRhyH9YD1+Gij3waJ
         /1Z/MjAmVxF84CGRX6XAoY2vqPES4pACAh7egRm6ECp9GbhY7rpjOoPBY5ezBEqff551
         SmIVsNmmSxWPL33E1GID9sVMHlVXmu1QzlldRFRbzRBRO9TfIgfZWecMOKsmlIxO0JFz
         0YUQ==
X-Gm-Message-State: APjAAAWpKOoNlRFpNIuTyG9TPGOmdAsAATbtH8DgUNDFQIaCkc5cCnSs
        hoRx18wClNxXVuqLopXAcPYE8g==
X-Google-Smtp-Source: APXvYqxWCmIsDgrHAK05JR8WqgdMV0+hgjUzOArYSbDIbTXLTKJNiTDR4x/uzFmMNznIrTyo6qjDig==
X-Received: by 2002:a37:dc42:: with SMTP id v63mr48716828qki.488.1564188991930;
        Fri, 26 Jul 2019 17:56:31 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m8sm21000597qkg.104.2019.07.26.17.56.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 17:56:31 -0700 (PDT)
Date:   Fri, 26 Jul 2019 17:56:27 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/3] flow_offload: move tc indirect block to
 flow offload
Message-ID: <20190726175627.7c146f94@cakuba.netronome.com>
In-Reply-To: <1564148047-6428-2-git-send-email-wenxu@ucloud.cn>
References: <1564148047-6428-1-git-send-email-wenxu@ucloud.cn>
        <1564148047-6428-2-git-send-email-wenxu@ucloud.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jul 2019 21:34:05 +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> move tc indirect block to flow_offload and rename
> it to flow indirect block.The nf_tables can use the
> indr block architecture.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>

> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 00b9aab..66f89bc 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -4,6 +4,7 @@
>  #include <linux/kernel.h>
>  #include <linux/list.h>
>  #include <net/flow_dissector.h>
> +#include <linux/rhashtable.h>
>  
>  struct flow_match {
>  	struct flow_dissector	*dissector;
> @@ -366,4 +367,42 @@ static inline void flow_block_init(struct flow_block *flow_block)
>  	INIT_LIST_HEAD(&flow_block->cb_list);
>  }
>  
> +typedef int flow_indr_block_bind_cb_t(struct net_device *dev, void *cb_priv,
> +				      enum tc_setup_type type, void *type_data);
> +
> +struct flow_indr_block_cb {
> +	struct list_head list;
> +	void *cb_priv;
> +	flow_indr_block_bind_cb_t *cb;
> +	void *cb_ident;
> +};
> +
> +typedef void flow_indr_block_ing_cmd_t(struct net_device *dev,
> +				       struct flow_block *flow_block,
> +				       struct flow_indr_block_cb *indr_block_cb,
> +				       enum flow_block_command command);
> +
> +struct flow_indr_block_dev {
> +	struct rhash_head ht_node;
> +	struct net_device *dev;
> +	unsigned int refcnt;
> +	struct list_head cb_list;
> +	flow_indr_block_ing_cmd_t *ing_cmd_cb;
> +	struct flow_block *flow_block;

TC can only have one block per device. Now with nftables offload we can
have multiple blocks. Could you elaborate how this is solved?

> +};
