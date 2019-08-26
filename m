Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF799D310
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 17:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733200AbfHZPjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 11:39:53 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40785 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732598AbfHZPjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 11:39:51 -0400
Received: by mail-wr1-f68.google.com with SMTP id c3so15774336wrd.7
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 08:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=57++UNrMkrYSY6dqYWlb60q+atXYaiorteAJEBYDUA4=;
        b=AaUPxi1rFy5ko6Xhw9pNr+sJgTWiVZr14lRcqKKDWXdUU6ryQRrqIFtz1X1oUX45Lx
         OtnCWu1JpVtvcC7yCNPfmkoF9KKtd90/nYk9jDK9z9INP0/6vZTDMSiSqLR9rS3nRSB5
         qT/7Qg+h9RGlDMzrBcYbbmzbmv437OejUVstqo+KTMk5/R3t5P+j+FOlDOTBq1v7yGBF
         D3AIPaZNaoETPJUoii1YqSvWmTvzYsKt6UVT7w8vJvW7vsj1RyhvlKgbXXajiJRSGyDt
         evZI/co/PSZGJJkQiN6EBQP72YUmOEwyURtXorY6YFe1RtpZyf3LYWGFnflynzWrCWWA
         Ngyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=57++UNrMkrYSY6dqYWlb60q+atXYaiorteAJEBYDUA4=;
        b=XUlizR2lhQo0f7hGQfd0Cr/zjzYcRu0U3O78M3V51hnrBQtmu3B/ZUW2X02nfEZQx6
         5aYVQu2XokK9Frdb5kI/+TQ1oSAlnwMwdG/0LrYMz9rUDwS0ipC/MrJaeiN5e3Fj058W
         fN893ag2cTF6feg8LzRVnhsyLgzxZFQTLLZ8yGBslHRbTt9abXhBNddz0YgWdjo53NfX
         uUsR99NdEU1tquqp81ODIEuedxXlkMiOs/qhapjayUTP4lS2yHBaOzen7+uJ1VGbRRCU
         PSdIn7UXEJTQYhZwbt8kEH9NgPUv+lXI8X+LjwTY8Anx289RNYCjMuHv3a5MTnquMcYd
         Oxmg==
X-Gm-Message-State: APjAAAW/tQgxepZHauI2Qt/cQoS332ND2S2EfaSbCmJD/a5VZX+5RBXY
        XcY3VmFqcfF+sPm0YGjvZbV3RQ==
X-Google-Smtp-Source: APXvYqxYWWYHqdZBJayLsnn+kPU0RzbzaEzT3LoD5HYwDAnCfadjr/0P+dl6RyMDjUpCdUWZoOkNxQ==
X-Received: by 2002:adf:90e7:: with SMTP id i94mr21750117wri.224.1566833989331;
        Mon, 26 Aug 2019 08:39:49 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id h8sm14707349wrq.49.2019.08.26.08.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 08:39:48 -0700 (PDT)
Date:   Mon, 26 Aug 2019 17:39:48 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org
Subject: Re: [PATCH net-next v3 01/10] net: sched: protect block
 offload-related fields with rw_semaphore
Message-ID: <20190826153948.GB2309@nanopsycho.orion>
References: <20190826134506.9705-1-vladbu@mellanox.com>
 <20190826134506.9705-2-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826134506.9705-2-vladbu@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 26, 2019 at 03:44:57PM CEST, vladbu@mellanox.com wrote:
>In order to remove dependency on rtnl lock, extend tcf_block with 'cb_lock'
>rwsem and use it to protect flow_block->cb_list and related counters from
>concurrent modification. The lock is taken in read mode for read-only
>traversal of cb_list in tc_setup_cb_call() and write mode in all other
>cases. This approach ensures that:
>
>- cb_list is not changed concurrently while filters is being offloaded on
>  block.
>
>- block->nooffloaddevcnt is checked while holding the lock in read mode,
>  but is only changed by bind/unbind code when holding the cb_lock in write
>  mode to prevent concurrent modification.
>
>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
