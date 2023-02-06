Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1251968CA48
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 00:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjBFXKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 18:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbjBFXJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 18:09:49 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8724032E58
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 15:09:00 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id m14so11913419wrg.13
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 15:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tUVkDQEJN+f3H5RbKcH7eKZszP3z4+ZhaNY7/1eDEK0=;
        b=3GPz/uhzq56MNVqxQrUbrLtDBKMp5rEeW437HaIBX4KY0ngH0k+mTCezC4km7P3KA2
         kN5deoUkQI4heod8fq7bkCdfuSz5KvD11XqbLqyMO52GY62ILymiSEy1cQ+lNrY53xNl
         J9Bwf4gsPuqQXUvzAuF7jC9cUOnnNeM+6RiBUWG4qgpOrhc3jSLzyqKb5bWpvXGNyfgR
         2km+wAabhxR1H4cZoc5JQW4OzXgSRCS8pD75M2jk+4xUaDFSZ+t1nnlIBA93+2MM9s0l
         Mrpwb7gopW5o38c6+KY9OJErcC/678QWh+5ZvPQ7qkbJg/Zb06lm0pFXBaKUip0vP8Tf
         A5Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tUVkDQEJN+f3H5RbKcH7eKZszP3z4+ZhaNY7/1eDEK0=;
        b=o1gVuVjPCddfN8gTlJAzGPKraHd/uVJ0gsI8Y07jqznvVcmHm0GYI8eguyWSfsZ2ng
         0gBatnkcc5PzmO+i8piVivULAgyfwxJZeYUNJc/SxfJhNVCBU5lvhfvGUd29yZdl+6nq
         MzuSj4Gx14c43Po58x77QGW+QaqfA9xSWYVqvBF/pGowkoXT5qw7rNCJNsVPY8P9RuA6
         9M1ycNnjOmigqq/QJT9Xw+k803uYnCkNDaC283FRb6/L/+GjQuZ44C3mKFtX+1wSCx+T
         O2xRVPuBLMRUlJZAk2pqpwDZRyrsfq5BhXS84A8YGmdeLvCY37XANIUCF7R0UTUwzOgT
         dY+w==
X-Gm-Message-State: AO0yUKUQkFJe56GFmW5JesyHuQas5Q+uNRaQMpXRjmYVlwzoGncDojnQ
        nQ/CSxHbjdV92jOEka6cRHU8QQ==
X-Google-Smtp-Source: AK7set/0+a9ObSwP2WEs8ENTpfW+5+dmVDcNj0UPOUv8C58FSFs3TPzfS2mS+OBiJH5hLSHwT7zDLQ==
X-Received: by 2002:a05:6000:18ca:b0:2c3:db9e:4b06 with SMTP id w10-20020a05600018ca00b002c3db9e4b06mr515880wrq.45.1675724938849;
        Mon, 06 Feb 2023 15:08:58 -0800 (PST)
Received: from [192.168.100.228] (212-147-51-13.fix.access.vtx.ch. [212.147.51.13])
        by smtp.gmail.com with ESMTPSA id c14-20020adffb4e000000b002be0b1e556esm9690464wrs.59.2023.02.06.15.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 15:08:58 -0800 (PST)
Message-ID: <0b6635f8-1b5a-80ec-8cc8-5b463d963d2c@blackwall.org>
Date:   Tue, 7 Feb 2023 00:08:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH iproute2-next 3/3] man: man8: bridge: Describe
 mcast_max_groups
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org,
        dsahern@gmail.com, stephen@networkplumber.org
Cc:     Ido Schimmel <idosch@nvidia.com>
References: <cover.1675705077.git.petrm@nvidia.com>
 <924ecbb716124faa45ffb204b68b679634839293.1675705077.git.petrm@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <924ecbb716124faa45ffb204b68b679634839293.1675705077.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/6/23 19:50, Petr Machata wrote:
> Add documentation for per-port and port-port-vlan option mcast_max_groups.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
>   man/man8/bridge.8 | 22 ++++++++++++++++++++++
>   1 file changed, 22 insertions(+)
> 
> diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
> index f73e538a3536..7075eab283fa 100644
> --- a/man/man8/bridge.8
> +++ b/man/man8/bridge.8
> @@ -47,6 +47,8 @@ bridge \- show / manipulate bridge addresses and devices
>   .BR hwmode " { " vepa " | " veb " } ] [ "
>   .BR bcast_flood " { " on " | " off " } ] [ "
>   .BR mcast_flood " { " on " | " off " } ] [ "
> +.BR mcast_max_groups
> +.IR MAX_GROUPS " ] ["
>   .BR mcast_router
>   .IR MULTICAST_ROUTER " ] ["
>   .BR mcast_to_unicast " { " on " | " off " } ] [ "
> @@ -169,6 +171,8 @@ bridge \- show / manipulate bridge addresses and devices
>   .IR VID " [ "
>   .B state
>   .IR STP_STATE " ] [ "
> +.B mcast_max_groups
> +.IR MAX_GROUPS " ] [ "
>   .B mcast_router
>   .IR MULTICAST_ROUTER " ]"
>   
> @@ -517,6 +521,15 @@ By default this flag is on.
>   Controls whether multicast traffic for which there is no MDB entry will be
>   flooded towards this given port. By default this flag is on.
>   
> +.TP
> +.BI mcast_max_groups " MAX_GROUPS "
> +Sets the maximum number of MDB entries that can be registered for a given
> +port. Attempts to register more MDB entries at the port than this limit
> +allows will be rejected, whether they are done through netlink (e.g. the
> +\fBbridge\fR tool), or IGMP or MLD membership reports. Setting a limit to 0
> +has the effect of disabling the limit. See also the \fBip link\fR option
> +\fBmcast_hash_max\fR.
> +

I'd add that the default is 0 (no limit), otherwise looks good to me.

>   .TP
>   .BI mcast_router " MULTICAST_ROUTER "
>   This flag is almost the same as the per-VLAN flag, see below, except its
> @@ -1107,6 +1120,15 @@ is used during the STP election process. In this state, the vlan will only proce
>   STP BPDUs.
>   .sp
>   
> +.TP
> +.BI mcast_max_groups " MAX_GROUPS "
> +Sets the maximum number of MDB entries that can be registered for a given
> +VLAN on a given port. A VLAN-specific equivalent of the per-port option of
> +the same name, see above for details.
> +
> +Note that this option is only available when \fBip link\fR option
> +\fBmcast_vlan_snooping\fR is enabled.
> +
>   .TP
>   .BI mcast_router " MULTICAST_ROUTER "
>   configure this vlan and interface's multicast router mode, note that only modes

