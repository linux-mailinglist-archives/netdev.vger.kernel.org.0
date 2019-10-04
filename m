Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C407ECC46C
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 22:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbfJDUtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 16:49:49 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39756 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbfJDUts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 16:49:48 -0400
Received: by mail-wm1-f65.google.com with SMTP id v17so7092354wml.4
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 13:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5+yjbgrUz+HByvL/UFVEfs2BLaObx/l/UDcg1Ue+7Ak=;
        b=1bMpjDBTh0JTaIYHYLo0/TXUhdxIeDjrA5Kpy0rD9yE6oQ7mYc9MsOsWJBI04mmNYM
         kMzpRT1k472acuMpNa+Mbet+arYcs4fSSmJA/ZMjLbC0zu51+gyJu5UdofXUzNBhbZS6
         HwQBJ72pVRGmCRCxtnmZM6JN0M+4/z0Hjv5OoZGIVBuo5TXkp23pPNpI2nx/um7IOsF5
         aMgdGZw3MuHAEryZeajhEcbKS+KgiI+42NCKPrMMeTYw7nSvZiJhJgftqeRrhPiMSZw9
         Qoa9mXBccM1maNL6BM9Y2MDoGTE195b+nXt9hTntNnEO4Xce+Yw8z0UlW4imuwis2o8x
         v8XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5+yjbgrUz+HByvL/UFVEfs2BLaObx/l/UDcg1Ue+7Ak=;
        b=kDArs3OL7lZ0I6GOfdFG5NmJkr1NEcDjIhNizGspFa28RNKDhG+g5fpXwUBk4gXpg2
         dqxbRNs4M4KTaTkFOfXpu4jPbWT7/XUVW3vVOlkSKzchh1H3gAnBvXVjo7BuwKiSn2Le
         YJtyqArgbGjWOYkEZo5tdjlYEme9HKT99JjlLdYl0f/GAb+f9PLNJD75AU5NgFaZyAgf
         SrIbl6oawVKIz+rsVIO7b/z6+uko8cCJ8NmIrLdYDdM5Epz5EJUALUPukMgpWFmDj9qb
         Hi6WltNr7hR2xJd6faijgIxON0uOtVuVtytNrjm7GBjyR8dDxkJmh2gQu8/FPH/12AtE
         cgzg==
X-Gm-Message-State: APjAAAWUpthgq01pde9uE6s7msyVQwhHi8ZYg1s6b+rFnxW3r66Ft3ti
        v1TkRINlJrkw7Al2yioiZJP1Lg==
X-Google-Smtp-Source: APXvYqzP5vT66Zwm4dFb0bouAPJncFnpIUcQUMMtLopbAltNaEzCz0+XvR1nbWJY145CqZwvU+bTOQ==
X-Received: by 2002:a1c:7fcc:: with SMTP id a195mr12547174wmd.27.1570222185586;
        Fri, 04 Oct 2019 13:49:45 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v16sm6332969wrt.12.2019.10.04.13.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 13:49:45 -0700 (PDT)
Date:   Fri, 4 Oct 2019 22:49:44 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        dsahern@gmail.com, tariqt@mellanox.com, saeedm@mellanox.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, shuah@kernel.org,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v3 11/15] netdevsim: implement proper devlink
 reload
Message-ID: <20191004204944.GC2247@nanopsycho>
References: <20191003094940.9797-1-jiri@resnulli.us>
 <20191003094940.9797-12-jiri@resnulli.us>
 <20191003161730.6c61b48c@cakuba.hsd1.ca.comcast.net>
 <20191004061914.GA2264@nanopsycho>
 <20191004104217.23ec4a0d@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004104217.23ec4a0d@cakuba.hsd1.ca.comcast.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Oct 04, 2019 at 07:42:17PM CEST, jakub.kicinski@netronome.com wrote:
>On Fri, 4 Oct 2019 08:19:14 +0200, Jiri Pirko wrote:
>> >> @@ -84,20 +82,10 @@ int nsim_fib_set_max(struct nsim_fib_data *fib_data,
>> >>  		entry = &fib_data->ipv6.rules;
>> >>  		break;
>> >>  	default:
>> >> -		return 0;
>> >> -	}
>> >> -
>> >> -	/* not allowing a new max to be less than curren occupancy
>> >> -	 * --> no means of evicting entries
>> >> -	 */
>> >> -	if (val < entry->num) {
>> >> -		NL_SET_ERR_MSG_MOD(extack, "New size is less than current occupancy");
>> >> -		err = -EINVAL;  
>> >
>> >This change in behaviour should perhaps be mentioned in the commit
>> >message. The reload will no longer fail if the resources are
>> >insufficient.   
>> 
>> Reload is going to fail if the resources are insufficient. I have a
>> selftest for that, please see the last patch.
>
>Oh, because re-registering the fib notifier itself will fail? 

Yep.


>All good then, thanks.
>
>> >Since we want to test reload more widely than just for the FIB limits
>> >that does make sense to me. Is that the thinking?
