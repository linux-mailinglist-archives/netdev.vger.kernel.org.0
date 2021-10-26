Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE7043AF12
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbhJZJaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234844AbhJZJ37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 05:29:59 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C22DC061767;
        Tue, 26 Oct 2021 02:27:36 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id u13so11318306edy.10;
        Tue, 26 Oct 2021 02:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I7YfSyelzy7SPOD/68bXsBPGsKRurvUCvEQxs14RBXU=;
        b=TjYgjSVOmnnMkWPm+jlRpAhJ/Jk4zFaOtVPc+6KH2wltPLi8+L2OGO2CneJJC8UzQ4
         7uN/gaYQM5sKKA4mPCRw6qRskqSUiexL+wLCZvGO6aKLxmcqYDhLs7ZLJPI3uEo74OPM
         QQDssCjxvjKtBmAyiIF86XrgiPCLZsfLca5tBne2o/OTR/1qEGlGznZOWTgLco0Zl/Yv
         1W9xKXW3i5JaZmpeAFtwM02TFYyLIwOELeI4IYqW9s28Z72ohycuNSw/4HtigRHBNk7M
         7hY/nIXdhUnlHVr9niH8No+9GHmLET2CVEtb4zmIH7ejkcuQIcoQDDr9UnubMuhnip1r
         tUuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I7YfSyelzy7SPOD/68bXsBPGsKRurvUCvEQxs14RBXU=;
        b=ZvRlblRK+RaZ/ycYLhe+cpbGq6yxyGw7/XAoiMlcMIMUtQEzNMRhIlTgbboEb/JOBG
         Xr+/ByWG3tI56pL5ahPM6ah66wFgcUcKoJWcyyqi+z3FxniNQWN0Y6YBDMoDf6HJFUmi
         EF6ydMx/pSbGj3qkrIaKyeKGvd5IQJzB/K4dcjGOL/StvbJAFlS8XYGhZ4TrLF8Xe2+i
         7sl90WIHJM8Kp8mYbCiHP95S3B8hrPyt2jrNAD14yY3xe0jAnem+6ywI5SZG6NYRU/NI
         uBpxCs4IU9JQ0e/UoHmF21hMHjcg46c7YwkvSiNwCknzeBFndtUDzwcJhDe07vK10Tl9
         GSWw==
X-Gm-Message-State: AOAM530fx3YbtlJOuUujetA2PhOVGB1J/fSLp8pUkzcLD4PxyksQsRHk
        /30IUGCvFL0v6qfn8aNp6QA=
X-Google-Smtp-Source: ABdhPJyV1TPxG9jV+16YCTn2EphruR+NcwnEI+hIumIkqOc9jEfQMUMirh/PaE3daQf+V0FlQVFTaA==
X-Received: by 2002:a17:907:16aa:: with SMTP id hc42mr19148394ejc.491.1635240454691;
        Tue, 26 Oct 2021 02:27:34 -0700 (PDT)
Received: from localhost.localdomain (host-80-181-148-119.retail.telecomitalia.it. [80.181.148.119])
        by smtp.gmail.com with ESMTPSA id sh19sm6196023ejc.99.2021.10.26.02.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 02:27:34 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        mudongliangabcd@gmail.com, netdev@vger.kernel.org,
        phind.uet@gmail.com, syzkaller-bugs@googlegroups.com
Cc:     syzbot <syzbot+7a942657a255a9d9b18a@syzkaller.appspotmail.com>
Subject: Re: [syzbot] memory leak in cfg80211_inform_single_bss_frame_data
Date:   Tue, 26 Oct 2021 11:27:31 +0200
Message-ID: <2678912.i2LAJy1QmT@localhost.localdomain>
In-Reply-To: <000000000000e1063f05cf34f2a8@google.com>
References: <000000000000e1063f05cf34f2a8@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart327050664.krEj5IxTLE"
Content-Transfer-Encoding: 7Bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart327050664.krEj5IxTLE
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

On Tuesday, October 26, 2021 12:33:23 AM CEST syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    87066fdd2e30 Revert "mm/secretmem: use refcount_t instead 
..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16b55554b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d25eeb482b0f99b
> dashboard link: https://syzkaller.appspot.com/bug?
extid=7a942657a255a9d9b18a
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils 
for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=171cf464b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1396b19f300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the 
commit:
> Reported-by: syzbot+7a942657a255a9d9b18a@syzkaller.appspotmail.com
> 
> BUG: memory leak
> unreferenced object 0xffff88810f3c7980 (size 96):

Let's try the attached diff.

Fabio
--nextPart327050664.krEj5IxTLE
Content-Disposition: attachment; filename="scan_c_diff"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="scan_c_diff"

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 11c68b159324..e84855ea4075 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2380,7 +2380,7 @@ cfg80211_inform_single_bss_frame_data(struct wiphy *wiphy,
 		capability = le16_to_cpu(mgmt->u.probe_resp.capab_info);
 	}
 
-	ies = kzalloc(sizeof(*ies) + ielen, gfp);
+	ies = kzalloc(sizeof(cfg80211_bss_ies) + ielen, gfp);
 	if (!ies)
 		return NULL;
 	ies->len = ielen;

--nextPart327050664.krEj5IxTLE--



