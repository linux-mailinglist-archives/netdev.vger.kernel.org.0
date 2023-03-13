Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAE16B7938
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 14:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjCMNmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 09:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjCMNmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 09:42:13 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6578462D9E
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 06:42:04 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id q16so11369122wrw.2
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 06:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678714922;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RhjHJBnam+mAiyjkCppW94+bwBEENAyEUbj4u0UUHGw=;
        b=u8kSOiCxamEX/o2dNIfn76IACrRExQbgI20PcUKgLOT21daGswIYkH7y4e705qHc84
         KZoACiq5OzPYZxs4Cs7L1OdfdY+i8tAgR55nay0/NfcPugriZ8dTNOtbMTqUE+TnS00o
         00PNiJ0hHEvg67LI/EDAHieU5ceud3+G2T3A+wmhmXwcVjw0fKjWdzHHCGwO89kwQRf4
         8kAJw46yBAFIEKB+F8g6LoFyrnEe2JWdIXwG2VgXT/G80QV3Z0ZVrTZDdTY2fLeJcLYe
         Ov2aEBhudcjUMxOttyRVP26K2YY+/uaOygNHRu7ErezMfb9CnAbc8VZfaW2uidhDn2OV
         94qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678714923;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RhjHJBnam+mAiyjkCppW94+bwBEENAyEUbj4u0UUHGw=;
        b=daibrRR9nsLtZkaNZ8YQ1QvXVCWZApWFwoZEM6lHV3zcwfkU7lnwazDdJBNrYoAM9E
         R9Tq+iQ7hYO2wfnthH4UuatcctzoFPME8ZQN95h1kBLGSkfB0EDmwFcdVMPH0fbQyxsD
         rHLFgntLWKrbmPfiMSdEe0dmb9AR5TjRyXxYMOVPAQ3YahhN6IapJcRLENdjizjLPUP9
         +jPIenF28auGs1D2/9zuuCvtccwdVrvCKUdbOYlLR/8jDGIAf0IGSfwAlDXTYGx8iUqG
         0M+MPIL6/89hob8ODNWhZqyg7/yQoNIiMzOSwgt3AtQ6dR0GKLeqpZVctsjwcGZqwlJ7
         ZeOA==
X-Gm-Message-State: AO0yUKXAMDSbeT0prhLXxQrSfoh+dcUoBWVdgQIZKF+0SszTsK5HMINt
        9u/1/091kzZFoZzS2mgyfWpm4g9M4n4h2WDo+Qw=
X-Google-Smtp-Source: AK7set+/c786VIH8IVDv7VAuTxHlmUWpQK8GNqr4nYBxGqOk8sKEc5STEMei7I8BiVbu6TfZgYeMHA==
X-Received: by 2002:adf:f446:0:b0:2c7:ae2:56df with SMTP id f6-20020adff446000000b002c70ae256dfmr21111847wrp.70.1678714922646;
        Mon, 13 Mar 2023 06:42:02 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id p6-20020adfce06000000b002ce72cff2ecsm8011778wrn.72.2023.03.13.06.42.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 06:42:02 -0700 (PDT)
Message-ID: <e87c9c3d-2235-7800-e1ce-8495efdc0284@blackwall.org>
Date:   Mon, 13 Mar 2023 15:42:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net 0/2] bonding: properly restore flags when non-eth dev
 enslave fails
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     syoshida@redhat.com, j.vosburgh@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
References: <20230313132834.946360-1-razor@blackwall.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230313132834.946360-1-razor@blackwall.org>
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

On 13/03/2023 15:28, Nikolay Aleksandrov wrote:
> Hi,
> A bug was reported by syzbot[1] that causes a warning and a myriad of
> other potential issues if a bond that is also a slave fails to enslave a
> non-eth device. Patch 01 fixes the bug and patch 02 adds a selftest for
> bond flags restoration in such cases. For more information please see
> commit descriptions.
> 
> Thanks,
>  Nik
> 
> [1] https://syzkaller.appspot.com/bug?id=391c7b1f6522182899efba27d891f1743e8eb3ef
> 
> Nikolay Aleksandrov (2):
>   bonding: restore bond's IFF_SLAVE flag if a non-eth dev
>     enslave fails
>   selftests: rtnetlink: add a bond test trying to enslave non-eth dev
> 
>  drivers/net/bonding/bond_main.c          |  8 +++++-
>  tools/testing/selftests/net/rtnetlink.sh | 36 ++++++++++++++++++++++++
>  2 files changed, 43 insertions(+), 1 deletion(-)
> 

Self-NAK, apologies for the noise. I'll send a v2 with the selftest adjusted to
always to attempt a cleanup after printing the errors regardless if the system hangs.

