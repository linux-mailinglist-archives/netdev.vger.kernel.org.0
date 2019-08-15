Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 225C18E32A
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 05:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729791AbfHOD2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 23:28:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60636 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727750AbfHOD2M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 23:28:12 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BD71CC055673;
        Thu, 15 Aug 2019 03:28:12 +0000 (UTC)
Received: from [10.72.12.184] (ovpn-12-184.pek2.redhat.com [10.72.12.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A9C85D9DC;
        Thu, 15 Aug 2019 03:28:07 +0000 (UTC)
Subject: Re: [PATCH V5 0/9] Fixes for vhost metadata acceleration
To:     Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20190809054851.20118-1-jasowang@redhat.com>
 <20190810134948-mutt-send-email-mst@kernel.org>
 <360a3b91-1ac5-84c0-d34b-a4243fa748c4@redhat.com>
 <20190812054429-mutt-send-email-mst@kernel.org>
 <20190812130252.GE24457@ziepe.ca>
 <9a9641fe-b48f-f32a-eecc-af9c2f4fbe0e@redhat.com>
 <20190813115707.GC29508@ziepe.ca> <20190813164105.GD22640@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bba46127-ea43-f9f3-eece-0910243782c5@redhat.com>
Date:   Thu, 15 Aug 2019 11:28:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190813164105.GD22640@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 15 Aug 2019 03:28:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/14 上午12:41, Christoph Hellwig wrote:
> On Tue, Aug 13, 2019 at 08:57:07AM -0300, Jason Gunthorpe wrote:
>> On Tue, Aug 13, 2019 at 04:31:07PM +0800, Jason Wang wrote:
>>
>>> What kind of issues do you see? Spinlock is to synchronize GUP with MMU
>>> notifier in this series.
>> A GUP that can't sleep can't pagefault which makes it a really weird
>> pattern
> get_user_pages/get_user_pages_fast must not be called under a spinlock.
> We have the somewhat misnamed __get_user_page_fast that just does a
> lookup for existing pages and never faults for a few places that need
> to do that lookup from contexts where we can't sleep.


Yes, I do use __get_user_pages_fast() in the code.

Thanks

