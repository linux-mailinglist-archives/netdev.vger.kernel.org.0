Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BF531A31A
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 17:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhBLQvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 11:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhBLQvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 11:51:41 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02286C061574;
        Fri, 12 Feb 2021 08:51:01 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id f14so231285ejc.8;
        Fri, 12 Feb 2021 08:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=kuyIAN6ynILC6Lb1Ej4zOAFFZL68p0m+Z5l76VYpdI4=;
        b=pQ6KJ66aU4m9vG+s3RKS3nIO1REYUCD/HIfeBWb/ray8H2l25s8Q6t8eeBvC81VOwj
         JgmxhAqZFLNd9LndP8r/4EQQfM39a5bexDTvN8dhRfzNQRtrty9Ges2pArAFSN4IlMqB
         E50vDhmSB87YjNOo9c56Ad835Zxsd2FkW/gWgIPWJQszMui8KRlOvsEPLHQGjxG2iMhZ
         8UA8Dy4rSA4jK5+Wgfyhob65xkiJWNyWnEnw+U0b5clkgFlyrLNbkG1OrTzmQebnblOk
         SEAl6Kg6u42jsJlDQyXMX+7qjJMdZTmpQOJAuqvSrXbEHrrQWG5GXJ6lYqQe+I7EnXqn
         KbSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=kuyIAN6ynILC6Lb1Ej4zOAFFZL68p0m+Z5l76VYpdI4=;
        b=tVWu3rEGvPo7/0HcCadGdijSc5/zV+iRsDnq0lnj1THiC2Hp4a2O8ivcHN7mb3qPeg
         hNW28Dg+1Z18dbGQERLqnMRzTPC+bhXQsLEium1uUYmmHr71dGCONw3v9rKz+0oRjewl
         62Myijgi4ZhoTBzg99xU7aKU41aCzc3sdKNeGGO/UThpG3DawyQhHzMjh30D3KTg0Dol
         R+Z0W9pzz7w729AYMB9YgpxFwamQQbulQJ/5AtXV48dJzKGeSkj/JkpHKnUvsKGsKCpc
         OYooB847Aezk7dFIFkwQNrgqWI93wcrMrbKeAo3JUocctuv6itcWdAggbN4B4wxGD6R3
         McVA==
X-Gm-Message-State: AOAM5304xLwkuH/2GTA+jg1P1FaOyNAQEDDZ8YYRgEoc6AWRCwmgDXiS
        nIkQvSfvaKMzLlKuYlxkgcvScza+t+Vzw/wP
X-Google-Smtp-Source: ABdhPJw+9EQuVkXn16atquT/DdvsnrytGuk42nwp9fu3inZ/k5/jDBeVUF+gk6tK8IDbBYAMCLQMaw==
X-Received: by 2002:a17:906:364b:: with SMTP id r11mr3850258ejb.447.1613148659299;
        Fri, 12 Feb 2021 08:50:59 -0800 (PST)
Received: from anparri (host-95-239-64-41.retail.telecomitalia.it. [95.239.64.41])
        by smtp.gmail.com with ESMTPSA id lo3sm580481ejb.106.2021.02.12.08.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 08:50:58 -0800 (PST)
Date:   Fri, 12 Feb 2021 17:50:50 +0100
From:   Andrea Parri <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, mikelley@microsoft.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, davem@davemloft.net, kuba@kernel.org,
        linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Regressions with VMBus/VSCs hardening changes
Message-ID: <20210212165050.GA11906@anparri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I'm reporting two regressions following certain VMBus/VSCs hardening changes
we've been discussing 'recently', unfortunately the first regression already
touched/affects mainline while the second one is in hyperv-next:

1) [mainline]

The first regression manifests with the following message (several):

  hv_vmbus: No request id available

I could reliably reproduce such message/behavior by running the command:

  fio --name=seqwrite --rw=read --direct=1 --ioengine=libaio --bs=32k --numjobs=4 --size=2G --runtime=60

(the message is triggered when files are being created).

I've bisected this regression to commit:

  453de21c2b8281 ("scsi: storvsc: Use vmbus_requestor to generate transaction IDs for VMBus hardening")

2) [hyperv-next]

The second regression manifests with various messages including:

  hv_netvsc 9c5f5000-0499-4b18-b2eb-a8d5c57c8774 eth0: Unknown nvsp packet type received 51966

  hv_netvsc 9c5f5000-0499-4b18-b2eb-a8d5c57c8774 eth0: unhandled packet type 0, tid 0

  hv_netvsc 9c5f5000-0499-4b18-b2eb-a8d5c57c8774 eth0: Incorrect transaction id

  hv_netvsc 9c5f5000-0499-4b18-b2eb-a8d5c57c8774 eth0: Invalid rndis_msg (buflen: 262, msg_len: 1728)

The connection was then typically lost/reset by the peer.

I could reproduce such behavior/messages by running the test:

  ntttcp -r -m 8,*,<receiver IP address> # receiver

  ntttcp -s -m 8,*,<receiver IP address> -ns -t 60 # sender

I bisected this regression to commit:

  a8c3209998afb5 ("Drivers: hv: vmbus: Copy packets sent by Hyper-V out of the ring buffer")

---
I am investigating but don't have fixes for these regressions now: given the
'timing' (-rc7 with the next merge window at the door...) I would propose to
revert/drop the interested changes:

1) 453de21c2b8281 is part of the so called 'vmbus_requestor' series that was
   applied during the merge window for 5.11:

  e8b7db38449ac5 ("Drivers: hv: vmbus: Add vmbus_requestor data structure for VMBus hardening")
  453de21c2b8281 ("scsi: storvsc: Use vmbus_requestor to generate transaction IDs for VMBus hardening")
  4d18fcc95f5095 ("hv_netvsc: Use vmbus_requestor to generate transaction IDs for VMBus hardening")

  I could prepare/submit patches to revert such commits (asap but likely not
  before tomorrow/late Saturday - EU time).

2) IIUC a8c3209998afb5 could be dropped (after rebase) without further modi-
   fications to hyperv-next.

Other suggestions/thoughts?

Thanks,
  Andrea
