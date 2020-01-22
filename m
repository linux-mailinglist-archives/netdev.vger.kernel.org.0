Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1EB145F52
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 00:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgAVXph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 18:45:37 -0500
Received: from mail-pf1-f179.google.com ([209.85.210.179]:37956 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAVXph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 18:45:37 -0500
Received: by mail-pf1-f179.google.com with SMTP id x185so593475pfc.5
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 15:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BsgFl0ZNFiD73iCKTJQPfPLfGgrqLNO0kJzFDpfi5rw=;
        b=NKu3MVBP4tv7QI7UHUo8YwSEIiROh1W1O21fs6umX9359qBnybevWLoDOhBsLHKIER
         KQ8M3HevaIBBvTE80H2VvgQGAWJwUEMuDU3s2fFp8JWsmS+l4JtXjHeZB6RJ6rs94FXZ
         S/2wtx5BYyHffZ/qE9p/VSDRttw064W3vlAXSq3q2R5rtP7dYrsYOQMA5Wgk2AZ8CKlH
         UrNn9PDMw5FyyiE39oNPYQNyckD2YBBe5Hbw1u9AGc0lblO5Y7UQvt76Vw6+ZU8iUGzl
         FG/J4JysYq+VZUWa7qawakGdQlgKMOoXAy/JPxjG0OmUMzU0dBl/p8TCSGKhL64ZqFvE
         sJAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BsgFl0ZNFiD73iCKTJQPfPLfGgrqLNO0kJzFDpfi5rw=;
        b=l/6MhJcLXCgzbKPoBFZi5uSr7OjXJ/HI4QHdmm6rE2l7rR2ve5jD1eMR1SNnCfJ31I
         N1+2gr2z8XQFPGXtIBc0U7l1O6fRbCv9sMrkxuvDHlBoJWBiCAquyCH/q+jR2YyA3ptJ
         ODMq9rATk+OLLpR4QBEPy1Dn6WAGPc7HyVQvtwOljE1Oddu4lP+wV8H5eiMcYw6pE12E
         3MStkMktaSLb5ytsDFfJnhEjRwnJcpQwtBNgrK5Cw7QROP7mL+fNawLjZqKU08ygmW1f
         F0vpqwmPDhWKIYrTPiMQH0HqeDGiyYiRwRATT73Ja44r0j0cLrorlauzN2o4ga/yEJ+X
         JOAQ==
X-Gm-Message-State: APjAAAVA97Amrb0wWy71PNMRg+m5nCqgpj0N0Y6+fwhw21QGGlSD2JLx
        sFaQ17Jf9t/yQRuoJpthnak=
X-Google-Smtp-Source: APXvYqzK+i1yLSTifNBusAkg2T4wfsbHkYws0Ff4/O86aUuYFRky+tbglLvmKuHq8lk7cuGunjxIeA==
X-Received: by 2002:a63:dc4f:: with SMTP id f15mr754863pgj.300.1579736736933;
        Wed, 22 Jan 2020 15:45:36 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id i17sm54570pfr.67.2020.01.22.15.45.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 15:45:36 -0800 (PST)
Subject: Re: [Patch net] net_sched: fix datalen for ematch
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     syzbot+5af9a90dad568aa9f611@syzkaller.appspotmail.com,
        syzbot+2f07903a5b05e7f36410@syzkaller.appspotmail.com,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <20200122234203.15441-1-xiyou.wangcong@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <317521e6-07f5-c32a-66dd-8aa499ae80d7@gmail.com>
Date:   Wed, 22 Jan 2020 15:45:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200122234203.15441-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/20 3:42 PM, Cong Wang wrote:
> syzbot reported an out-of-bound access in em_nbyte. As initially
> analyzed by Eric, this is because em_nbyte sets its own em->datalen
> in em_nbyte_change() other than the one specified by user, but this
> value gets overwritten later by its caller tcf_em_validate().
> We should leave em->datalen untouched to respect their choices.
> 
> I audit all the in-tree ematch users, all of those implement
> ->change() set em->datalen, so we can just avoid setting it twice
> in this case.
> 
> Reported-and-tested-by: syzbot+5af9a90dad568aa9f611@syzkaller.appspotmail.com
> Reported-by: syzbot+2f07903a5b05e7f36410@syzkaller.appspotmail.com
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>

SGTM, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>

