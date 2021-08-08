Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05693E3C26
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 20:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhHHSR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 14:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhHHSR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 14:17:27 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EABC061760
        for <netdev@vger.kernel.org>; Sun,  8 Aug 2021 11:17:08 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id c2-20020a0568303482b029048bcf4c6bd9so15325526otu.8
        for <netdev@vger.kernel.org>; Sun, 08 Aug 2021 11:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TdKMjM7WQlrCJ6XOtCZve56ltTw80U4Umf1eXR4Si2w=;
        b=UR5O4wbIvHpbqMMNqaIeFn6MR0X5WML0ty+TT9RCcO/2EMUwT6lO8+DZe4UpFFf38H
         NmqxyAYP66sKcbMPlEjrqoIMWsy6zAPsvhYulWsmC2zNXsROCWnDcoSKLJ8LgdsYkI/X
         1EqA7dzrQ6aA65soGvAKss28fsV1cq30jrRdyIYNe5Qz5INrZ7d9ksTsXrICyxekRMkS
         oc98VuL0Vk5YFhIysqh3J8RORHrM8z1ao2nwOTceXE8zva91eW7mARm73yHjBaeRvrNJ
         R81FhbeRzC+/Mlb2NNXxkpd2chRxX4e7aKOUeLn57OFbwMBOs/yzM7rLnwezojPf8uNX
         7I9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TdKMjM7WQlrCJ6XOtCZve56ltTw80U4Umf1eXR4Si2w=;
        b=I/jPiOIcjCSIcqB0cLZ925fSOVDOMzW7HvBYhDbORQj2bgB1pUzpH59fnbEM4LhMcz
         KJVSVSdjqM96sY4jqdve5qLq/eJzgIhgqyr0QqN86ZM3tueClG11Lq5+8RrKHYSBa/Si
         ZHLU5/Mequyx+66BjrWIqOS7mQtsUWwWabLjIFUc9GSvEvp1D0YtCGQ5uCoXRbRNjCbv
         gezRuAbm5DbNIeTf2hy20sG5pXuIB8zM6ZLjt13ZhJLXVmfMfNmdYA8r+bs2nCyHYO1j
         8nzz4S2gn7zcazhKNLxaxseCxXajh8UidCEpZMcQVcTNwLxGxb7tYvhqmss87PNtmXBj
         4NxQ==
X-Gm-Message-State: AOAM533pw/k69rayaTi8SX0rVqriiVNbLlWqE6FtHwwOgFxMRCZFCdAQ
        Uuu8qHUbT1Udeg9q40t3E1gwG9IJR9M=
X-Google-Smtp-Source: ABdhPJwnEC38mdrf0DIPVTmfCd7JdvUH3diKpZo55w9nbqfTZSWux+ycxEesHU3yZXQMxqXz+Pa5gg==
X-Received: by 2002:a05:6830:1216:: with SMTP id r22mr1790491otp.315.1628446628105;
        Sun, 08 Aug 2021 11:17:08 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id s12sm273312otk.21.2021.08.08.11.17.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Aug 2021 11:17:07 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] ip/bond: add lacp active support
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
References: <20210802030220.841726-1-liuhangbin@gmail.com>
 <20210802030220.841726-2-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4127d0f8-c88b-c535-21c2-6f54f6c30686@gmail.com>
Date:   Sun, 8 Aug 2021 12:17:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210802030220.841726-2-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/21 9:02 PM, Hangbin Liu wrote:
> @@ -316,6 +324,13 @@ static int bond_parse_opt(struct link_util *lu, int argc, char **argv,
>  
>  			addattr32(n, 1024, IFLA_BOND_PACKETS_PER_SLAVE,
>  				  packets_per_slave);
> +		} else if (matches(*argv, "lacp_active") == 0) {
> +			NEXT_ARG();
> +			if (get_index(lacp_active_tbl, *argv) < 0)
> +				invarg("invalid lacp_active", *argv);
> +
> +			lacp_active = get_index(lacp_active_tbl, *argv);
> +			addattr8(n, 1024, IFLA_BOND_AD_LACP_ACTIVE, lacp_active);
>  		} else if (matches(*argv, "lacp_rate") == 0) {

The new argument needs to go after the older "lacp_rate" since it uses
matches. Also, let's stop using matches and move to a full strcmp for
new options.

