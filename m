Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 085F2107F88
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 17:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfKWQ4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 11:56:02 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46795 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726736AbfKWQ4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 11:56:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574528160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2zzmCXVL6/qiRxw5VRJxtFFVEelD3xq1/ujpmzsTxFU=;
        b=bwEVP9LAvhMO7ZNnBjKdLXMLDPmTZXLZNMFAJl4IKgFZt13tdMXGm0ZTIE8UJkwrVu/6tC
        P26EejJ29Eo5UWJeIG9uXc70Zfa6547dWlvXRdJ9unOkcJiXOf+qyVRCogcNgqHfCvIy1r
        HZ4nOC06NNEYvnV4GhYfpjNhfvvkj3M=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-4ay8i4x9MOmKPY2m9jVf6A-1; Sat, 23 Nov 2019 11:55:59 -0500
Received: by mail-qt1-f200.google.com with SMTP id 2so7025717qtg.8
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 08:55:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=oUPi4IjzCEcsGqjHvxV40TwATuFQ6qhdtMszb+yQ4YA=;
        b=g+dC4ZoASpChC6+mV5IB4I0OahLxAffSwJDg+EErAhICT+KgMsFoMO++J7kqhPLu11
         BDyAIX5GITEDcXpBAe7sjKgDFdrSPb/bc4c/3UXQmlbAGwUQrWNunQFeb4vqClQPF0f0
         Po2cjCyLlJT061rpcY3y2dCeO2RmYqId0VffYBHm/M+08fuVkIXVwXi0ynLl+0anxpAH
         /LKpFlFIaddo+4A+9Qw2h6A0R0dwnpYRV/XigWB1b/9wbOPWTCjUXN1zPc3xa07FfzFl
         BDmWGavAg2cPht6HQd+M/nxAatlK4GSWq/xRZdTRnlvZTr1PD+nDtkUU7nw4EeDyjj8C
         dK8w==
X-Gm-Message-State: APjAAAUHRqUr3LWGFn5gGkD2A0S86mHxwvq1+Cz6+3Gy3M2vDee86mpl
        w0ZPZpY5g1z25DQjj3Rns43Qa/S4G7PO317LdvWdDwQLS+TUhZZZ7rGA1xW+GafWrZoBTHvUzhL
        zG/65GJLL6EfkTXYU
X-Received: by 2002:ac8:109:: with SMTP id e9mr10744669qtg.233.1574528158668;
        Sat, 23 Nov 2019 08:55:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqx5oU6z7kIgkAY+TdwrAkagYjcdcvZ06XXDl+M6D2/wPofNwFAEDJeY+TKLUO56xn44s6qvMg==
X-Received: by 2002:ac8:109:: with SMTP id e9mr10744651qtg.233.1574528158492;
        Sat, 23 Nov 2019 08:55:58 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id a3sm618985qkd.67.2019.11.23.08.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 08:55:57 -0800 (PST)
Date:   Sat, 23 Nov 2019 11:55:52 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, khazhy@google.com, lvivier@redhat.com,
        mimu@linux.ibm.com, pasic@linux.ibm.com, wei.w.wang@intel.com
Subject: [PULL] virtio: last minute bugfixes
Message-ID: <20191123115552-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
X-Mutt-Fcc: =sent
X-MC-Unique: 4ay8i4x9MOmKPY2m9jVf6A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit af42d3466bdc8f39806b26f593604fdc54140bcb=
:

  Linux 5.4-rc8 (2019-11-17 14:47:30 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_li=
nus

for you to fetch changes up to c9a6820fc0da2603be3054ee7590eb9f350508a7:

  virtio_balloon: fix shrinker count (2019-11-20 02:15:57 -0500)

----------------------------------------------------------------
virtio: last minute bugfixes

Minor bugfixes all over the place.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Halil Pasic (1):
      virtio_ring: fix return code on DMA mapping fails

Laurent Vivier (1):
      virtio_console: allocate inbufs in add_port() only if it is needed

Michael S. Tsirkin (1):
      virtio_balloon: fix shrinker scan number of pages

Wei Wang (1):
      virtio_balloon: fix shrinker count

 drivers/char/virtio_console.c   | 28 +++++++++++++---------------
 drivers/virtio/virtio_balloon.c | 20 +++++++++++++-------
 drivers/virtio/virtio_ring.c    |  4 ++--
 3 files changed, 28 insertions(+), 24 deletions(-)

