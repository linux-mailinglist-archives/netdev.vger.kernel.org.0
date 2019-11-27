Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D579D10AECB
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 12:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfK0Lio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 06:38:44 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50135 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726219AbfK0Lio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 06:38:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574854722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h5tpEqO+wGu590B9l8gWu8dMstk0LXzAJSva1FoVaD0=;
        b=aJJbxyhNxYTb8faSR85v2MlvwHREeShFZ5jg7xGgbDvUjCNRipMMTM+UOVZAGHRI3yTC6X
        +W0GE5JmfEKIWHhcnenwb8K5idDfSNozL2KSuijAGwKxnsgjP1QxDr7kB7iJFCUkCTtEfm
        MkVRGFfVnU+BVdiluBu3fAEHI18HtDA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-lNVH7iMZM0GUld5kG3RFyg-1; Wed, 27 Nov 2019 06:38:40 -0500
Received: by mail-wm1-f72.google.com with SMTP id t203so2277734wmt.7
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 03:38:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gB/Wj4XkNOl04gutjt7FkVMp5zt/tHRhcrcqk436DGA=;
        b=pQAnBkm/84TO+Nv4RX/iyEhpvqx9mcCIg9/3gD2UkXwlzaAN/bO1mnQIlbm5RIQq6x
         XIVPtpzuxlvHx3+rXFjN5XgabAn/HbUCYjlPqZ+FPvdL+IM7yHfPQ9cl3z32nMRekOXi
         AjUG/jx6H9RYwbQYP+x5gORV1aiZ84dEmTHv3iRWP1oaCRc7HRzM9zpbfzYfi3uGRo7N
         fYHnZNvm+hmuwr2Wj7uaGK+vJT0o5pr21JhjyxSaSdJPvmpyE4VWm0dRRW5aBk5Fy0Xm
         hwUhR8nl8yMS+WLIUHifYbM75M59Rj9YSFiVtQIsiezB9Xl0qmh6eSt1UghPIDl7Iyj7
         m9MQ==
X-Gm-Message-State: APjAAAVNYcvEJu8pIGfwduxWbRzHk6LR6eK/N0yd8mgMuqVM9WFx9Zwy
        PeBk8D3Gvex7xvhFGsuWDl6HLYzRAY7XNXk+mnZ1M5gWdPOgDfybWHt/h7OeevzdpqfjLf2EtRM
        fYB/MFYqI7tfm5ngq
X-Received: by 2002:a05:600c:249:: with SMTP id 9mr3850250wmj.2.1574854719517;
        Wed, 27 Nov 2019 03:38:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqwxKFhYNt/5OmFRFNm0SplAax2A8tbao8cCbRdGJOTR3SFH21/IDFCvk/lfdGlETDTJsaX8dg==
X-Received: by 2002:a05:600c:249:: with SMTP id 9mr3850228wmj.2.1574854719334;
        Wed, 27 Nov 2019 03:38:39 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id w11sm20128184wra.83.2019.11.27.03.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 03:38:38 -0800 (PST)
Date:   Wed, 27 Nov 2019 06:38:35 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     jcfaracco@gmail.com, netdev@vger.kernel.org, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, dnmendes76@gmail.com
Subject: Re: [net-next V3 0/2] drivers: net: virtio_net: implement
Message-ID: <20191127063624-mutt-send-email-mst@kernel.org>
References: <20191126200628.22251-1-jcfaracco@gmail.com>
 <20191126.140630.1195989367614358026.davem@davemloft.net>
MIME-Version: 1.0
In-Reply-To: <20191126.140630.1195989367614358026.davem@davemloft.net>
X-MC-Unique: lNVH7iMZM0GUld5kG3RFyg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 02:06:30PM -0800, David Miller wrote:
>=20
> net-next is closed

Could you merge this early when net-next reopens though?
This way I don't need to keep adding drivers to update.

Thanks,

--=20
MST

