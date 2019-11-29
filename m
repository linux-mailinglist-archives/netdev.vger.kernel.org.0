Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4CC10D72B
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 15:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfK2Oj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 09:39:59 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55103 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727011AbfK2Oj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 09:39:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575038398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FfyXChrBe1vZ1PcTn0iTJTc7p7Xm2eml7LrBbaxtCas=;
        b=h2Z4p+9lzt83uKoRyK69/duN2d7B7CCKGflpZEyTTgo2nkoNVLD+di6KXGhOg32GO96F2h
        Xumr+7698f3KvT5WzKmOO6+3xmwvcMJA1HKu+d0tsv8D5x9S4oyoflSiYjyBk7l8nZUxNS
        hrmmNIAbDiGoaYa0qcZ616O+6ZpjHQQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-frV0228iPLGX0XOTTtzT5g-1; Fri, 29 Nov 2019 09:39:55 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A06A9800D41;
        Fri, 29 Nov 2019 14:39:53 +0000 (UTC)
Received: from elisabeth (ovpn-200-40.brq.redhat.com [10.40.200.40])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 939A4600C8;
        Fri, 29 Nov 2019 14:39:51 +0000 (UTC)
Date:   Fri, 29 Nov 2019 15:39:45 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, shuah@kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH] selftests: pmtu: use -oneline for ip route list cache
Message-ID: <20191129153945.03836fea@elisabeth>
In-Reply-To: <20191128185806.23706-1-cascardo@canonical.com>
References: <20191128185806.23706-1-cascardo@canonical.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: frV0228iPLGX0XOTTtzT5g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 28 Nov 2019 15:58:06 -0300
Thadeu Lima de Souza Cascardo <cascardo@canonical.com> wrote:

> Some versions of iproute2 will output more than one line per entry, which
> will cause the test to fail, like:
> 
> TEST: ipv6: list and flush cached exceptions                        [FAIL]
>   can't list cached exceptions
> 
> That happens, for example, with iproute2 4.15.0. When using the -oneline
> option, this will work just fine:
> 
> TEST: ipv6: list and flush cached exceptions                        [ OK ]
> 
> This also works just fine with a more recent version of iproute2, like
> 5.4.0.
> 
> For some reason, two lines are printed for the IPv4 test no matter what
> version of iproute2 is used. Use the same -oneline parameter there instead
> of counting the lines twice.

Thanks, it looks definitely more robust this way.

Fixes: b964641e9925 ("selftests: pmtu: Make list_flush_ipv6_exception test more demanding")

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

Acked-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

