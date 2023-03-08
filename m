Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45DBA6B0D69
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 16:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbjCHPxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 10:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbjCHPw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 10:52:59 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0981DB1
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 07:52:56 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id j19-20020a05600c1c1300b003e9b564fae9so1641123wms.2
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 07:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678290774;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MDZ/hTb61KfwEIwAdlKV3weJ7qnh1qKDio05sZM4ofk=;
        b=c7AmT6pL4VdimZKAD9iXlSWqmhP6F1pBUPBJZzPUHp/1lYC35BbECrNlTQrOPttkf7
         yr3vgk3U+/GJ7T2/iM2C56BBGk1bAk64WQ6O25UwvgeqnZ43uql+S2Vw5xtcwfrkjpvb
         rnrHnAzkW392HeOCw7+RlDyMVLPdCQurW+8/FA1Oyxxv4YjALAU+ybxAQiPc5rPw6xMb
         FInBPfw+FYb6wNiB9nJY7gQxPVtDSXZrx92r1fLSoHt77Rx2DqmMp+mbcp6cdbFuhwq+
         4Z6JIMhVMriV+6V/PujXCm4vuZQzLbLFdi4iGoYNSLWNvQptZV6ZkMdUABlG54ebwgVl
         rD4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678290774;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MDZ/hTb61KfwEIwAdlKV3weJ7qnh1qKDio05sZM4ofk=;
        b=r93dSciVmbaur5B0IQnYCqH97erNzkaz/wr8U6K0i7YD5PDgEwAbOdU9xO+AHUwocX
         nQBj7pJpvZbm5k+nwas7nz40NpA5KGGfhDweN94YU5Svt3O4y03Iv26i750w6cJaT6sz
         AhggTA5u600DefIBSJbvtSOh7cxe9LSTyFeRfzX0rbWrT/pY4/EM4Ogx43rvvBTKWTpp
         1RbmnJY6QsCwEivuHTsM3i+E6aJFTP0bmYTKa6/SJVcxgESPIy1URxTKDeLkWASTnAAO
         hDcs+RHSG0AoIbF/CWCDcBsKHqlv3vSWZ5VFym/GTyO9t0cBUCNyWz3IRrxv+LWvC/9R
         xfdA==
X-Gm-Message-State: AO0yUKXk3tT90YNJOVntkhtadMP69AX+OytmPCv+49kUQ/iKCzeDOQI/
        XsiH5+qfpnimGLWe00G7duc=
X-Google-Smtp-Source: AK7set+V8oa+xehk4l/jYD6OfEY2pPibdhPa5fTLnewJtpK/yieRn0uxukG2Rey7Crbfgh/tWxoSbw==
X-Received: by 2002:a7b:ca59:0:b0:3eb:966f:5811 with SMTP id m25-20020a7bca59000000b003eb966f5811mr13598466wml.3.1678290774409;
        Wed, 08 Mar 2023 07:52:54 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id f18-20020a05600c43d200b003dec22de1b1sm15797663wmn.10.2023.03.08.07.52.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 07:52:54 -0800 (PST)
Subject: Re: [PATCH net] sfc: ef10: don't overwrite offload features at NIC
 reset
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Tianhao Zhao <tizhao@redhat.com>,
        Jonathan Cooper <jonathan.s.cooper@amd.com>
References: <20230308113254.18866-1-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <ddf82062-8755-1980-aba7-927742fed230@gmail.com>
Date:   Wed, 8 Mar 2023 15:52:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230308113254.18866-1-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/03/2023 11:32, Íñigo Huguet wrote:
> At NIC reset, some offload features related to encapsulated traffic
> might have changed (this mainly happens if the firmware-variant is
> changed with the sfboot userspace tool). Because of this, features are
> checked and set again at reset time.
> 
> However, this was not done right, and some features were improperly
> overwritten at NIC reset:
> - Tunneled IPv6 segmentation was always disabled
> - Features disabled with ethtool were reenabled
> - Features that becomes unsupported after the reset were not disabled
> 
> Also, cleanup a bit the setting of other features not related to
> encapsulation. Now that Siena devices are unsupported, some checks are
> unnecessary because they're always supported in all ef10 models.

Could you clarify what checks were removed?  All I can see is the
 'NETIF_F_TSO6 requires NETIF_F_IPV6_CSUM' check, and Siena already
 supported NETIF_F_IPV6_CSUM (it's only Falcon that didn't).
Or are you also referring to some items moving from efx.c to the
 definition of EF10_OFFLOAD_FEATURES?  That's fine and matches more
 closely to what we do for ef100, but again the commit message could
 explain this better.
In any case this should really be two separate patches, with the
 cleanup part going to net-next.
That said, the above is all nit-picky, and the fix looks good, so:
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
