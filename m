Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD394C60B7
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 02:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbiB1B7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 20:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiB1B7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 20:59:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06B13DA68
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 17:58:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55E6060500
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 01:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365B1C340E9;
        Mon, 28 Feb 2022 01:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646013522;
        bh=bv7NQkgKo8v7O9A1WKFawd46iEc928FJbFGKDhv1qe8=;
        h=From:To:Cc:Subject:Date:From;
        b=rK8yBes1qGASO4J8bw/JtWalr87gJpfoHApIzpqTLy2eR2Y5xhpRCYYZqzoxiwzjn
         v3KtWZ01pv1XXN1ZX5QWlIfkpVfys+ecxNCOhPqY1OJar7mSn1aphIHQhL0q7v1F8O
         +mY/IbCjCFz9GpaOE8KOH7AQIjS16t8wi0gOm56002i90QZztBon9qpPwouNWBQy2X
         QehvMZVRIQXtUzthAvy5oIxZfbQvC93P6AE5vROsFG8+aLe60kxpkW/SCPHrPqzOlw
         upSCAwL6Miiy5l8kYRiyzxdfocBPShbVas+7OElj3KNc9qSduPl5FENHAIUdV7jUyz
         JVHLoBOlvznlA==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2-next 0/3] bpf: Work around libbpf deprecations
Date:   Sun, 27 Feb 2022 18:58:37 -0700
Message-Id: <20220228015840.1413-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

libbpf is deprecating APIs, so iproute2 needs to adapt. This will be
an on-going effort, especially to handle legacy maps. This is a
starter set for the low handing fruit.

David Ahern (3):
  bpf_glue: Remove use of bpf_load_program from libbpf
  bpf: Export bpf syscall wrapper
  bpf: Remove use of bpf_create_map_xattr

 include/bpf_util.h |  2 ++
 lib/bpf_glue.c     | 15 ++++++++-------
 lib/bpf_legacy.c   | 19 +++++++------------
 lib/bpf_libbpf.c   | 24 ++++++++++++------------
 4 files changed, 29 insertions(+), 31 deletions(-)

-- 
2.24.3 (Apple Git-128)

