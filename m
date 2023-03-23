Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E82E6C6C2C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 16:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbjCWPVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 11:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjCWPVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 11:21:19 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647801BAD3
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:21:18 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id eh3so88159182edb.11
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1679584877;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NZy27oNct5Hp79ZO94h985IXw8RyQ8r2nB3InJsfjRk=;
        b=mQPj9nd5tx7L6O/mXQm4SMprNjLGGeyaxpYdLjRFxvpPUHsLVAgZcVxp7I1E4ltzof
         DenObKouN6DA09PI+W1sEORIBQZNtRpo0Yil0rNfPW6Zu6Pb4ivq6Q7nKbA6s4ez7ZzR
         L+ebJN4+OAfKzFVGrUGmace97ZtWJSthCNdwlfdmzq+5vzrtJRw1fnTG09y3oVxZUr0P
         AfG6NSvzWonNVSe9ZxTatw8YjaX6T9CJpIQaLPtTLdqWi+U1Pujd4Hyr3I3AsBM58i9o
         9TKYbTv3bFREdyL1YCbzZw0Na37L3UypkAmZJBSUdCP5m2rkp6XNp1k2CsZ60y/k9PBh
         lWNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679584877;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NZy27oNct5Hp79ZO94h985IXw8RyQ8r2nB3InJsfjRk=;
        b=Hlk7IrzekvucDOOaFq+26zmQ8jaaS6Gb4GnQaA9v8xTAjHtesszb1S1e7KUxVa6hyO
         d70jMfzC47+z9kd7bDS20JYw58jpO4GVjtg+6/JMLthSgFQb5b7XtgP9vdm3JvvCAuFV
         BUFFZ+pIr3GOBdk8D6QVHMlVmcCofMk1g6KoNBFsv+dr/Y16oRTAg9cCG4X216hl0BK0
         mXgiYfCHKwRZd4bVSHLokgoLXAJ8nz3T9yDSf9Kaeh23vhPYEIW+UJtxWWpCu89FZQF8
         wLc/hOjbPZ4cQG0EVl9K+0fTmRBK3LudZdVebrnbaKe5ErpuyBf+LgZ6n/Jou1Qgt0I/
         HNmw==
X-Gm-Message-State: AO0yUKUGt4SQij187UZUFg6p4fJ3EChKyrGhBwgUgcie79F3EoWrW9Fs
        ya372JxjHjaW9u3DIQhfMoh9nrXQ+WrGpZFkrWHIIg==
X-Google-Smtp-Source: AK7set8/UgJMVNN8wP0bnndL3wbJdXn1C77umcSq7HMO86Xu+qff1nW6jcIwrRS86koIXJ/QR78w/Q==
X-Received: by 2002:a17:906:2751:b0:92f:1418:27f0 with SMTP id a17-20020a170906275100b0092f141827f0mr9592010ejd.34.1679584876844;
        Thu, 23 Mar 2023 08:21:16 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id m20-20020a170906259400b0092b8c1f41ebsm8738959ejb.24.2023.03.23.08.21.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 08:21:16 -0700 (PDT)
Message-ID: <5d4802d8-8853-dc95-efb6-3b840036675d@blackwall.org>
Date:   Thu, 23 Mar 2023 17:21:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH iproute2-next 7/7] bridge: mdb: Document the catchall MDB
 entries
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230321130127.264822-1-idosch@nvidia.com>
 <20230321130127.264822-8-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230321130127.264822-8-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=3.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/03/2023 15:01, Ido Schimmel wrote:
> Document the catchall MDB entries used to transmit IPv4 and IPv6
> unregistered multicast packets.
> 
> In deployments where inter-subnet multicast forwarding is used, not all
> the VTEPs in a tenant domain are members in all the broadcast domains.
> It is therefore advantageous to transmit BULL (broadcast, unknown
> unicast and link-local multicast) and unregistered IP multicast traffic
> on different tunnels. If the same tunnel was used, a VTEP only
> interested in IP multicast traffic would also pull all the BULL traffic
> and drop it as it is not a member in the originating broadcast domain
> [1].
> 
> [1] https://datatracker.ietf.org/doc/html/draft-ietf-bess-evpn-irb-mcast#section-2.6
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  man/man8/bridge.8 | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
> index 9753ce9e92b4..4006ad23ea74 100644
> --- a/man/man8/bridge.8
> +++ b/man/man8/bridge.8
> @@ -1013,6 +1013,12 @@ device creation will be used.
>  device name of the outgoing interface for the VXLAN device to reach the remote
>  VXLAN tunnel endpoint.
>  
> +.in -8
> +The 0.0.0.0 and :: MDB entries are special catchall entries used to flood IPv4
> +and IPv6 unregistered multicast packets, respectively. Therefore, when these
> +entries are programmed, the catchall 00:00:00:00:00:00 FDB entry will only
> +flood broadcast, unknown unicast and link-local multicast.
> +
>  .in -8
>  .SS bridge mdb delete - delete a multicast group database entry
>  This command removes an existing mdb entry.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

