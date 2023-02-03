Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B196689308
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbjBCJCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbjBCJCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:02:41 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1FE92C03
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 01:02:40 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id f7so4500949edw.5
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 01:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5Dk9oRwWoL6Eq4hgVuGxNfkU9whS5cyWy9FWflgjKWo=;
        b=DG1clRKvCrEsxzYopyxVfqz2ynaSB/i1pW0NcbwP3OAdNhXVEJBaj4gx/tQSEmgHpl
         76moVpcYec8yFX1LV4rOvEsz9PETyE5mVX+9Qfdaso+TUbbEP0HxVtJEpnq8KPGl9NOC
         QEw02HPDpGimTv+kvKl66aMPl4CjCHxgGRsBIi50aaGBp2NGecisznzAQOuum56XL7Ls
         AYWQn+ynEM4UMCwrtbZXZRB/eD2rj/HIBxVev5SU36+prdEOum482fLhkCt4dxhshmRK
         WJY2A+eO7GNipQfBVGUzmwg6pfKEhxF0DdU6ERR+W0+X0VGZbH3BC5xTLo1OqznX15jf
         3/Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5Dk9oRwWoL6Eq4hgVuGxNfkU9whS5cyWy9FWflgjKWo=;
        b=TW5hfIyRWvhBaUzPlAsmN2iyh8lA4ByN8JKL0Xj/AbJDMnakxF1+KEN9H1uIX41lGX
         QDqPbaOq+JZ5JEj4qtYMiCo4spAgiCCSMQTf5VWZvqK27NEQ+PVMqAYOMzKBQSQoqY7c
         Ddys1MjQXrVjO3iLrDq22CTvpMKEMDMDGkuzJvlyFyIO5ldadEU+KkpXCBysjRLnYZZI
         ME5XHBarvXBK8DFfoCGNu6yLIeyD6ZI9wXo3sPyTM8jAvtMlNtrjLHzS4btlhCES/Ivp
         O04Lasp3lvdJrA17mnPdiaNGQsjxHJSmgE36Pta6dzIb9EVk/mIno8p0DQXy/Y23e8hU
         9msA==
X-Gm-Message-State: AO0yUKUcBJ4cUWerN66buIcg7u3rjSnlwA5QTlISLdycYzdCO18HmRpN
        DHBvBcTaZiIAdx30lxvMp/gmRQ==
X-Google-Smtp-Source: AK7set/r59J0g2PJFpZV8vVuKmWj3HAPnJLAa+CmyhxGVomGjfq0jGabAAYixW3ajTM7qKb+CYyf2w==
X-Received: by 2002:a50:d610:0:b0:499:4130:fae with SMTP id x16-20020a50d610000000b0049941300faemr9882422edi.10.1675414959035;
        Fri, 03 Feb 2023 01:02:39 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id d16-20020a056402001000b0048789661fa2sm800356edu.66.2023.02.03.01.02.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 01:02:38 -0800 (PST)
Message-ID: <a8d81917-c021-deb1-4121-927859d47da5@blackwall.org>
Date:   Fri, 3 Feb 2023 11:02:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next v3 16/16] selftests: forwarding: bridge_mdb_max:
 Add a new selftest
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
References: <cover.1675359453.git.petrm@nvidia.com>
 <ea90ca36a55f0ec3e0f1a20418f4c9e685a7a8ab.1675359453.git.petrm@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <ea90ca36a55f0ec3e0f1a20418f4c9e685a7a8ab.1675359453.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/02/2023 19:59, Petr Machata wrote:
> Add a suite covering mcast_n_groups and mcast_max_groups bridge features.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
> 
> Notes:
>     v2:
>     - Adjust the tests that check setting max below n and
>       reset of max on VLAN snooping enablement
>     - Make test naming uniform
>     - Enable testing of control path (IGMP/MLD) in
>       mcast_vlan_snooping bridge
>     - Reorganize the code so that test instances (per bridge
>       type and configuration type) always come right after
>       the test, in order of {d,q,qvs}{4,6}{cfg,ctl}.
>       Then groups of selftests are at the end of the file.
>       Similarly adjust invocation order of the tests.
> 
>  .../testing/selftests/net/forwarding/Makefile |    1 +
>  .../net/forwarding/bridge_mdb_max.sh          | 1336 +++++++++++++++++
>  2 files changed, 1337 insertions(+)
>  create mode 100755 tools/testing/selftests/net/forwarding/bridge_mdb_max.sh
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


