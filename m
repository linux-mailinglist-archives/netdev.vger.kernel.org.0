Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6E43966B1
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 19:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbhEaRRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 13:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233480AbhEaRPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 13:15:43 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63606C0611EB;
        Mon, 31 May 2021 08:29:07 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id k22-20020a17090aef16b0290163512accedso128947pjz.0;
        Mon, 31 May 2021 08:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R3ERwvWAJQeMnwLML6I5CNggHBvI3ijt6irwEhA0CSU=;
        b=ZjcWRA2zVVf2u39IwROdRm+73SIR4lpLX33ihPFpccyUmmwKGXuEURi0bGu4ChqTds
         qbWYG7Ryuo/jLZeeXHauSo899ebOPGJ9UIr2EkiM//zBZcok6/ELX79M6ZqIdWEksGOV
         lSuljF4vJqYpWRlmsJB2tMuqpqgxVajKZO/q3dLh/26/ghOonKlPwxqxSJ7ZkJFdA1cR
         C2zlYiuSeJ5EKIsIqhq0Ww3jwn+xPLMNrjEJy4r+fbqgBXQWk7HkSpfAJJPvp1/BztMK
         /Ze895BJAIxsRCi3pGceCSh/CP6Nql9so5EzCN93ySHKrawSCQgjdiqOnqu5AJEaFHVP
         /GUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R3ERwvWAJQeMnwLML6I5CNggHBvI3ijt6irwEhA0CSU=;
        b=UEIB1Lty8JBvtPbqWmBG3dRXo513wC5cdFIpiBt2uMuLo7phjm3p5V8vcZX0e6hn72
         GJnwJQP/ClCIRiED4+LY9FjgEsAiV+hkVLesHAJv7fOtuNOZtC08+nOG3hY8rDfxJ7YT
         FrU/QhW0Zo8sDVAxcVOxQELw1rcLljlrApZugezXnFDW9qK09muTlsubz0WmEiUZxmxu
         bQ2Yo4aGXybNyIxrfMTJWKJ9uZgNtIj8w1OCwjkt0QzORrqU78c5VzpqC7KZB8eDnDz7
         wCxAc8/+LTrxRlPjuTLXNoAfdaL4ZHek4hb8i/5lZtHwqKBbEUJX6KWsBvuPspXg1ok+
         g3ug==
X-Gm-Message-State: AOAM532COuGdn0j1MPjtacfmVK+/AzKTPcFs/g0sYJ4lYiqz9U0rhOtL
        fQXlJVoXBNKAA+I3i0SyjsI=
X-Google-Smtp-Source: ABdhPJxzmBuYkOtFsW5fXmvfOuELbxqIAdDR2FQ12ZJ1ILKtDC6SzoIpta8D6y5gWAqw7OkY0VqRHA==
X-Received: by 2002:a17:903:2482:b029:fd:696c:1d2b with SMTP id p2-20020a1709032482b02900fd696c1d2bmr21292801plw.24.1622474946893;
        Mon, 31 May 2021 08:29:06 -0700 (PDT)
Received: from mail.google.com ([141.164.41.4])
        by smtp.gmail.com with ESMTPSA id t13sm4319859pfh.97.2021.05.31.08.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 08:29:06 -0700 (PDT)
Date:   Mon, 31 May 2021 23:28:58 +0800
From:   Changbin Du <changbin.du@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Changbin Du <changbin.du@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] net: fix oops in socket ioctl cmd SIOCGSKNS when NET_NS
 is disabled
Message-ID: <20210531152858.nz2orstfcm2bwvjr@mail.google.com>
References: <20210529060526.422987-1-changbin.du@gmail.com>
 <20210529112735.22bdc153@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210529112735.22bdc153@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 29, 2021 at 11:27:35AM -0700, Jakub Kicinski wrote:
> On Sat, 29 May 2021 14:05:26 +0800 Changbin Du wrote:
> > When NET_NS is not enabled, socket ioctl cmd SIOCGSKNS should do nothing
> > but acknowledge userspace it is not supported. Otherwise, kernel would
> > panic wherever nsfs trys to access ns->ops since the proc_ns_operations
> > is not implemented in this case.
> > 
> > [7.670023] Unable to handle kernel NULL pointer dereference at virtual address 00000010
> > [7.670268] pgd = 32b54000
> > [7.670544] [00000010] *pgd=00000000
> > [7.671861] Internal error: Oops: 5 [#1] SMP ARM
> > [7.672315] Modules linked in:
> > [7.672918] CPU: 0 PID: 1 Comm: systemd Not tainted 5.13.0-rc3-00375-g6799d4f2da49 #16
> > [7.673309] Hardware name: Generic DT based system
> > [7.673642] PC is at nsfs_evict+0x24/0x30
> > [7.674486] LR is at clear_inode+0x20/0x9c
> > 
> > Signed-off-by: Changbin Du <changbin.du@gmail.com>
> > Cc: <stable@vger.kernel.org> # v4.9
> 
> Please provide a Fixes tag.
>
Now it will be fixed by nsfs side. And the code has been changed to many times..

> > diff --git a/net/socket.c b/net/socket.c
> > index 27e3e7d53f8e..644b46112d35 100644
> > --- a/net/socket.c
> > +++ b/net/socket.c
> > @@ -1149,11 +1149,15 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
> >  			mutex_unlock(&vlan_ioctl_mutex);
> >  			break;
> >  		case SIOCGSKNS:
> > +#ifdef CONFIG_NET_NS
> >  			err = -EPERM;
> >  			if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
> >  				break;
> >  
> >  			err = open_related_ns(&net->ns, get_net_ns);
> 
> There's a few more places with this exact code. Can we please add the
> check in get_net_ns? That should fix all callers.
> 
> > +#else
> > +			err = -ENOTSUPP;
> 
> EOPNOTSUPP, you shouldn't return ENOTSUPP to user space.
>
Thanks for pointing out. Will change it.

> > +#endif
> >  			break;
> >  		case SIOCGSTAMP_OLD:
> >  		case SIOCGSTAMPNS_OLD:
> 

-- 
Cheers,
Changbin Du
