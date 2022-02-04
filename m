Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DED4A9868
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 12:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358338AbiBDL32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 06:29:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54580 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358367AbiBDL31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 06:29:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643974167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rKcAC/zNHr00Tq8BU3YBzxSoLlmDW9xs1/IiBJPTXXk=;
        b=aJH5Ua6Ub8EzLkFYGVPx2gsUpIEsVvpR6d2n72emfYVDkjo9Uscz+TgGXF2fMlZhLUzh9a
        U6ZGuQ8S/hLdthbWdL1SrM1OyYsLcSzz6wAotZfh8L0xDuIP4cXQik7OMNg3Dnat784uQi
        oVhgmaaxzl7VvxerRrTkcdyXn/j+rvE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-353-Js89B58gOU6TihnHBhGYEQ-1; Fri, 04 Feb 2022 06:29:22 -0500
X-MC-Unique: Js89B58gOU6TihnHBhGYEQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A953D8144E1;
        Fri,  4 Feb 2022 11:29:20 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0310108116A;
        Fri,  4 Feb 2022 11:29:18 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander H Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net-next 0/2] gro: a couple of minor optimization
Date:   Fri,  4 Feb 2022 12:28:35 +0100
Message-Id: <cover.1643972527.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series collects a couple of small optimizations for the GRO engine,
reducing slightly the number of cycles for dev_gro_receive().
The delta is within noise range in tput tests, but with big TCP coming
every cycle saved from the GRO engine will count - I hope ;)

v1 -> v2:
 - a few cleanup suggested from Alexander(s)
 - moved away the more controversial 3rd patch

Paolo Abeni (2):
  net: gro: avoid re-computing truesize twice on recycle
  net: gro: minor optimization for dev_gro_receive()

 include/net/gro.h | 52 +++++++++++++++++++++++++----------------------
 net/core/gro.c    | 16 ++++-----------
 2 files changed, 32 insertions(+), 36 deletions(-)

-- 
2.34.1

