Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51BD1F192A
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 14:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbgFHMw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 08:52:59 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41771 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728007AbgFHMw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 08:52:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591620776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=gjI/Xc/cqqYk/lSVknmdrxtI4JosdROOwhqNKTqv88I=;
        b=NN+up0NcCTUYLGSto74dqIaj288wsdjwMReMgxuG5xHIC6uKe+pm2l+F2uEzqtTaZGQPtx
        8lnBaH4juCamqVOBunK/5J1j5ZPFD3xsTFOF0kSH2fsYwn6exM3U6/OjdZxBNQNeCR+8mL
        KmeQZKvR/AF+SbMqgCMEEIv+6vXfP+s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-jgO-BiCKP6q9EYQseB7vyQ-1; Mon, 08 Jun 2020 08:52:55 -0400
X-MC-Unique: jgO-BiCKP6q9EYQseB7vyQ-1
Received: by mail-wr1-f71.google.com with SMTP id s17so7079291wrt.7
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 05:52:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=gjI/Xc/cqqYk/lSVknmdrxtI4JosdROOwhqNKTqv88I=;
        b=HusVbVp4DiDFDnqmpwzmm/sdEqz+67HCmawVqbciJxM2v7PuP4O6D66fUqPV5y3kXX
         I/tRgkrPGA8V0dFb7R0jjm/K0bzkCvwBJWZlXirec5JYQKghDvGdMilYkMJsbWL8Oi6b
         T9X7X/HI+TlDKmtjeJeIH5nQUDgwEYIn9vQ3W5YT2sYMyBu9WG7uA0631F2fNk3+uivA
         sqV/5bxmPsFwz1MsAbmDcqBvQDoBxyf9w6L736WNKKLIxyrJ6HkodDk9/bT+pofGj1ir
         XwPc7MoOwHkts4ONo9DqCsLydk0nNt20Gh/D68oMw4WiG/3QkoDxxA9RpDNDn152mB6U
         eamQ==
X-Gm-Message-State: AOAM533EeiTpgl/7UqoU3429aiGx9SrOZGuQfcta9Zyza4GP0mnXOgKZ
        lfN+WQd/TzG0m/JYFj5RkcUW3I8Q3v1xlrgQCkFiqDSAZhLDlw+d7W5EbAFUaQ2UJRub+4zDpyh
        JB1WA6pEz0KpqxP48
X-Received: by 2002:a05:6000:1ce:: with SMTP id t14mr23504278wrx.300.1591620773840;
        Mon, 08 Jun 2020 05:52:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDSI+/ZbdtAMbTo/u8TmLBd4nOMtF+iSAUbirR2p1aEeZspsKsHQ+oW3THKUaNWxC1PVL/dQ==
X-Received: by 2002:a05:6000:1ce:: with SMTP id t14mr23504259wrx.300.1591620773666;
        Mon, 08 Jun 2020 05:52:53 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id y19sm21769323wmi.6.2020.06.08.05.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 05:52:52 -0700 (PDT)
Date:   Mon, 8 Jun 2020 08:52:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v6 00/11] vhost: ring format independence
Message-ID: <20200608125238.728563-1-mst@redhat.com>
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

changes from v5:
	- addressed comments by Jason: squashed API changes, fixed up discard

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


Michael S. Tsirkin (11):
  vhost: option to fetch descriptors through an independent struct
  vhost: use batched get_vq_desc version
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
 drivers/vhost/vhost.c | 382 +++++++++++++++++++++++++++---------------
 drivers/vhost/vhost.h |  44 +++--
 drivers/vhost/vsock.c |  30 ++--
 6 files changed, 443 insertions(+), 282 deletions(-)

-- 
MST

