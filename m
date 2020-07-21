Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEEB92274C8
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgGUBmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728228AbgGUBmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:42:08 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9037C061794;
        Mon, 20 Jul 2020 18:42:08 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id k18so15002144qtm.10;
        Mon, 20 Jul 2020 18:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3kzc+irLFgVhQ9n0dTjUMyvUgBauAQI5DCdqyR/t7/A=;
        b=Ez//KUJcJVRbq+3weK/7MJV2HoNSXJuE8Qoo15LekqLu5Gs0V2iAQqqDORE8TVabCs
         tC3oyBPyNOBaM8PvPKik9ToC+Z9xDmfWgXFZIwvKY+WvnNq5+iyK7cRdehWha1VzIYc1
         Uh2ZtUXuWzJj/7+EOXjUbc9wmAOipp2IVJTiH0JhFyPjezjrYbSQjucIzpZcT3hLHpPW
         Z8L2tug8I/o4F5G3bpkWeuaHaUbz4zFWjC346U/BW1y3RWoAtlvtM0TSAXiMX0gbTjgr
         qGaC2uyW1gM/i7kphNSX0fpIJmnsekKa5W2ICPokqABxp91uiI47sHb0kkcISchb3qYE
         OsWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3kzc+irLFgVhQ9n0dTjUMyvUgBauAQI5DCdqyR/t7/A=;
        b=dMLUFfStqJ8TougXY051kNLFJ6ximVIalWyrtZkS0WDXhQS5r8yYCYWEvMvNruOeJy
         xuW5cisnoOLpE3JbS/IBBzE743+iqbXe78fmTTvh3dIHea8+7hS8poOWvUCsdcQ/U2Gq
         xxIh92wPUSPfJvxVK2Azagyb2iNvLHkUvdpJCM3XDB0PrEzvWzIgXMJmBzTEAzrT4pOp
         /iNczfD6r7tGUTLRUdGn2OiXHovN2hC8wogn/xEyQUIzIbAr/AL4XV45fdTKBFGJaSTW
         I5fEr3y96+c3YGpSXiiSu47dB1So3dNV2mwhDKy9vr8zor21ZjUY6HOgxB+OevMZUXdO
         q+yw==
X-Gm-Message-State: AOAM532qyOXufTdkJ2/wtSLA6zuic5o8MaiZcfBimH4vEuQwX4/ZSGFi
        a98oZF+HEwuPQ0NnO5eTeAc=
X-Google-Smtp-Source: ABdhPJyGe3BmZBj3Tl8E3RN3ZLtlD2biGimL4+HNYM3VYCR/VMLwhvtqRPxR9MTrubEvorRmOrNgcg==
X-Received: by 2002:ac8:649:: with SMTP id e9mr26220277qth.314.1595295728056;
        Mon, 20 Jul 2020 18:42:08 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id a193sm1092131qkc.102.2020.07.20.18.42.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2020 18:42:07 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id EAC4F27C0054;
        Mon, 20 Jul 2020 21:42:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 20 Jul 2020 21:42:06 -0400
X-ME-Sender: <xms:7kcWX1yBqxo2IxaO2W-c7aTLx3QXhVJhq3nmnGWycUPWKZefFYHQWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeehgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    fuohhrthgvugftvggtihhpvdculdegtddmnecujfgurhephffvufffkffojghfggfgsedt
    keertdertddtnecuhfhrohhmpeeuohhquhhnucfhvghnghcuoegsohhquhhnrdhfvghngh
    esghhmrghilhdrtghomheqnecuggftrfgrthhtvghrnhephedvveetfefgiedutedtfeev
    vddvleekjeeuffffleeguefhhfejteekieeuueelnecukfhppeehvddrudehhedrudduud
    drjedunecuvehluhhsthgvrhfuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhep
    sghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtie
    egqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhi
    gihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:7kcWX1TYBMIafZQyLXsAIsJNdjLqclNRKCpF2Xfp5gsQRhETsfEF7g>
    <xmx:7kcWX_XrOzPs6XVPkH-ChbCkbH7o5_Ltln6K56xOm6y1uDOGNmPYRw>
    <xmx:7kcWX3gBQedZbb5fRUtxTUHS9Dmk202AfQUyZhlAXwtMRZe-7bIDug>
    <xmx:7kcWX_YTW5mzISxfWKIIMi7Q286n_yCHY5vjSlR9GUnhq7PN32k3YowZrJQ>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 64F8E3280070;
        Mon, 20 Jul 2020 21:42:06 -0400 (EDT)
From:   Boqun Feng <boqun.feng@gmail.com>
To:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
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
        Michael Kelley <mikelley@microsoft.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [RFC 09/11] HID: hyperv: Make ringbuffer at least take two pages
Date:   Tue, 21 Jul 2020 09:41:33 +0800
Message-Id: <20200721014135.84140-10-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200721014135.84140-1-boqun.feng@gmail.com>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
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
 drivers/hid/hid-hyperv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
index 0b6ee1dee625..36c5e157c691 100644
--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -104,8 +104,8 @@ struct synthhid_input_report {
 
 #pragma pack(pop)
 
-#define INPUTVSC_SEND_RING_BUFFER_SIZE		(40 * 1024)
-#define INPUTVSC_RECV_RING_BUFFER_SIZE		(40 * 1024)
+#define INPUTVSC_SEND_RING_BUFFER_SIZE		(128 * 1024)
+#define INPUTVSC_RECV_RING_BUFFER_SIZE		(128 * 1024)
 
 
 enum pipe_prot_msg_type {
-- 
2.27.0

