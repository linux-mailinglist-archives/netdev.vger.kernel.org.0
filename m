Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213353DEA24
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 11:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbhHCJ6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 05:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234772AbhHCJ6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 05:58:09 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6780C06175F
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 02:57:57 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id c9so19275842qkc.13
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 02:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DYWmYVwjqxa9rp2biji+L+ue4mqPJ7j9GqrDjWUg1NY=;
        b=eyrkz1+ER5aQesayMV6wjRZuFoWWpzrNKSWC2u1LVPMFVLqUggDWIuOp1hp60xWsK9
         hIuqrf+CZkxX474H3nAXUXmgTED3olU/jqkYrOamaiejW8RYd38E8p2wqCXUw/G6fIGS
         KfTy7QABNW3DrttPaeIMv3Ds35FGNeCVKkfHOBwck4gCw+vzcxIoWb3orEZL0fGV/yEc
         769X1wT3UMfmK5MYrM+140CWdOR01I5EgoLc6lKitYTxyu/u3C0u3dJHvTSm7TDF95tx
         EktTMlCCRpEMVXalWVU6a2eQkM7KLNpTfb58MuixnUDTmN4yBwE6RJJpraGLilh48lKo
         nqLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DYWmYVwjqxa9rp2biji+L+ue4mqPJ7j9GqrDjWUg1NY=;
        b=DmCynVEkDHgPMG1J29Pus3AS9ZFSvMWMmelzyVNVs5hTbTCzHSjMylPh+ctgVkC5Bu
         oOlv9d6Wc/hDZEC1bJM0IseMvL+H2dXgZGLS/qI+rPUmqFXB2KSRAhiTQlwuDc77taSQ
         /N3dElfLDjeL1m87vetFuvallsFez7rCs31Xikop2NtTGvTUSYUqi3g4Q0qypnkvuqe1
         CYnbZg9WtBCoHMW8K3zwlWfdo3yfZZyAyh6OMzhxVH9iQUT5fw5yGLBfBpAVxRTAvgQw
         XWRvraleDPdL1lzGmdgah9tm8mE+x1mVURieNCn2VAzCHeFB/ANNRRNbE7mKxk47Drdu
         J1pw==
X-Gm-Message-State: AOAM532Lqc+uVerEs4KU8q0AzNEVeNe3vQ/xl/h7fS/vgJnSA4DShrj2
        YIe2FLdJDny9eHR+LyEdshuFdA==
X-Google-Smtp-Source: ABdhPJxIdQQTgepYu+aBZvknRiGpfoOnlRNwhCwMEFOfY1V+w2SSX70sRhAKdQ04aicbuXhLeFBlNw==
X-Received: by 2002:a05:620a:1274:: with SMTP id b20mr19955787qkl.376.1627984676971;
        Tue, 03 Aug 2021 02:57:56 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id h7sm5898423qtq.79.2021.08.03.02.57.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 02:57:56 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Roopa Prabhu <roopa@nvidia.com>
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-2-simon.horman@corigine.com>
 <ygnhim12qxxy.fsf@nvidia.com>
 <13f494c9-e7f0-2fbb-89f9-b1500432a2f6@mojatatu.com>
 <20210727130419.GA6665@corigine.com> <ygnh7dhbrfd0.fsf@nvidia.com>
 <95d6873c-256c-0462-60f7-56dbffb8221b@mojatatu.com>
 <ygnh4kcfr9e8.fsf@nvidia.com> <20210728074616.GB18065@corigine.com>
 <7004376d-5576-1b9c-21bc-beabd05fa5c9@mojatatu.com>
 <20210728144622.GA5511@corigine.com>
 <2ba4e24f-e34e-f893-d42b-d0fd40794da5@mojatatu.com>
 <ygnhv94sowqj.fsf@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <31fb2ae6-2b91-5530-70c8-63b42eb5c39d@mojatatu.com>
Date:   Tue, 3 Aug 2021 05:57:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <ygnhv94sowqj.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-30 7:40 a.m., Vlad Buslov wrote:
> On Fri 30 Jul 2021 at 13:17, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>> On 2021-07-28 10:46 a.m., Simon Horman wrote:

> 
> Filters with tunnel_key encap actions can be offloaded/unoffloaded
> dynamically based on neigh state (see mlx5e_rep_neigh_update()) and fib
> events (see mlx5e_tc_fib_event_work()).
>

Thanks. Will look and compare against the FIB case.

cheers,
jamal
