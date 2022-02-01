Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435C14A686B
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 00:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242793AbiBAXSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 18:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiBAXSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 18:18:31 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43FCC061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 15:18:31 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id v5so15869819qto.7
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 15:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KCM6JPsknp1hfrFpjrSwdUwOiL2U/leVm3A4CUTSU+c=;
        b=XmgLldcexaLTiZ8y3K5R0AbGEBngk8rpmTMVMtRqBe2IZLxom52N6m1n4M8fb2Hq/n
         pU1glky1Wd+cNnMuxnfzGjUEtENWUaVi0LdVEphqCOxLPwMtibPTXyZcGfRef0fLNpJ9
         GIEwYjY7MI8sqQIutHwaEOpDDK+qtSYR2252gtkt9l5GxFnNSDTCvzzTutGnFB6x+Xik
         MS2SQPDjCOQnuCowVSIYsDOptlTc09YpLM6SQVIufv//qC7QPtzdzA+Q6EIZuiSLCxnV
         jCeiglc7AfXBfL7r/J4aBipL00qQZv7G83J9XMsWaALDJqayijaRQGM+O3dY+MfLQy29
         gAzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KCM6JPsknp1hfrFpjrSwdUwOiL2U/leVm3A4CUTSU+c=;
        b=q2xQ3tLuXHJlhp8RVx3baF3p0S6W+WJj8texxkBdD9+JoKPKV+ZoppKmm52JkM2qjF
         bwo+Vapj5Wduetr8P/MF3GkcL3+zOXZZM8aRAEFoWLZsZMeYlaBvCMqw4kT3+G8t/0w7
         7cEWLTeUqvXm9Ibb/CaUQoZARME29awWUMR82Z551idbLkO7dyeKw1Qo3zYdqIx/1Pr7
         /nLyyopMO+APsmowaEoSnQ7E16eFa7xDZk79ZxCvWOnowoQgZpNvSK/QTQeiBTqpKZ+r
         /BbWUED7SOF7HztY8+Aab7buJnUQru3f2KmlcegeLwyV/7Dv+6BDMWDYqAKpAuqc9ZvY
         SGnw==
X-Gm-Message-State: AOAM53150qV1c1YDDDCopbMmyaUdiAz9yezPDtnAKWQVvrCxVpP9hciI
        vKgH8KqDcbzchBNNbcuUGMfTrA==
X-Google-Smtp-Source: ABdhPJyebO7jySsGBAv8h84PcmxWqImEAjccMEawWqBhXKjiHo7zODJ4JufDPfVauGk+1y1pC37zOw==
X-Received: by 2002:a05:622a:254:: with SMTP id c20mr20894781qtx.429.1643757510944;
        Tue, 01 Feb 2022 15:18:30 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id i18sm10619956qka.80.2022.02.01.15.18.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 15:18:30 -0800 (PST)
Message-ID: <0e202f7c-0558-6050-54c9-e1e28b1bfaa3@mojatatu.com>
Date:   Tue, 1 Feb 2022 18:18:29 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net-next v2 1/1] net/sched: Enable tc skb ext allocation
 on chain miss only when needed
Content-Language: en-US
To:     Paul Blakey <paulb@nvidia.com>, dev@openvswitch.org,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>, davem@davemloft.net,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>
References: <20220201175220.7680-1-paulb@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20220201175220.7680-1-paulb@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-01 12:52, Paul Blakey wrote:
> Tc skb extension is used to send miss info from tc to ovs datapath
> module, and is currently always allocated even if it will not
> be used by ovs datapath (as it depends on a requested feature).
> 
> Export the static key which is used by openvswitch module to
> guard this code path as well, so it will be skipped if ovs
> datapath doesn't need it. Enable this code path once
> ovs datapath needs it.

Why the name tc_skb_ext_tc_ovs_XXX? This is a generic feature
which could be used for other purposes within tc and outside
of ovs. Suggestion to rename to tc_skb_ext_tc_XXX

cheers,
jamal
