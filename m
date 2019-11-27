Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7F710AE6B
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 12:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfK0LD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 06:03:26 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20131 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726194AbfK0LD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 06:03:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574852605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k6afWhW0k+5vQvAI3+I3yvEiGsV/YiHUSVuZ0gqzLhc=;
        b=EGplOT7rY6CUKzV1Ejux6aZGpVi0gzrAGTsnfLEoAnLZ/pjM2AW4SzY0VL2upxmvyWmPbo
        lK9T3RBZkJ4bP9+v6KYieW6PhocEyDGm4RZCdDKA1nUbc030fn7/U4dDhUGH4JnkWME6eZ
        ng+FICi9dp5pvtb+hAOTc6oPPj8GvE8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-VMx6fb4AN96ge09SQCM90Q-1; Wed, 27 Nov 2019 06:03:22 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B6A2593A1;
        Wed, 27 Nov 2019 11:03:20 +0000 (UTC)
Received: from [10.72.12.78] (ovpn-12-78.pek2.redhat.com [10.72.12.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 217425D9D6;
        Wed, 27 Nov 2019 11:03:01 +0000 (UTC)
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
From:   Jason Wang <jasowang@redhat.com>
To:     Martin Habets <mhabets@solarflare.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, Kiran Patil <kiran.patil@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Bie, Tiwei" <tiwei.bie@intel.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
 <30b968cf-0e11-a2c6-5b9f-5518df11dfb7@solarflare.com>
 <22dd6ae3-03f4-1432-2935-8df5e9a449de@redhat.com>
 <AM0PR05MB48660C6FDCC2397045A03139D1490@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <e8ab3603-59e1-6e1c-67c2-e1a252ba0ac1@solarflare.com>
 <0b845456-54b2-564a-0979-ba55bcf3269c@redhat.com>
Message-ID: <1d9a5ee9-779e-6255-08c6-b4f57af701a6@redhat.com>
Date:   Wed, 27 Nov 2019 19:03:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <0b845456-54b2-564a-0979-ba55bcf3269c@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: VMx6fb4AN96ge09SQCM90Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/27 =E4=B8=8B=E5=8D=886:58, Jason Wang wrote:
>
>> With the virtual bus we do have a solid foundation going forward, for=20
>> the users we know now and for
>> future ones.
>
>
> If I understand correctly, if multiplexer is not preferred. It would=20
> be hard to have a bus on your own code, there's no much code could be=20
> reused.
>

Sorry, I meant "not hard to have" ...

Thanks


> Thanks=20

