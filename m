Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E68B64297
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 09:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbfGJHZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 03:25:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbfGJHZD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 03:25:03 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F9952064A;
        Wed, 10 Jul 2019 07:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562743502;
        bh=IousUScaSMmuPeRDHGRJxcstSaEgxpxL2pbkVSZVkvs=;
        h=From:To:Cc:Subject:Date:From;
        b=LcN7PHTE6jmc9B8o6+rmPXcBqimbqw+EACJ0TQcjvQviPrjEkTl2jhlLzjOTgeA6x
         DvGDyfz3pVmGf7fGXpoOQuQEas+B3kMx8wlcMc1pyl/qh+lZsCoKv559e1nIqIlLQh
         M5qISUdh5yRWVc5/h/3VjAu2tECpneOLhbqbzBqc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-rc 0/8] Statistics counter support
Date:   Wed, 10 Jul 2019 10:24:47 +0300
Message-Id: <20190710072455.9125-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

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

Mark Zhang (8):
  rdma: Update uapi headers to add statistic counter support
  rdma: Add "stat qp show" support
  rdma: Add get per-port counter mode support
  rdma: Add rdma statistic counter per-port auto mode support
  rdma: Make get_port_from_argv() returns valid port in strict port mode
  rdma: Add stat manual mode support
  rdma: Add default counter show support
  rdma: Document counter statistic

 man/man8/rdma-dev.8                   |   1 +
 man/man8/rdma-link.8                  |   1 +
 man/man8/rdma-resource.8              |   1 +
 man/man8/rdma-statistic.8             | 167 ++++++
 man/man8/rdma.8                       |   7 +-
 rdma/Makefile                         |   2 +-
 rdma/include/uapi/rdma/rdma_netlink.h |  82 ++-
 rdma/rdma.c                           |   3 +-
 rdma/rdma.h                           |   1 +
 rdma/stat.c                           | 759 ++++++++++++++++++++++++++
 rdma/utils.c                          |  17 +-
 11 files changed, 1032 insertions(+), 9 deletions(-)
 create mode 100644 man/man8/rdma-statistic.8
 create mode 100644 rdma/stat.c

--
2.20.1

