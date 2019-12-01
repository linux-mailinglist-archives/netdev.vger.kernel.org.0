Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA7E10E2C7
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 18:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbfLARlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 12:41:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40770 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727167AbfLARlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 12:41:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575222091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=uh1Sd5tkc92EWbHsSGqyuYXJpd3hrVjZvfbXObN+a3s=;
        b=MbWCcdVNZAf8B0Yv/oITo25vs+10rAlGWUkgKthtgujLSjj5Mcu9M/WwzxT8oLkSPGfGLu
        iWBL2ap58BnWMoR3kzxeZginiHfs7+28ACVPa3+fFwwnisy+MPXxB+EfPHUVjq2RdDbgSQ
        x8pFIggYwTTJ3YvtR2hk3auRNyxufOQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-zoRgTIgXOMiCJV48tExs5g-1; Sun, 01 Dec 2019 12:41:29 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62AC2800D4C;
        Sun,  1 Dec 2019 17:41:28 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-204-56.brq.redhat.com [10.40.204.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD99E600C8;
        Sun,  1 Dec 2019 17:41:26 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH net v2 0/2] openvswitch: remove a couple of BUG_ON()
Date:   Sun,  1 Dec 2019 18:41:23 +0100
Message-Id: <cover.1575221237.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: zoRgTIgXOMiCJV48tExs5g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The openvswitch kernel datapath includes some BUG_ON() statements to check
for exceptional/unexpected failures. These patches drop a couple of them,
where we can do that without introducing other side effects.

v1 -> v2:
 - avoid memory leaks on error path

Paolo Abeni (2):
  openvswitch: drop unneeded BUG_ON() in ovs_flow_cmd_build_info()
  openvswitch: remove another BUG_ON()

 net/openvswitch/datapath.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--=20
2.21.0

