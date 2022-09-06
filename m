Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8345AF265
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 19:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbiIFR1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 13:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234165AbiIFR0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 13:26:48 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0048FC2;
        Tue,  6 Sep 2022 10:16:32 -0700 (PDT)
Message-ID: <23bbf58b-c376-f9c4-f344-39208dd19520@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662484590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SCnCBjGRKjR5Yyo18DHtfhCdvw/StlCdoFtM4iz5Qiw=;
        b=FroGJ41FVxC2q5Ojpn0QVtnMPFJxwyNGFw25SUgyxTsujbZGv5MGgz+yjZioO7PV6qOC/w
        OckHgaSiXfdsJcI6O0L+FluIJYJqoGh9pGU9Z5Ye8Qg4emo3FmNuNI4p9kBlnuGzlJcL4R
        mPlUzqAfRgdwOJYfBikQ8dl1C6OB+9o=
Date:   Tue, 6 Sep 2022 10:16:24 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: Ensure cgroup/connect{4,6}
 programs can bind unpriv ICMP ping
Content-Language: en-US
To:     YiFei Zhu <zhuyifei@google.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <cover.1662058674.git.zhuyifei@google.com>
 <345fbce9b67e4f287a771c497e8bd1bccff50b58.1662058674.git.zhuyifei@google.com>
 <20220902055527.knlkzkrwnczpx6xh@kafai-mbp.dhcp.thefacebook.com>
 <CAA-VZPnMxN7ppWrjOr4oBo6veUVmuPXCj3P3GJdd_v+otSn8Qw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAA-VZPnMxN7ppWrjOr4oBo6veUVmuPXCj3P3GJdd_v+otSn8Qw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/22 4:52 PM, YiFei Zhu wrote:
>> btw, does it make sense to do it as a subtest in
>> connect_force_port.c or they are very different?
> 
> I could try, but they are structured differently; that checks the
> ports whereas this checks the bound IPs. That test also doesn't use
> skels or sets up netns whereas this test does. I think I would prefer
> to have two tests since tests are cheap, but I can try to restructure
> connect_force_port.c in a way that is compatible with both if you
> insist.
Yep. Keeping them separate is fine.  I was asking because they are 
testing the same hook other than the port-vs-ip difference.

connect[46]_prog.c looks like a better one also but not yet in 
test_progs infra.  It will be useful to migrate it in the future.
