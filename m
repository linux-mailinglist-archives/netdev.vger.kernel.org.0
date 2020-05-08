Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7632F1CA06F
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 03:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgEHB7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 21:59:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50119 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726518AbgEHB7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 21:59:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588903183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uMn5kXEMwwk6mUv6PTZwumoxAF7POIcplX3ZxztB3/w=;
        b=E4TVMuBhItj+lmZEpOm8e/h3ystQ7Q0+Qp8oA9sZzKLP13YuyYzCeClnQ2HkzJCwB+Qj7l
        Yu5PXl4gXrP+67PumGouG39L3aF2hd4hGQkVoVY4Ww73uCmxwYfkhFWw2CaSdZwsZDYRvZ
        E8keP2HMUvHSmiBvE/CQvBpPctV6mxk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-3y5hWrAsPU-uIiXsi-giRw-1; Thu, 07 May 2020 21:59:41 -0400
X-MC-Unique: 3y5hWrAsPU-uIiXsi-giRw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DCBE80B72B;
        Fri,  8 May 2020 01:59:40 +0000 (UTC)
Received: from [10.72.13.98] (ovpn-13-98.pek2.redhat.com [10.72.13.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4300E579AD;
        Fri,  8 May 2020 01:59:31 +0000 (UTC)
Subject: Re: [PATCH net-next 1/2] virtio-net: don't reserve space for vnet
 header for XDP
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        "Jubran, Samih" <sameehj@amazon.com>
References: <20200506061633.16327-1-jasowang@redhat.com>
 <20200506102123.739f1233@carbon>
 <3ecb558b-5281-2497-db3c-6aae7d7f882b@redhat.com>
 <20200506054619-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e1b67a0a-8499-39f9-0132-2ea62205289e@redhat.com>
Date:   Fri, 8 May 2020 09:59:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200506054619-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/5/6 下午5:46, Michael S. Tsirkin wrote:
>>> There
>>> are a lot of unanswered questions on how this will be implemented.
>>> Thus, I cannot layout how we are going to leverage this info yet, but
>>> your patch are killing this info, which IHMO is going in the wrong
>>> direction.
>> I can copy vnet header ahead of data_hard_start, does it work for you?
>>
>> Thanks
> That's likely to be somewhat expensive.


Any better approach? Note that it's not the issue that is introduced in 
this patch. Anyhow the header adjustment may just overwrite the vnet 
header even without this patch.

Thanks

