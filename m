Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C83A22AD27
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgGWLDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:03:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20904 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726867AbgGWLDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:03:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595502182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rN7mBZqwvGKQlHN3zcLFKxzADlvKqBmKSAh4b3bGUkU=;
        b=cQShG9YLVK4Qsp2o7/Wc7lQSEYkjhTEWXJ60FnJR86Q6VBGeUKzcEd4W5NC3+L6BeqHBjC
        j3sGg6OOOjerbvwulZEgSeirjuwsrhWFhUXQnkxlRP9eX1TNacaPqZmZejPeRZV+z+6cH6
        fl1RVRhwW8sr836qC7tsFPIF1RcgA1w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-RQ4-Q6hVNn2928u31scp-w-1; Thu, 23 Jul 2020 07:03:00 -0400
X-MC-Unique: RQ4-Q6hVNn2928u31scp-w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E797C57;
        Thu, 23 Jul 2020 11:02:58 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-113-9.ams2.redhat.com [10.36.113.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D52088BED5;
        Thu, 23 Jul 2020 11:02:57 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, mptcp@lists.01.org
Subject: [PATCH net-next 0/8] mptcp: non backup subflows pre-reqs
Date:   Thu, 23 Jul 2020 13:02:28 +0200
Message-Id: <cover.1595431326.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains a bunch of MPTCP improvements loosely related to
concurrent subflows xmit usage, currently under development.

The first 3 patches are actually bugfixes for issues that will become apparent
as soon as we will enable the above feature.

The later patches improve the handling of incoming additional subflows,
improving significantly the performances in stress tests based on a high new
connection rate.

Paolo Abeni (8):
  subflow: always init 'rel_write_seq'
  mptcp: avoid data corruption on reinsert
  mptcp: mark as fallback even early ones
  mptcp: explicitly track the fully established status
  mptcp: cleanup subflow_finish_connect()
  subflow: explicitly check for plain tcp rsk
  subflow: use rsk_ops->send_reset()
  subflow: introduce and use mptcp_can_accept_new_subflow()

 net/mptcp/options.c  |  5 +--
 net/mptcp/protocol.c | 23 ++++++++---
 net/mptcp/protocol.h |  8 ++++
 net/mptcp/subflow.c  | 91 ++++++++++++++++++++++++++------------------
 4 files changed, 81 insertions(+), 46 deletions(-)

-- 
2.26.2

