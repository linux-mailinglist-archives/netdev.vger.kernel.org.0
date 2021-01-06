Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859B52EC172
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 17:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbhAFQt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 11:49:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59759 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725800AbhAFQt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 11:49:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609951711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HwlZfpT5mZHefTaSAm2gk61cZxN7ZFymYA2HQi89GZA=;
        b=Pkz+V/KTe5oUUtaRCEhPxRkZkOKTJgxY7RUKiJvjy12wk5tMNymUifF8DtkDlz02a48D9r
        Bir/RIrtL86mAPrrOwLnsZLYGJczUHVNQ7znGH6thzu2FAF88B0hp9edmEJsw05WxdQmeu
        TMXiZWvSlgCKYJyFrzEQ0gEVylTDv14=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-ovjw37mRMYaLIOvn1C5lCg-1; Wed, 06 Jan 2021 11:48:29 -0500
X-MC-Unique: ovjw37mRMYaLIOvn1C5lCg-1
Received: by mail-wm1-f70.google.com with SMTP id g82so1490232wmg.6
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 08:48:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HwlZfpT5mZHefTaSAm2gk61cZxN7ZFymYA2HQi89GZA=;
        b=C2adNX8MH72YNmligXmOzuzLe0RylQbuTkxeW0MwZarLvs8a3AME2ZeV/JgI9RxRn9
         9w3k6zwY/1Y5W618klV25/ku2JfsqCnoM6cOhl/mIS+RkgcEqZTcH/wj+CRusUIvWbXX
         N178lQua9D/5Vh8RukkPI9GSKIiUKY+Xsl43RlBCnoQSNX2uUcqrFkWNxPjWLBFC4XqN
         nL878XyGQdEbA229BG5xPOCUVOxrMPVqmVBi681EXgRb3FJi6vJOsQ1v9JRWoL+69lLa
         cAZVBZ7RR3SuU8H067QyZdFTRSbCNFgsqPYU2j8tjTJhjrOWrtbJ+V3MzVd5S3ykstsL
         OxPw==
X-Gm-Message-State: AOAM533LbedYvF4ebguoxYXRB9ReORMj3Mfz09/r7TddTXdDhEtxCvsg
        prEIJid1GWP+mZhlJzQZSmWuQwksD102uHhx1xDy4ue5cU81fAzWVkUaIvc0mMbQlUABfpndiGM
        B2ZrCt9I/zLcEur0X
X-Received: by 2002:a05:6000:11c1:: with SMTP id i1mr5201902wrx.16.1609951708008;
        Wed, 06 Jan 2021 08:48:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwhwWV97SZK6rpgjEZk+tVArUfCaglYhe9hA2yMVELZHaM151HlxIQfF9sO2dDg8CVpe1l6Sg==
X-Received: by 2002:a05:6000:11c1:: with SMTP id i1mr5201887wrx.16.1609951707829;
        Wed, 06 Jan 2021 08:48:27 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id h14sm3867141wrx.37.2021.01.06.08.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 08:48:27 -0800 (PST)
Date:   Wed, 6 Jan 2021 17:48:25 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH] ppp: fix refcount underflow on channel unbridge
Message-ID: <20210106164825.GA7058@linux.home>
References: <20210105211743.8404-1-tparkin@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105211743.8404-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 09:17:43PM +0000, Tom Parkin wrote:
>  err_unset:
>  	write_lock_bh(&pch->upl);
> -	RCU_INIT_POINTER(pch->bridge, NULL);
> +	/* Re-check pch->bridge with upl held since a racing unbridge might already
> +	 * have cleared it and dropped the reference on pch->bridge.
> +	 */
> +	if (rcu_dereference_protected(pch->bridge, lockdep_is_held(&pch->upl))) {
> +		RCU_INIT_POINTER(pch->bridge, NULL);
> +		drop_ref = true;
> +	}
>  	write_unlock_bh(&pch->upl);
>  	synchronize_rcu();
> +
> +	if (drop_ref)
> +		if (refcount_dec_and_test(&pchb->file.refcnt))
> +			ppp_destroy_channel(pchb);
> +

I think this works because ppp_mutex prevents pch->bridge from being
reassigned to another channel. However, this isn't obvious when reading
the code, and well, I prefer to not introduce new dependencies on
ppp_mutex (otherwise we'd better go with your original patch).

I think we could just save pch->bridge while we're under ->upl
protection, and then drop the reference of that channel (if non-NULL):

 err_unset:
 	write_lock_bh(&pch->upl);
+	/* Re-read pch->bridge in case it was modified concurrently */
+	pchb = rcu_dereference_protected(pch->bridge,
+					 lockdep_is_held(&pch->upl));
+	RCU_INIT_POINTER(pch->bridge, NULL);
 	write_unlock_bh(&pch->upl);
 	synchronize_rcu();
+
+	if (pchb)
+		if (refcount_dec_and_test(&pchb->file.refcnt))
+			ppp_destroy_channel(pchb);
+

 	return -EALREADY;
 }

This way we know that pchb is the channel we were pointing to when we
cleared pch->bridge. And this is also a bit simpler than using an extra
boolean.

