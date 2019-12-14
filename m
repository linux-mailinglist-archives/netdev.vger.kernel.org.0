Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C82E211EFEA
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 03:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfLNCLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 21:11:02 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44915 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfLNCLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 21:11:02 -0500
Received: by mail-lj1-f195.google.com with SMTP id c19so695702lji.11
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 18:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ySR7TYBQhTmVu6KMG+j74j9+ZRg88KrNjUFtJErf2/0=;
        b=SXb/Zp7fUVFOXqfsfn1Ioi/WCk64YO6dsh3bicKU9wV4cG/gEi+dbN5rIl0dnqNrhV
         hj7Pekuq1K/ayYHab9CbuM/ujPP8uKnHBwwEwB0NYmiMBmcQAgQdGCjKDi6PV941gJrp
         GbTgKumeOWmxeIRrA432U8eUyQzwl5vuupxwSUlwolCL2LXLTwjdQeLiLMwvTr55s8XK
         IfyfzAaaN0D3Pjojv/MIQ+Bw/ZGf6wYdEd4WI10MM48Z925uAGyqIHxqQNf/Bqo/2SFe
         cft5eLFeHCbYDPztS2t7tmfzWLQ9WjLGol5lFyuV3jgdVCNFcp8bSmaM1ILwTSUBpi/V
         +K/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ySR7TYBQhTmVu6KMG+j74j9+ZRg88KrNjUFtJErf2/0=;
        b=BOQB8B+/N8vq2CL2+FMCiNixqcmosVRVoNlsqK5mj9jnir3FJDN5tyisnBtHKGTy7K
         L0WHeBolMJx/FpxiLQExUazl+adD0jR+rpgKwwUVUXU+Nz/j/tRLwcfiQuYpFmvE1GYF
         1FZWMcRT1l0XJoaNoRA+wbyaMhAg4HunPsoPzK98Ah+Zcq+vGJuZTdDz9ZbphF6GVSXG
         +ss5PZbWE3uqkS01sqYQEYwKVdL9s+JAvCld9yHu4ZBemIZtFz509gmsOCan+ls9M+iL
         uXs6rM5yBXPwCZc323cYOcC6l9VgNCFeiydRobx0i4KxJiuDrpd6+IKsYsyW2DwJQjyU
         j2Aw==
X-Gm-Message-State: APjAAAUIo0kp7OF1LiQ2gAjK7ou5M/dObHEKfLtbogSGORsCe5Up0iBx
        HCZ4ZV3mi2IKNSMk+wcq3KAW9w==
X-Google-Smtp-Source: APXvYqx31c9AbeMwEq7DpSSfHmn+XAWX9b/tCrkJXLP1y/F+yXyKvwm6s4HTOnIAjWUHUq9asiCdQQ==
X-Received: by 2002:a2e:978d:: with SMTP id y13mr11738378lji.103.1576289460426;
        Fri, 13 Dec 2019 18:11:00 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x13sm5268984lfe.48.2019.12.13.18.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 18:11:00 -0800 (PST)
Date:   Fri, 13 Dec 2019 18:10:51 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] bonding: don't init workqueues on error
Message-ID: <20191213181051.0f949b17@cakuba.netronome.com>
In-Reply-To: <20191210152454.86247-1-mcroce@redhat.com>
References: <20191210152454.86247-1-mcroce@redhat.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 16:24:54 +0100, Matteo Croce wrote:
> bond_create() initialize six workqueues used later on.

Work _entries_ not _queues_ no?

> In the unlikely event that the device registration fails, these
> structures are initialized unnecessarily, so move the initialization
> out of the error path. Also, create an error label to remove some
> duplicated code.

Does the initialization of work entries matter? Is this prep for further
changes?

> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---
>  drivers/net/bonding/bond_main.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index fcb7c2f7f001..8756b6a023d7 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -4889,8 +4889,8 @@ int bond_create(struct net *net, const char *name)
>  				   bond_setup, tx_queues);
>  	if (!bond_dev) {
>  		pr_err("%s: eek! can't alloc netdev!\n", name);

If this is a clean up patch I think this pr_err() could also be removed?
Memory allocation usually fail very loudly so there should be no reason
to print more errors.

> -		rtnl_unlock();
> -		return -ENOMEM;
> +		res = -ENOMEM;
> +		goto out_unlock;
>  	}
>  
>  	/*
> @@ -4905,14 +4905,17 @@ int bond_create(struct net *net, const char *name)
>  	bond_dev->rtnl_link_ops = &bond_link_ops;
>  
>  	res = register_netdevice(bond_dev);
> +	if (res < 0) {
> +		free_netdev(bond_dev);
> +		goto out_unlock;
> +	}
>  
>  	netif_carrier_off(bond_dev);
>  
>  	bond_work_init_all(bond);
>  
> +out_unlock:
>  	rtnl_unlock();
> -	if (res < 0)
> -		free_netdev(bond_dev);
>  	return res;
>  }
>  

I do appreciate that the change makes the error handling follow a more
usual kernel pattern, but IMHO it'd be even better if the error
handling was completely moved. IOW the success path should end with
return 0; and the error path should contain free_netdev(bond_dev);

-	int res;
+	int err;

	[...]

	rtnl_unlock();

	return 0;

err_free_netdev:
	free_netdev(bond_dev);
err_unlock:
	rtnl_unlock();
	return err;

I'm just not 100% sold on the improvement made by this patch being
worth the code churn, please convince me, respin or get an ack from 
one of the maintainers? :)
