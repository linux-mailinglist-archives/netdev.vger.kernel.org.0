Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6AC85B1FC1
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 15:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbiIHN4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 09:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbiIHN4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 09:56:42 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEBAED99C
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 06:56:36 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id z17so10149131eje.0
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 06:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=oU7r9URdkHR4hFtjwb+DGbO5ThpZ489lVmOF+LZfRK0=;
        b=UQlzr6tCetqVbCOOX2ttQ/neOUnakbzGJShT7CCa07IJuqxjOzl+EOWl/kv99025Iy
         rCDQcVk1pCFItNZQ/tvHphz+S7cmtNw9x42goeylzffmomGRsueAsM7xcL8I3cfWC/qF
         KFfnufPnVdlKSc22AbRxrP5tMpvvRvvTo+BR7MBP2Sqkf/1IFL8fMcKO/hSe+W6+tlNR
         SgbSCHx09n1Y8nXPKoM4arIoWokszvDSY94Pjn4G38V08HlvuJzx6+lHIeUVbqekZd1m
         FF5F/dlhvn8S82lH7Y00yvifqIo+ANWsQ466ROvddquwTgi1TrDwIgKG2jZtyzlNqMtf
         mY1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=oU7r9URdkHR4hFtjwb+DGbO5ThpZ489lVmOF+LZfRK0=;
        b=flZ35v32JVLGu6smSFf6VgwALi8I4vIRS2v1HRjJTUXFVwq1yal9Hakpl+odoXgatY
         3YHke8iXNqITpdHWbeaN3gFHO9sxprGu5K2XIgxYLAdYK9/ino1WSGjDQUrGk65o909K
         yhXPZdL0Ss6u1rS9VwVUHFdFla2w31NyNa9nQnQZL/za9BKbmuJ0AWa1HKisrCQhgx5g
         QoRXhGntkUKzu9upCllBN6VeBfyKWXUVkZoBMK8cLfYyBsUN6u9bYuNO8eliikkQy4/1
         QJZLnrZtg/VJuy6+JYIjtxzPAp6EE7WpkSqO8sLdl2ZrGaPSt/TQi1rsyB3GMYkbgBmL
         eSpQ==
X-Gm-Message-State: ACgBeo1jQR+WnPSxDSG9OxbMtH7hzKSHddhvTdGK3vTwSyg9lhd2FXue
        ObU8TLOUPut7fGhEjvt6kHu5htH5Efujcg==
X-Google-Smtp-Source: AA6agR71PQQCRleuxeuH7B8IXp8332nCARvv5AMHLZ9ubQsUxlJHU9AyInKTff/3PUJPpU6bxUx9mA==
X-Received: by 2002:a17:906:974f:b0:778:ce93:38e3 with SMTP id o15-20020a170906974f00b00778ce9338e3mr588170ejy.644.1662645395092;
        Thu, 08 Sep 2022 06:56:35 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:8618:9875:a93a:7063? ([2a02:578:8593:1200:8618:9875:a93a:7063])
        by smtp.gmail.com with ESMTPSA id u24-20020a056402111800b0044ebe6f364csm6002652edv.45.2022.09.08.06.56.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 06:56:16 -0700 (PDT)
Message-ID: <e4b7eddc-3a73-0994-467e-6d65d6ad80c0@tessares.net>
Date:   Thu, 8 Sep 2022 15:56:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net v3] net: mptcp: fix unreleased socket in accept queue
Content-Language: en-GB
To:     menglong8.dong@gmail.com, pabeni@redhat.com
Cc:     mathew.j.martineau@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, fw@strlen.de,
        peter.krystad@linux.intel.com, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>,
        Jiang Biao <benbjiang@tencent.com>,
        Mengen Sun <mengensun@tencent.com>
References: <20220907111132.31722-1-imagedong@tencent.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20220907111132.31722-1-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Menglong,

On 07/09/2022 13:11, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> The mptcp socket and its subflow sockets in accept queue can't be
> released after the process exit.
> 
> While the release of a mptcp socket in listening state, the
> corresponding tcp socket will be released too. Meanwhile, the tcp
> socket in the unaccept queue will be released too. However, only init
> subflow is in the unaccept queue, and the joined subflow is not in the
> unaccept queue, which makes the joined subflow won't be released, and
> therefore the corresponding unaccepted mptcp socket will not be released
> to.

Thank you for the v3.

Unfortunately, our CI found a possible recursive locking:

> - KVM Validation: debug:
>   - Unstable: 1 failed test(s): selftest_mptcp_join - Critical: 1 Call Trace(s) ❌:
>   - Task: https://cirrus-ci.com/task/5418283233968128
>   - Summary: https://api.cirrus-ci.com/v1/artifact/task/5418283233968128/summary/summary.txt

https://lore.kernel.org/mptcp/4e6d3d9e-1f1a-23ae-cb56-2d4f043f17ae@gmail.com/T/#u

Do you mind looking at it please?

Also, because it is not just a simple fix, may you send any new versions
only to MPTCP mailing list please? So without the other mailing lists
and netdev maintainers to reduce the audience during the development.

Once the patch is ready, we will apply it in MPTCP tree and send it to
netdev. That's what we usually for MPTCP related patches.

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
