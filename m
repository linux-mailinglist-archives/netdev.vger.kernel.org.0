Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E5F5E83FA
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbiIWUez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbiIWUcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:32:52 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAE0F5977
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:28:36 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id l10so1152878plb.10
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=1MqQrxnQnbWg62GSxHH0OEF1q347X/m+4lnjB2flQT0=;
        b=Sm/M1aPSgGxkRY3LHKu9WT6VO0RigAcBGr0kTvvwRsO2yiPnlyPOycSqBm+Mx8oFi3
         bspsiUMbtKdtztOA4+TN8PPA5DxAgy5IBcQaq/1bn/CTLSI6xp/mM0sWTL+QnjiHRtQm
         hkYMCwfmO+zSjZYsUL+mFvQC8TlG50HBWaABQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=1MqQrxnQnbWg62GSxHH0OEF1q347X/m+4lnjB2flQT0=;
        b=jHoKxna7OmSuyRt7wg3GQugwL0yPiLNBO1KgNJKIxffFZ1iCIgu0k4413tIpOWcczU
         zZ9EN2KtCwCwPVTjsduyYq5yAYfH6f9dlswr2o0qvM/TMitU+MW/b+FWYxjE5/EEYr5t
         rLEcnTHmrJqfns9fo0C1BGIQJfal+QSXaGfzwI90yvS5HXSoa7S2CPfn79+dsqTlxp3K
         Qq8JkYdo0LSO7/DmmXfQhNL/cSBg5KKytstpXt0fz3Q0KWlcGIGqH/LLCDvlz3XjxKcT
         8bcaolI0mGvh2HKf55e2QQ8pB6GulYHE4ZfVPzkmor34AbOzAwd5FFw/vQxTmTUm3VK3
         2EIw==
X-Gm-Message-State: ACrzQf1iDUM8qsxb80d1QRNOxk6hGUskefzmZTmcd5O58eka1Zz27DsT
        x6gxKtRUabO/eirzZWSknRTtgw==
X-Google-Smtp-Source: AMsMyM6DPO4r131p/AkrnBJsIg/pPdpNgGZzqHysb3GkGzz8lYKLY18dMnHntypNM/af/tAornEd+g==
X-Received: by 2002:a17:90b:3e8d:b0:203:1b6d:2112 with SMTP id rj13-20020a17090b3e8d00b002031b6d2112mr23327438pjb.6.1663964915447;
        Fri, 23 Sep 2022 13:28:35 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g13-20020aa796ad000000b0053ae018a91esm7005618pfk.173.2022.09.23.13.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:28:32 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        dev@openvswitch.org, x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 12/16] devres: Use kmalloc_size_roundup() to match ksize() usage
Date:   Fri, 23 Sep 2022 13:28:18 -0700
Message-Id: <20220923202822.2667581-13-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923202822.2667581-1-keescook@chromium.org>
References: <20220923202822.2667581-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=845; h=from:subject; bh=p9b8wNdLQUTcKVpskeYovP9HfQefiLH6cTy/WYiH/34=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjLhblaNBFxJTohammexHC6CbeJ0+h67dRN4PBtvwk 5JonPTWJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYy4W5QAKCRCJcvTf3G3AJv3zD/ 9LAMXluSBHTtqxb1umMTVE5i5sD3JCHrbpRq7+nm/ihvkEJ1pnKlLOmxomGKq8yeaSA69bZA8KfZSc CR5xfaDsFWx4j9MHisTXdoYIizPEmbqQRRqOxkcdkdBTXGB4/9y7dICzF8nG/wZnRE5cg43nOsJxA/ hh08sM/Jc50zsKD8NK3U423EdCAh5Mur1N+IQdBrcIDvnYzrV9ox60ZBhTx1GxtTQH29f1M7tkTsxb CVJH0I7rS5lLvIDvLckMlcpX75U4M6OfFXPwwIxp8zwb/SpdErJg9OQ0Bc5aPbHKg5h0mzeyjxITo4 Z8ePU5LP/HNZ40tbLl/4YQUWf9RwhgxmPxlaMerypnyhhY7RPOqjaEt4QjEp435c3lkzt/jPKVyQ00 /BWZWjk3oYQBVD1YkNvQadr0W7iugWkFBmy0TMQKbpGlH/9UDUI6ZWX0cskd2A9Vm/9DXzxZlWfb5T 46CEGwe6OTc72/fqVunf113g0JP/k16VF9IW4+cBz7fPkxp8MWBVHYsuByyGXMUPaQPem/RWWPBSdo m2SZX1ZgW/fXrsnRcDrhQ1bd8TrDPmojcGJefLK+ix//dr8fGR/Mmu8QlKJ5P4e96wfEoqQZTf9cys itlMdKLXQRmGqut8owpdZR9a0jlrGiYaoK47SOl258qhzKf6gWj/fY7i/IJw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Round up allocations with kmalloc_size_roundup() so that devres's use
of ksize() is always accurate and no special handling of the memory is
needed by KASAN, UBSAN_BOUNDS, nor FORTIFY_SOURCE.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/base/devres.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 864d0b3f566e..7db20ce7ea8a 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -101,6 +101,9 @@ static bool check_dr_size(size_t size, size_t *tot_size)
 					size, tot_size)))
 		return false;
 
+	/* Actually allocate the full kmalloc bucket size. */
+	*tot_size = kmalloc_size_roundup(*tot_size);
+
 	return true;
 }
 
-- 
2.34.1

