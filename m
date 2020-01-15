Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8066B13C444
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730297AbgAON4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:56:38 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38480 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729604AbgAON4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 08:56:36 -0500
Received: by mail-wr1-f66.google.com with SMTP id y17so15849471wrh.5;
        Wed, 15 Jan 2020 05:56:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UVc+vS25sl77DRieZ7fqDsmqFprVJrI4fDKBKV1QbSs=;
        b=LRpnvGdzzWtUwKgyeGcGGN7KeOpl9e8FWnHjZMCHy6xvS2RmAld9JGtTRK5wpmr4Wr
         f+68izFS//Rwjzy2ijVLI7F7bdxenZkGhvqP2Pe4MqZ5x0t4yCahrso4U28zqIMkRHMr
         giavbBMV6yGFzf1LwFPQodHd5TaIXwJXkXp2iK6EZCjSETdMAyJLSqtfj+r97j8if8QQ
         04zYn5zghbhZQ9g+Wu2QGrm63urnz2NEK8ylxGcqCUXkT3O/lIP+3clkdHSv28fyrZJp
         kZS9E5BlRlN2sbrVS0vfRTMpLfhaTbICuYtHl4FjQ0oYUeHnAPac/0t+6ohMCIqy3LRR
         wFlA==
X-Gm-Message-State: APjAAAVASCXfzYEd7FJv3jD/qPlXT8DRKTyNg63woSkDC9kGsI6iAr7O
        GAMMPu0gBJCewGcRHZZDX3w=
X-Google-Smtp-Source: APXvYqyXYe4s0+Dcy7oHJR4GBgwa+hNOEdtdbuIIeeHe/ERVxkCyU9BEoy570XvbPj01KdjYPiKSMQ==
X-Received: by 2002:adf:df90:: with SMTP id z16mr33198153wrl.273.1579096594676;
        Wed, 15 Jan 2020 05:56:34 -0800 (PST)
Received: from debian (41.142.6.51.dyn.plus.net. [51.6.142.41])
        by smtp.gmail.com with ESMTPSA id r6sm25367610wrq.92.2020.01.15.05.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 05:56:33 -0800 (PST)
Date:   Wed, 15 Jan 2020 13:56:31 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     madhuparnabhowmik04@gmail.com
Cc:     wei.liu@kernel.org, paul@xen.org, davem@davemloft.net,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, paulmck@kernel.org,
        joel@joelfernandes.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] net: xen-netbank: hash.c: Use built-in RCU list checking
Message-ID: <20200115135631.edr2nrfkycppxcku@debian>
References: <20200115124129.5684-1-madhuparnabhowmik04@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115124129.5684-1-madhuparnabhowmik04@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the patch.

There is a typo in the subject line. It should say xen-netback, not
xen-netbank.

On Wed, Jan 15, 2020 at 06:11:28PM +0530, madhuparnabhowmik04@gmail.com wrote:
> From: Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>
> 
> list_for_each_entry_rcu has built-in RCU and lock checking.
> Pass cond argument to list_for_each_entry_rcu.
> 
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>
> ---
>  drivers/net/xen-netback/hash.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/xen-netback/hash.c b/drivers/net/xen-netback/hash.c
> index 10d580c3dea3..30709bc9d170 100644
> --- a/drivers/net/xen-netback/hash.c
> +++ b/drivers/net/xen-netback/hash.c
> @@ -51,7 +51,8 @@ static void xenvif_add_hash(struct xenvif *vif, const u8 *tag,
>  
>  	found = false;
>  	oldest = NULL;
> -	list_for_each_entry_rcu(entry, &vif->hash.cache.list, link) {
> +	list_for_each_entry_rcu(entry, &vif->hash.cache.list, link,
> +							lockdep_is_held(&vif->hash.cache.lock)) {

There are probably too many tabs here. Indentation looks wrong.

The surrounding code makes it pretty clear that the lock is already held
by the time list_for_each_entry_rcu is called, yet the checking involved
in lockdep_is_held is not trivial, so I'm afraid I don't consider this a
strict improvement over the existing code.

If there is something I misunderstood, let me know.

Wei.

>  		/* Make sure we don't add duplicate entries */
>  		if (entry->len == len &&
>  		    memcmp(entry->tag, tag, len) == 0)
> @@ -102,7 +103,8 @@ static void xenvif_flush_hash(struct xenvif *vif)
>  
>  	spin_lock_irqsave(&vif->hash.cache.lock, flags);
>  
> -	list_for_each_entry_rcu(entry, &vif->hash.cache.list, link) {
> +	list_for_each_entry_rcu(entry, &vif->hash.cache.list, link,
> +							lockdep_is_held(&vif->hash.cache.lock)) {
>  		list_del_rcu(&entry->link);
>  		vif->hash.cache.count--;
>  		kfree_rcu(entry, rcu);
> -- 
> 2.17.1
> 
