Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D66F688407
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 17:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbjBBQTd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 Feb 2023 11:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232145AbjBBQTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 11:19:16 -0500
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78740298EB;
        Thu,  2 Feb 2023 08:19:05 -0800 (PST)
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.95)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1pNcIb-0007Ln-EJ; Thu, 02 Feb 2023 17:18:57 +0100
Received: from p57bd9464.dip0.t-ipconnect.de ([87.189.148.100] helo=[192.168.178.81])
          by inpost2.zedat.fu-berlin.de (Exim 4.95)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1pNcIb-0007e6-6x; Thu, 02 Feb 2023 17:18:57 +0100
Message-ID: <0d24e5aa26eeb7e9d899c62ba44e59b64b1ef44a.camel@physik.fu-berlin.de>
Subject: Re: [PATCH net-next] r8169: use devm_clk_get_optional_enabled() to
 simplify the code
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org, nic_swsd@realtek.com,
        pabeni@redhat.com, linux-sh@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>
Date:   Thu, 02 Feb 2023 17:18:56 +0100
In-Reply-To: <CAMuHMdXPSh6u3FmMW002-fML2CMMs7ZO4a1-05nBHZo_dndb_A@mail.gmail.com>
References: <68bd1e34-4251-4306-cc7d-e5ccc578acd9@gmail.com>
         <585c4b48790d71ca43b66fc24ea8d84917c4a0e1.camel@physik.fu-berlin.de>
         <CAMuHMdXPSh6u3FmMW002-fML2CMMs7ZO4a1-05nBHZo_dndb_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 87.189.148.100
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert!

On Thu, 2023-02-02 at 17:09 +0100, Geert Uytterhoeven wrote:
> > This change broke the r8169 driver on my SH7785LCR SuperH Evaluation Board.
> > 
> > With your patch, the driver initialization fails with:
> > 
> > [    1.648000] r8169 0000:00:00.0: error -EINVAL: failed to get ether_clk
> > [    1.676000] r8169: probe of 0000:00:00.0 failed with error -22
> > 
> > Any idea what could be the problem?
> 
> SH's clk_enable() returns -EINVAL if clk == NULL, which is wrong.
> Preparing a patch...

Ah, that explains the error message then.

Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
