Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920D16C47D2
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 11:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjCVKkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 06:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbjCVKkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 06:40:04 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7FA474F5
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 03:40:02 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id i5so23968968eda.0
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 03:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1679481601;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a86RjZ2N63DirVpQxCCyPL1BzLxFdG6fDziwW/dj7vc=;
        b=if06j9ePnMhdle6v/guHe1KmTLtk2M9vnlEGbrcUa1su3DJpSpzToVbVUJVSA/MP82
         gzzO9txaCRPUNT3cMze6Hd/FmF42t6AB5b7ky//r8l5+vH0SnfCCHDd0ut6F1vO9tDQE
         octr9mv9UNdyo1Pd5NKrSZNa4/vdTMs8zrQPxkz2KqZAGbg1s1qON18jHyjWBVscQnZl
         7c4o3NBoIXilBcafSFT0MPtWyPMnsFYjHL8/vWeDVBk+qtk4aTPZcC31RAQ2QidMusy/
         YXtcVE9gbgCb8tWglk+n33N8/y9/Ugbz8L5AkeVXleaeP8IE0s1v72oy900CduMJ8RHr
         o7qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679481601;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a86RjZ2N63DirVpQxCCyPL1BzLxFdG6fDziwW/dj7vc=;
        b=a9S6XR1AUG423yHj7IvBaJV1vFg/ytGddMq91GfQphTwm26ak8oi8uavA27qcBDrV0
         /HXTvpc9TGX46t73Qk5vbaEPHo9i9AmdePRuRE7NftoMak9L/eqPe2XEbMVzx+8kT0el
         gGM+yR5r9qRidTX9jFYF15p7pBeJPN2MweyrMmI11XIGgtZcS9LAiMSm58WpX+VXpkkM
         HFYU8HVUvx/8JLcOUXRifN5zbIsVvRge8U0vc9SS/H2zotzm7dAQpnuM3C3ftAiUoqtk
         TGmPXg8bWzCCtyssF/T5o24M+w70GisZ48O+Lhwbd3OzhM2p8x2dp1N6ut23eN52xAC6
         rl6g==
X-Gm-Message-State: AO0yUKVi9GXq4YvNHOnb/4iiGyJl0JlnHP1gkIQRe9COJ1C6b5+i1662
        YMyRs7DILrksfKu9sW9qU0CTAQ==
X-Google-Smtp-Source: AK7set+wKHYeTHwZtpIzikB0Y6Mfz4+irSmE61FEmkGJ97E74sVd4IG1G6JRf3jz4CUj0BmlUgeLMg==
X-Received: by 2002:a17:906:3553:b0:930:ca4d:f2bf with SMTP id s19-20020a170906355300b00930ca4df2bfmr6296334eja.54.1679481601042;
        Wed, 22 Mar 2023 03:40:01 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id u23-20020a170906409700b009334a6ef3e8sm4947246ejj.141.2023.03.22.03.40.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Mar 2023 03:40:00 -0700 (PDT)
Message-ID: <e9caa256-482d-1cc0-4244-e9d4c5615f01@blackwall.org>
Date:   Wed, 22 Mar 2023 12:39:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v3] docs: networking: document NAPI
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>, corbet@lwn.net,
        jesse.brandeburg@intel.com, mkl@pengutronix.de,
        linux-doc@vger.kernel.org, stephen@networkplumber.org,
        romieu@fr.zoreil.com
References: <20230322053848.198452-1-kuba@kernel.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230322053848.198452-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=3.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/03/2023 07:38, Jakub Kicinski wrote:
> Add basic documentation about NAPI. We can stop linking to the ancient
> doc on the LF wiki.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Link: https://lore.kernel.org/all/20230315223044.471002-1-kuba@kernel.org/
> Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz> # for ctucanfd-driver.rst
> Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> v3: rebase on net-next (to avoid ixgb conflict)
>     fold in grammar fixes from Stephen
> v2: https://lore.kernel.org/all/20230321050334.1036870-1-kuba@kernel.org/
>     remove the links in CAN and in ICE as well
>     improve the start of the threaded NAPI section
>     name footnote
>     internal links from the intro to sections
>     various clarifications from Florian and Stephen
> 
> CC: corbet@lwn.net
> CC: jesse.brandeburg@intel.com
> CC: anthony.l.nguyen@intel.com
> CC: pisa@cmp.felk.cvut.cz
> CC: mkl@pengutronix.de
> CC: linux-doc@vger.kernel.org
> CC: f.fainelli@gmail.com
> CC: stephen@networkplumber.org
> CC: romieu@fr.zoreil.com
> ---
>  .../can/ctu/ctucanfd-driver.rst               |   3 +-
>  .../device_drivers/ethernet/intel/e100.rst    |   3 +-
>  .../device_drivers/ethernet/intel/i40e.rst    |   4 +-
>  .../device_drivers/ethernet/intel/ice.rst     |   4 +-
>  Documentation/networking/index.rst            |   1 +
>  Documentation/networking/napi.rst             | 251 ++++++++++++++++++
>  include/linux/netdevice.h                     |  13 +-
>  7 files changed, 266 insertions(+), 13 deletions(-)
>  create mode 100644 Documentation/networking/napi.rst
> 
[snip]
> +Threaded NAPI
> +-------------
> +
> +Threaded NAPI is an operating mode that uses dedicated kernel
> +threads rather than software IRQ context for NAPI processing.
> +The configuration is per netdevice and will affect all
> +NAPI instances of that device. Each NAPI instance will spawn a separate
> +thread (called ``napi/${ifc-name}-${napi-id}``).
> +
> +It is recommended to pin each kernel thread to a single CPU, the same
> +CPU as services the interrupt. Note that the mapping between IRQs and

"... the same CPU as services the interrupt ...", should it be
"the same CPU that services the interrupt" ?

> +NAPI instances may not be trivial (and is driver dependent).
> +The NAPI instance IDs will be assigned in the opposite order
> +than the process IDs of the kernel threads.
> +
> +Threaded NAPI is controlled by writing 0/1 to the ``threaded`` file in
> +netdev's sysfs directory.
> +
> +.. rubric:: Footnotes
> +
> +.. [#] NAPI was originally referred to as New API in 2.4 Linux.

Very nice! Other than the above looks good to me.

Cheers,
 Nik

