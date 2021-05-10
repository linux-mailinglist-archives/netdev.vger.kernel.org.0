Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4AA37902B
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 16:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238721AbhEJOIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 10:08:41 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:37919 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235412AbhEJOBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 10:01:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 14AAD5807B2;
        Mon, 10 May 2021 10:00:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 10 May 2021 10:00:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=benboeckel.net;
         h=date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=fwXudyHn8IUNsmfHA12W5pUxFzr
        IcUsJJs6niPOOwGc=; b=gQh6u0zhPsG//1fbjCgHH3SUq5OZEixVi+ckcNcOvNr
        8f8S6u6OqczboxIeZQzxpdw3AUy1t45vyyuSQKDA1+yJJEqv0Na0yFB8YXQoxGQa
        A5mz/uekXLKQlXSBVpDzZgWHaTwxLQ8cfd/84Seg6MJA86M+DwrG/rxkfmjHnsDx
        Vsn+We4G3Oh5Yvv4HNwlluWEHPMQsGoYqOZqIpzyUGPfcSXaDfcxgaoBasafO20O
        Nia4uZb9+lsHdBKwEogjjnykkTJJzKThWOeq3e2hyjT/F/nLvkiGpnFJ0uMYCJ5w
        yhbph4b45d/9JdizeckN5aTq6WAACtGxOiZQK1Svtuw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fwXudy
        Hn8IUNsmfHA12W5pUxFzrIcUsJJs6niPOOwGc=; b=FkYLunR8+bNyojGntZzlTv
        lNhoU5Ih8GFYdgqBiM9GEeBgkR7PC0rd49vKxgNK2oVHYiwvnJ0pFHee6wyNEefG
        07iyoKlPp2/47lNX2/0a3w6XYC3Muan3VrHn9DIyh2AJDD/sq19lwcD+nClmgOGW
        3kjTJut/WH9S1nO20R6vTeVSVeiFhLK/oh1ul5trEQZynTCu46HI2dcf9dXPVKk9
        sOjDpOdiQFUH6B6gq1Emr8rDL+S3scV3gAHdetS1J2hIDO0dgu0hscWNc8fHxaey
        25F3JvGPZJisNAQmAtq62YqH7TCAIzVvBqJwx8rI9Oyho2YDtxrFPxf1S0VsKOTA
        ==
X-ME-Sender: <xms:hDyZYCqZ48w__j-3J2DdcFFyCNO8Px1wZAdweI2vgyXQ5g_1A_avfw>
    <xme:hDyZYAoPMp-2hhXE5dIuFZVKJLDFR-LeVjsu56BtdhTJGnUi8Md4Pqb1pnf9Vqqdn
    t02Gw-Ku9S6gnwxX4I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttderjeenucfhrhhomhepuegvnhcu
    uehovggtkhgvlhcuoehmvgessggvnhgsohgvtghkvghlrdhnvghtqeenucggtffrrghtth
    gvrhhnpeevffdtteetgfdttdekueefgedttddtueeugeekgeetffeuteffjeduieehhfek
    tdenucfkphepvdegrdduieelrddvtddrvdehheenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehmvgessggvnhgsohgvtghkvghlrdhnvght
X-ME-Proxy: <xmx:hDyZYHO7a0I2ObO3iNQCJFMynfyvzQSxH3x8A4ShPc13xjvG6wh63A>
    <xmx:hDyZYB6OL9_iqJiCXEkFvw1uMnu0UHjkSyxn6Irx0qOidEFWAmkwbA>
    <xmx:hDyZYB472gSq8MYTawlNh6oofIzwaZQvJxltEegElvbnNVF17UiCaA>
    <xmx:hjyZYNFuZhUi4dOrdPamnliiTh3owe6Tf-ewK9C2k9SXGvHlGfVlTg>
Received: from localhost (unknown [24.169.20.255])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 10:00:35 -0400 (EDT)
Date:   Mon, 10 May 2021 10:00:34 -0400
From:   Ben Boeckel <me@benboeckel.net>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, keyrings@vger.kernel.org,
        kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fpga@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-media@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-sgx@vger.kernel.org, linux-usb@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, netdev@vger.kernel.org,
        rcu@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 00/53] Get rid of UTF-8 chars that can be mapped as ASCII
Message-ID: <YJk8gkMlk8dtaEsz@erythro.dev.benboeckel.internal>
References: <cover.1620641727.git.mchehab+huawei@kernel.org>
 <2ae366fdff4bd5910a2270823e8da70521c859af.camel@infradead.org>
 <20210510135518.305cc03d@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210510135518.305cc03d@coco.lan>
User-Agent: Mutt/2.0.5 (2021-01-21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 13:55:18 +0200, Mauro Carvalho Chehab wrote:
>     $ git grep "CPU 0 has been" Documentation/RCU/
>       Documentation/RCU/Design/Data-Structures/Data-Structures.rst:| #. CPU 0 has been in dyntick-idle mode for quite some time. When it   |
>       Documentation/RCU/Design/Data-Structures/Data-Structures.rst:|    notices that CPU 0 has been in dyntick idle mode, which qualifies  |

The kernel documentation uses hard line wraps, so such a naive grep is
going to always fail unless such line wraps are taken into account. Not
saying this isn't an improvement in and of itself, but smarter searching
strategies are likely needed anyways.

--Ben
