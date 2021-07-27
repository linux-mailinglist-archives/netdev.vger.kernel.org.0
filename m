Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453F03D796B
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 17:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236833AbhG0PK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 11:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236732AbhG0PK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 11:10:27 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61C9C061757;
        Tue, 27 Jul 2021 08:10:26 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id m2-20020a17090a71c2b0290175cf22899cso5274205pjs.2;
        Tue, 27 Jul 2021 08:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O5pEEc+xJKLuFPunFhPF3535thcf6WAhFfzevFnFf0E=;
        b=W81OQJj5ybJUEEJu00QstY2i6kdkej9Sab/6hlmX8hehNTaIrmT5y0+qQHeF1yf98u
         3sKjnqmBkWEk28kgYzSPtECOT7mku7Qv0MHD10uXxcNJn0OBQYxL1aejJ1yFTxfAl5T7
         +X/tkkeugacva/Y5DyYwlHx12TCdv5XvcOzBXYwNdPro+VrXk/Co0cy2wpI83SjF8rP0
         /ab3KFUxSA8pg6ES58Ox5JjOh2p7OAoR3KT2tqecBNfU3zcEYZphThagruejasrYAuAW
         3v3YAioeD9c8PAYjyuCnQuSWHQ+bZlXxyVkddtwJj97wECOyAxvFfa6QgybdRTeroBOz
         GFIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O5pEEc+xJKLuFPunFhPF3535thcf6WAhFfzevFnFf0E=;
        b=kAhJiG2Wi952yFgVey1mRkOlGRbPTTPLPaPcAhuMdk4zr4hKBuYo8NtB3M60cuhQoT
         VjGTZ22uLN73GEueAkq14WnoX6NJLZ1cdPOGJcDPoJisGTIG8H+5383/duHsGqwnDfVl
         IpzQuhPy8YZ9Nnz9gSJEJZLIQBIAR+UcrORvUcJxjatQWlGS4NQF6EpeV8aPPWpnuy01
         vP6+UXjOC1dEF+wDOyR/P4miQtW4p2N4CsCwAnAJmoog6IBrplsWprdhNGnOPgMVZgc4
         P+ifv8q4py8Si5JZNINm7lMfqUicabj6OIEzgqphmiuAAp1rj/drrrukwmy/2cWxdxIU
         osPw==
X-Gm-Message-State: AOAM531WRpINc01ZCVW5sBQuNcyRNiQVqsX+sCRYxFzgdCZzze+08Ygf
        od0oh3WeuGwvXNFYUY1FUqs=
X-Google-Smtp-Source: ABdhPJy1g9lNy4rrqOTQdIZYd5Jgb1Ig8OwiuA+uu3/kdOhLEHkCI6UPXWenxBhXAoIxKurki0hZCQ==
X-Received: by 2002:a17:90a:604a:: with SMTP id h10mr22738881pjm.225.1627398626316;
        Tue, 27 Jul 2021 08:10:26 -0700 (PDT)
Received: from horizon.localdomain ([177.220.174.170])
        by smtp.gmail.com with ESMTPSA id l11sm2301874pfd.187.2021.07.27.08.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 08:10:25 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id E10F7C11A2; Tue, 27 Jul 2021 12:10:22 -0300 (-03)
Date:   Tue, 27 Jul 2021 12:10:22 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Xin Long <lucien.xin@gmail.com>, carnil@debian.org
Subject: Re: [PATCH net 1/4] sctp: validate from_addr_param return
Message-ID: <YQAh3sAro23P8B77@horizon.localdomain>
References: <cover.1624904195.git.marcelo.leitner@gmail.com>
 <a8a08b7fbb0bf76377e26584682c12dd82202d2e.1624904195.git.marcelo.leitner@gmail.com>
 <YP9tZryTbUGaQQ+e@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YP9tZryTbUGaQQ+e@decadent.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 04:20:22AM +0200, Ben Hutchings wrote:
> On Mon, Jun 28, 2021 at 04:13:41PM -0300, Marcelo Ricardo Leitner wrote:
> [...]
> > @@ -1174,7 +1175,8 @@ static struct sctp_association *__sctp_rcv_asconf_lookup(
> >  	if (unlikely(!af))
> >  		return NULL;
> >  
> > -	af->from_addr_param(&paddr, param, peer_port, 0);
> > +	if (af->from_addr_param(&paddr, param, peer_port, 0))
> > +		return NULL;
> >  
> >  	return __sctp_lookup_association(net, laddr, &paddr, transportp);
> >  }
> [...]
> 
> This condition needs to be inverted, doesn't it?

Right you are. I'll send a patch today.

Thanks,
Marcelo
