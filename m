Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94F262F6A8
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 14:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbiKRN5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 08:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234213AbiKRN5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 08:57:40 -0500
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DEFB855
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 05:57:38 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 3CCC6C020; Fri, 18 Nov 2022 14:57:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1668779863; bh=VQvQZFr5XOX6mVpYtpRmE/S6SSj33Skt2C2fmAo2mBQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tUX5eVOb6vWixrgLrzthqJdSROlGDJJHiq5JNnNKuIRg1kSPNlE2d/fiebmFFfktS
         VEoiGy13q5Hxgl5cV6GNcfnc4KRkO657R9fR9mHUIBth5qGIa21z71ma8+6dsyzv9N
         eaGnGsary/JAwbdqCMynKIUfccfUDIfAPpNccBe/TSOk6SGaweuFBjI8Lm000seVuq
         LVwZxcT25LBSQZ1S6x/58BzNusmICIVyP347N+siiuVYp2GZ4Pa+6dJILn1t8IPoZq
         e/w6QotVeDLx32oi/7MnNvUBX9gGn2CmTqbef1TdLzoJS0Qi8mLnskdSyMDlRmkOYJ
         CI73+Qc/S6H+Q==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id C497BC009;
        Fri, 18 Nov 2022 14:57:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1668779861; bh=VQvQZFr5XOX6mVpYtpRmE/S6SSj33Skt2C2fmAo2mBQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U0LzaW2K7atMmeU+JVE/GaCTSmjVg0tRzfZjuQQAxIVbWiDYB+3woQGkNMel+hitr
         3rTD0J3FpbYf4pN0Brco4XxROR1WC8rVFCw6jNBO/r4Y28sX1FAxdbpUg/5jqeNZ+F
         IuLWY+6c0OAZowNPAE/CdJNE0rGh2wTMDj4y8C5EGiDGCIdL9lcz4gotMEgVQhkC7q
         zcy9sfMmlMqaV932sCfZI/fnXWVEBXULvmYsrA0kPPGnoXoP1jqhD65SRKqIniEVrX
         2m+4vMWDDyLK4AeTxQ5HCB7FqLdtYgA6dDUT1siYm62YKw+qaZZrM2/1UFX446Cv5+
         vyUpPpGGZwalQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 5888f87b;
        Fri, 18 Nov 2022 13:57:30 +0000 (UTC)
Date:   Fri, 18 Nov 2022 22:57:14 +0900
From:   asmadeus@codewreck.org
To:     "Guozihua (Scott)" <guozihua@huawei.com>
Cc:     Christian Schoenebeck <linux_oss@crudebyte.com>, ericvh@gmail.com,
        lucho@ionkov.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH 0/3 v2] 9p: Fix write overflow in p9_read_work
Message-ID: <Y3ePOhpctTf7Buf8@codewreck.org>
References: <20221117091159.31533-1-guozihua@huawei.com>
 <3918617.6eBe0Ihrjo@silver>
 <Y3cRJsRFCZaKrzhe@codewreck.org>
 <a6aec93a-1166-1d8a-48de-767bc1eb2214@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a6aec93a-1166-1d8a-48de-767bc1eb2214@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guozihua (Scott) wrote on Fri, Nov 18, 2022 at 06:18:16PM +0800:
> I retried the repro on your branch, the issue does not reproduce. What
> a good pair of eyes :)！

Thanks!
By the way the original check also compared size to msize directly,
without an offset for headers, so with hindsight it looks clear enough
that the size is the full size including the header.

I'm not sure why I convinced myself it didn't...

Anyway, this made me check other places where we might fail at this and
I've a couple more patches; please review if you have time.
I'll send them all to Linus next week...
-- 
Dominique
