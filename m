Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74CBD5E5950
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 05:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiIVDMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 23:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiIVDLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 23:11:36 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE0790828
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 20:10:28 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t190so7844428pgd.9
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 20:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=KtJQxM97YBw1ybtvuETSvn7dCGYbbNyL/TMT/+SzmmU=;
        b=FXq499jerICaOIudNJl9X9HvncqoZ26Rey2ZEcTHwfOsxqpZ88m1AcMNvabITl7ktf
         otabATcFdrn9uUfQaBz54ORv9CLq2BALyhNuHATyi853KWeUJJODBiaOX2We8TBvbr3R
         089SGfE8g5vUSB25WVvFLrng0+Ij1LNA8tvzE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=KtJQxM97YBw1ybtvuETSvn7dCGYbbNyL/TMT/+SzmmU=;
        b=gHH4HrkFzwjvZOJJ7nxAdE8cEdFdlX60bk16hQNFIb2KgZvL9DKAgPvWNH+C/rk61T
         THEi+kAeUmtLF9iTZUOnR33IZyvEMX+9Y5QoJgkcDytKqxFSy/Rn9urcf/q2Ko/1Vp4V
         87eGzq25GzpBC3dTjQaAuBm8ylgKHNDVt+ro4LdVUJAO7SZKvkx+1ArffoUne73CNcRr
         vW9g0HDV89QTktCLhZY/tLyILLoNyCij+vrddqb7j/wcr5tfS2P3oASBd8aDRaV5GYPe
         owxvrga5ySeG4+B3tqaEjGxXFTp3kH6FpqfnqBbQABqEPh3Wv0KeSJhNLELpFxk9KFmM
         gz2g==
X-Gm-Message-State: ACrzQf1KyEwu5hlOmNWbeTZUvgE67DvOE8Zo1ziUXDPgG0VKpVqO932v
        4awr9vwIZjZK2wVBNECJEdiwvg==
X-Google-Smtp-Source: AMsMyM5DFDxK0WCMKFDuZxvtbntvdP6o5W4EoaVjl4WwV6+EDjakr1hsYDIL2vLeT0yZPL8CvbXBgA==
X-Received: by 2002:a05:6a00:174f:b0:537:6845:8b1a with SMTP id j15-20020a056a00174f00b0053768458b1amr1476359pfc.68.1663816227626;
        Wed, 21 Sep 2022 20:10:27 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090a9b8200b002001c9bf22esm2650047pjp.8.2022.09.21.20.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 20:10:26 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        dev@openvswitch.org, x86@kernel.org,
        linux-wireless@vger.kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: [PATCH 07/12] igb: Proactively round up to kmalloc bucket size
Date:   Wed, 21 Sep 2022 20:10:08 -0700
Message-Id: <20220922031013.2150682-8-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922031013.2150682-1-keescook@chromium.org>
References: <20220922031013.2150682-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1355; h=from:subject; bh=GnGo60Q8Ey4t/45rZVkHHXQYJiJECnGYVFTtoXWQ73Y=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjK9ITjdxbzH7GftOj5prz+63FJ1nPbhwlH4IVeCtD 8ED2tMyJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYyvSEwAKCRCJcvTf3G3AJjCiD/ wMJri5QLOOqouOEh6gNHJttRS42p0Og0uXHFXBpfBrQHVdMA/pZ7vM6aplEkCSzfpBRS9ns48N68wS jcAXVJGdtoRra0fSdkwT4D/eNkhKa/DLtxD0AIjix8HXBLfF0xblfFujjMTn2AcNU0TIoJNpYb7VgX k5ga7gxgqR6sqMlNaFb5qthk1BfSfBFjP5XdVSZtQjZHuc1xAXbYyBzlTYP5PHfAzBhZdVwZxDKAoh HLy++A+AphN0n4DVADlQ2Pn0+VZTZBXDRRAYBIKxn4mFfjNlexbTZx9K9vi+BB/QWW7WFQR851SPy2 H0AIW6jGUmqOlFp42ZjG32ra+NQrzMdB3SHS0UCKvWrHcgGOij3jZloSaDZ9TqEk86JUA2eNTV8EsO H2dRnVfemfa8X8YeGg5PS19OLC7pnOJYipxZfBdX5FrqP2SnHC2IqAqpLlOfeapo5yjFQdZZY/QeMW aYDixd+87XW69dT3Y8AMCAHA74UZNFOpQ96K/S/nwAMoGRQVUKRicu3fOrBwssRCIoAd24pldFMqg3 1lPT3qVVTF1IPhnR4vQ3RQJihuPUWjOP3S+3lH2U15ueKvZmGmjl7MCHI2RUE87+c+TqOb87PwG6fW eepaAJi+LmbVjbB1PG3ptYHjsDDSkTgUtQRqZ0fL/ZAxrsHf91M5rKLsQBig==
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

Instead of having a mismatch between the requested allocation size and
the actual kmalloc bucket size, which is examined later via ksize(),
round up proactively so the allocation is explicitly made for the full
size, allowing the compiler to correctly reason about the resulting size
of the buffer through the existing __alloc_size() hint.

Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 2796e81d2726..4d70ee5b0f79 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -1196,6 +1196,7 @@ static int igb_alloc_q_vector(struct igb_adapter *adapter,
 
 	ring_count = txr_count + rxr_count;
 	size = struct_size(q_vector, ring, ring_count);
+	size = kmalloc_size_roundup(size);
 
 	/* allocate q_vector and rings */
 	q_vector = adapter->q_vector[v_idx];
-- 
2.34.1

