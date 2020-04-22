Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87321B421A
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 12:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732274AbgDVK5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 06:57:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23170 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726562AbgDVKEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 06:04:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587549884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yLmMi+rP26Fq6FaPBYLJdo35qo7Xopu6BBwUuox0rH8=;
        b=FGlFPhhcsqH0A9rkHV/NBcrTawLnna+dXGc8rQBBE86cAgMWKekaFnEGl3CNa7fmRLDawW
        5O+SWvw+8rAznzamEwlJssGpVP1CDy5LVUr9jbGKgjLwlTHvFJYiUUs5+5qV+3wdXar28D
        h0Z7W2TuKln3Tz5uyNu+muAokfoX8N4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-SN6zFPG6MwmKNyg6SmdNbA-1; Wed, 22 Apr 2020 06:04:42 -0400
X-MC-Unique: SN6zFPG6MwmKNyg6SmdNbA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 711ECDB76;
        Wed, 22 Apr 2020 10:04:41 +0000 (UTC)
Received: from ovpn-114-173.ams2.redhat.com (ovpn-114-173.ams2.redhat.com [10.36.114.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 946AA600D2;
        Wed, 22 Apr 2020 10:04:38 +0000 (UTC)
Message-ID: <41f1fe372f1fafbb8b6cd9b861586fca569a4009.camel@redhat.com>
Subject: Re: [PATCH v4] net: UDP repair mode for retrieving the send queue
 of corked UDP socket
From:   Paolo Abeni <pabeni@redhat.com>
To:     =?UTF-8?Q?Le=C5=9Fe?= Doru =?UTF-8?Q?C=C4=83lin?= 
        <lesedorucalin01@gmail.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Date:   Wed, 22 Apr 2020 12:04:37 +0200
In-Reply-To: <20200416133857.GA3923@white>
References: <20200416132242.GA2586@white> <20200416133857.GA3923@white>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-04-16 at 16:38 +0300, Le=C5=9Fe Doru C=C4=83lin wrote:
> Should I move this functionality in a getsockopt or ioctl syscall, so i=
t does not interfere with other syscalls?

Yes, please. As suggested by Eric, please avoid additional
code/conditionals in fast-path.

Thanks,

Paolo

p.s. sorry for the late reply. The current situation does not allow for
low latency.

