Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9775354D993
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 07:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347960AbiFPFLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 01:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiFPFLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 01:11:12 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA18558E72;
        Wed, 15 Jun 2022 22:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655356270; x=1686892270;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=NkEFYvNXfkRiyQzrKr5w73UFu/bNjvCsd8osZsw1FkQ=;
  b=fSxT62GXW1uxpxMMMowHxS5yZ6Veu9TYnr/t88PvBquBKZwEfSeW/RMZ
   Ng5dAVC5qymZlqW4m/MhCTQlAZcReXjEnRdmdKetYGPsy/u154+oqaXBn
   TQBw5qGehLFSt5XtvfdUAcTBFCBuKwh9fkfsy5jXPRJW8V8e6Oszv4UiT
   nMR7IcS7Z6rWonXcCue0oEESnknGDmdfmwVQ1fZbJIKhprP+1qHUWAgsN
   FQgdvhTZiaxbWSawapdW8uDlQTlazhca8hFkjdHN2tUsGIF9cYx+s+sr0
   Mkwwkv6/4vPEijDoH+j3E59js7TH9n9Juy1Fq5U1cbJGjzAYcavpXMcc4
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="276741256"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="276741256"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 22:11:10 -0700
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="641365226"
Received: from rongch2-mobl.ccr.corp.intel.com (HELO [10.249.174.230]) ([10.249.174.230])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 22:11:05 -0700
Subject: Re: [linux-next:master] BUILD REGRESSION
 8cb8311e95e3bb58bd84d6350365f14a718faa6d
To:     Arnd Bergmann <arnd@arndb.de>, kernel test robot <lkp@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "open list:DRM DRIVER FOR QEMU'S CIRRUS DEVICE" 
        <virtualization@lists.linux-foundation.org>,
        Networking <netdev@vger.kernel.org>,
        linux-staging@lists.linux.dev,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-parport@lists.infradead.org,
        linux-omap <linux-omap@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvm list <kvm@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        bpf <bpf@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux Memory Management List <linux-mm@kvack.org>
References: <628ea118.wJYf60YnZco0hs9o%lkp@intel.com>
 <CAK8P3a10aGYNr=nKZVzv+1n_DRibSCCkoCLuTDtmhZskBMWfyw@mail.gmail.com>
From:   "Chen, Rong A" <rong.a.chen@intel.com>
Message-ID: <7a9f0c2d-f1e9-dd2f-6836-26d08bfa45a0@intel.com>
Date:   Thu, 16 Jun 2022 13:11:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a10aGYNr=nKZVzv+1n_DRibSCCkoCLuTDtmhZskBMWfyw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/26/2022 4:32 PM, Arnd Bergmann wrote:
> On Wed, May 25, 2022 at 11:35 PM kernel test robot <lkp@intel.com> wrote:
>> .__mulsi3.o.cmd: No such file or directory
>> Makefile:686: arch/h8300/Makefile: No such file or directory
>> Makefile:765: arch/h8300/Makefile: No such file or directory
>> arch/Kconfig:10: can't open file "arch/h8300/Kconfig"
> 
> Please stop building h8300  after the asm-generic tree is merged, the
> architecture is getting removed.
> 
>          Arnd
> 

Hi Arnd,

Thanks for the advice, we have stopped building h8300 for new kernel.

Best Regards,
Rong Chen
