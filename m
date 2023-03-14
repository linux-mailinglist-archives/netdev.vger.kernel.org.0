Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353386B9224
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbjCNLwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbjCNLwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:52:38 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481F320541
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:52:14 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id l12so5794335wrm.10
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 04:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678794731;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pmNZdygJnAQ23YxPeMcptEgBWA7szbpuBbBzvQMSVCo=;
        b=UHIeTIbhvVf49zjI8NtD5Z6zlDH3+WhDYKavKzAoMJFNFURrBBrVECTacuI1buZ3Ss
         lMryy8VP8NaUyzaPbmy/jBKC6VJuvhMGAdVwqw7agzj7gDv3COpSLtoCPfn6usL5Ql2W
         cPVlfrrd2f1MVNI/BQ2GMMRzVlBkVlueDb/mfXTzr/WstTqS+fLTRzusnZbbynv7/+Se
         4o/SWQr3DznAC8AfU+lCAV2+6WSrjROYJD61mJf20mx70nRUP7PMMI1EdHF96BfKPQvY
         aCwyXJDK1eCtpvJ6146bTRVcha/ZA513ivMKsuh6RzF+DVcdpfoMWmxplJ6g/hQ8Z8l4
         0MsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678794731;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pmNZdygJnAQ23YxPeMcptEgBWA7szbpuBbBzvQMSVCo=;
        b=oYpaknOxyfYrwmNhJpstBww735HlqeStaCmlm15jMVrcDfMHsQKxudamV5GQJ9hK3M
         jOvoAWJrQ5PSRn3SqMtYqYg03Fz0MLjn9RXzl0CyVpAJ+d4c4uNajKLAtEenh6yt4oOc
         OYXJU+PN+AwnAAZFt9vyM2QNC0iD1ixhnE2ZpU2NttBPmhezpTw6zVJmcy/mGQq0W/Pf
         t4Y6rvo+TGJzvtgG+Fpbo/Lc3IhKnfPG5L7iYBRviXtaUxhCc9JLocUJY1RcGu+nCJTx
         6TLAx5ohZaZipzEy5tLBvCa+DCVryxGqAbuawL/pR+PecJdfrNF2gCivfz9Dq7G6+23H
         JU+Q==
X-Gm-Message-State: AO0yUKW8DpqPEYmgJWq2Df1nJ1ya/arg7kx9MJZ1JaAOMfShci822asO
        XKLnljh1IY7U42BDDOInIrao/Q==
X-Google-Smtp-Source: AK7set/DYsurM3Y/Ay8cF84ihvZw3WvNCmvKbtR0aCTPSMaAAh0eqqclWMa3g9wvKzxnnvl/cx3/fg==
X-Received: by 2002:a5d:4fc4:0:b0:2ce:a8dd:ba95 with SMTP id h4-20020a5d4fc4000000b002cea8ddba95mr5905894wrw.35.1678794730697;
        Tue, 14 Mar 2023 04:52:10 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id m1-20020adffa01000000b002c5526234d2sm1996376wrr.8.2023.03.14.04.52.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 04:52:10 -0700 (PDT)
Message-ID: <8300e3cf-39d7-55bd-2614-db581fcfdc65@blackwall.org>
Date:   Tue, 14 Mar 2023 13:52:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 05/11] vxlan: Move address helpers to private
 headers
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230313145349.3557231-1-idosch@nvidia.com>
 <20230313145349.3557231-6-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230313145349.3557231-6-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2023 16:53, Ido Schimmel wrote:
> Move the helpers out of the core C file to the private header so that
> they could be used by the upcoming MDB code.
> 
> While at it, constify the second argument of vxlan_nla_get_addr().
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  drivers/net/vxlan/vxlan_core.c    | 47 -------------------------------
>  drivers/net/vxlan/vxlan_private.h | 45 +++++++++++++++++++++++++++++
>  2 files changed, 45 insertions(+), 47 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


