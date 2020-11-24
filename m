Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6147E2C25DE
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 13:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387623AbgKXMmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 07:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387546AbgKXMmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 07:42:19 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36916C0613D6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 04:42:19 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id k1so7771524eds.13
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 04:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v5oJEH7G3NHZCE4xwCSDjX6qOD8dCQf3Ud7tVmANgVM=;
        b=c1d8Pohu1nhl+isGtY5U7X38voeZtZl3F66L9JW/m1LPkdR5K3PaIh9z390H3UgOW1
         0okfMO4T1ew/vDFgWqohggnsr2uABUQA+UH0zChyTeI5y7AKvcLuN7+pmAMlKFYluWYc
         z2l/9VW+ZJaWwf9CDBJcckNMZZD1zyWRzp0PxJwHWW+hwJSh5EVo0D9rSAOwUUCOh/0O
         VvFayLjX+3g7/KvRqC95GbbWVKHLeDtExrFD8+dOtz8OwYARDfPk5wjvML1UBsoWnUu5
         WN+Bf0ztsE23iOGPEz1z3kkko0UgehuqNxQBfL3zNb6OBETIgcgeNlXw84CKLb8v4Xi7
         3y1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=v5oJEH7G3NHZCE4xwCSDjX6qOD8dCQf3Ud7tVmANgVM=;
        b=PXESqXjoHvFatkXPBnA3nYyzsDvROKL9cKmsID64g9rn0mH9zTP5dTfZPfffDHTyiD
         kxqyQueVmiKNOvhuSTFJErCxbh0nmFpnJiotCmAyn/7QcPTCRLjfkDmWWukZWkw0ovXi
         Q02CeLQuPeD/XbQt3ahCDzRAqhB4iGTnleBX6CK0eDV256eG/x6tHnl5uHzp9nXLcPnU
         SjaT7qLlB1johpUTGDmwvi8QYf45MZgBbJlkDv/XwsVQ339BABLujBZZXk2CsOY3WxPl
         LqKAIFDzJQyuVIcuITchkrDP+qfvd7IxbQENqu3hA5j+jwiyfIF7Ba6ZrnWVToe1gJy/
         L3GQ==
X-Gm-Message-State: AOAM533XmS+w2hVvvyMI9RClWXkrliNpuyPIlh7aB/T3AuStMcXhLNtn
        912d83huvj4xBpEo+DRNxn8=
X-Google-Smtp-Source: ABdhPJz/aH3/Tt6mbz2V5VctyD7Ej/ypu7zOioxye7qCaLGCRKq8atFAhXuoXKlxvmrgliOEQxPaaQ==
X-Received: by 2002:a05:6402:1c1c:: with SMTP id ck28mr3833420edb.336.1606221737902;
        Tue, 24 Nov 2020 04:42:17 -0800 (PST)
Received: from tycho ([2a02:810d:e80:4c80:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id d2sm6702333ejr.31.2020.11.24.04.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 04:42:16 -0800 (PST)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
Date:   Tue, 24 Nov 2020 13:42:15 +0100
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>, jianbol@mellanox.com,
        jhs@mojatatu.com
Subject: Re: [PATCH iproute2-next 1/1] tc flower: fix parsing vlan_id and
 vlan_prio
Message-ID: <20201124124215.dzdj37g2a3uhfran@tycho>
References: <20201124122810.46790-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124122810.46790-1-roid@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 02:28:10PM +0200, Roi Dayan wrote:
> When protocol is vlan then eth_type is set to the vlan eth type.
> So when parsing vlan_id and vlan_prio need to check tc_proto
> is vlan and not eth_type.
> 
> Fixes: 4c551369e083 ("tc flower: use right ethertype in icmp/arp parsing")
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> ---
>  tc/f_flower.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tc/f_flower.c b/tc/f_flower.c
> index 58e1140d7391..9b278f3c0e83 100644
> --- a/tc/f_flower.c
> +++ b/tc/f_flower.c
> @@ -1432,7 +1432,7 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
>  			__u16 vid;
>  
>  			NEXT_ARG();
> -			if (!eth_type_vlan(eth_type)) {
> +			if (!eth_type_vlan(tc_proto)) {
>  				fprintf(stderr, "Can't set \"vlan_id\" if ethertype isn't 802.1Q or 802.1AD\n");
>  				return -1;
>  			}
> @@ -1446,7 +1446,7 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
>  			__u8 vlan_prio;
>  
>  			NEXT_ARG();
> -			if (!eth_type_vlan(eth_type)) {
> +			if (!eth_type_vlan(tc_proto)) {
>  				fprintf(stderr, "Can't set \"vlan_prio\" if ethertype isn't 802.1Q or 802.1AD\n");
>  				return -1;
>  			}
> -- 

Thanks for fixing this. I missed to test the option odering in my tests.
Your fix works fine for me. Sorry for missing this.

> 2.25.4
