Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8D133E1EE
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhCPXOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhCPXNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 19:13:52 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC093C06174A;
        Tue, 16 Mar 2021 16:13:51 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id dm8so53283edb.2;
        Tue, 16 Mar 2021 16:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h5N8UTmG4BZkHgZ0YH1ThX18H8zJMwY/JOz1fXn6pws=;
        b=mzgvGSEhdP9YNGKVnnNL4T/PSMciLfuSgzIsQpdebraeHI8fvFwCeQnn6wuOJZoEZ9
         TmcY/4aAp5ttXtYOMPOVe6xi5Zm399duWRlrlz9pPqJJPPIeG1S+mRmkUfAKpr1jpWmC
         t2VSiu+pFEDxmbWllndyuaEa7HeorK7IyPiImZjUTbWIu7u5BfQffJ4XlaXk9SYTn14r
         mnl6vzwE9tHWGExWMyrFYb4H7R/KnXoalxnLUPZqoUhGseGsexr6D0JHa/fKshl8Q9/F
         8MOrUaNt+z0GqLGm4AXXhnvpibRmbJE3vrLsN/tfSfibb59+g+9ZtDvGSFFJDkv/u64j
         BSiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h5N8UTmG4BZkHgZ0YH1ThX18H8zJMwY/JOz1fXn6pws=;
        b=Gfpx8nnRA4rTSXN79WNAagnk5bnMadRe7F+qmGfzJLpqkWL4yY8Xr8ZAzRs0Gq1TkW
         MkplI/RVZTe/mrHLN1Lr1uTUk9aveExM/rSfOm8zwJ5c7ly04tt/I+ZveOFYzhZFjcON
         9UGjr9eaW9R8PaH1rmQw63HMFO3WN1vT2ztatkmNMian8cHhcvvEzs0T4J01jcF627+G
         CaUgdFET/BUZNwYu7bb4ljCs8C7rhtBsXXorNpSEQFZIeUgUgWgmevZGL4Y9d6qDaSf1
         oW9UD9FTa7xrRulhPxx4Y89dl1rOGG/MItiA5kxur23niQdlb3iqtKjiLNYYNsXUZvQX
         wIUQ==
X-Gm-Message-State: AOAM530uVUggqdNu8LtJye8MZcsKSfIWKVB4wDfh/UVj+tJfv0+8Uk37
        8Adht36NNA72Up9CBTxYscA=
X-Google-Smtp-Source: ABdhPJwTG5lrlgdEF8gA6AnOhk+qd5k6M/gFTkc9u3PyR1fo1pesNLyYo3GBIAf8LlV0RTxZHPAYaQ==
X-Received: by 2002:a05:6402:22bb:: with SMTP id cx27mr38447509edb.148.1615936430519;
        Tue, 16 Mar 2021 16:13:50 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r17sm11352598edm.89.2021.03.16.16.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 16:13:50 -0700 (PDT)
Date:   Wed, 17 Mar 2021 01:13:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/3] net: ocelot: Add PGID_BLACKHOLE
Message-ID: <20210316231349.px2b3ofqwjgu2nct@skbuf>
References: <20210316201019.3081237-1-horatiu.vultur@microchip.com>
 <20210316201019.3081237-2-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316201019.3081237-2-horatiu.vultur@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 09:10:17PM +0100, Horatiu Vultur wrote:
> Add a new PGID that is used not to forward frames anywhere. It is used
> by MRP to make sure that MRP Test frames will not reach CPU port.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
