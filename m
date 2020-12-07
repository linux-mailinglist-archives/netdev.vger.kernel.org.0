Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE9D2D15E3
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgLGQYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:24:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21218 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725863AbgLGQYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 11:24:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607358155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VzvFgcbXqnSf0xffgB1ICdPB4YvhRJaj2zUkRxRlQvw=;
        b=h7jjfI9VB+DDlTvSqfhubqBpYqjD384CUZd+92u3EYnTVfyQ/WrppOmrsWyquk36d2WWtQ
        fSqn1AA6aiXcW95LZyzvHM9mY9/kRoiHFx6BLLnqlLI65vLVFwF8yovpfKJskVkDr2p7GC
        2PxkO3ifEL784sC+iX+235LUtp41uKA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-HlRt9_PoMTqC9Jf78hlYsQ-1; Mon, 07 Dec 2020 11:22:33 -0500
X-MC-Unique: HlRt9_PoMTqC9Jf78hlYsQ-1
Received: by mail-wr1-f69.google.com with SMTP id x10so5025944wrs.2
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 08:22:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VzvFgcbXqnSf0xffgB1ICdPB4YvhRJaj2zUkRxRlQvw=;
        b=t7epqWpoBP0bNMkUALInp2kUgYOBLK/mo3bHcdYqNzZ5KV2DPIBGCY99h25q0/yV7N
         yCN6dfH7V9jjSXfiYzsxk74u+swuSMIKoFvS1j33Gaf2sKVWyhZ13YsYGVWRbbXZe7Od
         foI3zd89/+b/E90Y1cR6RYAs6RirFht7v7AOMv2++NMpcEP2pVVT7wCo10Jkx3kAOuqQ
         Saa373MgMeAD3h/C6ESKKCjpdSep6pFWrg36nkXi/PSrob/BN+VivZbpSrf4fSG85y37
         4WqHV++vxQyt3wjqXDin0S08QejYkT/BnmiN1fKZdJHo2zFwxo8N6mfDvCBPqQsuZLb/
         fpcg==
X-Gm-Message-State: AOAM533TBkxgMxi3pbrVn4O8itxqN3mligkTJcMuC3TwIjz6YGmPRL/M
        +iH58HW6/gnopJmVESysCla8g9VhN0uMH2byyQhcpCUvbeZXExAVNj1ReccruCUQzdjeKn25wQE
        qsDQt593rR6+u3qs5
X-Received: by 2002:a1c:e084:: with SMTP id x126mr19187749wmg.109.1607358151740;
        Mon, 07 Dec 2020 08:22:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJycFcwKR8WO2DZJ7hs2XU1mp00MCtx1NkC6tHNn6rEFnUPjIfHSlQdqiYzHOb4OUQ83UAzwJQ==
X-Received: by 2002:a1c:e084:: with SMTP id x126mr19187738wmg.109.1607358151562;
        Mon, 07 Dec 2020 08:22:31 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id m8sm15033298wmc.27.2020.12.07.08.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 08:22:30 -0800 (PST)
Date:   Mon, 7 Dec 2020 17:22:28 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH v3 net-next 1/2] ppp: add PPPIOCBRIDGECHAN and
 PPPIOCUNBRIDGECHAN ioctls
Message-ID: <20201207162228.GA28888@linux.home>
References: <20201204163656.1623-1-tparkin@katalix.com>
 <20201204163656.1623-2-tparkin@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204163656.1623-2-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 04:36:55PM +0000, Tom Parkin wrote:
> +static int ppp_unbridge_channels(struct channel *pch)
> +{
> +	struct channel *pchb, *pchbb;
> +
> +	write_lock_bh(&pch->upl);
> +	pchb = rcu_dereference_protected(pch->bridge, lockdep_is_held(&pch->upl));
> +	if (!pchb) {
> +		write_unlock_bh(&pch->upl);
> +		return -EINVAL;
> +	}
> +	RCU_INIT_POINTER(pch->bridge, NULL);
> +	write_unlock_bh(&pch->upl);
> +
> +	write_lock_bh(&pchb->upl);
> +	pchbb = rcu_dereference_protected(pchb->bridge, lockdep_is_held(&pchb->upl));
> +	if (pchbb == pch)
> +		RCU_INIT_POINTER(pchb->bridge, NULL);
> +	write_unlock_bh(&pchb->upl);
> +
> +	synchronize_rcu();
> +
> +	if (pchbb == pch)
> +		if (refcount_dec_and_test(&pch->file.refcnt))
> +			ppp_destroy_channel(pch);

Since a respin is needed (see below), maybe add a comment explaining
why we need to verify that pchbb == pch.

> +	if (refcount_dec_and_test(&pchb->file.refcnt))
> +		ppp_destroy_channel(pchb);
> +
> +	return 0;
> +}
> +
>  static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>  	struct ppp_file *pf;
> @@ -641,8 +714,9 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  	}
>  
>  	if (pf->kind == CHANNEL) {
> -		struct channel *pch;
> +		struct channel *pch, *pchb;
>  		struct ppp_channel *chan;
> +		struct ppp_net *pn;
>  
>  		pch = PF_TO_CHANNEL(pf);
>  
> @@ -657,6 +731,29 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  			err = ppp_disconnect_channel(pch);
>  			break;
>  
> +		case PPPIOCBRIDGECHAN:
> +			if (get_user(unit, p))
> +				break;
> +			err = -ENXIO;
> +			pn = ppp_pernet(current->nsproxy->net_ns);
> +			spin_lock_bh(&pn->all_channels_lock);
> +			pchb = ppp_find_channel(pn, unit);
> +			/* Hold a reference to prevent pchb being freed while
> +			 * we establish the bridge.
> +			 */
> +			if (pchb)
> +				refcount_inc(&pchb->file.refcnt);

The !pchb case isn't handled. With this code, if ppp_find_channel()
returns NULL, ppp_bridge_channels() will crash when trying to lock
pchb->upl.

> +			spin_unlock_bh(&pn->all_channels_lock);
> +			err = ppp_bridge_channels(pch, pchb);
> +			/* Drop earlier refcount now bridge establishment is complete */
> +			if (refcount_dec_and_test(&pchb->file.refcnt))
> +				ppp_destroy_channel(pchb);
> +			break;
> +

The rest looks good to me.

