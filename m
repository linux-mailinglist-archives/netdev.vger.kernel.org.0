Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC13DAB865
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 14:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404783AbfIFMvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 08:51:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37400 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404772AbfIFMvk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 08:51:40 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 383D38980E3;
        Fri,  6 Sep 2019 12:51:39 +0000 (UTC)
Received: from [10.72.12.95] (ovpn-12-95.pek2.redhat.com [10.72.12.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D1A260605;
        Fri,  6 Sep 2019 12:51:30 +0000 (UTC)
Subject: Re: [PATCH 2/2] vhost: re-introducing metadata acceleration through
 kernel virtual address
To:     Hillf Danton <hdanton@sina.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@mellanox.com,
        aarcange@redhat.com, jglisse@redhat.com, linux-mm@kvack.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@infradead.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org
References: <20190905122736.19768-1-jasowang@redhat.com>
 <20190906032154.9376-1-hdanton@sina.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <cd2ed116-4b19-73b2-a3f0-4377cc0f2db3@redhat.com>
Date:   Fri, 6 Sep 2019 20:51:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190906032154.9376-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Fri, 06 Sep 2019 12:51:39 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/6 上午11:21, Hillf Danton wrote:
> On Thu,  5 Sep 2019 20:27:36 +0800 From:   Jason Wang <jasowang@redhat.com>
>> +static void vhost_set_map_dirty(struct vhost_virtqueue *vq,
>> +				struct vhost_map *map, int index)
>> +{
>> +	struct vhost_uaddr *uaddr = &vq->uaddrs[index];
>> +	int i;
>> +
>> +	if (uaddr->write) {
>> +		for (i = 0; i < map->npages; i++)
>> +			set_page_dirty(map->pages[i]);
>> +	}
> Not sure need to set page dirty under page lock.


Just to make sure I understand the issue. Do you mean there's no need 
for set_page_dirty() here? If yes, is there any other function that 
already did this?

Thanks

