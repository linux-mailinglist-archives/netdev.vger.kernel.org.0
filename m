Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E246E4F23B2
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 08:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbiDEGyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 02:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbiDEGym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 02:54:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA948FE49;
        Mon,  4 Apr 2022 23:52:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABD42B81B96;
        Tue,  5 Apr 2022 06:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5887BC340F3;
        Tue,  5 Apr 2022 06:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649141561;
        bh=sfI+F1qddgBQPEPVyPm4UsT8iPzrWXdjhWe583jbPNo=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=V/qs96FwacDoAwIb3AYjsXmHxIyAPgkVCDF70o06rl9Kv/EU36wYnE2B+iVWmFDuY
         9yuhSTxtp1RApbos0thzGGcgBcYzB4OUjwwadhMoCk9ddnMLEKl7z5ojHVyxLNPTxe
         fkI47UjfZEnf1/Ud4Zb2n1JXmLeINpIf17so9GlwWdiyUMNfRV7wQ5S+MxBnAEYklV
         Y8YdKnoXbq3CdeKDF/1PwekiJc2XNSMWQ0QvtapOIX7H8ZI+dMggm5cQNjfN6CVOOX
         7Pm2r4QROcmMfAGlnaeACUWbHHdwgaBx6T+/ZTGZ0SVcsrXuQJQPOhC5ncYhaHg04Y
         CE7JnbN9mYeEw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-um <linux-um@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        scsi <linux-scsi@vger.kernel.org>,
        "open list\:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-xfs@vger.kernel.org,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: Build regressions/improvements in v5.18-rc1
In-Reply-To: <CAMuHMdV_-3TOHYehUsHeqwHjQtzN1Ot886K7vwPr4P-4u8eehw@mail.gmail.com>
        (Geert Uytterhoeven's message of "Tue, 5 Apr 2022 08:46:06 +0200")
References: <CAHk-=wg6FWL1xjVyHx7DdjD2dHZETA5_=FqqW17Z19X-WTfWSg@mail.gmail.com>
        <20220404074734.1092959-1-geert@linux-m68k.org>
        <alpine.DEB.2.22.394.2204041006230.1941618@ramsan.of.borg>
        <874k38u20c.fsf@tynnyri.adurom.net>
        <CAMuHMdV_-3TOHYehUsHeqwHjQtzN1Ot886K7vwPr4P-4u8eehw@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Tue, 05 Apr 2022 09:52:33 +0300
Message-ID: <87czhwrphq.fsf@kernel.org>
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

> On Mon, Apr 4, 2022 at 8:39 PM Kalle Valo <kvalo@kernel.org> wrote:
>> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>> >> /kisskb/src/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c:
>> >> error: case label does not reduce to an integer constant: => 3798:2,
>> >> 3809:2
>> >
>> > arm64-gcc5.4/arm64-allmodconfig
>> > powerpc-gcc5/powerpc-allmodconfig
>> > powerpc-gcc5/ppc64_book3e_allmodconfig
>>
>> After v5.17 there were two commits to brcmfmac/sdio.c:
>>
>> $ git log --oneline v5.17.. drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>> ed26edf7bfd9 brcmfmac: Add BCM43454/6 support
>> 6d766d8cb505 brcmfmac: pcie: Declare missing firmware files in pcie.c
>>
>> I can't see how either of them could cause this warning. Could something
>> else cause this or am I missing something?
>
> Doh, I should not have reduced the CC list in the xfs subthread...
>
> The builds above are all gcc-5 builds, so they are affected by the same
> issue as XFS: unsigned constants that don't fit in int are lacking a
> "U" suffix.
>
> I assume Arnd's patch for
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> fixes this?
> https://lore.kernel.org/all/CAK8P3a0wRiS03imdXk2WbGONkSSczEGdE-ue5ubF6UyyDE9dQg@mail.gmail.com

Great, thanks. I assume Arnd will submit it officially at some point.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
