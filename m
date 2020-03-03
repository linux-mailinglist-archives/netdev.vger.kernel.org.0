Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBBA177571
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 12:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbgCCLq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 06:46:28 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40907 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728997AbgCCLq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 06:46:28 -0500
Received: by mail-wm1-f67.google.com with SMTP id e26so2497067wme.5
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 03:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=carX5VpQZmZNR92ZkzmN/ZXGs+EEpl2dynQkv22p/9E=;
        b=y266v6izx6pdCz4govWw6abt2tsLvVLAezD16JN4jAYxfysHPhLxcXZOtpEVezzMrf
         /0urW8GKqBYJV5j5MPum5i2NJoBNsPMi2z987FzxHNDXawc94+TTsHSGr2GuIwIDjpzH
         BVVoBEf2+Y2csMtZ8K0M379LnDN2IheDz2C/XrVBoedcbWJE6uRoOTmQNOwxDZMi40Z2
         iRx/VQGlxVTwCOSuDGGgKcYhNikT1nac0ekjdsMLe2ukh27+LkzD7ka0K8q1sRhBEMmz
         59Y79w2u9DXnbO+zK4UPwsP8YYkZ5CEqiI4AQ4FsaH8pMzPoWWZfuMms9WgKkqcEOzRG
         iwdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=carX5VpQZmZNR92ZkzmN/ZXGs+EEpl2dynQkv22p/9E=;
        b=K1rm0T1XPQY8CnqRGiKkzYA0S0CKW/RawtJ6+Rh9Xm+Io1pwpkuwCJYzgPhj09ZTE+
         GOBuRC0jF4NobbOqHULxq7m8bIgy8hRhEZ+RDvFkxUVcMemImKnrc+UrGtsnWQcoT4Xr
         cvHPekCzwSanzIvN3EE/SpIiyk/LS68ejyysb3DHh5u+4MkTboF8SsOgmp3BKtlcFmJG
         LTM0+UUkzztPJUc4GAm2ICgUPBmDiaU09scIEelJhzgyyya/xmlsyuAG97S9JwcKOADP
         6ohk54mxzXmWVaLFEBTp+bKASaVO0hB2TFGBKN3hL8ZGzpj9vJ9BN0o7df8uix7uLZOQ
         AUwg==
X-Gm-Message-State: ANhLgQ1rSqrr22rkOiQ51SYB7bd8JV4wRKKOrm5hNSb3BrSeGGemshCb
        4+e9dtDHXnkb+mJRWnZkPrupgQ==
X-Google-Smtp-Source: ADFU+vvh70vz5xN6Fh4fDo+RQtivopt0Tol+VnLnBtULqcN8qw5y/gP66lId4kJno/QPBeyW8Ac68g==
X-Received: by 2002:a05:600c:581:: with SMTP id o1mr1722712wmd.8.1583235985684;
        Tue, 03 Mar 2020 03:46:25 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id g10sm34730513wrr.13.2020.03.03.03.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 03:46:24 -0800 (PST)
Date:   Tue, 3 Mar 2020 12:46:24 +0100
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
Message-ID: <20200303114624.GG2178@nanopsycho>
References: <20200228172505.14386-1-jiri@resnulli.us>
 <20200228172505.14386-4-jiri@resnulli.us>
 <20200228114056.5bc06ad2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200229074004.GL26061@nanopsycho>
 <20200229111848.53450ff1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200301090009.GT26061@nanopsycho>
 <20200302113319.22fb0cb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302113319.22fb0cb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 02, 2020 at 08:33:19PM CET, kuba@kernel.org wrote:
>On Sun, 1 Mar 2020 10:00:09 +0100 Jiri Pirko wrote:
>> Sat, Feb 29, 2020 at 08:18:48PM CET, kuba@kernel.org wrote:
>> >On Sat, 29 Feb 2020 08:40:04 +0100 Jiri Pirko wrote:  
>> >> Fri, Feb 28, 2020 at 08:40:56PM CET, kuba@kernel.org wrote:  
>> >> >On Fri, 28 Feb 2020 18:24:56 +0100 Jiri Pirko wrote:    
>> >> >> @@ -299,6 +300,9 @@ static int bnxt_tc_parse_actions(struct bnxt *bp,
>> >> >>  		return -EINVAL;
>> >> >>  	}
>> >> >>  
>> >> >> +	if (!flow_action_basic_hw_stats_types_check(flow_action, extack))
>> >> >> +		return -EOPNOTSUPP;    
>> >> >
>> >> >Could we have this helper take one stat type? To let drivers pass the
>> >> >stat type they support?     
>> >> 
>> >> That would be always "any" as "any" is supported by all drivers.
>> >> And that is exactly what the helper checks..  
>> >
>> >I'd think most drivers implement some form of DELAYED today, 'cause for
>> >the number of flows things like OvS need that's the only practical one.
>> >I was thinking to let drivers pass DELAYED here.
>> >
>> >I agree that your patch would most likely pass ANY in almost all cases
>> >as you shouldn't be expected to know all the drivers, but at least the
>> >maintainers can easily just tweak the parameter.
>> >
>> >Does that make sense? Maybe I'm missing something.  
>> 
>> Well, I guess. mlx5 only supports "delayed". It would work for it.
>> How about having flow_action_basic_hw_stats_types_check() as is and
>> add flow_action_basic_hw_stats_types_check_ext() that would accept extra
>> arg with enum?
>
>SGTM, perhaps with a more concise name? 
>Just flow_basic_hw_stats_check()?

Will try :)

