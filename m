Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF04562A80
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 06:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbiGAE3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 00:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiGAE3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 00:29:00 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8373D58FDD;
        Thu, 30 Jun 2022 21:28:58 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id cf14so1420450edb.8;
        Thu, 30 Jun 2022 21:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0O4/oNbZ3YRoOmSuse2orABsjwO93HDgN0c9nygzXkg=;
        b=fx0uLrcSQjZTXvB8Hu09bD0L2czFcKCI1dhTczw2jK//jpIFIOw9zrjIG4Ekl3fDyg
         tsL8YBSJEeTLOHoKvqu6m5E9DdNlfBVoib6TBMnFAuEkdc0ENq0Ck0NCfnRxRx9gcO+1
         JIikryE5KvK84hE00FXdGwLWDJnGlYaLICN4vG/07bBvYxRtLZyd25f66gXGxII9SsT/
         tPNEW6OaaL/Uf+g90g1mikLHkU/VrZWyynVW3ixRiqJHU+rHkNJudhFH5/f+R98yWVFx
         5uKDF7R4AiXRhjZUajMN47RNbeXi1tmNgV1d6/2ym28LeZU9IUm11P61VEfKzbTLhCoo
         XfAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0O4/oNbZ3YRoOmSuse2orABsjwO93HDgN0c9nygzXkg=;
        b=luBelySV2JtcU3G2lnCzkwozJkZhdgsOvZ+Sb660zSroeTahSSdmbbNRQLFJTlus70
         0MhEd8pWWhRBRg01eTeoctNkVL6JmW9giJtqRF+IbiisG7zDQs4boqlPUBrfY32MmbF5
         2zAghRcgnDbMG+ZrYIEWK/BR1DcjqD0NoubWV0IQ8rs+R0Jx88CA0lSJ7OqGm/pphow7
         OMvz6nqdxiaaW54nbwpXbu3GlMPCGY0a/sV1FLILx2kj2Sq1pFmD8OBhpjv2A+nLxOQO
         Ihgep8Vo2pwywkd9sIdlZ8ZCEVlDfKotuHwEeIsbMgpNmnG+s+jlySuxmyKKP/pSR+N+
         QuJQ==
X-Gm-Message-State: AJIora+VmHBZS+wf9xJVotik/KtK/FXRuAKprCBolhmvjhoepXo4SkmF
        vTSq+UVQHgn4yXuea66jSaw=
X-Google-Smtp-Source: AGRyM1veiW2EfEXKBX9p8FXLTR5ucjbaZny9cnQElotgkUzW71FChR9E1mXGinabKbKZoVmPsdt4gA==
X-Received: by 2002:a05:6402:524d:b0:437:8d2e:c675 with SMTP id t13-20020a056402524d00b004378d2ec675mr16771826edd.65.1656649737098;
        Thu, 30 Jun 2022 21:28:57 -0700 (PDT)
Received: from felia.fritz.box (200116b826fa4e008c7f8ad93cf12391.dip.versatel-1u1.de. [2001:16b8:26fa:4e00:8c7f:8ad9:3cf1:2391])
        by smtp.gmail.com with ESMTPSA id b27-20020a17090630db00b0072a72b0fe72sm1130850ejb.111.2022.06.30.21.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 21:28:56 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: adjust XDP SOCKETS after file movement
Date:   Fri,  1 Jul 2022 06:28:10 +0200
Message-Id: <20220701042810.26362-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit f36600634282 ("libbpf: move xsk.{c,h} into selftests/bpf") moves
files tools/{lib => testing/selftests}/bpf/xsk.[ch], but misses to adjust
the XDP SOCKETS (AF_XDP) section in MAINTAINERS.

Adjust the file entry after this file movement.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
Andrii, please ack.

Alexei, please pick this minor non-urgent clean-up on top of the commit above.

 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fa4bfa3d10bf..27d9e65b9a85 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22042,7 +22042,7 @@ F:	include/uapi/linux/xdp_diag.h
 F:	include/net/netns/xdp.h
 F:	net/xdp/
 F:	samples/bpf/xdpsock*
-F:	tools/lib/bpf/xsk*
+F:	tools/testing/selftests/bpf/xsk*
 
 XEN BLOCK SUBSYSTEM
 M:	Roger Pau Monné <roger.pau@citrix.com>
-- 
2.17.1

