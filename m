Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0291B5AD8E6
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 20:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbiIESNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 14:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiIESNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 14:13:37 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E0A5B79B;
        Mon,  5 Sep 2022 11:13:36 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id u5so2498466qvv.3;
        Mon, 05 Sep 2022 11:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=+l0ZT6ZshJG5RaY0vTNoOQ84MhCjiFoEf9ODAog3mo8=;
        b=L+7ghW63726Yl9fotP46L54UPUCWTp307tmfi4jUVRDR2kS0kN1IbT8I8gQOUzhtcu
         Sa8+jlGuAx3t+amvA2IsmmkjSV50tyZdUZXokif4tXJ6OPn8RkpjReR6cPgZFLSLbEsS
         bVsqH/8x/gXTX9T11GZQbBX35EvjelhntF8bXu8tfWnXPElvuIY/4/mCJqG4FdupFYAC
         clrx9Nd/UzVywEOA/jeAa7nEzHfvAJIHYM+ZH5b1xtCpJFQwlxk+bGoWYhp2P+P96qGN
         uNC3gINLAKceKwf0rKvK3hoTR14u8j5Qu8UKMvLCJGl3/H7Xtp43lnLXbxz7IIQhdYEp
         T9pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=+l0ZT6ZshJG5RaY0vTNoOQ84MhCjiFoEf9ODAog3mo8=;
        b=VHz6GzB393CllbMlzl6fAYxelcGJ4C3/Pad12+OXCRmV+1snpC4dO3xSTY22CCAM5v
         Kd1kjf8Gat+pRoMvvdKoFQSTPAeagFOXvDAEzoB3MeSMrZzyQBOQTtuLS7ttBOLEJgiK
         RXHgRn+VGHHS3RMmqKlKU4DxN3D9JuEqitXHH4zSFgFM0u80V27TK/SzI4GPgD2HFZD3
         BQ5jIR4T7ywu6wXzGDAd05RXjb1o38mCootbnUd3l/zblx5SO/gV2j63hPXfgoc4H1Js
         dNssB4663ar2LG0S8SlvQQHoESd9DbLbVynmzpYCl+UQXw2SKywte4DVXEvzC7E2nig/
         MNUw==
X-Gm-Message-State: ACgBeo0fRKW8377g3lwqsD/Gd0zSd/Dn+zrrLis0kZU+LuoO8rQHsXdY
        Qs2qLsEJa6021IM3yCwB0nJucp1UoGY=
X-Google-Smtp-Source: AA6agR5yPMPZi+GUaKO4vlNR15wkWX2ysK5yj2T6BzWJ4CJhvyAhworzv6Yfd0j2ala7jaQXNKFo+w==
X-Received: by 2002:a0c:f3d3:0:b0:4a0:86d9:1807 with SMTP id f19-20020a0cf3d3000000b004a086d91807mr8043246qvm.19.1662401615736;
        Mon, 05 Sep 2022 11:13:35 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:53d7:9fdb:135e:210a])
        by smtp.gmail.com with ESMTPSA id d16-20020ac86150000000b0033a5048464fsm7806497qtm.11.2022.09.05.11.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 11:13:35 -0700 (PDT)
Date:   Mon, 5 Sep 2022 11:13:34 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, jiri@resnulli.us,
        vladbu@mellanox.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net,v2] net: sched: tbf: don't call qdisc_put() while
 holding tree lock
Message-ID: <YxY8ToCVWFSV6VqQ@pop-os.localdomain>
References: <20220826013930.340121-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826013930.340121-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 09:39:30AM +0800, Zhengchao Shao wrote:
> The issue is the same to commit c2999f7fb05b ("net: sched: multiq: don't
> call qdisc_put() while holding tree lock"). Qdiscs call qdisc_put() while
> holding sch tree spinlock, which results sleeping-while-atomic BUG.
> 

Hm, did you see an actual warning here??

The commit you mentioned above is a classful Qdisc which accepts
user-specified child Qdisc, but TBF technically does not, I don't think
you can change its default fifo.

Thanks.
