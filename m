Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F8564621F
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 21:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiLGUJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 15:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiLGUJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 15:09:44 -0500
Received: from mx23lb.world4you.com (mx23lb.world4you.com [81.19.149.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43877B4C8;
        Wed,  7 Dec 2022 12:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=e6150pesDjf2ip1bhFy8/7tkl3nhLq3boeEFGzcaG30=; b=YIz5jCMhP/toy1TW6y2Q6b8j79
        xvgVowTnq66shUETYzw7tkrSgy3/RZwUI/i3l17qAL8NJx+cUch9jbE5U+mQ7c8iQD+f2zEN9lbD1
        1aBgyC2irLEgBIhP3/hP4xN8Dh4m4xj7AVgMh6KnWeou9pU9vl2HCTg+o00ZaGt9hFPo=;
Received: from [88.117.56.227] (helo=[10.0.0.160])
        by mx23lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p30je-0001bK-5T; Wed, 07 Dec 2022 21:09:42 +0100
Message-ID: <f3ded6e3-9c99-b086-a155-cb79e77d46cc@engleder-embedded.com>
Date:   Wed, 7 Dec 2022 21:09:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 4/6] tsnep: Prepare RX buffer for XDP support
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
References: <20221203215416.13465-1-gerhard@engleder-embedded.com>
 <20221203215416.13465-5-gerhard@engleder-embedded.com>
 <21c752a196bae3977cc0f91182b6ae9cef9ed532.camel@redhat.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <21c752a196bae3977cc0f91182b6ae9cef9ed532.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.12.22 11:29, Paolo Abeni wrote:
> On Sat, 2022-12-03 at 22:54 +0100, Gerhard Engleder wrote:
>> @@ -808,6 +809,16 @@ static void tsnep_tx_close(struct tsnep_tx *tx)
>>   	tsnep_tx_ring_cleanup(tx);
>>   }
>>   
>> +static inline unsigned int tsnep_rx_offset(struct tsnep_rx *rx)
>> +{
>> +	struct tsnep_adapter *adapter = rx->adapter;
>> +
>> +	if (tsnep_xdp_is_enabled(adapter))
>> +		return XDP_PACKET_HEADROOM;
>> +
>> +	return TSNEP_SKB_PAD;
>> +}
> 
> please, no 'inline' in .c files, thanks!

Will be fixed.

Gerhard
