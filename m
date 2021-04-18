Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C363634F3
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 14:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhDRMDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 08:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbhDRMDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 08:03:32 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111A4C06174A
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 05:03:04 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id m9so18347233wrx.3
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 05:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UDYh7hE8A4TJihaXN6LxEUlZvIJ0LC4l+ziiUoDL4bo=;
        b=gNaOEm8Scl40WCtXqa6dXWLuars9Wort2p9yNfS2qOoaBTO/etfOgHAkkekcosMI9R
         i1dQyR52pRb3laNGkX+pAZeYJvOr6YGPHgryDKitQv6XU2yMUe61haQtxU3Dgl/O5BJf
         AKa6SrwFfHxoYPBOHkgxV2DZeYsGd4IXZjbL/k/war7eKsW5fArGcB7b9aTxCPliWrnc
         GfbXPkzalR7XE29bLMRwnuurkrwVcf4+JzmJ+8j+R0fk3CQ0Sh58MOj64u38NEkeE8UD
         pIrEd7xE2ud92YmH09a/sBL2ZiAqRp1+L5hbhV/RotSYsmppqY8+d/gUldP4IeBywwA0
         nZYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UDYh7hE8A4TJihaXN6LxEUlZvIJ0LC4l+ziiUoDL4bo=;
        b=guQu7TUThMiT1mXx4so5w8eCfy8OHRAa6Q/DAPhS6KgG76AoQMxGt1EbC1EnMDdyy4
         kD5VBA2JYPAJDewtRc75ErWheGHyndFvGwdP2dwvQITFzKQ0CvPStVSkzimJXkzBuIdp
         +d1oiaKwlQ/oMLKIYLDx5NyOid7R937LTIPRfV9ihtUL2I0FaPH7x6l02Hcq0UMvWn/B
         cQZqctdNjk7XcAXK91exaSEaIKwCbFDC3Tqzc4Wq3URWOKv+xHvYdeowqDDNCnf3aCLD
         LVX6VFfnxMuztP+d837EDrzJiSGufhSKWVUOBLTqWrw453VS9RSNKpKUG0bYw3vQsHFh
         psqw==
X-Gm-Message-State: AOAM532Up/Yx170Oj7g7O9c++Jbmi0Kn6Wctv6prr5tD/eIU+BYnabcf
        Fz4k/OzvURIID14zc+lPt3Ltqg+9UhXuxKGX
X-Google-Smtp-Source: ABdhPJwvPV81IVcpoRRkisGT6EW/6n9JzGyVl1ddt9mFb4ql0dz8bn2+T4hbhK1tp/riYMzjF7DHlg==
X-Received: by 2002:a5d:5711:: with SMTP id a17mr8937382wrv.342.1618747382458;
        Sun, 18 Apr 2021 05:03:02 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x25sm16584763wmj.34.2021.04.18.05.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 05:03:02 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 0/6] bridge: vlan: add per-vlan options support
Date:   Sun, 18 Apr 2021 15:01:31 +0300
Message-Id: <20210418120137.2605522-1-razor@blackwall.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
This set extends the bridge vlan code to use the new vlan RTM calls
which allow to dump detailed per-port, per-vlan information and also to
manipulate the per-vlan options. It also allows to monitor any vlan
changes (add/del/option change). The rtm vlan dumps have an extensible
format which allows us to add new options and attributes easily, and
also to request the kernel to filter on different vlan information when
dumping. The new kernel dump code tries to use compressed vlan format as
much as possible (it includes netlink attributes for vlan start and
end) to reduce the number of generated messages and netlink traffic.
The iproute2 support is activated by using the "-d" flag when showing
vlan information, that will cause it to use the new rtm dump call and
get all the detailed information, if "-s" is also specified it will dump
per-vlan statistics as well. Obviously in that case the vlans cannot be
compressed. To change per-vlan options (currently only STP state is
supported) a new vlan command is added - "set". It can be used to set
options of bridge or port vlans and vlan ranges can be used, all of the
new vlan option code uses extack to show more understandable errors.
The set adds the first supported per-vlan option - STP state.
Man pages and usage information are updated accordingly.

Example:
 $ bridge -d vlan show
 port              vlan-id
 ens13             1 PVID Egress Untagged
                     state forwarding
 bridge            1 PVID Egress Untagged
                     state forwarding

 $ bridge vlan set vid 1 dev ens13 state blocking
 $ bridge -d vlan show
 port              vlan-id
 ens13             1 PVID Egress Untagged
                     state blocking
 bridge            1 PVID Egress Untagged
                     state forwarding

We plan to add many more per-vlan options in the future.

Thanks,
 Nik

Nikolay Aleksandrov (6):
  bridge: rename and export print_portstate
  bridge: add parse_stp_state helper
  bridge: vlan: add option set command and state option
  libnetlink: add bridge vlan dump request helper
  bridge: vlan: add support for the new rtm dump call
  bridge: monitor: add support for vlan monitoring

 bridge/br_common.h   |   3 +
 bridge/link.c        |  32 ++++--
 bridge/mdb.c         |   2 +-
 bridge/monitor.c     |  19 +++-
 bridge/vlan.c        | 255 +++++++++++++++++++++++++++++++++++++++++--
 include/libnetlink.h |   7 ++
 lib/libnetlink.c     |  19 ++++
 man/man8/bridge.8    |  75 ++++++++++++-
 8 files changed, 390 insertions(+), 22 deletions(-)

-- 
2.30.2

