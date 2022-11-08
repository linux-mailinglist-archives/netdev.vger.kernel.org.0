Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57B3620B58
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 09:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbiKHIkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 03:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233390AbiKHIkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 03:40:51 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A901D2DFE
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 00:40:50 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E08783200956;
        Tue,  8 Nov 2022 03:40:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 08 Nov 2022 03:40:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1667896849; x=1667983249; bh=mGgOGBI5sAo99pvHgTl2NM2jYThv
        rQNV0s8mhsTSTvU=; b=EUWC61ia2XxKaCTgqL2vZZ+lrWH8JhTRRS4rcF5jtKVP
        XqykaKYAnzXAIbVUr6tJ2PjMLyObuG3mpc89vXscK9+4AX9RZTskt1HMN1QGT914
        Jgu6DLS8TZ8ELQJmKViY0wnFujNa0Ulk2iQIuxOCB0eEtZ0tjDUOxso6DfNJ5i9s
        8Xr7c+8CRO3QRNzdXk0rindnq/OkTF9Yw4D9iBn2ibq9JjoJGNZKb78IZmovu1W7
        wWQmvA7ut949VdAvf3dF0lR2GZ1VYppngZz/YWsQk9zgSJYcO6IJNuIPFDA5tGRo
        dQO2DGZczEajIQ1B0mAA+DWmw3G/UuWzXe8up5ySQg==
X-ME-Sender: <xms:ERZqY5tUkTs2BRUP8uoomAw-VPgF4iZWKx6DrCDJRx_6F81FbB4cZg>
    <xme:ERZqYydkvp-WN03K1s0TILTy1pjSJVSmkKbVfpRys6H1LWv3ZycmY8YIgqUnl-j9S
    k87QNrmZljWRWM>
X-ME-Received: <xmr:ERZqY8wGYC8Bq-bvmW6THI3jr1DxU0YVLcCpJi2gfaohPo3ezO0S0VloF3LZmIqtM1M9gaAvh4b50swYq8ERT7FJQt0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvdelgdduvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ERZqYwOZ8eKjLPgqEEhFt5SasdLZB8Fw_fnWy1GUONirlrw0pqyA7g>
    <xmx:ERZqY5-cXpVnNZd3mLJinWHdqWqfCfTsKXM6ghF6fZvIKR9QbJb64Q>
    <xmx:ERZqYwUmel-bJUcDQyoiBB7HnUYn87p9K-epl2V0uxkMiQWVfCgBCg>
    <xmx:ERZqY7L-PiXoCB8SuP-6Qbz_8wiR5wYzVKxKT4KuBH-ZVG-gb2EzYg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Nov 2022 03:40:48 -0500 (EST)
Date:   Tue, 8 Nov 2022 10:40:45 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCHv3 iproute2-next] rtnetlink: add new function
 rtnl_echo_talk()
Message-ID: <Y2oWDRIIR6gjkM4a@shredder>
References: <20220929081016.479323-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929081016.479323-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 04:10:16PM +0800, Hangbin Liu wrote:
> diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
> index 59f8f2fb..c87e847f 100644
> --- a/ip/ipnexthop.c
> +++ b/ip/ipnexthop.c
> @@ -919,12 +919,7 @@ static int ipnh_modify(int cmd, unsigned int flags, int argc, char **argv)
>  		.n.nlmsg_type = cmd,
>  		.nhm.nh_family = preferred_family,
>  	};
> -	struct nlmsghdr *answer;
>  	__u32 nh_flags = 0;
> -	int ret;
> -
> -	if (echo_request)
> -		req.n.nlmsg_flags |= NLM_F_ECHO | NLM_F_ACK;
>  
>  	while (argc > 0) {
>  		if (!strcmp(*argv, "id")) {
> @@ -1005,23 +1000,9 @@ static int ipnh_modify(int cmd, unsigned int flags, int argc, char **argv)
>  	req.nhm.nh_flags = nh_flags;
>  
>  	if (echo_request)
> -		ret = rtnl_talk(&rth, &req.n, &answer);
> -	else
> -		ret = rtnl_talk(&rth, &req.n, NULL);
> -
> -	if (ret < 0)
> -		return -2;
> +		return rtnl_echo_talk(&rth, &req.n, json, print_nexthop_nocache);
>  
> -	if (echo_request) {
> -		new_json_obj(json);
> -		open_json_object(NULL);
> -		print_nexthop_nocache(answer, (void *)stdout);
> -		close_json_object();
> -		delete_json_obj();
> -		free(answer);
> -	}
> -
> -	return 0;
> +	return rtnl_talk(&rth, &req.n, NULL);
>  }

Hangbin,

This change breaks the nexthop selftest:
tools/testing/selftests/net/fib_nexthops.sh

Which is specifically checking for "2" as the error code. Example:

# attempt to create nh without a device or gw - fails
run_cmd "$IP nexthop add id 1"
log_test $? 2 "Nexthop with no device or gateway"

I think it's better to restore the original error code than "fixing" all
the tests / applications that rely on it.

The return code of other subcommands was also changed by this patch, but
so far all the failures I have seen are related to "nexthop" subcommand.

Thanks
