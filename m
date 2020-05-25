Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372821E13ED
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 20:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388119AbgEYSPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 14:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387644AbgEYSPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 14:15:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDEC3C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 11:15:24 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jdHdC-0007kn-Bc; Mon, 25 May 2020 20:15:22 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     matthieu.baerts@tessares.net, mathew.j.martineau@linux.intel.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2 net-next 0/2] mptcp: adjust tcp rcvspace on rx
Date:   Mon, 25 May 2020 20:15:06 +0200
Message-Id: <20200525181508.13492-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two patches improve mptcp throughput by making sure tcp grows
the receive buffer when we move skbs from subflow socket to the
mptcp socket.

The second patch moves mptcp receive buffer increase to the recvmsg
path, i.e. we only change its size when userspace processes/consumes
the data.  This is done by using the largest rcvbuf size of the active
subflows.

