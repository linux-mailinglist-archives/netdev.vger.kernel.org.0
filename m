Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8896746B1B0
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 05:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhLGEFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 23:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbhLGEFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 23:05:41 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A3DC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 20:02:11 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id l8so13096669qtk.6
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 20:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qteZJzRApoqxo5cN+HV8rw1QeFkqyg2gsLlXSZXFvNA=;
        b=DvDviaFPfJSM/A3gVCoJeHTI6Z6D6zmf1NK4q7dd5IB7PSaWtETWqgaK+TzxQlDOfM
         Iaf6ReruGIxjIjTgbxf+eMyORTw8mfBnMbQPxB3m4eu/ng+werbj4uGIvcU/KlQKQITl
         cYkU3GOuQfyU0lp1jyt8OPh3sG41VAys9f/4BY2Mhkt2hUKT9X8kTxS2bity+YBLSs5R
         0PZ5TM9DvobDPOhkgx3/cMgxfJs28q/Lib3SuxsL+ZE8Zj5AqJMHp/aeBbvzjISoje9b
         GHXnp6gKjgIv45y0LzPIbvOqKmhvDmnDxY1uhRCNFj54bvydISSRxYhhkgz17SrAAS7R
         DGAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qteZJzRApoqxo5cN+HV8rw1QeFkqyg2gsLlXSZXFvNA=;
        b=MrkEs3731BNy3fpOTDYUdh5fc5jyIpjbUZ30iWmvcapS8FpwDHvi5BBrQ4sMsn7chG
         yCC16KFHjT0CwIFXrNvKvawDB9yMpxgc0CanPHWe5X4imZj9fp+992y8AWRBcILiapWz
         M0TsN9iow4kcmLXXXbigXnaLzuqPvcfo2wpNL4G+lrK2dFQUz6m/6h699o54wigFj/s9
         iN1LK0mXkfjW3Xr84nWszOW2CvyXPS9stz2/ZeyHmNEZaOlavgiHrk5uJyWUU3gvBFIM
         2nElGlk87zethbkHgJDF8H24WtuspgXyB4JHuU24vnkefVNmKGLsOw52IkDWgeMGUWkd
         to0g==
X-Gm-Message-State: AOAM533on602SlQw7dnWF4rZrow+c+MDWOx19b4ciqFQJmg7eELRlsRw
        OeqGyBeN+cwN4yQ9rNw4vh6yCZVNn8CYTQ==
X-Google-Smtp-Source: ABdhPJwCybWL4+983pFxkESmYJfqZNTUNq4dLi85Pg68zMlw2HzSzLX3JYiib4cTNjUW5VGAFnVoDw==
X-Received: by 2002:a05:622a:1452:: with SMTP id v18mr45467470qtx.575.1638849730542;
        Mon, 06 Dec 2021 20:02:10 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 14sm8526393qtx.84.2021.12.06.20.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 20:02:09 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 0/5] net: add refcnt tracking for some common objects
Date:   Mon,  6 Dec 2021 23:02:03 -0500
Message-Id: <cover.1638849511.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset provides a simple lib(obj_cnt) to count the operatings on any
objects, and saves them into a gobal hashtable. Each node in this hashtable
can be identified with a calltrace and an object pointer. A calltrace could
be a function called from somewhere, like dev_hold() called by:

    inetdev_init+0xff/0x1c0
    inetdev_event+0x4b7/0x600
    raw_notifier_call_chain+0x41/0x50
    register_netdevice+0x481/0x580

and an object pointer would be the dev that this function is accessing:

    dev_hold(dev).

When this call comes to this object, a node including calltrace + object +
counter will be created if it doesn't exist, and the counter in this node
will increment if it already exists. Pretty simple.

So naturally this lib can be used to track the refcnt of any objects, all
it has to do is put obj_cnt_track() to the place where this object is
held or put. It will count how many times this call has operated this
object after checking if this object and this type(hold/put) accessing
are being tracked.

After the 1st lib patch, the other patches add the refcnt tracking for
netdev, dst, in6_dev and xfrm_state, and each has example how to use
in the changelog. The common use is:

    # sysctl -w obj_cnt.control="clear" # clear the old result

    # sysctl -w obj_cnt.type=0x1     # track type 0x1 operating
    # sysctl -w obj_cnt.name=test    # match name == test or
    # sysctl -w obj_cnt.index=1      # match index == 1
    # sysctl -w obj_cnt.nr_entries=4 # save 4 frames' calltrace

    ... (reproduce the issue)

    # sysctl -w obj_cnt.control="scan"  # print the new result

Note that after seeing Eric's another patchset for refcnt tracking I
decided to post this patchset. As in this implemenation, it has some
benefits which I think worth sharing:

  - it runs fast:
    1. it doesn't create nodes for the repeatitive calls to the same
       objects, and it saves memory and time.
    2. the depth of the calltrace to record is configurable, at most
       time small calltrace also saves memory and time, but will not
       affect the analysis.
    3. kmem_cache used also contributes to the performance.

  - easy to use:
    1. it doesn't add any members to the object structure, just place
       an API to the hold/put functions, and it keep the kernel code
       clear and won't break any ABIs.
    2. three types of matching conditions for tracking can be set up,
       int, string by sysctl and API, and pointer by API.

This patchset has helped solve quite some refcnt leaks, from netdev to
dst, in6_dev, xfrm_dst. There are also some difficult cases that we've
addressed with this pathset:

  - some leaks were only reproduciable in customer's environment by running
    for a couple of months, "probe" data was even too huge to save and
    analyse, so saving memory is crucial.

  - some are not able to reproduce if the tracking patch worked slowly,
    like not using kmem cache, so running fast is important.

  - some leak was a chain, such as a leak we see it as a dev leak, but it
    was caused by a dst or in6_dev leak, and this dst or in6_dev leak was
    caused by another object, so tracking multiple types at the same time
    is effective.

Xin Long (5):
  lib: add obj_cnt infrastructure
  net: track netdev refcnt with obj_cnt
  net: track dst refcnt with obj_cnt
  net: track in6_dev refcnt with obj_cnt
  net: track xfrm_state refcnt with obj_cnt

 include/linux/netdevice.h |  11 ++
 include/linux/obj_cnt.h   |  20 +++
 include/net/addrconf.h    |   7 +-
 include/net/dst.h         |   8 +-
 include/net/sock.h        |   3 +-
 include/net/xfrm.h        |  11 ++
 lib/Kconfig.debug         |   7 +
 lib/Makefile              |   1 +
 lib/obj_cnt.c             | 285 ++++++++++++++++++++++++++++++++++++++
 net/core/dst.c            |   2 +
 10 files changed, 352 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/obj_cnt.h
 create mode 100644 lib/obj_cnt.c

-- 
2.27.0

