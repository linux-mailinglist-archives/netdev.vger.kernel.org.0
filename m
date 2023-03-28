Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263916CBB71
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbjC1JsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbjC1Jrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:47:49 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4E47A84;
        Tue, 28 Mar 2023 02:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=44mtZ61q7P+35bUH8uAbGMN+mLf2mEbB9fYaZnFfL/U=; b=tfrb+y9fqLdjjN1h5+XBr+ihvP
        keMi/4l3Hq/r8rnt1vwO9tW2el95OeYLkmJ3oJ6vPNwrniznDZasIdoy1OF8msRNT00+0qFqqEVFL
        6IIVo8OC3A1JoRCRZ0iNeo2W9e6uu46iQH7fNOQrBMLHeB1Ny3Tj37kImJKBxjNNkPgc=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1ph5tz-007gqn-KR; Tue, 28 Mar 2023 11:46:03 +0200
Message-ID: <f436c2cc-4f6f-0dc1-a343-4c41eb14935e@nbd.name>
Date:   Tue, 28 Mar 2023 11:46:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH net-next] net/core: add optional threading for backlog
 processing
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230324171314.73537-1-nbd@nbd.name>
 <20230324102038.7d91355c@kernel.org>
 <2d251879-1cf4-237d-8e62-c42bb4feb047@nbd.name>
 <20230324104733.571466bc@kernel.org>
 <f59ee83f-7267-04df-7286-f7ea147b5b49@nbd.name>
 <20230324201951.75eabe1f@kernel.org>
 <2ef8ab92-3670-61a1-384d-b827865447ca@nbd.name>
 <20230327190629.7e966f46@kernel.org>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20230327190629.7e966f46@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.03.23 04:06, Jakub Kicinski wrote:
> On Sat, 25 Mar 2023 06:42:43 +0100 Felix Fietkau wrote:
>> >> In my tests it brings down latency (both avg and p99) considerably in
>> >> some cases. I posted some numbers here:
>> >> https://lore.kernel.org/netdev/e317d5bc-cc26-8b1b-ca4b-66b5328683c4@nbd.name/  
>> > 
>> > Could you provide the full configuration for this test?
>> > In non-threaded mode the RPS is enabled to spread over remaining
>> > 3 cores? 
>> 
>> In this test I'm using threaded NAPI and backlog_threaded without any 
>> fixed core assignment.
> 
> I was asking about the rps_threaded=0 side of the comparison.
> So you're saying on that side you were using threaded NAPI with
> no pinning and RPS across all cores?
Yes.

- Felix
