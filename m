Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D972827941D
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 00:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbgIYWZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 18:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbgIYWZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 18:25:06 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03004C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 15:25:06 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id jw11so218818pjb.0
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 15:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VgiYgUxlXJtG+iD/70X03s3JdHIJv/flBnjn7+P4yJs=;
        b=TkWGCXBkIcD8zsnlNVRCyLPUkQkw+WpAv1xQFxImUmqLmIaQBfmmcIFq7TSSQ0cwYH
         6Qb80MW7btTF5d8u8ml6J61KDOqdqL8V9ih2o10gOAt7J14ci/0tE1K91DSoms1HlYSp
         PDC+CtRLpVpJ6qZiAxlxqMsJEQIaEHNV4JnLLGOhuNkFVgZJC35v6lxfDuXqPKDN8H8q
         XSEv1M/F1pjqiU5Om2ddEmhv4zfnIryGRcjP9n9fkZO97KeI7jl2OMN60CCvcGnakcUZ
         nOLzUWV21sOvC1xBgL6fZcv9Lsbpc6GSzeNsL3CbHCHGdy99JqbH2NgPdRUCt4HmL6SO
         qhkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VgiYgUxlXJtG+iD/70X03s3JdHIJv/flBnjn7+P4yJs=;
        b=OS7eFLG7y/p2L5AuRwsBdmyE7sLRzEhHTi3yqk9+4yuR8YjlcQhY4vCCfqT71eHr8e
         W+dUf/AVBj489VubM3s7Zwww9Mx5AV0bkfXFFHzsIVIQkPuLvO8kvyybvHtlkMhaTZRR
         buBoy8vgnDWba3iH7+BpHI59Cz48FUSVLvHjQ+nIUO11I3Oak8d8ckqd2IUgMs+TJ1w2
         y4ExUFgY2FnL612flBNRBeotIiwiCs1e+HwUU9Vpl66orm0cjK7gL1RWwLNdJymiAp6m
         ysobVzt+RK25Sto/fSj48KOUl3bU32wwWv/m7WllcwnWkUD2q37H3ocNPofn1ohxoX4Y
         p2DA==
X-Gm-Message-State: AOAM532e6NWeHMHlq4TgloCM/8tlxgUNQa55PKaYlJrWCtHGJjtikHdd
        b9iR99+4pyMoDFhRDUgSb5FJmsOgU3b3Njvq
X-Google-Smtp-Source: ABdhPJy+fhy7sVCarcbS6Qtnyv81+n4EXatbG9GHAK2Bnp7ybMZ/wkRebZBt2UDxZx1n1wPNw3qzPA==
X-Received: by 2002:a17:90a:a014:: with SMTP id q20mr624360pjp.77.1601072704120;
        Fri, 25 Sep 2020 15:25:04 -0700 (PDT)
Received: from jesse-ThinkPad-T570.lan (50-39-107-76.bvtn.or.frontiernet.net. [50.39.107.76])
        by smtp.gmail.com with ESMTPSA id q15sm169343pje.29.2020.09.25.15.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 15:25:03 -0700 (PDT)
From:   Jesse Brandeburg <jesse.brandeburg@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@gmail.com>,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net-next v3 5/9] drivers/net/ethernet: handle one warning explicitly
Date:   Fri, 25 Sep 2020 15:24:41 -0700
Message-Id: <20200925222445.74531-6-jesse.brandeburg@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925222445.74531-1-jesse.brandeburg@gmail.com>
References: <20200925222445.74531-1-jesse.brandeburg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

While fixing the W=1 builds, this warning came up because the
developers used a very tricky way to get structures initialized
to a non-zero value, but this causes GCC to warn about an
override. In this case the override was intentional, so just
disable the warning for this code with a kernel macro that results
in disabling the warning for compiles on GCC versions after 8.

It is not appropriate to change the struct to initialize all the
values as it will just add a lot more code for no value. The code
is completely correct as is, we just want to acknowledge that
this code could generate a warning and we're ok with that.

NOTE: the __diag_ignore macro currently only accepts a second
argument of 8 (version 80000), it's either use this one or
open code the pragma.

Fixed Warnings example (all the same):
drivers/net/ethernet/renesas/sh_eth.c:51:12: warning: initialized field overwritten [-Woverride-init]
drivers/net/ethernet/renesas/sh_eth.c:52:12: warning: initialized field overwritten [-Woverride-init]
drivers/net/ethernet/renesas/sh_eth.c:53:13: warning: initialized field overwritten [-Woverride-init]
+ 256 more...

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
v3: change to __diag_* macros, add warning detail
v2: first non-RFC version

Full list of warnings:
======================
drivers/net/ethernet/renesas/sh_eth.c:51:12: warning: initialized field overwritten [-Woverride-init]
   51 |  [EDSR]  = 0x0000,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:51:12: note: (near initialization for ‘sh_eth_offset_gigabit[0]’)
drivers/net/ethernet/renesas/sh_eth.c:52:12: warning: initialized field overwritten [-Woverride-init]
   52 |  [EDMR]  = 0x0400,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:52:12: note: (near initialization for ‘sh_eth_offset_gigabit[1]’)
drivers/net/ethernet/renesas/sh_eth.c:53:13: warning: initialized field overwritten [-Woverride-init]
   53 |  [EDTRR]  = 0x0408,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:53:13: note: (near initialization for ‘sh_eth_offset_gigabit[2]’)
drivers/net/ethernet/renesas/sh_eth.c:54:13: warning: initialized field overwritten [-Woverride-init]
   54 |  [EDRRR]  = 0x0410,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:54:13: note: (near initialization for ‘sh_eth_offset_gigabit[3]’)
drivers/net/ethernet/renesas/sh_eth.c:55:12: warning: initialized field overwritten [-Woverride-init]
   55 |  [EESR]  = 0x0428,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:55:12: note: (near initialization for ‘sh_eth_offset_gigabit[4]’)
drivers/net/ethernet/renesas/sh_eth.c:56:13: warning: initialized field overwritten [-Woverride-init]
   56 |  [EESIPR] = 0x0430,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:56:13: note: (near initialization for ‘sh_eth_offset_gigabit[5]’)
drivers/net/ethernet/renesas/sh_eth.c:57:13: warning: initialized field overwritten [-Woverride-init]
   57 |  [TDLAR]  = 0x0010,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:57:13: note: (near initialization for ‘sh_eth_offset_gigabit[6]’)
drivers/net/ethernet/renesas/sh_eth.c:58:13: warning: initialized field overwritten [-Woverride-init]
   58 |  [TDFAR]  = 0x0014,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:58:13: note: (near initialization for ‘sh_eth_offset_gigabit[7]’)
drivers/net/ethernet/renesas/sh_eth.c:59:13: warning: initialized field overwritten [-Woverride-init]
   59 |  [TDFXR]  = 0x0018,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:59:13: note: (near initialization for ‘sh_eth_offset_gigabit[8]’)
drivers/net/ethernet/renesas/sh_eth.c:60:13: warning: initialized field overwritten [-Woverride-init]
   60 |  [TDFFR]  = 0x001c,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:60:13: note: (near initialization for ‘sh_eth_offset_gigabit[9]’)
drivers/net/ethernet/renesas/sh_eth.c:61:13: warning: initialized field overwritten [-Woverride-init]
   61 |  [RDLAR]  = 0x0030,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:61:13: note: (near initialization for ‘sh_eth_offset_gigabit[10]’)
drivers/net/ethernet/renesas/sh_eth.c:62:13: warning: initialized field overwritten [-Woverride-init]
   62 |  [RDFAR]  = 0x0034,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:62:13: note: (near initialization for ‘sh_eth_offset_gigabit[11]’)
drivers/net/ethernet/renesas/sh_eth.c:63:13: warning: initialized field overwritten [-Woverride-init]
   63 |  [RDFXR]  = 0x0038,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:63:13: note: (near initialization for ‘sh_eth_offset_gigabit[12]’)
drivers/net/ethernet/renesas/sh_eth.c:64:13: warning: initialized field overwritten [-Woverride-init]
   64 |  [RDFFR]  = 0x003c,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:64:13: note: (near initialization for ‘sh_eth_offset_gigabit[13]’)
drivers/net/ethernet/renesas/sh_eth.c:65:13: warning: initialized field overwritten [-Woverride-init]
   65 |  [TRSCER] = 0x0438,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:65:13: note: (near initialization for ‘sh_eth_offset_gigabit[14]’)
drivers/net/ethernet/renesas/sh_eth.c:66:13: warning: initialized field overwritten [-Woverride-init]
   66 |  [RMFCR]  = 0x0440,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:66:13: note: (near initialization for ‘sh_eth_offset_gigabit[15]’)
drivers/net/ethernet/renesas/sh_eth.c:67:12: warning: initialized field overwritten [-Woverride-init]
   67 |  [TFTR]  = 0x0448,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:67:12: note: (near initialization for ‘sh_eth_offset_gigabit[16]’)
drivers/net/ethernet/renesas/sh_eth.c:68:11: warning: initialized field overwritten [-Woverride-init]
   68 |  [FDR]  = 0x0450,
      |           ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:68:11: note: (near initialization for ‘sh_eth_offset_gigabit[17]’)
drivers/net/ethernet/renesas/sh_eth.c:69:12: warning: initialized field overwritten [-Woverride-init]
   69 |  [RMCR]  = 0x0458,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:69:12: note: (near initialization for ‘sh_eth_offset_gigabit[18]’)
drivers/net/ethernet/renesas/sh_eth.c:70:13: warning: initialized field overwritten [-Woverride-init]
   70 |  [RPADIR] = 0x0460,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:70:13: note: (near initialization for ‘sh_eth_offset_gigabit[24]’)
drivers/net/ethernet/renesas/sh_eth.c:71:13: warning: initialized field overwritten [-Woverride-init]
   71 |  [FCFTR]  = 0x0468,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:71:13: note: (near initialization for ‘sh_eth_offset_gigabit[23]’)
drivers/net/ethernet/renesas/sh_eth.c:72:12: warning: initialized field overwritten [-Woverride-init]
   72 |  [CSMR]  = 0x04E4,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:72:12: note: (near initialization for ‘sh_eth_offset_gigabit[63]’)
drivers/net/ethernet/renesas/sh_eth.c:74:12: warning: initialized field overwritten [-Woverride-init]
   74 |  [ECMR]  = 0x0500,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:74:12: note: (near initialization for ‘sh_eth_offset_gigabit[28]’)
drivers/net/ethernet/renesas/sh_eth.c:75:12: warning: initialized field overwritten [-Woverride-init]
   75 |  [ECSR]  = 0x0510,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:75:12: note: (near initialization for ‘sh_eth_offset_gigabit[29]’)
drivers/net/ethernet/renesas/sh_eth.c:76:13: warning: initialized field overwritten [-Woverride-init]
   76 |  [ECSIPR] = 0x0518,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:76:13: note: (near initialization for ‘sh_eth_offset_gigabit[30]’)
drivers/net/ethernet/renesas/sh_eth.c:77:11: warning: initialized field overwritten [-Woverride-init]
   77 |  [PIR]  = 0x0520,
      |           ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:77:11: note: (near initialization for ‘sh_eth_offset_gigabit[31]’)
drivers/net/ethernet/renesas/sh_eth.c:78:11: warning: initialized field overwritten [-Woverride-init]
   78 |  [PSR]  = 0x0528,
      |           ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:78:11: note: (near initialization for ‘sh_eth_offset_gigabit[32]’)
drivers/net/ethernet/renesas/sh_eth.c:79:12: warning: initialized field overwritten [-Woverride-init]
   79 |  [PIPR]  = 0x052c,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:79:12: note: (near initialization for ‘sh_eth_offset_gigabit[34]’)
drivers/net/ethernet/renesas/sh_eth.c:80:12: warning: initialized field overwritten [-Woverride-init]
   80 |  [RFLR]  = 0x0508,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:80:12: note: (near initialization for ‘sh_eth_offset_gigabit[35]’)
drivers/net/ethernet/renesas/sh_eth.c:81:11: warning: initialized field overwritten [-Woverride-init]
   81 |  [APR]  = 0x0554,
      |           ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:81:11: note: (near initialization for ‘sh_eth_offset_gigabit[37]’)
drivers/net/ethernet/renesas/sh_eth.c:82:11: warning: initialized field overwritten [-Woverride-init]
   82 |  [MPR]  = 0x0558,
      |           ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:82:11: note: (near initialization for ‘sh_eth_offset_gigabit[38]’)
drivers/net/ethernet/renesas/sh_eth.c:83:13: warning: initialized field overwritten [-Woverride-init]
   83 |  [PFTCR]  = 0x055c,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:83:13: note: (near initialization for ‘sh_eth_offset_gigabit[39]’)
drivers/net/ethernet/renesas/sh_eth.c:84:13: warning: initialized field overwritten [-Woverride-init]
   84 |  [PFRCR]  = 0x0560,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:84:13: note: (near initialization for ‘sh_eth_offset_gigabit[40]’)
drivers/net/ethernet/renesas/sh_eth.c:85:14: warning: initialized field overwritten [-Woverride-init]
   85 |  [TPAUSER] = 0x0564,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:85:14: note: (near initialization for ‘sh_eth_offset_gigabit[43]’)
drivers/net/ethernet/renesas/sh_eth.c:86:13: warning: initialized field overwritten [-Woverride-init]
   86 |  [GECMR]  = 0x05b0,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:86:13: note: (near initialization for ‘sh_eth_offset_gigabit[47]’)
drivers/net/ethernet/renesas/sh_eth.c:87:13: warning: initialized field overwritten [-Woverride-init]
   87 |  [BCULR]  = 0x05b4,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:87:13: note: (near initialization for ‘sh_eth_offset_gigabit[48]’)
drivers/net/ethernet/renesas/sh_eth.c:88:12: warning: initialized field overwritten [-Woverride-init]
   88 |  [MAHR]  = 0x05c0,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:88:12: note: (near initialization for ‘sh_eth_offset_gigabit[49]’)
drivers/net/ethernet/renesas/sh_eth.c:89:12: warning: initialized field overwritten [-Woverride-init]
   89 |  [MALR]  = 0x05c8,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:89:12: note: (near initialization for ‘sh_eth_offset_gigabit[50]’)
drivers/net/ethernet/renesas/sh_eth.c:90:13: warning: initialized field overwritten [-Woverride-init]
   90 |  [TROCR]  = 0x0700,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:90:13: note: (near initialization for ‘sh_eth_offset_gigabit[51]’)
drivers/net/ethernet/renesas/sh_eth.c:91:12: warning: initialized field overwritten [-Woverride-init]
   91 |  [CDCR]  = 0x0708,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:91:12: note: (near initialization for ‘sh_eth_offset_gigabit[52]’)
drivers/net/ethernet/renesas/sh_eth.c:92:12: warning: initialized field overwritten [-Woverride-init]
   92 |  [LCCR]  = 0x0710,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:92:12: note: (near initialization for ‘sh_eth_offset_gigabit[53]’)
drivers/net/ethernet/renesas/sh_eth.c:93:13: warning: initialized field overwritten [-Woverride-init]
   93 |  [CEFCR]  = 0x0740,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:93:13: note: (near initialization for ‘sh_eth_offset_gigabit[55]’)
drivers/net/ethernet/renesas/sh_eth.c:94:13: warning: initialized field overwritten [-Woverride-init]
   94 |  [FRECR]  = 0x0748,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:94:13: note: (near initialization for ‘sh_eth_offset_gigabit[56]’)
drivers/net/ethernet/renesas/sh_eth.c:95:13: warning: initialized field overwritten [-Woverride-init]
   95 |  [TSFRCR] = 0x0750,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:95:13: note: (near initialization for ‘sh_eth_offset_gigabit[57]’)
drivers/net/ethernet/renesas/sh_eth.c:96:13: warning: initialized field overwritten [-Woverride-init]
   96 |  [TLFRCR] = 0x0758,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:96:13: note: (near initialization for ‘sh_eth_offset_gigabit[58]’)
drivers/net/ethernet/renesas/sh_eth.c:97:12: warning: initialized field overwritten [-Woverride-init]
   97 |  [RFCR]  = 0x0760,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:97:12: note: (near initialization for ‘sh_eth_offset_gigabit[41]’)
drivers/net/ethernet/renesas/sh_eth.c:98:13: warning: initialized field overwritten [-Woverride-init]
   98 |  [CERCR]  = 0x0768,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:98:13: note: (near initialization for ‘sh_eth_offset_gigabit[59]’)
drivers/net/ethernet/renesas/sh_eth.c:99:13: warning: initialized field overwritten [-Woverride-init]
   99 |  [CEECR]  = 0x0770,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:99:13: note: (near initialization for ‘sh_eth_offset_gigabit[60]’)
drivers/net/ethernet/renesas/sh_eth.c:100:13: warning: initialized field overwritten [-Woverride-init]
  100 |  [MAFCR]  = 0x0778,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:100:13: note: (near initialization for ‘sh_eth_offset_gigabit[61]’)
drivers/net/ethernet/renesas/sh_eth.c:101:15: warning: initialized field overwritten [-Woverride-init]
  101 |  [RMII_MII] = 0x0790,
      |               ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:101:15: note: (near initialization for ‘sh_eth_offset_gigabit[64]’)
drivers/net/ethernet/renesas/sh_eth.c:103:13: warning: initialized field overwritten [-Woverride-init]
  103 |  [ARSTR]  = 0x0000,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:103:13: note: (near initialization for ‘sh_eth_offset_gigabit[65]’)
drivers/net/ethernet/renesas/sh_eth.c:104:16: warning: initialized field overwritten [-Woverride-init]
  104 |  [TSU_CTRST] = 0x0004,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:104:16: note: (near initialization for ‘sh_eth_offset_gigabit[66]’)
drivers/net/ethernet/renesas/sh_eth.c:105:16: warning: initialized field overwritten [-Woverride-init]
  105 |  [TSU_FWEN0] = 0x0010,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:105:16: note: (near initialization for ‘sh_eth_offset_gigabit[67]’)
drivers/net/ethernet/renesas/sh_eth.c:106:16: warning: initialized field overwritten [-Woverride-init]
  106 |  [TSU_FWEN1] = 0x0014,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:106:16: note: (near initialization for ‘sh_eth_offset_gigabit[68]’)
drivers/net/ethernet/renesas/sh_eth.c:107:14: warning: initialized field overwritten [-Woverride-init]
  107 |  [TSU_FCM] = 0x0018,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:107:14: note: (near initialization for ‘sh_eth_offset_gigabit[69]’)
drivers/net/ethernet/renesas/sh_eth.c:108:17: warning: initialized field overwritten [-Woverride-init]
  108 |  [TSU_BSYSL0] = 0x0020,
      |                 ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:108:17: note: (near initialization for ‘sh_eth_offset_gigabit[70]’)
drivers/net/ethernet/renesas/sh_eth.c:109:17: warning: initialized field overwritten [-Woverride-init]
  109 |  [TSU_BSYSL1] = 0x0024,
      |                 ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:109:17: note: (near initialization for ‘sh_eth_offset_gigabit[71]’)
drivers/net/ethernet/renesas/sh_eth.c:110:17: warning: initialized field overwritten [-Woverride-init]
  110 |  [TSU_PRISL0] = 0x0028,
      |                 ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:110:17: note: (near initialization for ‘sh_eth_offset_gigabit[72]’)
drivers/net/ethernet/renesas/sh_eth.c:111:17: warning: initialized field overwritten [-Woverride-init]
  111 |  [TSU_PRISL1] = 0x002c,
      |                 ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:111:17: note: (near initialization for ‘sh_eth_offset_gigabit[73]’)
drivers/net/ethernet/renesas/sh_eth.c:112:16: warning: initialized field overwritten [-Woverride-init]
  112 |  [TSU_FWSL0] = 0x0030,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:112:16: note: (near initialization for ‘sh_eth_offset_gigabit[74]’)
drivers/net/ethernet/renesas/sh_eth.c:113:16: warning: initialized field overwritten [-Woverride-init]
  113 |  [TSU_FWSL1] = 0x0034,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:113:16: note: (near initialization for ‘sh_eth_offset_gigabit[75]’)
drivers/net/ethernet/renesas/sh_eth.c:114:16: warning: initialized field overwritten [-Woverride-init]
  114 |  [TSU_FWSLC] = 0x0038,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:114:16: note: (near initialization for ‘sh_eth_offset_gigabit[76]’)
drivers/net/ethernet/renesas/sh_eth.c:115:17: warning: initialized field overwritten [-Woverride-init]
  115 |  [TSU_QTAGM0] = 0x0040,
      |                 ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:115:17: note: (near initialization for ‘sh_eth_offset_gigabit[79]’)
drivers/net/ethernet/renesas/sh_eth.c:116:17: warning: initialized field overwritten [-Woverride-init]
  116 |  [TSU_QTAGM1] = 0x0044,
      |                 ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:116:17: note: (near initialization for ‘sh_eth_offset_gigabit[80]’)
drivers/net/ethernet/renesas/sh_eth.c:117:15: warning: initialized field overwritten [-Woverride-init]
  117 |  [TSU_FWSR] = 0x0050,
      |               ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:117:15: note: (near initialization for ‘sh_eth_offset_gigabit[81]’)
drivers/net/ethernet/renesas/sh_eth.c:118:17: warning: initialized field overwritten [-Woverride-init]
  118 |  [TSU_FWINMK] = 0x0054,
      |                 ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:118:17: note: (near initialization for ‘sh_eth_offset_gigabit[82]’)
drivers/net/ethernet/renesas/sh_eth.c:119:16: warning: initialized field overwritten [-Woverride-init]
  119 |  [TSU_ADQT0] = 0x0048,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:119:16: note: (near initialization for ‘sh_eth_offset_gigabit[83]’)
drivers/net/ethernet/renesas/sh_eth.c:120:16: warning: initialized field overwritten [-Woverride-init]
  120 |  [TSU_ADQT1] = 0x004c,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:120:16: note: (near initialization for ‘sh_eth_offset_gigabit[84]’)
drivers/net/ethernet/renesas/sh_eth.c:121:16: warning: initialized field overwritten [-Woverride-init]
  121 |  [TSU_VTAG0] = 0x0058,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:121:16: note: (near initialization for ‘sh_eth_offset_gigabit[85]’)
drivers/net/ethernet/renesas/sh_eth.c:122:16: warning: initialized field overwritten [-Woverride-init]
  122 |  [TSU_VTAG1] = 0x005c,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:122:16: note: (near initialization for ‘sh_eth_offset_gigabit[86]’)
drivers/net/ethernet/renesas/sh_eth.c:123:17: warning: initialized field overwritten [-Woverride-init]
  123 |  [TSU_ADSBSY] = 0x0060,
      |                 ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:123:17: note: (near initialization for ‘sh_eth_offset_gigabit[87]’)
drivers/net/ethernet/renesas/sh_eth.c:124:14: warning: initialized field overwritten [-Woverride-init]
  124 |  [TSU_TEN] = 0x0064,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:124:14: note: (near initialization for ‘sh_eth_offset_gigabit[88]’)
drivers/net/ethernet/renesas/sh_eth.c:125:16: warning: initialized field overwritten [-Woverride-init]
  125 |  [TSU_POST1] = 0x0070,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:125:16: note: (near initialization for ‘sh_eth_offset_gigabit[89]’)
drivers/net/ethernet/renesas/sh_eth.c:126:16: warning: initialized field overwritten [-Woverride-init]
  126 |  [TSU_POST2] = 0x0074,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:126:16: note: (near initialization for ‘sh_eth_offset_gigabit[90]’)
drivers/net/ethernet/renesas/sh_eth.c:127:16: warning: initialized field overwritten [-Woverride-init]
  127 |  [TSU_POST3] = 0x0078,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:127:16: note: (near initialization for ‘sh_eth_offset_gigabit[91]’)
drivers/net/ethernet/renesas/sh_eth.c:128:16: warning: initialized field overwritten [-Woverride-init]
  128 |  [TSU_POST4] = 0x007c,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:128:16: note: (near initialization for ‘sh_eth_offset_gigabit[92]’)
drivers/net/ethernet/renesas/sh_eth.c:129:16: warning: initialized field overwritten [-Woverride-init]
  129 |  [TSU_ADRH0] = 0x0100,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:129:16: note: (near initialization for ‘sh_eth_offset_gigabit[93]’)
drivers/net/ethernet/renesas/sh_eth.c:131:14: warning: initialized field overwritten [-Woverride-init]
  131 |  [TXNLCR0] = 0x0080,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:131:14: note: (near initialization for ‘sh_eth_offset_gigabit[94]’)
drivers/net/ethernet/renesas/sh_eth.c:132:14: warning: initialized field overwritten [-Woverride-init]
  132 |  [TXALCR0] = 0x0084,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:132:14: note: (near initialization for ‘sh_eth_offset_gigabit[95]’)
drivers/net/ethernet/renesas/sh_eth.c:133:14: warning: initialized field overwritten [-Woverride-init]
  133 |  [RXNLCR0] = 0x0088,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:133:14: note: (near initialization for ‘sh_eth_offset_gigabit[96]’)
drivers/net/ethernet/renesas/sh_eth.c:134:14: warning: initialized field overwritten [-Woverride-init]
  134 |  [RXALCR0] = 0x008c,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:134:14: note: (near initialization for ‘sh_eth_offset_gigabit[97]’)
drivers/net/ethernet/renesas/sh_eth.c:135:14: warning: initialized field overwritten [-Woverride-init]
  135 |  [FWNLCR0] = 0x0090,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:135:14: note: (near initialization for ‘sh_eth_offset_gigabit[98]’)
drivers/net/ethernet/renesas/sh_eth.c:136:14: warning: initialized field overwritten [-Woverride-init]
  136 |  [FWALCR0] = 0x0094,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:136:14: note: (near initialization for ‘sh_eth_offset_gigabit[99]’)
drivers/net/ethernet/renesas/sh_eth.c:137:14: warning: initialized field overwritten [-Woverride-init]
  137 |  [TXNLCR1] = 0x00a0,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:137:14: note: (near initialization for ‘sh_eth_offset_gigabit[100]’)
drivers/net/ethernet/renesas/sh_eth.c:138:14: warning: initialized field overwritten [-Woverride-init]
  138 |  [TXALCR1] = 0x00a4,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:138:14: note: (near initialization for ‘sh_eth_offset_gigabit[101]’)
drivers/net/ethernet/renesas/sh_eth.c:139:14: warning: initialized field overwritten [-Woverride-init]
  139 |  [RXNLCR1] = 0x00a8,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:139:14: note: (near initialization for ‘sh_eth_offset_gigabit[102]’)
drivers/net/ethernet/renesas/sh_eth.c:140:14: warning: initialized field overwritten [-Woverride-init]
  140 |  [RXALCR1] = 0x00ac,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:140:14: note: (near initialization for ‘sh_eth_offset_gigabit[103]’)
drivers/net/ethernet/renesas/sh_eth.c:141:14: warning: initialized field overwritten [-Woverride-init]
  141 |  [FWNLCR1] = 0x00b0,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:141:14: note: (near initialization for ‘sh_eth_offset_gigabit[104]’)
drivers/net/ethernet/renesas/sh_eth.c:142:14: warning: initialized field overwritten [-Woverride-init]
  142 |  [FWALCR1] = 0x00b4,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:142:14: note: (near initialization for ‘sh_eth_offset_gigabit[105]’)
drivers/net/ethernet/renesas/sh_eth.c:148:12: warning: initialized field overwritten [-Woverride-init]
  148 |  [ECMR]  = 0x0300,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:148:12: note: (near initialization for ‘sh_eth_offset_fast_rcar[28]’)
drivers/net/ethernet/renesas/sh_eth.c:149:12: warning: initialized field overwritten [-Woverride-init]
  149 |  [RFLR]  = 0x0308,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:149:12: note: (near initialization for ‘sh_eth_offset_fast_rcar[35]’)
drivers/net/ethernet/renesas/sh_eth.c:150:12: warning: initialized field overwritten [-Woverride-init]
  150 |  [ECSR]  = 0x0310,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:150:12: note: (near initialization for ‘sh_eth_offset_fast_rcar[29]’)
drivers/net/ethernet/renesas/sh_eth.c:151:13: warning: initialized field overwritten [-Woverride-init]
  151 |  [ECSIPR] = 0x0318,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:151:13: note: (near initialization for ‘sh_eth_offset_fast_rcar[30]’)
drivers/net/ethernet/renesas/sh_eth.c:152:11: warning: initialized field overwritten [-Woverride-init]
  152 |  [PIR]  = 0x0320,
      |           ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:152:11: note: (near initialization for ‘sh_eth_offset_fast_rcar[31]’)
drivers/net/ethernet/renesas/sh_eth.c:153:11: warning: initialized field overwritten [-Woverride-init]
  153 |  [PSR]  = 0x0328,
      |           ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:153:11: note: (near initialization for ‘sh_eth_offset_fast_rcar[32]’)
drivers/net/ethernet/renesas/sh_eth.c:154:13: warning: initialized field overwritten [-Woverride-init]
  154 |  [RDMLR]  = 0x0340,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:154:13: note: (near initialization for ‘sh_eth_offset_fast_rcar[33]’)
drivers/net/ethernet/renesas/sh_eth.c:155:12: warning: initialized field overwritten [-Woverride-init]
  155 |  [IPGR]  = 0x0350,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:155:12: note: (near initialization for ‘sh_eth_offset_fast_rcar[36]’)
drivers/net/ethernet/renesas/sh_eth.c:156:11: warning: initialized field overwritten [-Woverride-init]
  156 |  [APR]  = 0x0354,
      |           ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:156:11: note: (near initialization for ‘sh_eth_offset_fast_rcar[37]’)
drivers/net/ethernet/renesas/sh_eth.c:157:11: warning: initialized field overwritten [-Woverride-init]
  157 |  [MPR]  = 0x0358,
      |           ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:157:11: note: (near initialization for ‘sh_eth_offset_fast_rcar[38]’)
drivers/net/ethernet/renesas/sh_eth.c:158:12: warning: initialized field overwritten [-Woverride-init]
  158 |  [RFCF]  = 0x0360,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:158:12: note: (near initialization for ‘sh_eth_offset_fast_rcar[42]’)
drivers/net/ethernet/renesas/sh_eth.c:159:14: warning: initialized field overwritten [-Woverride-init]
  159 |  [TPAUSER] = 0x0364,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:159:14: note: (near initialization for ‘sh_eth_offset_fast_rcar[43]’)
drivers/net/ethernet/renesas/sh_eth.c:160:15: warning: initialized field overwritten [-Woverride-init]
  160 |  [TPAUSECR] = 0x0368,
      |               ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:160:15: note: (near initialization for ‘sh_eth_offset_fast_rcar[44]’)
drivers/net/ethernet/renesas/sh_eth.c:161:12: warning: initialized field overwritten [-Woverride-init]
  161 |  [MAHR]  = 0x03c0,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:161:12: note: (near initialization for ‘sh_eth_offset_fast_rcar[49]’)
drivers/net/ethernet/renesas/sh_eth.c:162:12: warning: initialized field overwritten [-Woverride-init]
  162 |  [MALR]  = 0x03c8,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:162:12: note: (near initialization for ‘sh_eth_offset_fast_rcar[50]’)
drivers/net/ethernet/renesas/sh_eth.c:163:13: warning: initialized field overwritten [-Woverride-init]
  163 |  [TROCR]  = 0x03d0,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:163:13: note: (near initialization for ‘sh_eth_offset_fast_rcar[51]’)
drivers/net/ethernet/renesas/sh_eth.c:164:12: warning: initialized field overwritten [-Woverride-init]
  164 |  [CDCR]  = 0x03d4,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:164:12: note: (near initialization for ‘sh_eth_offset_fast_rcar[52]’)
drivers/net/ethernet/renesas/sh_eth.c:165:12: warning: initialized field overwritten [-Woverride-init]
  165 |  [LCCR]  = 0x03d8,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:165:12: note: (near initialization for ‘sh_eth_offset_fast_rcar[53]’)
drivers/net/ethernet/renesas/sh_eth.c:166:13: warning: initialized field overwritten [-Woverride-init]
  166 |  [CNDCR]  = 0x03dc,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:166:13: note: (near initialization for ‘sh_eth_offset_fast_rcar[54]’)
drivers/net/ethernet/renesas/sh_eth.c:167:13: warning: initialized field overwritten [-Woverride-init]
  167 |  [CEFCR]  = 0x03e4,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:167:13: note: (near initialization for ‘sh_eth_offset_fast_rcar[55]’)
drivers/net/ethernet/renesas/sh_eth.c:168:13: warning: initialized field overwritten [-Woverride-init]
  168 |  [FRECR]  = 0x03e8,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:168:13: note: (near initialization for ‘sh_eth_offset_fast_rcar[56]’)
drivers/net/ethernet/renesas/sh_eth.c:169:13: warning: initialized field overwritten [-Woverride-init]
  169 |  [TSFRCR] = 0x03ec,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:169:13: note: (near initialization for ‘sh_eth_offset_fast_rcar[57]’)
drivers/net/ethernet/renesas/sh_eth.c:170:13: warning: initialized field overwritten [-Woverride-init]
  170 |  [TLFRCR] = 0x03f0,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:170:13: note: (near initialization for ‘sh_eth_offset_fast_rcar[58]’)
drivers/net/ethernet/renesas/sh_eth.c:171:12: warning: initialized field overwritten [-Woverride-init]
  171 |  [RFCR]  = 0x03f4,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:171:12: note: (near initialization for ‘sh_eth_offset_fast_rcar[41]’)
drivers/net/ethernet/renesas/sh_eth.c:172:13: warning: initialized field overwritten [-Woverride-init]
  172 |  [MAFCR]  = 0x03f8,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:172:13: note: (near initialization for ‘sh_eth_offset_fast_rcar[61]’)
drivers/net/ethernet/renesas/sh_eth.c:174:12: warning: initialized field overwritten [-Woverride-init]
  174 |  [EDMR]  = 0x0200,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:174:12: note: (near initialization for ‘sh_eth_offset_fast_rcar[1]’)
drivers/net/ethernet/renesas/sh_eth.c:175:13: warning: initialized field overwritten [-Woverride-init]
  175 |  [EDTRR]  = 0x0208,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:175:13: note: (near initialization for ‘sh_eth_offset_fast_rcar[2]’)
drivers/net/ethernet/renesas/sh_eth.c:176:13: warning: initialized field overwritten [-Woverride-init]
  176 |  [EDRRR]  = 0x0210,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:176:13: note: (near initialization for ‘sh_eth_offset_fast_rcar[3]’)
drivers/net/ethernet/renesas/sh_eth.c:177:13: warning: initialized field overwritten [-Woverride-init]
  177 |  [TDLAR]  = 0x0218,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:177:13: note: (near initialization for ‘sh_eth_offset_fast_rcar[6]’)
drivers/net/ethernet/renesas/sh_eth.c:178:13: warning: initialized field overwritten [-Woverride-init]
  178 |  [RDLAR]  = 0x0220,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:178:13: note: (near initialization for ‘sh_eth_offset_fast_rcar[10]’)
drivers/net/ethernet/renesas/sh_eth.c:179:12: warning: initialized field overwritten [-Woverride-init]
  179 |  [EESR]  = 0x0228,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:179:12: note: (near initialization for ‘sh_eth_offset_fast_rcar[4]’)
drivers/net/ethernet/renesas/sh_eth.c:180:13: warning: initialized field overwritten [-Woverride-init]
  180 |  [EESIPR] = 0x0230,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:180:13: note: (near initialization for ‘sh_eth_offset_fast_rcar[5]’)
drivers/net/ethernet/renesas/sh_eth.c:181:13: warning: initialized field overwritten [-Woverride-init]
  181 |  [TRSCER] = 0x0238,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:181:13: note: (near initialization for ‘sh_eth_offset_fast_rcar[14]’)
drivers/net/ethernet/renesas/sh_eth.c:182:13: warning: initialized field overwritten [-Woverride-init]
  182 |  [RMFCR]  = 0x0240,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:182:13: note: (near initialization for ‘sh_eth_offset_fast_rcar[15]’)
drivers/net/ethernet/renesas/sh_eth.c:183:12: warning: initialized field overwritten [-Woverride-init]
  183 |  [TFTR]  = 0x0248,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:183:12: note: (near initialization for ‘sh_eth_offset_fast_rcar[16]’)
drivers/net/ethernet/renesas/sh_eth.c:184:11: warning: initialized field overwritten [-Woverride-init]
  184 |  [FDR]  = 0x0250,
      |           ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:184:11: note: (near initialization for ‘sh_eth_offset_fast_rcar[17]’)
drivers/net/ethernet/renesas/sh_eth.c:185:12: warning: initialized field overwritten [-Woverride-init]
  185 |  [RMCR]  = 0x0258,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:185:12: note: (near initialization for ‘sh_eth_offset_fast_rcar[18]’)
drivers/net/ethernet/renesas/sh_eth.c:186:13: warning: initialized field overwritten [-Woverride-init]
  186 |  [TFUCR]  = 0x0264,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:186:13: note: (near initialization for ‘sh_eth_offset_fast_rcar[20]’)
drivers/net/ethernet/renesas/sh_eth.c:187:13: warning: initialized field overwritten [-Woverride-init]
  187 |  [RFOCR]  = 0x0268,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:187:13: note: (near initialization for ‘sh_eth_offset_fast_rcar[21]’)
drivers/net/ethernet/renesas/sh_eth.c:188:20: warning: initialized field overwritten [-Woverride-init]
  188 |  [RMIIMODE]      = 0x026c,
      |                    ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:188:20: note: (near initialization for ‘sh_eth_offset_fast_rcar[22]’)
drivers/net/ethernet/renesas/sh_eth.c:189:13: warning: initialized field overwritten [-Woverride-init]
  189 |  [FCFTR]  = 0x0270,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:189:13: note: (near initialization for ‘sh_eth_offset_fast_rcar[23]’)
drivers/net/ethernet/renesas/sh_eth.c:190:13: warning: initialized field overwritten [-Woverride-init]
  190 |  [TRIMD]  = 0x027c,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:190:13: note: (near initialization for ‘sh_eth_offset_fast_rcar[25]’)
drivers/net/ethernet/renesas/sh_eth.c:196:12: warning: initialized field overwritten [-Woverride-init]
  196 |  [ECMR]  = 0x0100,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:196:12: note: (near initialization for ‘sh_eth_offset_fast_sh4[28]’)
drivers/net/ethernet/renesas/sh_eth.c:197:12: warning: initialized field overwritten [-Woverride-init]
  197 |  [RFLR]  = 0x0108,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:197:12: note: (near initialization for ‘sh_eth_offset_fast_sh4[35]’)
drivers/net/ethernet/renesas/sh_eth.c:198:12: warning: initialized field overwritten [-Woverride-init]
  198 |  [ECSR]  = 0x0110,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:198:12: note: (near initialization for ‘sh_eth_offset_fast_sh4[29]’)
drivers/net/ethernet/renesas/sh_eth.c:199:13: warning: initialized field overwritten [-Woverride-init]
  199 |  [ECSIPR] = 0x0118,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:199:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[30]’)
drivers/net/ethernet/renesas/sh_eth.c:200:11: warning: initialized field overwritten [-Woverride-init]
  200 |  [PIR]  = 0x0120,
      |           ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:200:11: note: (near initialization for ‘sh_eth_offset_fast_sh4[31]’)
drivers/net/ethernet/renesas/sh_eth.c:201:11: warning: initialized field overwritten [-Woverride-init]
  201 |  [PSR]  = 0x0128,
      |           ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:201:11: note: (near initialization for ‘sh_eth_offset_fast_sh4[32]’)
drivers/net/ethernet/renesas/sh_eth.c:202:13: warning: initialized field overwritten [-Woverride-init]
  202 |  [RDMLR]  = 0x0140,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:202:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[33]’)
drivers/net/ethernet/renesas/sh_eth.c:203:12: warning: initialized field overwritten [-Woverride-init]
  203 |  [IPGR]  = 0x0150,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:203:12: note: (near initialization for ‘sh_eth_offset_fast_sh4[36]’)
drivers/net/ethernet/renesas/sh_eth.c:204:11: warning: initialized field overwritten [-Woverride-init]
  204 |  [APR]  = 0x0154,
      |           ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:204:11: note: (near initialization for ‘sh_eth_offset_fast_sh4[37]’)
drivers/net/ethernet/renesas/sh_eth.c:205:11: warning: initialized field overwritten [-Woverride-init]
  205 |  [MPR]  = 0x0158,
      |           ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:205:11: note: (near initialization for ‘sh_eth_offset_fast_sh4[38]’)
drivers/net/ethernet/renesas/sh_eth.c:206:14: warning: initialized field overwritten [-Woverride-init]
  206 |  [TPAUSER] = 0x0164,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:206:14: note: (near initialization for ‘sh_eth_offset_fast_sh4[43]’)
drivers/net/ethernet/renesas/sh_eth.c:207:12: warning: initialized field overwritten [-Woverride-init]
  207 |  [RFCF]  = 0x0160,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:207:12: note: (near initialization for ‘sh_eth_offset_fast_sh4[42]’)
drivers/net/ethernet/renesas/sh_eth.c:208:15: warning: initialized field overwritten [-Woverride-init]
  208 |  [TPAUSECR] = 0x0168,
      |               ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:208:15: note: (near initialization for ‘sh_eth_offset_fast_sh4[44]’)
drivers/net/ethernet/renesas/sh_eth.c:209:13: warning: initialized field overwritten [-Woverride-init]
  209 |  [BCFRR]  = 0x016c,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:209:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[46]’)
drivers/net/ethernet/renesas/sh_eth.c:210:12: warning: initialized field overwritten [-Woverride-init]
  210 |  [MAHR]  = 0x01c0,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:210:12: note: (near initialization for ‘sh_eth_offset_fast_sh4[49]’)
drivers/net/ethernet/renesas/sh_eth.c:211:12: warning: initialized field overwritten [-Woverride-init]
  211 |  [MALR]  = 0x01c8,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:211:12: note: (near initialization for ‘sh_eth_offset_fast_sh4[50]’)
drivers/net/ethernet/renesas/sh_eth.c:212:13: warning: initialized field overwritten [-Woverride-init]
  212 |  [TROCR]  = 0x01d0,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:212:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[51]’)
drivers/net/ethernet/renesas/sh_eth.c:213:12: warning: initialized field overwritten [-Woverride-init]
  213 |  [CDCR]  = 0x01d4,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:213:12: note: (near initialization for ‘sh_eth_offset_fast_sh4[52]’)
drivers/net/ethernet/renesas/sh_eth.c:214:12: warning: initialized field overwritten [-Woverride-init]
  214 |  [LCCR]  = 0x01d8,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:214:12: note: (near initialization for ‘sh_eth_offset_fast_sh4[53]’)
drivers/net/ethernet/renesas/sh_eth.c:215:13: warning: initialized field overwritten [-Woverride-init]
  215 |  [CNDCR]  = 0x01dc,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:215:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[54]’)
drivers/net/ethernet/renesas/sh_eth.c:216:13: warning: initialized field overwritten [-Woverride-init]
  216 |  [CEFCR]  = 0x01e4,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:216:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[55]’)
drivers/net/ethernet/renesas/sh_eth.c:217:13: warning: initialized field overwritten [-Woverride-init]
  217 |  [FRECR]  = 0x01e8,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:217:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[56]’)
drivers/net/ethernet/renesas/sh_eth.c:218:13: warning: initialized field overwritten [-Woverride-init]
  218 |  [TSFRCR] = 0x01ec,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:218:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[57]’)
drivers/net/ethernet/renesas/sh_eth.c:219:13: warning: initialized field overwritten [-Woverride-init]
  219 |  [TLFRCR] = 0x01f0,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:219:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[58]’)
drivers/net/ethernet/renesas/sh_eth.c:220:12: warning: initialized field overwritten [-Woverride-init]
  220 |  [RFCR]  = 0x01f4,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:220:12: note: (near initialization for ‘sh_eth_offset_fast_sh4[41]’)
drivers/net/ethernet/renesas/sh_eth.c:221:13: warning: initialized field overwritten [-Woverride-init]
  221 |  [MAFCR]  = 0x01f8,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:221:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[61]’)
drivers/net/ethernet/renesas/sh_eth.c:222:13: warning: initialized field overwritten [-Woverride-init]
  222 |  [RTRATE] = 0x01fc,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:222:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[62]’)
drivers/net/ethernet/renesas/sh_eth.c:224:12: warning: initialized field overwritten [-Woverride-init]
  224 |  [EDMR]  = 0x0000,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:224:12: note: (near initialization for ‘sh_eth_offset_fast_sh4[1]’)
drivers/net/ethernet/renesas/sh_eth.c:225:13: warning: initialized field overwritten [-Woverride-init]
  225 |  [EDTRR]  = 0x0008,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:225:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[2]’)
drivers/net/ethernet/renesas/sh_eth.c:226:13: warning: initialized field overwritten [-Woverride-init]
  226 |  [EDRRR]  = 0x0010,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:226:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[3]’)
drivers/net/ethernet/renesas/sh_eth.c:227:13: warning: initialized field overwritten [-Woverride-init]
  227 |  [TDLAR]  = 0x0018,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:227:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[6]’)
drivers/net/ethernet/renesas/sh_eth.c:228:13: warning: initialized field overwritten [-Woverride-init]
  228 |  [RDLAR]  = 0x0020,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:228:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[10]’)
drivers/net/ethernet/renesas/sh_eth.c:229:12: warning: initialized field overwritten [-Woverride-init]
  229 |  [EESR]  = 0x0028,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:229:12: note: (near initialization for ‘sh_eth_offset_fast_sh4[4]’)
drivers/net/ethernet/renesas/sh_eth.c:230:13: warning: initialized field overwritten [-Woverride-init]
  230 |  [EESIPR] = 0x0030,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:230:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[5]’)
drivers/net/ethernet/renesas/sh_eth.c:231:13: warning: initialized field overwritten [-Woverride-init]
  231 |  [TRSCER] = 0x0038,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:231:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[14]’)
drivers/net/ethernet/renesas/sh_eth.c:232:13: warning: initialized field overwritten [-Woverride-init]
  232 |  [RMFCR]  = 0x0040,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:232:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[15]’)
drivers/net/ethernet/renesas/sh_eth.c:233:12: warning: initialized field overwritten [-Woverride-init]
  233 |  [TFTR]  = 0x0048,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:233:12: note: (near initialization for ‘sh_eth_offset_fast_sh4[16]’)
drivers/net/ethernet/renesas/sh_eth.c:234:11: warning: initialized field overwritten [-Woverride-init]
  234 |  [FDR]  = 0x0050,
      |           ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:234:11: note: (near initialization for ‘sh_eth_offset_fast_sh4[17]’)
drivers/net/ethernet/renesas/sh_eth.c:235:12: warning: initialized field overwritten [-Woverride-init]
  235 |  [RMCR]  = 0x0058,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:235:12: note: (near initialization for ‘sh_eth_offset_fast_sh4[18]’)
drivers/net/ethernet/renesas/sh_eth.c:236:13: warning: initialized field overwritten [-Woverride-init]
  236 |  [TFUCR]  = 0x0064,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:236:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[20]’)
drivers/net/ethernet/renesas/sh_eth.c:237:13: warning: initialized field overwritten [-Woverride-init]
  237 |  [RFOCR]  = 0x0068,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:237:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[21]’)
drivers/net/ethernet/renesas/sh_eth.c:238:13: warning: initialized field overwritten [-Woverride-init]
  238 |  [FCFTR]  = 0x0070,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:238:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[23]’)
drivers/net/ethernet/renesas/sh_eth.c:239:13: warning: initialized field overwritten [-Woverride-init]
  239 |  [RPADIR] = 0x0078,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:239:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[24]’)
drivers/net/ethernet/renesas/sh_eth.c:240:13: warning: initialized field overwritten [-Woverride-init]
  240 |  [TRIMD]  = 0x007c,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:240:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[25]’)
drivers/net/ethernet/renesas/sh_eth.c:241:13: warning: initialized field overwritten [-Woverride-init]
  241 |  [RBWAR]  = 0x00c8,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:241:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[26]’)
drivers/net/ethernet/renesas/sh_eth.c:242:13: warning: initialized field overwritten [-Woverride-init]
  242 |  [RDFAR]  = 0x00cc,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:242:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[11]’)
drivers/net/ethernet/renesas/sh_eth.c:243:13: warning: initialized field overwritten [-Woverride-init]
  243 |  [TBRAR]  = 0x00d4,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:243:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[27]’)
drivers/net/ethernet/renesas/sh_eth.c:244:13: warning: initialized field overwritten [-Woverride-init]
  244 |  [TDFAR]  = 0x00d8,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:244:13: note: (near initialization for ‘sh_eth_offset_fast_sh4[7]’)
drivers/net/ethernet/renesas/sh_eth.c:250:12: warning: initialized field overwritten [-Woverride-init]
  250 |  [EDMR]  = 0x0000,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:250:12: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[1]’)
drivers/net/ethernet/renesas/sh_eth.c:251:13: warning: initialized field overwritten [-Woverride-init]
  251 |  [EDTRR]  = 0x0004,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:251:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[2]’)
drivers/net/ethernet/renesas/sh_eth.c:252:13: warning: initialized field overwritten [-Woverride-init]
  252 |  [EDRRR]  = 0x0008,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:252:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[3]’)
drivers/net/ethernet/renesas/sh_eth.c:253:13: warning: initialized field overwritten [-Woverride-init]
  253 |  [TDLAR]  = 0x000c,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:253:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[6]’)
drivers/net/ethernet/renesas/sh_eth.c:254:13: warning: initialized field overwritten [-Woverride-init]
  254 |  [RDLAR]  = 0x0010,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:254:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[10]’)
drivers/net/ethernet/renesas/sh_eth.c:255:12: warning: initialized field overwritten [-Woverride-init]
  255 |  [EESR]  = 0x0014,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:255:12: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[4]’)
drivers/net/ethernet/renesas/sh_eth.c:256:13: warning: initialized field overwritten [-Woverride-init]
  256 |  [EESIPR] = 0x0018,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:256:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[5]’)
drivers/net/ethernet/renesas/sh_eth.c:257:13: warning: initialized field overwritten [-Woverride-init]
  257 |  [TRSCER] = 0x001c,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:257:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[14]’)
drivers/net/ethernet/renesas/sh_eth.c:258:13: warning: initialized field overwritten [-Woverride-init]
  258 |  [RMFCR]  = 0x0020,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:258:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[15]’)
drivers/net/ethernet/renesas/sh_eth.c:259:12: warning: initialized field overwritten [-Woverride-init]
  259 |  [TFTR]  = 0x0024,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:259:12: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[16]’)
drivers/net/ethernet/renesas/sh_eth.c:260:11: warning: initialized field overwritten [-Woverride-init]
  260 |  [FDR]  = 0x0028,
      |           ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:260:11: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[17]’)
drivers/net/ethernet/renesas/sh_eth.c:261:12: warning: initialized field overwritten [-Woverride-init]
  261 |  [RMCR]  = 0x002c,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:261:12: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[18]’)
drivers/net/ethernet/renesas/sh_eth.c:262:13: warning: initialized field overwritten [-Woverride-init]
  262 |  [EDOCR]  = 0x0030,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:262:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[19]’)
drivers/net/ethernet/renesas/sh_eth.c:263:13: warning: initialized field overwritten [-Woverride-init]
  263 |  [FCFTR]  = 0x0034,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:263:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[23]’)
drivers/net/ethernet/renesas/sh_eth.c:264:13: warning: initialized field overwritten [-Woverride-init]
  264 |  [RPADIR] = 0x0038,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:264:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[24]’)
drivers/net/ethernet/renesas/sh_eth.c:265:13: warning: initialized field overwritten [-Woverride-init]
  265 |  [TRIMD]  = 0x003c,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:265:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[25]’)
drivers/net/ethernet/renesas/sh_eth.c:266:13: warning: initialized field overwritten [-Woverride-init]
  266 |  [RBWAR]  = 0x0040,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:266:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[26]’)
drivers/net/ethernet/renesas/sh_eth.c:267:13: warning: initialized field overwritten [-Woverride-init]
  267 |  [RDFAR]  = 0x0044,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:267:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[11]’)
drivers/net/ethernet/renesas/sh_eth.c:268:13: warning: initialized field overwritten [-Woverride-init]
  268 |  [TBRAR]  = 0x004c,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:268:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[27]’)
drivers/net/ethernet/renesas/sh_eth.c:269:13: warning: initialized field overwritten [-Woverride-init]
  269 |  [TDFAR]  = 0x0050,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:269:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[7]’)
drivers/net/ethernet/renesas/sh_eth.c:271:12: warning: initialized field overwritten [-Woverride-init]
  271 |  [ECMR]  = 0x0160,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:271:12: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[28]’)
drivers/net/ethernet/renesas/sh_eth.c:272:12: warning: initialized field overwritten [-Woverride-init]
  272 |  [ECSR]  = 0x0164,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:272:12: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[29]’)
drivers/net/ethernet/renesas/sh_eth.c:273:13: warning: initialized field overwritten [-Woverride-init]
  273 |  [ECSIPR] = 0x0168,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:273:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[30]’)
drivers/net/ethernet/renesas/sh_eth.c:274:11: warning: initialized field overwritten [-Woverride-init]
  274 |  [PIR]  = 0x016c,
      |           ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:274:11: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[31]’)
drivers/net/ethernet/renesas/sh_eth.c:275:12: warning: initialized field overwritten [-Woverride-init]
  275 |  [MAHR]  = 0x0170,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:275:12: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[49]’)
drivers/net/ethernet/renesas/sh_eth.c:276:12: warning: initialized field overwritten [-Woverride-init]
  276 |  [MALR]  = 0x0174,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:276:12: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[50]’)
drivers/net/ethernet/renesas/sh_eth.c:277:12: warning: initialized field overwritten [-Woverride-init]
  277 |  [RFLR]  = 0x0178,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:277:12: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[35]’)
drivers/net/ethernet/renesas/sh_eth.c:278:11: warning: initialized field overwritten [-Woverride-init]
  278 |  [PSR]  = 0x017c,
      |           ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:278:11: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[32]’)
drivers/net/ethernet/renesas/sh_eth.c:279:13: warning: initialized field overwritten [-Woverride-init]
  279 |  [TROCR]  = 0x0180,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:279:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[51]’)
drivers/net/ethernet/renesas/sh_eth.c:280:12: warning: initialized field overwritten [-Woverride-init]
  280 |  [CDCR]  = 0x0184,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:280:12: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[52]’)
drivers/net/ethernet/renesas/sh_eth.c:281:12: warning: initialized field overwritten [-Woverride-init]
  281 |  [LCCR]  = 0x0188,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:281:12: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[53]’)
drivers/net/ethernet/renesas/sh_eth.c:282:13: warning: initialized field overwritten [-Woverride-init]
  282 |  [CNDCR]  = 0x018c,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:282:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[54]’)
drivers/net/ethernet/renesas/sh_eth.c:283:13: warning: initialized field overwritten [-Woverride-init]
  283 |  [CEFCR]  = 0x0194,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:283:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[55]’)
drivers/net/ethernet/renesas/sh_eth.c:284:13: warning: initialized field overwritten [-Woverride-init]
  284 |  [FRECR]  = 0x0198,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:284:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[56]’)
drivers/net/ethernet/renesas/sh_eth.c:285:13: warning: initialized field overwritten [-Woverride-init]
  285 |  [TSFRCR] = 0x019c,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:285:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[57]’)
drivers/net/ethernet/renesas/sh_eth.c:286:13: warning: initialized field overwritten [-Woverride-init]
  286 |  [TLFRCR] = 0x01a0,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:286:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[58]’)
drivers/net/ethernet/renesas/sh_eth.c:287:12: warning: initialized field overwritten [-Woverride-init]
  287 |  [RFCR]  = 0x01a4,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:287:12: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[41]’)
drivers/net/ethernet/renesas/sh_eth.c:288:13: warning: initialized field overwritten [-Woverride-init]
  288 |  [MAFCR]  = 0x01a8,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:288:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[61]’)
drivers/net/ethernet/renesas/sh_eth.c:289:12: warning: initialized field overwritten [-Woverride-init]
  289 |  [IPGR]  = 0x01b4,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:289:12: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[36]’)
drivers/net/ethernet/renesas/sh_eth.c:290:11: warning: initialized field overwritten [-Woverride-init]
  290 |  [APR]  = 0x01b8,
      |           ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:290:11: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[37]’)
drivers/net/ethernet/renesas/sh_eth.c:291:11: warning: initialized field overwritten [-Woverride-init]
  291 |  [MPR]  = 0x01bc,
      |           ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:291:11: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[38]’)
drivers/net/ethernet/renesas/sh_eth.c:292:14: warning: initialized field overwritten [-Woverride-init]
  292 |  [TPAUSER] = 0x01c4,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:292:14: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[43]’)
drivers/net/ethernet/renesas/sh_eth.c:293:12: warning: initialized field overwritten [-Woverride-init]
  293 |  [BCFR]  = 0x01cc,
      |            ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:293:12: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[45]’)
drivers/net/ethernet/renesas/sh_eth.c:295:13: warning: initialized field overwritten [-Woverride-init]
  295 |  [ARSTR]  = 0x0000,
      |             ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:295:13: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[65]’)
drivers/net/ethernet/renesas/sh_eth.c:296:16: warning: initialized field overwritten [-Woverride-init]
  296 |  [TSU_CTRST] = 0x0004,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:296:16: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[66]’)
drivers/net/ethernet/renesas/sh_eth.c:297:16: warning: initialized field overwritten [-Woverride-init]
  297 |  [TSU_FWEN0] = 0x0010,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:297:16: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[67]’)
drivers/net/ethernet/renesas/sh_eth.c:298:16: warning: initialized field overwritten [-Woverride-init]
  298 |  [TSU_FWEN1] = 0x0014,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:298:16: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[68]’)
drivers/net/ethernet/renesas/sh_eth.c:299:14: warning: initialized field overwritten [-Woverride-init]
  299 |  [TSU_FCM] = 0x0018,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:299:14: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[69]’)
drivers/net/ethernet/renesas/sh_eth.c:300:17: warning: initialized field overwritten [-Woverride-init]
  300 |  [TSU_BSYSL0] = 0x0020,
      |                 ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:300:17: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[70]’)
drivers/net/ethernet/renesas/sh_eth.c:301:17: warning: initialized field overwritten [-Woverride-init]
  301 |  [TSU_BSYSL1] = 0x0024,
      |                 ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:301:17: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[71]’)
drivers/net/ethernet/renesas/sh_eth.c:302:17: warning: initialized field overwritten [-Woverride-init]
  302 |  [TSU_PRISL0] = 0x0028,
      |                 ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:302:17: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[72]’)
drivers/net/ethernet/renesas/sh_eth.c:303:17: warning: initialized field overwritten [-Woverride-init]
  303 |  [TSU_PRISL1] = 0x002c,
      |                 ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:303:17: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[73]’)
drivers/net/ethernet/renesas/sh_eth.c:304:16: warning: initialized field overwritten [-Woverride-init]
  304 |  [TSU_FWSL0] = 0x0030,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:304:16: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[74]’)
drivers/net/ethernet/renesas/sh_eth.c:305:16: warning: initialized field overwritten [-Woverride-init]
  305 |  [TSU_FWSL1] = 0x0034,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:305:16: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[75]’)
drivers/net/ethernet/renesas/sh_eth.c:306:16: warning: initialized field overwritten [-Woverride-init]
  306 |  [TSU_FWSLC] = 0x0038,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:306:16: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[76]’)
drivers/net/ethernet/renesas/sh_eth.c:307:17: warning: initialized field overwritten [-Woverride-init]
  307 |  [TSU_QTAGM0] = 0x0040,
      |                 ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:307:17: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[79]’)
drivers/net/ethernet/renesas/sh_eth.c:308:17: warning: initialized field overwritten [-Woverride-init]
  308 |  [TSU_QTAGM1] = 0x0044,
      |                 ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:308:17: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[80]’)
drivers/net/ethernet/renesas/sh_eth.c:309:16: warning: initialized field overwritten [-Woverride-init]
  309 |  [TSU_ADQT0] = 0x0048,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:309:16: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[83]’)
drivers/net/ethernet/renesas/sh_eth.c:310:16: warning: initialized field overwritten [-Woverride-init]
  310 |  [TSU_ADQT1] = 0x004c,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:310:16: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[84]’)
drivers/net/ethernet/renesas/sh_eth.c:311:15: warning: initialized field overwritten [-Woverride-init]
  311 |  [TSU_FWSR] = 0x0050,
      |               ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:311:15: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[81]’)
drivers/net/ethernet/renesas/sh_eth.c:312:17: warning: initialized field overwritten [-Woverride-init]
  312 |  [TSU_FWINMK] = 0x0054,
      |                 ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:312:17: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[82]’)
drivers/net/ethernet/renesas/sh_eth.c:313:17: warning: initialized field overwritten [-Woverride-init]
  313 |  [TSU_ADSBSY] = 0x0060,
      |                 ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:313:17: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[87]’)
drivers/net/ethernet/renesas/sh_eth.c:314:14: warning: initialized field overwritten [-Woverride-init]
  314 |  [TSU_TEN] = 0x0064,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:314:14: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[88]’)
drivers/net/ethernet/renesas/sh_eth.c:315:16: warning: initialized field overwritten [-Woverride-init]
  315 |  [TSU_POST1] = 0x0070,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:315:16: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[89]’)
drivers/net/ethernet/renesas/sh_eth.c:316:16: warning: initialized field overwritten [-Woverride-init]
  316 |  [TSU_POST2] = 0x0074,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:316:16: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[90]’)
drivers/net/ethernet/renesas/sh_eth.c:317:16: warning: initialized field overwritten [-Woverride-init]
  317 |  [TSU_POST3] = 0x0078,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:317:16: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[91]’)
drivers/net/ethernet/renesas/sh_eth.c:318:16: warning: initialized field overwritten [-Woverride-init]
  318 |  [TSU_POST4] = 0x007c,
      |                ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:318:16: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[92]’)
drivers/net/ethernet/renesas/sh_eth.c:320:14: warning: initialized field overwritten [-Woverride-init]
  320 |  [TXNLCR0] = 0x0080,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:320:14: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[94]’)
drivers/net/ethernet/renesas/sh_eth.c:321:14: warning: initialized field overwritten [-Woverride-init]
  321 |  [TXALCR0] = 0x0084,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:321:14: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[95]’)
drivers/net/ethernet/renesas/sh_eth.c:322:14: warning: initialized field overwritten [-Woverride-init]
  322 |  [RXNLCR0] = 0x0088,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:322:14: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[96]’)
drivers/net/ethernet/renesas/sh_eth.c:323:14: warning: initialized field overwritten [-Woverride-init]
  323 |  [RXALCR0] = 0x008c,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:323:14: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[97]’)
drivers/net/ethernet/renesas/sh_eth.c:324:14: warning: initialized field overwritten [-Woverride-init]
  324 |  [FWNLCR0] = 0x0090,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:324:14: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[98]’)
drivers/net/ethernet/renesas/sh_eth.c:325:14: warning: initialized field overwritten [-Woverride-init]
  325 |  [FWALCR0] = 0x0094,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:325:14: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[99]’)
drivers/net/ethernet/renesas/sh_eth.c:326:14: warning: initialized field overwritten [-Woverride-init]
  326 |  [TXNLCR1] = 0x00a0,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:326:14: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[100]’)
drivers/net/ethernet/renesas/sh_eth.c:327:14: warning: initialized field overwritten [-Woverride-init]
  327 |  [TXALCR1] = 0x00a4,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:327:14: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[101]’)
drivers/net/ethernet/renesas/sh_eth.c:328:14: warning: initialized field overwritten [-Woverride-init]
  328 |  [RXNLCR1] = 0x00a8,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:328:14: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[102]’)
drivers/net/ethernet/renesas/sh_eth.c:329:14: warning: initialized field overwritten [-Woverride-init]
  329 |  [RXALCR1] = 0x00ac,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:329:14: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[103]’)
drivers/net/ethernet/renesas/sh_eth.c:330:14: warning: initialized field overwritten [-Woverride-init]
  330 |  [FWNLCR1] = 0x00b0,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:330:14: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[104]’)
drivers/net/ethernet/renesas/sh_eth.c:331:14: warning: initialized field overwritten [-Woverride-init]
  331 |  [FWALCR1] = 0x00b4,
      |              ^~~~~~
drivers/net/ethernet/renesas/sh_eth.c:331:14: note: (near initialization for ‘sh_eth_offset_fast_sh3_sh2[105]’)
drivers/net/ethernet/renesas/sh_eth.c:333:16: warning: initialized field overwritten [-Woverride-init]
  333 |  [TSU_ADRH0] = 0x0100,
      |                ^~~~~~
---
 drivers/net/ethernet/renesas/sh_eth.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 586642c33d2b..c63304632935 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -45,6 +45,15 @@
 #define SH_ETH_OFFSET_DEFAULTS			\
 	[0 ... SH_ETH_MAX_REGISTER_OFFSET - 1] = SH_ETH_OFFSET_INVALID
 
+/* use some intentionally tricky logic here to initialize the whole struct to
+ * 0xffff, but then override certain fields, requiring us to indicate that we
+ * "know" that there are overrides in this structure, and we'll need to disable
+ * that warning from W=1 builds. GCC has supported this option since 4.2.X, but
+ * the macros available to do this only define GCC 8.
+ */
+__diag_push();
+__diag_ignore(GCC, 8, "-Woverride-init",
+	      "logic to initialize all and then override some is OK");
 static const u16 sh_eth_offset_gigabit[SH_ETH_MAX_REGISTER_OFFSET] = {
 	SH_ETH_OFFSET_DEFAULTS,
 
@@ -332,6 +341,7 @@ static const u16 sh_eth_offset_fast_sh3_sh2[SH_ETH_MAX_REGISTER_OFFSET] = {
 
 	[TSU_ADRH0]	= 0x0100,
 };
+__diag_pop();
 
 static void sh_eth_rcv_snd_disable(struct net_device *ndev);
 static struct net_device_stats *sh_eth_get_stats(struct net_device *ndev);
-- 
2.25.4

