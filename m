Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A593120B4
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 02:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhBGB1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 20:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhBGB1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 20:27:34 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C4CC06174A
        for <netdev@vger.kernel.org>; Sat,  6 Feb 2021 17:26:53 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id b9so19070497ejy.12
        for <netdev@vger.kernel.org>; Sat, 06 Feb 2021 17:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gyj8a7qrJz90jLCEiGyAZ0v/KQeOPqwDLjH71C9jl9U=;
        b=Y0hhH4bZWc0wugVcnQbqrpMsXHSnLvYBLtSvzYtKPJPQPrHnsoBQaSNTY0nCHUloBI
         jUXHgkZM1xgnRzcRdjSWZqLyN+eqvf0k+FHeyOKRpEwupXVNWRThfAs+6pq9Wd0ggyRI
         8a+1ABPO6NsY/ftCSfxiOYVowQMLh2KqoYE+i7XYmIDZtAY4YfYcNZnMMaDs3Mx3XIMJ
         ve1TZ0Y1on0VbtXzU06eqWrMbfN4m4sdcbLHpZYgof9T3gn7fkmfMPT5bRMHm9FwTuTM
         C8tex5bGXd7GGBY+N1g4rBENGx4oLPxTcstywaUYcC5RKsV+XLbhLEuNvh4CYMX/hsRe
         Dh4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gyj8a7qrJz90jLCEiGyAZ0v/KQeOPqwDLjH71C9jl9U=;
        b=TeeOsXycvp74Ggp3LqjYPSoXy3F+lNkXebsGa54TGHgUmDtzg8yAEGapljEW9XA+/x
         vGmaRB78gNWaqMG2TDXWYiyMN7J/6kzIdIP2df21WNzo9p6nOYFmqTwlmLEgBUjhxFh6
         ta0nN/4PM0qBU4vOnHpxFXRc4fjaKx0JIdptjUhf+5koS578fxkZkHdMWiowGRfPaUlh
         GVhZXMISWGF04p4SbQ6AxRg4hQuyHVrm26GM5V6W+a6SULp3+YCeXtNaFwi541PyZwjf
         aONXvw3Ui6BvtZf8P2naRtANWrJ2S+ACh8fQ96gyAYk97wgvxJq8IGGeU4jqmEGCtt58
         xfbQ==
X-Gm-Message-State: AOAM530T5WUeeHmrpQV6YDqRSVzlFQw+fnb0GF7sCT2rmbfvEkDmlVVy
        bWOqZzq0YQI8iomj8MvH+l0=
X-Google-Smtp-Source: ABdhPJz6ENIyy6IWtcgXqwto8BE6JduY7Ff8gyRuN5B4pCk3DFGwm8hisPHZT8DSttara5EWgpJXMQ==
X-Received: by 2002:a17:906:2d0:: with SMTP id 16mr11188154ejk.373.1612661212111;
        Sat, 06 Feb 2021 17:26:52 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k26sm6685867eds.41.2021.02.06.17.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Feb 2021 17:26:51 -0800 (PST)
Date:   Sun, 7 Feb 2021 03:26:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/4] net: hsr: generate supervision frame
 without HSR/PRP tag
Message-ID: <20210207012650.ewehcarai3tep5xa@skbuf>
References: <20210204215926.64377-1-george.mccollister@gmail.com>
 <20210204215926.64377-2-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204215926.64377-2-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 03:59:23PM -0600, George McCollister wrote:
> @@ -289,23 +286,12 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
>  		hsr->announce_count++;
>  	}
>  
> -	if (!hsr->prot_version)
> -		proto = ETH_P_PRP;
> -	else
> -		proto = ETH_P_HSR;
> -
> -	skb = hsr_init_skb(master, proto);
> +	skb = hsr_init_skb(master, ETH_P_PRP);
>  	if (!skb) {
>  		WARN_ONCE(1, "HSR: Could not send supervision frame\n");
>  		return;
>  	}

I wonder why you aren't even more aggressive, just remove the proto
argument from hsr_init_skb and delay setting skb->protocol to
hsr_fill_tag or the whereabouts. This is probably also more correct
since as far as I can see, nobody is updating the skb->proto of
supervision frames from HSR v0 to v1 after your change.
