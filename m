Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1CC350067
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 05:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbfFXD7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 23:59:49 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39041 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727552AbfFXD7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 23:59:48 -0400
Received: by mail-pg1-f196.google.com with SMTP id 196so6356516pgc.6
        for <netdev@vger.kernel.org>; Sun, 23 Jun 2019 20:59:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=DephS9aF1RqbAgEf2w/teieLK755TA9/UUG6864ldTk=;
        b=Vivnc44Cq/zjUu9nQulKIL7j/swrrLmVnwwWAMVYkVp5pm4NBnEX7FuGyzdmRwoBHe
         SjEC9dwjJi/xni/8cwjqhkvF4ovAqY14/LH9NICIwdIdGLNzRfrh559ITTqm62twOcOn
         UA6Z9T+qjv1CoWca7hn3CQFn0JCMsOdgHWWFfsiz9/pzYY/8+STWnnmMhMyUGTGcyxD2
         Zbm163ROj1OmaW0z56E6FhF78zHVNt3zPDUWefnSt/+Hgz7FP1FI/ZeLUcGQ++d/+kFV
         VxsMabkFbM0WaA8p+BUa/Fekp+Hpo7uo+bvaXSnSNOX6ffZft+fvNUEfE7EkaK/fuFXs
         HqkA==
X-Gm-Message-State: APjAAAXtVMLQNl6WtVBTmyhSYzKLXpFDcJKxO6faZlygI+VQYBQRMNxg
        eQ2dyc3QrrdCCIuIdPQB0CJ22Q==
X-Google-Smtp-Source: APXvYqx0vYrtGNTNl5KXc2DpVQEG5bwKvqspWyryVid6mzUIPcvfQcnDFMCtCb5rPpbnT1bu7BxQuw==
X-Received: by 2002:a63:3d09:: with SMTP id k9mr24980118pga.321.1561348787037;
        Sun, 23 Jun 2019 20:59:47 -0700 (PDT)
Received: from localhost (220-132-236-182.HINET-IP.hinet.net. [220.132.236.182])
        by smtp.gmail.com with ESMTPSA id t24sm9569893pfh.113.2019.06.23.20.59.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 23 Jun 2019 20:59:46 -0700 (PDT)
Date:   Sun, 23 Jun 2019 20:59:46 -0700 (PDT)
X-Google-Original-Date: Sun, 23 Jun 2019 20:59:43 PDT (-0700)
Subject:     Re: linux-next: build failure after merge of the net-next tree
In-Reply-To: <20190624131245.359e59a4@canb.auug.org.au>
CC:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        yash.shah@sifive.com
From:   Palmer Dabbelt <palmer@sifive.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Message-ID: <mhng-24035d0e-a382-4a48-89eb-eb00213fca7e@palmer-si-x1e>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 Jun 2019 20:12:45 PDT (-0700), Stephen Rothwell wrote:
> Hi all,
>
> On Thu, 20 Jun 2019 19:13:48 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> After merging the net-next tree, today's linux-next build (powerpc
>> allyesconfig) failed like this:
>> 
>> drivers/net/ethernet/cadence/macb_main.c:48:16: error: field 'hw' has incomplete type
>>   struct clk_hw hw;
>>                 ^~
>> drivers/net/ethernet/cadence/macb_main.c:4003:21: error: variable 'fu540_c000_ops' has initializer but incomplete type
>>  static const struct clk_ops fu540_c000_ops = {
>>                      ^~~~~~~
>> drivers/net/ethernet/cadence/macb_main.c:4004:3: error: 'const struct clk_ops' has no member named 'recalc_rate'
>>   .recalc_rate = fu540_macb_tx_recalc_rate,
>>    ^~~~~~~~~~~
>> drivers/net/ethernet/cadence/macb_main.c:4004:17: warning: excess elements in struct initializer
>>   .recalc_rate = fu540_macb_tx_recalc_rate,
>>                  ^~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/cadence/macb_main.c:4004:17: note: (near initialization for 'fu540_c000_ops')
>> drivers/net/ethernet/cadence/macb_main.c:4005:3: error: 'const struct clk_ops' has no member named 'round_rate'
>>   .round_rate = fu540_macb_tx_round_rate,
>>    ^~~~~~~~~~
>> drivers/net/ethernet/cadence/macb_main.c:4005:16: warning: excess elements in struct initializer
>>   .round_rate = fu540_macb_tx_round_rate,
>>                 ^~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/cadence/macb_main.c:4005:16: note: (near initialization for 'fu540_c000_ops')
>> drivers/net/ethernet/cadence/macb_main.c:4006:3: error: 'const struct clk_ops' has no member named 'set_rate'
>>   .set_rate = fu540_macb_tx_set_rate,
>>    ^~~~~~~~
>> drivers/net/ethernet/cadence/macb_main.c:4006:14: warning: excess elements in struct initializer
>>   .set_rate = fu540_macb_tx_set_rate,
>>               ^~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/cadence/macb_main.c:4006:14: note: (near initialization for 'fu540_c000_ops')
>> drivers/net/ethernet/cadence/macb_main.c: In function 'fu540_c000_clk_init':
>> drivers/net/ethernet/cadence/macb_main.c:4013:23: error: storage size of 'init' isn't known
>>   struct clk_init_data init;
>>                        ^~~~
>> drivers/net/ethernet/cadence/macb_main.c:4032:12: error: implicit declaration of function 'clk_register'; did you mean 'sock_register'? [-Werror=implicit-function-declaration]
>>   *tx_clk = clk_register(NULL, &mgmt->hw);
>>             ^~~~~~~~~~~~
>>             sock_register
>> drivers/net/ethernet/cadence/macb_main.c:4013:23: warning: unused variable 'init' [-Wunused-variable]
>>   struct clk_init_data init;
>>                        ^~~~
>> drivers/net/ethernet/cadence/macb_main.c: In function 'macb_probe':
>> drivers/net/ethernet/cadence/macb_main.c:4366:2: error: implicit declaration of function 'clk_unregister'; did you mean 'sock_unregister'? [-Werror=implicit-function-declaration]
>>   clk_unregister(tx_clk);
>>   ^~~~~~~~~~~~~~
>>   sock_unregister
>> drivers/net/ethernet/cadence/macb_main.c: At top level:
>> drivers/net/ethernet/cadence/macb_main.c:4003:29: error: storage size of 'fu540_c000_ops' isn't known
>>  static const struct clk_ops fu540_c000_ops = {
>>                              ^~~~~~~~~~~~~~
>> 
>> Caused by commit
>> 
>>   c218ad559020 ("macb: Add support for SiFive FU540-C000")
>> 
>> CONFIG_COMMON_CLK is not set for this build.
>> 
>> I have reverted that commit for today.
>
> I am still reverting that commit.  Has this problem been fixed in some
> subtle way?

I don't think so.  I'm assuming something like this is necessary

diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
index 1766697c9c5a..d13db9e9c818 100644
--- a/drivers/net/ethernet/cadence/Kconfig
+++ b/drivers/net/ethernet/cadence/Kconfig
@@ -23,6 +23,7 @@ config MACB
        tristate "Cadence MACB/GEM support"
        depends on HAS_DMA
        select PHYLIB
+       depends on COMMON_CLK
        ---help---
          The Cadence MACB ethernet interface is found on many Atmel AT32 and
          AT91 parts.  This driver also supports the Cadence GEM (Gigabit
@@ -42,7 +43,7 @@ config MACB_USE_HWSTAMP

 config MACB_PCI
        tristate "Cadence PCI MACB/GEM support"
-       depends on MACB && PCI && COMMON_CLK
+       depends on MACB && PCI
        ---help---
          This is PCI wrapper for MACB driver.

at a minimum, though it may be saner to #ifdef support for the SiFive clock
driver as that's only useful on some systems.  Assuming I can reproduce the
build failure (which shouldn't be too hard), I'll send out a patch that adds a
Kconfig for the FU540 clock driver to avoid adding a COMMON_CLK dependency for
all MACB systems.
