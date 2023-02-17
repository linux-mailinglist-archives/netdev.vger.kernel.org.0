Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75BF869B1E9
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 18:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjBQRjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 12:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjBQRjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 12:39:03 -0500
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28987149D;
        Fri, 17 Feb 2023 09:39:01 -0800 (PST)
Message-ID: <514bb57b-cc3e-7b7e-c7d4-94cdf52565d6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676655539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mUAWCHNiI3huoooaliH6fSRpJWfQfHulzV4uLmvQAiA=;
        b=gm3Xj59+48hMvxIvopTueKoApxS7bfbXjJxDYzds5jcGQTSyiJekDsk3HDcUqqWvQeRe88
        IOht0CBH8f28sNbQL3KuISV9drHMXHAFu8z3qFuE4E780hJK2oIzWiWzwaLXYORtQalLcq
        P/NhYqPw8OX1W8G/XYgUxKhlAwoSQN8=
Date:   Fri, 17 Feb 2023 09:38:54 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next V2] xdp: bpf_xdp_metadata use NODEV for no device
 support
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net
References: <167663589722.1933643.15760680115820248363.stgit@firesoul>
 <Y++6IvP+PloUrCxs@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <Y++6IvP+PloUrCxs@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/23 9:32 AM, Stanislav Fomichev wrote:
> On 02/17, Jesper Dangaard Brouer wrote:
>> With our XDP-hints kfunc approach, where individual drivers overload the
>> default implementation, it can be hard for API users to determine
>> whether or not the current device driver have this kfunc available.
> 
>> Change the default implementations to use an errno (ENODEV), that
>> drivers shouldn't return, to make it possible for BPF runtime to
>> determine if bpf kfunc for xdp metadata isn't implemented by driver.
> 
>> This is intended to ease supporting and troubleshooting setups. E.g.
>> when users on mailing list report -19 (ENODEV) as an error, then we can
>> immediately tell them their device driver is too old.
> 
> I agree with the v1 comments that I'm not sure how it helps.
> Why can't we update the doc in the same fashion and say that
> the drivers shouldn't return EOPNOTSUPP?
> 
> I'm fine with the change if you think it makes your/users life
> easier. Although I don't really understand how. We can, as Toke
> mentioned, ask the users to provide jited program dump if it's
> mostly about user reports.

and there is xdp-features also.

