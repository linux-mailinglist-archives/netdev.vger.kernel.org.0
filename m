Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0065F094D
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 12:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbiI3KtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 06:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbiI3Ks0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 06:48:26 -0400
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F121FA5D0
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 03:31:56 -0700 (PDT)
Received: by mail-oi1-f175.google.com with SMTP id t62so4281743oie.10
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 03:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=AupX32YCObtb6ls6yusQoPYHrBZcdCfKSavQHsYid6E=;
        b=byI1Uygrqwa8TgIOA9Dymz566yXNBO7USw3QYSbWXw+QlLnrnfawYYCVsK8TVdWbPL
         r4CQeO+Cty9xMbju0pVTUCMeAadaCeVDmK/6MuK/MInHP/5IshPFFC7yV83l0250UY2p
         SHkq3OQBJEWx4v4ianKxGK3XT5RRXqaUQHcch3w2h4vMs6TKTL8NtAqfWDe+TSrCrJfK
         bUImS7erwAsdZ+4zcv1OLfceyAkj++1/04jFpnPB14P4x7WDxW6FQ4waZDphancA/LHr
         PGbIOEG3EK2MOWHSPVI0H0ZgdCC/jA9HT+Z+ysiecEiX1W1JHqoK14CSlvYr+ReUykiA
         nMLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=AupX32YCObtb6ls6yusQoPYHrBZcdCfKSavQHsYid6E=;
        b=sMwdAX7a3KEcSH5BW/186V0NpVxOUKQ+y6KY1MIqXll3+ombWSuiP0REq88ZXjcmuO
         eyxe3Atp2cI992y4ioh19EMWD+dy+50IsCoxvBP6fAj9hycgG6G9QdcXffp3PsLCSKNe
         O/XiPTxSmRuw559pnyCecpjKZjsYwaQJDBIcJbVuSWzA1Xm+wWjrpta4pbjG6/BP8zSJ
         2okP4//8RntuWb9kEGPdEFBsoASvYKqvOphFB7Q8SeLkbhP/cpnw+vmVD6NFI4Y99Ch1
         Qxkk9P67ahyQHnv8mc2W9Xg9UmiHnPYZ+MYao0lRm7myXIiIn6J/5S27fzVx60HhlI1C
         F9nA==
X-Gm-Message-State: ACrzQf2UUb58buhEvaAdlOjn/eVBEjqKqOSWOZKmZ+7z+nTFXZDpjt2Y
        TFMPEn8fX6UKP1J9TZGM13ffp2lD6HVWihMITSWZ9g==
X-Google-Smtp-Source: AMsMyM5/Mbm3PDXFychxaDeLsssrFBOi9IOhtIWbXc78NEPtDNGytrVxJ4r1u1ICURkI9IwJ3R8IfCgwA8fsWCeYBrY=
X-Received: by 2002:a05:6808:148d:b0:350:7858:63ce with SMTP id
 e13-20020a056808148d00b00350785863cemr3587344oiw.106.1664533505162; Fri, 30
 Sep 2022 03:25:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220929041909.83913-1-shaozhengchao@huawei.com> <CA+NMeC8gFQ-M-nMzNA5H3UQKNtbekGvbKRxhyhg-b0QSNjY7MA@mail.gmail.com>
In-Reply-To: <CA+NMeC8gFQ-M-nMzNA5H3UQKNtbekGvbKRxhyhg-b0QSNjY7MA@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 30 Sep 2022 06:24:54 -0400
Message-ID: <CAM0EoMnp6T6D3p=HjcH+SXha-vMphHRL9eTEKcRaseBDaODBXA@mail.gmail.com>
Subject: Re: [PATCH net-next,v2] selftests/tc-testing: update qdisc/cls/action
 features in config
To:     Victor Nogueira <victor@mojatatu.com>
Cc:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, shuah@kernel.org, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please double check your work by testing it before submitting so we
can save some
cycles in reviewing. Those typos means your last commit was not tested.

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

On Thu, Sep 29, 2022 at 8:22 PM Victor Nogueira <victor@mojatatu.com> wrote:
>
> On Thu, Sep 29, 2022 at 1:11 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
> >
> > Since three patchsets "add tc-testing test cases", "refactor duplicate
> > codes in the tc cls walk function", and "refactor duplicate codes in the
> > qdisc class walk function" are merged to net-next tree, the list of
> > supported features needs to be updated in config file.
> >
> > Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>
> Reviewed-by: Victor Nogueira <victor@mojatatu.com>
