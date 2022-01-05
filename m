Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF617485523
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241164AbiAEO5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236073AbiAEO5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:57:40 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736ADC061212
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 06:57:39 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id r6so37713106qvr.13
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 06:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yHRC+n7KfqJll0c3p2GADFBTnmdDv9NiCyW3ZQuwYes=;
        b=H5HApHKJhmIXKeSkIKMImWWc7AGyXDoU9Z2qhvtGiKdz4ba8Og872MONh0cXFYCoXi
         3Jt6mMr5cAtLj5EGIfPRkfRXiOzJ9pv+bRVkNX8wWaRvvBU3i5us2dcxV8bIM2qHnrsj
         GzGDPZvDd44D8oBJ1mRnCHzwjDzsqfDXEEAac138McZc8GSWeIZsmgVRk1b+19dta5HV
         PC6JsPFBKfaWktRgMr2Wz0MND3VOZ34ayTZHNtSlmK3korA4x4BO+fNKnRHV10Ol9b9X
         NzOPxjR5tJgHjokEx+RRviXvR4ibUED2ZE5VSSUkQalZ3VZHnwcD8NnC9MBouDxXxdgM
         /FpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yHRC+n7KfqJll0c3p2GADFBTnmdDv9NiCyW3ZQuwYes=;
        b=43y4ZKypWvhTxvoyvn3pGl4039K0nfCXK+PR3TfC6I90W0mGku6Wzj2JTsq5Rhpc2o
         kKTP/i90LOw++VVsiEo8l/eWQzh8OaF2g7d1BwjpFVn8QvmUiX7OeNFGMhCpSflXSPkg
         bnRjQXWjU6Wte//n25XjPGTgDHhDpA1uKTZGQw7y3+ASsTCCTnzaB0voiUxNTN7H7cgh
         ghrYHE02RxVDTJnovCK3I6GFeSHF3vdlU3sbg/qcWqjzs6jm2L4zkyQNuD7E0etlQzGa
         J8DJ1tOuT1wsyyykKRpa83lVZAOp6M4DahCQlCZqp4ka8DTX85jWgWatOJiAFtM6V3Ut
         G4ug==
X-Gm-Message-State: AOAM532Fqw58eMupRQOuQhOE3AYS9cFunKNHZEqrykob3lBXiF8pwXP/
        wsboK3EZfn4vanjk+P+OjeUYbA==
X-Google-Smtp-Source: ABdhPJxFRzemxk4aT7X+8181H98e3PQiGIzX5bUNT/MlZVpNdCCH7cVg+0DjYjQTKnQKiuxSug8E9w==
X-Received: by 2002:a05:6214:2483:: with SMTP id gi3mr51200506qvb.15.1641394658595;
        Wed, 05 Jan 2022 06:57:38 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id h13sm37287607qtk.25.2022.01.05.06.57.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 06:57:38 -0800 (PST)
Message-ID: <776c2688-72db-4ad6-45e5-73bc08b78615@mojatatu.com>
Date:   Wed, 5 Jan 2022 09:57:37 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net 1/1] net: openvswitch: Fix ct_state nat flags for
 conns arriving from tc
Content-Language: en-US
To:     Paul Blakey <paulb@nvidia.com>, dev@openvswitch.org,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>, davem@davemloft.net,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>
References: <20220104082821.22487-1-paulb@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20220104082821.22487-1-paulb@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-04 03:28, Paul Blakey wrote:
[..]
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -287,7 +287,9 @@ struct tc_skb_ext {
>   	__u32 chain;
>   	__u16 mru;
>   	__u16 zone;
> -	bool post_ct;
> +	bool post_ct:1;
> +	bool post_ct_snat:1;
> +	bool post_ct_dnat:1;
>   };


is skb_ext intended only for ovs? If yes, why does it belong
in the core code? Ex: Looking at tcf_classify() which is such
a core function in the fast path any packet going via tc, it
is now encumbered with with checking presence of skb_ext.
I know passing around metadata is a paramount requirement
for programmability but this is getting messier with speacial
use cases for ovs and/or offload...

cheers,
jamal
