Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834194558DA
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 11:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244913AbhKRKVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 05:21:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245445AbhKRKVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 05:21:02 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80F3C061570
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 02:17:21 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso5285482pjb.0
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 02:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YYvNuf9oFFf9FQuQvaVjeMqnBn6eFulxHB4cZRJQhHY=;
        b=bVVDhXHLREtcGB6nZF7d04GkxEMFEl5JY46d32qMpqgs3IjOhqnooEA6Whtr171YeC
         qbnmBD4DDXeVXx94kEKjbymX8t5cBhmpMuF4nZnrVZc0RX9fZxvTQfuUv14Ledt21zWJ
         yYyX/MadQYeAx1p7icPUXtC7uafPztaDBFtfP8yqTblL0Z7vn5jD5AQJuctYoYJho9KQ
         AhrVwUxjpkW/UwA6+kOvqSwd4/2B8Fv7moKxgDEXn5XZyv0iG9+Bc0TZEYvLUeJUsZSY
         k+QuWjeknS+sUEHYhnWFbFO8ZEn16uhS4x8BaW1WAPAECSSaGS3ugzo6TogPjLg/wFD1
         TWQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YYvNuf9oFFf9FQuQvaVjeMqnBn6eFulxHB4cZRJQhHY=;
        b=JAvj87K9DHDn8zj5BzUldGJMsE6M8qdqxzxX6gT1HttDeYMgDAO9iJWypiwW+C7YjY
         /pVT5kU8V57Mmm9ADbak2pMQJnpsPODlwc4NM6jJGpXu1b8Yc+v8watd6RJb1X8BcKan
         gh7MAMLfj1BwrHpdtGaVUZ0nHExdBedkh5xD0xhlSl7l1MuobW+Bs+Dl2qwnWp8nhPdx
         TxgKcg751YJSIb/s1uM+1vusQCsMwdNQPYLzdjYvyHjbkeGLwyEx3GxL8750Y/ldbEux
         MC/W9TIOOaxLvH/V5B90jwpa5mdDTqiVZp7SfTKzlecx7DU55qNFzOK4Ha5DaIjUxAKU
         yRUg==
X-Gm-Message-State: AOAM533rZrapsiYvogmuhE52chzsox+LgnWWKWAXcsjNpCocCDH/fdLl
        iFi/9iWO89YfXlDux6wyXxE=
X-Google-Smtp-Source: ABdhPJzj6kzciKQhFFLwZtca0Eu9RZngie3RMoOTbsYrcHsKX9nRi1xwL8L9G6dGjne9C/l/2HGxgA==
X-Received: by 2002:a17:90b:17cc:: with SMTP id me12mr9058801pjb.141.1637230641283;
        Thu, 18 Nov 2021 02:17:21 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c3sm1908157pgk.16.2021.11.18.02.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 02:17:20 -0800 (PST)
Date:   Thu, 18 Nov 2021 18:17:14 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <jay.vosburgh@canonical.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [DISCUSS] Bond arp monitor not works with veth due to flag
 NETIF_F_LLTX.
Message-ID: <YZYoKuvrZmHEiQGx@Laptop-X1>
References: <YZXEY90dRsBjJckd@Laptop-X1>
 <CANn89iLKKX7+opENOa2oQpH_JmpPYeDPZtb+srYF2O3UgdUT5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLKKX7+opENOa2oQpH_JmpPYeDPZtb+srYF2O3UgdUT5g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 07:34:40PM -0800, Eric Dumazet wrote:
> Removing LLTX will have performance impact.

Yes, I also think so.
> 
> Updating ->trans_start at most once per jiffy should be ok.
> 
> Here is a patch against net-next
> @@ -4626,7 +4620,7 @@ static inline netdev_tx_t
> netdev_start_xmit(struct sk_buff *skb, struct net_devi
> 
>         rc = __netdev_start_xmit(ops, skb, dev, more);
>         if (rc == NETDEV_TX_OK)
> -               txq_trans_update(txq);
> +               txq_trans_cond_update(txq);
> 
>         return rc;
>  }

Awesome. This should resolve the veth's trans_start issue. Where is the patch?
I only find out the following one but could not find the fix in netdev_start_xmit()

https://patchwork.kernel.org/project/netdevbpf/patch/20211117032924.1740327-3-eric.dumazet@gmail.com/

Thanks
Hangbin
