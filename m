Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF4F67BD37
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 21:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235121AbjAYUpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 15:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235490AbjAYUpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 15:45:51 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C7344B3
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 12:45:50 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id p12so9964ilq.10
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 12:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1zR03idrI1Em30e/j9ttKYe63aGanx8QpT+HrIlYYkU=;
        b=mPEj8JixviosqQPj+AtZmx0JqowU+JDJ9G7hDPL7gsGey3N8UsjPFzoWpNh0GcPvcE
         K+WLE5RiutNWJw2pvbuyNjs2ohlBVKfXIs3ySzFakshYBqu8z853x5vu9uLT9997oHfi
         iXsChMDsKW4/dGMAC1hqbfqvoZubp7N40gr57fcPngTjUESSRwOrmvb1060YA7ApnTlC
         3iKwhHIs0/rAp7SSWrSIJeQedXV7+XEYAfOGi4D99oBqsLHNRJKQBHnoBXpj8x0Lphp+
         F/KvoNmHhaVoutJM2CWTHr4cRU8rqSer2GixI4L+INcG9orIrNQDwQ0Vm/fMnLbPmk8G
         CarQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1zR03idrI1Em30e/j9ttKYe63aGanx8QpT+HrIlYYkU=;
        b=KzN1X6VJMh+4kb6SRNwPK0NI7tURLqx9hDVEIaLAOiQEh2oPTjeLbjFLfBuUn+RU8f
         0nfd5P0XONSkUioWIrTKWLr2qnw4rsUYpASla0vP7X3AK1f9LZCQoW6P4QlTM/k9cIk4
         Pt2yFnyNez6pTlOpkP7/f18jlrazCjZFfZRabO3omI47DIi1f6Xifs0i1siNbCgYCX0g
         UeGAmkt+bvvfylp21oZz9BSet1vtF1nQn87OM94zvtYNboXfRXwL4qg2xExEubTGNRfo
         AdI1YxvkT/o2Aay9nMVmUxQS9tMkAUoj8HM0bVX1upqJp8tmDf5zwRzGiGFr15ONsX1R
         C6bg==
X-Gm-Message-State: AO0yUKVTyL7SRx9ZB3EPgxCxHgO9v2jXuJ3XJfQ8u3FRXgM/MrJASa7g
        6XcsT/IZPTCNmNwbNL6cSMq+lA==
X-Google-Smtp-Source: AK7set/pBx1ZI4FsY+J1IqjRpqKvtxCRvR3Kz0BFMwD9VonKp1iSsXu/d7nx+Pi1VR7c15sAkg8IUw==
X-Received: by 2002:a05:6e02:12ca:b0:310:96f0:a404 with SMTP id i10-20020a056e0212ca00b0031096f0a404mr6893380ilm.27.1674679549339;
        Wed, 25 Jan 2023 12:45:49 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id w14-20020a02968e000000b00389c2fe0f9dsm1960696jai.85.2023.01.25.12.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 12:45:48 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/8] net: ipa: abstract status parsing
Date:   Wed, 25 Jan 2023 14:45:37 -0600
Message-Id: <20230125204545.3788155-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under some circumstances, IPA generates a "packet status" structure
that describes information about a packet.  This is used, for
example, when offload hardware detects an error in a packet, or
otherwise discovers a packet needs special handling.  In this case,
the status is delivered (along with the packet it describes) to a
"default" endpoint so that it can be handled by the AP.

Until now, the structure of this status information hasn't changed.
However, to support more than 32 endpoints, this structure required
some changes, such that some fields are rearranged in ways that are
tricky to represent using C code.

This series updates code related to the IPA status structure.  The
first patch uses a local variable to avoid recomputing a packet
length more than once.  The second stops using sizeof() to determine
the size of an IPA packet status structure.  Patches 3-5 extend the
definitions for values held in packet status fields.  Patch 6 does a
little general cleanup to make patch 7 simpler.  Patch 7 stops using
a C structure to represent packet status; instead, a new function
fetches values "by name" from a buffer containing such a structure.
The last patch updates this function so it also supports IPA v5.0+.

					-Alex

Alex Elder (8):
  net: ipa: refactor status buffer parsing
  net: ipa: stop using sizeof(status)
  net: ipa: define all IPA status mask bits
  net: ipa: rename the NAT enumerated type
  net: ipa: define remaining IPA status field values
  net: ipa: IPA status preparatory cleanups
  net: ipa: introduce generalized status decoder
  net: ipa: add IPA v5.0 packet status support

 drivers/net/ipa/ipa_endpoint.c | 280 +++++++++++++++++++++++++--------
 drivers/net/ipa/ipa_reg.h      |  10 +-
 2 files changed, 217 insertions(+), 73 deletions(-)

-- 
2.34.1

