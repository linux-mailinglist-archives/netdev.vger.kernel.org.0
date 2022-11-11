Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6952624F0C
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 01:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiKKApg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 19:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiKKApf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 19:45:35 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AF16068D;
        Thu, 10 Nov 2022 16:45:33 -0800 (PST)
Message-ID: <d403ef7d-6dfd-bcaf-6088-cff5081f49e9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1668127532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bw8mu8AHIqRpJsotUOwUdebayj+6MCeH5ZoSf6IaVFw=;
        b=cPuoVcpsrrsvVu7r7W5QgQDGQfDpHjo8nhWcOOdnQbzoLJTzmBc6v1EdrpjrwfnesIKYk7
        cH5i28SAfLp+PUleiGi6OooaKNlXABCHZNqzlPDL1Py4pgciA+nd/ddLa6CS+Lfq8bcGUY
        eFmvACviJBFBb5Ophl0hjzFDRn4EQgA=
Date:   Thu, 10 Nov 2022 16:45:27 -0800
MIME-Version: 1.0
Subject: Re: [xdp-hints] Re: [RFC bpf-next v2 06/14] xdp: Carry over xdp
 metadata into skb context
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Stanislav Fomichev <sdf@google.com>
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
References: <20221104032532.1615099-1-sdf@google.com>
 <20221104032532.1615099-7-sdf@google.com>
 <187e89c3-d7de-7bec-c72e-d9d6eb5bcca0@linux.dev>
 <CAKH8qBv_ZO=rsJcq2Lvq36d9sTAXs6kfUmW1Hk17bB=BGiGzhw@mail.gmail.com>
 <9a8fefe4-2fcb-95b7-cda0-06509feee78e@linux.dev>
 <6f57370f-7ec3-07dd-54df-04423cab6d1f@linux.dev> <87leokz8lq.fsf@toke.dk>
 <5a23b856-88a3-a57a-2191-b673f4160796@linux.dev>
 <CAKH8qBsfVOoR1MNAFx3uR9Syoc0APHABsf97kb8SGpK+T1qcew@mail.gmail.com>
 <32f81955-8296-6b9a-834a-5184c69d3aac@linux.dev>
 <CAKH8qBuLMZrFmmi77Qbt7DCd1w9FJwdeK5CnZTJqHYiWxwDx6w@mail.gmail.com>
 <87y1siyjf6.fsf@toke.dk>
 <CAKH8qBsfzYmQ9SZXhFetf_zQPNmE_L=_H_rRxJEwZzNbqtoKJA@mail.gmail.com>
 <87o7texv08.fsf@toke.dk>
 <CAKH8qBtjYV=tb28y6bvo3tGonzjvm2JLyis9AFPSMTuXsL3NPA@mail.gmail.com>
 <87eduaxsep.fsf@toke.dk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <87eduaxsep.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/22 4:10 PM, Toke Høiland-Jørgensen wrote:
>> The problem with AF_XDP is that, IIUC, it doesn't have a data_meta
>> pointer in the userspace.
>>
>> You get an rx descriptor where the address points to the 'data':
>> | 256 bytes headroom where metadata can go | data |
> 
> Ah, I was missing the bit where the data pointer actually points at
> data, not the start of the buf. Oops, my bad!
> 
>> So you have (at most) 256 bytes of headroom, some of that might be the
>> metadata, but you really don't know where it starts. But you know it
>> definitely ends where the data begins.
>>
>> So if we have the following, we can locate skb_metadata:
>> | 256-sizeof(skb_metadata) headroom | custom metadata | skb_metadata | data |
>> data - sizeof(skb_metadata) will get you there
>>
>> But if it's the other way around, the program has to know
>> sizeof(custom metadata) to locate skb_metadata:
>> | 256-sizeof(skb_metadata) headroom | skb_metadata | custom metadata | data |
>>
>> Am I missing something here?
> 
> Hmm, so one could argue that the only way AF_XDP can consume custom
> metadata today is if it knows out of band what the size of it is. And if
> it knows that, it can just skip over it to go back to the skb_metadata,
> no?

+1 I replied with a similar point in another email.  I also think we can safely 
assume this.

> 
> The only problem left then is if there were multiple XDP programs called
> in sequence (whether before a redirect, or by libxdp chaining or tail
> calls), and the first one resized the metadata area without the last one
> knowing about it. For this, we could add a CLOBBER_PROGRAM_META flag to
> the skb_metadata helper which if set will ensure that the program
> metadata length is reset to 0?

How is it different from the same xdp prog calling bpf_xdp_adjust_meta() and 
bpf_xdp_metadata_export_to_skb() multiple times.  The earlier stored 
skb_metadata needs to be moved during the latter bpf_xdp_adjust_meta().  The 
latter bpf_xdp_metadata_export_to_skb() will overwrite the earlier skb_metadata.

