Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF521EBC90
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 15:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgFBNGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 09:06:05 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37352 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726853AbgFBNGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 09:06:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591103160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=vdmj+Tg8SGx2NrYVAizct++/zxOMWuxvcR8U68lSB2Q=;
        b=eu0O3jUmLKHk3JeifQFqOALalNmL+ETGiPqdwMKGLZsZJSaK9jaIUg53Oqnbb+prKQ4ZWO
        C1VJyY0HYRM3h1pt0RTVPKlNW0gGg4kOzkqJo4HXYVSsOns8GigxqRU0dEjpkqNXTZQRE5
        z7MK43887Fa9EwDcpyryr562UHHL86I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-wGAh0UCJP525IAx-YsEeQg-1; Tue, 02 Jun 2020 09:05:58 -0400
X-MC-Unique: wGAh0UCJP525IAx-YsEeQg-1
Received: by mail-wm1-f70.google.com with SMTP id b63so889257wme.1
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 06:05:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=vdmj+Tg8SGx2NrYVAizct++/zxOMWuxvcR8U68lSB2Q=;
        b=XxZR4GhDwdVzM3czjtxqC5E8fhaevGPzezj18HVlBdMl+5jYtV+VKiuLAeu/kPnma5
         5txoM/vzO8I9dA3yuqvEoxIROJHye+d8pHw7D7Pl1IfT6SzYlY3l/+BZUeVcb/YzIkb0
         2kz+P13+zOuV2W4uZCzXnEuTkTKOVMl0NExbGKCdiOhgKQ8mTxbI9JuH3qBK745h1aqX
         Z9zxaMNrrGuClQz8NUA/lz26yepSo5AsZXZQK/b3TTT7+rup1AegUXt8lsQL1O9CySNn
         qyy+bg8DrVq0Yt8y7gSwoQ5QqI7k7NvG0NF0TOXuPF3Aw4UW3aZIYTU+RprLNfKmLTTo
         Lm+g==
X-Gm-Message-State: AOAM532aosLtsBHcZ4gDiJ8oMwLqUAEWyC7yx3moPO0sZHPha/4VLSj5
        eRY4QKeVrJOH6cD60i4YIVpcYUuY2IaBAlx+XH9gz1HS021hmFzIqh33gAQI0uhgJyFPkUL+y5r
        VANSy3y5KoHsMvujj
X-Received: by 2002:a1c:e355:: with SMTP id a82mr3952752wmh.1.1591103156752;
        Tue, 02 Jun 2020 06:05:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxhvL+9CoWDlbet28l8cBoDZ1y4Jq12uY4hkhtEZgSR8vXHFkGEgf8rds3ZCLy2cNng3Lahg==
X-Received: by 2002:a1c:e355:: with SMTP id a82mr3952727wmh.1.1591103156470;
        Tue, 02 Jun 2020 06:05:56 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id 5sm3408485wmz.16.2020.06.02.06.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 06:05:55 -0700 (PDT)
Date:   Tue, 2 Jun 2020 09:05:54 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH RFC 00/13] vhost: format independence
Message-ID: <20200602130543.578420-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We let the specifics of the ring format seep through to vhost API
callers - mostly because there was only one format so it was
hard to imagine what an independent API would look like.
Now that there's an alternative in form of the packed ring,
it's easier to see the issues, and fixing them is perhaps
the cleanest way to add support for more formats.

This patchset does this by indtroducing two new structures: vhost_buf to
represent a buffer and vhost_desc to represent a descriptor.
Descriptors aren't normally of interest to devices but do occationally
get exposed e.g. for logging.

Perhaps surprisingly, the higher level API actually makes things a bit
easier for callers, as well as allows more freedom for the vhost core.
The end result is basically unchanged performance (based on preliminary
testing) even though we are forced to go through a format conversion.

The conversion also exposed (more) bugs in vhost scsi - which isn't
really surprising, that driver needs a lot more love than it's getting.

Very lightly tested. Would appreciate feedback and testing.

Michael S. Tsirkin (13):
  vhost: option to fetch descriptors through an independent struct
  vhost: use batched version by default
  vhost: batching fetches
  vhost: cleanup fetch_buf return code handling
  vhost/net: pass net specific struct pointer
  vhost: reorder functions
  vhost: format-independent API for used buffers
  vhost/net: convert to new API: heads->bufs
  vhost/net: avoid iov length math
  vhost/test: convert to the buf API
  vhost/scsi: switch to buf APIs
  vhost/vsock: switch to the buf API
  vhost: drop head based APIs

 drivers/vhost/net.c   | 173 +++++++++----------
 drivers/vhost/scsi.c  |  73 ++++----
 drivers/vhost/test.c  |  22 +--
 drivers/vhost/vhost.c | 375 +++++++++++++++++++++++++++---------------
 drivers/vhost/vhost.h |  46 ++++--
 drivers/vhost/vsock.c |  30 ++--
 6 files changed, 436 insertions(+), 283 deletions(-)

-- 
MST

