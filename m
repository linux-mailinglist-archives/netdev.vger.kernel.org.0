Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE5C2746B0
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 18:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgIVQay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 12:30:54 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:56224 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbgIVQay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 12:30:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600792253; x=1632328253;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=K4HWuij3R4oEOk1m1Z6GT4wg3YqvVFj3qM8OdKI1HL8=;
  b=hlVGyjSFPSWTXGPaZJaeFF45OCjpEWkfZFbJmI+1XCdQHL8TTxnINK8V
   UO9O6hYpwO3/Okq1eWUhNNPy1/89S4DtGFp1XmDVVHOpFs5Bu4SCoSjhA
   6NVZ/qVptJpCg3zbj9e16SZSTCKK6ZNs7RZs4RN37B9kfrlSepQOpMIJI
   Q=;
X-IronPort-AV: E=Sophos;i="5.77,291,1596499200"; 
   d="scan'208";a="57002667"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 22 Sep 2020 16:30:52 +0000
Received: from EX13D19EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 37AAB281FDE;
        Tue, 22 Sep 2020 16:30:47 +0000 (UTC)
Received: from 8c85908914bf.ant.amazon.com (10.43.161.237) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 22 Sep 2020 16:30:39 +0000
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Oded Gabbay <oded.gabbay@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <izur@habana.ai>, Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, SW_Drivers <SW_Drivers@habana.ai>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <linux-rdma@vger.kernel.org>, Olof Johansson <olof@lixom.net>
References: <20200918135915.GT8409@ziepe.ca>
 <CAFCwf13rJgb4=as7yW-2ZHvSnUd2NK1GP0UKKjyMfkB3vsnE5w@mail.gmail.com>
 <20200918141909.GU8409@ziepe.ca>
 <CAFCwf121_UNivhfPfO6uFoHbF+2Odeb1c3+482bOXeOZUsEnug@mail.gmail.com>
 <20200918150735.GV8409@ziepe.ca>
 <CAFCwf13y1VVy90zAoBPC-Gfj6mwMVbefh3fxKDVneuscp4esqA@mail.gmail.com>
 <20200918152852.GW8409@ziepe.ca>
 <b0721756-d323-b95e-b2d2-ca3ce8d4a660@amazon.com>
 <20200922114101.GE8409@ziepe.ca>
 <a16802a2-4a36-e03d-a927-c5cb7c766b99@amazon.com>
 <20200922161429.GI8409@ziepe.ca>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <e06c573a-99a7-906c-8197-847a61fba44a@amazon.com>
Date:   Tue, 22 Sep 2020 19:30:32 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200922161429.GI8409@ziepe.ca>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.237]
X-ClientProxiedBy: EX13D03UWA001.ant.amazon.com (10.43.160.141) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/09/2020 19:14, Jason Gunthorpe wrote:
> On Tue, Sep 22, 2020 at 03:46:29PM +0300, Gal Pressman wrote:
> 
>> I agree, that makes sense.
>> But assuming Oded actually goes and implements all the needed verbs to get a
>> basic functional libibverbs provider (assuming their HW can do it somehow), is
>> it really useful if no one is going to use it?
>> It doesn't sound like habanalabs want people to use GAUDI as an RDMA adapter,
>> and I'm assuming the only real world use case is going to be using the hl stack,
>> which means we're left with a lot of dead code that's not used/tested by anyone.
>>
>> Genuine question, wouldn't it be better if they only implement what's actually
>> going to be used and tested by their customers?
> 
> The general standard for this 'accel' hardware, both in DRM and RDMA
> is to present an open source userspace. Companies are encouraged to
> use that as their main interface but I suppose are free to carry the
> cost of dual APIs, and the community's wrath if they want.

I didn't mean they should maintain two interfaces.
The question is whether they should implement libibverbs support that covers the
cases used by their stack, or should they implement all "mandatory" verbs so
they could be able to run libibverbs' examples/perftest/pyverbs as well, even
though these will likely be the only apps covering these verbs.
