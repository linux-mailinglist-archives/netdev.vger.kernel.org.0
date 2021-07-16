Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7226F3CBCA2
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 21:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhGPTfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 15:35:17 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:55331 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231715AbhGPTfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 15:35:14 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id C2C163200909;
        Fri, 16 Jul 2021 15:32:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 16 Jul 2021 15:32:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=animalcreek.com;
         h=date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=OLLt4rGNVAu8jJhkBVYgJExcmT2
        QBI1XXhNObcl8su8=; b=aa13BIQOss1hQCY4wLFOX9npRr8DztT8k7zUW8jnzJX
        /nMGPwX/NC+hVgEfj3+oWpcqmtWnc4H5Rt9WVacErNJZDUVwiKoCuYX3MitUxwNp
        vTPBOBN/w3RCYeWJEb9UF/O5RqXNZNIeHNuj/NU6PNY0uNIC7wxh+obYOj0eXJ5F
        1IRZ9IfJhIyJCJIKvPUuDD1e0ar9qgtviO44wdLAhbTIaLpvHlZu66OAvp4T8+67
        j/qr5PGO7t4QjmhssldkMjO+bHovwVCM+0/Nbc4ZhRGdlUl/off6dckMeiLBbkXX
        X39HOx2e/3WuiP9ebig3KHtha6tnrD2crG2/v+C3cdg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=OLLt4r
        GNVAu8jJhkBVYgJExcmT2QBI1XXhNObcl8su8=; b=KtCsouRi3ZCJ2vsx5ExiVt
        n4+8AtWRFzE17vS8Azbz6ehAN8Xd+tefa236GnjNgB7X7zJErd4mHWupzAlt2spy
        2srO0ov+IUyyzF6qmtw4m5qHSdyaBmVe32VruXxd+4tWXgKzGK61Uta4UW/YeRAQ
        jVYS4S+yrku679q3gYDdKGSmashVaomJcYMcSyFJpOHqmW7pzZd4WdSv8OFaemiF
        odv65p75tAqX6kz30+EaAbLvjocHtyNyEsTcow8glL4+HPgL2CY+iFWUjTXE3y/Q
        8WvsCPe7xxY3cR5d+fJZdSN07BAPOHRAP7LZidHn/qQee5F9NCuM55XpDFNcv4Gg
        ==
X-ME-Sender: <xms:wN7xYIWqIVT9JRvodBdW2Cr21_eNYvgHyhiyaGsmCC0kvTDLzqdOFw>
    <xme:wN7xYMk0G-J-x2Q_PuECiSEgfoRyNR1CX3YEJVdwsswUI0p3giACH-KhKYLFdorjy
    6TCwBfHkvEWxRVINw>
X-ME-Received: <xmr:wN7xYMZnrqVPFLz7SUyB63sfQYkESxK6VbVkP98cTa6OY1XfkMu8NeE2uRrCr-asAd8Ip2lRt0fsdA5qNNQHqjZZl-ftaFuyDSBc4s4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefgdduvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjohesthdtredttddtvdenucfhrhhomhepofgrrhhk
    ucfirhgvvghruceomhhgrhgvvghrsegrnhhimhgrlhgtrhgvvghkrdgtohhmqeenucggtf
    frrghtthgvrhhnpedujeelgeejleegleevkeekvdevudfhteeuiedtleehtdduleelvdei
    fffhvdehtdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhhgrhgvvghrsegrnhhimhgrlhgt
    rhgvvghkrdgtohhm
X-ME-Proxy: <xmx:wN7xYHV_6d87NS_7y4Mt2jrr4MLAmu4Vo3wlgKD5eUub5oAfqkuZvQ>
    <xmx:wN7xYCknDlFPw0WWMsy5YFTRf9Jqn5MZBeWFeWj0K0flK7JWlwYxHw>
    <xmx:wN7xYMce6GI0j_9yBxh3yNVO8XJyzIK-qNBg8euZZUiW0OEJE6ukeg>
    <xmx:wd7xYJvmbwZ9tKdp_-FUWFwdv78ILaccBI93cYvQ59QFfxf56KPnig>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 16 Jul 2021 15:32:16 -0400 (EDT)
Received: by blue.animalcreek.com (Postfix, from userid 1000)
        id 4050B1360093; Fri, 16 Jul 2021 12:32:15 -0700 (MST)
Date:   Fri, 16 Jul 2021 12:32:15 -0700
From:   Mark Greer <mgreer@animalcreek.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Mark Greer <mgreer@animalcreek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nfc@lists.01.org
Subject: Re: [linux-nfc] Re: [PATCH 1/2] MAINTAINERS: nfc: add Krzysztof
 Kozlowski as maintainer
Message-ID: <20210716193215.GA597092@animalcreek.com>
References: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
 <961dc9c5-0eb0-586c-5e70-b21ca2f8e6f3@linaro.org>
 <d498c949-3b1e-edaa-81ed-60573cfb6ee9@canonical.com>
 <20210512164952.GA222094@animalcreek.com>
 <df2ec154-79fa-af7b-d337-913ed4a0692e@canonical.com>
 <20210715183413.GB525255@animalcreek.com>
 <d996605f-020c-95c9-6ab4-cfb101cb3802@canonical.com>
 <20210716171513.GB590407@animalcreek.com>
 <CA+Eumj7SPFXOMUGRxZqjG-0Jq_1EnWwh9Ny-a=+QsN8tfrrCwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+Eumj7SPFXOMUGRxZqjG-0Jq_1EnWwh9Ny-a=+QsN8tfrrCwg@mail.gmail.com>
Organization: Animal Creek Technologies, Inc.
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 08:17:31PM +0200, Krzysztof Kozlowski wrote:
> On Fri, 16 Jul 2021 at 19:15, Mark Greer <mgreer@animalcreek.com> wrote:
> > > I am happy to move entire development to github and keep kernel.org only
> > > for releases till some distro packages notice the change. If Github,
> > > then your linux-nfc looks indeed nicer.
> >
> > Okay, lets do that.  I'm the owner so I can give permissions to whoever
> > needs them (e.g., you :).
> 
> Then please assign some to the account "krzk" on Github. Thanks!

Done.
