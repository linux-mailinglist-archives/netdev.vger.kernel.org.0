Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4176EB2E5
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 22:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbjDUU0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 16:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjDUU0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 16:26:49 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F397271F;
        Fri, 21 Apr 2023 13:26:47 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 8F23E3200406;
        Fri, 21 Apr 2023 16:26:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 21 Apr 2023 16:26:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1682108804; x=1682195204; bh=aC
        bgC3XdyqzyDdvGIJajq2TuNCnA+koTs/nAqynb1IQ=; b=MhPkIiIzSwJgaybpv7
        OOpDVuAEiRZg7ZoaCXoGX88xwSMTbfWBOVOV1zKWEYtiHKenE9ecxX7efWNb1WgP
        4Sv96+IvIVQbTbkTikm7RgxpMlVvaldKIu/jZ1OGp6fNbfzCL3UNY5YoJbD/vq7L
        TqAzRjVcMrlDwR0m9wrVgO3kHwvnaUzd3/F1nCJLE8Ve8k3tlkXtQ7gYOgHw+F1L
        Cn0G0bOS47Q/gCM7RBVzYB5BeFNozpnqzkB0W7bBf/opsQRrK/bQHBbaZsF0XugO
        KsqJqPGTVQNQmnm2QuvZWaTsg57F0vprSQV3Gtp7jV3MYNZOUebfaAhwnglPHQoZ
        ZDtQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682108804; x=1682195204; bh=aCbgC3XdyqzyD
        dvGIJajq2TuNCnA+koTs/nAqynb1IQ=; b=Zh/pFUZWQf26+vLE6u1BmbSN4c6Xk
        TUnAQNiKUM8Jqk0u7Jn1OtJgGkuoM0YexovnVpKvR157b9AwbHPjZRv5qAWU9tkO
        Ix0FCNhNti0ZfsAbfjHm+5EJ8Z5K0oP0CbRNTeOTOLVIlWWrfYtow2Y/PzxL6CKe
        JGznMEP8wIJ0e5+wZI9BQNJOL0oPi4rbkjSC3pFwSABVgC4tdwZBgqXWI+Af040X
        DC6Jl9AOOufGK5jm/SZXiqyN8cKTxWN5QVL3jIpl8E9z6crx28kMPCkjFRceocox
        rDG+GrPJhqr6DIzM/mE56trtEMCkbKbN657Qzm5hfz1/APDxnsEYIN3xQ==
X-ME-Sender: <xms:g_FCZFf0hAsbKqLmgcXgk6iP_TPQ_MBTgmWOoeSm_H6gaVPthP9j2A>
    <xme:g_FCZDNPTFW5dUWRysVBFpsniS_WQPdhL3NuS8pFtN1TuNJVd-oupPj8Lzxtjw3xr
    am9mNXJ1cfbUSCBoA>
X-ME-Received: <xmr:g_FCZOjiCRWkDOVHPMqf1v0_co-yVLN9p-GCWn0C70Fzp-_CiJ_lSDPXpsrneS0ztaWV12OFR69PtYMU8GiggOG--23H0yGpWtAsffQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedtgedgudegkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enfghrlhcuvffnffculdefhedmnecujfgurhepfffhvfevuffkfhggtggujgesthdtsfdt
    tddtvdenucfhrhhomhepffgrnhhivghlucgiuhcuoegugihusegugihuuhhurdighiiiqe
    enucggtffrrghtthgvrhhnpedvfeekteduudefieegtdehfeffkeeuudekheduffduffff
    gfegiedttefgvdfhvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:g_FCZO941Xkdt2LriAz-YoED4DX2C_y5wiLDiQqxLXn_X934otCfLg>
    <xmx:g_FCZBv8IqVhPs2e2eG6mh7WTBlYI4thah-EpukzjakIeMGi5InyMw>
    <xmx:g_FCZNE1MBIqaRoaylZ-bOV_GW5NlHp9l3H7qC2pPEDp5TwZnRMvuQ>
    <xmx:hPFCZLJdA0oRoMFMNAWc_u-8rhYwzfZRG_W-MCEM13fPMftJbPNE0w>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Apr 2023 16:26:43 -0400 (EDT)
Date:   Fri, 21 Apr 2023 14:26:41 -0600
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Florian Westphal <fw@strlen.de>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        qde@naccy.de
Subject: Re: [PATCH bpf-next v5 0/7] bpf: add netfilter program type
Message-ID: <bom5rdg6ffwvmwmwpjwd7igpney2t2gimn3xedezviexyy3nbt@oihiwn2uw2rv>
References: <20230421170300.24115-1-fw@strlen.de>
 <168210302187.11240.7792947856131351121.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168210302187.11240.7792947856131351121.git-patchwork-notify@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 06:50:21PM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to bpf/bpf-next.git (master)
> by Alexei Starovoitov <ast@kernel.org>:

Yay!

I'm getting a procedure done on my wrist so I'll be unable to code for a
week or two. When I recover I'll get on the conntrack stuff + a
selftest. If anyone has a burning desire to do it before then, feel free
to go ahead.

Thanks,
Daniel
