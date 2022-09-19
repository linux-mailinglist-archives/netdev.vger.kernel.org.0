Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACDE5BC0E6
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 03:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiISBFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 21:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiISBFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 21:05:42 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD6713EB6
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 18:05:41 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 102-20020a9d0bef000000b0065a08449ab3so1219265oth.2
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 18:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=7Nln9o8+KgWXh20eCVhrCs8ZRIFITlFWDCJFyQHKKl4=;
        b=HZ5JQstOdyCuVV963ZooQpoyIaPxFimUQrEC+R/gZH/lIHi1rSMy4XixtpzdjH8IVN
         IVkMMP2OO0H5Buf8+jWiOlDZuJ9yy/8qCB66kindOVf71hZ6Yo8R9QQYGY1iQm+ZGU81
         FqHdC+XWokAbMRaxDHY2l1b6vmGUV+dDxIeFYHKTRqj75hJKEeomm66Vy7FW3eM/p9Ff
         wtJFjVqIbQLRnJrBdqirW73gj7lV4wzfrScnVjxYnhiLqduhq0zYWVH2pTJ12lkpcweD
         qK/IWwvrYrL9gfVbcXH/IhdeQEtoIqODDuMh0QVqBjzHT7gpyDBoB4P/HvOalDqRlLC7
         1n6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=7Nln9o8+KgWXh20eCVhrCs8ZRIFITlFWDCJFyQHKKl4=;
        b=iQ0GAbx0tq0kWBmRCgw7J5V90GEKRYXkvomY1WvP7zbLOKYEnqDbXXCGXmCO9DOPW0
         AKWRiY2pGAZhP5vb5cKX72fZsKUbYURC2V1PF5aWO/kHsg8IJkkZWwXI/Qzgh5DQ6zgm
         m32v88+mximrVHBVlzEY3FOBUqr7KioQ2FzuctfOT6kGarzB27QKzCFerXvB0/H6n3b+
         /c02aDzlG1d1o3+GCT63tvE3/PbJtiCqx51U6F0PV7PJdh5OGVDSKfCf5W78ab6agCY6
         3eoJ6dZDUmz2Jbl80FhHuqfAMRJJh7zsH7ZZ6dHlbCbahl+UuMbYYW8D+VQRK39C8/8p
         IBFw==
X-Gm-Message-State: ACrzQf2pJrqp3YJDzLRVwK/G+ivjNcJjus9qaEtr6FOvQMhPkfQF+YQk
        /ZzVJ6SSzTmZub9xaqvtXq9+CI3gekOVlCp26Ibr+w==
X-Google-Smtp-Source: AMsMyM6OazjHldIhOvSyzPAGt9W76ixoFWTADxVnkP4jasV5XE9fsHajWSzioFh5T2jypjokFzRcCm/zA1Bu6QNAlv8=
X-Received: by 2002:a9d:1b70:0:b0:658:cfeb:d221 with SMTP id
 l103-20020a9d1b70000000b00658cfebd221mr6955321otl.34.1663549540604; Sun, 18
 Sep 2022 18:05:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220916020251.190097-1-shaozhengchao@huawei.com> <f0fa2b91-cebf-0997-1074-d1ba35bf77a9@mojatatu.com>
In-Reply-To: <f0fa2b91-cebf-0997-1074-d1ba35bf77a9@mojatatu.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sun, 18 Sep 2022 21:05:29 -0400
Message-ID: <CAM0EoMmcjfjg+7RsMtW_4YWb+4ewACGW=YVtzOU0Xqh=Kk_K-g@mail.gmail.com>
Subject: Re: [PATCH net-next,v4 0/9] refactor duplicate codes in the tc cls
 walk function
To:     Victor Nogueira <victor@mojatatu.com>
Cc:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 12:56 PM Victor Nogueira <victor@mojatatu.com> wrote:
>
>
> On 15/09/2022 23:02, Zhengchao Shao wrote:
> > The walk implementation of most tc cls modules is basically the same.
> > That is, the values of count and skip are checked first. If count is
> > greater than or equal to skip, the registered fn function is executed.
> > Otherwise, increase the value of count. So the code can be refactored.
> > Then use helper function to replace the code of each cls module in
> > alphabetical order.
> >
> > The walk function is invoked during dump. Therefore, test cases related
> >   to the tdc filter need to be added.
> >
> > Last, thanks to Jamal, Victor and Wang for their review.
> >
> > Add test cases locally and perform the test. The test results are listed
> > below:
> >

>
> Reviewed-by: Victor Nogueira <victor@mojatatu.com>
> Tested-by: Victor Nogueira <victor@mojatatu.com>

For the series:
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
