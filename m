Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59E557CBAC
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbiGUNS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbiGUNSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:18:23 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB87CFD02;
        Thu, 21 Jul 2022 06:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EhWcWfbhv9nEoWrIjYVp9DqpCcdMz+PUQQozGn2KheY=; b=giItKgd6wvCs3BDkeINniObKTc
        CeHEjDJ58dT7M1nCbsCw166d42VASgHXPV143OBJu0Vs+E/vqom0rLMx29isjOsh/0+wbpM4jMxCE
        2hO8q8AabrVuw4vRyHWHo+yY1zS1qVtrJ2RPdM/jr0DkEVoZ7UZbFC+f/UEcETwzamEcMKKFlRRgG
        /Zx/oBSph+Ox1u+GFKdG+fdNSCrTEqXJ5LuOMnrK43kaQv3HeoBligMAIIoeWIUfq3vD8R49RXCVr
        YrvUYr3xDDYMEgJGtTVYRYHytdArtbrkNJgeQC2HNdHoEyCxWAYXNgP8TN7Qq6zABWOyFjlZ85+QZ
        CqmKt2vw==;
Received: from 200-100-212-117.dial-up.telesp.net.br ([200.100.212.117] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oEW3w-001UDx-KO; Thu, 21 Jul 2022 15:17:56 +0200
Message-ID: <104364ae-ff8f-5657-0185-6b28ff9fbfcf@igalia.com>
Date:   Thu, 21 Jul 2022 10:17:26 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 04/13] soc: bcm: brcmstb: Document panic notifier
 action and remove useless header
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, akpm@linux-foundation.org,
        bhe@redhat.com, pmladek@suse.com, kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net, halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Brian Norris <computersforpeace@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Markus Mayer <mmayer@broadcom.com>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-5-gpiccoli@igalia.com>
 <20220720230009.2478166-1-f.fainelli@gmail.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220720230009.2478166-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/07/2022 20:00, Florian Fainelli wrote:
> [...]
> 
> Applied to https://github.com/Broadcom/stblinux/commits/drivers/next, thanks!
> --
> Florian

Thanks Florian =)
