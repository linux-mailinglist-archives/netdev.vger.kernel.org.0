Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F084227223C
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 13:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgIULXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 07:23:22 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:9480 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgIULXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 07:23:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600687402; x=1632223402;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=TwH9MzHRv79x/EUOe5/xNeRXZrG6bmMJIXJfLBWxxGQ=;
  b=YF2wvJ1D6mpruSYmJ4xIQh+LGmjQime2fvQqIINAVFuttxQGz+J3jxow
   VXVBi1UnVwi0ACZA8GuTOzurUJx3Y59PwAcQrq/rTDccEb9ZCg3Ha5gfr
   gsw2q9yIy8uU6/pbI8Fnm0qonIEt6blprcKxJM8WQghlL5eviKgBBXtDY
   8=;
X-IronPort-AV: E=Sophos;i="5.77,286,1596499200"; 
   d="scan'208";a="77900423"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 21 Sep 2020 11:23:02 +0000
Received: from EX13D19EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id D5CD3240FD9;
        Mon, 21 Sep 2020 11:22:58 +0000 (UTC)
Received: from 8c85908914bf.ant.amazon.com (10.43.161.85) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 21 Sep 2020 11:22:50 +0000
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     Jason Gunthorpe <jgg@ziepe.ca>, Oded Gabbay <oded.gabbay@gmail.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <izur@habana.ai>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, SW_Drivers <SW_Drivers@habana.ai>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <linux-rdma@vger.kernel.org>, Olof Johansson <olof@lixom.net>
References: <20200918125014.GR8409@ziepe.ca>
 <CAFCwf12oK4RXYhgzXiN_YvXvjoW1Fwx1xBzR3Y5E4RLvzn_vhA@mail.gmail.com>
 <20200918132645.GS8409@ziepe.ca>
 <CAFCwf109t5=GuNvqTqLUCiYbjLC6o2xVoLY5C-SBqbN66f6wxg@mail.gmail.com>
 <20200918135915.GT8409@ziepe.ca>
 <CAFCwf13rJgb4=as7yW-2ZHvSnUd2NK1GP0UKKjyMfkB3vsnE5w@mail.gmail.com>
 <20200918141909.GU8409@ziepe.ca>
 <CAFCwf121_UNivhfPfO6uFoHbF+2Odeb1c3+482bOXeOZUsEnug@mail.gmail.com>
 <20200918150735.GV8409@ziepe.ca>
 <CAFCwf13y1VVy90zAoBPC-Gfj6mwMVbefh3fxKDVneuscp4esqA@mail.gmail.com>
 <20200918152852.GW8409@ziepe.ca>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <b0721756-d323-b95e-b2d2-ca3ce8d4a660@amazon.com>
Date:   Mon, 21 Sep 2020 14:22:02 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918152852.GW8409@ziepe.ca>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.85]
X-ClientProxiedBy: EX13D30UWC002.ant.amazon.com (10.43.162.235) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/2020 18:28, Jason Gunthorpe wrote:
> On Fri, Sep 18, 2020 at 06:15:52PM +0300, Oded Gabbay wrote:
> 
>> I'm sorry, but you won't be able to convince me here that I need to
>> "enslave" my entire code to RDMA, just because my ASIC "also" has some
>> RDMA ports.
> 
> You can't recreate common shared subsystems in a driver just because
> you don't want to work with the subsystem.
> 
> I don't care what else the ASIC has. In Linux the netdev part is
> exposed through netdev, the RDMA part through RDMA, the
> totally-not-a-GPU part through drivers/misc.
> 
> It is always been this way. Chelsio didn't get to rebuild the SCSI
> stack in their driver just because "storage is a small part of their
> device"
> 
> Drivers are not allowed to re-implement I2C/SPI/etc without re-using
> the comon code for that just because "I2C is a small part of their
> device"
> 
> Exposing to userspace the creation of RoCE QPs and their related
> objects are unambiguously a RDMA subsystem task. I don't even know how
> you think you can argue it is not. It is your company proudly claiming
> the device has 100G RoCE ports in all the marketing literature, after
> all.
> 
> It is too bad the device has a non-standards compliant implementation
> of RoCE so this will be a bit hard for you. Oh well.

What is considered a RoCE port in this case if it's not compliant with RoCE?
Sounds like it's an implementation of RDMA over ethernet, not RoCE.
Does GAUDI support UD/RC/.. QPs? Is it using a proprietary wire protocol?
(BTW, Oded claims it's similar to nvlink, how is nvlink's implementation
exposed? Or is it closed source?)

Jason, how do you imagine GAUDI in the RDMA subsystem? Userspace control path
verbs (used by hl-thunk?) and all data path verbs exposed as kverbs (used by
habanalabs driver)?
So neither any userspace verbs apps could use it nor kernel ULPs?
