Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024895EDF61
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 16:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbiI1O6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 10:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234535AbiI1O62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 10:58:28 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBC09B86A
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 07:58:25 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id g1so3160944lfu.12
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 07:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=XjBlcN0ist98FlU5W2baWEFCDfCTo7aPIftrNtx80L0=;
        b=RoBSDWAJomLh8smmqUsbXKb2v+paiOBkSF3OCZEIULNmT5DlrORcBVCgW1VRUkXcKt
         r48X+yDDOmDtFU4ZRuk/pyUgjp+Ec97AMiXtJcBesciURsRo7QgpaiiKA3Cd/v+MecsE
         N6dsPdap91dAJ/B4mEVKzJoO/hp7KXw6psi2TfogCI56+FRUoSE9K0QdBPwXZbEP4dfA
         Ugz0kViBs9bHEmDqnfTc+YPkxXW5onuiMlcu60mXrAy1EA3QwIvxM8SgT13s+YwIwoNr
         N/ir9xBmSaynjde4+KI2bfPIvhmVhOle0MsFBqpU/zg68tpXkikAmRpYebQx60B1GVc2
         CVoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=XjBlcN0ist98FlU5W2baWEFCDfCTo7aPIftrNtx80L0=;
        b=o0tOP6IA9+Sfy675nyPjVTblW1inBistYwyzGyqFc/7muOnXAlWBNwKuV35ncDGoH8
         HpZ+DXzWVf8FvlPMIe+Vfh/P5Qeh2V1cyE7tV6RQkkrB+RwGf1r6uFUC2ZuNsWTmoXaH
         acm2Kj7foQ4wvNltDXwC64ZVgNULUZsibcqggkMATev8Bl5vMuHrq/2GMV5HZBxo9KuM
         cC5jp7QE1W2kMMuVMHu/1X9upyKylSey4z96Tw25VYNnCXUxawmkWp6iOlVPRnxuM0dc
         /ylWs/gq3Z34K4mKTncW598HpUFJXLtK5rq3UwdBq+9S3L3LaaCIn2enZLc8ZbdZ+VUS
         56Gw==
X-Gm-Message-State: ACrzQf1t5lJFaJU8bSQa0AlLecW/Ycka7TfVrMLvQHNa3KCGieplnxS6
        fowBM7sGdUFYbY9cTYm1xyCWsDZchKVrhW322S8=
X-Google-Smtp-Source: AMsMyM5rKP68DD2w7S8cpKaRjG3Zk3AkPm/OOTuIl7Ox7yVGfiYXsU8YCfs1QdemxgQqWbx6PByH96VUk3Jb2sl08dc=
X-Received: by 2002:a05:6512:2805:b0:4a0:4fac:a958 with SMTP id
 cf5-20020a056512280500b004a04faca958mr12841073lfb.291.1664377103858; Wed, 28
 Sep 2022 07:58:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220923160937.1912-1-claudiajkang@gmail.com> <YzFYYXcZaoPXcLz/@corigine.com>
 <CAK+SQuRj=caHiyrtVySVoxRrhNttfg_cSbNFjG2PL7Fc0_ObGg@mail.gmail.com>
 <YzFgnIUFy49QX2b6@corigine.com> <CAK+SQuTHciJWhCi-YAQKPG4cwh7zB9_WR=-zK3xTUq9eTtE4+g@mail.gmail.com>
 <YzFiXabip3LRy5e2@corigine.com> <CAK+SQuRJd8mmwKNKNM_qsQ-h4WhLX9OcUcV9YSgAQnzG1wGMwg@mail.gmail.com>
 <20220926100444.2e93bf28@kernel.org> <20220926104506.559c183d@kernel.org>
In-Reply-To: <20220926104506.559c183d@kernel.org>
From:   Juhee Kang <claudiajkang@gmail.com>
Date:   Wed, 28 Sep 2022 23:57:47 +0900
Message-ID: <CAK+SQuS-PHYDjRcDf0gmX4ot8pKDoK9G00EzwKkX=o6Jh_fXQA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: use netdev_unregistering instead of
 open code
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        skhan@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, Sep 27, 2022 at 2:45 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 26 Sep 2022 10:04:44 -0700 Jakub Kicinski wrote:
> > On Mon, 26 Sep 2022 17:29:39 +0900 Juhee Kang wrote:
> > > I will send a patch by applying netdev_registered() helper function by
> > > directory.
> >
> > Please hold off doing that. My preference would be to remove
> > netdev_unregistering(), this is all low-gain churn.
> > IMHO the helpers don't add much to readability and increase
> > the number of random helpers programmer must be aware of.
> > Let me check with other netdev maintainers and get back to you.
>
> I got hold of Paolo and he concurred. Let's remove
> netdev_unregistering() instead. Thanks!

Thank you for your review!
I will send the next version which includes removing netdev_unregistering()
as soon as possible.

Best regards,
Juhee
