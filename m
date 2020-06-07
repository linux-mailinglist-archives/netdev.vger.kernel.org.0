Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A961F0BD1
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 16:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgFGOLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 10:11:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41463 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726561AbgFGOL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 10:11:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591539088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=OWdfFlhdvAuK9m65CuOfAgwGAWbw+S7EDp4ZxipnEDI=;
        b=ZUPaABLrQ4R4e5QjoFaRk6F3h4N/KhHcSSozgcHqU7/7yLCb4H3b2CqtdnZ1JB89nUHRQ4
        LsPFs57Rq02RBB+4SgbRk+9LC17X7Yxwp59faZ4evD+8oeuWOdFue/rZ2ivqm1TJK9R3X1
        ROWKGSekx6Bwa4E4UEzsvIpQZ/2j0t4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-f5He8m-qMWSaZacCdQLXBg-1; Sun, 07 Jun 2020 10:11:24 -0400
X-MC-Unique: f5He8m-qMWSaZacCdQLXBg-1
Received: by mail-wm1-f70.google.com with SMTP id t145so4297905wmt.2
        for <netdev@vger.kernel.org>; Sun, 07 Jun 2020 07:11:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=OWdfFlhdvAuK9m65CuOfAgwGAWbw+S7EDp4ZxipnEDI=;
        b=C+OHWMxYeobOBO69+8tO8HO8egLP2QhLjW/QsC5uFejlD1btCdeBIWtYDn7ZOrFTuG
         f/KWosaoHxVzOHfkf1w9QSoUcT1HKRiRxLbsQ0gjVKQgxEZ0qM/u5uw6zF99keQMsgWh
         bFQsvMYhrgWoCOlIJ6X6vjel4wXakYUL2bGGdDl4+CH6sen7/livs0tq+iLZK7pnAeCH
         hnNuL5+9+YLGzga0o8BcnVnhFhf21Vr4ifXIfw+9rJq8nhrvPQypV+7LeQNS+1f4IKfv
         8K9GK3eY0o1CLZKNBPlmjMqJgMIfTQ1Gq9iZTd9+jZJpDhIyPJvSBG4h5UoGHMU9Av55
         Mk4Q==
X-Gm-Message-State: AOAM530vbEqcIsDJreE0aLC06gl9vCHDZ9/QE305Sgr/RAMbfK1QehHM
        Mj8cb81a5x8cnZ+LqciXJf/4N/8EyvyXEmq+Le3mch+SLGnQGQdOI3ZijUleqSz2c/TTsvwiici
        0Gb+p+mAKT63NoXub
X-Received: by 2002:a1c:6583:: with SMTP id z125mr12068654wmb.102.1591539083096;
        Sun, 07 Jun 2020 07:11:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxV7ZWEoPal74PMq+69HAL799WrVxakjuqYm1EYkHAsqG9CYVZ+7zhU5OuON8EQ3eWowy87cg==
X-Received: by 2002:a1c:6583:: with SMTP id z125mr12068635wmb.102.1591539082879;
        Sun, 07 Jun 2020 07:11:22 -0700 (PDT)
Received: from redhat.com (bzq-82-81-31-23.red.bezeqint.net. [82.81.31.23])
        by smtp.gmail.com with ESMTPSA id u130sm20174752wmg.32.2020.06.07.07.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 07:11:22 -0700 (PDT)
Date:   Sun, 7 Jun 2020 10:11:20 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v5 00/13] vhost: ring format independence
Message-ID: <20200607141057.704085-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This adds infrastructure required for supporting
multiple ring formats.

The idea is as follows: we convert descriptors to an
independent format first, and process that converting to
iov later.

Used ring is similar: we fetch into an independent struct first,
convert that to IOV later.

The point is that we have a tight loop that fetches
descriptors, which is good for cache utilization.
This will also allow all kind of batching tricks -
e.g. it seems possible to keep SMAP disabled while
we are fetching multiple descriptors.

For used descriptors, this allows keeping track of the buffer length
without need to rescan IOV.

This seems to perform exactly the same as the original
code based on a microbenchmark.
Lightly tested.
More testing would be very much appreciated.


changes from v4:
	- added used descriptor format independence
	- addressed comments by jason
	- fixed a crash detected by the lkp robot.

changes from v3:
        - fixed error handling in case of indirect descriptors
        - add BUG_ON to detect buffer overflow in case of bugs
                in response to comment by Jason Wang
        - minor code tweaks

Changes from v2:
	- fixed indirect descriptor batching
                reported by Jason Wang

Changes from v1:
	- typo fixes


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

 drivers/vhost/net.c   | 174 ++++++++++---------
 drivers/vhost/scsi.c  |  73 ++++----
 drivers/vhost/test.c  |  22 +--
 drivers/vhost/vhost.c | 380 +++++++++++++++++++++++++++---------------
 drivers/vhost/vhost.h |  44 +++--
 drivers/vhost/vsock.c |  30 ++--
 6 files changed, 441 insertions(+), 282 deletions(-)

-- 
MST

