Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE29E1B0E42
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 16:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbgDTOZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 10:25:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46818 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728371AbgDTOZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 10:25:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587392746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=x5gp59HPcvgXwxTfOT0yy+v8M0H3CGZViuDMzRnFJGA=;
        b=KUrskhru4sru46CsO/Hk3NDxwoVcL27oq1XGg7ci2crMWillfeDklER954XToNoKk916hr
        5SilwdndfUzEEd5nO+Z0mvNzuhHRSf9k9kCuH4BlrleVRiC+vr5GlN5ceMQXpTKBLHf29m
        AJkQ2VDZwLoTAAvLOj8s84pJZSliBxQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-NRt4cVoeNwiY0kFyVVo31Q-1; Mon, 20 Apr 2020 10:25:44 -0400
X-MC-Unique: NRt4cVoeNwiY0kFyVVo31Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD2738713B2;
        Mon, 20 Apr 2020 14:25:34 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-142.ams2.redhat.com [10.36.114.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 818E6289BB;
        Mon, 20 Apr 2020 14:25:31 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Paasch <cpaasch@apple.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 0/3] mptcp: fix races on accept()
Date:   Mon, 20 Apr 2020 16:25:03 +0200
Message-Id: <cover.1587389294.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some fixes for accept() races which may cause incons=
istent
MPTCP socket status and oops. Please see the individual patches for the
technical details.

Florian Westphal (1):
  mptcp: handle mptcp listener destruction via rcu

Paolo Abeni (2):
  mptcp: avoid flipping mp_capable field in syn_recv_sock()
  mptcp: drop req socket remote_key* fields

 net/mptcp/protocol.c | 11 ++++++--
 net/mptcp/protocol.h |  8 +++---
 net/mptcp/subflow.c  | 66 +++++++++++++++++++++++++++-----------------
 3 files changed, 52 insertions(+), 33 deletions(-)

--=20
2.21.1

