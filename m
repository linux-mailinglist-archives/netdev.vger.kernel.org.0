Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFA142A597
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236601AbhJLN1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:27:54 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46913 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233296AbhJLN1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:27:52 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 60B9C5C01A8;
        Tue, 12 Oct 2021 09:25:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 12 Oct 2021 09:25:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=vbbra7uJyfw5gdFa8
        XXxhbxa+49epWQxU0iD2HtFREk=; b=CkveQvlPurneq1ErEd5/1SExY7DT+Mno+
        Z7/Jf6GCmGid5RaajTeBlo33+6xSMwlbj6Fc+N9cvBCUiFmrA7ph4r8mB2YwOTvO
        NyTnJNoHL/5rQ7+OaHsBP+HWEBuLQ/QP8fBG8RI49QFWJUAvLFUbN+YlWv2tmU6y
        BQmeT4XyOjZZp8QTBEcWF9njB1AOcGRKdkPiD9KnrvGxTyclaLgGkv5OjQbXqwgb
        DTTbnINL09BWn0bBFmbBvuPpqH4XRgToiANa6wh01J70A14xYp8hRXMw2mEU7RvC
        uB1eB91+In3vVZHAHqo87+En8h7GiQTdI/60hdYd5T8C9DEt8R14w==
X-ME-Sender: <xms:3YxlYaUqNXP9nxulRNLbZwCbyDRdDaQ0K3RLz8ytvDL0tSyAAADw2w>
    <xme:3YxlYWmCBYBBJjyTBg_SgOhsc7H-QN3w_poGlwEIppBQvjOQ-q_9naje2_eEnrr3K
    Euri_4FdyUDPTU>
X-ME-Received: <xmr:3YxlYeY0r7NG8Y-9NrouEHUpYkoUyG1n6IiT6x0BlmNxsx-4gnkxwNv3Ev8ji1Q5TUZXjnhMNm0bmh7y4iMI4Q3c3weGdhTK7TD5afRv9olXFA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:3YxlYRWWC2gfIonaxbVXUVLeHXYei4SY8ttBulN1YWXe0S5XGXc7KA>
    <xmx:3YxlYUmJZYNp1sJcj8TdTaEl60J98MADnnFKu2tz6grtgjpZIO4bWg>
    <xmx:3YxlYWemxYlrtGSmPD_HDxDptCjb2BC6WL578PGzpFrbpIa2Xwcysg>
    <xmx:3oxlYVBv1nkcwv0qxbC_nkGAUOICrv5ln1MY3w0vILsTYpxT0BtocQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Oct 2021 09:25:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 00/14] ethtool: Use memory maps for EEPROM parsing
Date:   Tue, 12 Oct 2021 16:25:11 +0300
Message-Id: <20211012132525.457323-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patchset prepares ethtool(8) for retrieval and parsing of optional
and banked module EEPROM pages, such as the ones present in CMIS. This
is done by better integration of the recent 'MODULE_EEPROM_GET' netlink
interface into ethtool(8).

Background
==========

ethtool(8) contains parsers for various module EEPROM memory maps such
as SFF-8079, SFF-8636 and CMIS. Using the legacy IOCTL interface,
ethtool(8) can ask the kernel to provide a buffer with the EEPROM
contents. The buffer is then passed to the parsers that parse and print
the EEPROM contents.

The major disadvantage of this method is that in addition to ethtool(8),
the kernel also needs to be familiar with the layout of the various
memory maps, as it should not report to user space optional pages that
do not exist.

In addition, with the emergence of more complex layouts (e.g., CMIS)
that include both optional and banked pages, the layout of the linear
buffer provided by the kernel is unclear.

For these reasons, kernel 5.13 was extended with the 'MODULE_EEPROM_GET'
netlink message that allows user space to request specific EEPROM pages.

Motivation
==========

Unfortunately, the current integration of 'MODULE_EEPROM_GET' into
ethtool(8) is not ideal. In the IOCTL path, a single large buffer is
passed to the parsers, whereas in the netlink path, individual pages are
passed. This is problematic for several reasons.

First, this approach is not very scalable as standards such as CMIS
support a lot of optional and banked pages. Passing them as separate
arguments is not going to work.

Second, the knowledge of which optional and banked pages are available
should be encapsulated in the individual parsers, not in the common
netlink code (i.e., netlink/module-eeprom.c). Currently, the common code
is blindly requesting from the kernel optional pages that might not
exist.

Third, the difference in the way information is passed to the parsers
propagates all the way to the individual parsing functions. For example,
cmis_show_link_len() vs. cmis_show_link_len_from_page().

Implementation
==============

In order to solve above mentioned problems and make it easier to
integrate retrieval and parsing of optional and banked pages, this
patchset reworks the EEPROM parsing code to use memory maps.

For each parser, a structure describing the layout of the memory map is
initialized with pointers to individual pages.

In the IOCTL path, this structure contains pointers to sections of the
linear buffer that was retrieved from the kernel.

In the netlink path, this structure contains pointers to individual
pages requested from the kernel. Care is taken to ensure that pages that
do not exist are not requested from the kernel.

After the structure is initialized, it is passed to the parsing code
that parses and prints the information.

This approach can be easily extended to support more optional and banked
pages and allows us to keep the parsing code common to both the IOCTL
and netlink paths. The only difference lies in how the memory map is
initialized when the parser is invoked.

Testing
=======

Build tested each patch with the following configuration options:

netlink | pretty-dump
--------|------------
v       | v
x       | x
v       | x
x       | v

No differences in output before and after the patchset (*). Tested with
QSFP (PC/AOC), QSFP-DD (PC/AOC), SFP (PC) and both IOCTL and netlink.

No reports from AddressSanitizer / valgrind.

(*) The only difference is in a few registers in CMIS that were not
parsed correctly to begin with.

Patchset overview
=================

Patches #1-#4 move CMIS to use a memory map and consolidate the code
paths between the IOCTL and netlink paths.

Patches #5-#8 do the same for SFF-8636.

Patch #9 does the same for SFF-8079.

Patch #10 exports a function to allow parsers to request a specific
EEPROM page.

Patches #11-#13 change parsers to request only specific and valid EEPROM
pages instead of getting potentially invalid pages from the common
netlink code (i.e., netlink/module-eeprom.c).

Patch #14 converts the common netlink code to simply call into
individual parsers based on their SFF-8024 Identifier Value. The command
context is passed to these parsers instead of potentially invalid pages.

Ido Schimmel (14):
  cmis: Rename CMIS parsing functions
  cmis: Initialize CMIS memory map
  cmis: Use memory map during parsing
  cmis: Consolidate code between IOCTL and netlink paths
  sff-8636: Rename SFF-8636 parsing functions
  sff-8636: Initialize SFF-8636 memory map
  sff-8636: Use memory map during parsing
  sff-8636: Consolidate code between IOCTL and netlink paths
  sff-8079: Split SFF-8079 parsing function
  netlink: eeprom: Export a function to request an EEPROM page
  cmis: Request specific pages for parsing in netlink path
  sff-8636: Request specific pages for parsing in netlink path
  sff-8079: Request specific pages for parsing in netlink path
  netlink: eeprom: Defer page requests to individual parsers

 cmis.c                  | 268 ++++++++++++++--------
 cmis.h                  |   8 +-
 ethtool.c               |   8 +-
 internal.h              |   8 +-
 netlink/extapi.h        |  11 +
 netlink/module-eeprom.c | 318 ++++++++------------------
 qsfp.c                  | 484 +++++++++++++++++++++++++---------------
 sfpid.c                 |  28 ++-
 8 files changed, 635 insertions(+), 498 deletions(-)

-- 
2.31.1

