Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C30507D4B5
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 07:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbfHAFDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 01:03:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29223 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728711AbfHAFDc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 01:03:32 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D7CC330044CC;
        Thu,  1 Aug 2019 05:03:31 +0000 (UTC)
Received: from [10.72.12.66] (ovpn-12-66.pek2.redhat.com [10.72.12.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 042175D9C9;
        Thu,  1 Aug 2019 05:03:25 +0000 (UTC)
Subject: Re: [PATCH V2 4/9] vhost: reset invalidate_count in
 vhost_set_vring_num_addr()
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20190731084655.7024-1-jasowang@redhat.com>
 <20190731084655.7024-5-jasowang@redhat.com> <20190731124124.GD3946@ziepe.ca>
 <31ef9ed4-d74a-3454-a57d-fa843a3a802b@redhat.com>
 <20190731193252.GH3946@ziepe.ca>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0a4deb4e-92e8-44e1-b20e-05767641b6ba@redhat.com>
Date:   Thu, 1 Aug 2019 13:03:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190731193252.GH3946@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 01 Aug 2019 05:03:31 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/1 上午3:32, Jason Gunthorpe wrote:
> On Wed, Jul 31, 2019 at 09:29:28PM +0800, Jason Wang wrote:
>> On 2019/7/31 下午8:41, Jason Gunthorpe wrote:
>>> On Wed, Jul 31, 2019 at 04:46:50AM -0400, Jason Wang wrote:
>>>> The vhost_set_vring_num_addr() could be called in the middle of
>>>> invalidate_range_start() and invalidate_range_end(). If we don't reset
>>>> invalidate_count after the un-registering of MMU notifier, the
>>>> invalidate_cont will run out of sync (e.g never reach zero). This will
>>>> in fact disable the fast accessor path. Fixing by reset the count to
>>>> zero.
>>>>
>>>> Reported-by: Michael S. Tsirkin <mst@redhat.com>
>>> Did Michael report this as well?
>>
>> Correct me if I was wrong. I think it's point 4 described in
>> https://lkml.org/lkml/2019/7/21/25.
> I'm not sure what that is talking about
>
> But this fixes what I described:
>
> https://lkml.org/lkml/2019/7/22/554
>
> Jason


I'm sorry I miss this, will add your name as reported-by in the next 
version.

Thanks

