Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED75145AA31
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239110AbhKWRoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:44:32 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37625 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233491AbhKWRoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 12:44:32 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3E3E65C0116;
        Tue, 23 Nov 2021 12:41:23 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 23 Nov 2021 12:41:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Kd8bh8XhU2j5IwD5s
        6xSdy+jgqZx9Ul1rR/qG+OtS7Y=; b=P9MkqGy9cqezNylUti0kvNdwZwUryBDi4
        fwicKugDl1yii7u71vpamZLYLQmK0kqIQWxRFy5JjsV6TVZ//nvIUKBI7nq0VtFj
        3X8Y69uVr/1pYjMVH09viA8oA8tFQXCSjqs/atT9Itm+/8sakeTQMCw5d3YlxsyD
        1guF0kZ18ilUhKdFeIeRuG7AE6SeXLqniZvJOxPvVdZYOKcu+llBqMmcVkIJZt4E
        +qsafsl53myHVS7aftrY0Powci+tJgN+S6Bg2S+2gmQRSMQ8BA9AvNFB3oT6RLYr
        +GvyISCYZom2B8wfaV0EciNOfX1F1esm3SHa9MP4k/bNn2TTNoHGw==
X-ME-Sender: <xms:wiedYVv4pn_7_lHmqR0HHehwjp7xmEERSyhJfto1X5KGn2lGPjaqQw>
    <xme:wiedYeecE4MlyX5jZHFDkNlruOavxsLxwKDF4PQ84uOUotzKAsEiivVYeZWa9aKUl
    zEEgO7iwbHCUxY>
X-ME-Received: <xmr:wiedYYywpVxZbp8ZJkY9Opm67lvD2gdoTI1UUNR1b1-c4rrCwztjcv-fs8esanslmdkIEAZ-pZdI145Utha7ie7A5GFCk4s8qfRwVq2EGY6iMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeeigddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:wiedYcNfHb3eZ2N_WbHofaiyMUbTxmmukx1E81FCyjv16GnLgzk51g>
    <xmx:wiedYV-8kofwoHntZyAdUl13q2Rup94ROBFhf414Ly6YtH9fLYF_3Q>
    <xmx:wiedYcUqMhmkEW6P6zECDP2CejePNa5niBttzy_bv0AnxoV6nU2sVw>
    <xmx:wyedYRb6ynG0UTv0O11bU1zrfEUkWKUbnpSMWxEdj5omaFOjJk2ZQQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Nov 2021 12:41:20 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 0/8] ethtool: Add support for CMIS diagnostic information
Date:   Tue, 23 Nov 2021 19:40:54 +0200
Message-Id: <20211123174102.3242294-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patchset extends ethtool(8) to retrieve, parse and print CMIS
diagnostic information. This information includes module-level monitors
(e.g., temperature, voltage), channel-level monitors (e.g., Tx optical
power) and related thresholds and flags.

ethtool(8) already supports SFF-8636 (e.g., QSFP) and SFF-8472 (e.g.,
SFP) diagnostic information, but until recently CMIS diagnostic
information was unavailable to ethtool(8) as it resides in optional and
banked pages.

Testing
=======

Build tested each patch with the following configuration options:

netlink | pretty-dump
--------|------------
v       | v
x       | x
v       | x
x       | v

Except fields that were added, no difference in output before and after
the patchset. Tested with both PC and AOC QSFP-DD modules.

No reports from AddressSanitizer / valgrind.

Patchset overview
=================

Patches #1-#2 are small preparations.

Patches #3-#4 retrieve (over netlink) and initialize the optional and
banked pages in the CMIS memory map. These pages contain the previously
mentioned diagnostic information.

Patch #5 parses and prints the CMIS diagnostic information in a similar
fashion to the way it is done for SFF-8636.

Patches #6-#7 print a few additional fields from the CMIS EEPROM dump.
The examples contain an ethtool command that is supported by the kernel,
but not yet by ethtool(8). It will be sent as a follow-up patchset.

Patch #8 prints the equivalent module-level fields for SFF-8636.

Ido Schimmel (8):
  sff-8636: Use an SFF-8636 specific define for maximum number of
    channels
  sff-common: Move OFFSET_TO_U16_PTR() to common header file
  cmis: Initialize Page 02h in memory map
  cmis: Initialize Banked Page 11h in memory map
  cmis: Parse and print diagnostic information
  cmis: Print Module State and Fault Cause
  cmis: Print Module-Level Controls
  sff-8636: Print Power set and Power override bits

 cmis.c       | 611 ++++++++++++++++++++++++++++++++++++++++++++++++---
 cmis.h       | 107 +++++++++
 qsfp.c       |  16 +-
 qsfp.h       |   2 +-
 sff-common.h |   6 +-
 5 files changed, 702 insertions(+), 40 deletions(-)

-- 
2.31.1

