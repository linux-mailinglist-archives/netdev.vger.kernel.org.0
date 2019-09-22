Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 187CABABEC
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 00:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbfIVWW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 18:22:28 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46751 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbfIVWW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 18:22:27 -0400
Received: by mail-io1-f65.google.com with SMTP id c6so15740772ioo.13
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 15:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=hImOzMJ05KmBv4g1KzY6JsfY72PzUxGoGBvm1paBJpM=;
        b=LGqOAQrDCH7KD0IkMFNMW57vSH55x+6WbDjd+go1NQvZ9dUbZq/P8FVdunL40Hde4j
         2vjuAIMWnuCjHR4/pgoOyWvSSlh8IA/OFZnDV3Mv+7twIMdSIc1Z6X57Uj6bPn6orJuQ
         +2zQy8jS4pFoMfk9EVpO2Pgg2XN+zaNhWWaeairm6fQz0eWyUwSPTWWRiOuilW+ltgsM
         Uic0to6pKBNioMBtARf8M26aP7qmc9AqrVgQs41vDHouCR5T0fSnKnJor93xoaEP7LKw
         8r9EtllMMhHvjvK7TD93tWAZqqev2J++wziySKgO5Aj1IWl+nkOmU25P0vYlR7hzA/6q
         Ob7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=hImOzMJ05KmBv4g1KzY6JsfY72PzUxGoGBvm1paBJpM=;
        b=g2dKQNlMKWzf5fc7TK1Am8VycpPH4QrusTvpL2yfAs5Gude2Hr5NGGOGE2uwIrltCT
         Qq4EE1mTuzgkcgDsPULcuKaB+wkXWDrf9wHSioMcuVdIpckGuV8jIAWJPNaweq00oXkr
         pB4PR1TnDXsPGw+HrhaiPuvx2zj3lgsoCjZRB9o+yNdhXaQhWYZ5eLs/9gfTLpaS/ldL
         Aw2lBFDNdNKAXG6RyTPuXDb0tFRO+iUDSyVfz56l82XyQ0yFORj7SPxXbBsTNggINhmO
         Ja2zdMa4BgRRNZ15TdCxg7PYrYnvN4NkGbF15x/gSglCGLtwLIPeKXO9bJ7J+m5sZAph
         tENA==
X-Gm-Message-State: APjAAAU3tUgcHw4bxJj5o2oWTj00aP9hDGL4PcDir8mzgOThuUbHHB7A
        bRHvj0VKcTuSKLC2LSa8Gc9KHtgSPm0=
X-Google-Smtp-Source: APXvYqyC8GFMaLszqNzF5bZkrveNmENlCSweZt7S0Z8Fa1QnU/6Bl4atw0oHwiEOelkywLGWoSjI5w==
X-Received: by 2002:a63:358a:: with SMTP id c132mr26480848pga.32.1569189406117;
        Sun, 22 Sep 2019 14:56:46 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id e192sm10967639pfh.83.2019.09.22.14.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Sep 2019 14:56:45 -0700 (PDT)
Date:   Sun, 22 Sep 2019 14:56:42 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: stmmac: selftests: Flow Control test can also
 run with ASYM Pause
Message-ID: <20190922145642.55453135@cakuba.netronome.com>
In-Reply-To: <f35fa5a51f52fc1ef17a0a9ecd470e2a6792b3f8.1568887745.git.joabreu@synopsys.com>
References: <f35fa5a51f52fc1ef17a0a9ecd470e2a6792b3f8.1568887745.git.joabreu@synopsys.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Sep 2019 12:09:49 +0200, Jose Abreu wrote:
> The Flow Control selftest is also available with ASYM Pause. Lets add
> this check to the test and fix eventual false positive failures.
> 
> Fixes: 091810dbded9 ("net: stmmac: Introduce selftests support")
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>

Hi Jose! 

Thanks for the patch it looks good, seems like you posted it from 
a slightly different email address than was used for signoff:

From: Jose Abreu <Jose.Abreu@synopsys.com>
vs
Signed-off-by: Jose Abreu <joabreu@synopsys.com>

Could you please fix and repost? Automation may get upset otherwise.
