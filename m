Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D5F5BDECA
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 09:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiITHuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 03:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiITHuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 03:50:08 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3426BDA
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 00:49:29 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id bq9so2875212wrb.4
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 00:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date;
        bh=M6+ne4OFKqc2mKK0wgRF6R/AO4uBhWAl+SeCBkxb194=;
        b=T1VA8FNm+ynrkpHjD70GZE1SFBOPeLxjYfo+0xvj1oSqPS0xUluytok2jm8QWvq/dl
         BQGjmPPjdv0mQKdJqX2q2P4ndl1YilSeEDcMppKIza+p7J8S7XnkCssKTT0bF/gnv15S
         DW4KC/g1Hr1BytfL/Mak9/ZhoSHgQ76GPgx9SDR8lnWYDOLHCEiUJOrbSKY/6A1Xwax2
         XXr2SOsG6AdPdhiXd6oEpTK857P7JFma0JdutIpKaHwQGxGqMF+KljRFd40gX51KZak9
         lk5IbS+n6B59cPPs4PdeWqf03WwCbw4z669TWnXCD+OHV/n/tt7CHyZptl2GrMuBt/l4
         VSVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=M6+ne4OFKqc2mKK0wgRF6R/AO4uBhWAl+SeCBkxb194=;
        b=q6NO6c1LYY6n58tvtQSPKiJz+zPyrK29Y/3jocqKx5bdoRCd4vAFos3GevmE1pOxo9
         zcEccVAA/Mt4uGgSNtzUpfqO447DL5IBbzGDEMySfWH3cSmNUxxNxT+3y2zAQuMrP6Pb
         oBCBsMwGx5BDC0thy0yMGLeujZrsFtKqED50uAvMGNzbknNnc2QI3WvTefI7N90cWKEx
         K2nq7HcQYRDFnvdCGb7ae+WambBFcIimJfCmnqgVMIVkrd36h/hw32VT6W46C6pJ/76g
         wS0yxltoFgzIKecTeSRdmMBZq6EsR4bTlTNw37LTfKm09kRzpho0iQEuh+wZVSbtxvSN
         a6yA==
X-Gm-Message-State: ACrzQf26cZCQ4JSf54jkJ6hPTtLHCLn7TFf03sA7t2oDREUvKOMdoNH3
        7u2eKNJQ5q3DrjR6enm6c3hr89FcjeRvpw==
X-Google-Smtp-Source: AMsMyM78ynE1NLC0tTzLR91DvF2v43osaTx4a+H7Cjq9r8jkqJQdZOha14Xcr4/4xHlLNO2lc2jV3w==
X-Received: by 2002:a5d:5312:0:b0:228:cc9e:b70f with SMTP id e18-20020a5d5312000000b00228cc9eb70fmr13263142wrv.11.1663660168186;
        Tue, 20 Sep 2022 00:49:28 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:ad91:24d8:d1d3:3b41? ([2a01:e0a:b41:c160:ad91:24d8:d1d3:3b41])
        by smtp.gmail.com with ESMTPSA id t1-20020a05600001c100b0021e51c039c5sm801894wrx.80.2022.09.20.00.49.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 00:49:27 -0700 (PDT)
Message-ID: <0198618f-7b52-3023-5e9f-b38c49af1677@6wind.com>
Date:   Tue, 20 Sep 2022 09:49:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v4 04/12] net: netlink: add NLM_F_BULK delete
 request modifier
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org
References: <20220413105202.2616106-1-razor@blackwall.org>
 <20220413105202.2616106-5-razor@blackwall.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220413105202.2616106-5-razor@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 13/04/2022 à 12:51, Nikolay Aleksandrov a écrit :
> Add a new delete request modifier called NLM_F_BULK which, when
> supported, would cause the request to delete multiple objects. The flag
> is a convenient way to signal that a multiple delete operation is
> requested which can be gradually added to different delete requests. In
> order to make sure older kernels will error out if the operation is not
> supported instead of doing something unintended we have to break a
> required condition when implementing support for this flag, f.e. for
> neighbors we will omit the mandatory mac address attribute.
> Initially it will be used to add flush with filtering support for bridge
> fdbs, but it also opens the door to add similar support to others.
> 
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> ---
>  include/uapi/linux/netlink.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
> index 4c0cde075c27..855dffb4c1c3 100644
> --- a/include/uapi/linux/netlink.h
> +++ b/include/uapi/linux/netlink.h
> @@ -72,6 +72,7 @@ struct nlmsghdr {
>  
>  /* Modifiers to DELETE request */
>  #define NLM_F_NONREC	0x100	/* Do not delete recursively	*/
> +#define NLM_F_BULK	0x200	/* Delete multiple objects	*/
Sorry to reply to an old patch, but FWIW, this patch broke the uAPI.
One of our applications was using NLM_F_EXCL with RTM_DELTFILTER. This is
conceptually wrong but it was working. After this patch, the kernel returns an
error (EOPNOTSUPP).

Here is the patch series:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/?h=92716869375b

We probably can't do anything now, but to avoid this in the future, I see only
two options:
 - enforce flags validation depending on the operation (but this may break some
   existing apps)
 - stop adding new flags that overlap between NEW and DEL operations (by adding
   a comment or defining dummy flags).

Any thoughts?

Regards,
Nicolas
