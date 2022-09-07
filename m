Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE9C5B07E1
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiIGPDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiIGPDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:03:51 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06C932D
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:03:50 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-127f5411b9cso5345658fac.4
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 08:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=qwoAmwE7uzwpfQFltUBKCke30IDuWY14X85lPw5iYX8=;
        b=CF2rm5xRQRPuhBo4+WmmI3m1i/0k4lPy5fZy67/JPbhBT54u7zDuEJaxcZaiaQ8Vj2
         U1qNQ252Dm/VR0W9fo6iZ/OBNdOyq59mXsdlQeL3nJX/4/uMci3v2+uAB0bjUkZPc+U6
         /EgrutyVmQ7NHeIl6hzH5c8tqUjop51koR5EyIEzIGkGxOhbGHUYXl/qhuCvQ5HOTZjh
         Ym/d8DqbUYvcVb8jieVD8Srg7uYtk36hCpeNOcXT079xoi8ruRmtYWDi/WC69fK1eJhG
         2e6j0herMZkZYl89cO2JULaQerpcBHJ77N59L5+xTP/8vTF3hFupt9nK/x2UYOE/Fbaa
         Sjfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=qwoAmwE7uzwpfQFltUBKCke30IDuWY14X85lPw5iYX8=;
        b=fY8V5Dgh/laoBLkLhZwCwhEHizMVqYKOQuHybYsqcb0CAQEL5i1LN1iMy3z/OwnALH
         hy/QHMMuaBfdWfMolrWN3f++V/D0WlyLhr/jRvhrlC1U8aPQol+4jYFBzCRa3AeHPB1Y
         X3u8LVEVpymDmQ4tIz6ZsPLMCmPQJR0W9Lcwvc/NzjqK7ZNEnlnkbAbgAeQnXMyiNsrp
         auQUV9K0TFwlEFNrkz/gReyPP1vWSZY24S3fpWwJMTlVUZdrpkDo5bwQAByY9XinAv93
         +yesYdg9WaPFaAiVSY6bSeE1k7i6ToJspsG7TApAPIctBlDRv4Ty3YVxwQ78KUV6y3M9
         oNSg==
X-Gm-Message-State: ACgBeo1Ow7Hft5llVCufEn6r1ztMwX+Vu1/GPuw4gcCcprqvyDRMJf6N
        SeAdVVnZnTplDBru9Q1D4d3nocMfWtobPWvANp8UdA==
X-Google-Smtp-Source: AA6agR74ExVJP/+hViALnfUQQ+EAGCa2ACNRreueZ0t6HqgdEHLnSjUS1OljuLFRWxG78CK2RLOoNTUbizOljJLIIZ8=
X-Received: by 2002:a05:6808:1d6:b0:344:93c6:ec88 with SMTP id
 x22-20020a05680801d600b0034493c6ec88mr1649793oic.2.1662563028738; Wed, 07 Sep
 2022 08:03:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220906121346.71578-1-shaozhengchao@huawei.com>
In-Reply-To: <20220906121346.71578-1-shaozhengchao@huawei.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Wed, 7 Sep 2022 11:03:37 -0400
Message-ID: <CAM0EoMn6NfFwZsDbpP1oq4irjF3d8Gm1t_nzxnWaOb3qXRkDLQ@mail.gmail.com>
Subject: Re: [PATCH net-next,v2 00/22] refactor the walk and lookup hook
 functions in tc_action_ops
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 6, 2022 at 8:11 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>
> The implementation logic of the walk/lookup hook function in each action
> module is the same. Therefore, the two functions can be reconstructed.
> When registering tc_action_ops of each action module, the corresponding
> net_id is saved to tc_action_ops. In this way, the net_id of the
> corresponding module can be directly obtained in act_api without executing
> the specific walk and lookup hook functions. Then, generic functions can
> be added to replace the walk and lookup hook functions of each action
> module. Last, modify each action module in alphabetical order.
>
> Reserve the walk and lookup interfaces and delete them when they are no
> longer used.
>
> This patchset has been tested by using TDC, and I will add selftest in
> other patchset.
>

Thank you for running the tdc tests! Please for any future changes to tc try
to do the same. And you are going to be a hero if you add more tests!
This is a  better patchset and overall a nice cleanup. For the series:

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
