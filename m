Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAE77E3579
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 16:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409446AbfJXOY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 10:24:56 -0400
Received: from mga07.intel.com ([134.134.136.100]:38072 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409438AbfJXOY4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 10:24:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 07:24:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,224,1569308400"; 
   d="scan'208";a="373233508"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 24 Oct 2019 07:24:53 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 0/2] xsk: XSKMAP lookup improvements
Date:   Thu, 24 Oct 2019 09:19:29 +0200
Message-Id: <20191024071931.3628-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This small set consists of two patches from Bjorn and myself which are
optimizing the XSKMAP lookups.  In first patch, Bjorn converts the array
of pointers to struct xdp_sock to the flexible array member of XSKMAP
itself. Second patch, based on Bjorn's work, implements the
map_gen_lookup() for XSKMAP.

Based on the XDP program from tools/lib/bpf/xsk.c where
bpf_map_lookup_elem() is explicitly called, this work yields the 5%
improvement for xdpsock's rxdrop scenario.

Thanks!


Björn Töpel (1):
  xsk: store struct xdp_sock as a flexible array member of the XSKMAP

Maciej Fijalkowski (1):
  xsk: implement map_gen_lookup() callback for XSKMAP

 kernel/bpf/xskmap.c | 74 +++++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 32 deletions(-)

-- 
2.20.1

