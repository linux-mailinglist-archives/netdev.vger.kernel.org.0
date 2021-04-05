Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57104353A41
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 02:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbhDEAbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 20:31:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231693AbhDEAbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 20:31:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617582666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iSJ3pKh1BivwXCh+A/1gJQXkiIPD6okedKlGIxFuIhA=;
        b=FJb9dyW4xHdwEeCVgEp3rbuJj9FnpMn8EXMk8g+L09r7pa9rVQ02a6Z1OYhiMtPQEaY3T8
        CDGv8rOukC5YS7mfCItuyzffblrD68oXa8htDJGbycy1oPnQqO8NNQiipP3CRVtsFs+cl+
        H+dTJMSJv4TQYfvbJAKFISrWnPs+FqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-sPF1MGPDOoyiR4pz-sy-UQ-1; Sun, 04 Apr 2021 20:31:04 -0400
X-MC-Unique: sPF1MGPDOoyiR4pz-sy-UQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21222817469;
        Mon,  5 Apr 2021 00:31:03 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-113-102.rdu2.redhat.com [10.10.113.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A00A42B189;
        Mon,  5 Apr 2021 00:31:01 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH RESEND wpan 00/15] net: ieee802154: forbid sec params for monitors
Date:   Sun,  4 Apr 2021 20:30:39 -0400
Message-Id: <20210405003054.256017-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this patch series contains fixes to forbid various security parameters
settings for monitor types. Monitor types doesn't use the llsec security
currently and we don't support it. With this patch series the user will
be notified with a EOPNOTSUPP error that for monitor interfaces security
is not supported yet. However there might be a possibility in future
that the kernel will decrypt frames with llsec information for sniffing
frames and deliver plaintext to userspace, but this isn't supported yet.

- Alex

Alexander Aring (15):
  net: ieee802154: nl-mac: fix check on panid
  net: ieee802154: forbid monitor for set llsec params
  net: ieee802154: stop dump llsec keys for monitors
  net: ieee802154: forbid monitor for add llsec key
  net: ieee802154: forbid monitor for del llsec key
  net: ieee802154: stop dump llsec devs for monitors
  net: ieee802154: forbid monitor for add llsec dev
  net: ieee802154: forbid monitor for del llsec dev
  net: ieee802154: stop dump llsec devkeys for monitors
  net: ieee802154: forbid monitor for add llsec devkey
  net: ieee802154: forbid monitor for del llsec devkey
  net: ieee802154: stop dump llsec seclevels for monitors
  net: ieee802154: forbid monitor for add llsec seclevel
  net: ieee802154: forbid monitor for del llsec seclevel
  net: ieee802154: stop dump llsec params for monitors

 net/ieee802154/nl-mac.c   |  7 +++---
 net/ieee802154/nl802154.c | 52 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 3 deletions(-)

-- 
2.26.3

