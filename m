Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39C72640DA
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 07:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfGJF5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 01:57:16 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35130 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGJF5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 01:57:16 -0400
Received: by mail-ed1-f68.google.com with SMTP id w20so816075edd.2;
        Tue, 09 Jul 2019 22:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gJAx2qQTU93m+bCh71C22HskJxiWkG6DmgTcMb27tPM=;
        b=Zc9YnkmEMq3c54zuojXF8A546raU1kiI5/Y9LDUZmrLw/kY7ScY9kaqFx1tfhkUubE
         C1ECA9L9ZptcBpmXNg+5IWtRNBDi9PIjxrf1LG4Z14MkcMZcJr1XYqgRmVRAIZq3BDks
         56sMW8abqRu1E+hOo90chE1hxY34HEy7d6IBXYsliK2n6kUVc0SK4nSv7Q0Rswl03WEc
         fUTUNt1brqmS2w9ix6eD/ytHhE2/kbeEAsvfbzQ/5XiRwJJVrMj74rwAD+zCgu88QNN6
         jNzuVN5lf7q7Om1JFh12rbS1apM/g7lcBrGd74HX9P9igE49SPYBqwizmX6BfDdBHE4f
         1KkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gJAx2qQTU93m+bCh71C22HskJxiWkG6DmgTcMb27tPM=;
        b=MQPtz+KFywpzwi7NY+sttMkNo6mxcKHalD/PGDuQJZCEDCnyM3YwvJuX+Lyeda++II
         qZfNHInsbuPtI5O+yLioorBdSTZDqJBQS0BgebrBvLYHCq4jOrrGTvjxIFkJamhzHl5y
         RNWU23ac8mwYa8ECsAPNeunjv6glIcelDZiw46vk2OT51OKZT5hm5aObwJbQaN478AjZ
         Rl2k1s2aHtlFPmM4dzqtS5PwYW5/qx0i+adFOMv2Hvq9drFWddahw4/lcw8nKRS4+7WX
         5IoSxpovEWFkhMuTzR6FW3gw2pxk78geX6kdUrefdP3JeBZcGjvzyBRvFllDN+oZVVc4
         +fFw==
X-Gm-Message-State: APjAAAV/nybX2OvpmJF0NH5MOp3K3+Sj0EhzoG/2K+GjCVZ6F0hm9T3S
        ZWOoNZH0VIbcmcsBP5SV/whq2NH1jZsofA==
X-Google-Smtp-Source: APXvYqw8Cpc8UEm2hUL901ll/sUhvLcWmh051Kcc1OYlue0B7D5yMOFjcx94Sy69k5uU/qfayrrBYw==
X-Received: by 2002:a17:906:84f:: with SMTP id f15mr8820492ejd.22.1562738234262;
        Tue, 09 Jul 2019 22:57:14 -0700 (PDT)
Received: from archlinux-epyc ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id k25sm142727ejp.65.2019.07.09.22.57.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 22:57:13 -0700 (PDT)
Date:   Tue, 9 Jul 2019 22:57:11 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     saeedm@mellanox.com, leon@kernel.org, borisp@mellanox.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        ndesaulniers@google.com
Subject: Re: [PATCH v2] net/mlx5e: Refactor switch statements to avoid using
 uninitialized variables
Message-ID: <20190710055711.GA52052@archlinux-epyc>
References: <20190708231154.89969-1-natechancellor@gmail.com>
 <20190710044748.3924-1-natechancellor@gmail.com>
 <20190709.223657.1108624224137142530.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709.223657.1108624224137142530.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 10:36:57PM -0700, David Miller wrote:
> 
> I applied your simpler addition of the return statement so that I could
> get the net-next pull request out tonight, just FYI...

Thanks for the heads up, I'll spin up a v3 just focusing on the
refactoring.

Cheers,
Nathan
