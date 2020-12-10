Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53852D640A
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 18:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404059AbgLJRtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 12:49:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21079 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392643AbgLJRtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 12:49:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607622464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=klbEnFcVtDmKolwSJZc0dcQUUHNX75Nyj0/Ifjohsjo=;
        b=cwYOjEjFA88b3U6oW/favR4jeQmT0SoI/tYEkfpI5xlDdIzEeac6DJxLOkIqBmuTguJ9uH
        fcbmcgrDDGXr2knKGBFtRe5t7LcM2UxGzHAuc7dvCsTxMK1fisRQIDHgc8V6Ty0C8OUgcm
        7Jkdazy0LGl7kq63fY1lzUw5unO8u/4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-QzKXnPVlOtSnlBpIeORx_w-1; Thu, 10 Dec 2020 12:47:41 -0500
X-MC-Unique: QzKXnPVlOtSnlBpIeORx_w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC51E5708C;
        Thu, 10 Dec 2020 17:47:35 +0000 (UTC)
Received: from [10.40.192.87] (unknown [10.40.192.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF10860BF1;
        Thu, 10 Dec 2020 17:47:34 +0000 (UTC)
Message-ID: <3ca886cd8e856f01ce7d1bb77dd00390e8c75032.camel@redhat.com>
Subject: Re: [PATCH net] net: sched: Fix dump of MPLS_OPT_LSE_LABEL
 attribute in cls_flower
From:   Davide Caratti <dcaratti@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
In-Reply-To: <0e248b0464673b412d428666d10b6d3c208809bf.1607528860.git.gnault@redhat.com>
References: <0e248b0464673b412d428666d10b6d3c208809bf.1607528860.git.gnault@redhat.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Thu, 10 Dec 2020 18:47:33 +0100
MIME-Version: 1.0
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-12-09 at 16:48 +0100, Guillaume Nault wrote:
> TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL is a u32 attribute (MPLS label is
> 20 bits long).
> 
> Fixes the following bug:
> 
>  $ tc filter add dev ethX ingress protocol mpls_uc \
>      flower mpls lse depth 2 label 256             \
>      action drop
> 
>  $ tc filter show dev ethX ingress
>    filter protocol mpls_uc pref 49152 flower chain 0
>    filter protocol mpls_uc pref 49152 flower chain 0 handle 0x1
>      eth_type 8847
>      mpls
>        lse depth 2 label 0  <-- invalid label 0, should be 256
>    ...
> 
> Fixes: 61aec25a6db5 ("cls_flower: Support filtering on multiple MPLS Label Stack Entries")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Reviewed-by: Davide Caratti <dcaratti@redhat.com>



