Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE03CA6048
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 06:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfICEj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 00:39:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbfICEjZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 00:39:25 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 99B8E3DE04
        for <netdev@vger.kernel.org>; Tue,  3 Sep 2019 04:39:25 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id p6so2686995qkk.6
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 21:39:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QsFw6JbKR151rBeG65E8RZKx+pqxeiIfjKh1LzJnxMs=;
        b=p7A3TByCLlotM2oOr3niyjdAVcGjp3hsdPSHRQXrqVmB0NHo6iHJlJ4HEvc3s7nzqz
         pVAITpKYZqUVYeJMIliesRidJ/HuLlZcDIiQxdpUxHGgNzyX+XK/cOF0ZCdzFwz/NaNP
         4o0nWJChYv5/kDkkB5Es5BRzVlMmsUNDr1W642ysWf2j/xdxXAo58ElkwoijcUwtayx/
         +vYe/NGSO0zdJrn0b/cuhKBaxgqB7HGZ/XKYKRE2EVkaFH0KDcV96OXNi+nGJeE1KP+Q
         83EnE7h0hrjTevEQnO6YRrVpdeqko/tLpbXd4QjOwozBxzZJziP8EAiYZ2yuHItBUEF3
         AzNA==
X-Gm-Message-State: APjAAAUdvlGfOYDUKx4JvfgnjMiGk/9zfmqchExFC7BHqoRf7nbx5rsY
        /Na9xV2WwkqPyzRAFH5bfnFMt/LjoUPMQusvtuY/emcA8GugoRtDY86eKPGuB1fP3iakpkucO/z
        FXUi9iqToFjSlYNjb
X-Received: by 2002:a37:7f41:: with SMTP id a62mr5242892qkd.21.1567485564982;
        Mon, 02 Sep 2019 21:39:24 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwsb0LztYbIXObHR39awO6zBUHMeK0bLZrIDZ9QdvCXGsCAgbVutbSJHHLuwhraV6VG7qqbwA==
X-Received: by 2002:a37:7f41:: with SMTP id a62mr5242876qkd.21.1567485564780;
        Mon, 02 Sep 2019 21:39:24 -0700 (PDT)
Received: from redhat.com (bzq-79-180-62-110.red.bezeqint.net. [79.180.62.110])
        by smtp.gmail.com with ESMTPSA id z72sm8508456qka.115.2019.09.02.21.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 21:39:24 -0700 (PDT)
Date:   Tue, 3 Sep 2019 00:39:19 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/5] vsock/virtio: limit the memory used per-socket
Message-ID: <20190903003823-mutt-send-email-mst@kernel.org>
References: <20190729165056.r32uzj6om3o6vfvp@steredhat>
 <20190729143622-mutt-send-email-mst@kernel.org>
 <20190730093539.dcksure3vrykir3g@steredhat>
 <20190730163807-mutt-send-email-mst@kernel.org>
 <20190801104754.lb3ju5xjfmnxioii@steredhat>
 <20190801091106-mutt-send-email-mst@kernel.org>
 <20190801133616.sik5drn6ecesukbb@steredhat>
 <20190901025815-mutt-send-email-mst@kernel.org>
 <20190901061707-mutt-send-email-mst@kernel.org>
 <20190902095723.6vuvp73fdunmiogo@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190902095723.6vuvp73fdunmiogo@steredhat>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 02, 2019 at 11:57:23AM +0200, Stefano Garzarella wrote:
> > 
> > Assuming we miss nothing and buffers < 4K are broken,
> > I think we need to add this to the spec, possibly with
> > a feature bit to relax the requirement that all buffers
> > are at least 4k in size.
> > 
> 
> Okay, should I send a proposal to virtio-dev@lists.oasis-open.org?

How about we also fix the bug for now?

-- 
MST
