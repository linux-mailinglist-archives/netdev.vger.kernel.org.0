Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECA33251CF
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 16:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfEUOWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 10:22:53 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:57745 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728045AbfEUOWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 10:22:53 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 21 May 2019 17:22:49 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x4LEMlHr023035;
        Tue, 21 May 2019 17:22:48 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        stephen@networkplumber.org, leonro@mellanox.com, parav@mellanox.com
Subject: [PATCH iproute2-next 0/4] Enrich rdma tool for net namespace commands
Date:   Tue, 21 May 2019 09:22:40 -0500
Message-Id: <20190521142244.8452-1-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RDMA subsystem can be running in either of the modes.
(a) Sharing RDMA devices among multiple net namespaces or
(b) Exclusive mode where RDMA device is bound to single net namespace 

This patch series adds
(1) query command to query rdma subsystem sharing mode
(2) set command to change rdma subsystem sharing mode
(3) assign rdma device to a net namespace

rdma tool examples:
(a) Query current rdma subsys net namespace sharing mode 
$ rdma sys show
netns shared

(b) Change rdma subsys mode to exclusive mode
$ rdma sys set netns exclusive

$ rdma sys show
netns exclusive

(c) Assign rdma device to a specific newly created net namespace
$ ip netns add foo
$ rdma dev set mlx5_1 netns foo 


Parav Pandit (4):
  rdma: Add an option to query,set net namespace sharing sys parameter
  rdma: Add man pages for rdma system commands
  rdma: Add an option to set net namespace of rdma device
  rdma: Add man page for rdma dev set netns command

 man/man8/rdma-dev.8    |  18 +++++-
 man/man8/rdma-system.8 |  82 +++++++++++++++++++++++
 man/man8/rdma.8        |   7 +-
 rdma/Makefile          |   2 +-
 rdma/dev.c             |  37 +++++++++++
 rdma/rdma.c            |   3 +-
 rdma/rdma.h            |   1 +
 rdma/sys.c             | 143 +++++++++++++++++++++++++++++++++++++++++
 rdma/utils.c           |   1 +
 9 files changed, 289 insertions(+), 5 deletions(-)
 create mode 100644 man/man8/rdma-system.8
 create mode 100644 rdma/sys.c

-- 
2.19.2

