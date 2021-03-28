Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F2934BEFB
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 22:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhC1Uq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 16:46:29 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:61253 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhC1UqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 16:46:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1616964373; x=1648500373;
  h=to:cc:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=BFoR87Zga8SDLRAr8FqLozZHk1+9WOoIeUVoGrO4GqY=;
  b=AixelBfk0fStrqVo06Ep3P48jNRY9pxTNeOTf6KLwzGU0xbOlm6tKmf9
   0otcOgHRGHTYj0/lk91ExBk9/5sVKeWA8AMN9XW5AjL3W4Eh9bg0ofqw6
   /YjwczdibvSMS7UFrryERZrQ0+rmj09nJCZG4UV99ez23rcVJIZZwIMsy
   s=;
X-IronPort-AV: E=Sophos;i="5.81,285,1610409600"; 
   d="scan'208";a="98513050"
Subject: Re: [net-next 1/2] xen-netback: add module parameter to disable ctrl-ring
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 28 Mar 2021 20:46:04 +0000
Received: from EX13D12EUA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id EBB91A245B;
        Sun, 28 Mar 2021 20:46:03 +0000 (UTC)
Received: from 147dda3ee008.ant.amazon.com (10.43.164.198) by
 EX13D12EUA002.ant.amazon.com (10.43.165.103) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 28 Mar 2021 20:46:02 +0000
To:     Leon Romanovsky <leon@kernel.org>,
        =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
CC:     Andrew Lunn <andrew@lunn.ch>, <netdev@vger.kernel.org>,
        <wei.liu@kernel.org>, <paul@xen.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <xen-devel@lists.xenproject.org>
References: <YE3foiFJ4sfiFex2@unreal>
 <64f5c7a8-cc09-3a7f-b33b-a64d373aed60@amazon.com> <YFI676dumSDJvTlV@unreal>
 <f3b76d9b-7c82-d3bd-7858-9e831198e33c@amazon.com> <YFeAzfJsHAqPvPuY@unreal>
 <12f643b5-7a35-d960-9b1f-22853aea4b4c@amazon.com> <YFgtf6NBPMjD/U89@unreal>
 <c7b2a12d-bf81-3d5f-40ae-f70e6cfa1637@suse.com> <YFg9w980NkZzEHmb@unreal>
 <facd5d2e-510e-4fc4-5e22-c934ea237b1b@suse.com> <YFhDlLkXLSs30/Ci@unreal>
From:   "Hsu, Chiahao" <andyhsu@amazon.com>
Message-ID: <b5630c17-b167-b161-bd71-c7674b7ba454@amazon.com>
Date:   Sun, 28 Mar 2021 22:46:01 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YFhDlLkXLSs30/Ci@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.164.198]
X-ClientProxiedBy: EX13D10EUA002.ant.amazon.com (10.43.165.64) To
 EX13D12EUA002.ant.amazon.com (10.43.165.103)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Leon Romanovsky 於 2021/3/22 08:13 寫道:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>
>
>
> On Mon, Mar 22, 2021 at 08:01:17AM +0100, Jürgen Groß wrote:
>> On 22.03.21 07:48, Leon Romanovsky wrote:
>>> On Mon, Mar 22, 2021 at 06:58:34AM +0100, Jürgen Groß wrote:
>>>> On 22.03.21 06:39, Leon Romanovsky wrote:
>>>>> On Sun, Mar 21, 2021 at 06:54:52PM +0100, Hsu, Chiahao wrote:
>>>>> <...>
>>>>>
>>>>>>>> Typically there should be one VM running netback on each host,
>>>>>>>> and having control over what interfaces or features it exposes is also
>>>>>>>> important for stability.
>>>>>>>> How about we create a 'feature flags' modparam, each bits is specified for
>>>>>>>> different new features?
>>>>>>> At the end, it will be more granular module parameter that user still
>>>>>>> will need to guess.
>>>>>> I believe users always need to know any parameter or any tool's flag before
>>>>>> they use it.
>>>>>> For example, before user try to set/clear this ctrl_ring_enabled, they
>>>>>> should already have basic knowledge about this feature,
>>>>>> or else they shouldn't use it (the default value is same as before), and
>>>>>> that's also why we use the 'ctrl_ring_enabled' as parameter name.
>>>>> It solves only forward migration flow. Move from machine A with no
>>>>> option X to machine B with option X. It doesn't work for backward
>>>>> flow. Move from machine B to A back will probably break.
>>>>>
>>>>> In your flow, you want that users will set all module parameters for
>>>>> every upgrade and keep those parameters differently per-version.
>>>> I think the flag should be a per guest config item. Adding this item to
>>>> the backend Xenstore nodes for netback to consume it should be rather
>>>> easy.
>>>>
>>>> Yes, this would need a change in Xen tools, too, but it is the most
>>>> flexible way to handle it. And in case of migration the information
>>>> would be just migrated to the new host with the guest's config data.
>>> Yes, it will overcome global nature of module parameters, but how does
>>> it solve backward compatibility concern?
>> When creating a guest on A the (unknown) feature will not be set to
>> any value in the guest's config data. A migration stream not having any
>> value for that feature on B should set it to "false".
>>
>> When creating a guest on B it will either have the feature value set
>> explicitly in the guest config (either true or false), or it will get
>> the server's default (this value should be configurable in a global
>> config file, default for that global value would be "true").
>>
>> So with the guest created on B with feature specified as "false" (either
>> for this guest only, or per global config), it will be migratable to
>> machine A without problem. Migrating it back to B would work the same
>> way as above. Trying to migrate a guest with feature set to "true" to
>> B would not work, but this would be the host admin's fault due to not
>> configuring the guest correctly.
so the expected changes would be

1. remove feature-ctrl-ring & feature-dynamic-multicast-control from 
netback_probe( )
2. consume the backend Xenstore nodes in connect( ) to see if Xen tools 
set nodes(true/false) or not(unknown)

Thanks.

Andy
> As long as all new features are disabled by default, it will be ok.
>
> Thanks
>
>>
>> Juergen
>
>
>
>

