Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B5957F7D4
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 02:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiGYAsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 20:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiGYAso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 20:48:44 -0400
Received: from meesny.iki.fi (meesny.iki.fi [IPv6:2001:67c:2b0:1c1::201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3565EFD3F
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 17:48:43 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com [66.111.4.228])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hendry)
        by meesny.iki.fi (Postfix) with ESMTPSA id 0FD6E20093
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 03:48:39 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
        t=1658710120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=oamKDRKjSR+hAXdsuB2OwYwJAM0xqkGG7iXZgEMO4co=;
        b=eohB7zH1Nte6dQ9lRO+Dm6bYEJFjp765tUkTsKSCLfTRcMpc11tm8BnF590VoO/pL937yj
        EU86E1WoziiXzlcoDv2AgUQY1dXL+Zdy91DQOUtcUxC0onZn7eSuAfGUuOTgplxQytjRlx
        DoFVgrrAaS6MCrJ6vBsL79+MCco2jGs=
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailauth.nyi.internal (Postfix) with ESMTP id 80D2627C0054
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 20:48:36 -0400 (EDT)
Received: from imap43 ([10.202.2.93])
  by compute5.internal (MEProxy); Sun, 24 Jul 2022 20:48:36 -0400
X-ME-Sender: <xms:ZOjdYqUV6jRz8NLqaES7H7V9hK7QQRx7hHJ8LCqu_EaYGT0eSi3ydQ>
    <xme:ZOjdYmmRLylsAb5D_jn8cEuVAVSGF5fxIksbzlw_9_YkS-n_zCbQII6qsZ3m9YPfd
    xEW9lgVzAssGbQE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvddtjedggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefofgggkfffhffvufgtsehttdertd
    erredtnecuhfhrohhmpedfmfgrihcujfgvnhgurhihfdcuoehhvghnughrhiesihhkihdr
    fhhiqeenucggtffrrghtthgvrhhnpedtveefueduudekueeljedtueetteekffehfefgle
    fffffguddvheefjeffueeiueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpehhvghnughrhidomhgvshhmthhprghuthhhphgvrhhsohhnrghlih
    hthidquddthedviedvleduvddqudduheegvdekieelqdhhvghnughrhieppehikhhirdhf
    ihesfigvsggtohhnvhgvrhhgvghrrdgtohhm
X-ME-Proxy: <xmx:ZOjdYuaXEVjMcKzXwAZ12J-eAtA-LPGpMqnj32nURxFxx5Jx4bgsEg>
    <xmx:ZOjdYhW94Q6nVcpTL0fs1AzRRUtCEC-dP4y-gB-TEVuJTkDYxL03AQ>
    <xmx:ZOjdYkkknucia8uLS1EIVJ6-uniHubscuOgEoH3e57OEb5smeVtBHA>
    <xmx:ZOjdYpwRRGYWN3-XJOOqbN0y9A0pyD4BAx2TdmBx3mHHDua7bNKBUw>
Feedback-ID: i1a9947e8:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 25D032D40074; Sun, 24 Jul 2022 20:48:36 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-757-gc3ad9c75d3-fm-20220722.001-gc3ad9c75
Mime-Version: 1.0
Message-Id: <c7aa5278-5c8d-4d76-96d7-bb52244786e9@www.fastmail.com>
Date:   Mon, 25 Jul 2022 08:48:15 +0800
From:   "Kai Hendry" <hendry@iki.fi>
To:     netdev@vger.kernel.org
Subject: Find IP address of active interface
Content-Type: text/plain
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=meesny; t=1658710120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=oamKDRKjSR+hAXdsuB2OwYwJAM0xqkGG7iXZgEMO4co=;
        b=daFFcWeEcoDEKeNAXCJsl0yCeqfuHptHDvt287m4gpsJbSbuC0LCEapRXX+5WKM6HKCe92
        RxYG+d9PH9adF61P/o2eSVew6dTSCAqkIcu8fb+krvK6vWw7nW5vvYfcqpT8MaAVH+Z7Ey
        JiWBa2LcK7NP2vVevF/hsRr2bI0/JFg=
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=hendry smtp.mailfrom=hendry@iki.fi
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1658710120; a=rsa-sha256; cv=none;
        b=hWNhTa5WgcqJRFFPzyQ5oIQGUb/jc4d5xc0HNWEyGnRMGSdXE8c0/LvlTDTfJxw5fKdNQs
        O6rn/f9h4yzq2GDLad/Z7mnOrVC4VoAkKQsdTRMQ7hALuWschEweDT9zYtFdiTwPnDxaaF
        SyCvDF6jTSHob4dk+7dE5rB68T6bZyI=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Is there an easier way than:

ip route get 8.8.8.8 2>/dev/null|grep -Eo 'src [0-9.]+'|grep -Eo '[0-9.]+'

To figure out the active, Internet routing interface?

Thank you,
