Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54667113719
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 22:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfLDVcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 16:32:09 -0500
Received: from mail-yb1-f202.google.com ([209.85.219.202]:33958 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbfLDVcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 16:32:09 -0500
Received: by mail-yb1-f202.google.com with SMTP id x191so791305ybg.1
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 13:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=akkVbDWURBPG3dzvXJ5rVgMMwDXRurnqOI11X4GD1k0=;
        b=XH9ZRmEIJbzFj0rxUa99bBTsEehNHZw2FAZdPkvfnUba5fiOWDgWdcv0QQgpfvKPMC
         AO+llBVIpCsrJVymrQtBjnpHjwPXqBfbvRpF4IQLqVROD1pQo8T6dFaQL35uzXYCfIIF
         w/+9+pP1oszHFRX0/VAoZh84NHH6v5cDtsvzLzPeMshZ9iWEMUQPHhwa0/sSNkdzfKpE
         zb956na0IbGfXtkpMIDTgTnvuhiGYB5z9omDxtdD2jLqjSElO9PsgZmYs27fUqZMxaAL
         0lA4OH0T6H6r7AWv3Em7xUw+l/bpbT3aoo25s+CknAqFMkbuIWtSaCVBHgWwXrLAyDKd
         UHBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=akkVbDWURBPG3dzvXJ5rVgMMwDXRurnqOI11X4GD1k0=;
        b=qYruIvM4GxRQO24B6eZ59zJdkHnukISqnEdyNluNAn/sFFS5HGR4/1+Av3yRunkIfY
         v8azwUXe2IsCO+L+0v7sfE5nEU1BFa6zvze6AqPq9widCee7H21Dx2IaTD7pZn6kVzXv
         +xca5yY1ok7GFoN13ERK9sGPhwj5SEl7a/ZMyi1Ay10igPJKZd5PVdvQBBpJNTiash9X
         EAojurJelbCuoPpH8pNxEp2JJEqD/eDWgvUZoGpmfyjjjgZzi0Nt3hT5r7h4I4QyCIwI
         aBKjG+2A3ZwGKEzwcAZWjIdjeed+x7XnBZLNB26S7WYWj2tPOfiGBfCfgDYL1U1h8A32
         In4Q==
X-Gm-Message-State: APjAAAUVl/+Si3EEwdFPLoHpwf9a1QnQQhIZN7emPhP236w2BZW3wjSq
        UU1OkNQbiwMUj8KIJyQYGtg7S7SPT4F4
X-Google-Smtp-Source: APXvYqyQtyOvk9UGGoXVYy5+W/zp+HoKUxCYuY1T7oOXssJzeQ4QRfhI/6jDVH61F7+GTxfgD25DbrJ8czrK
X-Received: by 2002:a0d:f645:: with SMTP id g66mr3851720ywf.116.1575495128236;
 Wed, 04 Dec 2019 13:32:08 -0800 (PST)
Date:   Wed,  4 Dec 2019 13:32:03 -0800
Message-Id: <20191204213203.163073-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH iproute2 v2] tc: fix warning in tc/q_pie.c
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Mahesh Bandewar <maheshb@google.com>,
        Maciej Zenczykowski <maze@google.com>, netdev@vger.kernel.org,
        Brian Vazquez <brianvv@google.com>,
        Leslie Monis <lesliemonis@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Warning was:
q_pie.c:202:22: error: implicit conversion from 'unsigned long' to
'double'

Fixes: 492ec9558b30 ("tc: pie: change maximum integer value of tc_pie_xstats->prob")
Cc: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 v2: rebase to current version.

 tc/q_pie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/q_pie.c b/tc/q_pie.c
index 935548a2..fda98a71 100644
--- a/tc/q_pie.c
+++ b/tc/q_pie.c
@@ -217,7 +217,7 @@ static int pie_print_xstats(struct qdisc_util *qu, FILE *f,
 	st = RTA_DATA(xstats);
 	/*prob is returned as a fracion of maximum integer value */
 	fprintf(f, "prob %f delay %uus",
-		(double)st->prob / UINT64_MAX, st->delay);
+		(double)st->prob / (double)UINT64_MAX, st->delay);
 
 	if (st->dq_rate_estimating)
 		fprintf(f, " avg_dq_rate %u\n", st->avg_dq_rate);
-- 
2.24.0.393.g34dc348eaf-goog

