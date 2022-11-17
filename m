Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA8362D863
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 11:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbiKQKtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 05:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234669AbiKQKty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 05:49:54 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D89F140B9
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 02:49:52 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 12DFCC009; Thu, 17 Nov 2022 11:49:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1668682196; bh=cUAVzy++vQmF1k3gRGwLejGc6gHKv/q3FUdmGQcPv7Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wT6YIxy9r8YuB3tp7pPWKDz0yKMMiNVSc0/dQfMhULEB4OrX1as4VxvP/XtetyrId
         lpJaFUsY+CHinJ4n/zMi4WQfoHHNvCjm+r80Tgyw8yvWLVdrxyYEklgOm0zU1JCrUt
         n5NkDael585w21vrTeQ3UHHYBlrKBOa0YU1m6IypRQopoyHA01SA+1XHlkSln1/mrv
         YOz1lopx4EueFOGoclXjsFI4Ebzf9lXNDv+HIgaiauUGaSi/pB/1Y9Uz7MtIUiydQ2
         kFd7SRL4c8/TRbUjgyjYI7ExlRe/EkeMHwTxG4rLFx1659ZH/su0kTgLmquDqWa2F8
         jyl2GT2J7D4Vw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 37A9FC009;
        Thu, 17 Nov 2022 11:49:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1668682195; bh=cUAVzy++vQmF1k3gRGwLejGc6gHKv/q3FUdmGQcPv7Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BMyfqENtg6i87RKdb1ZZgsKaQUo8OKlUxPvU7uZUvz7/wZHAxvJX0A3p9TWlfUs5n
         F7YWL6NOGu0UeqKpGrS2XDH/5Ti+zQwCEoD1ySCaiUUzoeSpnQZnBvisi3x1bRjaZj
         2HFsLJO9SZt/+jH2zMGObsbWJzrngovxWkVyQiCju9XSa4q+vMKn7t31RQbL6pWHKw
         eNyEd3FZAhXcZES6zRAg7oSjNjfu6y9IwkIECdo4PhaTff0l9dQcxYh9Ddqqa7ogEt
         AyE4AIUrD2AFH6C64lFIrAeUnhBJbWVAGCpZEkbSRwqqduQR/jvZwGjI3g1zCH41cd
         F+82HW0gXwXpw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id fd609252;
        Thu, 17 Nov 2022 10:49:43 +0000 (UTC)
Date:   Thu, 17 Nov 2022 19:49:28 +0900
From:   asmadeus@codewreck.org
To:     GUO Zihua <guozihua@huawei.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/3 v2] 9p: Fix write overflow in p9_read_work
Message-ID: <Y3YRuHnkULT1Ti3l@codewreck.org>
References: <20221117091159.31533-1-guozihua@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221117091159.31533-1-guozihua@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GUO Zihua wrote on Thu, Nov 17, 2022 at 05:11:56PM +0800:
> This patchset fixes the write overflow issue in p9_read_work. As well as
> some follow up cleanups.

Thanks for this v2.

Comments below

> GUO Zihua (3):
>   9p: Fix write overflow in p9_read_work
>   9p: Remove redundent checks for message size against msize.

This has 'Fixes: 3da2e34b64cd ("9p: Fix write overflow in
p9_read_work")' but that commit isn't applied yet, so the commit hash
only exists in your tree -- I will get a different hash when I apply the
patch (because it'll contain my name as committer, date changed etc)

I don't think it really makes sense to separate these two patches, I'll
squash them together on my side.

>   9p: Use P9_HDRSZ for header size

This makes sense to keep separate, I'll just drop the 'fixes' tag for
the same reason as above


I'll do the squash & test tomorrow, you don't need to resend.
I will tell you when I push to next so you can check you're happy with
my version.
-- 
Dominique
