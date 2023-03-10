Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99FC6B516D
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjCJUHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjCJUHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:07:12 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425D9126F06;
        Fri, 10 Mar 2023 12:07:09 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 407C932003C0;
        Fri, 10 Mar 2023 15:07:06 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Fri, 10 Mar 2023 15:07:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1678478825; x=1678565225; bh=0a
        Ymj5tx8ig6QH6sJhzcEPY7Nw5ZBynuJPqxTvDXknM=; b=X5SC3oGJ1EZkFs8ADD
        QVEjij51GN0LONEbpD6hZlYAnCAyOxHB/gFebYyrdKkWFPpYeZ8Ekojii9DGHmhk
        NuBEKgBccRnqnpkf1bwkTbG11Wx6ZsIYpEcAjpvDZwqR+r8If9LLEn3/3tKl5jiR
        KIXh71Rvp5EdS8mY+Vv6InffJAiSovUyHbykouSLymLzscVVo4JAdCHSEMTfRFbj
        kufQxdZbwlk6CjcOy1VRp48RBpwGu2jRTDwJ3oRtPok05nduJx58UG6oBsp0Hi/q
        sYvXorvn29xBldNcEVVc5Ce/4US4FzQCRi9b++9OBz4s/c5OwEmgHrWPnCi80hSp
        Ve3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1678478825; x=1678565225; bh=0aYmj5tx8ig6Q
        H6sJhzcEPY7Nw5ZBynuJPqxTvDXknM=; b=emaikchmYYs5S9yN9qw7620/5cxeP
        a3pzILMyUL+Iz3TjbcPSeUXhgluPzTHXu8eshOEMhlwZ+3pantwcpDBDUcd094Ms
        yIHZwVPKdwGZuAWeMmyA72Ef8Oh+qipTK7xSr3tbXRyyNBYAJXzMuiuGpEqWC8p6
        wYyXGsZOITWS8h5trFBjkrAHuvxaqgefwN/KYDFuubn6liRXjPXhUpZatSA71ukZ
        LaGMcwPgrJsjT55ocE/nyMeVyKwSNgR1UuGCNS2ova0zrXDx3FwOUN9LMspMbt4W
        9sor26Ysa7FuEcRPKgHz64QhVDVvJYj/gmOnGGf6uftFm3EEsaaEGZ+mA==
X-ME-Sender: <xms:6Y0LZL4hM-WTjE7oYScaxRaC4bmFlHc401-aeXrUMWqRgx2kKUepdw>
    <xme:6Y0LZA4uNK5KMORPICWxUj4OoL7PjxR6CmxGyKuukUMu0uZ2a1LwmkdjW2z7179bY
    PHFEXcxs0wf0zlhi2U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddukedguddvlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:6Y0LZCeI4J1F1ejZsac9taQx3HQQ2wtWYwOz_LvnafEMtTHfkqPJ9w>
    <xmx:6Y0LZMJuxI1NjEo29mH0yiYmAjDPykYQR8yQqSilWZSRTP7yTZDQ8w>
    <xmx:6Y0LZPI4QWu68qVcwMHW6SDIGnvwPH3fgeJCqxq3TQaguypMs_GxNQ>
    <xmx:6Y0LZMpXXbTU9riN2MVYqmKlpXj3JzLs5aTumgZAio8D2aERXyZr0Q>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 9843DB60086; Fri, 10 Mar 2023 15:07:05 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-206-g57c8fdedf8-fm-20230227.001-g57c8fded
Mime-Version: 1.0
Message-Id: <1a2c5d85-049c-4512-be39-1319fa790924@app.fastmail.com>
In-Reply-To: <20230310160757.199253-1-thuth@redhat.com>
References: <20230310160757.199253-1-thuth@redhat.com>
Date:   Fri, 10 Mar 2023 21:06:44 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Thomas Huth" <thuth@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Linux-Arch <linux-arch@vger.kernel.org>,
        "Chas Williams" <3chas3@gmail.com>,
        "Palmer Dabbelt" <palmer@dabbelt.com>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net,
        Netdev <netdev@vger.kernel.org>,
        "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH v2 0/5] Remove #ifdef CONFIG_* from uapi headers (2023 edition)
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023, at 17:07, Thomas Huth wrote:
> uapi headers should not use the kernel-internal CONFIG switches.
> Palmer Dabbelt sent some patches to clean this up a couple of years
> ago, but unfortunately some of those patches never got merged.
> So here's a rebased version of those patches - since they are rather
> trivial, I hope it's OK for everybody if they could go through Arnd's
> "generic include/asm header files" branch.
>
> v2:
> - Added Reviewed-bys from v1
> - Changed the CONFIG_CDROM_PKTCDVD_WCACHE patch according to Christoph's
>   suggestion
> - Added final patch to clean the list in scripts/headers_install.sh

Thanks for the rebase, applied to the asm-generic tree now, as I'm
fairly optimistic they are all good.

    Arnd
