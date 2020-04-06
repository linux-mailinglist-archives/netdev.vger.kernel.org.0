Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4224F19F095
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 09:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgDFHG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 03:06:26 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:35848 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgDFHGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 03:06:25 -0400
Received: by mail-pj1-f68.google.com with SMTP id nu11so6064516pjb.1;
        Mon, 06 Apr 2020 00:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RqJfBxc+5hEXzJUkSWB0gPw7NrIyI3K3Pr3732qHYAQ=;
        b=fUl+6I4x7XwQcdmoCTE2Z0XeWKNZEAvwwQhxESe8sRcEQ6vn+AfhNO23bXM8aiWdRe
         wVnHoSlX0U3b04JnkGrI5Ay7r0HfzNA0pKXN6fKs/gP6RV4tnDNoiDyKyGKhADiOl43n
         F+mF6OdX/tADPC9HmEUR2PJJhzbFPdsXHduQuuFTWnIM3HbbkxMv3OvuJKYbTAl42H8N
         1djGWbVFtbtxKYMtodVAdgw7d1ViLwhPqusfpHjBZmhP8Wby1fHN6KWDj01D0FRMHbs2
         40LctGPDNwQdiPuTkW3RvZYYmwy5GjBoAHY3eo1S34N7o4Y+/bM9ACEMqEVOAq1Y+/ZZ
         d+Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RqJfBxc+5hEXzJUkSWB0gPw7NrIyI3K3Pr3732qHYAQ=;
        b=GCOKNDwRQ6oPwdsISBwc3Ccs2EyJR0gJjOeSzMRphCCQxoQqy6U3mLimza2FQ1i9PY
         Bs0qzgOGKuUM+XbjwPaFoUmsxW7+OKCbf+7ELoJOMA7gr9HrdszmqHB1EQaOVbC1BpcP
         fImoGj0VdvYj4w3TCJh7zsRq4RhKH5/tCOeYrZ8jGtnZia4Bo2yUVpyXYVu5jgUN/PxO
         jc8K+9enhl/4BmWOUd9dkmCxBzDYiAaFb9mwQEt7Lt7ENM5BTj8yaeC+GbMYxtLd9Ubx
         lMjivOwNlL4aIm1LCbeQgHBYTbJcryybWFSyygoBvDLAOFsgecIGyzlLncSWaCbaXrJr
         +k1Q==
X-Gm-Message-State: AGi0PubBiffcWLft+F3M/nvSKrBEaHC7eXxnmtFmyQOM6+JF3Q+ot2uQ
        wH+7yzLxRa1z+EQLLfx0svI=
X-Google-Smtp-Source: APiQypKNbF2E3D32XKuBDPJhhlvxxo8J2rW27s0dKvSTxEZx7hANy5tViHe3jOKRRTeN/AfHY6j/Qg==
X-Received: by 2002:a17:902:507:: with SMTP id 7mr19209367plf.42.1586156784681;
        Mon, 06 Apr 2020 00:06:24 -0700 (PDT)
Received: from workstation-LAP.localdomain ([103.87.57.178])
        by smtp.gmail.com with ESMTPSA id m2sm11318884pjk.4.2020.04.06.00.06.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 Apr 2020 00:06:23 -0700 (PDT)
Date:   Mon, 6 Apr 2020 12:36:12 +0530
From:   Amol Grover <frextrite@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Sowden <jeremy@azazel.net>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH] netfilter: ipset: Pass lockdep expression to RCU lists
Message-ID: <20200406070612.GA240@workstation-LAP.localdomain>
References: <20200216172653.19772-1-frextrite@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200216172653.19772-1-frextrite@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 16, 2020 at 10:56:54PM +0530, Amol Grover wrote:
> ip_set_type_list is traversed using list_for_each_entry_rcu
> outside an RCU read-side critical section but under the protection
> of ip_set_type_mutex.
> 
> Hence, add corresponding lockdep expression to silence false-positive
> warnings, and harden RCU lists.
> 
> Signed-off-by: Amol Grover <frextrite@gmail.com>
> ---

Hi David

Could you please go through this patch aswell? This patch was directed to 
preemptively fix the _suspicious RCU usage_ warning which is now also
being reported by Kernel Test Robot.

[   11.654186] =============================
[   11.654619] WARNING: suspicious RCU usage
[   11.655022] 5.6.0-rc1-00179-gdb4ead2cd5253 #1 Not tainted
[   11.655583] -----------------------------
[   11.656001] net/netfilter/ipset/ip_set_core.c:89 RCU-list traversed in non-reader section!!

Thanks
Amol

>  net/netfilter/ipset/ip_set_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index cf895bc80871..97c851589160 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -86,7 +86,8 @@ find_set_type(const char *name, u8 family, u8 revision)
>  {
>  	struct ip_set_type *type;
>  
> -	list_for_each_entry_rcu(type, &ip_set_type_list, list)
> +	list_for_each_entry_rcu(type, &ip_set_type_list, list,
> +				lockdep_is_held(&ip_set_type_mutex))
>  		if (STRNCMP(type->name, name) &&
>  		    (type->family == family ||
>  		     type->family == NFPROTO_UNSPEC) &&
> -- 
> 2.24.1
> 
