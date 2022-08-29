Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A756D5A425A
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 07:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiH2FgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 01:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiH2FgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 01:36:04 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B3517E36;
        Sun, 28 Aug 2022 22:36:03 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id w196so9194241oiw.10;
        Sun, 28 Aug 2022 22:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=YPIk4Y6Ukvku/o4Tv5ZXhZ7lEnBtiiRp5ib7DSWGFM8=;
        b=Y2xNXQgUOvz57ZKdc/N+XMhEmLBm3bj1XlrpxOKnPOLBHuD5HmoY+DnVWRW0mN6ADh
         VPvL08VGntcxFZlFmTsY0KVnEMpTn2crFVNbylHVURnsprc1R4w+ono9iXtTBWTwWyXU
         x8EaxkKwqg9+puYxL/yEm3qTriPDWm74Z5kLYF+UgeKsEYEknMN/fCEXpHd8nt+8FljG
         nzbWg/aQakThnqhYoMXVVZk+TTTYsKC/Pg2YtsoOh64hr86qXWJR1my4Z5l93GMcQr1G
         fDMQleXph7i5wXyuigTsrEwfCeKUKZaIhPoezvyykO0QXPHnk1B0YvbB5JUSVdj3cIBl
         Gsrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=YPIk4Y6Ukvku/o4Tv5ZXhZ7lEnBtiiRp5ib7DSWGFM8=;
        b=GXZ1KWKE6DE4vGR59zTYfqeCGMYf/Vn7lyEpFWU4qUqklDF8QJ/hmGp9YuTuodGMtw
         ut2Wpm+owjv0f7cliL4d2N3l7Sp//pmd8fZkXnSpzPpj9a20yosvy8CB32isicvnqvSj
         5jahGgbDuK46hlGdmZyPucaUq86h18iSpS3uf9Jz0JzBMVAeaxyIFrqAYbNhLwOPf0Cr
         h5wFarbEod7UiXyL72++sdIamxTkKakkhv3WqHXBOEmz8bKZWaL/HM3IbJihUCaVp3zv
         J9zhKRQynKE7p4sPqwr/EVVRxsYUWcw+LBrC1pNaw3UOtQqGUym49Ekj9ZFB62O7xEFz
         Q3hA==
X-Gm-Message-State: ACgBeo0ZlAM11g2Km7RUXpdoNMTDQ9Un+wS6fEMyFnoJU3vT7baYIQg3
        roEn2QUj3BxgIOzeq+RhhGsj17qXb/Y=
X-Google-Smtp-Source: AA6agR4GofH7Oodg45bBR88TpKCljUFomt/mN0bMVxq3I+QI5h2I1XrvzY/CghUNf0ozvIqP0b/nsA==
X-Received: by 2002:a05:6808:1594:b0:343:2e08:ceaf with SMTP id t20-20020a056808159400b003432e08ceafmr6448552oiw.181.1661751363041;
        Sun, 28 Aug 2022 22:36:03 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:5e78:4de7:b681:c052])
        by smtp.gmail.com with ESMTPSA id r65-20020a4a3744000000b00445313616aesm4592061oor.21.2022.08.28.22.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 22:36:02 -0700 (PDT)
Date:   Sun, 28 Aug 2022 22:36:00 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org, toke@toke.dk,
        jhs@mojatatu.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        stephen@networkplumber.org, cake@lists.bufferbloat.net,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net-next] net: sched: remove redundant NULL check in
 change hook function
Message-ID: <YwxQQOzw/dGKJKyB@pop-os.localdomain>
References: <20220827014910.215062-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220827014910.215062-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 27, 2022 at 09:49:10AM +0800, Zhengchao Shao wrote:
> Currently, the change function can be called by two ways. The one way is
> that qdisc_change() will call it. Before calling change function,
> qdisc_change() ensures tca[TCA_OPTIONS] is not empty. The other way is
> that .init() will call it. The opt parameter is also checked before
> calling change function in .init(). Therefore, it's no need to check the
> input parameter opt in change function.
> 

Right.. but the one below:

> diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
> index c50a0853dcb9..e23d3dbb7272 100644
> --- a/net/sched/sch_gred.c
> +++ b/net/sched/sch_gred.c
> @@ -413,9 +413,6 @@ static int gred_change_table_def(struct Qdisc *sch, struct nlattr *dps,
>  	bool red_flags_changed;
>  	int i;
>  
> -	if (!dps)
> -		return -EINVAL;
> -

I don't think anyone checks tb[TCA_GRED_DPS]. What you intended to patch
is gred_change(), right?

Thanks.
