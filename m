Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5E2B10E4B8
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 03:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfLBC4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 21:56:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36859 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727301AbfLBC4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 21:56:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575255375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nzz1d6fNBXps/DnIs5UAQiNGoXHliCVcfy6g5+mgQoM=;
        b=BxDvaYHT6UmdzK750JSUQrLk4a2p2ydsJgIGcwedUTq2jx2AeOMsqCdp1oDKTn9JBD8e+F
        LbbxasvdUHRsHWE1ZZOrUE7sTiAu50q2mBdmkwZ/8lxiMuIkJzF8Egrt9j4Ezrq9fQ5yUl
        aZLr+jC/wahg0HOIKkgJsA4pV0vOIMM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-zMKLkK5MNLCjozNN_3opZg-1; Sun, 01 Dec 2019 21:56:11 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B525B800D41;
        Mon,  2 Dec 2019 02:56:09 +0000 (UTC)
Received: from [10.72.12.226] (ovpn-12-226.pek2.redhat.com [10.72.12.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F8AF5D6A0;
        Mon,  2 Dec 2019 02:56:01 +0000 (UTC)
Subject: Re: [RFC net-next 08/18] tun: run offloaded XDP program in Tx path
To:     David Miller <davem@davemloft.net>, mst@redhat.com
Cc:     dsahern@gmail.com, prashantbhole.linux@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        netdev@vger.kernel.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <f39536e4-1492-04e6-1293-302cc75e81bf@gmail.com>
 <20191201.125621.1568040486743628333.davem@davemloft.net>
 <20191201163730-mutt-send-email-mst@kernel.org>
 <20191201.135439.2128495024712395126.davem@davemloft.net>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <71cb13b9-fe81-c338-68dc-4d432360a0fb@redhat.com>
Date:   Mon, 2 Dec 2019 10:56:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191201.135439.2128495024712395126.davem@davemloft.net>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: zMKLkK5MNLCjozNN_3opZg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/12/2 =E4=B8=8A=E5=8D=885:54, David Miller wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> Date: Sun, 1 Dec 2019 16:40:22 -0500
>
>> Right. But it is helpful to expose the supported functionality
>> to guest in some way, if nothing else then so that
>> guests can be moved between different hosts.
>>
>> Also, we need a way to report this kind of event to guest
>> so it's possible to figure out what went wrong.
> On the contrary, this is why it is of utmost importance that all
> XDP implementations support the full suite of XDP facilities from
> the very beginning.
>
> This is why we keep giving people a hard time when they add support
> only for some of the XDP return values and semantics.  Users will get
> killed by this, and it makes XDP a poor technology to use because
> behavior is not consistent across device types.
>
> That's not acceptable and I'll push back on anything that continues
> this trend.
>
> If you can't HW offload it, kick it to software.


We can try to work out a solution for XDP_REDIRECT.

Thanks

