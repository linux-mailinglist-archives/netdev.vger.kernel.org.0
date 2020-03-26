Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E84B819411C
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgCZOSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:18:08 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36347 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgCZOSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:18:08 -0400
Received: by mail-pj1-f68.google.com with SMTP id nu11so2461827pjb.1;
        Thu, 26 Mar 2020 07:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BA2bA9PavUC7l7dbOSeDNGiZmDysCoavq5nh0AKiFpY=;
        b=jyEnc4F39900X3l7jblWNG3p0e4wzQF8tYoEsOLU0HfEZa1i5EVX6jRqFleD+SHmEQ
         79zOTgjI5TxA/Tc/SybR0T3OkTkDOhVK5PhpF7M4WFfQuh54uPLmUdegVJH1xlH/PjgW
         4E1gMLyay0W4PkcGASKSNGmPbDG6QyKGzszx04BUSkiI5d9mJxsKPl8bvDPwNkq2hhYW
         sGRStwwcVZdphe3bKY+zgymraMQGl4WDYs4B+8YIgMlhKtRHEokEp5fb6qAZA/KOx/FS
         nkKHon4++DPYXUNluZlaz9w3LiCOXuiCgTZ8LB9WFNTwqAAA9LbmHoLvNdfwPFcWTila
         ZKXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BA2bA9PavUC7l7dbOSeDNGiZmDysCoavq5nh0AKiFpY=;
        b=CQFkAxw2Djh9kv8Vr/LAAPrqFymxu+u/G9/TlgxXwS76J5dIMS/WD2qMFIwBv2u4+K
         11eS161PkvW/mwnPF0juY1sVqgwAIFXJ1qyAxXvuyx/XPltJ20ZGo3JKjaSIDxnYeYmT
         /fdqwQw9Fhj5SXa5NlucvcBHbLPNb3KZMwqdgwqY8BEFX+gCth9nHDTgYwr2CTZv3pWA
         yf8DPf7AWy8LlQTZZo3nocOlcGnIy42fcg81gO6zsAoWLsi2xGyHYtn90TeP9xgnKrU4
         O5HJ851CzGm1ys6HrLdW9rWXImnwHVO2Tu5pyH7rEwUOG7dwoWkKYaaNnmEBOOpHt9FA
         UClw==
X-Gm-Message-State: ANhLgQ36PMCKoP561hHQfBnnEhj8jBGbtP24v4AKoAURBire+IudVY9x
        oyq3Nl4NJ8KB5ghlVpsw+PI=
X-Google-Smtp-Source: ADFU+vsIwvpB25Rifcmkllw3Yln+dgc/3yaAaaH6TDoiKd25tKlDJPlPSD6wqJHK/AI4Y07gtLiCPQ==
X-Received: by 2002:a17:902:a986:: with SMTP id bh6mr7751713plb.100.1585232286954;
        Thu, 26 Mar 2020 07:18:06 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id a3sm1788882pfg.172.2020.03.26.07.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 07:18:06 -0700 (PDT)
Date:   Thu, 26 Mar 2020 07:18:04 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 02/11] net: ethernet: ti: cpts: separate hw
 counter read from timecounter
Message-ID: <20200326141804.GC20841@localhost>
References: <20200320194244.4703-1-grygorii.strashko@ti.com>
 <20200320194244.4703-3-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320194244.4703-3-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 09:42:35PM +0200, Grygorii Strashko wrote:
> Separate hw counter read from timecounter code:
> - add CPTS context field to store current HW counter value
> - move HW timestamp request and FIFO read code out of timecounter code
> - convert cyc2time on event reception in cpts_fifo_read()
> - call timecounter_read() in cpts_fifo_read() to update tk->cycle_last

This comment tells us WHAT the patch does, but does not help because
we can see that from the patch itself.  Instead, the comment should
tell us WHY is change is needed.

I was left scratching my head, with the question, what is the purpose
here?  Maybe the answer is to be found later on in the series.

Here is commit message pattern to follow that I learned from tglx:

1. context
2. problem
3. solution

For this patch, the sentence, "Separate hw counter read from
timecounter code" is #3.

Thanks,
Richard
