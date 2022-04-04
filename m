Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA7B4F1B24
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354322AbiDDVTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380030AbiDDSlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 14:41:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959D85F99;
        Mon,  4 Apr 2022 11:39:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42A3FB818D8;
        Mon,  4 Apr 2022 18:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B0EC340F3;
        Mon,  4 Apr 2022 18:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649097561;
        bh=uoCUt9kRip3xmuGeLGDqglk9GEPAPCSc46dVFwVFFvs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=pWjK8T/SiEbCNPFdLabaKBhPZF8HEsxpYiFOPoj11AhzUzWc0mFSTNoTlb44mzjIt
         F3UZs1LSUjPo/vOdjOWkHWODjT6vCZV4ZDdN74DxYDMI5v/o8GBHU2fLfKRNJyKNv7
         gtUzy0Kf5ojn5swpmgVLnbCnNNgCbQO7w0i9dnoCj/kzOzhXBF6WNWKxFi9motkxV1
         mAZPq5pTW07Pv3EOFvaB4dD/VUmByyweb+IizmotBRaNxe2OECt5SeCdq2GbRkzw8s
         AQKJTPhJozQ/0jP8eneP9qLPjEAktInngDlNV+gUc4cd2uHWA+D6yPbPP1WfCZEgV2
         5G+GoDEs7Lu2A==
From:   Kalle Valo <kvalo@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-parisc@vger.kernel.org, sparclinux@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        linux-rdma@vger.kernel.org, linux-um@lists.infradead.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-xfs@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-s390@vger.kernel.org
Subject: Re: Build regressions/improvements in v5.18-rc1
References: <CAHk-=wg6FWL1xjVyHx7DdjD2dHZETA5_=FqqW17Z19X-WTfWSg@mail.gmail.com>
        <20220404074734.1092959-1-geert@linux-m68k.org>
        <alpine.DEB.2.22.394.2204041006230.1941618@ramsan.of.borg>
Date:   Mon, 04 Apr 2022 21:39:15 +0300
In-Reply-To: <alpine.DEB.2.22.394.2204041006230.1941618@ramsan.of.borg> (Geert
        Uytterhoeven's message of "Mon, 4 Apr 2022 10:16:08 +0200 (CEST)")
Message-ID: <874k38u20c.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

>> /kisskb/src/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c:
>> error: case label does not reduce to an integer constant: => 3798:2,
>> 3809:2
>
> arm64-gcc5.4/arm64-allmodconfig
> powerpc-gcc5/powerpc-allmodconfig
> powerpc-gcc5/ppc64_book3e_allmodconfig

After v5.17 there were two commits to brcmfmac/sdio.c:

$ git log --oneline v5.17.. drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
ed26edf7bfd9 brcmfmac: Add BCM43454/6 support
6d766d8cb505 brcmfmac: pcie: Declare missing firmware files in pcie.c

I can't see how either of them could cause this warning. Could something
else cause this or am I missing something?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
