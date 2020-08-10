Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6952A240AD3
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 17:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgHJPwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 11:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgHJPwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 11:52:20 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0E5C061756
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 08:52:20 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id o1so5139763plk.1
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 08:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=WI8K83PkYalZeM6/hJkTMq/iy77hPEbGTf5cim2uTDQ=;
        b=d7yzMInmitwEnvtU9xCW6u2Ba1AUOrgQVDK5+LKTvQq6eeFLNegqlIkX1kamBolTrh
         Ml+/tFlGs7czTfkuBbXPltB5jRYjMwJR1uSPpl29FzL3EHDTKBPyZI2PS9mBXta+/3Ea
         c/Ckws9RjN3TrJ/a3GovvHQ0By2+/byccp6Tl/VZIGnqN+JNU8vFnY+VnNxbnJxuUM8T
         odxxQxXt+rU5SaCpdexEQyq6hoR6nFPdTTqps/t/qpP/vB1pCB/S8MhQ4Y5WUx3ipNoA
         1j1EmYFalozBPykqa8aCBoXlQN+TTBflpTjjOT3DSx6kH3uQYMZ7pSpzRDi/upiMwY8+
         sLng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=WI8K83PkYalZeM6/hJkTMq/iy77hPEbGTf5cim2uTDQ=;
        b=UJaCv0FuTXbYsntVlWc5RgcDdHNnRBbHau6FqQhGODo5M9lCmRndctJ7E4NtT+otYz
         DcHHU7lSjbpacvU9x6V7IC6MODcoaTLXVv0DpSTr0tWykObsuc/o/yz9vu51m7rDcq9O
         wVlorGnss34LKXJ6GGlN1Y5rwXIM0pBIbeaU8PVReKeuUTXCD03+d3RPLotGQmVEKwke
         FRPB1U9XHyA714BxCftx3J0k/6equNl7xx6khLPQOn6oDkdtmysmQKl/lH55QG9JHsp2
         eZA4dqJNZfyyd91r4szCQBnC/jnKxdWzcPRPlmPcqB1SktWPexGzoG87jxf1ZYz03OqV
         iU5w==
X-Gm-Message-State: AOAM531xO+UP/lmXh7Va2FqxgYI/r3hHBV4GX8dmaG0CAoQ+irZM8Zhr
        4PrFRBxmqOA04QiRz5JrFqK0w9Sj
X-Google-Smtp-Source: ABdhPJxFjIUK/vy8LJF2z6SWQmpjwqDhcPAz0Q4wdC1604vlNq1uqd8+1AJoco3uEbAGUpF9VxmvKA==
X-Received: by 2002:a17:902:c213:: with SMTP id 19mr24624983pll.95.1597074739699;
        Mon, 10 Aug 2020 08:52:19 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u24sm22407344pfm.20.2020.08.10.08.52.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Aug 2020 08:52:19 -0700 (PDT)
Date:   Mon, 10 Aug 2020 08:52:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Edward Cree <ecree@solarflare.com>
Cc:     linux-net-drivers@solarflare.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 03/11] sfc_ef100: read Design Parameters at
 probe time
Message-ID: <20200810155218.GA175192@roeck-us.net>
References: <12f836c8-bdd8-a930-a79e-da4227e808d4@solarflare.com>
 <827807a1-c4d6-d7de-7e9c-939d927d66cc@solarflare.com>
 <20200809002947.GA92634@roeck-us.net>
 <dcb8dba7-d259-4aa3-96d5-066b725ae84b@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dcb8dba7-d259-4aa3-96d5-066b725ae84b@solarflare.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 09:15:20AM +0100, Edward Cree wrote:
> On 09/08/2020 01:29, Guenter Roeck wrote:
> > On Mon, Aug 03, 2020 at 09:33:20PM +0100, Edward Cree wrote:
> >> +		if (EFX_MIN_DMAQ_SIZE % reader->value) {
> > This is a 64-bit operation (value is 64 bit). Result on 32-bit builds:
> >
> > ERROR: modpost: "__umoddi3" [drivers/net/ethernet/sfc/sfc.ko] undefined!
> >
> > Guenter
> Yep, kbuild robot already spotted this, and I'm trying to figureout
>  the cleanest way to deal with it.
> See https://lore.kernel.org/netdev/487d9159-41f8-2757-2e93-01426a527fb5@solarflare.com/
> Any advice would be welcome...
> 
Answered there.

Guenter
