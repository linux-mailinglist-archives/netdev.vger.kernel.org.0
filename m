Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0954539B5C
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 04:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348381AbiFACsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 22:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344480AbiFACse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 22:48:34 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549594550C
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 19:48:34 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id n10so677645pjh.5
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 19:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/S9mCeWkKYvoHJn4pkUREJMV0rsn/YGdEfXy2hh1hh8=;
        b=iTkHqxb1TuNjCzKzQF1dGL2CXh+tHhHGGS2J/mdCBZuzkOuMUnXw/PCpuQBlaQt+xR
         jHD/XTlQ/AMld60WtwG5gkY0f7eheby92Ub6aNGZMCvW++tP4F2JKxOO9Q3J6LUHT3PA
         2POYnAzW/nIwq+nUiujdDBOQRuIaSDOXJlp/ncdZh3FeQgZ8ZO4ZmQVhJ8hJZXrEEydf
         WTWbNdKBQWEqUeHdoja1RIJfk2PkBa9PWGNvnXxdyLhZWE2hTSoxZNNCKjzOs/L/FP5/
         wv7A+K898SLnkGUGsTvAoFasRKNmAxRerAtipN+6ZlspWikahuuisO5iRnT77Uq+C5F1
         YrlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/S9mCeWkKYvoHJn4pkUREJMV0rsn/YGdEfXy2hh1hh8=;
        b=wNr9wvq3g32tcC2bvCStNwyIxC6b2u9DrOT2XMA8pFW5jHXJe0+ns5jZ7d/RqQKNW/
         gQBky/TfJ9Fr7y7+OMP1al+zo2HXdJFxU2vo7PHs6oahDW8+6fEuzKosuaNRgJ3tCM5r
         1GA6PixGjqjNIPrNDoFl9bWmVRzaQbwYjCdGJFnmfaveqK/BQZLwgkQdb8UsaCZ3Bp3M
         upxhkd1iknPzrYl+j89KAlSlVGdDCmEcwHvcYzBJXF9cejGLtvgY9tuB/jUnJ7/8tAHD
         d2UoQSGaTdYw42KnZnxb2RvPmyzMI4tZbTOijGUFyIqq5/M+wA9Y/eDAzpTeRRm9mwaY
         xLkg==
X-Gm-Message-State: AOAM5309YtAOG8mQfFx6M0RoFblutpeLG8abmhc+k/pgPhKGOSOoaWcY
        dzsraWulBgtqSXsOrBXl9LVU6AXD49tlTQ==
X-Google-Smtp-Source: ABdhPJyLuQGIlP7oh8jXFgq0hE2ijhCR1RgbnnpJDATjrv+5O4yO4/rtn7lPPRNsGAo+aSk0FHi52w==
X-Received: by 2002:a17:902:e748:b0:164:1b1e:28fe with SMTP id p8-20020a170902e74800b001641b1e28femr2900327plf.116.1654051713326;
        Tue, 31 May 2022 19:48:33 -0700 (PDT)
Received: from localhost ([2601:648:8700:396:e6b9:7aff:fe68:bbf4])
        by smtp.gmail.com with ESMTPSA id 19-20020a170902e9d300b00163f5028fd6sm246588plk.5.2022.05.31.19.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 19:48:32 -0700 (PDT)
From:   Frederik Deweerdt <frederik.deweerdt@gmail.com>
To:     netdev@vger.kernel.org
Cc:     willemb@google.com, Frederik Deweerdt <frederik.deweerdt@gmail.com>
Subject: [PATCH] [doc] msg_zerocopy.rst: clarify the TCP shutdown scenario
Date:   Tue, 31 May 2022 19:47:45 -0700
Message-Id: <20220601024744.626323-1-frederik.deweerdt@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
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

Hi folks,

Based on my understanding, retransmissions of zero copied buffers can
happen after `close(2)`, the patch below amends the docs to suggest how
notifications should be handled in that case.

Explicitly mention that applications shouldn't be calling `close(2)` on
a TCP socket without draining the error queue.
---
 Documentation/networking/msg_zerocopy.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/networking/msg_zerocopy.rst b/Documentation/networking/msg_zerocopy.rst
index 15920db8d35d..cb44fc1f3e3e 100644
--- a/Documentation/networking/msg_zerocopy.rst
+++ b/Documentation/networking/msg_zerocopy.rst
@@ -144,6 +144,10 @@ the socket. A socket that has an error queued would normally block
 other operations until the error is read. Zerocopy notifications have
 a zero error code, however, to not block send and recv calls.
 
+For protocols like TCP, where retransmissions can occur after the
+application is done with a given connection, applications should signal
+the close to the peer via shutdown(2), and keep polling the error queue
+until all transmissions have completed.
 
 Notification Batching
 ~~~~~~~~~~~~~~~~~~~~~
-- 
2.36.1

