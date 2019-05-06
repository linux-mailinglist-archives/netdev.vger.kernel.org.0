Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022DE1536A
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 20:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfEFSLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 14:11:23 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33552 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbfEFSLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 14:11:22 -0400
Received: by mail-qk1-f193.google.com with SMTP id k189so1245462qkc.0
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 11:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=0Me1KTo/zMfF7DxvunGK3RvXAhXXhY9/8XaAHBID0aM=;
        b=pFT4J9rFsls+sXP7X4unMkHvD4AuHAoSHKoplc9ZbgFJ2kTyNFa7dHRfwPGPRGybUT
         H5XDJvgUtiebSI+Rkxi2C4totrI3W8wfTlQYIjDBvJzVGVmmU7OhP/2c2ab03TvLfD8I
         XyZ2mQJHHH0vHbZmiPjn+RZ6/hf1KPwY6Bv5iVR3Z0yBMCi/bjEMjykKegUjsUBTwSQh
         v7lPdCFJ82nTFFjrlrayf4y/0cLLBc33OCRo+QGS1C4YWEVP7TwSveAs+W+sqoLj5W3e
         0GN5LiXh339lWYDovnbVRUMDJjQ0x9cBUz5Hd5oiKqSMA+aV84Iw2NbI4oVnA8ceRqfy
         RhQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0Me1KTo/zMfF7DxvunGK3RvXAhXXhY9/8XaAHBID0aM=;
        b=FQ8s5UvxxTRqf8hfjdluLE+mikDgHSv2oTYnSUpEt4YPZllYlaxLnHtM54mMNU3vYw
         9lyfcyxkt/ZFIsrs2B8Xew1Ij1KidqkKmG/02F9VwTkaC3TeEwMsd8mMmAs54ICmUXva
         4IUusrhyjwfe0nJyWvtfQyZF8qdTKddAdS56uSsum1qUMPU6t2+Ky9G5ak2gbQVcLbu+
         2LufTZORIEntW1H6oUKMTV+lsp/VE9Ye9Iin14gxYAMTx06GdvRA11DSuBIPhG8OE2/C
         FHurEz2ZJ0UewXR73C2ybd6plAotZnES0nlpNNDodxe4wO3/VWH9rNYjnoO6ck57kngJ
         gSXA==
X-Gm-Message-State: APjAAAX7mrifb0qyKpdjGAh9zWXwmthhEnrL8v6/FwkRlpSmrcXwUJeq
        ySqcJc+dSUjycUKvzGsHJRiqhA==
X-Google-Smtp-Source: APXvYqzuLcZlrnMAMf9IqLYSJv9N7CU+g691qLvsGZYmHfbnD2/O+ReNLou/Q63+FK82ZunzYKyA7w==
X-Received: by 2002:a37:de04:: with SMTP id h4mr20118723qkj.196.1557166281582;
        Mon, 06 May 2019 11:11:21 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v2sm5876838qkh.65.2019.05.06.11.11.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 06 May 2019 11:11:21 -0700 (PDT)
Date:   Mon, 6 May 2019 11:11:13 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, xiyou.wangcong@gmail.com,
        idosch@mellanox.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, gerlitz.or@gmail.com,
        simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Subject: Re: [PATCH net-next 10/13] net/sched: add block pointer to
 tc_cls_common_offload structure
Message-ID: <20190506111113.052b08d9@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20190506061631.GB2362@nanopsycho.orion>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
        <20190504114628.14755-11-jakub.kicinski@netronome.com>
        <20190504131654.GJ9049@nanopsycho.orion>
        <20190505133432.4fb7e978@cakuba.hsd1.ca.comcast.net>
        <20190506061631.GB2362@nanopsycho.orion>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 May 2019 08:16:31 +0200, Jiri Pirko wrote:
> Sun, May 05, 2019 at 07:34:32PM CEST, jakub.kicinski@netronome.com wrote:
> >On Sat, 4 May 2019 15:16:54 +0200, Jiri Pirko wrote:  
> >> Sat, May 04, 2019 at 01:46:25PM CEST, jakub.kicinski@netronome.com wrote:  
> >> >From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
> >> >
> >> >Some actions like the police action are stateful and could share state
> >> >between devices. This is incompatible with offloading to multiple devices
> >> >and drivers might want to test for shared blocks when offloading.
> >> >Store a pointer to the tcf_block structure in the tc_cls_common_offload
> >> >structure to allow drivers to determine when offloads apply to a shared
> >> >block.    
> >> 
> >> I don't this this is good idea. If your driver supports shared blocks,
> >> you should register the callback accordingly. See:
> >> mlxsw_sp_setup_tc_block_flower_bind() where tcf_block_cb_lookup() and
> >> __tcf_block_cb_register() are used to achieve that.  
> >
> >Right, in some ways.  Unfortunately we don't support shared blocks
> >fully, i.e. we register multiple callbacks and get the rules
> >replicated.  It's a FW limitation, but I don't think we have shared
> >blocks on the roadmap, since rule storage is not an issue for our HW.
> >
> >But even if we did support sharing blocks, we'd have to teach TC that
> >some rules can only be offloaded if there is only a single callback
> >registered, right?  In case the block is shared between different ASICs.  
> 
> I don't see why sharing block between different ASICs is a problem. The
> sharing implementation is totally up to the driver. It can duplicate the
> rules even within one ASIC. According to that, it registers one or more
> callbacks.

If we want to replicate software semantics for act_police all ports
sharing the port should count against the same rate limit.  This is
pretty much impossible unless the rule is offloaded to a single ASIC
and the ASIC/FW supports proper block/action sharing.

> In this patchset, you use the block only to see if it is shared or not.
> When TC calls the driver to bind, it provides the block struct:
> ndo_setup_tc
>    type == TC_SETUP_BLOCK
>       f->command == TC_BLOCK_BIND
> You can check for sharing there and remember it for the future check in
> filter insertion.
> 
> I would like to avoid passing block pointer during filter insertion. It
> is misleading and I'm pretty sure it would lead to misuse by drivers.
> 
> I see that Dave already applied this patchset. Could you please send
> follow-up removing the block pointer from filter offload struct?

Makes sense, we'll follow up shortly!
