Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D54E58EF1C
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbiHJPRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbiHJPRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:17:44 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42CF78234;
        Wed, 10 Aug 2022 08:17:42 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oLnSj-00047A-IS; Wed, 10 Aug 2022 17:17:37 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oLnSj-000ROa-83; Wed, 10 Aug 2022 17:17:37 +0200
Subject: Re: [PATCH bpf-next v4] selftests: xsk: Update poll test cases
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Shibin Koikkara Reeny <shibin.koikkara.reeny@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org, kuba@kernel.org,
        andrii@kernel.org, ciara.loftus@intel.com
References: <20220803144354.98122-1-shibin.koikkara.reeny@intel.com>
 <YvOtvgdSnOhUd9Po@boxer>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <36e36fb2-948f-84c7-0d3b-d97e76373dfa@iogearbox.net>
Date:   Wed, 10 Aug 2022 17:17:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YvOtvgdSnOhUd9Po@boxer>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26623/Wed Aug 10 09:55:07 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/10/22 3:08 PM, Maciej Fijalkowski wrote:
> On Wed, Aug 03, 2022 at 02:43:54PM +0000, Shibin Koikkara Reeny wrote:
>> Poll test case was not testing all the functionality
>> of the poll feature in the testsuite. This patch
>> update the poll test case which contain 2 testcases to
> 
> updates, contains, test cases
> 
>> test the RX and the TX poll functionality and additional
>> 2 more testcases to check the timeout features of the
> 
> feature
> 
>> poll event.
>>
>> Poll testsuite have 4 test cases:
> 
> test suite, has
> 
>>
>> 1. TEST_TYPE_RX_POLL:
>> Check if RX path POLLIN function work as expect. TX path
> 
> works
> 
>> can use any method to sent the traffic.
> 
> send
> 
>>
>> 2. TEST_TYPE_TX_POLL:
>> Check if TX path POLLOUT function work as expect. RX path
>> can use any method to receive the traffic.
>>
>> 3. TEST_TYPE_POLL_RXQ_EMPTY:
>> Call poll function with parameter POLLIN on empty rx queue
>> will cause timeout.If return timeout then test case is pass.
> 
> space after dot
> 
>>
>> 4. TEST_TYPE_POLL_TXQ_FULL:
>> When txq is filled and packets are not cleaned by the kernel
>> then if we invoke the poll function with POLLOUT then it
>> should trigger timeout.
>>
>> v1: https://lore.kernel.org/bpf/20220718095712.588513-1-shibin.koikkara.reeny@intel.com/
>> v2: https://lore.kernel.org/bpf/20220726101723.250746-1-shibin.koikkara.reeny@intel.com/
>> v3: https://lore.kernel.org/bpf/20220729132337.211443-1-shibin.koikkara.reeny@intel.com/
>>
>> Changes in v2:
>>   * Updated the commit message
>>   * fixed the while loop flow in receive_pkts function.
>> Changes in v3:
>>   * Introduced single thread validation function.
>>   * Removed pkt_stream_invalid().
>>   * Updated TEST_TYPE_POLL_TXQ_FULL testcase to create invalid frame.
>>   * Removed timer from send_pkts().
>>   * Removed boolean variable skip_rx and skip_tx.
>> Change in v4:
>>   * Added is_umem_valid()
> 
> for single patches, I believe that it's concerned a better practice to
> include the versioning below the '---' line?
> 
>>
>> Signed-off-by: Shibin Koikkara Reeny <shibin.koikkara.reeny@intel.com>
>> ---
>>   tools/testing/selftests/bpf/xskxceiver.c | 166 +++++++++++++++++------
>>   tools/testing/selftests/bpf/xskxceiver.h |   8 +-
>>   2 files changed, 134 insertions(+), 40 deletions(-)
> 
> I don't think these grammar suggestions require a new revision, so:
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

I cleaned these up while applying. Shibin, please take care of this before sending
out next time, thanks guys!
