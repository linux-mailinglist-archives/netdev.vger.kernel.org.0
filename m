Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1233D5E6DA4
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 23:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbiIVVGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 17:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiIVVGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 17:06:16 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B1910D0F9
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:06:14 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id c81so11847580oif.3
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=NCVjM0Xim4JbgV2zgTRimsrSTM4pFcIxPwZuOYrWBGA=;
        b=29NPx89WCXGmTmJKjAufKLK2mppkI4JikttUH3E5jBj0xTXxnGV/LVsZXBzVTzw0Gy
         aAkM8gWpY9daLYzMAxAmJmbd0UmIfYZYti12y6fl+ADkjkJQycydRKsXfy0p5mKQmevj
         kosK378R5u5Pe3uKyGFzXs7q3/EhtvDyHQjvxBIEckWpEKIP0B9JyS1n+rJBW7xFoVcM
         OCHYMemYKpTA++BABe0SfXS1e+BUMvQ5EgO5EIjigbq8OoYQcfswQd8lNqaHOa/vr3h/
         2z+MAPyZZ6JTLeOCMllmRJTF7p0YeDV7HgUTht4CHsVOwnV0fTCZO6/HA+HH7cm9pQy7
         JElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=NCVjM0Xim4JbgV2zgTRimsrSTM4pFcIxPwZuOYrWBGA=;
        b=SNe7RyUHeSRrN50FXDI345iz1m6nKsh43kNil6gxbTfdSI7SSlUkpigsMPz5+SHqnS
         KNAKitdVO3Wfl2lW6dd4jHZTJQBH/jA6fiOIIp6z4vbGXV+8MUmLeqZXjUpMgosmMmxI
         tZ0ZyhwPjzK4HnH0GrfYCqhLaqdA3Non2Evz42SQXEdHK81sPy2EPaC6HvXGLeMxaxLT
         1YiRFX1kpETpIN34PBWlgoMQdCgj1bKxmpcrgRK04rdYBVzbZ87W3t61r9D1kQczvaFv
         XBZWci1Ak0VwKdaBLxF/CWyDtbbWfCERZGWlAZSleV6otNO17pnnbyGG/iCc3L1EG5Sf
         gAlA==
X-Gm-Message-State: ACrzQf0aXTgiZQwFUNVnr91M6Vf4vkhZJSvJ3YUcyF65J7LMTGijbTyt
        uFexWLZ+fczh8YZRPGT7aw8AbYR1BiyKbrjVBTandQ==
X-Google-Smtp-Source: AMsMyM5I2Jso/cb0Xgy8I3xA6TXm+IjQXn9rCuiXJQWdwawtCLRCqrDiSG1mCiRdXsaTISwQBxEE084aR8tRFr8jVhk=
X-Received: by 2002:a05:6808:1997:b0:34f:d372:b790 with SMTP id
 bj23-20020a056808199700b0034fd372b790mr2493721oib.2.1663880773973; Thu, 22
 Sep 2022 14:06:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220921025052.23465-1-shaozhengchao@huawei.com> <20220922133956.46005009@kernel.org>
In-Reply-To: <20220922133956.46005009@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 22 Sep 2022 17:06:02 -0400
Message-ID: <CAM0EoMmxHniuywoLOAJmVX7F6mJ30+A1=S0uqDQhJw9qiU2S0Q@mail.gmail.com>
Subject: Re: [PATCH net-next,v2 00/15] add tc-testing qdisc test cases
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, shuah@kernel.org, victor@mojatatu.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 4:40 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 21 Sep 2022 10:50:37 +0800 Zhengchao Shao wrote:
> > For this patchset, test cases of the qdisc modules are added to the
> > tc-testing test suite.
>
> Victor, Jamal, pls LMK if you'd like more time to review otherwise
> I'd love to apply these this evening. Our patch queue length is
> hovering between unreasonable and crazy :(

There's some issue with this patchset - something was oopsing; could be
an issue on our setup. Victor is looking into it.

Tests are good though - and we do review them and run them before
acking...

cheers,
jamal
