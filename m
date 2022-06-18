Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E41E55014E
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 02:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383636AbiFRA1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 20:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237031AbiFRA1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 20:27:49 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF8A11810
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 17:27:48 -0700 (PDT)
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 7A57B3FBF5
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 00:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1655512066;
        bh=dGG+fDyJsKyya6AqvIAsYyiUL2jM7VioR7e5sB5N5Vc=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=s0CpwL63crx0nfv8Mf9kTfnxcIPJn7zt9Kcot/7X/1duujkNZIlvx73ID3SaMVWLx
         owXIiMhXEDzZeSYIxWMjfq7VpcwEHyu7JFv5FUdkYPbyLiagBKHR5s8r+EHcSco9Tn
         SIjscfzeY6khlPeHDolRUyJdNcMfPldoSRdK2W68kh9tJnsCHGoGinwegkoyqXygQN
         bQRpez98W3+811Ps3YF9azJIXrCucAZ3O2zKizCzV69juyZjbXPnjlTE8+qdubKAc/
         e5RwyOSlQE++ufMM/4U1yiGellRbmD1pAVNLZstHUHl0fw8sOFGlgXrr6OuSbp8YI0
         5LQWAwAo8xoew==
Received: by mail-pg1-f197.google.com with SMTP id q8-20020a632a08000000b00402de053ef9so2927825pgq.3
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 17:27:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:date:message-id;
        bh=dGG+fDyJsKyya6AqvIAsYyiUL2jM7VioR7e5sB5N5Vc=;
        b=wfCItmiwqNGJEVB9/HNaxxJmyKUjfmYc7a5Ze/Gx1RW2NwP14vyewzbruq94czFl3g
         6Snaa76zmZs4Us/VDIPeyAPPW/jgnThGDqK71bxWwTBnfdjUFwWxPxmc7csNCVIhEhQD
         wz83rJyy/uVXw4x0b9n/TR0nZC10VZLWWjO3GEY9H85+saOK/QHwk1cfxxalTRxctbyZ
         5ip/rWkN3mF/M8p2ztzKyoCPZxd+aBy3n6RsPoRNAj1usF2uDXLadN2A4FfciHJo25M4
         Cftq+EcN002LHaZp6qlUziGG5u86Laj3fNP+I1o55oiApIzdFmr3K50J6qiDOz8s6o7E
         qOAA==
X-Gm-Message-State: AJIora9FlRGVIfLZnneHdaD6M8vcjm17fs26GxGvCxz4+/FWLiBB4fKx
        rYMkBDPvxSFbeXFiXme+y4/uqM79FuXyXmO++JrN+wj/n41Gp1dKOLHjtjX94IJE1OjhqyiJLTS
        tYZIbIk9DH/zJ8H59skzG42DxjtWAK4lRVw==
X-Received: by 2002:a65:6cc8:0:b0:3fe:2b89:cc00 with SMTP id g8-20020a656cc8000000b003fe2b89cc00mr11096461pgw.599.1655512064814;
        Fri, 17 Jun 2022 17:27:44 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tCjwHyrBlVaDm3Q6HuDLlx3fcHoXcnX4XCLuwf3yvPvZ1TWzEMNaW+bVAnmZlnjz/1GFyYPQ==
X-Received: by 2002:a65:6cc8:0:b0:3fe:2b89:cc00 with SMTP id g8-20020a656cc8000000b003fe2b89cc00mr11096439pgw.599.1655512064485;
        Fri, 17 Jun 2022 17:27:44 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id u22-20020a62d456000000b0051c70fd5263sm4251026pfl.169.2022.06.17.17.27.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Jun 2022 17:27:44 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id A7A6C6093D; Fri, 17 Jun 2022 17:27:43 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id A0350A0B36;
        Fri, 17 Jun 2022 17:27:43 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jonathan Toppins <jtoppins@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net] veth: Add updating of trans_start
In-reply-to: <20220617124413.6848c826@kernel.org>
References: <9088.1655407590@famine> <20220617084535.6d687ed0@kernel.org> <5765.1655484175@famine> <20220617124413.6848c826@kernel.org>
Comments: In-reply-to Jakub Kicinski <kuba@kernel.org>
   message dated "Fri, 17 Jun 2022 12:44:13 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28606.1655512063.1@famine>
Date:   Fri, 17 Jun 2022 17:27:43 -0700
Message-ID: <28607.1655512063@famine>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

>On Fri, 17 Jun 2022 09:42:55 -0700 Jay Vosburgh wrote:
>> 	In this case, it's to permit the bonding ARP / ND monitor to
>> function if that software device (veth in this case) is added to a bond
>> using the ARP / ND monitor (which relies on trans_start, and has done so
>> since at least 2.6.0).  I'll agree it's a niche case; this was broken
>> for veth for quite some time, but veth + netns is handy for software
>> only test cases, so it seems worth doing.
>
>I presume it needs it to check if the device has transmitted anything
>in the last unit of time, can we look at the device stats for LLTX for
>example?

	Yes, that's the use case.  

	Hmm.  Polling the device stats would likely work for software
devices, although the unit of time varies (some checks are fixed at one
unit, but others can be N units depending on the missed_max option
setting).

	Polling hardware devices might not work; as I recall, some
devices only update the statistics on timespans on the order of seconds,
e.g., bnx2 and tg3 appear to update once per second.  But those do
update trans_start.

	The question then becomes how to distinguish a software LLTX
device from a hardware LLTX device.

>> 	I didn't exhaustively check all LLTX drivers, but, e.g., tun
>> does update trans_start:
>> 
>> drivers/net/tun.c:
>> 
>>        /* NETIF_F_LLTX requires to do our own update of trans_start */
>>         queue = netdev_get_tx_queue(dev, txq);
>>         txq_trans_cond_update(queue);
>
>Well, it is _an_ example, but the only one I can find. And the
>justification is the same as yours now -- make bonding work a31d27fb.
>Because of that I don't think we can use tun as a proof that trans 
>start should be updated on LLTX devices as a general, stack-wide rule.
>There's a lot more LLTX devices than veth and tun.

	I'm not suggesting that all (software) LLTX software devices be
updated.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
