Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F245EF781
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 16:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbiI2O2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 10:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234453AbiI2O1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 10:27:53 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A12264AE
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:27:51 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id c11so2463175wrp.11
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date;
        bh=71nCcPMaeT0M5JDZNHMg8UzSZT3YmZG9QviWI8mlRAw=;
        b=AaTKvLETfOYA/zchEh1plybDWzi5t6ckZNrH/07Kk/ZxCzuzkg/q38jeUhyNUhJRtJ
         Adw4aJ3j8WaUx+Tdvtcrrm5p+nA40WRy+pw2lyN180iq8rLWQnL42XIPthfZrJoC5cIK
         +5e3kPmxPxKcOScBMOVtJAhXeKjFo7r5sr9gbOBQ1a5wmU4ywoSQGH+sFmfUplR/Oox8
         dGwXgQILi/Nb6LepREVANFPM/REj68jd4NLoN2CP9ZlNL6nBL8JQLkASNHFjuRG5oGsd
         lIFxpF8hM8wczNml8SNOlMe9kYAB1g3JMGOvxPIjq+uvufHPsq6jjWGLhem7F3JE6PVJ
         OHPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=71nCcPMaeT0M5JDZNHMg8UzSZT3YmZG9QviWI8mlRAw=;
        b=g/+F/4+YazKsOhYEMYtQzCGEBG9LG4S5OXJFswYvcxElMqF2K1APG8lnqPa4S7pM01
         625gKQCsnmfQEb5C3st8KGAA4VZR2aOWhXZ37D/6w6QL1DrzpbnTVb/WdqhIX8qPEPji
         RYSPx7AJVvw+upnNFZAXft26HaCJtve3FxcUE8PWoJ8FixDK67IaU2x8+NhTskYcqG4l
         jU5t2MVK9kKt0CHsbCcmX5eyYE6V9Cd1UZKQWGuwBW2IlZuuqKBF7bWY14lClWsX34Rk
         GtUCw7NaJmZRZaJQucKIBEMAqYGzSEPo29hnHuYPsTnvz65AFACH4Mw9udNqqIo4eGZK
         +wdQ==
X-Gm-Message-State: ACrzQf3/L8QJgF6n4sgrHUZ2JUG15RWl3iX+JA/Y2A5hvkqzTorZ+1qv
        Syn1gb2hlpPXbvoa3nEUopBj3EQuyQsJ4g==
X-Google-Smtp-Source: AMsMyM5jNLsGI3srZgdxJqDDtgGcqXZeqoRKPIOGv2vqfaB1yp4zdgydw+Vo1Vp4NekHejrM5vw7Jw==
X-Received: by 2002:a5d:5983:0:b0:22c:b9a0:e874 with SMTP id n3-20020a5d5983000000b0022cb9a0e874mr2607960wri.306.1664461670189;
        Thu, 29 Sep 2022 07:27:50 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:c9dd:4896:ac7a:b9e1? ([2a01:e0a:b41:c160:c9dd:4896:ac7a:b9e1])
        by smtp.gmail.com with ESMTPSA id f2-20020adff982000000b0022afedf3c87sm6698745wrr.105.2022.09.29.07.27.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 07:27:49 -0700 (PDT)
Message-ID: <aaddae1d-ad4e-425c-b88a-0830d839a3ce@6wind.com>
Date:   Thu, 29 Sep 2022 16:27:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] ip: fix triggering of 'icmp redirect'
Content-Language: en-US
To:     Julian Anastasov <ja@ssi.bg>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
References: <20220829100121.3821-1-nicolas.dichtel@6wind.com>
 <6c8a44ba-c2d5-cdf-c5c7-5baf97cba38@ssi.bg>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <6c8a44ba-c2d5-cdf-c5c7-5baf97cba38@ssi.bg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 27/09/2022 à 14:56, Julian Anastasov a écrit :
> 
> 	Hello,
Hello,

thanks for the detailed explanation.

> 
> On Mon, 29 Aug 2022, Nicolas Dichtel wrote:
> 
>> __mkroute_input() uses fib_validate_source() to trigger an icmp redirect.
>> My understanding is that fib_validate_source() is used to know if the src
>> address and the gateway address are on the same link. For that,
>> fib_validate_source() returns 1 (same link) or 0 (not the same network).
>> __mkroute_input() is the only user of these positive values, all other
>> callers only look if the returned value is negative.
>>
>> Since the below patch, fib_validate_source() didn't return anymore 1 when
>> both addresses are on the same network, because the route lookup returns
>> RT_SCOPE_LINK instead of RT_SCOPE_HOST. But this is, in fact, right.
>> Let's adapat the test to return 1 again when both addresses are on the same
>> link.
>>
>> CC: stable@vger.kernel.org
>> Fixes: 747c14307214 ("ip: fix dflt addr selection for connected nexthop")
>> Reported-by: kernel test robot <yujie.liu@intel.com>
>> Reported-by: Heng Qi <hengqi@linux.alibaba.com>
>> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>> ---
>>
>> This code exists since more than two decades:
>> https://git.kernel.org/pub/scm/linux/kernel/git/davem/netdev-vger-cvs.git/commit/?id=0c2c94df8133f
>>
>> Please, feel free to comment if my analysis seems wrong.
>>
>> Regards,
>> Nicolas
>>
>>  net/ipv4/fib_frontend.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
>> index f361d3d56be2..943edf4ad4db 100644
>> --- a/net/ipv4/fib_frontend.c
>> +++ b/net/ipv4/fib_frontend.c
>> @@ -389,7 +389,7 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
>>  	dev_match = dev_match || (res.type == RTN_LOCAL &&
>>  				  dev == net->loopback_dev);
>>  	if (dev_match) {
>> -		ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_HOST;
>> +		ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_LINK;
> 
> 	Looks like I'm late here. nhc_scope is related to the
> nhc_gw. nhc_scope = RT_SCOPE_LINK means rt_gw4 is a target behing a GW 
> (nhc_gw). OTOH, RT_SCOPE_HOST means nhc_gw is 0 (missing) or a local IP 
> and as result, rt_gw4 is directly connected. IIRC, this should look
> like this:
> 
> nhc_gw	nhc_scope		rt_gw4		fib_scope (route)
> ---------------------------------------------------------------------------
> 0	RT_SCOPE_NOWHERE	Host		RT_SCOPE_HOST (local)
> 0	RT_SCOPE_HOST		LAN_TARGET	RT_SCOPE_LINK (link)
> LOCAL1	RT_SCOPE_HOST		LAN_TARGET	RT_SCOPE_LINK (link)
> REM_GW1	RT_SCOPE_LINK		Universe	RT_SCOPE_UNIVERSE (indirect)
> 
> 	For the code above: we do not check res->scope,
> we are interested what is the nhc_gw's scope (LINK/HOST/NOWHERE).
> It means, reverse route points back to same device and sender is not
> reached via gateway REM_GW1.
iproute2 reject a gw which is not directly connected, am I wrong?

> 
> 	By changing it to nhc_scope >= RT_SCOPE_LINK, ret always
> will be 1 because nhc_scope is not set below RT_SCOPE_LINK (253).
> Note that RT_SCOPE_HOST is 254.
Do you have a setup which shows the problem?

> 
> 	Looks like calling fib_info_update_nhc_saddr() in
> nh_create_ipv4() with fib_nh->fib_nh_scope (nhc_scope) is a problem,
> it should be fib_nh->fib_nh_scope - 1 or something like that,
> see below. 127.0.0.1 is selected because it is
> ifa_scope = RT_SCOPE_HOST, lo is first device and fib_nh_scope is 
> RT_SCOPE_HOST when GW is not provided while creating the nexthop.
> 
> 	About commit 747c14307214:
> 
> - if nexthop_create() assigns always nhc_scope = RT_SCOPE_LINK then
> the assumption is that all added gateways are forced to be used
> for routes to universe? If GW is not provided, we should use
> nhc_scope = RT_SCOPE_HOST to allow link routes, right?
> Now, the question is, can I use same nexthop in routes
> with different scope ? What if later I add local IP that matches
> the IP used in nexthop? This nexthop's GW becomes local one.
> But these are corner cases.
> 
> 	What I see as things to change:
> 
> - fib_check_nexthop(): "scope == RT_SCOPE_HOST",
> "Route with host scope can not have multiple nexthops".
> Why not? We may need to spread traffic to multiple
> local IPs. But this is old problem and needs more
> investigation.
> 
> - as fib_check_nh() is called (and sets nhc_scope) in
> nh_create_ipv4(), i.e. when a nexthop is added, we should
> tune nhc_scope in nh_create_ipv4() by selecting fib_cfg.fc_scope
> based on the present GW and then to provide it to fib_check_nh()
> and fib_info_update_nhc_saddr. As result, this nexthop will get
> valid nhc_scope based on the current IPs and link routes and
> also valid nh_saddr (not 127.0.0.1). We can do it as follows:
> 
> 	.fc_scope = cfg->gw.ipv4 ? RT_SCOPE_UNIVERSE :
> 				   RT_SCOPE_LINK,
> 
> 	As result, we will also fix the scope provided to
> fib_info_update_nhc_saddr which looks like the main
> problem here.
> 
> - later, if created route refers to this nexthop,
> fib_check_nexthop() should make sure the provided
> route's scope is not >= the nhc_scope, may be a
> check in nexthop_check_scope() is needed. This
> will ensure that new link route is not using nexthop
> with provided gateway.
> 
> - __fib_validate_source() should match for RT_SCOPE_HOST
> as before.
> 
> - fib_check_nh_nongw: no GW => RT_SCOPE_HOST
After reverting the two commits (747c14307214 and eb55dc09b5dd) and putting the
below patch, the initial problem is fixed. But it's not clear what is broken
with the current code. Before sending these patches formally, it would be nice
to be able to add a selftest to demonstrate what is wrong.

@@ -2534,7 +2534,7 @@ static int nh_create_ipv4(struct net *net, struct nexthop *nh,
 	if (!err) {
 		nh->nh_flags = fib_nh->fib_nh_flags;
 		fib_info_update_nhc_saddr(net, &fib_nh->nh_common,
-					  fib_nh->fib_nh_scope);
+					  !fib_nh->fib_nh_scope ? 0 : fib_nh->fib_nh_scope - 1);
 	} else {
 		fib_nh_release(net, fib_nh);
 	}
