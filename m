Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A3A65CBBC
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 03:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbjADCFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 21:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjADCFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 21:05:44 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E9917E07;
        Tue,  3 Jan 2023 18:05:43 -0800 (PST)
Message-ID: <f372a5ca-d9f1-e44e-07fb-3ec1e089e2f7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1672797941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l6FK8fxQs0Li6/NLpmqWpkSek5USo3mefm4+LR8SZbw=;
        b=RTXXh5k1+OFsl/fP6roHOnjVfs9Ei2NzSFZJY1eNOwSi+VJK4h5cJNQ1jsjRbcbqXtomDs
        5SlAQSeTTsgU5XYUQenmDy5aJliiPVr/oa08ib7FyxfhJPfMjL6n3hTPR2v1JnhM11ZUKg
        UCLij+k83FITN0kcA2B/p8ZAn62cYPc=
Date:   Tue, 3 Jan 2023 18:05:25 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v5 11/17] selftests/bpf: Verify xdp_metadata
 xdp->af_xdp path
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20221220222043.3348718-1-sdf@google.com>
 <20221220222043.3348718-12-sdf@google.com>
 <18bed458-0128-d434-8b7a-bf676a0ea863@linux.dev>
 <CAKH8qBst6==Rw1mQohjNimf5QZrPJ05d+XLjqyyT1W8fENNz4w@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAKH8qBst6==Rw1mQohjNimf5QZrPJ05d+XLjqyyT1W8fENNz4w@mail.gmail.com>
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

On 12/22/22 8:06 PM, Stanislav Fomichev wrote:
>>> +     /* First half of umem is for TX. This way address matches 1-to-1
>>> +      * to the completion queue index.
>>> +      */
>>> +
>>> +     for (i = 0; i < UMEM_NUM / 2; i++) {
>>> +             addr = i * UMEM_FRAME_SIZE;
>>> +             printf("%p: tx_desc[%d] -> %lx\n", xsk, i, addr);
>> Do you still need this verbose printf which is in a loop?  Also, how about other
>> printf in this test?
> In case we'd ever need to debug this test, those printfs shouldn't
> hurt, right? Or are you concerned about this test polluting the output
> with something like 'test_progs -v -v' ?
> 

Asking just in case it was some left over from the earlier rfc that is no longer 
needed. I think only failure test get logged in CI, so I don't mind to leave 
them here if they will be useful to debug other earlier/later ASSERTs.
