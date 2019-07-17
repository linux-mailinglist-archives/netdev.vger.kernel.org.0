Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E12266BE48
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 16:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfGQOcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 10:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfGQOcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 10:32:03 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70A2B21743;
        Wed, 17 Jul 2019 14:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563373923;
        bh=zmVTs8VmkI57LlE1bMF5eFLUY14PRyajtQIuVBa4t9E=;
        h=From:To:Cc:Subject:Date:From;
        b=06jrIA5qQt2U4mcbwqDG1CbHkUf5WSrhN7QgIDDNOCblfM/3z4syS+ppEZ2Coc8LV
         nu3y75mgtXntUKT4G/MQxE3k3QgrmqR/YE6rTNkTVfkJ2ZGFSiRPxcMnSQ8SNRpiYu
         oja29WclJS2pAhl+4wT66wCLPsapd6TLEn2SImCk=
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-rc v1 0/7] Statistics counter support
Date:   Wed, 17 Jul 2019 17:31:49 +0300
Message-Id: <20190717143157.27205-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog v0->v1:
 * Fixed typo in manual page (Gal)
 * Rebased on top of d035cc1b "ip tunnel: warn when changing IPv6 tunnel without tunnel name"
 * Dropped update header file because it was already merged.

---------------------------------------------------------------------------------------

Hi,

This is supplementary part of accepted to rdma-next kernel series,
that kernel series provided an option to get various counters: global
and per-objects.

Currently, all counters are printed in format similar to other
device/link properties, while "-p" option will print them in table like
format.

[leonro@server ~]$ rdma stat show
link mlx5_0/1 rx_write_requests 0 rx_read_requests 0 rx_atomic_requests
0 out_of_buffer 0 duplicate_request 0 rnr_nak_retry_err 0 packet_seq_err
0 implied_nak_seq_err 0 local_ack_timeout_err 0 resp_local_length_error
0 resp_cqe_error 0 req_cqe_error 0 req_remote_invalid_request 0
req_remote_access_errors 0 resp_remote_access_errors 0
resp_cqe_flush_error 0 req_cqe_flush_error 0 rp_cnp_ignored 0
rp_cnp_handled 0 np_ecn_marked_roce_packets 0 np_cnp_sent 0

[leonro@server ~]$ rdma stat show -p
link mlx5_0/1
	rx_write_requests 0
	rx_read_requests 0
	rx_atomic_requests 0
	out_of_buffer 0
	duplicate_request 0
	rnr_nak_retry_err 0
	packet_seq_err 0
	implied_nak_seq_err 0
	local_ack_timeout_err 0
	resp_local_length_error 0
	resp_cqe_error 0
	req_cqe_error 0
	req_remote_invalid_request 0
	req_remote_access_errors 0
	resp_remote_access_errors 0
	resp_cqe_flush_error 0
	req_cqe_flush_error 0
	rp_cnp_ignored 0
	rp_cnp_handled 0
	np_ecn_marked_roce_packets 0
	np_cnp_sent 0

Thanks

Mark Zhang (7):
  rdma: Add "stat qp show" support
  rdma: Add get per-port counter mode support
  rdma: Add rdma statistic counter per-port auto mode support
  rdma: Make get_port_from_argv() returns valid port in strict port mode
  rdma: Add stat manual mode support
  rdma: Add default counter show support
  rdma: Document counter statistic

 man/man8/rdma-dev.8       |   1 +
 man/man8/rdma-link.8      |   1 +
 man/man8/rdma-resource.8  |   1 +
 man/man8/rdma-statistic.8 | 167 +++++++++
 man/man8/rdma.8           |   7 +-
 rdma/Makefile             |   2 +-
 rdma/rdma.c               |   3 +-
 rdma/rdma.h               |   1 +
 rdma/stat.c               | 759 ++++++++++++++++++++++++++++++++++++++
 rdma/utils.c              |  17 +-
 10 files changed, 954 insertions(+), 5 deletions(-)
 create mode 100644 man/man8/rdma-statistic.8
 create mode 100644 rdma/stat.c

--
2.20.1

