Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04AD41ADA5E
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 11:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbgDQJsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 05:48:40 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30048 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726650AbgDQJsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 05:48:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587116919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EH1XZETTMUkBMVwE0SvYImZx8kDPUe6xlEK01XCSGX4=;
        b=UAKRK6JS+P0J5af9L8MxR9GG/NM6Do6c13QCjcGSyJJSGtuHVU+T9zcd6+XfWYHPzPYigS
        cmZJzRW2+OCCvyV9wgR+M7i23uuauU9hT58dnXbGHn4Oim33AsbSk1KKAiKRDhLMkiQEwx
        Jxq+918twRwxvIs1raP/gZSo+8EcM0s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-MzTmX318NzqE3LOEWqBCMw-1; Fri, 17 Apr 2020 05:48:35 -0400
X-MC-Unique: MzTmX318NzqE3LOEWqBCMw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B26A51005509;
        Fri, 17 Apr 2020 09:48:31 +0000 (UTC)
Received: from [10.72.13.157] (ovpn-13-157.pek2.redhat.com [10.72.13.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73F3611A088;
        Fri, 17 Apr 2020 09:48:22 +0000 (UTC)
Subject: Re: [PATCH V2] vhost: do not enable VHOST_MENU by default
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, geert@linux-m68k.org,
        tsbogend@alpha.franken.de, benh@kernel.crashing.org,
        paulus@samba.org, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, Michael Ellerman <mpe@ellerman.id.au>
References: <20200416185426-mutt-send-email-mst@kernel.org>
 <b7e2deb7-cb64-b625-aeb4-760c7b28c0c8@redhat.com>
 <20200417022929-mutt-send-email-mst@kernel.org>
 <4274625d-6feb-81b6-5b0a-695229e7c33d@redhat.com>
 <20200417042912-mutt-send-email-mst@kernel.org>
 <fdb555a6-4b8d-15b6-0849-3fe0e0786038@redhat.com>
 <20200417044230-mutt-send-email-mst@kernel.org>
 <73843240-3040-655d-baa9-683341ed4786@redhat.com>
 <20200417050029-mutt-send-email-mst@kernel.org>
 <ce8a18e5-3c74-73cc-57c5-10c40af838a3@redhat.com>
 <20200417053803-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <71b98c3b-1a38-b9aa-149c-f48c92a77448@redhat.com>
Date:   Fri, 17 Apr 2020 17:48:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200417053803-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/17 =E4=B8=8B=E5=8D=885:38, Michael S. Tsirkin wrote:
> On Fri, Apr 17, 2020 at 05:33:56PM +0800, Jason Wang wrote:
>> On 2020/4/17 =E4=B8=8B=E5=8D=885:01, Michael S. Tsirkin wrote:
>>>> There could be some misunderstanding here. I thought it's somehow si=
milar: a
>>>> CONFIG_VHOST_MENU=3Dy will be left in the defconfigs even if CONFIG_=
VHOST is
>>>> not set.
>>>>
>>>> Thanks
>>>>
>>> BTW do entries with no prompt actually appear in defconfig?
>>>
>> Yes. I can see CONFIG_VHOST_DPN=3Dy after make ARCH=3Dm68k defconfig
> You see it in .config right? So that's harmless right?


Yes.

Thanks

