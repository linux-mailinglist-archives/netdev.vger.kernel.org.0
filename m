Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306AE2013F4
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 18:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393039AbgFSQGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 12:06:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37454 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2394156AbgFSQGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 12:06:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592582784;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pI1rax/V9oHTSj2u7yISulPzydxjiPQ7BjYV44sXLw8=;
        b=b1GNG45uIYPnIW9PBls5nnTth+46LosZT3K7ziBMltpTJfh2m1gAImPrMU7uHYSvp5f52X
        KU8LwgXD5mKeJmPZ++I1MmmSB9uEKlwMFaR/wZlqWPR4Z/5cGsyxlx6dUMp9qDkG7Xv72P
        DDPpsY/FWB/rhWnFOd4XSNt2UCg/FzE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-hjbPAmIBNcKUcLaVMv25jA-1; Fri, 19 Jun 2020 12:06:22 -0400
X-MC-Unique: hjbPAmIBNcKUcLaVMv25jA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DF75107B7C6;
        Fri, 19 Jun 2020 16:06:21 +0000 (UTC)
Received: from jtoppins.rdu.csb (ovpn-119-209.rdu2.redhat.com [10.10.119.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA62C1C94D;
        Fri, 19 Jun 2020 16:06:20 +0000 (UTC)
Reply-To: jtoppins@redhat.com
Subject: Re: [PATCH net] ionic: tame the watchdog timer on reconfig
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net
References: <20200618172904.53814-1-snelson@pensando.io>
From:   Jonathan Toppins <jtoppins@redhat.com>
Organization: Red Hat
Message-ID: <086f01c2-b8ab-3a92-2a1b-b53fa1e0245b@redhat.com>
Date:   Fri, 19 Jun 2020 12:06:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200618172904.53814-1-snelson@pensando.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/18/20 1:29 PM, Shannon Nelson wrote:
> Even with moving netif_tx_disable() to an earlier point when
> taking down the queues for a reconfiguration, we still end
> up with the occasional netdev watchdog Tx Timeout complaint.
> The old method of using netif_trans_update() works fine for
> queue 0, but has no effect on the remaining queues.  Using
> netif_device_detach() allows us to signal to the watchdog to
> ignore us for the moment.
> 
> Fixes: beead698b173 ("ionic: Add the basic NDO callbacks for netdev support")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Acked-by: Jonathan Toppins <jtoppins@redhat.com>

