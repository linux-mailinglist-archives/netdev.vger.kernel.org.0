Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5902122F3D
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 15:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbfLQOuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 09:50:09 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:42573 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727127AbfLQOuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 09:50:08 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id A9CCD6395;
        Tue, 17 Dec 2019 09:50:07 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 17 Dec 2019 09:50:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=4cIp2F9GZx6Q23WhgNIogqD6bW4
        O5qNKgcTSyASlC+E=; b=Gi07bExCvjAN5nuKqBLZG/2jy5AaWcQ5uMg2TpS9idd
        f2DZOM9lxNYv9Q2HIyHURhjyE3bAdY+wNeNSry5kiy6k0sqTi+z5AZTF46LMqSZI
        9geI4AMMqQVK3ZxvSsg05x/u8nASRNEIpLq9mLRPJg3p5+cggr7QAiqegfRs6fm7
        QNrXkJo64FxdVy+rT1GyGWzoLbQMBkEWBRUQKJe9PPynJIyOuNa/nyMn3TAqAUOO
        /HDqWXqb5F8beAz6aLOSOmQzj/CwcM1Ll4HQspIBcdb/mrRcDGr6Dy8Bwjt/Qhjb
        7y6nAjOfqn6c5TQ3KObMY0LG9RukN00NgofzHxBAQRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4cIp2F
        9GZx6Q23WhgNIogqD6bW4O5qNKgcTSyASlC+E=; b=IN/hScjOmdr2LXAzMFThmY
        ftq7zHz6ZA/FdebKUxQpUUk+NucUKkdRie8EoGP0M6ZXK/hNJubRrah3mU+7DDYg
        ji4QQvChsgXOd/FpV+sNZLWb2utwe3vJM0y7SYtbccJCiZtCczioOyLW9a6exeTL
        Da9qBZwlaFSDKmxdnCL+kyqVNOd/AGS345lkeQfvWpHWq/PwZ3Lco3xvNx9p5nLj
        qeTNhJe49U0HM+oSy2ZX6o+I/VFCCodJpCyqAt2BCuF6iwCupzhdfU6LRGFZeq5k
        N2eOivd26k9D5AuLw2hcmzu8H1TOzA3wwImkNZg9tj5EhQLLz4Du8WxkBA5nDnqA
        ==
X-ME-Sender: <xms:Huv4XaE6IPHj7TGEPCGQcFoOIxspKi3_l63oR-zCZNwWF1JLdQyXhQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtjedgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepgh
    hrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Huv4XWeD6OmVXRDK67xOb7vsMpbu-4WODJ4MAJ2mFsAWOc43DngMKA>
    <xmx:Huv4XbBgeDOnz5WCr93LDCx1d_VmpipmdFnHavoE60aJzEf4rE5JLw>
    <xmx:Huv4XZZ54qRO_THZMvYkAtsSmgxGaFQtetIlonFHtaXeRd7O1TVp9g>
    <xmx:H-v4XX43xI83jWx_a8WhLOU7T4gfG6swGrFd7heNb0ixK98hQnvaMQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 25BD880064;
        Tue, 17 Dec 2019 09:50:05 -0500 (EST)
Date:   Tue, 17 Dec 2019 15:50:03 +0100
From:   Greg KH <greg@kroah.com>
To:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Cc:     "Enrico Weigelt, metux IT consult" <info@metux.net>,
        linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, dmitry.torokhov@gmail.com,
        jacek.anaszewski@gmail.com, pavel@ucw.cz, dmurphy@ti.com,
        arnd@arndb.de, masahiroy@kernel.org, michal.lkml@markovi.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        linux-gpio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] RFC: platform driver registering via initcall tables
Message-ID: <20191217145003.GB3639802@kroah.com>
References: <20191217102219.29223-1-info@metux.net>
 <20191217103152.GB2914497@kroah.com>
 <6422bc88-6d0a-7b51-aaa7-640c6961b177@metux.net>
 <20191217140646.GC3489463@kroah.com>
 <d938b8e1-d9ce-9ad6-4178-86219e99d4df@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d938b8e1-d9ce-9ad6-4178-86219e99d4df@metux.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 03:43:56PM +0100, Enrico Weigelt, metux IT consult wrote:
> On 17.12.19 15:06, Greg KH wrote:
> 
> > That's not needed, and you are going to break the implicit ordering we
> > already have with link order.  
> 
> Ups, 10 points for you - I didn't consider that.
> 
> > You are going to have to figure out what
> > bus type the driver is, to determine what segment it was in, to figure
> > out what was loaded before what.
> 
> hmm, if it's just the ordering by bus type (but not within one bus
> type), then it shouldn't be the big deal to fix, as I'll need one table
> and register-loop per bus-type anyways.
> 
> By the way: how is there init order ensured with dynamically loaded
> modules ? (for cases where there aren't explicit symbol dependencies)

See the recent work in the driver core for DT fixes for that very issue.

greg k-h
