Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E4E6EB20D
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 21:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbjDUTFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 15:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbjDUTFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 15:05:15 -0400
Received: from mx06lb.world4you.com (mx06lb.world4you.com [81.19.149.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E3DE53;
        Fri, 21 Apr 2023 12:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pNA0LbEE2V+gZ0EBUCIKt5+WIYL8jdEZURhUGriO9ns=; b=mPXp9QuBwzet9977RfBJUss+v+
        CmyD5CwG4V2468gvhzMczRGuGvpAvj/efyCHH9eUqCIRe1CawPHFPOH/x/vXvRYw5nbUymbCKscie
        xaHNWQfG8cYtuKWO75w5SoRL1Gz70nRflOH24Fve9tEpcrwDqDVdfUfWqS8eaiVhTLg4=;
Received: from [88.117.57.231] (helo=[10.0.0.160])
        by mx06lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1ppw4E-0007Dj-35;
        Fri, 21 Apr 2023 21:05:11 +0200
Message-ID: <f5d3638a-f1f3-f45f-1b0c-e5de54dd07d1@engleder-embedded.com>
Date:   Fri, 21 Apr 2023 21:05:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v3 0/6] tsnep: XDP socket zero-copy support
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
References: <20230418190459.19326-1-gerhard@engleder-embedded.com>
 <ZEGeNYHh+NatBDq+@boxer>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <ZEGeNYHh+NatBDq+@boxer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.04.23 22:19, Maciej Fijalkowski wrote:
> On Tue, Apr 18, 2023 at 09:04:53PM +0200, Gerhard Engleder wrote:
>> Implement XDP socket zero-copy support for tsnep driver. I tried to
>> follow existing drivers like igc as far as possible. But one main
>> difference is that tsnep does not need any reconfiguration for XDP BPF
>> program setup. So I decided to keep this behavior no matter if a XSK
>> pool is used or not. As a result, tsnep starts using the XSK pool even
>> if no XDP BPF program is available.
>>
>> Another difference is that I tried to prevent potentially failing
>> allocations during XSK pool setup. E.g. both memory models for page pool
>> and XSK pool are registered all the time. Thus, XSK pool setup cannot
>> end up with not working queues.
>>
>> Some prework is done to reduce the last two XSK commits to actual XSK
>> changes.
> 
> I had minor comments on two last patches, besides:
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

I will add that tag to all commits.

Thank you for the review!

Gerhard
