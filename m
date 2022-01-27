Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D297B49E16C
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240772AbiA0Lpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:45:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23166 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240729AbiA0Lpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:45:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643283941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8RR5Ue1LHRP/WMllXgj5Q292IyPnVxl6WAY+7fkEGsE=;
        b=HhNI8EE2E/mdoT3hpoAb6kJyauFLVck3agMzACAofr7w6NpeoyIhNlASqlAnJPz4mC8qdp
        D6X4MUcIwO1nA0DhMtevhH0lhYT6x5u7IBmZYWQOfXZ6DUQSv8vCtGqAbvy7+5kvjXyiCV
        /SnYnnD5seSPSgqcnqgnPePQacytf48=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-UqJY85DJOYq8dhvrk7tNpg-1; Thu, 27 Jan 2022 06:45:39 -0500
X-MC-Unique: UqJY85DJOYq8dhvrk7tNpg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77D0F839A46
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 11:45:38 +0000 (UTC)
Received: from queeg.tpb.lab.eng.brq.redhat.com (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA5706E4AC;
        Thu, 27 Jan 2022 11:45:37 +0000 (UTC)
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Miroslav Lichvar <mlichvar@redhat.com>
Subject: [PATCH net-next 0/5] Virtual PTP clock improvements and fix
Date:   Thu, 27 Jan 2022 12:45:31 +0100
Message-Id: <20220127114536.1121765-1-mlichvar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch fixes an oops when unloading a driver with PTP clock and
enabled virtual clocks.

The other patches add missing features to make synchronization with
virtual clocks work as well as with the physical clock.

Miroslav Lichvar (5):
  ptp: unregister virtual clocks when unregistering physical clock.
  ptp: increase maximum adjustment of virtual clocks.
  ptp: add gettimex64() to virtual clocks.
  ptp: add getcrosststamp() to virtual clocks.
  ptp: start virtual clocks at current system time.

 drivers/ptp/ptp_clock.c  | 11 ++++++--
 drivers/ptp/ptp_vclock.c | 59 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 64 insertions(+), 6 deletions(-)

-- 
2.34.1

