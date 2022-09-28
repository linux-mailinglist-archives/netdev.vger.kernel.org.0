Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D9D5EE837
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 23:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbiI1VU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 17:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233190AbiI1VT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 17:19:57 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E70A24089
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 14:17:46 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id lh5so29715884ejb.10
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 14:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Oo3pTBFbghH6fXAnXoz6Anl2gYlbKkWw8ek9n4LJAgI=;
        b=pc9dAxxTDbyTPRYWIJoZ4JXsUuYzYh5g5WdDZzGvJfby9UPJMYLPOvUNHa/NK2d7kl
         ctg0Rt6hWloqKchvBVAvxui07UWlkwdeR94PpRtme8S2M0sT5qt9Gu4U9cMBRqVWs4Q6
         2v15+BL/DpbagzGpAPZJHcZrVoX65Xx56XcSFlIOOPOUw2lYJ9joYQkno5L1By1OTiyK
         LLHhOOPE0wOdFLcrZHz2PFX2OrTTY+idtt2tOObfJD9Pygqdx3Q0tQbxogOA0bWnmzCc
         rZXxKXgOrXiuHT6XH2VxPtxyjesD6gawwq6zh/SPQdMVyyONfsDZmjf/yPUuHkiYeLuQ
         UTdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Oo3pTBFbghH6fXAnXoz6Anl2gYlbKkWw8ek9n4LJAgI=;
        b=HcjxjdoZ9WKMd09xoVkkGyqCQvx6kD2KqMN6toDtc87pZaiCqo/+1Pu2NoBEYIwlC4
         xEK6bWBRMnqI4FVPznbH7OOnHKjyNGwgSYSUPW10bI+tjpqQGRFBQw74qka4OiWsaeYr
         TpsHOTeGV06BckfI3K02I5ARYjk9HBG6NnD3HO73DLWs8hf7SbrQqw5YjkCoChS4vFdv
         MNtNFkNE+bZ1ZSQejrQl69dbkFctg74YAbWJBk3KiXqGbLnlLVIVy3+NVx6J7xFH1C65
         EMMmj6CBJkNh0mZbn4E/Zv3QPv3hj6d+Roleoj6QIDkvp/UntI26k7H54xAgh/1bFXSx
         jV5g==
X-Gm-Message-State: ACrzQf0MMMWr6qfxU7gDhnXRdFgyytUATEic02lB8XYKrqKymrgcdpFD
        pKbb4YaYmW/ReTLJZoZit+7F4Q==
X-Google-Smtp-Source: AMsMyM5SYKzoHq4fwx5Ud6TO6ZvFm5FZ+jn4m+dZP4wCzyUTuPoQ6eafa5iVwOw/rFyOOxO8wH1kLQ==
X-Received: by 2002:a17:907:da2:b0:782:b6a:326d with SMTP id go34-20020a1709070da200b007820b6a326dmr28985715ejc.429.1664399864611;
        Wed, 28 Sep 2022 14:17:44 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id n20-20020a05640206d400b0045467008dd0sm4068755edy.35.2022.09.28.14.17.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 14:17:44 -0700 (PDT)
Message-ID: <4676ee24-9c98-5ca7-3fe0-2793d46592c0@blackwall.org>
Date:   Thu, 29 Sep 2022 00:17:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net] genetlink: reject use of nlmsg_flags for new commands
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Guillaume Nault <gnault@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
References: <20220928183515.1063481-1-kuba@kernel.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220928183515.1063481-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/09/2022 21:35, Jakub Kicinski wrote:
> Commit 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
> introduced extra validation for genetlink headers. We had to gate it
> to only apply to new commands, to maintain bug-wards compatibility.
> Use this opportunity (before the new checks make it to Linus's tree)
> to add more conditions.
> 
> Validate that Generic Netlink families do not use nlmsg_flags outside
> of the well-understood set.
> 
> Link: https://lore.kernel.org/all/20220928073709.1b93b74a@kernel.org/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> CC: Florent Fourcot <florent.fourcot@wifirst.fr>
> CC: Nikolay Aleksandrov <razor@blackwall.org>
> CC: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> CC: Johannes Berg <johannes@sipsolutions.net>
> CC: Pablo Neira Ayuso <pablo@netfilter.org>
> CC: Florian Westphal <fw@strlen.de>
> CC: Jamal Hadi Salim <jhs@mojatatu.com>
> CC: Jacob Keller <jacob.e.keller@intel.com>
> CC: Guillaume Nault <gnault@redhat.com>
> CC: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/netlink/genetlink.c | 32 +++++++++++++++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)
> 

Thanks!
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>



