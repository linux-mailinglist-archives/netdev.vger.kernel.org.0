Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9AD94B8F4D
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 18:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237217AbiBPRiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 12:38:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237242AbiBPRit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 12:38:49 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32BA23C85F
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:38:34 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso7073879pjt.4
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=tQG4OiOgTJuLNT4pwJwQQRBCUUaRXmIT05jnmLgiilU=;
        b=AOkeEj+J6d2onBsMRIxeuIApJeYqL4JR+WbRozlmuQSILZ54cEtPX6Ez8JBijuDntO
         kLDXdcl7t3zLPHnY6pIc256aRatKR3aLCrdU32WuB2cVj972yd3pa0xM94TkwpK7VHXW
         bm+UcBAC8MuVrv4VHFYRLx7RbOO11Zn8rDm+B8JIsCe7I5OdVODlOgiTTXAsC0mNexDh
         6OAC+Z9EQkP55ApE34FH5Bb071Eei9esvx1CbkZ8D7pzXAh8hFuRcWy9bpaGTSFCkfR7
         EVIYHDvjJqAwdCvc3kdFWL4OYfI7MtL0G+xBIftvtaeDomGGfb3+HH5l5fXQGKvb2xTJ
         eI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tQG4OiOgTJuLNT4pwJwQQRBCUUaRXmIT05jnmLgiilU=;
        b=nkW/6O1kPUYHHHO2O1oi0shp5Zd4V+6mlOWfv81ZNWtTT+hJWApxlcbrp4rKvJ/ftH
         y1g1VFcltYgpe3KoSYuJCm3J41Jk1whIGpScvn+enfNhU2V7y9bRRmtKOZA5cMvID8N+
         YUe7oT3oPJr+FcyTlBd8W1comJJ2hhKrAE0RbKwuJ/OYlaW9o+f0bE/4LBV6mENK938Y
         CijYCpB4Qd7ULSxbj4n30xJ7KYEealhzQAMT5x6E8G0CR/ueeNK3gXillllP2fC1+87K
         XPWf1nDCXcQ1JBrKQkVPLEkn0mmHRhHIlZCgbhaIgbhSlMFo5nlCTaAAYf/ytySdLqLr
         bEng==
X-Gm-Message-State: AOAM5338ERygYmGHYHqR2HeimJJvLx/iIKjyEFwwGKHaHIA8aAs3F9b/
        F9xKoSw1pSN6Cx/OEytfSVTXH60P0FI=
X-Google-Smtp-Source: ABdhPJx0Ju4tsKTQoZji0esaviz9Nh1LuWrSpqN3XtliqioVZ9WYBWc4aNYFxYpXw73YsJwOUa4hXg==
X-Received: by 2002:a17:903:3015:b0:14c:def1:ef62 with SMTP id o21-20020a170903301500b0014cdef1ef62mr3739276pla.2.1645033114156;
        Wed, 16 Feb 2022 09:38:34 -0800 (PST)
Received: from [192.168.86.21] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 16sm33242855pfm.200.2022.02.16.09.38.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 09:38:33 -0800 (PST)
Message-ID: <c13d92e2-3ac5-58cb-2b21-ebe03e640983@gmail.com>
Date:   Wed, 16 Feb 2022 09:38:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 5/5] bonding: add new option ns_ip6_target
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>
References: <20220216080838.158054-1-liuhangbin@gmail.com>
 <20220216080838.158054-6-liuhangbin@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220216080838.158054-6-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/16/22 00:08, Hangbin Liu wrote:
> This patch add a new bonding option ns_ip6_target, which correspond
> to the arp_ip_target. With this we set IPv6 targets and send IPv6 NS
> request to determine the health of the link.
>
> For other related options like the validation, we still use
> arp_validate, and will change to ns_validate later.
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>   Documentation/networking/bonding.rst |  11 +++
>   drivers/net/bonding/bond_netlink.c   |  59 ++++++++++++
>   drivers/net/bonding/bond_options.c   | 138 +++++++++++++++++++++++++++
>   drivers/net/bonding/bond_sysfs.c     |  26 +++++

Thanks for the patches !

Do we really need to add sysfs parts, now rtnetlink is everywhere ?


>   include/net/bond_options.h           |   4 +
>   include/net/bonding.h                |   7 ++
>   include/uapi/linux/if_link.h         |   1 +
>   tools/include/uapi/linux/if_link.h   |   1 +
>   8 files changed, 247 insertions(+)
>
> diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
> index ab98373535ea..525e6842dd33 100644
> --- a/Documentation/networking/bonding.rst
> +++ b/Documentation/networking/bonding.rst
> @@ -313,6 +313,17 @@ arp_ip_target
>   	maximum number of targets that can be specified is 16.  The
>   	default value is no IP addresses.
>   
> +ns_ip6_target
> +
> +	Specifies the IPv6 addresses to use as IPv6 monitoring peers when
> +	arp_interval is > 0.  These are the targets of the NS request
> +	sent to determine the health of the link to the targets.
> +	Specify these values in ffff:ffff::ffff:ffff format.  Multiple IPv6
> +	addresses must be separated by a comma.  At least one IPv6
> +	address must be given for NS/NA monitoring to function.  The
> +	maximum number of targets that can be specified is 16.  The
> +	default value is no IPv6 addresses.
> +
>   arp_validate
>   
>   	
