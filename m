Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5A9D6CA5B
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 09:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389402AbfGRHww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 03:52:52 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38863 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389379AbfGRHww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 03:52:52 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so27550312wrr.5
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 00:52:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rq+59r0RojlnTnigSljktyDPpoq1gf7r9wfF77O5XwQ=;
        b=URW6ZYTBkoMUon2OhIy9tqJgUT18pPg5/oejtK50or4B4slZoFKdcH5TN6Un22yolP
         8hvuFDC022jKJRcs+lU1ir+mLG5aQcYVa0LD/DhBNtYI/ir2pY1CJ06WUBH+afgY2CYv
         gJ5qOhz/0pACzzf/xLhf0XkYGflbGn8DInMTC7BsNKJ4MYfZCwYRL+29h9WENo8obMXf
         SvxmjbXUSZuaIM9NDDubSxmWV6wMkPdEvh5Q30+FGFIDXwxtrs8ILoiLMJkMZeGQuhIc
         n9wNKZqem+clQfzro4twGPbXdspT1UIFj04jDmYQ8UGoCSIslU0cKV8CMklyJ8h25za7
         59vA==
X-Gm-Message-State: APjAAAWD57Hp9so5KKEdQ8xUFV+cpmvI10pkzrRjLa0xYr2tJ4zeo/hw
        Lg2/iUSTb0jfLs0s2LPnvRlxvw==
X-Google-Smtp-Source: APXvYqyhGa0Qg+pWCOm2tSbKxPMpCW9SMZnBKSICCaQYntmM+FchtqJbWROJ8PfSDyCUWGkgpEQWRw==
X-Received: by 2002:adf:e6c5:: with SMTP id y5mr50042800wrm.235.1563436370235;
        Thu, 18 Jul 2019 00:52:50 -0700 (PDT)
Received: from steredhat ([5.170.38.133])
        by smtp.gmail.com with ESMTPSA id 91sm54324185wrp.3.2019.07.18.00.52.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 00:52:49 -0700 (PDT)
Date:   Thu, 18 Jul 2019 09:52:41 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 5/5] vsock/virtio: change the maximum packet size
 allowed
Message-ID: <CAGxU2F5ybg1_8VhS=COMnxSKC4AcW4ZagYwNMi==d6-rNPgzsg@mail.gmail.com>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-6-sgarzare@redhat.com>
 <20190717105703-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717105703-mutt-send-email-mst@kernel.org>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 5:00 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Jul 17, 2019 at 01:30:30PM +0200, Stefano Garzarella wrote:
> > Since now we are able to split packets, we can avoid limiting
> > their sizes to VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE.
> > Instead, we can use VIRTIO_VSOCK_MAX_PKT_BUF_SIZE as the max
> > packet size.
> >
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>
>
> OK so this is kind of like GSO where we are passing
> 64K packets to the vsock and then split at the
> low level.

Exactly, something like that in the Host->Guest path, instead in the
Guest->Host we use the entire 64K packet.

Thanks,
Stefano
