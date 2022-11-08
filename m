Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBBE621847
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 16:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbiKHPa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 10:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbiKHPa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 10:30:26 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D1D1ADAB;
        Tue,  8 Nov 2022 07:30:21 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id z3so11719889iof.3;
        Tue, 08 Nov 2022 07:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qy/Rc6DnHa32L0gtaQOFgQXxEk3cbk+pvK/PQRTCYSY=;
        b=Oo2wZxfd6FXyLY+R2iY6D9nOy1wF1TjeYrqrZEeWF4LQmG5EEu577pTBG6DAp+PMJM
         DkhazrPswUeWkLPSjzmq0RPLcKEPr9Wo+tB/ry+it8Xzs8pe6L8mhaqviIT32mHlESK8
         S/DNYCnf2EtbJd51S/7V0CzWSgzohfW+TyySakUIwjsYutLAG/AT+C7piZW01nhv/LeY
         zjx2ZVyCXT722THpGGzx+AcwmCZTxL24ehf6LbOeH8w9HoOkPnHBoio/4fSL3HpgViO4
         crrvW7W7VL9ntbA/mVHVgXa4EaCdawUggbVxatBvOjzGDj6ga/EXIGE5XXYnDKGasX0R
         b1zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qy/Rc6DnHa32L0gtaQOFgQXxEk3cbk+pvK/PQRTCYSY=;
        b=pBkaDUpVNTtq20USqdoWtUnboxpmJIS+O02CLCLAaOFJ4mO7+E8gO2vpz1YgFZQMMM
         aILpriyX+so+Ja9GAfXHVKTIj8m3M5J3LxjtJNXfJ/5y/oFtBDFYqeIQY36j1GUN9AQm
         oqiSFLw4zaWu2O0aOTOD8tTWU3iVzJ0Yw4ZLSRPXQzG34JHFEswS7dbb0bFt+PQPhkZ6
         g7P4Zq26m3duhmcs9jKlsWeEbC2Q9Emex7nMTzxhDyeNVXTFawkeRjLKsZ5eZCxKPHjC
         73tNq2jTT/5cyNROXDcGDhhmT2b5OJEaoiUc5l3HDeVrM+4Goo/SKzMwc3JJOgQ93ujd
         rOZg==
X-Gm-Message-State: ACrzQf0mRSZNW/4O7Ln9kgiUgbi8fy58crOTSw6QN5WCQingBDrBRJel
        5nqIxBRejmy7zZdoXzrukVWYO6SwJDY=
X-Google-Smtp-Source: AMsMyM5euKjUYWoSojhRZZsZ/Ir21fMFkCqewFaLlmc8oJgqJ+5WVjhEfCLLGd/uNNhyZI3FTngPOA==
X-Received: by 2002:a05:6602:27c1:b0:6a4:cd04:e392 with SMTP id l1-20020a05660227c100b006a4cd04e392mr33853006ios.23.1667921420963;
        Tue, 08 Nov 2022 07:30:20 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:a10c:23e5:6dc3:8e07? ([2601:282:800:dc80:a10c:23e5:6dc3:8e07])
        by smtp.googlemail.com with ESMTPSA id x13-20020a02970d000000b00365ddf7d1d8sm3749598jai.53.2022.11.08.07.30.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 07:30:20 -0800 (PST)
Message-ID: <623dbc30-2ba7-6bc8-f6f8-607d0e583171@gmail.com>
Date:   Tue, 8 Nov 2022 08:30:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH net-next v3] net/core: Allow live renaming when an
 interface is up
Content-Language: en-US
To:     Andy Ren <andy.ren@getcruise.com>, netdev@vger.kernel.org
Cc:     richardbgobert@gmail.com, davem@davemloft.net,
        wsa+renesas@sang-engineering.com, edumazet@google.com,
        petrm@nvidia.com, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, andrew@lunn.ch, sthemmin@microsoft.com,
        idosch@idosch.org, sridhar.samudrala@intel.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        roman.gushchin@linux.dev
References: <20221107174242.1947286-1-andy.ren@getcruise.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20221107174242.1947286-1-andy.ren@getcruise.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/22 10:42 AM, Andy Ren wrote:
> Allow a network interface to be renamed when the interface
> is up.
> 
> As described in the netconsole documentation [1], when netconsole is
> used as a built-in, it will bring up the specified interface as soon as
> possible. As a result, user space will not be able to rename the
> interface since the kernel disallows renaming of interfaces that are
> administratively up unless the 'IFF_LIVE_RENAME_OK' private flag was set
> by the kernel.
> 
> The original solution [2] to this problem was to add a new parameter to
> the netconsole configuration parameters that allows renaming of
> the interface used by netconsole while it is administratively up.
> However, during the discussion that followed, it became apparent that we
> have no reason to keep the current restriction and instead we should
> allow user space to rename interfaces regardless of their administrative
> state:
> 
> 1. The restriction was put in place over 20 years ago when renaming was
> only possible via IOCTL and before rtnetlink started notifying user
> space about such changes like it does today.
> 
> 2. The 'IFF_LIVE_RENAME_OK' flag was added over 3 years ago in version
> 5.2 and no regressions were reported.
> 
> 3. In-kernel listeners to 'NETDEV_CHANGENAME' do not seem to care about
> the administrative state of interface.
> 
> Therefore, allow user space to rename running interfaces by removing the
> restriction and the associated 'IFF_LIVE_RENAME_OK' flag. Help in
> possible triage by emitting a message to the kernel log that an
> interface was renamed while UP.
> 
> [1] https://www.kernel.org/doc/Documentation/networking/netconsole.rst
> [2] https://lore.kernel.org/netdev/20221102002420.2613004-1-andy.ren@getcruise.com/
> 
> Signed-off-by: Andy Ren <andy.ren@getcruise.com>
> ---
> 
> Notes:
>     Changes from v1->v2
>     - Added placeholder comment in place of removed IFF_LIVE_RENAME_OK flag
>     - Added extra logging hints to indicate whether a network interface was
>     renamed while UP
>     
>     Changes from v2->v3
>     - Patch description changes
> 
>  include/linux/netdevice.h |  4 +---
>  net/core/dev.c            | 19 ++-----------------
>  net/core/failover.c       |  6 +++---
>  3 files changed, 6 insertions(+), 23 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


