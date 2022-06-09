Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F4B545726
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 00:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345654AbiFIWTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 18:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345695AbiFIWTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 18:19:19 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E094CD5F
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 15:19:11 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id x29-20020a056a000bdd00b0051c0902c1f3so7621872pfu.20
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 15:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fWdTUxWRVXkKLWYheGOI11e0mL2XAHFKbZxg8ksMoZM=;
        b=ezNDouTkewW/awvW/cRvKC6jHhcMBl4eQkJi6sdP+X2J6iJMkd00jA2jaRJhpFY7aw
         yxivdcEq++4iV1GgB2ziv1ayV3oP8FWg/GB0Zo4bN9LSRrIbKMWW4pYYedFNqaZbtBdq
         LI7orAiKEXNDUMTMRTz+eYmtPr0ihFSVRZhCMEgns7LQjXXffU9ysRs8Jm7/xp/mkHV8
         hqJ/WTn4IigfYhYdyyonY3s//N3eKAKkW8RZYgrVC9YsY682gIJn1c0bZa76vTplgKaA
         3OGnJiqbOGhiGk4PrcLnGinCbRAB3xGsfKwPwyZscTB2mgetoP8/LmB/5HB6hMrHCgU0
         s7qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fWdTUxWRVXkKLWYheGOI11e0mL2XAHFKbZxg8ksMoZM=;
        b=h89yQsPxXd5nJ6zndjk7XpuTQi6Jfj2bZRZX4hel0E1Y8/H6sAuuQfSJb+DTcEUR61
         OvZFNQMhiLrMmDuNAkdncE9j6JBWZnKxuORBXLjnmrSPhfyhEfTijXz7I3ikNALR/H8F
         A09mSYx+NS4mBf9ZFQa7cKjEfldnv6bmrfgYOuBRwUafIzsddiADgWqML/rKfpg4XL+v
         avmWiThbBZIWkwfWzARhfKeYC24ucSn287g/+ilPn5uDFf1EsHnnJqA7P98mtc30XiwX
         dWToXWsGj8pLLkTEGvM1mSZEAlnl04bO50qsCuk6ajgNnrQO+u0TduoZsKohogm6VQrD
         f6YA==
X-Gm-Message-State: AOAM533Kai888BiAOpXZF1LSSzOrSX0tSVOB+yaXbRBPoxc/+Sh5XLo+
        eiXMUJiOXS6hktQiQLtXdbeBc3Vz
X-Google-Smtp-Source: ABdhPJymRh8XdI6qUr+0U3jn9BPA1WS3MroiwqAq54XxkobNI9HSYvmGC6qhWN+ZtdS8zin/gyNAdfGHUw==
X-Received: from fawn.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5795])
 (user=morbo job=sendgmr) by 2002:a63:c5:0:b0:3fe:26a0:7abe with SMTP id
 188-20020a6300c5000000b003fe26a07abemr10973746pga.152.1654813150612; Thu, 09
 Jun 2022 15:19:10 -0700 (PDT)
Date:   Thu,  9 Jun 2022 22:16:24 +0000
In-Reply-To: <20220609221702.347522-1-morbo@google.com>
Message-Id: <20220609221702.347522-6-morbo@google.com>
Mime-Version: 1.0
References: <20220609221702.347522-1-morbo@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 05/12] fs: quota: use correct format characters
From:   Bill Wendling <morbo@google.com>
To:     isanbard@gmail.com
Cc:     Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jan Kara <jack@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Ross Philipson <ross.philipson@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-mm@kvack.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, alsa-devel@alsa-project.org,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bill Wendling <isanbard@gmail.com>

When compiling with -Wformat, clang emits the following warnings:

fs/quota/dquot.c:206:22: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
                    request_module(module_names[qm].qm_mod_name))
                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use a string literal for the format string.

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Signed-off-by: Bill Wendling <isanbard@gmail.com>
---
 fs/quota/dquot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index a74aef99bd3d..3b613de3b371 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -203,7 +203,7 @@ static struct quota_format_type *find_quota_format(int id)
 			     module_names[qm].qm_fmt_id != id; qm++)
 			;
 		if (!module_names[qm].qm_fmt_id ||
-		    request_module(module_names[qm].qm_mod_name))
+		    request_module("%s", module_names[qm].qm_mod_name))
 			return NULL;
 
 		spin_lock(&dq_list_lock);
-- 
2.36.1.255.ge46751e96f-goog

