Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0689E492C2E
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 18:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346383AbiARRUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 12:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243729AbiARRUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 12:20:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C355C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 09:20:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2624FB816F3
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 17:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84486C340E0;
        Tue, 18 Jan 2022 17:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642526445;
        bh=FzTN81AXxTOxFZrRuNs1bFizpxALFD3aDW7Z14Rf9zc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h7uugVbylvMiBrhsK94cLMXIduOqFP8l6L2zt8Cx8KLNuG3ApFJPfTpURIQzz4ESt
         tdoE5ebG+UEzGAE8ET59SqrD0nklE3esjm1gj4HfQhNJafrSdHuNAA3qF3siFNacSa
         LxJ0Z/sBChHxaWBSeeKHMwFbPdTeAtI4b9ERZEL+Zi4Zcs2qzYU7glZ2LdFzsELxnE
         ocJqSufhmyi6ipdchXRtCFt68QYypvYPLN6UMK6voqeZHSeueZHGgy5NwHZyq0qSyu
         TnTMUCx0WYuHdxv7Nl3l6rFWmrRT6yE94sgrrn6InqpWsJIJgd7IPV20ND1uSiAuGr
         503Utgz3iBJqQ==
Date:   Tue, 18 Jan 2022 09:20:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Akhmat Karakotov <hmukos@yandex-team.ru>
Cc:     Martin KaFai Lau <kafai@fb.com>, Lawrence Brakmo <brakmo@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexander Azimov <mitradir@yandex-team.ru>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>, zeil@yandex-team.ru,
        davem@davemloft.net
Subject: Re: [PATCH v3] tcp: Use BPF timeout setting for SYN ACK RTO
Message-ID: <20220118092044.3e36c533@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <26CE358E-1A2F-4971-B455-9100142830BE@yandex-team.ru>
References: <20211025121253.8643-1-hmukos@yandex-team.ru>
        <20211103204607.21491-1-hmukos@yandex-team.ru>
        <20211104010648.h3bhz6cugnhcyfg6@kafai-mbp>
        <7A1A33E9-663E-42B2-87B5-B09B14D15ED2@yandex-team.ru>
        <20220118075750.21b3e1f0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <0F05155C-ED5A-4FC0-8068-B7A1738B5735@yandex-team.ru>
        <20220118090453.3345919d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <26CE358E-1A2F-4971-B455-9100142830BE@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jan 2022 20:07:40 +0300 Akhmat Karakotov wrote:
> On Jan 18, 2022, at 20:04, Jakub Kicinski <kuba@kernel.org> wrote:
> >> But if necessary I will integrate those changes in this patch with v4.  
> > 
> > Right, net-next is closed, anyway, v4 as a 2-patch mini-series may be
> > the best way.  
> 
> Why separate then if the second patch is just a refactor? Wouldn't single patch be simpler and better?

Sure.
