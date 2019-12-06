Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB877114ADE
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 03:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfLFCX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 21:23:29 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41014 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbfLFCX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 21:23:28 -0500
Received: by mail-pg1-f195.google.com with SMTP id x8so2497847pgk.8
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 18:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=wY17/pcKHb0BDe6YGhh2KXvf1injn7RzqVNMJfXcpiY=;
        b=O8a8D+8obYH25hp9Mn8J75T8B2U3Hv4YNAIFEqoeLOTkHPNBws5/rrE7v3oKhrxugF
         TMVPzLP50j2o2oc7LohhMA6XKJPJulU1V07SClfrP/jL3/L/0sbuhcAfYFmvtgb8yWCk
         Z4T5DIJtqVqEcSIhTPoR61r3U1rVxSm9h5YuB4We2KzFpYJZW7lOL7R1tgX6LHAFKnSv
         I0JHqMfFzg+FxHXBsT5X3uBYNgpdJV1zb+tMYxV5G9SfpmBCyM/k+mQGqRpShkIDyyDo
         HyxSEH4AtJTIzIDr8zLldVGi8JF8cS/wqaispOdFXQeTh1bq2NUUIh1zWlbvzwakkkWA
         nsCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=wY17/pcKHb0BDe6YGhh2KXvf1injn7RzqVNMJfXcpiY=;
        b=PUO9IyBkbOau99kOdmj5G+y3Pt6B57BF/7uFpjymsjUpb9ZBEqbWOFtVg07vHmxzhL
         3nRdtb6BQViY1e9VHvGPz4OU6nyyTG+HD7ve6b+NdFN5x2/1WGR1OHB/PeqgqiI49pUl
         ekNZgtSWro8qHdiGk3j+v8+HCdwvHY/w9vluL8TBVWo30DYBZK4shttw2YAR69s5ByG2
         whoIPYeU3aWPptHcHKsqase0umAeVOBZh68birY+HsOnBpgmHPK6jKdIAtZkgiNkZTfU
         OmxzA1KdZaKZb4IgC2Efp/0aWP9la8OAxqunzUgbThO3WpsgG8ceRpy28EQLwHFTELHy
         9QjA==
X-Gm-Message-State: APjAAAXoTUjcQlf1dYxiXfLT3JLPKbqq7DcUFPumNdug5gylI5sZvetw
        6O7OT/FMKV2a5CIP4AQ9SjA59paqaEYamA==
X-Google-Smtp-Source: APXvYqwqPU6X/AEaCBNbyAMPZp9/DogGXDrIH3CbbnovjFOzzm0K8NN3LMyPTzykUNmYVJc1YzNwIA==
X-Received: by 2002:a63:fe0a:: with SMTP id p10mr905866pgh.96.1575599007430;
        Thu, 05 Dec 2019 18:23:27 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id j7sm13987156pgn.0.2019.12.05.18.23.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 18:23:26 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Block/io_uring fixes and changes for 5.5-rc1
Message-ID: <01d2e4de-c834-dd52-e28d-3ff75ca5cd34@kernel.dk>
Date:   Thu, 5 Dec 2019 19:23:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

Wasn't expecting this to be so big, and if I was, I would have used
separate branches for this. Going forward I'll be doing separate
branches for the current tree, just like for the next kernel version
tree. In any case, this pull request contains:

- Series from Christoph that fixes an inherent race condition with zoned
  devices and revalidation.

- null_blk zone size fix (Damien)

- Fix for a regression in this merge window that caused busy spins by
  sending empty disk uevents (Eric)

- Fix for a regression in this merge window for bfq stats (Hou)

- Fix for io_uring creds allocation failure handling (me)

- io_uring -ERESTARTSYS send/recvmsg fix (me)

- Series that fixes the need for applications to retain state across
  async request punts for io_uring. This one is a bit larger than I
  would have hoped, but I think it's important we get this fixed for
  5.5.

- connect(2) improvement for io_uring, handling EINPROGRESS instead of
  having applications needing to poll for it (me)

- Have io_uring use a hash for poll requests instead of an rbtree. This
  turned out to work much better in practice, so I think we should make
  the switch now. For some workloads, even with a fair amount of
  cancellations, the insertion sort is just too expensive. (me)

- Various little io_uring fixes (me, Jackie, Pavel, LimingWu)

- Fix for brd unaligned IO, and a warning for the future (Ming)

- Fix for a bio integrity data leak (Justin)

- bvec_iter_advance() improvement (Pavel)

- Xen blkback page unmap fix (SeongJae)

The major items in here are all well tested, and on the liburing side we
continue to add regression and feature test cases. We're up to 50 topic
cases now, each with anywhere from 1 to more than 10 cases in each.

Please pull!


  git://git.kernel.dk/linux-block.git tags/for-linus-20191205


----------------------------------------------------------------
Christoph Hellwig (7):
      null_blk: cleanup null_gendisk_register
      block: remove the empty line at the end of blk-zoned.c
      block: simplify blkdev_nr_zones
      block: replace seq_zones_bitmap with conv_zones_bitmap
      block: allocate the zone bitmaps lazily
      block: don't handle bio based drivers in blk_revalidate_disk_zones
      block: set the zone size in blk_revalidate_disk_zones atomically

Damien Le Moal (1):
      null_blk: fix zone size paramter check

Eric Biggers (1):
      block: don't send uevent for empty disk when not invalidating

Hou Tao (1):
      bfq-iosched: Ensure bio->bi_blkg is valid before using it

Jackie Liu (2):
      io_uring: remove parameter ctx of io_submit_state_start
      io_uring: remove io_wq_current_is_worker

Jens Axboe (14):
      io_uring: use current task creds instead of allocating a new one
      io_uring: transform send/recvmsg() -ERESTARTSYS to -EINTR
      io_uring: add general async offload context
      io_uring: ensure async punted read/write requests copy iovec
      io_uring: ensure async punted sendmsg/recvmsg requests copy data
      io_uring: ensure async punted connect requests copy data
      io_uring: mark us with IORING_FEAT_SUBMIT_STABLE
      io_uring: handle connect -EINPROGRESS like -EAGAIN
      null_blk: remove unused variable warning on !CONFIG_BLK_DEV_ZONED
      io_uring: allow IO_SQE_* flags on IORING_OP_TIMEOUT
      io_uring: ensure deferred timeouts copy necessary data
      io-wq: clear node->next on list deletion
      io_uring: use hash table for poll command lookups
      Merge branch 'io_uring-5.5' into for-linus

Justin Tee (1):
      block: fix memleak of bio integrity data

LimingWu (1):
      io_uring: fix a typo in a comment

Ming Lei (2):
      brd: remove max_hw_sectors queue limit
      brd: warn on un-aligned buffer

Pavel Begunkov (3):
      block: optimise bvec_iter_advance()
      io_uring: fix error handling in io_queue_link_head
      io_uring: hook all linked requests via link_list

SeongJae Park (1):
      xen/blkback: Avoid unmapping unmapped grant pages

 block/bfq-cgroup.c                  |   3 +
 block/bio-integrity.c               |   2 +-
 block/bio.c                         |   3 +
 block/blk-zoned.c                   | 149 ++++----
 block/blk.h                         |   4 +
 block/ioctl.c                       |   2 +-
 drivers/block/brd.c                 |   5 +-
 drivers/block/null_blk_main.c       |  40 ++-
 drivers/block/xen-blkback/blkback.c |   2 +
 drivers/md/dm-table.c               |  12 +-
 drivers/md/dm-zoned-target.c        |   2 +-
 drivers/scsi/sd_zbc.c               |   2 -
 fs/block_dev.c                      |   2 +-
 fs/io-wq.c                          |   2 +-
 fs/io-wq.h                          |  11 +-
 fs/io_uring.c                       | 694 +++++++++++++++++++++++++-----------
 include/linux/blkdev.h              |  24 +-
 include/linux/bvec.h                |  22 +-
 include/linux/socket.h              |  20 +-
 include/uapi/linux/io_uring.h       |   1 +
 net/socket.c                        |  76 ++--
 21 files changed, 672 insertions(+), 406 deletions(-)

-- 
Jens Axboe

