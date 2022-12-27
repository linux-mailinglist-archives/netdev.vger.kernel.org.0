Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA75656D72
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 18:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiL0RgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 12:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiL0RgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 12:36:23 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE172652
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 09:36:22 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id u8so7010048ilq.13
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 09:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=smbRtPix3phAazFHEqnSaP3v1M/yT1Gt8/0I+tzWvyQ=;
        b=oAVdZUIYHrd+buByS3ENc+V0eyW0FrKzv+C6ZJ3r0LHIJvB3mg09an331KIMSZuCLi
         jv13X+QxVu3YVJi0Tazwn5Ps6Kmwi2YjFagmeZhIw2xaozv7WmSsGdyKM7tMkKBRCNkb
         zn9g8AVJnVUE3IrSt4ggWmHQeYzCWNTLaqG+DukbTTEQopKNOwtecQAW8vL8cz/5igIp
         piqt2bw9cxF05v4Q6sqM10Gwi9DuGjMx1GKuW5pJpu/oZ2ST9aokHOHJrqYZ4b5oRtAl
         UV9BH6Ly0nrPMDhR1zLmM37AHU4G9tIHrxlvr8NQdjYdarJlRt1fraKWg1rQBmP4qGYj
         Lquw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=smbRtPix3phAazFHEqnSaP3v1M/yT1Gt8/0I+tzWvyQ=;
        b=n6XafiFuoly7gMhPSBiTViJ8bur1mtzZyFrefieUYwvSxe61F3UdL81lAXE8fLUpGY
         enI8BR9DVDFagdOBbM2BwP7r/p6+ojptxmRltRiJw8tMaJ7DlV8t1UfQBw7QzYWallN1
         Ka8lFlimIBq7wFMH32NpnnyFKTIqgq0CouIbr9JjVrnfGakM8sK25wrO/Ku+eZHtysZQ
         JrZLq/x5ddFv5uNsomk1StlDcTCHwRcf8AlQ0vK828y/9UC3QDTcIlhHNc9Ved5KR0UY
         yvS2GOp4U9aAbijH7ro+FGH0rq/4X7FSTA+U+N/AUsW8EpzGoPSPb9vzLq1T+VtGHROq
         gIng==
X-Gm-Message-State: AFqh2kqUgW9yP1ptw1K1U3u0Jm3PWoGgSycW7EWv2w5t/Vl6mvOstlC0
        9AT8aT4gRLHEAB/O5AFDh60=
X-Google-Smtp-Source: AMrXdXv4OvRjcbTwJmkTP/Od4+LSnPHG2uTCuVEVWjWCDgOtSYitIV/uKIsFXhgTkKwFNWfUmSUTiw==
X-Received: by 2002:a92:c085:0:b0:30c:f88:e807 with SMTP id h5-20020a92c085000000b0030c0f88e807mr2074912ile.6.1672162582199;
        Tue, 27 Dec 2022 09:36:22 -0800 (PST)
Received: from fedora.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id v14-20020a92cd4e000000b0030258f9670bsm4304630ilq.13.2022.12.27.09.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 09:36:21 -0800 (PST)
From:   Maxim Georgiev <glipus@gmail.com>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, kuba@kernel.org, glipus@gmail.com
Subject: [PATCH ethtool-next] Fixing boolean value output for Netlink reported values in JSON format
Date:   Tue, 27 Dec 2022 10:36:20 -0700
Message-Id: <20221227173620.6577-1-glipus@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current implementation of show_bool_val() passes "val" parameter of pointer
type as a last parameter to print_bool():
https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/tree/netlink/netlink.h#n131
...
static inline void show_bool_val(const char *key, const char *fmt, uint8_t *val)
{
	if (is_json_context()) {
		if (val)
>			print_bool(PRINT_JSON, key, NULL, val);
	} else {
...
print_bool() expects the last parameter to be bool:
https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/tree/json_print.c#n153
...
void print_bool(enum output_type type,
		const char *key,
		const char *fmt,
		bool value)
{
...
Current show_bool_val() implementation converts "val" pointer to bool while
calling show_bool_val(). As a result show_bool_val() always prints the value
as "true" as long as it gets a non-null pointer to the boolean value, even if
the referred boolean value is false.

Fixes: 7e5c1ddbe67d ("pause: add --json support")
Signed-off-by: Maxim Georgiev <glipus@gmail.com>
---
 netlink/netlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/netlink/netlink.h b/netlink/netlink.h
index 3240fca..1274a3b 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -128,7 +128,7 @@ static inline void show_bool_val(const char *key, const char *fmt, uint8_t *val)
 {
 	if (is_json_context()) {
 		if (val)
-			print_bool(PRINT_JSON, key, NULL, val);
+			print_bool(PRINT_JSON, key, NULL, *val);
 	} else {
 		print_string(PRINT_FP, NULL, fmt, u8_to_bool(val));
 	}
-- 
2.38.1

