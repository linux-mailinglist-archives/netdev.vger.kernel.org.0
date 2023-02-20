Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5414B69C992
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 12:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjBTLQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 06:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbjBTLQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 06:16:53 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD87E1B331
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 03:16:22 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id cq23so2942133edb.1
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 03:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8PoFbTAadJ+43wOAm2K5cpVEABJmL3iRNCRdHHCzefw=;
        b=Dir9WT9k1Y/bxVD3+brb5gZm9/yj5Z/1q2L3Bu6uaXxvchM7h3yUE1iH3cT/K6biqj
         UDwCKhvUiWv+mpDY8N33akppy9NqEXu6SGpnZ/bgznVTMld4b5DHDInRgx0KbMyG9dmP
         PpeOQKTF7sgSQuZ7zvJzQwcCLsGz3xZzTJEpaJd4NwnFQOa4Zrhl84u8+PcPr2jEK3gB
         Qk8i9Hg/PPqU5AqZ/aMunOq8Z0K+Z7nEDZEUd7ZkqA/2b820PjYPwVO0aNly5zsKaTBG
         KE7Gw8HcaqAhhRYkD+mMegyKv9QL7Py719GvjEwMeAxXc9JvX6aMmlcVrUhcmph1Q3tc
         OP4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8PoFbTAadJ+43wOAm2K5cpVEABJmL3iRNCRdHHCzefw=;
        b=n08AWP6N3PhWQHrN44zravTqYyGJLEgYAU2Zsj/yZCO6DHCkdonx3250ALT9w9pRqp
         9GhSTxo0ug41lWwr08UjLDKccZjzgyK1DEx4qf9CSjEd3ZxNS88QGS3oKWhcNqUj9DPh
         Lb7TRP7WptrMcPDS2rhYoy8tWBjv/fJ+wh3X/LVvwKC28rx1MPifYe0+uQufhLdBO/ao
         CdjmJ3mmm6esg6AshOWjVqhUMqE+IKlQ2XEUK/LgdqS4Wti0D8iWdp+ol5nmRNTmysQk
         2Zz+gQeAMypYKQcpdQFAKONdkLT7hu9DDMe8/CtPZNu2VxNZPY5FE3FPLdp4mDj8J3UJ
         Eq2A==
X-Gm-Message-State: AO0yUKUvmaAunwQN5kH/VKBzaj8rB7drhVpLaO2GZ7SO9vdSj2/AeFGu
        1+PoLzO0OOiUP/AOCSkvQs3HcQ==
X-Google-Smtp-Source: AK7set+HYw4RCAHeS6v6rYL/JuG8/dMUwKnuAvdtPtHONyOn0eft5/2bJ7+F0yVn7fexBYxOUXrzWw==
X-Received: by 2002:a17:907:2da2:b0:889:33ca:70c6 with SMTP id gt34-20020a1709072da200b0088933ca70c6mr14374470ejc.2.1676891771408;
        Mon, 20 Feb 2023 03:16:11 -0800 (PST)
Received: from [10.44.2.5] ([81.246.10.41])
        by smtp.gmail.com with ESMTPSA id w10-20020a170906968a00b008b17de9d1f2sm4787395ejx.15.2023.02.20.03.16.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Feb 2023 03:16:11 -0800 (PST)
Message-ID: <ac85e6d0-c147-6659-ebb6-85b79d7fa797@tessares.net>
Date:   Mon, 20 Feb 2023 12:16:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCHv2 bpf-next] selftests/bpf: run mptcp in a dedicated netns
Content-Language: en-GB
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Felix Maurer <fmaurer@redhat.com>, mptcp@lists.linux.dev
References: <20230219070124.3900561-1-liuhangbin@gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20230219070124.3900561-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hangbin,

On 19/02/2023 08:01, Hangbin Liu wrote:
> The current mptcp test is run in init netns. If the user or default
> system config disabled mptcp, the test will fail. Let's run the mptcp
> test in a dedicated netns to avoid none kernel default mptcp setting.
> 
> Suggested-by: Martin KaFai Lau <martin.lau@linux.dev>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> v2: remove unneed close_cgroup_fd goto label.

Thank you for the update!

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
