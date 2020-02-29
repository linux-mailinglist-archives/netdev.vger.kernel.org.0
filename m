Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6C51174586
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 08:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgB2HkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 02:40:10 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39792 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgB2HkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 02:40:10 -0500
Received: by mail-wm1-f66.google.com with SMTP id c84so5732911wme.4
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 23:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rLmUIYkhANYVwW9T8NdrOJvFHT5x96ctHk3w7LpE4r8=;
        b=ro3VTaQUOTrlUVnIVmDVDqWAAT5+yCVTkTRJB2J+9wFj8uJhGsPAmUJRa36KkMKZJt
         6T2haE2MkFE6/2HRNMEYqQHJ9qNKPEFO5svc3kwoe4QlNet7FY0pgqCRBqWfHilgL1eM
         Fidov6727TRUxvFQiEJ7ikCXM4QdnYugwcjT5VFjWsczgcJbHdJj8hS0xO7+JDD0mJVo
         HabtRmyprTclfrwkYjyFu+xv+A5OJVqcvEc/LHIVnDNeqAVP1gLczzPIFU+SGT6G+UcW
         UhfGWXHM3WqS1GzeI6sQZdTDB5xsHC39Cm40aivtVxFZLdh/b73P08UJpIhtV8FKXi2L
         KhKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rLmUIYkhANYVwW9T8NdrOJvFHT5x96ctHk3w7LpE4r8=;
        b=c7WAT8h5u3NJz2B9dAwroWuFBmKGNfrwaaLJRQHxB3eDK3IJpXpufb2ZMjjNOL2xSA
         inQJ1TqxQh7Rl7WYzi9J30y+ToT/SeeD1atA9Yc3RGqbPGleRJ9b0QatqknDy0lybRBB
         jVgMQmNE8CDTbcHj/7GYS7C9jIo7S0V4gI6FOxAuQq8LxJwPfE9eWofNRrTAB5GWPU92
         kTYZp3/g+Z9f5WQ8/icMiAuFK+9OwJ5/hhccAbpcMViTknB4lI0TE6YpfUFm3aKG5z27
         XK1NymrFXPrHPUAWbDVRKJTEtil5YFGLqEfbyn+B0i/lfGZpljrfF8CTgfQZtmxgpafk
         7M4w==
X-Gm-Message-State: APjAAAXsR35wgQ2SzPOjoylUsQoNL25P/VvpG4/bEZkAtgux2cmE/J/8
        Vdm0fv+OXe9+PPNHSfg7BZrf6w==
X-Google-Smtp-Source: APXvYqxR2NY6LMLIbf45ezAAwxL76TtbDd+ILrXvRkiHvssr4nFhM/rIs7bqoiPO5OIBEL8bUQ7Ymg==
X-Received: by 2002:a1c:1d15:: with SMTP id d21mr6924328wmd.101.1582962007020;
        Fri, 28 Feb 2020 23:40:07 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id c8sm5997781wru.7.2020.02.28.23.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 23:40:06 -0800 (PST)
Date:   Sat, 29 Feb 2020 08:40:04 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 03/12] flow_offload: check for basic action
 hw stats type
Message-ID: <20200229074004.GL26061@nanopsycho>
References: <20200228172505.14386-1-jiri@resnulli.us>
 <20200228172505.14386-4-jiri@resnulli.us>
 <20200228114056.5bc06ad2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228114056.5bc06ad2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 28, 2020 at 08:40:56PM CET, kuba@kernel.org wrote:
>On Fri, 28 Feb 2020 18:24:56 +0100 Jiri Pirko wrote:
>> @@ -299,6 +300,9 @@ static int bnxt_tc_parse_actions(struct bnxt *bp,
>>  		return -EINVAL;
>>  	}
>>  
>> +	if (!flow_action_basic_hw_stats_types_check(flow_action, extack))
>> +		return -EOPNOTSUPP;
>
>Could we have this helper take one stat type? To let drivers pass the
>stat type they support? 

That would be always "any" as "any" is supported by all drivers.
And that is exactly what the helper checks..


>
>At some point we should come up with a way to express the limitations
>at callback registration time so we don't need to add checks like this
>to all the drivers. On the TODO list it goes :)

I was thinking about that. Not really easy with the currect infra.

>
>>  	flow_action_for_each(i, act, flow_action) {
>>  		switch (act->id) {
>>  		case FLOW_ACTION_DROP:
>
