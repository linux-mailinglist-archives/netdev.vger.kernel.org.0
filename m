Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242F3250B1F
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 23:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgHXVtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 17:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHXVtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 17:49:35 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FCCC061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 14:49:35 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id j25so4657034ejk.9
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 14:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:subject:message-id:user-agent:mime-version;
        bh=kZOPQCIA0tqctsksq6PgHBKbr7xJLGfBW5BydzeehUI=;
        b=IpIZWcbAEXZKvmAzPnFAN3OffzwftlFEGxfsZl1uMIwxuLB1LXW3dRf+PHJQmCdSkg
         MtOO6aRkt9rgkGhaWdPWPdbCLofOvNJAX2+1eZQeowE+vKYOH0WXRK4LD7OGggKYmt8E
         CTMF76dx93J8CL0qRWzrdxj5+WOYwajIJquHyvgDJseyUCF8FrrV3s5pZoQr4LrFmCNV
         aYvvaqjGolia6tRKRJtjh2Wb8nb3Zs3pqXZaGorYAC5ek0So3fCMWP+8fG/ZZX6tw8dg
         YK9jN88Pxa/lvu/U2uxLJOyDbKvbQXxeMH2n3RL1LvHa+iazL1yh6cKCc59ha5ClMEXL
         02RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:subject:message-id:user-agent
         :mime-version;
        bh=kZOPQCIA0tqctsksq6PgHBKbr7xJLGfBW5BydzeehUI=;
        b=irApKzPMsSaAQ5UK0N+DwNqkGagViCZoFM5u/bKW4mIBfbHcWhW8rURbJBYLHkUg5v
         kzh3aPfe8V+GKoWsrgKeBd4w09CUDCRVgAwlatqWNL9v/0mQJ0svSqMGiiOxgVuawm8i
         x7h/6R2Ow3Bm+JmTpRLOarnU/amou3T28lZE7cf3LRgpyaXtmbaOnd1QfU0a5FAIHF8A
         HM6GunJB9pLK0cZzlTy9U5WVQER1r5Eu5AUrJ3viH//DV1oOkfRto2xFYKZGYt45vlT9
         yW7Emh5eBVGQBC6vycCdWfKwH/kXV1xaQGOvJzHdvDDMMw401FVsoavbZCbta+HuZCW3
         Ak7Q==
X-Gm-Message-State: AOAM531+1XIa/nyXT4UwWqfOPcnRn5vW1UjvoA5PXjbDS8jZKQASDW78
        KMZLg7fj2D+WK6wMu2UFyzSWjbM0VD0=
X-Google-Smtp-Source: ABdhPJy8tR4j1mxRCK4kcaDea8Xirl5LoM33+4QoiJSyCkB/+zYSGeSNZFGPSj80Wty0WLPOvVWQ7w==
X-Received: by 2002:a17:907:36b:: with SMTP id rs11mr7873006ejb.544.1598305772909;
        Mon, 24 Aug 2020 14:49:32 -0700 (PDT)
Received: from [2a02:8108:8440:5da4:b6c4:bfbb:8473:b7bc] ([2a02:8108:8440:5da4:b6c4:bfbb:8473:b7bc])
        by smtp.gmail.com with ESMTPSA id v23sm8017135ejc.63.2020.08.24.14.49.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 14:49:32 -0700 (PDT)
From:   Arne Welzel <arne.welzel@gmail.com>
X-Google-Original-From: Arne Welzel <awelzel@tinkyx230.local>
Date:   Mon, 24 Aug 2020 23:49:24 +0200 (CEST)
To:     netdev@vger.kernel.org
Subject: Opening /proc/<pid>/net/dev prevents network namespace from
 expiring
Message-ID: <alpine.DEB.2.21.99999.380.2008242341130.17914@tinkyx230.local>
User-Agent: Alpine 2.21.99999 (DEB 380 2019-12-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

[reposting from kernelnewbies as suggested by Greg]

as an unprivileged user one is able to keep network namespaces from
expiring by opening /proc/<pid>/net/dev of other processes. I've previously
put this on stackexchange [1] and then bugzilla [2]. That's been a while
though, so posting here for a bit more visibility in case it's something
that's worth fixing.

The reproducer is roughly as follows. As root:

# echo "100" > /proc/sys/user/max_net_namespaces
# while true ; do
#     (unshare -n bash -c 'sleep 0.3 && readlink /proc/self/ns/net') || sleep 0.5
# done

As unprivileged user in a second terminal, run below Python script [3]:
# python3 pin_net_namespaces.py

After about one minute the first terminal will show the following until the
Python process keeping the network namespaces alive is terminated.
...
unshare: unshare failed: No space left on device
unshare: unshare failed: No space left on device

Without the change to max_net_namespaces reproducing just takes very long,
but then also kernel memory grows fairly large.

Does that seem like problematic behavior? I had attached a patch and tests
to [2], but I fall into the kernel newbie category, so not sure how useful.

Thanks,
   Arne


[1] https://unix.stackexchange.com/questions/576718/opening-proc-pid-net-dev-prevents-network-namespace-from-expiring-is-this-ex/
[2] https://bugzilla.kernel.org/show_bug.cgi?id=207351

[3] $ cat pin_net_namespaces.py
#!/usr/bin/env python3
import glob
import os
import time

net_namespaces = {}

while True:
    for net_dev in glob.glob("/proc/*/net/dev"):
        try:
            ino = os.stat(net_dev).st_ino
            if ino not in net_namespaces:
                net_namespaces[ino] = open(net_dev)
                print("Have", len(net_namespaces), "namespaces...")
        except FileNotFoundError:
            # not fast enough...
            pass

    time.sleep(0.2)
