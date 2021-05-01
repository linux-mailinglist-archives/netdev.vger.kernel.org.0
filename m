Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2902A3707EF
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 18:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhEAQpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 12:45:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29789 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230522AbhEAQpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 12:45:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619887467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vhDT7Bh13JALM+TbFZtbkNyHYjQBF4dsNLAer7QG+GM=;
        b=BmcCMw9cFKXmmT0aKjFxsuPQgoEtNG7P4+J9m9VuOszxhkDD1BGb0j9TxHojDqnu+tKhOX
        VgZsCJIAO/qu4e1LSo2vTHixBmZyUkEsjsiOgH46ztMQc0GhMpQuNDf04Ug3Q1Pt0najzB
        iWR5gSVguqJ3xD+nLTm7drZhB1NFvVQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-qIcYlbS1Peae5xmg7XnfUw-1; Sat, 01 May 2021 12:44:26 -0400
X-MC-Unique: qIcYlbS1Peae5xmg7XnfUw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D00A107ACCA;
        Sat,  1 May 2021 16:44:25 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-28.ams2.redhat.com [10.36.112.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A35260BE5;
        Sat,  1 May 2021 16:44:24 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 1/2] dcb: fix return value on dcb_cmd_app_show
Date:   Sat,  1 May 2021 18:39:22 +0200
Message-Id: <d2475b23f31e8cb1eb19d51d8bb10866a06a418c.1619886883.git.aclaudi@redhat.com>
In-Reply-To: <cover.1619886883.git.aclaudi@redhat.com>
References: <cover.1619886883.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dcb_cmd_app_show() is supposed to return EINVAL if an incorrect argument
is provided.

Fixes: 8e9bed1493f5 ("dcb: Add a subtool for the DCB APP object")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 dcb/dcb_app.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index c4816bc2..28f40614 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -667,7 +667,7 @@ static int dcb_cmd_app_show(struct dcb *dcb, const char *dev, int argc, char **a
 out:
 	close_json_object();
 	dcb_app_table_fini(&tab);
-	return 0;
+	return ret;
 }
 
 static int dcb_cmd_app_flush(struct dcb *dcb, const char *dev, int argc, char **argv)
-- 
2.30.2

