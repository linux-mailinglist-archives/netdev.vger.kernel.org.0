Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B981A4406E3
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 04:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhJ3CMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 22:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhJ3CMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 22:12:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0C8C061570;
        Fri, 29 Oct 2021 19:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=jtC1LgoBKx3W6frSUd+4Y7cfdCmWlhoYd8szeem2/oY=; b=PlhHNoHgh+U81cjRLjtzEEo+5F
        RzJ6zQJqp4K14GYC+xR+ioZwhVEVcFyYAN8wxym+lvZn/gV4K/XTD8T3jQgIHv0X0bMPPUGwq8oJP
        Z4jCfoXKn5IC1BiAgrGfTajsJM9x71pgfd+IRYFuuXGHvkJsfjlRalNM23HMZLZK4ICZqifGhRCjH
        DdwiQurw0yEHQyZYBs3OBjwXlsru7yHNowsAN0VD5Q0qGH67yyVXtHM8the9Z+wYFFsTwOSj56aYj
        q1Wq0mKTGRbi+z/MAWcatejkMWXQ76EmHlAYU8NzwFgpLx5Z6kIww/BdDiDznox8HFYITgiHCJ45X
        sXe0sdWQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mgdop-00CdW7-Fo; Sat, 30 Oct 2021 02:10:03 +0000
Subject: Re: linux-next: build warning after merge of the net-next tree
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20211027220721.5a941815@canb.auug.org.au>
 <YXk5Uii+pNPaDiSR@shell.armlinux.org.uk>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <2b553780-f0a8-f9d7-4401-65762952fbdd@infradead.org>
Date:   Fri, 29 Oct 2021 19:10:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YXk5Uii+pNPaDiSR@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/21 4:34 AM, Russell King (Oracle) wrote:
> On Wed, Oct 27, 2021 at 10:07:21PM +1100, Stephen Rothwell wrote:
>> Hi all,
>>
>> After merging the net-next tree, today's linux-next build (htmldocs)
>> produced this warning:
>>
>> include/linux/phylink.h:82: warning: Function parameter or member 'DECLARE_PHY_INTERFACE_MASK(supported_interfaces' not described in 'phylink_config'
>>
>> Introduced by commit
>>
>>    38c310eb46f5 ("net: phylink: add MAC phy_interface_t bitmap")
>>
>> Or maybe this is a problem with the tool ...
> 
> Hmm. Looks like it is a tooling problem.
> 
>   * @supported_interfaces: bitmap describing which PHY_INTERFACE_MODE_xxx
>   *                        are supported by the MAC/PCS.
> 
>          DECLARE_PHY_INTERFACE_MASK(supported_interfaces);
> 
> I'm guessing the tool doesn't use the preprocessed source. I'm not sure
> what the solution to this would be.
> 

I just sent a patch to scripts/kernel-doc to support that macro.

-- 
~Randy
