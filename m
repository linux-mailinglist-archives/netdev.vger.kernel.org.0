Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA3D274259
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 14:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgIVMqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 08:46:51 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:20978 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgIVMqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 08:46:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600778810; x=1632314810;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=nziyF0gCHf+QbUZWkcNumlIIbcw7LDkmtCIhMVokIFM=;
  b=TfEOQVNe2a5SEJoigXV06ZCR+NEP1ZuUl27rQCymWfl8DCwejcAq4FJ8
   5bc57ErZ70/WjpfAJxPpRepwHb3ogep+EODSbgn9NJ+VJ39yw58T8+CL0
   s3e5hFLbBYgfNQVtfxRNe9D3kSdT70BOzmUNYMYR/j8AsFDjNXlL/POsK
   I=;
X-IronPort-AV: E=Sophos;i="5.77,290,1596499200"; 
   d="scan'208";a="56952007"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 22 Sep 2020 12:46:48 +0000
Received: from EX13D19EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id E7FC8A1869;
        Tue, 22 Sep 2020 12:46:43 +0000 (UTC)
Received: from 8c85908914bf.ant.amazon.com (10.43.161.237) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 22 Sep 2020 12:46:34 +0000
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
References: <20200918132645.GS8409@ziepe.ca>
 <CAFCwf109t5=GuNvqTqLUCiYbjLC6o2xVoLY5C-SBqbN66f6wxg@mail.gmail.com>
 <20200918135915.GT8409@ziepe.ca>
 <CAFCwf13rJgb4=as7yW-2ZHvSnUd2NK1GP0UKKjyMfkB3vsnE5w@mail.gmail.com>
 <20200918141909.GU8409@ziepe.ca>
 <CAFCwf121_UNivhfPfO6uFoHbF+2Odeb1c3+482bOXeOZUsEnug@mail.gmail.com>
 <20200918150735.GV8409@ziepe.ca>
 <CAFCwf13y1VVy90zAoBPC-Gfj6mwMVbefh3fxKDVneuscp4esqA@mail.gmail.com>
 <20200918152852.GW8409@ziepe.ca>
 <b0721756-d323-b95e-b2d2-ca3ce8d4a660@amazon.com>
 <20200922114101.GE8409@ziepe.ca>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <a16802a2-4a36-e03d-a927-c5cb7c766b99@amazon.com>
Date:   Tue, 22 Sep 2020 15:46:29 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200922114101.GE8409@ziepe.ca>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.237]
X-ClientProxiedBy: EX13D17UWB004.ant.amazon.com (10.43.161.132) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/09/2020 14:41, Jason Gunthorpe wrote:
> On Mon, Sep 21, 2020 at 02:22:02PM +0300, Gal Pressman wrote:
> 
>> What is considered a RoCE port in this case if it's not compliant with RoCE?
>> Sounds like it's an implementation of RDMA over ethernet, not RoCE.
>> Does GAUDI support UD/RC/.. QPs? Is it using a proprietary wire protocol?
>> (BTW, Oded claims it's similar to nvlink, how is nvlink's implementation
>> exposed? Or is it closed source?)
> 
> I think Oded was drawing a parallel to how nvlink is integral with the
> compute element. From Oded's descriptions I don't think it is much
> like nvlink at all.
> 
>> Jason, how do you imagine GAUDI in the RDMA subsystem? Userspace control path
>> verbs (used by hl-thunk?) and all data path verbs exposed as kverbs (used by
>> habanalabs driver)?
>> So neither any userspace verbs apps could use it nor kernel ULPs?
> 
> Based on what Oded described it seems like a reasonable RDMA device
> with some limitations around MR IOVA.
> 
> Looks like the desire is to create a RDMA WR and CQ ring in userspace,
> and then co-mingle that with the compute side of the device.
> 
> So instead of doing the special IOCTL and mmap against the compute FD
> it would create a RDMA QP and RDMA CQ, use dv to access the raw
> internals, and the propritary stack would have exactly the same stuff
> it would have had with the misc ioctl.
> 
> But, completely separately, they'd also have to implement some of
> verbs which serves as the open source userspace showing how this HW
> works. What that is depends largely on what their HW can do, and if
> they want to connect to UCX/mpi/libfabric/etc
> 
> A bunch of ioctl stubs or a few tests is far below our standard in
> RDMA.
> 
> There may have been some argument that the compute side of this device
> has no industry standards so should be a drivers/misc, but HPC
> networking *does* have extensive standards and extensive open source
> software stacks. It is very hard for me to see how a device in this
> market could be competitive without integrating with that stuff.

I agree, that makes sense.
But assuming Oded actually goes and implements all the needed verbs to get a
basic functional libibverbs provider (assuming their HW can do it somehow), is
it really useful if no one is going to use it?
It doesn't sound like habanalabs want people to use GAUDI as an RDMA adapter,
and I'm assuming the only real world use case is going to be using the hl stack,
which means we're left with a lot of dead code that's not used/tested by anyone.

Genuine question, wouldn't it be better if they only implement what's actually
going to be used and tested by their customers?
