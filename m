Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFFA607ED0
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 21:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiJUTNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 15:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiJUTNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 15:13:47 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5668115A8E2
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:13:45 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id p16so3131855iod.6
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3i+Pa4J8bcK4+v/ZgymWwGim+h5u0D8ub/WCEgMRWbs=;
        b=QQ6cVsALVD1ZESHIkBeya46B5Mdalbmf/0qaiyDp1Az+go8Ycxao0O8cZ/g4Fp5Nud
         Z94Wo+WKnBW2aK5T9TexSRJuG8PXvgwfZLzQeym4Q9kpR3d9KeNuw+FD3XdG0ci7K33U
         RFBK0Zl+UAqrbldAGAYIgH5jP5TI6w25m5iKOmjNFicamnrhLBYbRDPwwdCPqyOL9QDE
         zhA9gWowntH1kYECvtPKHOT7+SGVomqzIKad5D2J+Nc3FNk4QHR1hPR8qq3yDPIAqxRm
         RGHWtfgSlhZfpoN0b2OxQP8kuGNAL/tzzur1nHBIJpEr0ms4PVKSyag2CWDKVgWDW07H
         eEAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3i+Pa4J8bcK4+v/ZgymWwGim+h5u0D8ub/WCEgMRWbs=;
        b=QvtiDSH0bBy/layl1iotLTjrk2KFM2c4dADedYPKlnEyda5yE+JnSGf+q95bdx90fq
         fiQKNC9J252/DkL31PUQjvTafFA2unylcoKivA5+nkzZ/GF19CzjMAeHY0JORdwF+IiQ
         Xg/VMJD66CWN47idqo4tjbHDkG0jDSmaE/BclnE9mV41PQRr66ZKLHiNwzEDX1Ael63d
         9+EFV9j/oPCm9+I+vwpEt3aWYr1wtMSQfmCmSu8TF8mj2y4+7MA2MLRUuf5L4mWoS5TN
         Cnfk9VDvHfo/IrZkhP6jBOPrCW/8/D6Kwrus9XBEpLHa+yWURdcLtK5q058mrFVqc1IQ
         PV9A==
X-Gm-Message-State: ACrzQf2wFllb6rR4a9g0WqWVhF4pBI7ImsNIpVBQ45CnrNtKUF8AsJtI
        dd8GAOLJMcIPA0jJ6hD6JBGyXg==
X-Google-Smtp-Source: AMsMyM6xvJ0iBZmfYAklZzuwVetfYY4s78LgfUYuEf/mPq8EVumDozWszKXGumGw9YLLkjGom8o/Iw==
X-Received: by 2002:a6b:4a01:0:b0:6bc:d4ae:321c with SMTP id w1-20020a6b4a01000000b006bcd4ae321cmr14889741iob.59.1666379624609;
        Fri, 21 Oct 2022 12:13:44 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id e3-20020a022103000000b00363c68aa348sm4439362jaa.72.2022.10.21.12.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 12:13:43 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/7] net: ipa: validation cleanup
Date:   Fri, 21 Oct 2022 14:13:33 -0500
Message-Id: <20221021191340.4187935-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series gathers a set of IPA driver cleanups, mostly involving
code that ensures certain things are known to be correct *early*
(either at build or initializatin time), so they can be assumed good
during normal operation.

The first removes three constant symbols, by making a (reasonable)
assumption that a routing table consists of entries for the modem
followed by entries for the AP, with no unused entries between them.

The second removes two checks that are redundant (they verify the
sizes of two memory regions are in range, which will have been done
earlier for all regions).

The third adds some new checks to routing and filter tables that
can be done at "init time" (without requiring any access to IPA
hardware).

The fourth moves a check that routing and filter table addresses can
be encoded within certain IPA immediate commands, so it's performed
earlier; the checks can be done without touching IPA hardware.  The
fifth moves some other command-related checks earlier, for the same
reason.

The sixth removes the definition ipa_table_valid(), because what it
does has become redundant.  Finally, the last patch moves two more
validation calls so they're done very early in the probe process.
This will be required by some upcoming patches, which will record
the size of the routing and filter tables at this time so they're
available for subsequent initialization.

					-Alex

Alex Elder (7):
  net: ipa: kill two constant symbols
  net: ipa: remove two memory region checks
  net: ipa: validate IPA table memory earlier
  net: ipa: verify table sizes fit in commands early
  net: ipa: introduce ipa_cmd_init()
  net: ipa: kill ipa_table_valid()
  net: ipa: check table memory regions earlier

 drivers/net/ipa/ipa_cmd.c   |  53 ++++--------
 drivers/net/ipa/ipa_cmd.h   |  16 +++-
 drivers/net/ipa/ipa_mem.c   |  14 ++--
 drivers/net/ipa/ipa_table.c | 162 +++++++++++++++++++++---------------
 drivers/net/ipa/ipa_table.h |  15 ++--
 5 files changed, 138 insertions(+), 122 deletions(-)

-- 
2.34.1

