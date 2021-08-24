Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DA93F6B54
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 23:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbhHXVss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 17:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbhHXVsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 17:48:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC37C061757
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 14:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=FWIdrVlLJ8RmRSq0xaRSPTq02aPvPZSRAXqKzuaY/HY=; b=TkHasoyVMJL4blp3yLmNai1MsD
        joaRSMyWwzhQRTd01T97Rko0cfEksetexcC4qTZJ/X3IXA0f1AcEJwVbSw0VuLGkR1Yhz+x1QlCpR
        UjiyXR5yCjM8lQK1eTUJYNIRibqcg3cD7cZcJaGUyQUTvO+KPVy33LK/ETmd4OwQhq93mLkIy3c8l
        u/41CmRkjM1MH8ztPeaLuCAHDm9X/uf6nnEneqY9NiZYYP1VFXaAzixts7Fdxg30U5a27cXcasj2h
        OvNuKs61WzHbzMV/Ddj2anmlKE4wpF2YHWN8OFTRjTpu32HKT9YHt33BfKKRNgCz4+30P5Q/gK5PX
        n/v/XElw==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIeH3-004lfK-VG; Tue, 24 Aug 2021 21:48:02 +0000
Subject: Re: [PATCH] ptp: ocp: don't allow on S390
To:     Richard Cochran <richardcochran@gmail.com>,
        Arnd Bergmann <arnd@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
References: <20210813203026.27687-1-rdunlap@infradead.org>
 <CAK8P3a3QGF2=WZz6N8wQo2ZQxmVqKToHGmhT4wEtB7tAL+-ruQ@mail.gmail.com>
 <20210820153100.GA9604@hoboy.vegasvil.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <80be0a74-9b0d-7386-323c-c261ca378eef@infradead.org>
Date:   Tue, 24 Aug 2021 14:48:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210820153100.GA9604@hoboy.vegasvil.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/21 8:31 AM, Richard Cochran wrote:
> On Fri, Aug 20, 2021 at 12:45:42PM +0200, Arnd Bergmann wrote:
> 
>> I would also suggest removing all the 'imply' statements, they
>> usually don't do what the original author intended anyway.
>> If there is a compile-time dependency with those drivers,
>> it should be 'depends on', otherwise they can normally be
>> left out.
> 
> +1

Hi,

Removing the "imply" statements is simple enough and the driver
still builds cleanly without them, so Yes, they aren't needed here.

Removing the SPI dependency is also clean.

The driver does use I2C, MTD, and SERIAL_8250 interfaces, so they
can't be removed without some other driver changes, like using
#ifdef/#endif (or #if IS_ENABLED()) blocks and some function stubs.


-- 
~Randy

