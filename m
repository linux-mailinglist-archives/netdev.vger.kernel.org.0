Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18932EC7A6
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 02:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbhAGBUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 20:20:10 -0500
Received: from mrdf0111.ocn.ad.jp ([125.206.160.167]:47912 "EHLO
        mrdf0111.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbhAGBUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 20:20:09 -0500
Received: from mogw5208.ocn.ad.jp (mogw5208.ocn.ad.jp [125.206.161.9])
        by mrdf0111.ocn.ad.jp (Postfix) with ESMTP id D2B0C3E02EF;
        Thu,  7 Jan 2021 10:18:51 +0900 (JST)
Received: from mf-smf-unw005c1.ocn.ad.jp (mf-smf-unw005c1.ocn.ad.jp [153.138.219.78])
        by mogw5208.ocn.ad.jp (Postfix) with ESMTP id 132CD2A041E;
        Thu,  7 Jan 2021 10:17:34 +0900 (JST)
Received: from ocn-vc-mts-201c1.ocn.ad.jp ([153.138.219.212])
        by mf-smf-unw005c1.ocn.ad.jp with ESMTP
        id xJu3kE3BKaeryxJvikLBIg; Thu, 07 Jan 2021 10:17:34 +0900
Received: from smtp.ocn.ne.jp ([153.149.227.165])
        by ocn-vc-mts-201c1.ocn.ad.jp with ESMTP
        id xJvhkfc3Tf1TbxJvhkXnKU; Thu, 07 Jan 2021 10:17:34 +0900
Received: from localhost (p1601136-ipoe.ipoe.ocn.ne.jp [114.172.254.135])
        by smtp.ocn.ne.jp (Postfix) with ESMTPA;
        Thu,  7 Jan 2021 10:17:33 +0900 (JST)
Date:   Thu, 07 Jan 2021 10:17:29 +0900 (JST)
Message-Id: <20210107.101729.1936921832901251107.anemo@mba.ocn.ne.jp>
To:     geert@linux-m68k.org
Cc:     tsbogend@alpha.franken.de, mpm@selenic.com,
        herbert@gondor.apana.org.au, dan.j.williams@intel.com,
        vkoul@kernel.org, davem@davemloft.net, miquel.raynal@bootlin.com,
        richard@nod.at, vigneshr@ti.com, kuba@kernel.org,
        a.zummo@towertech.it, alexandre.belloni@bootlin.com,
        broonie@kernel.org, wim@linux-watchdog.org, linux@roeck-us.net,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-watchdog@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 00/10] Remove support for TX49xx
From:   Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <CAMuHMdV86BES7dmWr-7j1jbtoSy0bH1J0e5W41p8evagi0Nqcw@mail.gmail.com>
References: <CAMuHMdX=trGqj8RzV7r1iTneqDjWOc4e1T-X+R_B34rxxhJpbg@mail.gmail.com>
        <20210106184839.GA7773@alpha.franken.de>
        <CAMuHMdV86BES7dmWr-7j1jbtoSy0bH1J0e5W41p8evagi0Nqcw@mail.gmail.com>
X-Mailer: Mew version 6.7 on Emacs 24.5 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jan 2021 21:41:24 +0100, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> > Is that sufficient to keep it?
>>
>> for me it is. But now we probaly need some reverts then...
> 
> Indeed. Fortunately not all of it, as some removals were TX4938-only.

These patches should not break RBTX4927:

  net: tc35815: Drop support for TX49XX boards
  spi: txx9: Remove driver
  mtd: Remove drivers used by TX49xx
  char: hw_random: Remove tx4939 driver
  rtc: tx4939: Remove driver
  ide: tx4938ide: Remove driver

And these patches just break audio-support only.

  dma: tx49 removal
  ASoC: txx9: Remove driver

I think dma and ASoC drivers are hard to maintain now, and can be
dropped for basic support for RBTX4927.
(TX39 boards does not have audio-support, so dma txx9 driver can be
dropped too)

---
Atsushi Nemoto
