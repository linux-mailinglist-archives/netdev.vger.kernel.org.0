Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1E2630BD3
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 05:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiKSENl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 23:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbiKSEMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 23:12:38 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D030B970C
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 20:12:04 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id E41741956AE2; Fri, 18 Nov 2022 20:11:51 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        ammarfaizi2@gnuweeb.org
Subject: [RFC PATCH v4 0/4] liburing: add api for napi busy poll
Date:   Fri, 18 Nov 2022 20:11:45 -0800
Message-Id: <20221119041149.152899-1-shr@devkernel.io>
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

This adds two new api's to set/clear the napi busy poll settings. The two
new functions are called:
- io_uring_register_napi
- io_uring_unregister_napi

The patch series also contains the documentation for the two new function=
s
and two example programs. The client program is called napi-busy-poll-cli=
ent
and the server program napi-busy-poll-server. The client measures the
roundtrip times of requests.

There is also a kernel patch "io-uring: support napi busy poll" to enable
this feature on the kernel side.

Changes:
- V4:
  - Modify functions to use a structure to pass the napi busy poll settin=
gs
    to the kernel.
  - Return previous values when returning from the above functions.
  - Rename the functions and remove one function (no longer needed as the
    data is passed as a structure)
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
*** BLURB HERE ***

Stefan Roesch (4):
  liburing: add api to set napi busy poll settings
  liburing: add documentation for new napi busy polling
  liburing: add example programs for napi busy poll
  liburing: update changelog with new feature

 .gitignore                       |   2 +
 CHANGELOG                        |   3 +
 examples/Makefile                |   2 +
 examples/napi-busy-poll-client.c | 441 +++++++++++++++++++++++++++++++
 examples/napi-busy-poll-server.c | 385 +++++++++++++++++++++++++++
 man/io_uring_register_napi.3     |  40 +++
 man/io_uring_unregister_napi.3   |  27 ++
 src/include/liburing.h           |   3 +
 src/include/liburing/io_uring.h  |  12 +
 src/liburing.map                 |   6 +
 src/register.c                   |  12 +
 11 files changed, 933 insertions(+)
 create mode 100644 examples/napi-busy-poll-client.c
 create mode 100644 examples/napi-busy-poll-server.c
 create mode 100644 man/io_uring_register_napi.3
 create mode 100644 man/io_uring_unregister_napi.3


base-commit: 8fc22e3b3348c0a6384ec926e0b19b6707622e58
--=20
2.30.2

