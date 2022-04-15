Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F0750264B
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 09:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351160AbiDOHlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 03:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351162AbiDOHlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 03:41:32 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B4F4B1F8;
        Fri, 15 Apr 2022 00:39:05 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id bg9so6725703pgb.9;
        Fri, 15 Apr 2022 00:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7Z7mILpiEbIhXnxkIbIQrTgZVr/aE/tpgfsOP60J5fQ=;
        b=Ek/ooZ8zbGOpq4ldLwkfi6X2KgZZv1HnzYWGJx53dOVtA2RnkzoFq8zSKz79lYnl9P
         f3jNoGwOxUruO3I2wH4hFmEHqV5a0OnfwYJWFFN0lzo0RB7hL3WEPXMgABIx9K8k93Up
         Br/YK5YtXXUAaxQdLDEp7rUVapHh4pccxlM74DotEOP7p1zeCoiTCbNxB1eV8DOvUA/D
         C+slidK0jKPCwqw09Rn5/QoHQzWrlfQnRtQGALkEovDUZ1ZOR53/2cusntn1keEvYN6j
         ndzUiUWPAge7IwdrArw3d0O2aaZX3deH5MGNwfz6iz0ewBrSf+1A4NgvyjK4LEtZZGJd
         usEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7Z7mILpiEbIhXnxkIbIQrTgZVr/aE/tpgfsOP60J5fQ=;
        b=APtBI3OypXhmT3fxB//SXnrnqyJtVWAGpJvF4pV61sFIyObUKYfBU9/7Xq2hbPMrN0
         GXfaja0dAVinE22jxLGifxphEdbljclvKBlhQv9gpPHB7yAvq38NDzBp28M6Ck+9+Nk0
         hDOobMoU4DT9IdJveWlo5Ba9uBmiVHXLffATi998L5JxZDCng/4RRK7A0em5Q57r1tgs
         NMa1tnTnHcK8eRAboT+DVQ9zQ2MG35dnBFbgK9UpbXGujEhntMqH3EXUyHDhnnqdkpm3
         F3NBNPhvHvTsX9CO/t+rJDLmqjdJ17/BV3nCZEfmgtKGJQksAq3uDYrxpCEAnoIa/mlc
         qdcA==
X-Gm-Message-State: AOAM531tRCE3kMy1KXl6TMpp/ReMtHaRnyI4mK8WHNpg8lC1n7o4Ntoj
        DBZ0qd/6vVYalh9bAATgRfU=
X-Google-Smtp-Source: ABdhPJx/mFPNudIZ2y6RfMDEwj4GDSKSQpBB7GQigl3sdT8UsSdsiuEBHlCdzEa+tF35zyGcTAiJoA==
X-Received: by 2002:a63:a804:0:b0:398:e7d7:29ab with SMTP id o4-20020a63a804000000b00398e7d729abmr5294823pgf.138.1650008344416;
        Fri, 15 Apr 2022 00:39:04 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-30.three.co.id. [116.206.28.30])
        by smtp.gmail.com with ESMTPSA id y8-20020aa78f28000000b00508225493ddsm1925680pfr.80.2022.04.15.00.39.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 00:39:03 -0700 (PDT)
Message-ID: <4586921d-5fc4-b63f-8264-a6fd63c592b6@gmail.com>
Date:   Fri, 15 Apr 2022 14:38:58 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net-next v5] net/ipv6: Introduce accept_unsolicited_na
 knob to implement router-side changes for RFC9131
Content-Language: en-US
To:     Arun Ajith S <aajith@arista.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, prestwoj@gmail.com, gilligan@arista.com,
        noureddine@arista.com, gk@arista.com
References: <20220415054219.38078-1-aajith@arista.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220415054219.38078-1-aajith@arista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/22 12:42, Arun Ajith S wrote:
> +accept_unsolicited_na - BOOLEAN
> +	Add a new neighbour cache entry in STALE state for routers on receiving an
> +	unsolicited neighbour advertisement with target link-layer address option
> +	specified. This is as per router-side behavior documented in RFC9131.
> +	This has lower precedence than drop_unsolicited_na.
> +
> +   ====   ======  ======  ==============================================
> +	 drop   accept  fwding                   behaviour
> +	 ----   ------  ------  ----------------------------------------------
> +	    1        X       X  Drop NA packet and don't pass up the stack
> +	    0        0       X  Pass NA packet up the stack, don't update NC
> +	    0        1       0  Pass NA packet up the stack, don't update NC
> +	    0        1       1  Pass NA packet up the stack, and add a STALE
> +	                        NC entry
> +   ====   ======  ======  ==============================================
> +

Hi,

Building htmldocs with this patch, there are no more warnings from v4, but
I don't see the table above generated in the output. I guess due to
whitespace-mangling issues on your mailer, because the table syntax alignment
(the =-s) don't match the contents/cells. 

Thanks.

-- 
An old man doll... just what I always wanted! - Clara
