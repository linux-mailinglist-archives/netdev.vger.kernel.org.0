Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0343716F7AF
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 06:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgBZFxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 00:53:38 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59122 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725789AbgBZFxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 00:53:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582696416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tRAP6xiiiSc4eL0r9oRNYE+vM0MzAyVXhIil2vzVo00=;
        b=GbK7lnoh0CKU7tfq5b+qZoHkXbUAxvaZMVK2V1nS6WQTo4QhzZ7LI5xRZfzQaZRco75LN0
        muBKTOScGmZWND8vZanqAYQVAP1IhKNX0ByYG7pAZkel6S4GF2qrkoAVTFqr/IT9NDrS5e
        kRfVSXEvbkxl25MsJX5grOtUh4pLrd0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-08cJEsX_MQ65qGfC4AvnBQ-1; Wed, 26 Feb 2020 00:53:35 -0500
X-MC-Unique: 08cJEsX_MQ65qGfC4AvnBQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1E5C801A06;
        Wed, 26 Feb 2020 05:53:33 +0000 (UTC)
Received: from [10.72.13.217] (ovpn-13-217.pek2.redhat.com [10.72.13.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87BD092D02;
        Wed, 26 Feb 2020 05:53:24 +0000 (UTC)
Subject: Re: virtio_net: can change MTU after installing program
To:     David Ahern <dahern@digitalocean.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7df5bb7f-ea69-7673-642b-f174e45a1e64@digitalocean.com>
 <07bb0ad3-c3e9-4a23-6e75-c3df6a557dcf@redhat.com>
 <bcd3721e-5938-d12d-d0e6-b53d337ff7ff@digitalocean.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d4d65b88-b825-b380-22d2-bc61d50248b4@redhat.com>
Date:   Wed, 26 Feb 2020 13:53:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <bcd3721e-5938-d12d-d0e6-b53d337ff7ff@digitalocean.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/26 =E4=B8=8B=E5=8D=8812:31, David Ahern wrote:
> On 2/25/20 9:02 PM, Jason Wang wrote:
>>> The simple solution causes a user visible change with 'ip -d li sh' b=
y
>>> showing a changing max mtu, but the ndo has a poor user experience in
>>> that it just fails EINVAL (their is no extack) which is confusing sin=
ce,
>>> for example, 8192 is a totally legit MTU. Changing the max does retur=
n a
>>> nice extack message.
>>
>> Or for simplicity, just forbid changing MTU when program is installed?
> My preference is to show the reduced max MTU when a program is
> installed. Allows the mtu to be increased to the max XDP allows for the
> device.
>

Yes, that's better. But may requires changes in both qemu and virtio=20
spec to work.

Do you want to address them? Or if it's not urgent, I can add this in my=20
todo list and address it in the future.

Thanks


