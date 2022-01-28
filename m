Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0963349F6F4
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 11:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344070AbiA1KQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 05:16:24 -0500
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:45715 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245304AbiA1KQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 05:16:20 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 5CFAA2B00254;
        Fri, 28 Jan 2022 05:16:15 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 28 Jan 2022 05:16:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=IfghC/MuIyj/3FnI1U3LySUJn+GqmbGV5a+ZVg
        4yeGU=; b=PuOi3yd5H2bnIYyTDUNPqtI4Ok30DMI4/rqZJT176vTeKLfBWT4WYP
        Qp79elG98CXgFBeIe1X6yswsN5/LW4XWO0tkTr2AtgPDAo3CPLC+AGTpPHwcU5hY
        W9fAhLcUXM+M30z0SaLN6u1qQLnENo9nFpx9ws7v+q9aKRuhsoYRYce49BarUtGX
        g4ZYKF9U36DUdkXilfZBfQ1zYZK6wU+fQgi3+IbS+GKIjw2+/QH7LwAXYG53Ah3Y
        +yEb8mZneIWC3eTfdFCuWNtiJlCwahxtf/ug0oHWku/qBY89+bUcpjWPwfPxLmvJ
        AeDG7yHi7S/AyWuwAZpByps2T1SwWsjQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=IfghC/MuIyj/3FnI1
        U3LySUJn+GqmbGV5a+ZVg4yeGU=; b=L/sBsLlMJS6QJ91CSKL8tsUhH4CeFCMm4
        iybU19a8rBfhMmPsllb2zb80MR9bjVAQCc9ZJJJXdtAu4GAH590HkE/rVU+26wHi
        hMyOOi+d+a50f03HS9ILdqXETuIMVJ3pC1Ew0QnNv3KpohvWCXWEMLAxtyQ+e1IV
        dulUBxwsIsIlExPfmxc8MjPfM5hGJ2RqLJPkZLUiV7neaCoDjXi4mOgzwBu3ibZx
        d5rM8E0jxHRZHJ+whXSC++bYm1qRCjZb6SDubHQzxWhoAoj6x2vy7vKpz0z1oIjX
        WsMounuQjlrmxLAPeZrAomhRQkJtGCLB6A52PxDcD4QJfcFAlU/Bw==
X-ME-Sender: <xms:bsLzYXR-p5ZK5McLCAKIIFMXOBjgNDUqjizI5LJB2YUsxWJ-Jll5RQ>
    <xme:bsLzYYwr0xMOJvODLgdFJ4BkMkWaeSx6li6BPS7UzFJ86YCb81wraSYftFI6LsiuR
    pPYAn2LmHBtYw>
X-ME-Received: <xmr:bsLzYc2qea4QRUWXxVf6vngBnjqkgMyrUA720BfTwet_BpVRwexV9N_ZJiJWejiwWAiLVsxg3CZhexbUbvElkAMNRrozldzP>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrfeehgddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:bsLzYXBTIRkYSNwSbWwZoQ2gojShfFwIDI7dOub6HXT9_6eA-0TvRg>
    <xmx:bsLzYQjrquv-HflKsutfyTzHXW26H6HzCtyJYGDsAisjIAmucLCoxQ>
    <xmx:bsLzYbreNQOyzsoEzDUkfbbsx8d_rytLqmEz3Vy9vkaFV7po-Kxt3w>
    <xmx:bsLzYfonIznhl6vlSODB3FJA4ul6TFLupAmBPpZ6r4LfET6Man5YBO-wOVE>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 28 Jan 2022 05:16:13 -0500 (EST)
Date:   Fri, 28 Jan 2022 11:16:10 +0100
From:   Greg KH <greg@kroah.com>
To:     Zhou Qingyang <zhou1615@umn.edu>
Cc:     kjlu@umn.edu, Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Angus Ainslie <angus@akkea.ca>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: Fix a wild pointer dereference bug in
 brcmf_chip_recognition()
Message-ID: <YfPCahElneup1DJS@kroah.com>
References: <20220124164847.54002-1-zhou1615@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124164847.54002-1-zhou1615@umn.edu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 12:48:45AM +0800, Zhou Qingyang wrote:
> In brcmf_chip_recognition(), the return value of brcmf_chip_add_core()
> is assigned to core and is passed to brcmf_chip_sb_corerev(). In
> brcmf_chip_sb_corerev(), there exists dereference of core without check.
> the return value of brcmf_chip_add_core() could be ERR_PTR on failure of
> allocation, which could lead to a NULL pointer dereference bug.
> 
> Fix this bug by adding IS_ERR check for every variable core.
> 
> This bug was found by a static analyzer.
> 
> Builds with 'make allyesconfig' show no new warnings,
> and our static analyzer no longer warns about this code
> 
> Fixes: cb7cf7be9eba ("brcmfmac: make chip related functions host interface independent")
> Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
> ---
> The analysis employs differential checking to identify inconsistent 
> security operations (e.g., checks or kfrees) between two code paths 
> and confirms that the inconsistent operations are not recovered in the
> current function or the callers, so they constitute bugs. 
> 
> Note that, as a bug found by static analysis, it can be a false
> positive or hard to trigger. Multiple researchers have cross-reviewed
> the bug.

As stated before, umn.edu is still not allowed to contribute to the
Linux kernel.  Please work with your administration to resolve this
issue.



