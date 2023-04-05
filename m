Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A75D6D7879
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjDEJfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbjDEJfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:35:23 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A721559F9
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:34:56 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id r29so35490484wra.13
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 02:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680687251;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=55wOMBrYYlMNWfSOGfx3NZmYbk7jBlW3jtQEtn3JIWk=;
        b=AXr2Aj9NQFWOTkGE/rMU+jvXA4LyJIdKQjUzkzHOc4stuOTuXVg27i2RxJvafzhUb9
         TxqmsnlOJhw8vGQSEX/3+i2hNvjEagYuEIH9y0b7EH+2+nWDij61ViUKEPMcrRH20azw
         9TeCrV+jEr107tHzTWZtt2b5uG4dpwU1Y8DwXfSrHw4O7gqHj+RwW69VrmPfxG0V+jsZ
         u9usZUY/45ZMRRuK5sjvAlKp4TlGSRybxAPGKOb/swxUvMmOj8Ua4qOmKmAL/Kn1A9p1
         KBU7dKFwoQmmSvbwdih4juxO0+D3be05oBlrEIomftfpbeHnvfznaZrwn3RD5fEkcHAU
         WWDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680687251;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=55wOMBrYYlMNWfSOGfx3NZmYbk7jBlW3jtQEtn3JIWk=;
        b=dhDjrs4jObRXZ09JM/Ih8HXQs8nC69BYUCcO+tds07p92vdWhcFnSLXtMpzyA5oU2W
         pLQK3en07mTlb0Blj9Lgxw/iYO+ltB2aKuodatUIJYbu4BvDKbaqpHa73y0z60ksXF+B
         rCtWH51oXfU00qICwtLpYsOnr8w7cjbp2+pK4lWTMxt1/eiDyj4FmEXVuh3TR+Mj5RS7
         LgXjWcjLiH7wS+GIaJScV3W6WTQjyJ9OK5IKRMA7fvCxm2XIXeLH0iA8c07L/2/jju8u
         KYJvd5WGwdqwnXQT6sAWytDp7O5Fm4Kwo/9oZ+kY5tSZV+ANFYmNYALrZ0m7paYMtVlE
         wy6w==
X-Gm-Message-State: AAQBX9e8EF9xcpLdZxpGcHJxEyaWqSB/+kZ0HnB98lpO7XuaMJCkp4O0
        ghyOgkuFStt+NKxqu9bFAnQ=
X-Google-Smtp-Source: AKy350Z2YCjhS3jaadiqfEWv/22cXEV4aaOvcSb6qpFpBTca72btGFb4nASL108SEfokN/DMYiddwg==
X-Received: by 2002:a5d:6609:0:b0:2ce:a74f:3253 with SMTP id n9-20020a5d6609000000b002cea74f3253mr3418903wru.70.1680687250704;
        Wed, 05 Apr 2023 02:34:10 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id x18-20020adfdd92000000b002d64fcb362dsm14493200wrl.111.2023.04.05.02.34.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 02:34:10 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 2/6] net: ethtool: record custom RSS contexts
 in the IDR
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     edward.cree@amd.com, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, habetsm.xilinx@gmail.com,
        sudheer.mogilappagari@intel.com
References: <cover.1680538846.git.ecree.xilinx@gmail.com>
 <57c0a5a7d41e1341e8a7b0256ca8ed6f3e3ea9c0.1680538846.git.ecree.xilinx@gmail.com>
 <20230403144839.1dc56d3c@kernel.org>
 <cfaa6688-125f-9f2e-805a-ce68281d60d2@gmail.com>
 <20230404164050.1a2a5952@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <d41dfe33-0811-4db5-eda6-89820b3d3ac5@gmail.com>
Date:   Wed, 5 Apr 2023 10:34:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230404164050.1a2a5952@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/04/2023 00:40, Jakub Kicinski wrote:
> On Tue, 4 Apr 2023 12:49:18 +0100 Edward Cree wrote:
>>> GFP_USER? Do you mean it for accounting? GFP_KERNEL_ACCOUNT?  
>>
>> It's an allocation triggerable by userland; I was under the
>>  impression that those were supposed to use GFP_USER for some
>>  reason; the rss_config alloc further up this function does.
> 
> That's what I thought, too, and that it implies memory accounting.
> But then someone from MM told me that that's not the case, and
> that GFP_USER is supposed to be mmap()able. Or maybe the latter
> part I got from the kdoc in gfp_types.h.
> 
> I think we should make sure the memory is accounted.

Okay.  Presumably this doesn't apply to `rss_config` because it's
 short-lived (freed on the way out of the function)?
(In which case I think `rss_config` should just be GFP_KERNEL;
 we don't try to map it to userspace, we just copy_{from,to}_user
 between it and the ioctl data.  But that's unrelated cleanup
 which we can worry about later, if at all.)
