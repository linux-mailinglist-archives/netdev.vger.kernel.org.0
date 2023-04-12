Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBBE96DFF75
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 22:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjDLULt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 16:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjDLULs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 16:11:48 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E75659C
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 13:11:46 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id c3so13771664pjg.1
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 13:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mistywest-com.20221208.gappssmtp.com; s=20221208; t=1681330306; x=1683922306;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A5Pok9xdKAe+IxVTyn72c81IrSUtFk9gECcYU1++fc4=;
        b=vM1C9AL8SiVOeQx3TGsN4nfDTULtrbQhnE0j/LW3nFi9CraAkZhYmQ8OThS0ULxM/b
         UN4foGYmiy3SQzbzVQdlu/dj3uN8+yYhOwtrv1qJbFPu+D43z/KEEPQHAPW4SHUN/HFI
         k/d4QsdieopTX6nUssqsaQ7l3fOmsTS41y4IFcb7IJA32BLB0SJpG7x8fBFtARcmGWTJ
         iNA71jhGaHGCxZ0Ehh++w943tlina8xuEs5wytdYhaOQqir/NbCm74lnqLsxM8rx7tX0
         J8vi712gjUZkDpE7WiAJvnLtyhhYEcPk2Rv6w/dp61IkNMV3ENlm2u9qRSi5SR2h8IeU
         +IVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681330306; x=1683922306;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A5Pok9xdKAe+IxVTyn72c81IrSUtFk9gECcYU1++fc4=;
        b=I55Tpz/EpUytJACh0nwb7KJCLKy78q5t3U+PGXyIu6N5ZAGlNtgp7+WzDQIFapEJ4o
         WjQcAHwH1pe4c39SWwaVcpvl/XwIqugfh+/d20UCPG/xQmR3SEc/GCgn7nVsPcbaEBMW
         wWy+VmcSdb10kndcZrLIu8zIdRiqXU3uTiIKkjBcnl9jSjjUyFw+coD7OLFi7BCNE7En
         Z24yt5RsiDuhQt0H3tuCooSPOU45h+PV0Pt8I6IrgTWCUJvDTuyCI0GTVuZqTSL73i8Z
         pWrG99c2Melqz1Xbj3Q8e5jPJkrE62Jal57OaQ7XVKPGrjLzLmJfKRaRMp821Ys6L4i0
         p5WQ==
X-Gm-Message-State: AAQBX9ch0q2bfHJkia9h3JbVHp98kww3/LZnOLRS2ZJQl+yxU7gcDSLP
        GTPOj9FhmpdPzlsQlZCdyiGNsKnd33BoH9c1lW9YlA==
X-Google-Smtp-Source: AKy350aGrnighth/9Tpc+FpP3G3WVHmxHIzpm649upSy580Qk97CJQh8t+uXXho2U3/xc+r15J8L9g==
X-Received: by 2002:a05:6a20:9324:b0:d9:9e33:7218 with SMTP id r36-20020a056a20932400b000d99e337218mr7509678pzh.1.1681330306083;
        Wed, 12 Apr 2023 13:11:46 -0700 (PDT)
Received: from [192.168.100.190] ([209.52.149.8])
        by smtp.gmail.com with ESMTPSA id i26-20020a63221a000000b0051a3c744256sm5150535pgi.93.2023.04.12.13.11.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 13:11:45 -0700 (PDT)
Message-ID: <5eb810d7-6765-4de5-4eb0-ad0972bf640d@mistywest.com>
Date:   Wed, 12 Apr 2023 13:11:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Content-Language: en-US
To:     netdev@vger.kernel.org
From:   Ron Eggler <ron.eggler@mistywest.com>
Subject: issues to bring up two VSC8531 PHYs
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
I am trying to bring up a pair of VSC9531 PHYs on an embedded system. I'm using a Yocto build and have altered the device tree with the following patch:
https://github.com/MistySOM/meta-mistysom/blob/phy-enable/recipes-kernel/linux/smarc-rzg2l/0001-add-vsc8531-userspace-dts.patch
I installed mdio-tools and can see the interfaces like:
# mdio
11c20000.ethernet-ffffffff
11c30000.ethernet-ffffffff

Also, I hooked up a logic analyzer to the mdio lines and can see communications happening at boot time. Also, it appears that it's able to read the link status correctly (when a cable is plugged):
# mdio 11c20000.ethernet-ffffffff
  DEV      PHY-ID  LINK
0x00  0x00070572  up

Yet, ifconfig doesn't show the interfaces and I get:
# ifconfig eth0 up
[  140.542939] ravb 11c20000.ethernet eth0: failed to connect PHY
SIOCSIFFLAGS: No such file or directory
When I try to bring it up

# ip l displays the interfaces as:
4: eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether 9a:ab:83:16:65:36 brd ff:ff:ff:ff:ff:ff
5: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether 2a:9d:bf:09:8d:c3 brd ff:ff:ff:ff:ff:ff

Where am I going from here? I have experimented with drilling down into bitwise analysis of the MDIO communications. I'm uncertain though if this is my best bet, does someone here have any insight and can provide me with some guidance?

Thanks a lot!
-- 
Ron

