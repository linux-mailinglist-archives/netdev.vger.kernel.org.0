Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71D72AA7A8
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 20:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbgKGTfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 14:35:33 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:33377 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725836AbgKGTfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 14:35:31 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 08DCBCC1;
        Sat,  7 Nov 2020 14:35:29 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 07 Nov 2020 14:35:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bernat.ch; h=
        from:to:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=aErFnEm0Eb/dEprImF/xsdD28n
        WRLMSYfp+HGIVb8Ic=; b=dREt04VkgDQFsIEvgNKUZ12p9zGqjggjW1OiqNH/69
        P09zUQWWsqLGbH60DCKyIpFbUh1mCGiRLe7aeB9Zt8ng6VlV01N9uYDi00/uQtOe
        uyTzt8M1kKqxy1ZnPhVofXnB5aJBye5634xO0nZ7Mc7Q+p1D+dFD7/0Wv0IBM45S
        cZLRnrA8ypMLPs+CLSdXETfZItLWdYwvoCEsIKDIpYxtcC9YeGsQ5BBMlHbvxkz+
        0peMsUTT/YAfPkGZd04WoTh0UsZOlt3fUEshmIikiatkexP7PhCmXU86CK6JKDg1
        flFH4J8TWg4fgnOIqkLmb4OMVzWFKcB+Umv9bI1EnVvg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=aErFnEm0Eb/dEprIm
        F/xsdD28nWRLMSYfp+HGIVb8Ic=; b=jrM5jblphjW9lU2u7l7L2UmiqIweQ6ijb
        62EJuGzWZeXa3SFV9uhakHpU3aDlv7PtKOULOEexZxL+xOD1xP4mp5ewzgFgHqdK
        IiO8cVEh/khIi0/GoJXHBI4H/LsjCyBgF5HwoSkXuFH3VKjC2fMJFDrhUk14DXS5
        LaNorJmHT75C3DzDA8xgZLTlmpOFJwQ9EUNq0w5irW4LGcWtbEDu9asPnJqj2/Gt
        uc4nkrSH3nr6MXGt/mXxarVEJcTgi9WCvqrZ0vXGLSnyaWUXl0ODGQFVevfmEsqa
        HxBSqSWecElu3jmo3+WLk0GmfbMYyjxG2zHMUNbHumF0yUXC2rSRQ==
X-ME-Sender: <xms:APemX41Qb47okNpVC0DeFBp4CpJBc3JBe9nHRZDkp09WB-EfPv4bTA>
    <xme:APemXzEWtnf00lGWuIBAa8AV8Fh-nqjNXoNtN8FFzoxqWnDrj8i7cEfL-Fcvn49zq
    V5zaK14Go4ZOINKeUc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduuddguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepgghinhgtvghn
    thcuuegvrhhnrghtuceovhhinhgtvghnthessggvrhhnrghtrdgthheqnecuggftrfgrth
    htvghrnhepvdeiffetueektdelveffhfdvfefgtdffhedtudekteevfffgvedtfeehveff
    hefgnecukfhppeekiedrvdegvddrkedrudeijeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgrtheslhhufhhfhidrtgig
X-ME-Proxy: <xmx:APemXw7RA3ts6AzL7e9CEaqzlg1haoFe64wDRmgSc5IYNXMl7ENZPA>
    <xmx:APemXx0DPvDAaD1Qx9hKH2lP-ymeI2p7DrlhKLeAAw8so7eWJa_Qdw>
    <xmx:APemX7ElM0L7yEWijgoEm8pLJb5y2HCHY0VtQRA4Y7ykZXxLKEfVqw>
    <xmx:AfemXzCb_mT9nV8BqbbIH5e0ytvyK7p4OD6ftv9jN2bShztOTMqdRg>
Received: from neo.luffy.cx (lfbn-idf1-1-619-167.w86-242.abo.wanadoo.fr [86.242.8.167])
        by mail.messagingengine.com (Postfix) with ESMTPA id 04F5330614AA;
        Sat,  7 Nov 2020 14:35:28 -0500 (EST)
Received: by neo.luffy.cx (Postfix, from userid 500)
        id 6BDF1A17; Sat,  7 Nov 2020 20:35:26 +0100 (CET)
From:   Vincent Bernat <vincent@bernat.ch>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: net: evaluate net.ipvX.conf.all.* sysctls
Date:   Sat,  7 Nov 2020 20:35:12 +0100
Message-Id: <20201107193515.1469030-1-vincent@bernat.ch>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some per-interface sysctls are ignoring the "all" variant. This
patchset fixes some of them when such a sysctl is handled as a
boolean. This includes:

 - net.ipvX.conf.all.disable_policy
 - net.ipvX.conf.all.disable_policy.disable_xfrm
 - net.ipv4.conf.all.proxy_arp_pvlan
 - net.ipvX.conf.all.ignore_routes_with_linkdown

Two sysctls are still ignoring the "all" variant as it wouldn't make
much sense for them:

 - net.ipv4.conf.all.tag
 - net.ipv4.conf.all.medium_id

Ideally, the "all" variant should be removed, but there is no simple
alternative to DEVINET_SYSCTL_* macros that would allow one to not
expose and "all" entry.


