Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E811A97A2
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 10:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408174AbgDOIzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 04:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404948AbgDOIzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 04:55:01 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F8FC061A0C;
        Wed, 15 Apr 2020 01:55:00 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id x2so12604393qtr.0;
        Wed, 15 Apr 2020 01:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JdLKJQfgj1eY7ftApxxfrYOrZdlAW3AQZfoeziwZuJk=;
        b=lzsuX6ZQfIZhWnERfba/dyE6J6a8r1eebi2NuHrDczxp8Mty4eZG6AmioRIqmbfvsu
         GLsrbVstY1lYHX9gy/VthnqHmT8j3507a78QqtJ1W+XQioPWmAkfwKJRGVQU8dcRWLyz
         qvZreSzcUV67R+pLit1+GLahSllQYCg5ZGlYOaP12limz7mty9r8U1/ckNuH3yA+bpIp
         POzM8ZJB88hpNSCLbOcqcBeGKQ4UX9MSY217EoXgA5ygyWFbNgFzghfy9uTqwPXRZEXA
         xw2MNh9ymLGXN9O0BEWRrXfE2SSaJw+gFjT+h+ChlKbxNkbXPmiEW+WA+ctrFntvq081
         t0yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JdLKJQfgj1eY7ftApxxfrYOrZdlAW3AQZfoeziwZuJk=;
        b=sfHR+4AbXN/EX7xmt7GYMIj/0X9LmjI233dMFyl3icJrxvNc2yBfVyKhioLJ2J7uV8
         Wa9qbJ1Xc8T360EvphFq0jzpP2u876Ot1hD9Oa9l9LEc5IfL3AwrEB6VS1iPL56MLZTK
         SsanBGYm+0bjWZkZl+QNetzqR9IF9WKl2syLfghaqFLnR23WBd+llmsZBq1XE6eqDKNy
         VVNs4accdlJRXQPNHg9zankhpBfV3ufRTX5mLMYdGYkqUnoqy0jo6jTTYexXtntytYFv
         LKyFcP4iweFZH8p698EGwekfZmRd6Ur3ZkAvHMspLdAY2sByBXyzraTt62CqFIt77Q9X
         4l4Q==
X-Gm-Message-State: AGi0Pub0tmVVvTbybzd3NFNk3wSaeA4rT7W57EJaoFO43MEL4DI0YGuu
        jckOcmoW+sdf76VAeDhiAgLu1rS5oqo=
X-Google-Smtp-Source: APiQypLbR9jN8rKjkYxaBEIQuuc30/o4vJ5w1OkdLP7Emft2eBJBPAKgrOgGMLd06ZGM9wjJDka2rQ==
X-Received: by 2002:ac8:16e4:: with SMTP id y33mr20816185qtk.4.1586940899998;
        Wed, 15 Apr 2020 01:54:59 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o22sm1882750qtm.90.2020.04.15.01.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 01:54:59 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [RFC PATCH bpf-next 0/2] xdp: add dev map multicast support
Date:   Wed, 15 Apr 2020 16:54:35 +0800
Message-Id: <20200415085437.23028-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This is a prototype for xdp multicast support, which has been discussed
before[0]. The goal is to be able to implement an OVS-like data plane in
XDP, i.e., a software switch that can forward XDP frames to multiple
ports.

To achieve this, an application needs to specify a group of interfaces
to forward a packet to. It is also common to want to exclude one or more
physical interfaces from the forwarding operation - e.g., to forward a
packet to all interfaces in the multicast group except the interface it
arrived on. While this could be done simply by adding more groups, this
quickly leads to a combinatorial explosion in the number of groups an
application has to maintain.

To avoid the combinatorial explosion, we propose to include the ability
to specify an "exclude group" as part of the forwarding operation. This
needs to be a group (instead of just a single port index), because a
physical interface can be part of a logical grouping, such as a bond
device.

Thus, the logical forwarding operation becomes a "set difference"
operation, i.e. "forward to all ports in group A that are not also in
group B". This series implements such an operation using device maps to
represent the groups. This means that the XDP program specifies two
device maps, one containing the list of netdevs to redirect to, and the
other containing the exclude list.

To be able to reuse the existing bpf_redirect_map() helper, we use a
containing map-in-map type to store the forwarding and exclude groups.
When a map-in-map type is passed to the redirect helper, it will
interpret the index as encoding the forwarding group in the upper 16
bits and the exclude group in the lower 16 bits. The enqueue logic will
unpack the two halves of the index and perform separate lookups in the
containing map. E.g., an index of 0x00010001 will look for the
forwarding group at map index 0x10000 and the exclude group at map index
0x1; the application is expected to populate the map accordingly.

For this RFC series we are primarily looking for feedback on the concept
and API: the example in patch 2 is functional, but not a lot of effort
has been made on performance optimisation.

Last but not least, thanks a lot to Jiri, Eelco, Toke and Jesper for
suggestions and help on implementation.

[0] https://xdp-project.net/#Handling-multicast

Hangbin Liu (2):
  xdp: add dev map multicast support
  sample/bpf: add xdp_redirect_map_multicast test

 include/linux/bpf.h                           |  29 ++
 include/net/xdp.h                             |   1 +
 kernel/bpf/arraymap.c                         |   2 +-
 kernel/bpf/devmap.c                           | 118 +++++++
 kernel/bpf/hashtab.c                          |   2 +-
 kernel/bpf/verifier.c                         |  15 +-
 net/core/filter.c                             |  69 +++-
 net/core/xdp.c                                |  26 ++
 samples/bpf/Makefile                          |   3 +
 samples/bpf/xdp_redirect_map_multicast.sh     | 142 ++++++++
 samples/bpf/xdp_redirect_map_multicast_kern.c | 147 +++++++++
 samples/bpf/xdp_redirect_map_multicast_user.c | 306 ++++++++++++++++++
 12 files changed, 854 insertions(+), 6 deletions(-)
 create mode 100755 samples/bpf/xdp_redirect_map_multicast.sh
 create mode 100644 samples/bpf/xdp_redirect_map_multicast_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multicast_user.c

-- 
2.19.2

