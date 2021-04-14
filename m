Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7D135F769
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbhDNPOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233624AbhDNPOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 11:14:06 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B35C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 08:13:45 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id p67so9002196pfp.10
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 08:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nrpDlB0LPWjoejIOSmQjtS9LtUgvos7LUCgbdrI/L80=;
        b=qZOfIoPGD6YUD+8u2BvH8bu/HFL0QLgVxaRzKdHBIp50j8rVNIO/7+oPKlZ9ism/T9
         HyW8EBerT1ROVskcBBYPSviWYizxO5dDFiE7WxwpXG0hDt/3ElgKkUpklcc1Vap5j50N
         yfUoFb7U4doecIqNisNRKsxRKhrAGcqYBIELW/07Iv12jKQ/i4z1JJonte9Pn4VpQT45
         HlFAxFpoEIT86SF4GpAKPktz2eRWNyqDTA0WJXIBPnVlA1kHfHllPmFd7IjsAXreBZiv
         KqVJ+VsoLznZt8MhtBQFne5zvUlVGjVE6+vx8lE5H6jXMX71Ho2+Ebwv5PSNqfZEaaEg
         KzRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nrpDlB0LPWjoejIOSmQjtS9LtUgvos7LUCgbdrI/L80=;
        b=rx2oQCfkx+OrPj+qyATCgXjxy9fBEAzSiJKWTU1OW5+U5iKLbjKdCJHgvqLG5tMDTw
         lzE/InQToXezgag8XSKeycH8HEsiC4zYZgbJRTrFpZZY0zUf+pyMkWqIXCj55eyaB6Wj
         nZUWHGZFodjOVq6zlCFLl9LfdRjtgKsKN2al+wGIuSVAysNZK38/PxRjMzc+nU/wUyJc
         oJ9WYWgSwEwNiJvc66xHMYS5OCkSmUKVlqN14UXN/qzxkfdGFmfLw331LZhNr5wwqKNG
         h0pYA6HXHi3KFxfOpNegMZwxE3dwqzllmqjuYjwhRozl7m7TjrHhP4ra7SMF/KrMCYQS
         d2Eg==
X-Gm-Message-State: AOAM531idFVPb4umu89YzLzT8VWkIMTh+FO5DzQkx7XR+s4yofMdZ4uo
        HuN+aaiXAvYAHdfx95TqXhI=
X-Google-Smtp-Source: ABdhPJyrus5+6CpaqeN6WiUoa3P4Efs8Gv4wMBXgsTnnSq5AmcgWSpIQ6Od00lKRynZxPPm6Im/rtw==
X-Received: by 2002:a63:3c9:: with SMTP id 192mr3497736pgd.423.1618413225088;
        Wed, 14 Apr 2021 08:13:45 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id x12sm1079842pfu.193.2021.04.14.08.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 08:13:44 -0700 (PDT)
Date:   Wed, 14 Apr 2021 18:13:33 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] net: bridge: propagate error code and extack
 from br_mc_disabled_update
Message-ID: <20210414151333.jvrhaesom43cwpcp@skbuf>
References: <20210414143413.1786981-1-olteanv@gmail.com>
 <3fb316d9-8ba2-78d2-ac0c-1fab5de09da8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fb316d9-8ba2-78d2-ac0c-1fab5de09da8@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 05:58:04PM +0300, Nikolay Aleksandrov wrote:
> > @@ -3607,7 +3619,7 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val)
> >  			br_multicast_leave_snoopers(br);
> >  	}
> >  
> > -	return 0;
> > +	return err;
> 
> Here won't you return EOPNOTSUPP even though everything above was successful ?
> I mean if br_mc_disabled_update() returns -EOPNOTSUPP it will just be returned
> and the caller would think there was an error.
> 
> Did you try running the bridge selftests with this patch ?
> 
> Thanks,
>  Nik

Thanks, this is a good point. I think I should just do this instead:
	if (err == -EOPNOTSUPP)
		err = 0;
	if (err)
		...

And I haven't run the bridge selftests. You are talking about:
tools/testing/selftests/net/forwarding/bridge_{igmp,mld}.sh
right?
