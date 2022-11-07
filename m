Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C8461FC48
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 18:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbiKGR41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 12:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbiKGRzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 12:55:10 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28AA25288
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 09:54:18 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id A68E4F6B962; Mon,  7 Nov 2022 09:54:04 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        ammarfaizi2@gnuweeb.org
Subject: [RFC PATCH v2 0/4] liburing: add api for napi busy poll timeout 
Date:   Mon,  7 Nov 2022 09:53:53 -0800
Message-Id: <20221107175357.2733763-1-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds two new api's to set and clear the napi busy poll timeout. The
two new functions are called:
- io_uring_register_busy_poll_timeout and
- io_uring_unregister_busy_poll_timeout.

The patch series also contains the documentation for the two new function=
s
and two test programs. The client program is called napi-busy-poll-client
and the server program napi-busy-poll-server. The client measures the
roundtrip times of requests.

There is also a kernel patch "io-uring: support napi busy poll" to enable
this feature on the kernel side.

Changes:
- V2:
  - Updated the liburing.map file for the two new functions.
    (added a 2.4 section)
  - Added a description of the new feature to the changelog file
  - Fixed the indentation of the longopts structure
  - Used defined exit constants
  - Fixed encodeUserData to support 32 bit builds


Signed-off-by: Stefan Roesch <shr@devkernel.io>

Stefan Roesch (4):
  liburing: add api to set napi busy poll timeout
  liburing: add documentation for new napi busy polling
  liburing: add test programs for napi busy poll
  liburing: update changelog with new feature

 CHANGELOG                       |   3 +
 man/io_uring_register_napi.3    |  35 +++
 man/io_uring_unregister_napi.3  |  26 ++
 src/include/liburing.h          |   4 +
 src/include/liburing/io_uring.h |   4 +
 src/liburing.map                |   8 +
 src/register.c                  |  15 ++
 test/Makefile                   |   2 +
 test/napi-busy-poll-client.c    | 422 ++++++++++++++++++++++++++++++++
 test/napi-busy-poll-server.c    | 372 ++++++++++++++++++++++++++++
 10 files changed, 891 insertions(+)
 create mode 100644 man/io_uring_register_napi.3
 create mode 100644 man/io_uring_unregister_napi.3
 create mode 100644 test/napi-busy-poll-client.c
 create mode 100644 test/napi-busy-poll-server.c


base-commit: 754bc068ec482c5338a07dd74b7d3892729bb847
--=20
2.30.2

