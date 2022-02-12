Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5431F4B37A4
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 20:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbiBLTcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 14:32:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiBLTcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 14:32:15 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40B4606CA;
        Sat, 12 Feb 2022 11:32:10 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id h7so15453309iof.3;
        Sat, 12 Feb 2022 11:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=85D+ZVI6xZrOi9juV+VxGoOsdsJITQcvDoo7mAoBhBk=;
        b=o2xlZHtKuJ+sQSrpo4104Wn5qXEyFjP81rSzZosACHuhu7La39FOi6DG6IBK0Qqa3X
         DZzeoD7kVwnHjUHu30Gw0VRBDaa1dLAYeHgGgk7VhBADUsyN3SAZZgwXnEC9iFxjD+K3
         u4wuVWS6nRjEMw3TW798y7Kd8lEPJDNAD8kT5SjP0ed8+ajd78p1xgceaHpuu47zyzPL
         8UoM5qKIJVrTzIpKrPcoEfhN/rxfFzPVbC3/Qth5jG2fMVWFq9gbeRZiur7YCuFq9Hin
         h+VtHNWPC8U9w3PvgR/0DKBVWP+rBulp7Y7+8NzKlLVfwaWJ+qqUGNVNAHi1Vj8k1lv/
         iKwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=85D+ZVI6xZrOi9juV+VxGoOsdsJITQcvDoo7mAoBhBk=;
        b=hbKbDEwKDnGQAncNTyFMmY0tdMc1EzXRH5n9qZx6/yxPzHTeOfY6y+E+i3ugl7VupA
         spwM9efAAdWqusklveH8VZn89bFbYX/KKj871mO7+ZBf/GyPaQ7gJKmzUUUTPNIv3a2W
         RHR/HTxrA1pSAV11lXAID5EsPOwSEMJ1Ip9CJK68y8/qQXdQNO0zFtPUpYP2VFxqfeB+
         a0qZzCtjH19zlXCrILB0s0s5ioKEcqWsPp/9RFB5cQb0OYODQWDrn+4KsxK/vQua6aMC
         yy4DMDieGQfjX347lxuSsV/9t4IMVztX+bE7qA9UlAf20Tdx2rf40Ou9yyctgdHHT8Ek
         jdOw==
X-Gm-Message-State: AOAM533o7xtDez+rplmxlulWgwH7myJsQkAGis39JmZE+EYDO2RTayS1
        oKtWfdDIXN/n2VAED4Ic7eDMhScqPGA=
X-Google-Smtp-Source: ABdhPJzIZMIYeRJzPAoQ3rU2xH/WSkkt1G7PR0grk4Iu+BoXsr/Nkf1XpAzNYFhvVEq7NLdwXikz6Q==
X-Received: by 2002:a5d:8052:: with SMTP id b18mr3648023ior.62.1644694330139;
        Sat, 12 Feb 2022 11:32:10 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:b5fd:e5f4:5f5e:6650? ([2601:282:800:dc80:b5fd:e5f4:5f5e:6650])
        by smtp.googlemail.com with ESMTPSA id g7sm5633445ild.40.2022.02.12.11.32.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Feb 2022 11:32:09 -0800 (PST)
Message-ID: <4287b4dc-83b6-5c27-7df1-542a76ff3451@gmail.com>
Date:   Sat, 12 Feb 2022 12:32:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v2] Generate netlink notification when default IPv6 route
 preference changes
Content-Language: en-US
To:     Kalash Nainwal <kalash@arista.com>, netdev@vger.kernel.org
Cc:     fruggeri@arista.com, "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <20220210220935.21139-1-kalash@arista.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220210220935.21139-1-kalash@arista.com>
Content-Type: text/plain; charset=UTF-8
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

On 2/10/22 2:09 PM, Kalash Nainwal wrote:
>  Generate RTM_NEWROUTE netlink notification when the route preference
>  changes on an existing kernel generated default route in response to
>  RA messages. Currently netlink notifications are generated only when
>  this route is added or deleted but not when the route preference
>  changes, which can cause userspace routing application state to go
>  out of sync with kernel.
> 
> Signed-off-by: Kalash Nainwal <kalash@arista.com>
> ---
>  net/ipv6/ndisc.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


