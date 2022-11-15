Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F290362923A
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 08:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbiKOHKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 02:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbiKOHJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 02:09:54 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BB92018C
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 23:09:45 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 1C8B815F1105; Mon, 14 Nov 2022 23:09:35 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        ammarfaizi2@gnuweeb.org
Subject: [RFC PATCH v3 0/4] liburing: add api for napi busy poll timeout 
Date:   Mon, 14 Nov 2022 23:09:29 -0800
Message-Id: <20221115070933.1792142-1-shr@devkernel.io>
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

This adds three new api's to set/clear the napi busy poll timeout and to =
set
the napi prefer busy poll setting. The three new functions are called:
- io_uring_napi_register_busy_poll_timeout,
- io_uring_napi_unregister_busy_poll_timeout,
- io_uring_register_napi_prefer_busy_poll.

The patch series also contains the documentation for the three new functi=
ons
and two example programs. The client program is called napi-busy-poll-cli=
ent
and the server program napi-busy-poll-server. The client measures the
roundtrip times of requests.

There is also a kernel patch "io-uring: support napi busy poll" to enable
this feature on the kernel side.

Changes:
- V3:
  - Updated liburing.map file
  - Moved example programs from the test directory to the example directo=
ry.
    The two example programs don't fit well in the test category and need=
 to
    be run from separate hosts.
  - Added the io_uring_register_napi_prefer_busy_poll API.
  - Added the call to io_uring_register_napi_prefer_busy_poll to the exam=
ple
    programs
  - Updated the documentation
- V2:
  - Updated the liburing.map file for the two new functions.
    (added a 2.4 section)
  - Added a description of the new feature to the changelog file
  - Fixed the indentation of the longopts structure
  - Used defined exit constants
  - Fixed encodeUserData to support 32 bit builds


Signed-off-by: Stefan Roesch <shr@devkernel.io>

Stefan Roesch (4):
  liburing: add api to set napi busy poll settings
  liburing: add documentation for new napi busy polling
  liburing: add test programs for napi busy poll
  liburing: update changelog with new feature

 .gitignore                                    |   2 +
 CHANGELOG                                     |   3 +
 examples/Makefile                             |   2 +
 examples/napi-busy-poll-client.c              | 432 ++++++++++++++++++
 examples/napi-busy-poll-server.c              | 380 +++++++++++++++
 ...io_uring_register_napi_busy_poll_timeout.3 |  35 ++
 man/io_uring_register_napi_prefer_busy_poll.3 |  35 ++
 ..._uring_unregister_napi_busy_poll_timeout.3 |  26 ++
 src/include/liburing.h                        |   6 +
 src/include/liburing/io_uring.h               |   4 +
 src/liburing.map                              |   7 +
 src/register.c                                |  23 +
 12 files changed, 955 insertions(+)
 create mode 100644 examples/napi-busy-poll-client.c
 create mode 100644 examples/napi-busy-poll-server.c
 create mode 100644 man/io_uring_register_napi_busy_poll_timeout.3
 create mode 100644 man/io_uring_register_napi_prefer_busy_poll.3
 create mode 100644 man/io_uring_unregister_napi_busy_poll_timeout.3


base-commit: 8fc22e3b3348c0a6384ec926e0b19b6707622e58
--=20
2.30.2

