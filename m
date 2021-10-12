Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422F442A83B
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 17:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237411AbhJLP3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 11:29:01 -0400
Received: from www62.your-server.de ([213.133.104.62]:49812 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhJLP3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 11:29:00 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1maJg5-000GpK-DY; Tue, 12 Oct 2021 17:26:53 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1maJg5-000W8H-5a; Tue, 12 Oct 2021 17:26:53 +0200
Subject: Re: [PATCH net-next 4/4] net, neigh: Add NTF_MANAGED flag for managed
 neighbor entries
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     David Ahern <dsahern@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, Ido Schimmel <idosch@idosch.org>
Cc:     roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211011121238.25542-1-daniel@iogearbox.net>
 <20211011121238.25542-5-daniel@iogearbox.net>
 <05807c5b-59aa-839d-fbb0-b9712857741e@gmail.com>
 <bf31a3fe-c12d-fd75-c2eb-9685cc8528f2@iogearbox.net>
Message-ID: <680247ef-c5d4-520d-2823-7313d3b539c6@iogearbox.net>
Date:   Tue, 12 Oct 2021 17:26:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <bf31a3fe-c12d-fd75-c2eb-9685cc8528f2@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26320/Tue Oct 12 10:17:49 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 5:05 PM, Daniel Borkmann wrote:
> On 10/12/21 4:51 PM, David Ahern wrote:
>> On 10/11/21 6:12 AM, Daniel Borkmann wrote:
[...]
>>> @@ -1254,8 +1281,8 @@ static int __neigh_update(struct neighbour *neigh, const u8 *lladdr,
>>>           (old & (NUD_NOARP | NUD_PERMANENT)))
>>>           goto out;
>>> -    ext_learn_change = neigh_update_ext_learned(neigh, flags, &notify);
>>> -    if (flags & NEIGH_UPDATE_F_USE) {
>>> +    neigh_update_flags(neigh, flags, &notify, &gc_update, &managed_update);
>>> +    if (flags & (NEIGH_UPDATE_F_USE | NEIGH_UPDATE_F_MANAGED)) {
>>>           new = old & ~NUD_PERMANENT;
>>
>> so a neighbor entry can not be both managed and permanent, but you don't
>> check for the combination in neigh_add and error out with a message to
>> the user.
> 
> Good point, I'll error out if both NUD_PERMANENT and NTF_MANAGED is set in neigh_add().
> 
> Thanks for the review!

Ah, I missed that this was already applied, will send a relative diff in that case.

Thanks,
Daniel
