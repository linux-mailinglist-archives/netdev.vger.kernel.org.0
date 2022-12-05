Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6DE8642C2F
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 16:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbiLEPpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 10:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbiLEPpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 10:45:03 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14771F03F
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 07:44:51 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id i15so8147649edf.2
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 07:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tfKmzFIivR84aG/YhA8CfmmH6xgvFirRXWP7JuK1YUk=;
        b=hSdrSzdOE8XumiTKevu/I2QmD9fnTqdEpFHE7Bhai9aUZc47b27E5de7lctXQ7Fcj3
         9jQs2Lr8eQ+4Jm7YM9e0/FC7O26OeJGq848cC88gEvBgilLMOfF/3hYgw4PPSIPtrrdn
         flaTluZsylwF1L/KClqXYZAnMYdA7FsPx9DleDMgKsssWBuCDDoiwVdnjH/DJJMgnYS+
         snJFEQ0Zb7xWJoyhP0ufhkMLSGdKwVTBKtRGBIAP34JmDPZKFeFmj+q4QvIfILulSBXp
         X9ZTENd+ZMDJKbRmY6gxyKzqayNA7ihrSWeZ+jlBP7gf4uDhJn1nmvRv/UkSRl6inZ7j
         PpMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tfKmzFIivR84aG/YhA8CfmmH6xgvFirRXWP7JuK1YUk=;
        b=uFNwothikejo1ZOejRCQSpbooJIlE3LUbpRKPx5NyCYx2UpZV2PCHE/ir4vz3YCl9y
         wPSIf3QCR4Kb16B31HH6utI58JZ35m9/UsAO3t6EtETeaTfzcE3mIs9NVf5uTQgOHu4V
         wqKWlgHLmqjLAA4uzk+MUL4+HX0TotrwD5yzq02AMoTegtfbhTBUOCWDWVwF82/ywuZE
         uYMrqLo/nPL913T5lW7ZULkjgBpolgMc/WEsfgb3RdKDG/h6kizOllrowQY/X427cDFo
         LIrC9XdzuWpaGK820HEDK73/I7JvH9GYM3BCFDuduP5e8bKHjsDIUlkNKbC7YYLPJMqP
         fcCQ==
X-Gm-Message-State: ANoB5pk/kQV34+cjHP7FkJk/IuF8pZrcSBL7tuVEktV3cyH6JX4cxmRE
        G87TXxjRP/I5iY2XqV7WFtLl5aTtRAEg0DLN
X-Google-Smtp-Source: AA0mqf7666734hzhIG2U/KjYgpyCj3PeIQsVAQsQWgZsDLq7p5iFn62D/zuoL/PagwGLpE4HJBpAkQ==
X-Received: by 2002:a05:6402:4284:b0:461:8156:e0ca with SMTP id g4-20020a056402428400b004618156e0camr19351579edc.271.1670255089592;
        Mon, 05 Dec 2022 07:44:49 -0800 (PST)
Received: from hera (ppp078087234022.access.hol.gr. [78.87.234.22])
        by smtp.gmail.com with ESMTPSA id 10-20020a170906200a00b007ae243c3f05sm6221749ejo.189.2022.12.05.07.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 07:44:49 -0800 (PST)
Date:   Mon, 5 Dec 2022 17:44:46 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>, brouer@redhat.com,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 00/24] Split page pools from struct page
Message-ID: <Y44R7i65ftm+uGdF@hera>
References: <20221130220803.3657490-1-willy@infradead.org>
 <cfe0b2ca-824d-3a52-423a-f8262f12fabe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfe0b2ca-824d-3a52-423a-f8262f12fabe@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesper,

On Mon, Dec 05, 2022 at 04:34:10PM +0100, Jesper Dangaard Brouer wrote:
> 
> On 30/11/2022 23.07, Matthew Wilcox (Oracle) wrote:
> > The MM subsystem is trying to reduce struct page to a single pointer.
> > The first step towards that is splitting struct page by its individual
> > users, as has already been done with folio and slab.  This attempt chooses
> > 'netmem' as a name, but I am not even slightly committed to that name,
> > and will happily use another.
> 
> I've not been able to come-up with a better name, so I'm okay with
> 'netmem'.  Others are of-cause free to bikesheet this ;-)

Same here. But if anyone has a better name please shout.

> 
> > There are some relatively significant reductions in kernel text
> > size from these changes.  I'm not qualified to judge how they
> > might affect performance, but every call to put_page() includes
> > a call to compound_head(), which is now rather more complex
> > than it once was (at least in a distro config which enables
> > CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP).
> > 
> 
> I have a micro-benchmark [1][2], that I want to run on this patchset.
> Reducing the asm code 'text' size is less likely to improve a
> microbenchmark. The 100Gbit mlx5 driver uses page_pool, so perhaps I can
> run a packet benchmark that can show the (expected) performance improvement.
> 
> [1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_simple.c
> [2] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_cross_cpu.c
> 

If you could give it a spin it would be great.  I did apply the patchset
and was running fine on my Arm box. I was about to run these tests, but then
I remembered that this only works for x86.  I don't have any cards supported
by page pool around.

> > I've only converted one user of the page_pool APIs to use the new netmem
> > APIs, all the others continue to use the page based ones.
> > 
> 
> I guess we/netdev-devels need to update the NIC drivers that uses page_pool.
> 
 
[...]

Regards
/Ilias
