Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813301F85C2
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 00:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgFMWkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 18:40:37 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:42150 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726728AbgFMWkh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Jun 2020 18:40:37 -0400
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 05DMeKVd019295;
        Sun, 14 Jun 2020 00:40:25 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 641D9120069;
        Sun, 14 Jun 2020 00:40:15 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1592088015; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1YTwWfivUt1tSuIOMHks9jBd3XnLGThjeWZ7z8Bddco=;
        b=8MRwRyzYlfnAFx9HqyjoOyTvtnIkg2PUo6gQ2SgqHvU+AGRoSdriRW0pD6Yx0CpcNQb0aE
        ATNWS+xtCxu1I1Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1592088015; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1YTwWfivUt1tSuIOMHks9jBd3XnLGThjeWZ7z8Bddco=;
        b=A13y3PH2HLQNtp/dPt47GBNTTsXv6LqEG77h1Rsm4evjDwpO5fjwG6UXmGyIMh8q84f3i+
        0nUMZ8JiSDSw3JOXNvpF867Ir3prnYX99b1lCdMIqeDnWWHX+zsy2Y3552SyuVhxGtzTcR
        OE0uvu5HruAiGnO2TOd87k1vMyJUhgPDt1fa86572K72PMonc1uRqsi4TRJlk3VpI2yHHW
        8hdEuoOkOueXUN8KgWoPHCjR1V1LI2Ovi1T/9zXEMQccMx6az4wNS2LF/GmAlvkCEBzdC0
        cmeyUX4+MWVHYyIA0zQ9q4nVffCLCzv8ltdZ20b+v0cqM6/goNfn3jf/UpFEZw==
Date:   Sun, 14 Jun 2020 00:40:14 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Donald Sharp <sharpd@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Dinesh Dutt <didutt@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [RFC,net-next, 3/5] vrf: add sysctl parameter for strict mode
Message-Id: <20200614004014.582e20b9f2c2c786deca9779@uniroma2.it>
In-Reply-To: <20200612105227.2f85e3d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200612164937.5468-1-andrea.mayer@uniroma2.it>
        <20200612164937.5468-4-andrea.mayer@uniroma2.it>
        <20200612105227.2f85e3d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Jun 2020 10:52:27 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> drivers/net/vrf.c:1771:49: warning: incorrect type in argument 3 (different address spaces)
> drivers/net/vrf.c:1771:49:    expected void *
> drivers/net/vrf.c:1771:49:    got void [noderef] <asn:1> *buffer
> drivers/net/vrf.c:1785:35: warning: incorrect type in initializer (incompatible argument 3 (different address spaces))
> drivers/net/vrf.c:1785:35:    expected int ( [usertype] *proc_handler )( ... )
> drivers/net/vrf.c:1785:35:    got int ( * )( ... )

Hi Jakub,
the fix will be in the next version of this patch set.

Thank you,
Andrea
