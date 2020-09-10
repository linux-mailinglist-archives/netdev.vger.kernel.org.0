Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10152651FF
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgIJVGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731031AbgIJOgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:36:08 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBF5C0617A5;
        Thu, 10 Sep 2020 07:35:22 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id nw23so9063526ejb.4;
        Thu, 10 Sep 2020 07:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cJZ1ALnckJC8ruyPBCuRJ0Lsg32GinrUeRHrSBpztMM=;
        b=pMyjgVpawhrKbJYpksDCkMVZhl5j4ABwRjUqNdAB9pCv02RlKDa8LThip7Yne0hup+
         lSmEh/0qbxVuJsplNuvuv3inBYOqFa2fnmMWeysj2OTq4xUW3kZ2mT56EFj/30dyGHd/
         ruaTRIFqoPIBBDyM5CTOOlzRNTFXpcoeZPjymeml9RKt1B0APqnXGJZOC38y11/rremY
         TiHaJsLeh9SJoPvHznavHEdMimz0ahcEpW9NyfhADOiISUj04ys7OgU5knLToCaSV917
         8KpMCI7aItJYq9+PdjA5GYcsDGTrY50xv3zHMsRgrhKg99XcvySc6jtzX+VI4TDJMIj/
         NgaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cJZ1ALnckJC8ruyPBCuRJ0Lsg32GinrUeRHrSBpztMM=;
        b=qFXQkGiYunqryUhY+An0Jm42j0iODwSL12zcfGp1RBHbhXZ4SAV/2w8eUCX1cC+xe6
         6pohsrOo8lf74W4+A/FuRzxvDSVmD1pMn4PqV3XA18hf44CuJIRwsaLvpD6PL6jJB4sC
         gh/SR5DROPHQzXYkCc21Z9XyzbT9Jz08aacZPFlKvoiRCmw2HQEytndHf561pHNhetsf
         wUXgXRKVOmf2LthvOpRrObL8a5SYE+uCkxWKPaI8EOaxfk3dXt+0PpPIek9H/uK2TQwC
         W1Yrabakt9C+ZUJmgO48vcAQBhsSc1xVkoq43rqgYZzwrvsMv1pO6MHGixjdfCntQxYb
         PHlQ==
X-Gm-Message-State: AOAM531dsM0GoWkXxx1CV/jEY0rx2VDyjzdChHOn+VHYkqbh8rfQI69o
        wXqQM61VSBRkaO6CxqrNMlM=
X-Google-Smtp-Source: ABdhPJx6aEJH96kjwRD/WTSeHx2VkGr4g/gIVID3Jq9BaiQDF+o4qqUHlSGbFq8qOjiXLgCUsj6qsg==
X-Received: by 2002:a17:906:aecb:: with SMTP id me11mr9608863ejb.217.1599748521431;
        Thu, 10 Sep 2020 07:35:21 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id h10sm6975442ejt.93.2020.09.10.07.35.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 07:35:20 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 94E8027C00A1;
        Thu, 10 Sep 2020 10:35:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 10 Sep 2020 10:35:17 -0400
X-ME-Sender: <xms:pTlaX0OY-WCrHADKZd5H16fWTP4nmtCgGYh-J7GHzH0CmVEmZqdljw>
    <xme:pTlaX68izEi2JApZTKzAM1BB75THqWOulq1W6L1_yjRJFRJh3FSDoU50pfCysJ4lB
    iHhx16VxF0KbQ0i9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehjedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjughrpefhvffufffkofgjfhgggfes
    tdekredtredttdenucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqhhunhdrfhgvnh
    hgsehgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeehvdevteefgfeiudettdef
    vedvvdelkeejueffffelgeeuhffhjeetkeeiueeuleenucfkphephedvrdduheehrdduud
    durdejudenucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtd
    eigedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehf
    ihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:pTlaX7RWyBhHxAjUXnDOc1TSPC3Urvaj3KvpXZqPHOY0EieVVFnHcg>
    <xmx:pTlaX8sOBtbUqxAalZnPPYgTZgRFLuMqXKstToadWE4cs8-haXbnRw>
    <xmx:pTlaX8dyRnuTHgM5YC_vzA7F1q9s5IsOrPoXIgI60WdNBFmMx7ZSug>
    <xmx:pTlaXwMQp70cfK2PY7A-PX9E0c9xuSAEr9xRzK-1Gzyn0BKGvweRxGl6HZE>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id CC5073064685;
        Thu, 10 Sep 2020 10:35:16 -0400 (EDT)
From:   Boqun Feng <boqun.feng@gmail.com>
To:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Kelley <mikelley@microsoft.com>, will@kernel.org,
        ardb@kernel.org, arnd@arndb.de, catalin.marinas@arm.com,
        mark.rutland@arm.com, maz@kernel.org,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [PATCH v3 08/11] Input: hyperv-keyboard: Make ringbuffer at least take two pages
Date:   Thu, 10 Sep 2020 22:34:52 +0800
Message-Id: <20200910143455.109293-9-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200910143455.109293-1-boqun.feng@gmail.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When PAGE_SIZE > HV_HYP_PAGE_SIZE, we need the ringbuffer size to be at
least 2 * PAGE_SIZE: one page for the header and at least one page of
the data part (because of the alignment requirement for double mapping).

So make sure the ringbuffer sizes to be at least 2 * PAGE_SIZE when
using vmbus_open() to establish the vmbus connection.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 drivers/input/serio/hyperv-keyboard.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/serio/hyperv-keyboard.c b/drivers/input/serio/hyperv-keyboard.c
index df4e9f6f4529..6ebc61e2db3f 100644
--- a/drivers/input/serio/hyperv-keyboard.c
+++ b/drivers/input/serio/hyperv-keyboard.c
@@ -75,8 +75,8 @@ struct synth_kbd_keystroke {
 
 #define HK_MAXIMUM_MESSAGE_SIZE 256
 
-#define KBD_VSC_SEND_RING_BUFFER_SIZE		(40 * 1024)
-#define KBD_VSC_RECV_RING_BUFFER_SIZE		(40 * 1024)
+#define KBD_VSC_SEND_RING_BUFFER_SIZE	max(40 * 1024, (int)(2 * PAGE_SIZE))
+#define KBD_VSC_RECV_RING_BUFFER_SIZE	max(40 * 1024, (int)(2 * PAGE_SIZE))
 
 #define XTKBD_EMUL0     0xe0
 #define XTKBD_EMUL1     0xe1
-- 
2.28.0

