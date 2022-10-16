Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556C05FFE93
	for <lists+netdev@lfdr.de>; Sun, 16 Oct 2022 12:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiJPKI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 06:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJPKIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 06:08:55 -0400
Received: from ofcsgdbm.dwd.de (ofcsgdbm.dwd.de [141.38.3.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB7136861
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 03:08:53 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by ofcsg2dn3.dwd.de (Postfix) with ESMTP id 4Mqwnc1YQhz2wpv
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 10:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dwd.de; h=
        content-type:content-type:mime-version:references:message-id
        :in-reply-to:subject:subject:from:from:date:date:received
        :received:received:received:received:received:received:received;
         s=dwd-csg20210107; t=1665914932; x=1667124533; bh=zamKnwBiutPTM
        v8R2M4U3AikQo0InxYoAWWVktLey38=; b=RSQw3qUwvYeVDHBpcFefc/m0VZwfr
        Lsmz1Q6qNLXJZl3HbwOnc/gI3n/ntFnXBEp2MxUCiwaZdDGCiyatiNfOU/c3lNGr
        KozYWvi3AlF4CY5lCVFaa3nGEUVnpmizd1LTqjXNNw47idXXLeNYrZ3q5WzCPwR+
        9laEG+3JAlLYB1gS71j4FlN5bbK6oi24ZA0VrXN4SrHRL0Go/SmAYu0jBRE5bt3E
        09xWatDg5e9r7tGhQ+V2pvgZn1OE3d/Z5wfFYoMu5nE/kz6CJjOxgtg0Ij7sTZEF
        w7yih9zsmUvdYBslpW/OquGG83EnTIRtuZ+/MIrz4kUfe6P0rUzU+LOGw==
X-Virus-Scanned: by amavisd-new at csg.dwd.de
Received: from ofcsg2cteh1.dwd.de ([172.30.232.65])
 by localhost (ofcsg2dn3.dwd.de [172.30.232.26]) (amavisd-new, port 10024)
 with ESMTP id 3cZ_lobZAPRn for <netdev@vger.kernel.org>;
 Sun, 16 Oct 2022 10:08:52 +0000 (UTC)
Received: from ofcsg2cteh1.dwd.de (unknown [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 0E028C900CFD
        for <root@ofcsg2dn3.dwd.de>; Sun, 16 Oct 2022 10:08:52 +0000 (UTC)
Received: from ofcsg2cteh1.dwd.de (unknown [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 026D9C90216C
        for <root@ofcsg2dn3.dwd.de>; Sun, 16 Oct 2022 10:08:52 +0000 (UTC)
X-DDEI-TLS-USAGE: Unused
Received: from ofcsgdbm.dwd.de (unknown [172.30.232.26])
        by ofcsg2cteh1.dwd.de (Postfix) with ESMTP
        for <root@ofcsg2dn3.dwd.de>; Sun, 16 Oct 2022 10:08:51 +0000 (UTC)
Received: from ofcsgdbm.dwd.de by localhost (Postfix XFORWARD proxy);
 Sun, 16 Oct 2022 10:08:52 -0000
Received: from ofcsg2dvf2.dwd.de (ofcsg2dvf2.dwd.de [172.30.232.11])
        by ofcsg2dn3.dwd.de (Postfix) with ESMTPS id 4Mqwnb6X3Dz2wVH;
        Sun, 16 Oct 2022 10:08:51 +0000 (UTC)
Received: from ofmailhub.dwd.de (oflxs04.dwd.de [141.38.39.196])
        by ofcsg2dvf2.dwd.de  with ESMTP id 29GA8phv000732-29GA8phw000732;
        Sun, 16 Oct 2022 10:08:51 GMT
Received: from praktifix.dwd.de (praktifix.dwd.de [141.38.44.46])
        by ofmailhub.dwd.de (Postfix) with ESMTP id 68B70E25F1;
        Sun, 16 Oct 2022 10:08:51 +0000 (UTC)
Date:   Sun, 16 Oct 2022 10:08:51 +0000 (GMT)
From:   Holger Kiehl <Holger.Kiehl@dwd.de>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ice driver not loading with 256 CPU's?
In-Reply-To: <ea05a9d-b8b8-216f-d99-9b794f19f2cf@praktifix.dwd.de>
Message-ID: <68f4cde8-cb2f-f526-265d-2d5cdcfa53e2@praktifix.dwd.de>
References: <ea05a9d-b8b8-216f-d99-9b794f19f2cf@praktifix.dwd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-FE-Last-Public-Client-IP: 141.38.39.196
X-FE-Policy-ID: 2:2:1:SYSTEM
X-TMASE-Version: DDEI-5.1-9.0.1002-27204.006
X-TMASE-Result: 10--19.901500-10.000000
X-TMASE-MatchedRID: oTBA/+sdKaYMek0ClnpVp/HkpkyUphL9Mi5cVoUvU/bfrYpxwT811j13
        GoPFA1HFJjdZvprOsDxHPmHy6OeVI4DVR1zNwvHu2ymWcHNzzEzYUDvAr2Y/19Z5C2tydwt9bwY
        sfZTUes1l+KZhG9Ijo32Cywe/FAZ0I0LyKTLUz/+ZUG41i0KjmxZSD+Gbjz3IJEdV66mPROFSj9
        02t3M5P71vPbjkslMKpWip9Zjnp6UrqSb6h39QPIdlc1JaOB1TyHdfpwipSH6bKItl61J/yX2PY
        bDNMTe9KrauXd3MZDUD/dHyT/Xh7Q==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-DDEI-PROCESSED-RESULT: Safe
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 15 Oct 2022, Holger Kiehl wrote:

> Hello,
>
> I have an AMD system with 2 sockets (each with a EPYC 7763 64-Core)
> with a total of 256 CPU's and a 4 port Intel 810 nic and get the
> following error during boot:
>
> Oct 15 10:53:35 hermes kernel: ice 0000:e2:00.1: The DDP package was 
> successfully loaded: ICE OS Default Package version 1.3.26.0
> Oct 15 10:53:35 hermes kernel: ice 0000:e2:00.1: not enough device MSI-X 
> vectors. requested = 260, available = 252
> Oct 15 10:53:35 hermes kernel: ice 0000:e2:00.1: ice_init_interrupt_scheme 
> failed: -34
> Oct 15 10:53:35 hermes kernel: ice: probe of 0000:e2:00.1 failed with error 
> -5
>
> Get this error when using default kernel from Alma9 or as above with
> kernel.org 6.0.2 kernel. Looking at the code
> (drivers/net/ethernet/intel/ice/ice_main.c ice_ena_msix_range() starting
> at line 3928) I would assume if I had less CPU's this would not be a problem.
>
Indeed, booting with nr_cpus=252 the driver loads:

Oct 16 10:02:30 hermes kernel: ice 0000:e2:00.0: The DDP package was successfully loaded: ICE OS Default Package version 1.3.26.0
Oct 16 10:02:30 hermes kernel: ice 0000:e2:00.0: PTP init successful
Oct 16 10:02:30 hermes kernel: ice 0000:e2:00.0: DCB is enabled in the hardware, max number of TCs supported on this port are 8
Oct 16 10:02:30 hermes kernel: ice 0000:e2:00.0: FW LLDP is disabled, DCBx/LLDP in SW mode.
Oct 16 10:02:30 hermes kernel: ice 0000:e2:00.0: Commit DCB Configuration to the hardware
Oct 16 10:02:30 hermes kernel: ice 0000:e2:00.0: 252.048 Gb/s available PCIe bandwidth (16.0 GT/s PCIe x16 link)

Could you please fix the driver so it works with more then 252 CPU's?

Many thanks in advance.

Regards,
Holger
