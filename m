Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5253215D8
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 13:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhBVMKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 07:10:44 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17050 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhBVMKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 07:10:35 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60339f110003>; Mon, 22 Feb 2021 04:09:53 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Feb
 2021 12:09:52 +0000
Received: from c-236-149-120-125.mtl.labs.mlnx (172.20.145.6) by
 mail.nvidia.com (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via
 Frontend Transport; Mon, 22 Feb 2021 12:09:51 +0000
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>
Subject: [PATCH iproute2] dcb: Fix compilation warning about reallocarray
Date:   Mon, 22 Feb 2021 14:09:43 +0200
Message-ID: <20210222120943.2035-1-roid@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613995793; bh=kmZlJZKdCn5DHFFiB64IzqZ1KMy+T/qAdVdbf9020IA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Type:Content-Transfer-Encoding;
        b=JjDDCWWYRnkCrwQFLCkeCk7JODZ3l8B9R+KOO0clnWUWJ+8/T+5KoBMRmC5u2EW2l
         WOUpF3j+6VNALsKazpBv6PFHzcN36pc805sAvOUn9P7On1tLluLQdKWJNE4aEQVZ4B
         xEdC3Vtu5BMAsbxCltIXUg7zAnWNUx8D945aN22rdeXvPKvIU2BdsOVds+QeRugvZy
         6OeRJM3Kif4Agp2xsnl4IlPwPssjjwsAZ9oIaPcrapTURrbOvohf2SO+ayZ7HBWzZF
         siFN4hmZoL8yXB1AwnlgPMEH5mZVfNEkvli7F9lFniN5F8e00DMlv2el5iUj1Cslyp
         wn83B4O0N9Qng==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To use reallocarray we need to add bsd/stdlib.h.

dcb_app.c: In function =E2=80=98dcb_app_table_push=E2=80=99:
dcb_app.c:68:25: warning: implicit declaration of function =E2=80=98realloc=
array=E2=80=99; did you mean =E2=80=98realloc=E2=80=99?

Fixes: 8e9bed1493f5 ("dcb: Add a subtool for the DCB APP object")
Signed-off-by: Roi Dayan <roid@nvidia.com>
---
 dcb/dcb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/dcb/dcb.c b/dcb/dcb.c
index 6640deef5688..32896c4d5732 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -5,6 +5,7 @@
 #include <linux/dcbnl.h>
 #include <libmnl/libmnl.h>
 #include <getopt.h>
+#include <bsd/stdlib.h>
=20
 #include "dcb.h"
 #include "mnl_utils.h"
--=20
2.8.0

