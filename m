Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DCF6F2985
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 18:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjD3Qhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 12:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjD3Qhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 12:37:47 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8D6199A
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 09:37:44 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-94f0dd117dcso290066866b.3
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 09:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1682872662; x=1685464662;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gdJIIB/OitWvjby4JCezksWs1PsObjE5/Rl2aap/UyU=;
        b=FOGnDonjCCqIssMqvcfmtID68cW2CM5gEYfjiphO5MgRDXSxU9lYBTILUEthRsg1BK
         1MhPds3fA5c+6HFxnZdVae4fHfOjvvnSiKtOZNh3sDv7vqoNGIhYDxfC63WrEFkpVd6a
         CbvLMd9jrDeYRtYUDY86bINN86KPN0pAAtubGHrXjphnyDpqOVOQMBgjd5DtVdZ97eBE
         vcQc8IzdXs6n9+9dVfzzyxcv9ow0Dfs1c9kQAtD8/c3a+a7u9EyHDS5CKccZaos4hKMY
         MU1BlkFg44zX0kvVOFQUk48bdsasQ+YSFnUACeB0FWyEuWJ3Z3Ae1AfGPwKI0LchFowr
         NDvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682872662; x=1685464662;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gdJIIB/OitWvjby4JCezksWs1PsObjE5/Rl2aap/UyU=;
        b=SZlv1nakm30QpEfmTAtZAdbzdVkVnhlp/q/KLc/kW6F52XmAaXzRWGgJkwz66OvWr0
         MbJYvMAxsm751DV7kd0Az/UL2FzTmrG1Z0NdTveM3n8Gg8DuGGZz6rFaiMgfg1xdX4Xr
         bYfhV6EDvVuCY+cw6xiWYv3ehxZ4sj8Lw4NlP6gOPDQeo9CclmhQWOcIFjJdQbxNmwjC
         UHuG4PvYX8KA0L8+uMyr9DU1NHvKilpz2ENZ+WZSATiCpEnrQ7ygJOEoPQamgEKJSVqP
         FWr+itzWK81NhG8NZp9o970aLhZ9Ngp/kHASV1WR3JZCxTdikWqAtRl/KdJlzWxogpD6
         CGbg==
X-Gm-Message-State: AC+VfDwZagAmie54NfW8bkbixhBZPrxB61PyUeh0FePNHLueq1tyKxyX
        NUnEwK096IOcJPm+mVMM7iU=
X-Google-Smtp-Source: ACHHUZ6TS+mrPegUaF8fdmk45BXBU1VvXdO5mlwzSH9269KJQuN5HJjNmkAGbFrQabWQc4dDARKBpA==
X-Received: by 2002:a17:906:9744:b0:94e:ec32:ba28 with SMTP id o4-20020a170906974400b0094eec32ba28mr13282684ejy.29.1682872662484;
        Sun, 30 Apr 2023 09:37:42 -0700 (PDT)
Received: from tycho (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id gv45-20020a1709072bed00b009606489890bsm4695014ejc.113.2023.04.30.09.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 09:37:42 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
Date:   Sun, 30 Apr 2023 18:37:40 +0200
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com, simon.horman@corigine.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v4 3/3] selftests: net: add tc flower cfm test
Message-ID: <nf7dyids3rlb3yx6vdtnr33wcmtaarcz5te6o7hgl2sul7zrie@37rvrnq5vnz6>
References: <20230425211630.698373-1-zahari.doychev@linux.com>
 <20230425211630.698373-4-zahari.doychev@linux.com>
 <ZE6Cw0XOU9L/STZj@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZE6Cw0XOU9L/STZj@shredder>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +tcflags="skip_hw"
> > +

[...]

> > +h1_create()
> > +{
> > +	simple_if_init $h1 192.0.2.1/24 198.51.100.1/24
> 
> The IP address are not used in the test. Can be omitted.
> 
> > +}
> > +
> > +h1_destroy()
> > +{
> > +	simple_if_fini $h1 192.0.2.1/24 198.51.100.1/24
> > +}
> > +
> > +h2_create()
> > +{
> > +	simple_if_init $h2 192.0.2.2/24 198.51.100.2/24
> > +	tc qdisc add dev $h2 clsact
> > +}
> > +
> > +h2_destroy()
> > +{
> > +	tc qdisc del dev $h2 clsact
> > +	simple_if_fini $h2 192.0.2.2/24 198.51.100.2/24
> > +}
> > +
> > +cfm_mdl_opcode()
> > +{
> > +	local mdl=$1
> > +	local op=$2
> > +	local flags=$3
> > +	local tlv_offset=$4
> 
> If you use something like:
> 
> local mdl=$1; shift
> local op=$1; shift
> 
> Then minimal changes are required if the order changes
> 
> > +
> > +	printf "%02x %02x %02x %02x"    \
> > +		   $((mdl << 5))             \
> > +		   $((op & 0xff))             \
> > +		   $((flags & 0xff)) \
> > +		   $tlv_offset
> > +}
> 
> See mldv2_is_in_get() in tools/testing/selftests/net/forwarding/lib.sh
> and related functions for a more readable way to achieve the above.
> 
> > +
> > +match_cfm_opcode()
> > +{
> > +	local ethtype="89 02"; readonly ethtype
> > +	RET=0
> > +
> > +	tc filter add dev $h2 ingress protocol cfm pref 1 handle 101 \
> > +	   flower cfm op 47 action drop
> > +	tc filter add dev $h2 ingress protocol cfm pref 2 handle 102 \
> > +	   flower cfm op 43 action drop
> 
> Both filters can use the same preference since the same mask is used.
> 
> > +
> > +	pkt="$ethtype $(cfm_mdl_opcode 7 47 0 4)"
> > +	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
> > +	pkt="$ethtype $(cfm_mdl_opcode 6 5 0 4)"
> > +	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
> > +
> > +	tc_check_packets "dev $h2 ingress" 101 1
> > +	check_err $? "Did not match on correct opcode"
> > +
> > +	tc_check_packets "dev $h2 ingress" 102 0
> > +	check_err $? "Matched on the wrong opcode"
> 
> For good measures you can send a packet with opcode 43 and check that
> only 102 is hit.
> 
> > +
> > +	tc filter del dev $h2 ingress protocol cfm pref 1 handle 101 flower
> > +	tc filter del dev $h2 ingress protocol cfm pref 2 handle 102 flower
> > +
> > +	log_test "CFM opcode match test"
> > +}
> > +
> > +match_cfm_level()
> > +{
> > +	local ethtype="89 02"; readonly ethtype
> > +	RET=0
> > +
> > +	tc filter add dev $h2 ingress protocol cfm pref 1 handle 101 \
> > +	   flower cfm mdl 5 action drop
> > +	tc filter add dev $h2 ingress protocol cfm pref 2 handle 102 \
> > +	   flower cfm mdl 3 action drop
> > +	tc filter add dev $h2 ingress protocol cfm pref 3 handle 103 \
> > +	   flower cfm mdl 0 action drop
> 
> Same comment about the preference.
> 
> > +
> > +	pkt="$ethtype $(cfm_mdl_opcode 5 42 0 4)"
> > +	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
> > +	pkt="$ethtype $(cfm_mdl_opcode 6 1 0 4)"
> > +	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
> > +	pkt="$ethtype $(cfm_mdl_opcode 0 1 0 4)"
> > +	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
> > +
> > +	tc_check_packets "dev $h2 ingress" 101 1
> > +	check_err $? "Did not match on correct level"
> > +
> > +	tc_check_packets "dev $h2 ingress" 102 0
> > +	check_err $? "Matched on the wrong level"
> > +
> > +	tc_check_packets "dev $h2 ingress" 103 1
> > +	check_err $? "Did not match on correct level"
> > +
> > +	tc filter del dev $h2 ingress protocol cfm pref 1 handle 101 flower
> > +	tc filter del dev $h2 ingress protocol cfm pref 2 handle 102 flower
> > +	tc filter del dev $h2 ingress protocol cfm pref 3 handle 103 flower
> > +
> > +	log_test "CFM level match test"
> > +}
> > +
> > +match_cfm_level_and_opcode()
> > +{
> > +	local ethtype="89 02"; readonly ethtype
> > +	RET=0
> > +
> > +	tc filter add dev $h2 ingress protocol cfm pref 1 handle 101 \
> > +	   flower cfm mdl 5 op 41 action drop
> > +	tc filter add dev $h2 ingress protocol cfm pref 2 handle 102 \
> > +	   flower cfm mdl 7 op 42 action drop
> 
> Likewise
> 
> > +

I will handle your comments in the next version.

thanks,
Zahari

[...]


