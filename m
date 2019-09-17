Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 564A8B4853
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 09:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404462AbfIQHcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 03:32:36 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46190 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392639AbfIQHcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 03:32:36 -0400
Received: by mail-wr1-f68.google.com with SMTP id o18so1882747wrv.13
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 00:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=oyhBT4NnP3XekqJBrOaMJ0r2KPZOM4Cejny690HOkpg=;
        b=ag1lgpymVO5zKtZiHfMc3QPvrlLDo3dr6qmlA9AdbsH5yNUs1K676rjkUkMeIrxSAi
         acWgSwDzzrKHiGg1F05lg3ddI6zMlFHae5cx3qzrilkkqr8lY10Q5a6uzgyie3WQ9smT
         TVyYD46v2ygcnSqstm/pl0yb2vuwuT2zFHIbgnVg98jChXWlp9Yd2lRjdTtbAWMIco7A
         JMo/1DkuhFLnOqOJyeo6eVLsI9/IdySjb6nwgtH52X6wSX2EWiuxSbFg5cO4d20w+VOp
         5CzKszx9lHEWQjPj0J4at6Qc1iHPm1hIVMokHDWIWOxNu7K4QBAEQYhkBaHl3MFddMBB
         GDFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=oyhBT4NnP3XekqJBrOaMJ0r2KPZOM4Cejny690HOkpg=;
        b=YHeo1QPgqZTh3JtopPSgqfMbDsZI6k4a0TpHP03elS1g5zetySLpddK28TdWhsEu/Z
         XKQZ2EokVUePCYh7HVMP1oLVRpIEdgFvddprlKtn/RlwWwLitKI2h/arI3R4JXG5ezbx
         nwqd+Q1Ngo0q2fNs00Bfvbgp/YQMg2Vlbr2G125WDaDvB9V3pSKvZ8tSvVoHJTL8qqGd
         tDsNP1iH6zg2YRMvFaPcaUkRMDEnyXsV4v6wROIQv4JXFdGn5O7KGW/KDD9csM3nmpFJ
         9VxNlLI7DQjBYfXvoEPYiIq6Mygh72LbUF9cFFRoRQ9Xea9EbQjlvsFq7Y9IQ0vwojvl
         tD5g==
X-Gm-Message-State: APjAAAWiLfVG78AfPfzuA+DUA0b+YN9hYdaZwLfsLkiUCZDGc/wjh+mU
        e3OP+oy0DL9Ov/UzbnwN/Zg=
X-Google-Smtp-Source: APXvYqwPtB6FQROzVwDthXWIn4SiTuaOmYy8ijhIHfgEk5vwfIhAKjh2Kpn7F8HctF2mZd6kYgsBpQ==
X-Received: by 2002:adf:e612:: with SMTP id p18mr1651886wrm.218.1568705554444;
        Tue, 17 Sep 2019 00:32:34 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id x129sm929561wmg.8.2019.09.17.00.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 00:32:33 -0700 (PDT)
Date:   Tue, 17 Sep 2019 00:32:32 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Ilie Halip <ilie.halip@gmail.com>,
        David Bolvansky <david.bolvansky@gmail.com>,
        netdev@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: -Wsizeof-array-div warnings in ethernet drivers
Message-ID: <20190917073232.GA14291@archlinux-threadripper>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Clang recently added a new diagnostic in r371605, -Wsizeof-array-div,
that tries to warn when sizeof(X) / sizeof(Y) does not compute the
number of elements in an array X (i.e., sizeof(Y) is wrong). See that
commit for more details:

https://github.com/llvm/llvm-project/commit/3240ad4ced0d3223149b72a4fc2a4d9b67589427

Some ethernet drivers have an instance of this warning due to receive
side scaling support:


../drivers/net/ethernet/amd/xgbe/xgbe-dev.c:361:49: warning: expression
does not compute the number of elements in this array; element type is
'u8' (aka 'unsigned char'), not 'u32' (aka 'unsigned int')
[-Wsizeof-array-div]
        unsigned int key_regs = sizeof(pdata->rss_key) / sizeof(u32);
                                       ~~~~~~~~~~~~~~  ^
../drivers/net/ethernet/amd/xgbe/xgbe-dev.c:361:49: note: place
parentheses around the 'sizeof(u32)' expression to silence this warning


../drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c:537:36: warning:
expression does not compute the number of elements in this array;
element type is 'u8' (aka 'unsigned char'), not 'u32' (aka 'unsigned
int') [-Wsizeof-array-div]
        for (i = 0; i < (sizeof(cfg->key) / sizeof(u32)); i++) {
                                ~~~~~~~~  ^
../drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c:537:36: note:
place parentheses around the 'sizeof(u32)' expression to silence this
warning


../drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c:2329:49: warning:
expression does not compute the number of elements in this array;
element type is 'u8' (aka 'unsigned char'), not 'u32' (aka 'unsigned
int') [-Wsizeof-array-div]
        unsigned int key_regs = sizeof(pdata->rss_key) / sizeof(u32);
                                       ~~~~~~~~~~~~~~  ^
../drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c:2329:49: note: place
parentheses around the 'sizeof(u32)' expression to silence this warning


What is the reasoning behind having the key being an array of u8s but
seemlingly converting it into an array of u32s? It's not immediately
apparent from reading over the code but I am not familiar with it so I
might be making a mistake. I assume this is intentional? If so, the
warning can be silenced and we'll send patches to do so but we want to
make sure we aren't actually papering over a mistake.

Cheers!
Nathan
