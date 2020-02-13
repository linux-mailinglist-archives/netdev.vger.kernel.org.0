Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE46B15C796
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 17:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgBMPWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 10:22:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48126 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727665AbgBMPWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 10:22:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581607336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sg7JP3JVay2T20YRvFn/u3cS+1B1NiES9y/sI/tFeig=;
        b=aJHQYf9Cy9usHlCgzT6AI9bvLcDMZNrydzfXAHnoUR/+u5zkjT7XiO5EWnpycFWy3d1X+X
        KU+w5TMz9M84HXJYJk2c0G8EwSrx6CpM/k/h17eIy+gJaylgTd2WliYRNthT4CzbUbIsds
        zH0+UdBUmeYGr9FzllnVrB00mD8hJm8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-c64aTuVgNGC2tCQYBesUgg-1; Thu, 13 Feb 2020 10:22:12 -0500
X-MC-Unique: c64aTuVgNGC2tCQYBesUgg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12F1410CE786;
        Thu, 13 Feb 2020 15:22:11 +0000 (UTC)
Received: from ovpn-112-23.rdu2.redhat.com (ovpn-112-23.rdu2.redhat.com [10.10.112.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C19148AC23;
        Thu, 13 Feb 2020 15:22:09 +0000 (UTC)
Message-ID: <34daecbeb05d31e30ef11574f873553290c29d16.camel@redhat.com>
Subject: Re: [PATCH 0/2] Migrate QRTR Nameservice to Kernel
From:   Dan Williams <dcbw@redhat.com>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 13 Feb 2020 09:22:39 -0600
In-Reply-To: <20200213091427.13435-1-manivannan.sadhasivam@linaro.org>
References: <20200213091427.13435-1-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-02-13 at 14:44 +0530, Manivannan Sadhasivam wrote:
> Hello,
> 
> This patchset migrates the Qualcomm IPC Router (QRTR) Nameservice
> from userspace
> to kernel under net/qrtr.
> 
> The userspace implementation of it can be found here:
> https://github.com/andersson/qrtr/blob/master/src/ns.c
> 
> This change is required for enabling the WiFi functionality of some
> Qualcomm
> WLAN devices using ATH11K without any dependency on a userspace
> daemon.

Just out of curiousity, what's the motivation for not requiring a
userspace daemon? What are the downsides of the current userspace
daemon implementation?

Dan

> The original userspace code is published under BSD3 license. For
> migrating it
> to Linux kernel, I have adapted Dual BSD/GPL license.
> 
> This patchset has been verified on Dragonboard410c and Intel NUC with
> QCA6390
> WLAN device.
> 
> Thanks,
> Mani
> 
> Manivannan Sadhasivam (2):
>   net: qrtr: Migrate nameservice to kernel from userspace
>   net: qrtr: Fix the local node ID as 1
> 
>  net/qrtr/Makefile |   2 +-
>  net/qrtr/ns.c     | 730
> ++++++++++++++++++++++++++++++++++++++++++++++
>  net/qrtr/qrtr.c   |  51 +---
>  net/qrtr/qrtr.h   |   4 +
>  4 files changed, 746 insertions(+), 41 deletions(-)
>  create mode 100644 net/qrtr/ns.c
> 

