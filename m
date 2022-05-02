Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C769516AEF
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 08:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383490AbiEBGqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 02:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343598AbiEBGqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 02:46:43 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864202CE1D;
        Sun,  1 May 2022 23:43:12 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id x23so6319744pff.9;
        Sun, 01 May 2022 23:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=iAuUa0BGKm3Umq1FBvXS7xo05qV6QmFyZ/a1PtsOX5E=;
        b=P+qxbf4Lv1EeTjOjULUDyzWnjjnjEl3cIx5tdseFK+GRpnp0zV6XDF8vlDr4Ja4iXx
         u9qrpIGpr7qdbZHwZlBFg4P0udLosxtDbk0LgGOtAmAjYAlOc8nvcybd3+hve19ZdhDu
         oPlLwBWiP6KIvd7rp5p6S2oWYS/GrRAYqaIJDLL8JW42LeChQFvENah0cuIJIX8/NQDZ
         q1G1O6xJ5IEIDrPK8DDotFvvDswPofCe92W6NZGMLQ7LNhZHnxx5aNkB9hG0m2RBl7ot
         C2KIjK3DtCgJmbENPMSXmwrYpQu313cs+I0uc6KISVuarAN10eMIe66loQy4n9NNG4n3
         pooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=iAuUa0BGKm3Umq1FBvXS7xo05qV6QmFyZ/a1PtsOX5E=;
        b=4cfpxpDCYoxeNWaTvf8JLImmiz2A62NHNdg4ScYke8jYQWeA1mcAzCcpY6EL0MOJik
         wPY8XlUEGst+/YGDJiCZ/WbCbbOH5FD9HcbSEnKKiLT6gwLlT7IN9gIXRX0R5xPVGctP
         XeXRUGShEMPzRQE3yE7idrZIk0MpJhwFqoqfKH7r6rvxlPcu8F3ahXrIdVmHBpn2d/0J
         WlStRJftBrF2F8vo2QhUIBW4wunSRH5ImhF43yI3MdRsU+3jv4mhvr17X7SLSSy1JlKP
         vPpq+Nek8K71Q6npZaqSxLP/J239+kK3+iDvPflOY4+CK4YarZinDVuZpPVkAvOcIsSH
         TwtA==
X-Gm-Message-State: AOAM533d1XiyN/SAwCNDO8+8g+s8HyT5hPYJmicQEO2uOedIlY1tgPax
        gpi7mAdGjYXnMRb2/0TM+DsHqRoGGmylgs1v7aMTwVCigng=
X-Google-Smtp-Source: ABdhPJxb5VYu7eov/l6wnOftz0i68FF37AZ58mVmsnou3EO+HGkwtWZqq1kKfFpx+aHz3h/nSDzLjRUdwY5FEmLR0To=
X-Received: by 2002:a63:e849:0:b0:3c1:cf88:7b17 with SMTP id
 a9-20020a63e849000000b003c1cf887b17mr8186947pgk.590.1651473792044; Sun, 01
 May 2022 23:43:12 -0700 (PDT)
MIME-Version: 1.0
From:   Forest Crossman <cyrozap@gmail.com>
Date:   Mon, 2 May 2022 01:43:00 -0500
Message-ID: <CAO3ALPzKEStzf5-mgSLJ_jsCSbRq_2JzZ6de2rXuETV5RC-V8w@mail.gmail.com>
Subject: Realtek RTL8156 devices defaulting to CDC-NCM instead of vendor mode,
 resulting in reduced performance
To:     hayeswang@realtek.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, all,

I recently purchased a pair of USB to 2.5G Ethernet dongles based on
the RTL8156, and have so far been very happy with them, but only after
adding some udev rules[0] to to take advantage of the r8152 driver by
switching the devices from their default CDC-NCM mode to the vendor
mode. I was prompted to use those rules to switch the driver because
one of the adapters (based on the RTL8156A) would get very hot, up to
120 F (49 C) even while idle, and the round-trip latency directly
between the pair of adapters was about 3 ms, and I couldn't help but
wonder if maybe the vendor mode might be more efficient.

After performing some tests of latency and power consumption, testing
first with both adapters in NCM mode and then again with both in
vendor mode, I proved my hunch correct. I discovered that, in a
disconnected state, the RTL8156A adapter used about half as much power
(0.64 W -> 0.30 W) while the RTL8156B adapter saw a 21% reduction in
power (0.34 W -> 0.27 W). Similarly, in a connected-but-idle state the
RTL8156A again saw about a 55% savings in power consumption (2.17 W ->
0.97 W) and a 40% savings in the RTL8156B adapter (0.94 W -> 0.56 W).
It was only under full load that the fewest power savings were seen,
with a reduction of only 15% in the RTL8156A (2.23 W -> 1.90 W) and no
savings for the RTL8156B (0.96 W). Similarly, round-trip latency while
idle went from 3 ms to 0.6 ms. I also tested under load and saw much
larger latency savings and reduced packet loss, but forgot to write
down the numbers (I can run the tests again if someone really wants me
too). Also, jumbo frames drastically reduced performance under NCM
mode, while vendor mode handled it like a champ (again, I forgot to
write down the numbers but can test again if asked).

So, with all the benefits I've seen from using these adapters in their
vendor mode, is there still a reason to let the kernel prefer their
NCM mode? It'd be nice to be able to get the maximum performance from
these adapters on any Linux system I plug them into, without having to
install a udev rule on every one of those systems.

If anyone would like to try replicating the results I listed here, or
to perform new tests, the specific RTL8156A adapter I used is the
Ugreen CM275[1] and the RTL8156B adapter is the Inateck ET1001[2].


Curious to hear your thoughts on this,

Forest


[0]: https://github.com/bb-qq/r8152/blob/160fb96d2319cdf64ae7597e8739972934ac83b2/50-usb-realtek-net.rules
[1]: https://www.amazon.com/gp/product/B081TY1WQX/
[2]: https://www.amazon.com/gp/product/B08VN3DGK6/
