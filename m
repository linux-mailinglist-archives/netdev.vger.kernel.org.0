Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 234ED238ED
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 15:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731841AbfETNyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 09:54:01 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33957 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728619AbfETNyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 09:54:01 -0400
Received: by mail-io1-f68.google.com with SMTP id g84so11097050ioa.1
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 06:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PNcQkl0sbDGXxnYuX4gXEpMWKK3coY11enMS7zPLh3A=;
        b=R5wW8lMc1iy8WX5sYIP1b1h0H4/nA/j52JRPwd4H4/d96WL7tLLiJArjqoRqRX9OPB
         FSg6TjfoAJXORsyizA3JhqGza/b2CTsNAAcuwuVQFl4C4mhXyIEo3mVGb8ZkEIVUNVDh
         L40iihL4Q3zEayB7IeYK6/ANJogh5XRzFdpYCWnBjn30ZDh/PMc1opt203xC/d2kr+Xg
         +hJKwYigYLilykiT/0P2KR03lJ0mR2+W3r/w/VuUYu39KYpJ5BvxsicRHefYns1DleK/
         FDLseKCMrYlnYZTVbqG+qY/WnjOAa1e9JgUfjK8safuRTCLVD0JF1XGvZsQ/xfYomin2
         yiEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PNcQkl0sbDGXxnYuX4gXEpMWKK3coY11enMS7zPLh3A=;
        b=LJL1lgkPoDnvyEil10wckJfOyCJ+hklSfwc3ex736+We1/2Ho3oGGnuVEhD57Xiylm
         Ptt4NtDdefvxkfG6BFGC8O4LOfU3jmaRnq0GQ4Ug76Uc013AwpBucTGZFWpUq3fue4SG
         K9bYfzIkCnvJ7Cpvk5X+2kLahAzCo6S1BM7L2Uub6dfWVLtVipoZF6syTyyGSasxxtVv
         Q0ldbc2AAKmhVx3MPOtgC5eTUmkEMGhmyKYA6LBRKplIypPurK0Iv8kqYAYVmpzTChLD
         6rFmPUm1lFVPxy5WOjDlIkdHB5vyuK81w8uGdUc+mWavY/2baP706g9mHd5OIdR8T6eo
         XM4A==
X-Gm-Message-State: APjAAAUdkSyDUUWMe9LkEDrjSI0OHLbpNdySwh0HQ+zrw8oQHZL10pMW
        3skUZT3ZEj4Umpk9F7oVk84Eug==
X-Google-Smtp-Source: APXvYqynHsjMtF9qAVZpY1JsVPL2bqipIldd2eim0mxY31JSO0vulzprtm9VZoDN7/PUuSG67E/g/g==
X-Received: by 2002:a5d:9d07:: with SMTP id j7mr24786480ioj.39.1558360440641;
        Mon, 20 May 2019 06:54:00 -0700 (PDT)
Received: from localhost.localdomain (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.gmail.com with ESMTPSA id n17sm6581185ioa.0.2019.05.20.06.53.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 06:53:59 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     arnd@arndb.de, subashab@codeaurora.org, david.brown@linaro.org,
        agross@kernel.org, davem@davemloft.net
Cc:     bjorn.andersson@linaro.org, ilias.apalodimas@linaro.org,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] net: introduce "include/linux/if_rmnet.h"
Date:   Mon, 20 May 2019 08:53:46 -0500
Message-Id: <20190520135354.18628-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main objective of this series was originally to define a single
public header file containing a few structure definitions that are
currently defined privately for the Qualcomm "rmnet" driver.  In
review, Arnd Bergmann said that before making them public, the
structures should avoid using C bit-fields in their definitions.

To facilitate implementing that suggestion I rearranged some other
code, including eliminating some accessor macros that I believe
reduce rather than improve the clarity of the code that uses them.

I also discovered a bug (concievably due to non-portable behavior)
in the way one of the structures is defined, so I fixed that.  And
finally I ensured all of the fields in these structures were defined
with proper annotation of their big endianness.

A form of the code in this series was present in this patch:
  https://lore.kernel.org/lkml/20190512012508.10608-3-elder@linaro.org/
This series is available here, based on kernel v5.2-rc1:
  remote: https://git.linaro.org/people/elder/linux.git
  branch: ipa-rmnet-v1_kernel-5.2-rc1
    acbcb18302a net: introduce "include/linux/if_rmnet.h"

					-Alex

Alex Elder (8):
  net: qualcomm: rmnet: fix struct rmnet_map_header
  net: qualcomm: rmnet: kill RMNET_MAP_GET_*() accessor macros
  net: qualcomm: rmnet: use field masks instead of C bit-fields
  net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum header
  net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum trailer
  net: qualcomm: rmnet: get rid of a variable in
    rmnet_map_ipv4_ul_csum_header()
  net: qualcomm: rmnet: mark endianness of struct
    rmnet_map_dl_csum_trailer fields
  net: introduce "include/linux/if_rmnet.h"

 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  | 11 ++--
 .../net/ethernet/qualcomm/rmnet/rmnet_map.h   | 36 ----------
 .../qualcomm/rmnet/rmnet_map_command.c        | 12 +++-
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 65 +++++++++----------
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |  1 +
 include/linux/if_rmnet.h                      | 45 +++++++++++++
 6 files changed, 91 insertions(+), 79 deletions(-)
 create mode 100644 include/linux/if_rmnet.h

-- 
2.20.1

