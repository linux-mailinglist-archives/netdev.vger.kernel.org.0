Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9422D42B0
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 16:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbfJKOWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 10:22:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36580 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728414AbfJKOWh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 10:22:37 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4CF94C01FBD9
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 14:22:37 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id g65so9068008qkf.19
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 07:22:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3/69IjnpthyAsYWKUyauhiINSOqY8C5ksx6fR2DlmR8=;
        b=cp1risq9kd9jVtJjJ3mxpBG0YyJ6umx8qa+ZMthSTCN39k2jzkHoV14wuuwZiM8Nek
         F6weQsnBsTQnJPi+H4yIuYPaVVuJ+0uWENBOQhNQ1ADT2NrN5l0p2MmYJSwaREVcAUNW
         fYYvfSGU37D+L8LzUXFgZw3Q1g1rZGM4g5U8QL1HDBQ0Si7ZBbbXm296y0r0JbVS0ZiE
         giAvuWKPw7K1uNhI8TItCPM3SG16sj20znPaPf0d6Xiim26vxLDC4xzOrFb5+S2mpJ8X
         BjnGhdsB6bc7C59FlKv032HF/yuBn/rwR+rFJwlROEV9xXQTzOaVtIp8BpUQgQXtnsA9
         BVEg==
X-Gm-Message-State: APjAAAX+1Xr/Ika450bmln8zKAXCnGcTD+oN/JCs1H+XuxZClh6xMmJg
        ewf6kqRpjrzCOQFo8dCjjv2ZpEXOtzHl90IrhO7CQwh1jRRNqkG9zfFwUKc4Qil4RlxqIQdrTOj
        z/hVA/1ZBvaN2uG3e
X-Received: by 2002:ac8:6c4:: with SMTP id j4mr17178015qth.235.1570803756538;
        Fri, 11 Oct 2019 07:22:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyypmt8JVfwhZN2RwBVS/3yah5jYZ2+VyE0up3EqHheFxjCMjltd5zsKzuYpHN6h2SBGBQ1eg==
X-Received: by 2002:ac8:6c4:: with SMTP id j4mr17177991qth.235.1570803756356;
        Fri, 11 Oct 2019 07:22:36 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id q47sm6531138qtq.95.2019.10.11.07.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 07:22:35 -0700 (PDT)
Date:   Fri, 11 Oct 2019 10:22:30 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Adit Ranadive <aditr@vmware.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] vsock: add half-closed socket details in the
 implementation notes
Message-ID: <20191011101936-mutt-send-email-mst@kernel.org>
References: <20191011130758.22134-1-sgarzare@redhat.com>
 <20191011130758.22134-2-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011130758.22134-2-sgarzare@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 03:07:57PM +0200, Stefano Garzarella wrote:
> vmci_transport never allowed half-closed socket on the host side.
> Since we want to have the same behaviour across all transports, we
> add a section in the "Implementation notes".
> 
> Cc: Jorgen Hansen <jhansen@vmware.com>
> Cc: Adit Ranadive <aditr@vmware.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/af_vsock.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index 2ab43b2bba31..27df57c2024b 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -83,6 +83,10 @@
>   *   TCP_ESTABLISHED - connected
>   *   TCP_CLOSING - disconnecting
>   *   TCP_LISTEN - listening
> + *
> + * - Half-closed socket is supported only on the guest side. recv() on the host
> + * side should return EOF when the guest closes a connection, also if some
> + * data is still in the receive queue.
>   */
>  
>  #include <linux/types.h>

That's a great way to lose data in a way that's hard to debug.

VMCI sockets connect to a hypervisor so there's tight control
of what the hypervisor can do.

But vhost vsocks connect to a fully fledged Linux, so
you can't assume this is safe. And application authors do not read
kernel source.

> -- 
> 2.21.0
