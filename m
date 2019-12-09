Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79392117249
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 17:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfLIQ7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 11:59:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26774 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726342AbfLIQ7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 11:59:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575910780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=yGl7Vrv+XWlTtDgTsR3P7I2jEyLRppExhNEltBNPE5I=;
        b=Hvee1Ouk9+dKzNqBQ730OXEcg/SZex5OLdMgCr7cwPNnw/1SOyRFsGlR8WnF1jgExJ61lw
        CZhJZ54tKebIJraE1R4nXagJledPYuovawDXkaCgv1mEB8xAfhAEf7CnjTgw9WJ3tH/h67
        AqHjAiYu0yl65Fk5KLpgIREJt3Rs5tk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-klOrTT9oO_asWHe_pVIwUQ-1; Mon, 09 Dec 2019 11:59:38 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A609A801E53;
        Mon,  9 Dec 2019 16:59:37 +0000 (UTC)
Received: from wlan-180-229.mxp.redhat.com (wlan-180-229.mxp.redhat.com [10.32.180.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4AAA79AC;
        Mon,  9 Dec 2019 16:59:36 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Roman Mashak <mrv@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net] tc-testing: unbreak full listing of tdc testcases
Date:   Mon,  9 Dec 2019 17:58:52 +0100
Message-Id: <153a41008e46c78aab655edd0e7e1b27db1b7813.1575910628.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: klOrTT9oO_asWHe_pVIwUQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the following command currently fails:

 [root@fedora tc-testing]# ./tdc.py -l
 The following test case IDs are not unique:
 {'6f5e'}
 Please correct them before continuing.

this happens because there are two tests having the same id:

 [root@fedora tc-testing]# grep -r 6f5e tc-tests/*
 tc-tests/actions/pedit.json:        "id": "6f5e",
 tc-tests/filters/basic.json:        "id": "6f5e",

fix it replacing the latest duplicate id with a brand new one:

 [root@fedora tc-testing]# sed -i 's/6f5e//1' tc-tests/filters/basic.json
 [root@fedora tc-testing]# ./tdc.py -i

Fixes: 4717b05328ba ("tc-testing: Introduced tdc tests for basic filter")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 tools/testing/selftests/tc-testing/tc-tests/filters/basic.json | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json=
 b/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
index 76ae03a64506..2e361cea63bc 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
@@ -152,7 +152,7 @@
         ]
     },
     {
-        "id": "6f5e",
+        "id": "b99c",
         "name": "Add basic filter with cmp ematch u8/transport layer and d=
efault action",
         "category": [
             "filter",
--=20
2.23.0

