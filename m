Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 406DFB8898
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 02:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393155AbfITAiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 20:38:02 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40744 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390299AbfITAiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 20:38:02 -0400
Received: by mail-qt1-f193.google.com with SMTP id x5so6653729qtr.7
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 17:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=CN7jg6OOuzm2zBD9WcFz76HJfo92xCps7bkvCZHXEwo=;
        b=GNZLKsHruEqz9+MCYy7iLHiodTGYi5xgfgHle3VyEGqAmbvcSfwblet85KZ9t57S3x
         V1AmjQyi1ig6zquy/0YjnGAt2DI1fXPqbNTjmbJeKKa93vvAyLn3ZoJU9ED3K/mGKtTP
         S+iDWYlJAS2/kay+Hf2CPceCt+kevLATsP1a9sjeQT+/sTBNkgNZJNzEr3PMBA+xBhJm
         Qb5D7JDxHkB/i2wrI0D/DALNGpowJszHYCR1PLobFxbLx1wF35YSW7BTF59JvjTc4F9q
         HC4X7h7uDlzwwjy6K3VZfYtt8FxlIcTcNVelaLSNWY76e/p3zvgAJVAV6pviIs+aIEA1
         mrQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=CN7jg6OOuzm2zBD9WcFz76HJfo92xCps7bkvCZHXEwo=;
        b=ArtnE+sIbGFpyagVhXR/0dYgwVa6/eY/HeFwikZo/iqyHvIWJ5KG9A/lSwxXNsdyyr
         ywZ6BZSRNYR4TI6BIoUxeu9gvdLgLLIalgL+HTMnOeGujTU76bCTWXn55nX8Ibp5Q7yi
         og/MS+P6UVcwwYY6Rzm9G95kL2c668zZizUteBgi8hnLYGT4j2JrRJ7XgNwrx//NL2kg
         byXPdOtLawUQlDD2QHQUhU4BLoP0TkgCOaaRap+KFT9w2tA9ZlbXoKHIr0Y4m3aQUaoC
         wZ4BoRZl5G32XrOxsoAGkbbNMNb6LsAaqrfjCLWuwCwvgckHQ82CnJMkoO/mmY/ZItpy
         6IvQ==
X-Gm-Message-State: APjAAAUuX1HjLDZwRScQtgpaq1UuAHup+KYSmKCqIAud44nIbYDHzkPi
        PrildAWUrtt/AYIaV7F4YGKibw==
X-Google-Smtp-Source: APXvYqwSnublFYl2uW/GnoB2+Q7KUfNbKnCul0+EO0UDQ+pfYdBIwCKkb84J3c+zzyqGAHp5jXyzFw==
X-Received: by 2002:ac8:124c:: with SMTP id g12mr86619qtj.81.1568939881082;
        Thu, 19 Sep 2019 17:38:01 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l14sm131844qtp.8.2019.09.19.17.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 17:38:01 -0700 (PDT)
Date:   Thu, 19 Sep 2019 17:37:57 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Murilo Fossa Vicentini <muvic@linux.ibm.com>
Cc:     netdev@vger.kernel.org, tlfalcon@linux.ibm.com, muvic@br.ibm.com,
        abdhalee@linux.vnet.ibm.com
Subject: Re: [PATCH net] ibmvnic: Warn unknown speed message only when
 carrier is present
Message-ID: <20190919173757.0a6b1194@cakuba.netronome.com>
In-Reply-To: <20190916145037.77376-1-muvic@linux.ibm.com>
References: <20190916145037.77376-1-muvic@linux.ibm.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Sep 2019 11:50:37 -0300, Murilo Fossa Vicentini wrote:
> With commit 0655f9943df2 ("net/ibmvnic: Update carrier state after link
> state change") we are now able to detect when the carrier is properly
> present in the device, so only report an unexpected unknown speed when it
> is properly detected. Unknown speed is expected to be seen by the device
> in case the backing device has no link detected.
> 
> Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
> Tested-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
> Signed-off-by: Murilo Fossa Vicentini <muvic@linux.ibm.com>

Applied, thanks!
