Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04BE3BEA18
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 16:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhGGOyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 10:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbhGGOyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 10:54:07 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2D6C061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 07:51:26 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id i12-20020a05683033ecb02903346fa0f74dso2435136otu.10
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 07:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EeKWrVW5NpVLimN6dOrgipZvOJHErIGdg0c7P37GdcQ=;
        b=NqZb1z3mDzArPRSRVUnWWAvDzc8KUV8Iz+yw8dr+nx4T0X7WITrAe0xUYXlIObEsYE
         HDHR7bk1V7uPKZr6vYtD2ThUoVbX/Dp++I3s3PQ9W7iJHQdcSMTRTlLhpn4usBWzriIf
         efQwCViBuWgxqEN1g+siRztrFTfWxIWxnHNMGJnXEZxlSn0mVODWVxpt5RjozcpIBDEn
         8X2QktQEZsFtiSG4jgYBOnohFDzd6jB2UrO8UzuG16oTPE9zz9WpCiEEOe+9HQpEYYxD
         IpVqo+XRrYPxdwD51V7kwbL45sMm6YjdCvxZvVzh4m7oMpfG/4fGic9FNH1I73+b6L74
         S/Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EeKWrVW5NpVLimN6dOrgipZvOJHErIGdg0c7P37GdcQ=;
        b=qEmJ2QJfPBMJd7MOfItol4NZ1DuHfzozUXh8tQerbr8ngllFDMxm2O8x508CW4jEVN
         pj1RS5EASQRpoyExu71szwwJowp7DXP6qiWelHShkLgJYy+Sp1DQ3VRf4JkuRsLjki8a
         oKZluRIa86COxyZJBwrMZ9TE9eCN8FkZcf7wZSmBlpZHXR8kYVWgQui9YAm3mJ8dpzhI
         OnRxZIieQCPlt91QDFc+tAUMT+1xiKuAIAVW8Ogp24LxDtlztjLN+fitEibJAFH8VYjj
         dBhLPFZ1mPuqaY00D2L34o3w3eLFjUCAUzdtVC0SQsMbtfwWX3gkNNQkMsjLb9DQ6qW9
         2qXQ==
X-Gm-Message-State: AOAM532opSidvnzwWiKD68yR8MDxNLG6G/2Q6pFw3fcHxYQCC19qGkUU
        SLQJ/woOXIkvHbWm6o7+1Vg=
X-Google-Smtp-Source: ABdhPJwjxUVaK/iNXaxdaGACe/CXZM0vozq8I8YKYS/IU65WG9guTWBpXt+jp3t7A3CG1FCeV/8Evg==
X-Received: by 2002:a05:6830:1584:: with SMTP id i4mr5695655otr.353.1625669485690;
        Wed, 07 Jul 2021 07:51:25 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id q184sm1383318ooa.2.2021.07.07.07.51.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 07:51:25 -0700 (PDT)
Subject: Re: [PATCH net 2/2] selftests: icmp_redirect: IPv6 PMTU info should
 be cleared after redirect
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>
References: <20210707081530.1107289-1-liuhangbin@gmail.com>
 <20210707081530.1107289-3-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7bc07872-adde-f81b-313f-59468e37c19d@gmail.com>
Date:   Wed, 7 Jul 2021 08:51:22 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210707081530.1107289-3-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/21 2:15 AM, Hangbin Liu wrote:
> After redirecting, it's already a new path. So the old PMTU info should
> be cleared. The IPv6 test "mtu exception plus redirect" should only
> has redirect info without old PMTU.
> 
> The IPv4 test can not be changed because of legacy.
> 
> Fixes: ec8105352869 ("selftests: Add redirect tests")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/testing/selftests/net/icmp_redirect.sh | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/icmp_redirect.sh b/tools/testing/selftests/net/icmp_redirect.sh
> index 3a111ac1edc3..ecbf57f264ed 100755
> --- a/tools/testing/selftests/net/icmp_redirect.sh
> +++ b/tools/testing/selftests/net/icmp_redirect.sh
> @@ -313,9 +313,10 @@ check_exception()
>  	fi
>  	log_test $? 0 "IPv4: ${desc}"
>  
> -	if [ "$with_redirect" = "yes" ]; then
> +	# No PMTU info for test "redirect" and "mtu exception plus redirect"
> +	if [ "$with_redirect" = "yes" ] && [ "$desc" != "redirect exception plus mtu" ]; then
>  		ip -netns h1 -6 ro get ${H1_VRF_ARG} ${H2_N2_IP6} | \
> -		grep -q "${H2_N2_IP6} .*via ${R2_LLADDR} dev br0.*${mtu}"
> +		grep -v "mtu" | grep -q "${H2_N2_IP6} .*via ${R2_LLADDR} dev br0"
>  	elif [ -n "${mtu}" ]; then
>  		ip -netns h1 -6 ro get ${H1_VRF_ARG} ${H2_N2_IP6} | \
>  		grep -q "${mtu}"
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

