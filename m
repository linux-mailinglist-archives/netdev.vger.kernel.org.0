Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5996D87E3
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbjDEUMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbjDEUMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:12:09 -0400
Received: from out-5.mta1.migadu.com (out-5.mta1.migadu.com [95.215.58.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DF17EDC;
        Wed,  5 Apr 2023 13:11:47 -0700 (PDT)
Message-ID: <f1a32d5a-03e7-fce1-f5a5-6095f365f0a9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680725470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ND8zupGe7sSXe8KuRSf4Pa9L5Pfc41bVv9ADnmYOAYg=;
        b=qbfI0/1BfPP0IBPSx1kF3HH2nxEmwn88mTnGZLhwFnggFzEpVRHG6zsVAnvBqPWaHU3yEH
        EUQgaRLXp9mhTaSI/MKMXjqW/vcggXxKh+nZubFlYXr88ajt0m9XSuJQ9tLoTFyK8qpvgb
        zCAYTHNap4+KbAiV+xkdc7FjEB9La3M=
Date:   Wed, 5 Apr 2023 13:11:04 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf] xsk: Fix unaligned descriptor validation
Content-Language: en-US
To:     Kal Cutter Conley <kal.conley@dectris.com>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230403143601.32168-1-kal.conley@dectris.com>
 <CAJ8uoz1BKJ1_jq6Sum-OkZQTR_ftmr5Enj+Cmn4Qsi15_jOpbQ@mail.gmail.com>
 <c0596a62-0873-5638-920b-235c55ff33a2@linux.dev>
 <CAHApi-mzLH7yVOT0cM03yafzTJJqfGwOBTa3q5U6jBdWnAx3VQ@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAHApi-mzLH7yVOT0cM03yafzTJJqfGwOBTa3q5U6jBdWnAx3VQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/23 12:48 PM, Kal Cutter Conley wrote:
>> Is this case covered by an existing test?
>>
> 
> No. I submitted a test but I was asked to make minor changes to it. I
> plan to submit the test once this gets picked up on bpf-next.

Since you already have a test case, it is better to submit them together such 
that this case can be covered earlier than later.

Other xskxceiver fixes have already landed to bpf-next. imo, I think for this 
particular case, bpf-next for both the fix and the test is fine.
