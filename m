Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A653E93F6
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 16:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhHKOvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 10:51:37 -0400
Received: from smtpout30.security-mail.net ([85.31.212.37]:28994 "EHLO
        fx306.security-mail.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232589AbhHKOvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 10:51:36 -0400
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Aug 2021 10:51:36 EDT
Received: from localhost (localhost [127.0.0.1])
        by fx306.security-mail.net (Postfix) with ESMTP id 9209039955E
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 16:44:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalray.eu;
        s=sec-sig-email; t=1628693053;
        bh=gZou+HFQeHw91t1FyYMRJTbruRgsl8ynxh9C93Ito5k=;
        h=From:To:Cc:Subject:Date;
        b=vxXqHAyR3XOFq0elaZiMyC13wlgLPj8poQMnQ2Xfg+pkoxACpPQixuoPd3VFT7I3S
         lE724PlFlp9tcboh+Hfzy1F8QtcUsMzZw72YC761wEXltTwx6fb8Oo7C8HqbRP2w/z
         8/I19Er/6YjF1haXUk8zMsLwPHyIfk0KgU/k7N24=
Received: from fx306 (localhost [127.0.0.1])
        by fx306.security-mail.net (Postfix) with ESMTP id D1A3D399513;
        Wed, 11 Aug 2021 16:44:12 +0200 (CEST)
X-Virus-Scanned: E-securemail
Secumail-id: <15818.6113e23c.84949.0>
Received: from zimbra2.kalray.eu (unknown [217.181.231.53])
        by fx306.security-mail.net (Postfix) with ESMTPS id 8555B39956D;
        Wed, 11 Aug 2021 16:44:12 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1])
        by zimbra2.kalray.eu (Postfix) with ESMTPS id 7029E27E02C1;
        Wed, 11 Aug 2021 16:44:12 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by zimbra2.kalray.eu (Postfix) with ESMTP id 5AB8A27E02A3;
        Wed, 11 Aug 2021 16:44:12 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra2.kalray.eu 5AB8A27E02A3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalray.eu;
        s=32AE1B44-9502-11E5-BA35-3734643DEF29; t=1628693052;
        bh=8grwC6CVMEm0QYxHt6LKfWhLHOIAuBVI6YmsLIclkYY=;
        h=From:To:Date:Message-Id;
        b=gwAYPmEqa9yiJc9DA9xZwJV+7luurrYXuPE4gKVFyhPemJ0hz0vROPFWSfjhwp1/I
         t/4H8bFpKlfdDUgQwB0msNODF8Byu5jRD7hP89FCNG4O92CmsEQTygPZSA2+Kn6qBO
         cKwXk67bHAMUNpOEGVKyHDG7VMMQ4nJKJNJyZHYg=
Received: from zimbra2.kalray.eu ([127.0.0.1])
        by localhost (zimbra2.kalray.eu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1vUe2_1GkFdC; Wed, 11 Aug 2021 16:44:12 +0200 (CEST)
Received: from tellis.lin.mbt.kalray.eu (unknown [192.168.36.206])
        by zimbra2.kalray.eu (Postfix) with ESMTPSA id 4130227E0232;
        Wed, 11 Aug 2021 16:44:12 +0200 (CEST)
From:   Jules Maselbas <jmaselbas@kalray.eu>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Jules Maselbas <jmaselbas@kalray.eu>
Subject: [PATCH ethtool] Remove trailing newline in perror messages
Date:   Wed, 11 Aug 2021 16:43:59 +0200
Message-Id: <20210811144359.30419-1-jmaselbas@kalray.eu>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: by Secumail
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

perror append additional text at the end of the error message,
and will also include a newline. The newline in the error message
it self is not needed and can be removed. This makes errors much
nicer to read.

Signed-off-by: Jules Maselbas <jmaselbas@kalray.eu>
---
 ethtool.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 33a0a49..d4c861f 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -2122,7 +2122,7 @@ static int do_gchannels(struct cmd_context *ctx)
 		if (err)
 			return err;
 	} else {
-		perror("Cannot get device channel parameters\n");
+		perror("Cannot get device channel parameters");
 		return 1;
 	}
 	return 0;
@@ -4613,7 +4613,7 @@ static int do_getfwdump(struct cmd_context *ctx)
 
 	err = send_ioctl(ctx, &edata);
 	if (err < 0) {
-		perror("Can not get dump level\n");
+		perror("Can not get dump level");
 		return 1;
 	}
 	if (dump_flag != ETHTOOL_GET_DUMP_DATA) {
@@ -4623,14 +4623,14 @@ static int do_getfwdump(struct cmd_context *ctx)
 	}
 	data = calloc(1, offsetof(struct ethtool_dump, data) + edata.len);
 	if (!data) {
-		perror("Can not allocate enough memory\n");
+		perror("Can not allocate enough memory");
 		return 1;
 	}
 	data->cmd = ETHTOOL_GET_DUMP_DATA;
 	data->len = edata.len;
 	err = send_ioctl(ctx, data);
 	if (err < 0) {
-		perror("Can not get dump data\n");
+		perror("Can not get dump data");
 		err = 1;
 		goto free;
 	}
@@ -4654,7 +4654,7 @@ static int do_setfwdump(struct cmd_context *ctx)
 	dump.flag = dump_flag;
 	err = send_ioctl(ctx, &dump);
 	if (err < 0) {
-		perror("Can not set dump level\n");
+		perror("Can not set dump level");
 		return 1;
 	}
 	return 0;
-- 
2.17.1

