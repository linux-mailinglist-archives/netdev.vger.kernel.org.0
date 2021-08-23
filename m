Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE9D3F4503
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 08:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbhHWGfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 02:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbhHWGfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 02:35:46 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335D5C061575;
        Sun, 22 Aug 2021 23:35:04 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id h13so24627782wrp.1;
        Sun, 22 Aug 2021 23:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qSV/e6QyHif3aJ5CG58TgVpcSD8xLK7XuClJ7iB4h84=;
        b=s4ev/IgiHuIFr5xnopqiQZRs20uU/t0h2JNQZlsDqPaBqfsR/w5PGZktTCle5ypukR
         q9qYu6TrrwG08jWZQjFlyUGFT6HO0PSttR3IkTNlrXbUUXHAOmwTuV2oj4qc4q4HxLmU
         /qAdU7f0caLOtYWXiaDy2Q4cSDyzYDXBk/RovNjn1c6/4Cg20kqKe3TKFATT9LNaV2JR
         +jRwe6ADy/6NJi0HbTH7XOsJdJwz4yGO23OSrdt5ifHEQt77MnvciwIWwtuNMpcqrj0q
         X5hDmeoZFRSIuWXGqk5wpLBo0V54/ch9mJdaD7n/kStlnURFcDfBzrgfPYttUaR4FPVL
         p2rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qSV/e6QyHif3aJ5CG58TgVpcSD8xLK7XuClJ7iB4h84=;
        b=bhz67+Atp8Tn3DpENqXrpQZ1BSgB2quLzwAikI2lMlh7dl49OA4U6lK/W7CSJSiFn5
         n8ipwxelO+CWivwzoosysFLQgeP3GrCbQKKrhdm2Rz61+TO2oSz4U7cvDrY1fEcF9NSN
         0f2xjzJOUHOrE8C+acPr5A23kmRo8sPu/Wkh22TLnYsHtM7pp4okmMq5sv0KsU8/XkUM
         SuKAS9jEk63aZnqS6+rU2HLwP3+QDwIM3bypmBuJ+moWXxT7M5x8Bo1mmmoqQRSx5uv6
         7Hr570YL8H5M0qjf72VB17g40B8jjFn2OwhhYC7DuRoE2I93/BKLjodcfqeGJF1VA7WP
         b6sg==
X-Gm-Message-State: AOAM53261wZ8z/eBN34Z2eV4wHUJoab3cVHGsLflsxjen3xyTfXoqxzQ
        vGfdERpD0unjkNmJRiO+zSPGk085Ujr7gA==
X-Google-Smtp-Source: ABdhPJw9dO/0knZ51VRdOTtD6rx3KHx7jFCK6IapWDUPd09TgcbryXdTAwCPpXPDU0IhlMgIAe1z4Q==
X-Received: by 2002:adf:eb89:: with SMTP id t9mr12317037wrn.66.1629700502635;
        Sun, 22 Aug 2021 23:35:02 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:ed43:740c:fec5:7f46? (p200300ea8f084500ed43740cfec57f46.dip0.t-ipconnect.de. [2003:ea:8f08:4500:ed43:740c:fec5:7f46])
        by smtp.googlemail.com with ESMTPSA id o34sm17404318wms.10.2021.08.22.23.34.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Aug 2021 23:35:02 -0700 (PDT)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <20210823120929.7c6f7a4f@canb.auug.org.au>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <fbac0963-385d-b593-e087-e1e75f62fcbf@gmail.com>
Date:   Mon, 23 Aug 2021 08:34:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210823120929.7c6f7a4f@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.08.2021 04:09, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/net/ethernet/broadcom/bnx2.c: In function 'bnx2_read_vpd_fw_ver':
> drivers/net/ethernet/broadcom/bnx2.c:8055:6: error: implicit declaration of function 'pci_vpd_find_ro_info_keyword'; did you mean 'pci_vpd_find_info_keyword'? [-Werror=implicit-function-declaration]
>  8055 |  j = pci_vpd_find_ro_info_keyword(data, BNX2_VPD_LEN,
>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |      pci_vpd_find_info_keyword
> 
> Caused by commit
> 
>   ddc122aac91f ("bnx2: Search VPD with pci_vpd_find_ro_info_keyword()")
> 
> I have used the net-next tree from next-20210820 for today.
> 
This series was supposed to go through the PCI tree. It builds on recent patches
that are in the PCI tree, but not in linux-next yet.
I mentioned this dependency in the cover letter for the last series, but forgot
it this time. Sorry.
