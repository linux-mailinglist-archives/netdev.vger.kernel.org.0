Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8898660271E
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 10:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiJRIhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 04:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiJRIhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 04:37:47 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D189F745
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 01:37:45 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id a13so19460580edj.0
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 01:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WaPR/tmqWGcHhxRlM7SpojtLJcPC5mdHh5MXF3Ewvbk=;
        b=8OGa01prAdF0y4D0Uz44tSzzEmmgbLu8CCpNNBZ6LdpI+YoIkpNtWrWYfRKDEh8KCB
         bk5oGQ0yMsZ4GjqybOadty3vUndpWRk4khXdCoW85w3dsFUkL4SsZYCIGkIWqqChHoAF
         gcxmXW7THu8+MfWd3fM/GJZM1cm6coTRJ2cquKCiGo+Iv4Sex9ILtXRqWEcRKBFxePCT
         IPslvfR70QjRWwRZE7Q5E780gFbWIOXJ53O2q4IYJao76liUR26wlylXfFepiM6Fu8LG
         H9xa7DGpnweWEnBPTmk545PZgJdzWtP8PwuL8u2juBJnE4bfPAuJ6xtUbA17/0L6VnbX
         ijGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WaPR/tmqWGcHhxRlM7SpojtLJcPC5mdHh5MXF3Ewvbk=;
        b=pVf9WBApgoxG2BHW8qS1NITL6BLxE3k4YqiqYcncq4NZ0ByEI+ghMuyoys6q5/H7gT
         FPIy5/xhT1fej2io/hXZD7WnvIMhyPGxzyF+nZ9hSl8RGTJebe4NAEX578wPJSX/dU/d
         5STRRWj1zMJ1YDRmyD91/eYZbr7WkPtshBio/+eXQ8Ro25S2m87sAYcdQ+4AS5cWYX9D
         G5mRcoLz2PPqB+YJwv4S19Myi/ExUVOmmhKy1xY3IpKA2QylbAQGPy8EMqCudCZjKSUj
         bfQPJqAvNlC2ddxf/eIuv9RjDW4TMUNC9OLV2uf1ucgbg/0F3GGYXR5dxHvgskB4iqV1
         HYLQ==
X-Gm-Message-State: ACrzQf1Wub0U9k59zsZllobNh3KlUdNoFPCyLer06oEcPBpQURQSltMP
        pvyK+b98dXzQE+MRKtr47Ms9YA==
X-Google-Smtp-Source: AMsMyM6SIOcTZVNe2fyjyFBy5PanORL8OYZZduX5sfYJhmsNLOC24nC0Hqo2CvWxsX5es34+8YuPHw==
X-Received: by 2002:a05:6402:1d53:b0:45e:ec87:686e with SMTP id dz19-20020a0564021d5300b0045eec87686emr150040edb.380.1666082264334;
        Tue, 18 Oct 2022 01:37:44 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id g2-20020a1709064e4200b0077016f4c6d4sm7238813ejw.55.2022.10.18.01.37.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Oct 2022 01:37:44 -0700 (PDT)
Message-ID: <8d1c7a93-6189-dd93-f4ee-bb76282bd2c0@blackwall.org>
Date:   Tue, 18 Oct 2022 11:37:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next 4/4] bridge: mcast: Simplify MDB entry creation
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221018064001.518841-1-idosch@nvidia.com>
 <20221018064001.518841-5-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221018064001.518841-5-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/10/2022 09:40, Ido Schimmel wrote:
> Before creating a new MDB entry, br_multicast_new_group() will call
> br_mdb_ip_get() to see if one exists and return it if so.
> 
> Therefore, simply call br_multicast_new_group() and omit the call to
> br_mdb_ip_get().
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_mdb.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

