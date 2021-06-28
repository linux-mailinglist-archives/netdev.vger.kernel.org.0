Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B0B3B5A69
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 10:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbhF1IZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 04:25:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24926 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232308AbhF1IZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 04:25:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624868574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hfbf0q6N4YJ3ZB/zpvQoM2U9tRNz7A0FXI1DCovCZlQ=;
        b=d4IzihVmgaQQW2wYIMEg0pxUlXTwY7Jf1xLmFlknSZatlCO9R2s8d8XSqnMmAk4ZXEmFRf
        xlOmJile0y5xflp6zUMeoD4jOCxKSDl2MuioWjO3tk8pnoAGuK5/4QFv4EMnmXcR3IPmcZ
        0XrWN5kP1VpR3G+jGpTd48f+qdZML50=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-NilkxSGwNO65JN8Ew0ERcg-1; Mon, 28 Jun 2021 04:22:53 -0400
X-MC-Unique: NilkxSGwNO65JN8Ew0ERcg-1
Received: by mail-wr1-f69.google.com with SMTP id g8-20020a5d54080000b0290124a2d22ff8so3749815wrv.4
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 01:22:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Hfbf0q6N4YJ3ZB/zpvQoM2U9tRNz7A0FXI1DCovCZlQ=;
        b=Xi1xWvUj8LY0+y3CEvF5B7tRNxMsoRziD3D99MXNA2qy2y49AuuB8ZzxkedXrfd9X2
         YJs6SAbtstuj9yssYJQuoc99mbuFdd6p3holkBZmhpaoHYqGn6QMQzrvijZxYKe7L+/S
         mgG9DHPLHvQAS+Fr78aM57smmlGcZAwknecphK1emd1QiSAAjAkvNJGj6ywS8vDUa5K7
         89ogIluiD4zhEPZ5bGYjX+cFRgeZkZNINxWsH2ZFXHtS2X7xlKp1/+jgh1kAObmwDZHC
         QBB9dWTZ3IepEagxcCPNQpxXEqVVhtmV+mQsP0c30H4Ylzg8SuNwIDhG9tx/tWYvX4jT
         IDIg==
X-Gm-Message-State: AOAM532guUFFOLgqFmuyaycThc2GQbnVdezqWqQFH0deHyh3YOlUrF2a
        R1PXI5P+27BEJ8gPJnw04nX9Rra6GSaSz0kjPQbEgnBspU5+yPbHGgxLDDuwYJ3gdRRJbCrdHia
        VE/ZQRVhmHKX0y3wg
X-Received: by 2002:a1c:e907:: with SMTP id q7mr25143316wmc.1.1624868571634;
        Mon, 28 Jun 2021 01:22:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/im28MAWluQn9OsVs7Z3xj/WK+OmNVFNYJtVqrY9eJACxlCeFAB/EBM3dI/1j9qXOGGfrYQ==
X-Received: by 2002:a1c:e907:: with SMTP id q7mr25143303wmc.1.1624868571499;
        Mon, 28 Jun 2021 01:22:51 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-109-224.dyn.eolo.it. [146.241.109.224])
        by smtp.gmail.com with ESMTPSA id a24sm18722086wmj.30.2021.06.28.01.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 01:22:51 -0700 (PDT)
Message-ID: <5a265895487d8f61c30b9495bada893f92a8baf7.camel@redhat.com>
Subject: Re: [PATCH net-next] mptcp: fix 'masking a bool' warning
From:   Paolo Abeni <pabeni@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        Dan Carpenter <dan.carpenter@oracle.com>
Date:   Mon, 28 Jun 2021 10:22:50 +0200
In-Reply-To: <20210625212522.264000-1-mathew.j.martineau@linux.intel.com>
References: <20210625212522.264000-1-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-06-25 at 14:25 -0700, Mat Martineau wrote:
> From: Matthieu Baerts <matthieu.baerts@tessares.net>
> 
> Dan Carpenter reported an issue introduced in
> commit fde56eea01f9 ("mptcp: refine mptcp_cleanup_rbuf") where a new
> boolean (ack_pending) is masked with 0x9.
> 
> This is not the intention to ignore values by using a boolean. This
> variable should not have a 'bool' type: we should keep the 'u8' to allow
> this comparison.
> 
> Fixes: fde56eea01f9 ("mptcp: refine mptcp_cleanup_rbuf")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

Acked-by: Paolo Abeni <pabeni@redhat.com>

