Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CBF648C7E
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 03:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiLJCQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 21:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiLJCQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 21:16:24 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86392D1F2
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 18:16:22 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id b2so15455959eja.7
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 18:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1R9VAANJlTrciJjQsKDvPNKmcff13RR4a7aIKJTOf9c=;
        b=ZtuGuLaeoGZ3W8TVpK60hamKcRs18txIQWbzWmwyu2jUk7G+AMYijvhhZ3A7v1crOi
         2me6j2AZMMGJZ+cx6ARcEPdceqbY8QEaMXhC5E51xRcu+r23edZBcTvzpKGT1eaTelWR
         ZMbHBGit6peX4vQj0gqBRbgT9d6j4lv1lsUzzAR7Vt5nwge+OA+mO26GsQoLvoNfkr0+
         HIH/HMOt0wZ8Eiw5MsTB8Yj6cXn5JOQ5WxFBZc0mvVdOSk8eROpUX22MtJ0ON+wGhSGC
         oSRzSbN9fDf5T2TCnmlI0QhfL58lZq+0afb9lm5QynfTUMZ5kkUz1ZKi+iC9rflLpNP7
         U1yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1R9VAANJlTrciJjQsKDvPNKmcff13RR4a7aIKJTOf9c=;
        b=X39RmfX1Iau9JdxOp2BX4Jh07faXLeX+lJlkUM+JLnmysUrvO4DsI3aF6UxgREPyMO
         QKNx/7+beT03VnRFDOTzkGyQ4fLMiHsKTNrL0Uec3EJyTHH34sFQziFWbqHCJvdb4E1K
         hvm9DoiDUwm3rgZep9Xuap5CzWAK3xIBRBqT2YCnRt3QnSQkY2dpg7mbdtQzkeqlhbis
         6k9t5s+8z9cpngRfezRcAyRvzSxqCPjH+QcmoqHyFTTNvv9BAG3tmNfz357Ss/PLw40m
         0cXSAYMi1cB2l1lP/XLJqwcaI6ylN6eUzsY/Y9oy4ppSxQRJJ1Vmf2mewrlWXMxn/7Su
         ojhA==
X-Gm-Message-State: ANoB5pkq9GJwVMO0xQzAvGKhS24t/zQiHqXE5lVLHUdc/G8EABV77l7e
        lXFzFMFc0eb94uROo3544iLsXmKvjYBI6EAj8rhgwJg1T3uz4w==
X-Google-Smtp-Source: AA0mqf6XJiZ+0Ps2gMOubRUyUKeiL0x+8antiPEGu+vjTjqFCBNXFV76V2hxvAg6ideAsXj67GLIPQYKOVas+/G4LAI=
X-Received: by 2002:a17:906:65c4:b0:7ad:d250:b907 with SMTP id
 z4-20020a17090665c400b007add250b907mr78888816ejn.737.1670638581277; Fri, 09
 Dec 2022 18:16:21 -0800 (PST)
MIME-Version: 1.0
From:   Max Georgiev <glipus@gmail.com>
Date:   Fri, 9 Dec 2022 19:16:10 -0700
Message-ID: <CAP5jrPHr2UMpKK45NTUVLtW9OiBctZhWP-0yVvb9_SBO3pC7LA@mail.gmail.com>
Subject: [PATCH ethtool] JSON output support for Netlink implementation of
 --show-coalesce option
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

JSON output support for Netlink implementation of --show-coalesce option

Add --json support for Netlink implementation of --show-coalesce option
No changes for non-JSON output for this feature.

Example output without --json:
$ sudo ./ethtool --show-coalesce enp9s0u2u1u2
Coalesce parameters for enp9s0u2u1u2:
Adaptive RX: n/a  TX: n/a
stats-block-usecs: n/a
sample-interval: n/a
pkt-rate-low: n/a
pkt-rate-high: n/a

rx-usecs: 15000
rx-frames: n/a
rx-usecs-irq: n/a
rx-frames-irq: n/a

tx-usecs: 0
tx-frames: n/a
tx-usecs-irq: n/a
tx-frames-irq: n/a

rx-usecs-low: n/a
rx-frame-low: n/a
tx-usecs-low: n/a
tx-frame-low: n/a

rx-usecs-high: n/a
rx-frame-high: n/a
tx-usecs-high: n/a
tx-frame-high: n/a

CQE mode RX: n/a  TX: n/a

Same output with --json:
$ sudo ./ethtool --json --show-coalesce enp9s0u2u1u2
[ {
        "ifname": "enp9s0u2u1u2",
        "rx-usecs: ": 15000,
        "tx-usecs: ": 0
    } ]

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Maxim Georgiev <glipus@gmail.com>
---
 ethtool.c          |  1 +
 netlink/coalesce.c | 27 ++++++++++++++++++---------
 netlink/netlink.h  | 19 +++++++++++++++----
 3 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 3207e49..3b8412c 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5694,6 +5694,7 @@ static const struct option args[] = {
        },
        {
                .opts   = "-c|--show-coalesce",
+               .json   = true,
                .func   = do_gcoalesce,
                .nlfunc = nl_gcoalesce,
                .help   = "Show coalesce options"
diff --git a/netlink/coalesce.c b/netlink/coalesce.c
index 15037c2..f003a5c 100644
--- a/netlink/coalesce.c
+++ b/netlink/coalesce.c
@@ -33,9 +33,12 @@ int coalesce_reply_cb(const struct nlmsghdr *nlhdr,
void *data)
        if (!dev_ok(nlctx))
                return err_ret;

-       if (silent)
+       open_json_object(NULL);
+
+       if (silent && !is_json_context())
                putchar('\n');
-       printf("Coalesce parameters for %s:\n", nlctx->devname);
+       print_string(PRINT_ANY, "ifname", "Coalesce parameters for %s:\n",
+                    nlctx->devname);
        show_bool("rx", "Adaptive RX: %s  ",
                  tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX]);
        show_bool("tx", "TX: %s\n", tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX]);
@@ -45,31 +48,33 @@ int coalesce_reply_cb(const struct nlmsghdr
*nlhdr, void *data)
                 "sample-interval: ");
        show_u32(tb[ETHTOOL_A_COALESCE_PKT_RATE_LOW], "pkt-rate-low: ");
        show_u32(tb[ETHTOOL_A_COALESCE_PKT_RATE_HIGH], "pkt-rate-high: ");
-       putchar('\n');
+       show_cr();
        show_u32(tb[ETHTOOL_A_COALESCE_RX_USECS], "rx-usecs: ");
        show_u32(tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES], "rx-frames: ");
        show_u32(tb[ETHTOOL_A_COALESCE_RX_USECS_IRQ], "rx-usecs-irq: ");
        show_u32(tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_IRQ], "rx-frames-irq: ");
-       putchar('\n');
+       show_cr();
        show_u32(tb[ETHTOOL_A_COALESCE_TX_USECS], "tx-usecs: ");
        show_u32(tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES], "tx-frames: ");
        show_u32(tb[ETHTOOL_A_COALESCE_TX_USECS_IRQ], "tx-usecs-irq: ");
        show_u32(tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_IRQ], "tx-frames-irq: ");
-       putchar('\n');
+       show_cr();
        show_u32(tb[ETHTOOL_A_COALESCE_RX_USECS_LOW], "rx-usecs-low: ");
        show_u32(tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_LOW], "rx-frame-low: ");
        show_u32(tb[ETHTOOL_A_COALESCE_TX_USECS_LOW], "tx-usecs-low: ");
        show_u32(tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_LOW], "tx-frame-low: ");
-       putchar('\n');
+       show_cr();
        show_u32(tb[ETHTOOL_A_COALESCE_RX_USECS_HIGH], "rx-usecs-high: ");
        show_u32(tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_HIGH], "rx-frame-high: ");
        show_u32(tb[ETHTOOL_A_COALESCE_TX_USECS_HIGH], "tx-usecs-high: ");
        show_u32(tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH], "tx-frame-high: ");
-       putchar('\n');
+       show_cr();
        show_bool("rx", "CQE mode RX: %s  ",
                  tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX]);
        show_bool("tx", "TX: %s\n", tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX]);
-       putchar('\n');
+       show_cr();
+
+       close_json_object();

        return MNL_CB_OK;
 }
@@ -92,7 +97,11 @@ int nl_gcoalesce(struct cmd_context *ctx)
                                      ETHTOOL_A_COALESCE_HEADER, 0);
        if (ret < 0)
                return ret;
-       return nlsock_send_get_request(nlsk, coalesce_reply_cb);
+
+       new_json_obj(ctx->json);
+       ret = nlsock_send_get_request(nlsk, coalesce_reply_cb);
+       delete_json_obj();
+       return ret;
 }

 /* COALESCE_SET */
diff --git a/netlink/netlink.h b/netlink/netlink.h
index f43c1bf..3af104b 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -102,10 +102,15 @@ int dump_link_modes(struct nl_context *nlctx,
const struct nlattr *bitset,

 static inline void show_u32(const struct nlattr *attr, const char *label)
 {
-       if (attr)
-               printf("%s%u\n", label, mnl_attr_get_u32(attr));
-       else
-               printf("%sn/a\n", label);
+       if (is_json_context()) {
+               if (attr)
+                       print_uint(PRINT_JSON, label, NULL,
mnl_attr_get_u32(attr));
+       } else {
+               if (attr)
+                       printf("%s%u\n", label, mnl_attr_get_u32(attr));
+               else
+                       printf("%sn/a\n", label);
+       }
 }

 static inline const char *u8_to_bool(const uint8_t *val)
@@ -132,6 +137,12 @@ static inline void show_bool(const char *key,
const char *fmt,
        show_bool_val(key, fmt, attr ? mnl_attr_get_payload(attr) : NULL);
 }

+static inline void show_cr(void)
+{
+       if (!is_json_context())
+               putchar('\n');
+}
+
 /* misc */

 static inline void copy_devname(char *dst, const char *src)
-- 
2.38.1
