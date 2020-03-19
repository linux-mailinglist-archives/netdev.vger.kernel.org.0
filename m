Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 725AB18BC49
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgCSQTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:19:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53318 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727577AbgCSQTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:19:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=23UqYLRMpftpoKbes/7QsgpYVn5GfTKm7hb6ThuIFwk=; b=K59F+LP+Kwj26WoYtgbUmIFUWS
        tuU6Z1zb5c6xo7u/9kuIY6g+/bZREqKR40koQIFwN/bi7ash6fD+Jk2KA4k7qnvIs/2vNZQVKNEWZ
        eY+P1lFx8NfSeuzprlWyi9CBKtrWSPU4bi7iwCgC7Qmy1Ve6EUnZrwcIz3r+2N2Hf2v8o7DRERIiL
        hg/rT3Y2rp6m38WJVu64apzcIZcr6SQC8OwCClNmXKc4oPojdNa3B0C7q7Ueswq0N5D29Qzi0jie8
        IF17/ki1uRXBfwgvn/dcVYVd7+YBLwecUoKOmAYUUHfH3Ol776kOV7454TU8CqvbIVkrBanAn1uWw
        +maT9EkQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jExtc-0003Ka-V1; Thu, 19 Mar 2020 16:19:50 +0000
Subject: Re: [PATCH net-next] sysfs: fix static inline declaration of
 sysfs_groups_change_owner()
To:     Christian Brauner <christian.brauner@ubuntu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <20200319142002.7382ed70@canb.auug.org.au>
 <20200319144741.3864191-1-christian.brauner@ubuntu.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <7a5e3c76-ffc0-8086-1726-b0c9a32dc96a@infradead.org>
Date:   Thu, 19 Mar 2020 09:19:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200319144741.3864191-1-christian.brauner@ubuntu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/20 7:47 AM, Christian Brauner wrote:
> The CONFIG_SYSFS declaration of sysfs_group_change_owner() is different
> from the !CONFIG_SYSFS version and thus causes build failurs when
> !CONFIG_SYSFS is set.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

> Fixes: 303a42769c4c ("sysfs: add sysfs_group{s}_change_owner()")
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>

Thanks.

> ---
>  include/linux/sysfs.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
> index 9e531ec76274..4beb51009b62 100644
> --- a/include/linux/sysfs.h
> +++ b/include/linux/sysfs.h
> @@ -562,8 +562,8 @@ static inline int sysfs_groups_change_owner(struct kobject *kobj,
>  }
>  
>  static inline int sysfs_group_change_owner(struct kobject *kobj,
> -			 const struct attribute_group **groups,
> -			 kuid_t kuid, kgid_t kgid)
> +					   const struct attribute_group *groups,
> +					   kuid_t kuid, kgid_t kgid)
>  {
>  	return 0;
>  }
> 
> base-commit: 79e28519ac78dde6d38fe6ea22286af574f5c7db
> 


-- 
~Randy
