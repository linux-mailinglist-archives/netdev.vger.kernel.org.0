Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC1B23BBB6
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 16:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgHDOF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 10:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728708AbgHDOAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 10:00:36 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0960C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 07:00:21 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id j16so3645534ooc.7
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 07:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S51+9DoMEhjVmsWDD9c8ddVLTFqPPFbxVhxAwZGhfKs=;
        b=HHx16UKsLhS2krUOAJ3yRf+vZ/rLI46EJUVYch3z1H2PiEe6l3g5l0jotOSrWhn5dW
         5UP1xMzcwMxgO69iKeN+mcyZh562Er8uL19ddFlXardyPFUr2Sbo/kxu3wpNv4Um3chG
         Cx8Adr/pQFXhQBE06/xni3xS1+CFELUXRfw0qzVYjJ4jNMAr/t2xWpUziCJdn7khOGRh
         WjF5T7LKY6ZCJdzXg4e02n8+am1wqvw+wDShp+QAc6lKewU4DrY+LJKvY5amnSCa/7fh
         +wRdpvOjEycG5HszSmLmH6U+pvvctwxMp6jN0VZK9MVl+MknYbOixfxKEC+FxYvIdJ06
         Km7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S51+9DoMEhjVmsWDD9c8ddVLTFqPPFbxVhxAwZGhfKs=;
        b=Vg+DAtYQpaQk43pFQFUknfbN7n0t6+j6CbhGYC1wl5nwzm7FVuyByEw1XfHZ+NHgxI
         V5hVT1KE38VMTwLJkgIs60GzIun16a7YVOaivO5dhBHEF0wdXcmQ+fW8AGNRDxaXqEqg
         JmnFBjhKUCN636eRdNn5+t9HCo2YrSXmuqQoEMXShgo3Vk6LnfYiSDP5k/IcXP5tH8ya
         grNuVCZhWf5kU76trUrzg2PLPUUz8Dg+YlwcdT1o9vfTrIPYQEyP2jSvwAU7dwB9mFkw
         4QRrlstvUjQiiU4zfZVyQVBz32Li14sYq/X8DbCUNA71d0rd/z49yHzAz14AP+J4W95y
         Q2Kg==
X-Gm-Message-State: AOAM531+TbLhtjIPRyLJpTiJdkp0hbLgkJck3yzAHAjxhj3GhIDNi9/J
        X58pbYf0ymFIKDra4TNw2mHvhxI1
X-Google-Smtp-Source: ABdhPJxT0YYUxf10NXOQ9wv6RJNvmBbiUzElI4jOXmLAcfG0/VgvfIP4XBp7hrKS2Z+bVinJx579Rw==
X-Received: by 2002:a4a:9f93:: with SMTP id z19mr18819956ool.58.1596549621134;
        Tue, 04 Aug 2020 07:00:21 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:14ac:dc81:c028:3eca])
        by smtp.googlemail.com with ESMTPSA id s6sm3369370otq.75.2020.08.04.07.00.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 07:00:20 -0700 (PDT)
Subject: Re: [PATCH net-next v2 5/6] selftests: pmtu.sh: Add tests for bridged
 UDP tunnels
To:     Stefano Brivio <sbrivio@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Westphal <fw@strlen.de>, Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Lourdes Pedrajas <lu@pplo.net>, netdev@vger.kernel.org
References: <cover.1596520062.git.sbrivio@redhat.com>
 <6b2a52ca59d791dfd5547acb62e710e61e646588.1596520062.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <baf285cf-5f58-e36d-abf9-32a8414bada7@gmail.com>
Date:   Tue, 4 Aug 2020 08:00:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <6b2a52ca59d791dfd5547acb62e710e61e646588.1596520062.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/20 11:53 PM, Stefano Brivio wrote:
> @@ -497,12 +529,19 @@ setup_vxlan_or_geneve() {
>  	run_cmd ${ns_a} ip link add ${type}_a type ${type} id 1 ${opts_a} remote ${b_addr} ${opts} || return 1
>  	run_cmd ${ns_b} ip link add ${type}_b type ${type} id 1 ${opts_b} remote ${a_addr} ${opts}
>  
> -	run_cmd ${ns_a} ip addr add ${tunnel4_a_addr}/${tunnel4_mask} dev ${type}_a
> -	run_cmd ${ns_b} ip addr add ${tunnel4_b_addr}/${tunnel4_mask} dev ${type}_b
> +	if [ -n "${br_if_a}" ]; then
> +		run_cmd ${ns_a} ip addr add ${tunnel4_a_addr}/${tunnel4_mask} dev ${br_if_a}
> +		run_cmd ${ns_a} ip addr add ${tunnel6_a_addr}/${tunnel6_mask} dev ${br_if_a}
> +		run_cmd ${ns_a} ip link set ${type}_a master ${br_if_a}
> +	else
> +		run_cmd ${ns_a} ip addr add ${tunnel4_a_addr}/${tunnel4_mask} dev ${type}_a
> +		run_cmd ${ns_a} ip addr add ${tunnel6_a_addr}/${tunnel6_mask} dev ${type}_a
> +	fi
>  
> -	run_cmd ${ns_a} ip addr add ${tunnel6_a_addr}/${tunnel6_mask} dev ${type}_a
> +	run_cmd ${ns_b} ip addr add ${tunnel4_b_addr}/${tunnel4_mask} dev ${type}_b
>  	run_cmd ${ns_b} ip addr add ${tunnel6_b_addr}/${tunnel6_mask} dev ${type}_b
>  
> +

extra newline snuck in

other than that:
Reviewed-by: David Ahern <dsahern@gmail.com>


