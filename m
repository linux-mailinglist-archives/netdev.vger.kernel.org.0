Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2108C1E06C9
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 08:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730436AbgEYGQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 02:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730280AbgEYGQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 02:16:27 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0623DC061A0E;
        Sun, 24 May 2020 23:16:27 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t11so8286006pgg.2;
        Sun, 24 May 2020 23:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=b96SL8+sRaQd4BNuO23oq4bmCu1x+cpwG9cm6rdCDA0=;
        b=viFVpiWHuDc+z9efiUkJdmh0VIDdJhkAiST+Q8beFUNnLgWtubZLHcJRe/qLLGg8Ip
         oTS8O5XPHQs5ZVa21IJrk9t5LGs94tYmAROm9iFn1gJg9EDp/ugeFILzwEj705KEvBGw
         b6JOOJ8Nw5uv/ziocgKDzhB84SwhMNSQMNaUAF+Ud1gvxPqt/eCPKpnOQcblDZXukU0k
         +YBUM4j7kZBcaRI3PmXwDJ1y1cgi3Lpe6Krsm8Hb3yurUa3b1ux8WWYM8OKxnhdxfQ25
         h3j2njsqK4+wVLtpj54w7bo2yq5Pakh/CDS4wsnvE8rqEgH2ggXaQJ6GUB5Z+zZZcTX0
         lA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=b96SL8+sRaQd4BNuO23oq4bmCu1x+cpwG9cm6rdCDA0=;
        b=WJJ8B7LrkOCkPqg9R4Jo3SeWEr1/GhkSEUvQ9UlzyPRjJVms27sYjQMFM7b0uVKfvB
         BQNZ4qItBNDG2LIo90rXnqQXOQhb4gIbAAj/s21nok3xWv2Luq2PFAx/lyLeJoYOnzDh
         OVa87gEVlzwCi66iSK39KKlUpvpYTnIiRysGYDYfEfdaLRGis7r/9cCeXpGZV0nEJtAJ
         50qzs1tUuh3QcNsf6E/ZK1zt6u6LayVMvThTq5BzhFu7U1bHgTmN82O5dF/Y+lgzyygT
         K1sdXSoTs1sHtXY7HWH0CZ5yQwnfC7ppLjRyq3LooNJ6BYtaRPTtMldnwDwKiFLT7s7R
         nL6A==
X-Gm-Message-State: AOAM533p+B+L7CzhGEZXE9wl0WkWoLz7tWKgwpa+Kx9CahjImJ4O9u08
        k6TV6pcq7XRpT3l6UBRei8E=
X-Google-Smtp-Source: ABdhPJxgBcGXY7WW27C6rn95w54bsP+6x+NYWWLJeYwxugt6XN3ID/4qT8FuaL3vxAeluC7dMnrvaA==
X-Received: by 2002:aa7:84c6:: with SMTP id x6mr15776442pfn.46.1590387386501;
        Sun, 24 May 2020 23:16:26 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id v1sm12380566pjn.9.2020.05.24.23.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2020 23:16:25 -0700 (PDT)
Date:   Sun, 24 May 2020 23:16:22 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jianyong Wu <Jianyong.Wu@arm.com>
Cc:     "maz@kernel.org" <maz@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Steven Price <Steven.Price@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Kaly Xin <Kaly.Xin@arm.com>, Justin He <Justin.He@arm.com>,
        Wei Chen <Wei.Chen@arm.com>, nd <nd@arm.com>
Subject: Re: [RFC PATCH v12 10/11] arm64: add mechanism to let user choose
 which counter to return
Message-ID: <20200525061622.GA13679@localhost>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-11-jianyong.wu@arm.com>
 <20200524021106.GC335@localhost>
 <HE1PR0802MB25552E7C792D3BB9CBE2D2C7F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HE1PR0802MB25552E7C792D3BB9CBE2D2C7F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 04:50:28AM +0000, Jianyong Wu wrote:
> How about adding an extra argument in struct ptp_clock_info to serve as a flag, then we can control this flag using IOCTL to determine the counter type.

no, No, NO!

> > From your description, this "flag" really should be a module parameter.
> Maybe use flag as a module parameter is a better way.

Yes.

Thanks,
Richard
