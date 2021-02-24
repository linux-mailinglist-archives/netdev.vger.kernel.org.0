Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF413235DA
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 03:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbhBXCnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 21:43:01 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34581 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229961AbhBXCm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 21:42:58 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 179405C0085;
        Tue, 23 Feb 2021 21:42:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Feb 2021 21:42:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zenhack.net; h=
        message-id:from:date:subject:to; s=fm2; bh=Vtx7UlgIGFX9Sn2RG8HGj
        RbRgEj2WGN5X1HPKlnVvXA=; b=BrV1JIhmVaRgKkDNJeX5NtbcVdpAsN5pUNczZ
        6fRwu5YLMPBMBDwPEDpoXyDTbJr1lSbGjNokyESKJeg2uDPBv2RORWG0qTxheIs+
        X0+qCUToSk+u9uYe1LI+pwFvm1XD1JVAam1rHAUWERLlMvHYT2yRQcDK0JIgu5Ho
        aSTO+zB0wkzaeHAsCRRD5ohIa2ajKV93tIoagkTi+3CPd+FRAcmJrnuO9cQYY4ng
        knlyayWz4GW91X2ZkDBz5KZ920OwNa4HhjJjdsV/Wc/+g+kMQgx5PvvBswmKJzKz
        TyuBQJdeieoiMHgDvvdCsqqFft5sF7Vr377Gunt3crC8dOhXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=date:from:message-id:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Vtx7UlgIGFX9Sn2RG8HGjRbRgEj2WGN5X1HPKlnVvXA=; b=ROwr3Fxn
        cL3DPOOL2RXvyNlV43RMbfDW6xMUpjPndATIfNoii6T0Y4gtW5PIal2tbThsLtKH
        avpkNp9Jd2dkHXO+dK82AU07e9/eqOMLBVVLVVPvDSHuowHCWvsfobe04iNqJhd3
        zmp6gtnKEADbXotuXD724IFxmkaG7E+4u5VTAwXpZepVLXtHSJGjG7TdN1JRJHkF
        K840qP1wVCmm9nhziyM/3fU08Bt54dE4jILQMHv7sUj4/KHM9QyNswwvxV1zlwcz
        fMlCy1CWE9NCnPyth2+iYtbCgkqQFoH8w23AWy/YQQbwHXnkZzXVyMUSPb8+he9Q
        JR8/5FVEwhRqxg==
X-ME-Sender: <xms:Ab01YJ6nWmZWaRtIIbFgnMml1er2qaBf53kuwUkplSSodCVxObN-nw>
    <xme:Ab01YG5uz9ize0Xg9mcRsZgI_wfRT2WBuzf0VmuuvLdbnovNPa8msiLPhw9dqVp38
    wJypx4TIeajjlyh2is>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeeigdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepkffhfffuvfestddtredttddttdenuc
    fhrhhomhepkfgrnhcuffgvnhhhrghrughtuceoihgrnhesiigvnhhhrggtkhdrnhgvtheq
    necuggftrfgrthhtvghrnhepudetgeehgfevtdffleeggfehkeekkeffffdvledvtefgge
    ffgffgleejuddtffeunecuffhomhgrihhnpegvrhhrohhrshdrthhoohhlshenucfkphep
    uddttddrtddrfeejrddvvddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepihgrnhesiigvnhhhrggtkhdrnhgvth
X-ME-Proxy: <xmx:Ab01YAcxUdb04wkKBgXGL3ZlEFUjzV6wATDkC34viTo_BZsYFfnJeQ>
    <xmx:Ab01YCKW9bul8CVQh0lQ4Y2F0zLyBgjdnf06o6vWSqYRP9Zz6SI6lw>
    <xmx:Ab01YNI8D8xlwY7tWGfZa--04NBJsTcAzVLFVa3Aw-aSC8oDRNLFLQ>
    <xmx:Ar01YLiDKK_gXP-h42tWqbhh7LEWVadyRwz0b5Et-z9R3kRu5loppA>
Received: from localhost (pool-100-0-37-221.bstnma.fios.verizon.net [100.0.37.221])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9184A24005B;
        Tue, 23 Feb 2021 21:42:09 -0500 (EST)
X-Mailbox-Line: From edb7c1985e446f6dd4ad875f39605bb2968d9920 Mon Sep 17 00:00:00 2001
Message-Id: <cover.1614134213.git.ian@zenhack.net>
From:   Ian Denhardt <ian@zenhack.net>
Date:   Tue, 23 Feb 2021 21:36:53 -0500
Subject: [PATCH 0/2] More strict error checking in bpf_asm.
To:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Enclosed are two patches related to my earlier message, which make the
error checking in the bpf_asm tool more strict, the first by upgrading a
warning to an error, the second by using non-zero exit codes when
aborting.

These could be conceptually separated, but it seemed sensible to submit
them together.

-Ian

Ian Denhardt (2):
  tools, bpf_asm: Hard error on out of range jumps.
  tools, bpf_asm: exit non-zero on errors.

 tools/bpf/bpf_exp.y | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--
2.30.1

