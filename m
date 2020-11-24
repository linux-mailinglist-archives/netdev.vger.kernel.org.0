Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D012C23FF
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 12:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731911AbgKXLUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 06:20:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20069 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726315AbgKXLUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 06:20:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606216800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d5zLVoKW/IH6LP6uIrGiz5xuuHbfBz/3Me6zfh9+1tE=;
        b=InkDysdo6DFO83nvLOetfkitj+nRBWRVdoPYpx3GX95JwPFRKYz8rwh/s/GLfNbYWtIRJP
        B8VUOOoRRTrVn7hMkgbcFYjktZwUW3Dimc7jJD/+7f2etclZUlcJloatdu5lS/xLMLh0kd
        1DYLlJIzk42M4OzYupWZ68p6PXZ4o/o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-QKxZJKXTN0WHDBukOksewA-1; Tue, 24 Nov 2020 06:19:58 -0500
X-MC-Unique: QKxZJKXTN0WHDBukOksewA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2B33521D;
        Tue, 24 Nov 2020 11:19:56 +0000 (UTC)
Received: from [10.36.113.14] (ovpn-113-14.ams2.redhat.com [10.36.113.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 32936100239F;
        Tue, 24 Nov 2020 11:19:54 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Matteo Croce" <mcroce@linux.microsoft.com>
Cc:     "Jakub Kicinski" <kuba@kernel.org>, netdev@vger.kernel.org,
        "David Miller" <davem@davemloft.net>, dev@openvswitch.org,
        "Pravin B Shelar" <pshelar@ovn.org>, bindiyakurle@gmail.com,
        "Ilya Maximets" <i.maximets@ovn.org>
Subject: Re: [PATCH net] net: openvswitch: fix TTL decrement action netlink
 message format
Date:   Tue, 24 Nov 2020 12:19:52 +0100
Message-ID: <7259C596-A195-4E3B-9D6F-959A34FCC3E2@redhat.com>
In-Reply-To: <CAFnufp1RRtwDLwrWayvyZVPmDjab_dTx50u7xWeNwK7J6azqWw@mail.gmail.com>
References: <160577663600.7755.4779460826621858224.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
 <20201120131228.489c3b52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFnufp1RRtwDLwrWayvyZVPmDjab_dTx50u7xWeNwK7J6azqWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23 Nov 2020, at 20:36, Matteo Croce wrote:

> On Fri, Nov 20, 2020 at 10:12 PM Jakub Kicinski <kuba@kernel.org> 
> wrote:
>>
>> On Thu, 19 Nov 2020 04:04:04 -0500 Eelco Chaudron wrote:
>>> Currently, the openvswitch module is not accepting the correctly 
>>> formated
>>> netlink message for the TTL decrement action. For both setting and 
>>> getting
>>> the dec_ttl action, the actions should be nested in the
>>> OVS_DEC_TTL_ATTR_ACTION attribute as mentioned in the openvswitch.h 
>>> uapi.
>>
>> IOW this change will not break any known user space, correct?
>>
>> But existing OvS user space already expects it to work like you
>> make it work now?
>>
>> What's the harm in leaving it as is?
>>
>>> Fixes: 744676e77720 ("openvswitch: add TTL decrement action")
>>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>>
>> Can we get a review from OvS folks? Matteo looks good to you (as the
>> original author)?
>>
>
> Hi,
>
> I think that the userspace still has to implement the dec_ttl action;
> by now dec_ttl is implemented with set_ttl().
> So there is no breakage yet.

Yes, see reply to Jakub’s email.

> Eelco, with this fix we will encode the netlink attribute in the same
> way for the kernel and netdev datapath?

Yes, this should make both implementations the same. No more weird code 
in the data-plane agnostic code :)

> If so, go for it.
>
>
>>> -     err = __ovs_nla_copy_actions(net, attr, key, sfa, eth_type,
>>> +     err = __ovs_nla_copy_actions(net, actions, key, sfa, eth_type,
>>>                                    vlan_tci, mpls_label_count, log);
>>>       if (err)
>>>               return err;
>>
>> You're not canceling any nests on error, I assume this is normal.
>>
>>> +     add_nested_action_end(*sfa, action_start);
>>>       add_nested_action_end(*sfa, start);
>>>       return 0;
>>>  }
>>
>
>
> -- 
> per aspera ad upstream

