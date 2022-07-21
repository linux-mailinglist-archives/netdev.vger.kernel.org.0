Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD81B57C193
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 02:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiGUA23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 20:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiGUA22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 20:28:28 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164BB5A88B;
        Wed, 20 Jul 2022 17:28:24 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 72so210133pge.0;
        Wed, 20 Jul 2022 17:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=jH9h10qQPmqy9XaSFPaWtgsJKQU/Fb0xm7oNpd+XnLI=;
        b=cFUO37NjH/fDK5op+fHw7DyAEcDcKJzyphiPTIre5PkNvyL+5KIw2a6QG7gys43+rq
         X6wu9p+FYkIl+cF1YLqmZI8Ux+5bd5idCFxlp1Gm3Z4WjsOM8RQmzKaman6wvixnfErC
         JU9tMmHV34EBlhRlpCCBPqPAh8ok6jcTxbtrOZGeMMt+GdP6gN0g9hthzft0J6Crpi1h
         IF9LQ4L0Fg+gNyCZr51O73tv1k9ZnNdPB1TK0ocZAO9aTW9OqldAn717UFdfFHagua4E
         CFfqUFDOr9h981S1jcTba5XG/wOf9Nj2FIXnAZzTJ2/+G1+5Tf+2ISX4tjxdKrAFESyV
         df8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jH9h10qQPmqy9XaSFPaWtgsJKQU/Fb0xm7oNpd+XnLI=;
        b=AjuNoXACiCjGekUfUhr+r369YevsTb3MtHGsmeGFaQXTaAweekxD70aB5W5eestwgx
         N1TXX6qyXBzm+RK8+XPa4H1k57UsjviEJnrpH+SvOExFOIe/Us47QQN5DecY0F/rIS1w
         Ey3dxuqG8n6WvFPjUEQVZ11Sq7MmjeEDLTnhJIWhxTkQ5VdgS8See/lIVuhUX9mK1K/5
         OtHCg/BYQHMhBBiYV6Zr0497UlxT0E7cHAPl4ixpSQ/rcNVj5/I2DT8OtpvDU0hcj8Ld
         l8hko1ENffg8/O0odxT+4TcJOLrr4m02cLy+/NXZdMIJCH2xymuQwBF8xYYTaGMQFmnr
         eRcg==
X-Gm-Message-State: AJIora/9slOhuFL7Bx9KiFsHiFXd0aJrxskU1f9uDoZ+Qddwgo106Wui
        J5BGMwPJxc7qNUYbbAmqoUE=
X-Google-Smtp-Source: AGRyM1ukWh5ihjPMbEXvPa9Q6FMOYa+DWD1lmp51UkwycijxpOMA2+dVCW0oMM/4A5gfiq+dKylfMA==
X-Received: by 2002:a65:6c03:0:b0:412:ac5a:bcab with SMTP id y3-20020a656c03000000b00412ac5abcabmr36088141pgu.7.1658363303175;
        Wed, 20 Jul 2022 17:28:23 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902db0500b0016bc4a6ce28sm163226plx.98.2022.07.20.17.28.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Jul 2022 17:28:22 -0700 (PDT)
From:   justinpopo6@gmail.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, joalonsof@gmail.com, jesionowskigreg@gmail.com,
        jackychou@asix.com.tw, jannh@google.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     f.fainelli@gmail.com, justin.chen@broadcom.com,
        Justin Chen <justinpopo6@gmail.com>
Subject: [PATCH v2 0/5] net: usb: ax88179_178a: improvements and bug fixes
Date:   Wed, 20 Jul 2022 17:28:11 -0700
Message-Id: <1658363296-15734-1-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Justin Chen <justinpopo6@gmail.com>

v2
	Remove unused variables
	Remove unnecessary memset

Power management was partially broken. There were two issues when dropping
into a sleep state.
1. Resume was not doing a fully HW restore. Only a partial restore. This
lead to a couple things being broken on resume. One of them being tcp rx.
2. wolopt was not being restored properly on resume.

Also did some general improvements and clean up to make it easier to fix
the issues mentioned above.

Justin Chen (5):
  net: usb: ax88179_178a: remove redundant init code
  net: usb: ax88179_178a: clean up pm calls
  net: usb: ax88179_178a: restore state on resume
  net: usb: ax88179_178a: move priv to driver_priv
  net: usb: ax88179_178a: wol optimizations

 drivers/net/usb/ax88179_178a.c | 319 +++++++++++++----------------------------
 1 file changed, 99 insertions(+), 220 deletions(-)

-- 
2.7.4

