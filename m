Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFB51B519E
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 03:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgDWBJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 21:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725846AbgDWBJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 21:09:06 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA71C03C1AA;
        Wed, 22 Apr 2020 18:09:06 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id z90so3520545qtd.10;
        Wed, 22 Apr 2020 18:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=kZZMnaMcQBhqgDirEUTn32VjbGAFtif280/VGW3b7tM=;
        b=l6ydBg84WwlNBhjVzvPLRYViPmZVw2+jsuX91n4Q2yEPNiCmXu0OR0R78xyG16cFhP
         7vzMMCMVcPIDY4GP460kf6MDMj/NchqVEvqDdHNYLQ8qMFPHZerWFL04pxTIZzvY5ZGj
         qDmiZo0fQmeHKX9eWZhGK/JqBZ2lUT4jy2RXbXRapoVAnheZLT9AQknFUrhWIG9FBWS4
         os37T9gcx6KLmUPBVfF4V11y7trRcmcUc9x4VlwhqDJ73z603IZWvCXPGPKz6TuqlhTc
         iQVEpX7omXZsrZXx3d2k+ADCwADFTRyQ8dJ2f8/zHPgX4R7mmNlhqBHMq+Uu0xchBF+n
         /AqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=kZZMnaMcQBhqgDirEUTn32VjbGAFtif280/VGW3b7tM=;
        b=P3Pt9wedBHWXKkrdllt9To+2yM3FGh1vlMMNqVRDjwLoTrHa4UsWPh3bQgtm98/1PF
         h8c0XpEoaeX/JATWJxX5VWRJj2lmOG+a0w0X1OhN0WgNV/ZBdTZY4DAqoxg3jtsG6rrF
         YnDLtO+6ECPZmPGXvtNBPugalH+XWAS5Mv4h+zF4XgTtuSC2THQu5yoXE50TryEI/FhU
         DkUH73Giz/grN4bNHwechPRYY1nVi4Mhwo4XqCBDCAC4FzlhgPIQqfxujfNwtLNcERla
         rSvcDxOKfLH4xPFcJbvDsDc/PO2/Bx8DjLd+DTnhyTMyvAEU57YoDVonGGpg2knXTJ/u
         j8/A==
X-Gm-Message-State: AGi0PuZkKu5S2+27fhjm5ZuIcGaJjSRCGXp1j3EmHqqZ6uN95z3fvfx+
        ANDO2ZqGa3Z/YthMo1cXSwrI4YY0Er1DXA==
X-Google-Smtp-Source: APiQypLUdaaqQUhuNrOVSIcBe9VAT3uf/QE4slr9wQlhRtKtCoHjAlpSHcABbZnynVh0Vyjph0ZWcQ==
X-Received: by 2002:ac8:346f:: with SMTP id v44mr1552672qtb.27.1587604145665;
        Wed, 22 Apr 2020 18:09:05 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:6408:158f:9d03:3b46:2548])
        by smtp.gmail.com with ESMTPSA id f68sm676952qtb.19.2020.04.22.18.09.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 18:09:04 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 91380C1D6B; Wed, 22 Apr 2020 22:09:02 -0300 (-03)
Date:   Wed, 22 Apr 2020 22:09:02 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jere =?iso-8859-1?Q?Lepp=E4nen?= <jere.leppanen@nokia.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S . Miller" <davem@davemloft.net>,
        Xin Long <lucien.xin@gmail.com>
Subject: Re: [PATCH net 1/2] sctp: Fix bundling of SHUTDOWN with COOKIE-ACK
Message-ID: <20200423010902.GB2688@localhost.localdomain>
References: <20200421190342.548226-1-jere.leppanen@nokia.com>
 <20200421190342.548226-2-jere.leppanen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200421190342.548226-2-jere.leppanen@nokia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 10:03:41PM +0300, Jere Leppänen wrote:
> When we start shutdown in sctp_sf_do_dupcook_a(), we want to bundle
> the SHUTDOWN with the COOKIE-ACK to ensure that the peer receives them
> at the same time and in the correct order. This bundling was broken by
> commit 4ff40b86262b ("sctp: set chunk transport correctly when it's a
> new asoc"), which assigns a transport for the COOKIE-ACK, but not for
> the SHUTDOWN.
> 
> Fix this by passing a reference to the COOKIE-ACK chunk as an argument
> to sctp_sf_do_9_2_start_shutdown() and onward to
> sctp_make_shutdown(). This way the SHUTDOWN chunk is assigned the same
> transport as the COOKIE-ACK chunk, which allows them to be bundled.
> 
> In sctp_sf_do_9_2_start_shutdown(), the void *arg parameter was
> previously unused. Now that we're taking it into use, it must be a
> valid pointer to a chunk, or NULL. There is only one call site where
> it's not, in sctp_sf_autoclose_timer_expire(). Fix that too.
> 
> Fixes: 4ff40b86262b ("sctp: set chunk transport correctly when it's a new asoc")
> Signed-off-by: Jere Leppänen <jere.leppanen@nokia.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
