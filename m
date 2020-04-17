Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB901AD769
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 09:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbgDQH2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 03:28:49 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46086 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728846AbgDQH2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 03:28:49 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jPLQa-00033h-Aj; Fri, 17 Apr 2020 09:28:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Subject: [PATCH net] mptcp: fix 'attempt to release socket in state...' splats
Date:   Fri, 17 Apr 2020 09:28:21 +0200
Message-Id: <20200417072823.25864-1-fw@strlen.de>
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two patches fix error handling corner-cases where
inet_sock_destruct gets called for a mptcp_sk that is not in TCP_CLOSE
state.  This results in unwanted error printks from the network stack.

 protocol.c |    8 ++++++--
 subflow.c  |   33 +++++++++++++++++++++++++++++++--
 2 files changed, 37 insertions(+), 4 deletions(-)


