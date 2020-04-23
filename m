Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631A11B5CB7
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 15:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgDWNj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 09:39:29 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25389 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728427AbgDWNj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 09:39:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587649165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tzW9lOcj3xSbts5Cp8WBxxGXHwoO5mLgm/tSC7f2Z3U=;
        b=d/XZA8OGVY6vBSI18SccvZgRdVJ6jLtk8ZLYn9C0LjjV9qEsFqSwspyqq7Xdb5sORE/NDn
        2D6nqDRtrpKI0CvehFJDK3K0hofcmBVKhsCrGh3fKgW1X0e35YYLHXWsQmwlLbVkTLKj2K
        0hChvLJs/K7509D83KEZ97nLyBvm/+8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-ID71KvEMPe-vk4rHrr6y0g-1; Thu, 23 Apr 2020 09:39:23 -0400
X-MC-Unique: ID71KvEMPe-vk4rHrr6y0g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC162872FF1;
        Thu, 23 Apr 2020 13:39:22 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-154.ams2.redhat.com [10.36.114.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE71E1002380;
        Thu, 23 Apr 2020 13:39:21 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     stephen@networkplumber.org, netdev@vger.kernel.org
Cc:     dcaratti@redhat.com
Subject: [PATCH iproute2-next 4/4] man: mptcp man page
Date:   Thu, 23 Apr 2020 15:37:10 +0200
Message-Id: <725b0afb6303f8507b63b1475a69aab7abf34d1e.1587572928.git.pabeni@redhat.com>
In-Reply-To: <cover.1587572928.git.pabeni@redhat.com>
References: <cover.1587572928.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

describe the mptcp subcommands implemented so far.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 man/man8/ip-mptcp.8 | 142 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 142 insertions(+)
 create mode 100644 man/man8/ip-mptcp.8

diff --git a/man/man8/ip-mptcp.8 b/man/man8/ip-mptcp.8
new file mode 100644
index 00000000..f6457e97
--- /dev/null
+++ b/man/man8/ip-mptcp.8
@@ -0,0 +1,142 @@
+.TH IP\-MPTCP 8 "4 Apr 2020" "iproute2" "Linux"
+.SH "NAME"
+ip-mptcp \- MPTCP path manager configuration
+.SH "SYNOPSIS"
+.sp
+.ad l
+.in +8
+.ti -8
+.B ip
+.RI "[ " OPTIONS " ]"
+.B mptcp
+.RB "{ "
+.B endpoint
+.RB " | "
+.B limits
+.RB " | "
+.B help
+.RB " }"
+.sp
+
+.ti -8
+.BR "ip mptcp endpoint add "
+.IR IFADDR
+.RB "[ " dev
+.IR IFNAME " ]"
+.RB "[ " id
+.I ID
+.RB "] [ "
+.I FLAG-LIST
+.RB "] "
+
+.ti -8
+.BR "ip mptcp endpoint del id "
+.I ID
+
+.ti -8
+.BR "ip mptcp endpoint show "
+.RB "[ " id
+.I ID
+.RB "]"
+
+.ti -8
+.BR "ip mptcp endpoint flush"
+
+.ti -8
+.IR FLAG-LIST " :=3D [ "  FLAG-LIST " ] " FLAG
+
+.ti -8
+.IR FLAG " :=3D ["
+.B signal
+.RB "|"
+.B subflow
+.RB "|"
+.B backup
+.RB  "]"
+
+.ti -8
+.BR "ip mptcp limits set "
+.RB "[ "
+.B subflow
+.IR SUBFLOW_NR " ]"
+.RB "[ "
+.B add_addr_accepted
+.IR  ADD_ADDR_ACCEPTED_NR " ]"
+
+.ti -8
+.BR "ip mptcp limits show"
+
+.SH DESCRIPTION
+
+MPTCP is a transport protocol built on top of TCP that allows TCP
+connections to use multiple paths to maximize resource usage and increas=
e
+redundancy. The ip-mptcp sub-commands allow configuring several aspects =
of the
+MPTCP path manager, which is in charge of subflows creation:
+
+.P
+The
+.B endpoint
+object specifies the IP addresses that will be used and/or announced for
+additional subflows:
+
+.TS
+l l.
+ip mptcp endpoint add	add new MPTCP endpoint
+ip mptcp endpoint delete	delete existing MPTCP endpoint
+ip mptcp endpoint show	get existing MPTCP endpoint
+ip mptcp endpoint flush	flush all existing MPTCP endpoints
+.TE
+
+.TP
+.IR ID
+is a unique numeric identifier for the given endpoint
+
+.TP
+.BR signal
+the endpoint will be announced/signalled to each peer via an ADD_ADDR MP=
TCP
+sub-option
+
+.TP
+.BR subflow
+if additional subflow creation is allowed by MPTCP limits, the endpoint =
will
+be used as the source address to create an additional subflow after that
+the MPTCP connection is established.
+
+.TP
+.BR backup
+the endpoint will be announced as a backup address, if this is a
+.BR signal
+endpoint, or the subflow will be created as a backup one if this is a
+.BR subflow
+endpoint
+
+.sp
+.PP
+The
+.B limits
+object specifies the constraints for subflow creations:
+
+.TS
+l l.
+ip mptcp limits show	get current MPTCP subflow creation limits
+ip mptcp limits set	change the MPTCP subflow creation limits
+.TE
+
+.TP
+.IR SUBFLOW_NR
+specifies the maximum number of additional subflows allowed for each MPT=
CP
+connection. Additional subflows can be created due to: incoming accepted
+ADD_ADDR option, local
+.BR subflow
+endpoints, additional subflows started by the peer.
+
+.TP
+.IR ADD_ADDR_ACCEPTED_NR
+specifies the maximum number of ADD_ADDR suboptions accepted for each MP=
TCP
+connection. The MPTCP path manager will try to create a new subflow for
+each accepted ADD_ADDR option, respecting the
+.IR SUBFLOW_NR
+limit.
+
+.SH AUTHOR
+Original Manpage by Paolo Abeni <pabeni@redhat.com>
--=20
2.21.1

