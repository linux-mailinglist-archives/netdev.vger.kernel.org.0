Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE001184BBD
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 16:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgCMPxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 11:53:07 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49145 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726442AbgCMPxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 11:53:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584114786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=W0jzmLYT0L/lZOS2W/w2Rz1BnhkEFEyf3IXhEdptsio=;
        b=buIZThWZvjLOKoVkV7OFPtrbsMLHVuXvbLok7CiNmKBPTh+76lsATP4c4aL2c6guY8wU30
        aK2OKevo/y6L8z2od1p1e/k2MipKvsDsH77snFbqyYrim8I/JPTXp3ccglgFnItRmhQo/K
        r03KeY/0kBWpMpVTxPpPwejLvaKmEnU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-q08f_LpMPNqOkfzpOZiCkg-1; Fri, 13 Mar 2020 11:53:04 -0400
X-MC-Unique: q08f_LpMPNqOkfzpOZiCkg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 177C4800D6C;
        Fri, 13 Mar 2020 15:53:03 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-114.ams2.redhat.com [10.36.116.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFA5260FC1;
        Fri, 13 Mar 2020 15:53:01 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 0/2] mptcp: simplify mptcp_accept()
Date:   Fri, 13 Mar 2020 16:52:40 +0100
Message-Id: <cover.1584114674.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we allocate the MPTCP master socket at accept time.

The above makes mptcp_accept() quite complex, and requires checks is seve=
ral
places for NULL MPTCP master socket.

These series simplify the MPTCP accept implementation, moving the master =
socket
allocation at syn-ack time, so that we drop unneeded checks with the foll=
ow-up
patch.

v1 -> v2:
- rebased on top of 2398e3991bda7caa6b112a6f650fbab92f732b91

Paolo Abeni (2):
  mptcp: create msk early
  mptcp: drop unneeded checks

 net/mptcp/options.c  | 14 ++------
 net/mptcp/protocol.c | 83 ++++++++++++++++++++++++--------------------
 net/mptcp/protocol.h |  4 +--
 net/mptcp/subflow.c  | 50 ++++++++++++++------------
 net/mptcp/token.c    | 31 ++---------------
 5 files changed, 79 insertions(+), 103 deletions(-)

--=20
2.21.1

