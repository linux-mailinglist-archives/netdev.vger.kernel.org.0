Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6C152AD68
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 23:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244097AbiEQVR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 17:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiEQVR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 17:17:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB342522E0
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 14:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652822244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0MMhuSzxVH8fFFuKt3ISY791VJcfxJlI8uGnfzcDavw=;
        b=VyjicP6kuLp+BUQ6p6g6ObSnZ20adYu41/e37jUvZoBVmXhAWc68zG6i6ThiywSJ1e5/zR
        LQY69e/zLpWdl4qaoiJ9nB5AA2z0dVc6I4RM1odQiK6yGbYexknxxOplvtJgIfUmB1tchl
        Pkxvro5JOeKPJXG7o/QSM6VVsEXy84U=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-546-OSMCYYMuNIy4lPZxDduelw-1; Tue, 17 May 2022 17:17:23 -0400
X-MC-Unique: OSMCYYMuNIy4lPZxDduelw-1
Received: by mail-qv1-f71.google.com with SMTP id p4-20020a056214122400b00461c2b40243so120599qvv.8
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 14:17:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:from:subject:to:cc:content-transfer-encoding;
        bh=0MMhuSzxVH8fFFuKt3ISY791VJcfxJlI8uGnfzcDavw=;
        b=MeMS+nirikamkzMO+MmysLVKgjd8bOuKUJE0EiHcnVBGIND/vigKo+Ytol+tBKGFTW
         5OeDm1XfNBdeMB40KK5reomNrH7OHa4N9BEMG4DWWwCP3/CTAWrmtR90MkzzVKHzcvd8
         YYTtIgMkMry4OYORu/T4Wf8z/Td9oWu/QLduZjTdLFfHsKP3mSDvBE21HGVXTL6I7eJz
         Eo41oiVn53k2ZCrNOGThs50Gids1D/PUjFoSYmyn+gChWfKpa9ch509DMSFdK8pwJNwm
         MijUJza77T9ChXtUu/GTUAnVph4UUY6d9vvHUbrGfPcc6eqs2Z4y2bWd+5MfGJRJXtSs
         bvag==
X-Gm-Message-State: AOAM530tkAYfFMBM6SmiBUs9z/CoDtr+LCBHTL/LOPxlXn1aBktxc/pV
        0+lsjHdPnh4xR8eTMqv1ROw9LbcGu9lcBZNxVqd6fTcI4aOAUQzC5Y5MRAE5cXocLbxuH6gqN17
        eo3pY5YB4/wkXSXhwLhYgiEs/JkyZhQS0ry6X4PssSoRDJPD5ibwSaYbrN/8rfO/pylWn
X-Received: by 2002:a05:622a:1aa2:b0:2f3:bad3:b506 with SMTP id s34-20020a05622a1aa200b002f3bad3b506mr21582959qtc.272.1652822242337;
        Tue, 17 May 2022 14:17:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLjKRK6l1MYW3W/VwY+81jhxT4Lm3WxoHtyjBeIbRKyuodvKCF/YndUMkYjW3SaKpEJDLBzw==
X-Received: by 2002:a05:622a:1aa2:b0:2f3:bad3:b506 with SMTP id s34-20020a05622a1aa200b002f3bad3b506mr21582934qtc.272.1652822242025;
        Tue, 17 May 2022 14:17:22 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id e4-20020a376904000000b0069fe1fc72e7sm166136qkc.90.2022.05.17.14.17.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 14:17:21 -0700 (PDT)
Message-ID: <de8d8ca4-4ead-0cef-1315-8764d93503c1@redhat.com>
Date:   Tue, 17 May 2022 17:17:19 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
From:   Jonathan Toppins <jtoppins@redhat.com>
Subject: [question] bonding: should assert dormant for active protocols like
 LACP?
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So running the following script:

--%<-----
  ip link add name link-bond0 type veth peer name link-end0
  ip link add bond0 type bond mode 4 miimon 100
  ip link set link-bond0 master bond0 down
  ip netns add n1
  ip link set link-end0 netns n1 up
  ip link set bond0 up
  cat /sys/class/net/bond0/bonding/ad_partner_mac
  cat /sys/class/net/bond0/operstate
--%<-----

The bond reports its operstate to be "up" even though the bond will 
never be able to establish an LACP partner. Should bonding for active 
protocols, LACP, assert dormant[0] until the protocol has established 
and frames actually are passed?

Having a predictable operstate where up actually means frames will 
attempt to be delivered would make management applications, f.e. Network 
Manager, easier to write. I have developers asking me what detailed 
states for LACP should they be looking for to determine when an LACP 
bond is "up". This seems like an incorrect implementation of operstate 
and RFC2863 3.1.12.

Does anyone see why this would be a bad idea?

-Jon

[0] Documentation/networking/operstates.rst

