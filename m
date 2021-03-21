Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CF83434F2
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 22:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhCUVBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 17:01:14 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:52568 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhCUVAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 17:00:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1616360446; x=1647896446;
  h=to:cc:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=bR/zGL5bgmIYKJX4KBNvUn1W7VU3s2jvkoCpPNEsc+Y=;
  b=D+80gHtukbZoYMZx8KbnoPhQyra/OZnnFHS7/XDep9bqxDXTZIR6vCnz
   QPj3mzZEIsBYjFWqDHndISrWokjBAmCVvGwbjXEttGPPUj/uei55tI48E
   X+278dJOrIIHhVvRDJopZNwLlJpG4irJX3jgW5vS5CrNLmtVVq33SztIU
   c=;
X-IronPort-AV: E=Sophos;i="5.81,266,1610409600"; 
   d="scan'208";a="99384150"
Subject: Re: [net-next 1/2] xen-netback: add module parameter to disable ctrl-ring
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 21 Mar 2021 21:00:39 +0000
Received: from EX13D12EUA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id C740FA1F51;
        Sun, 21 Mar 2021 21:00:36 +0000 (UTC)
Received: from 147dda3ee008.ant.amazon.com (10.43.166.52) by
 EX13D12EUA002.ant.amazon.com (10.43.165.103) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 21 Mar 2021 21:00:33 +0000
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Leon Romanovsky <leon@kernel.org>, <netdev@vger.kernel.org>,
        <wei.liu@kernel.org>, <paul@xen.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <xen-devel@lists.xenproject.org>
References: <20210311225944.24198-1-andyhsu@amazon.com>
 <YEuAKNyU6Hma39dN@lunn.ch> <ec5baac1-1410-86e4-a0d1-7c7f982a0810@amazon.com>
 <YEvQ6z5WFf+F4mdc@lunn.ch> <YE3foiFJ4sfiFex2@unreal>
 <64f5c7a8-cc09-3a7f-b33b-a64d373aed60@amazon.com> <YFI676dumSDJvTlV@unreal>
 <f3b76d9b-7c82-d3bd-7858-9e831198e33c@amazon.com> <YFeAzfJsHAqPvPuY@unreal>
 <12f643b5-7a35-d960-9b1f-22853aea4b4c@amazon.com> <YFeso1fr1hLxi3lR@lunn.ch>
From:   "Hsu, Chiahao" <andyhsu@amazon.com>
Message-ID: <818b5f7c-92ce-dca9-ee83-c6220c8292da@amazon.com>
Date:   Sun, 21 Mar 2021 22:00:21 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YFeso1fr1hLxi3lR@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.166.52]
X-ClientProxiedBy: EX13D10EUA003.ant.amazon.com (10.43.165.52) To
 EX13D12EUA002.ant.amazon.com (10.43.165.103)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Andrew Lunn 於 2021/3/21 21:29 寫道:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>
>
>
>>> At the end, it will be more granular module parameter that user still
>>> will need to guess.
>> I believe users always need to know any parameter or any tool's flag before
>> they use it.
>> For example, before user try to set/clear this ctrl_ring_enabled, they
>> should already have basic knowledge about this feature,
>> or else they shouldn't use it (the default value is same as before), and
>> that's also why we use the 'ctrl_ring_enabled' as parameter name.
> To me, it seems you are fixing this problem in the wrong place. As a
> VM user in the cloud, i have no idea how the cloud provider needs the
> VM configured to allow the cloud provider to migrate the VM to
> somewhere else in the bitbarn. As the VM user, it should not be my
> problem. I would expect the cloud provider to configure the VM host to
> only expose facilities to the VM which allows it to be migrated.
'the users' I mentioned it's the cloud provider, not a VM user. Sorry 
for the confusion.
And agree with you, just wondering how the cloud provider can expose the 
facilities to the VM if there's no way to set/clr it at runtime, unless 
reconfigure kernel?  These features are enabled by default.
>
> This is a VM host problem, not a VM problem.
>
>       Andrew


Thanks

