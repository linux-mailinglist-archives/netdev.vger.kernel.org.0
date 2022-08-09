Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B5758E005
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 21:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344375AbiHITS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 15:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348641AbiHITRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 15:17:13 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EC3F1
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 12:11:55 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id k29-20020a9d701d000000b0061c99652493so9112958otj.8
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 12:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9siwJIQC3o+zwhpaqmVDPq6puonWJ3yK708h6UiJFdg=;
        b=QgvKBMm8UoPqyQ2WP3hOgK3xaIB30W863tOgle5E3Kiwc6vM5E6q1uouWu2IkOUCUT
         wZ1VidX2czSp362XqtPXj7iTEJQVXXY4/vgVPe+e3HADQlaUaqGS5ppJ13N0sdhirBic
         ZG3woluvGbX/DYyX0WNrhb97ZS8DGtWApNHa47MRWKWZvAPx2M7cViTdLINc8Be08mjX
         HFA0ZRMJ5Eh7j7BBCUIx/lvI7p9JlyL68gS1ga6OcrDddr3ZXnIxtxlYUV3EaUt+6fnD
         iXC57N+GzkSH/9PQH7i/VD2H71w//DRuRIFKKcLF33iMrgJWAr7CBGin+vtZVn30RpCb
         mcnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9siwJIQC3o+zwhpaqmVDPq6puonWJ3yK708h6UiJFdg=;
        b=fJ/0ThUIDXMc3JoaW5xxWJGeM3GtE7dWudGUBv6+hVoLhFns+JY0Xikfbegk2YUgfM
         xDtmWNiun2xviA4U8ZQvQqDZLC+Ok1+0mmDSDgf//oMwNtJeWbIJCNXR2VW+fneBY8hb
         ZyzSHH7VVq1L0mH/868jkr1lFYunM/wALs+6+gTQviwbUAjZ0uNOWgX9PrBg+4HJsIIu
         lGGbHlE+eiPvFZHLqnar4t8ve4L/RNaagBao/7dHp4qgS8/i1QivN6cbOSMoYdgkCjs0
         f0ntrQWMgAW4SqF6QeU7F1LHwqsRClSOTuZLQYAOTaoX7uTMzP4KCC4X8ElfsSlHiRgj
         Pq0w==
X-Gm-Message-State: ACgBeo0vMpe2vJ4AjIUHbbfmTIZYigmUL8XAmCkGoTQSsVktPKAF9VCH
        lz8xFlBEK3YwbDQ8hu8FCpVWO0UO2fJUJ5ByuSM5lg==
X-Google-Smtp-Source: AA6agR5iAlBylvFaT44jwWOpEWd8XAtcToZBgN7hOdZtnHKUmmK59qh/j9o8EziN9T39wzzH/QTr3wEy3bcHZ0ksw1E=
X-Received: by 2002:a05:6830:34a0:b0:636:f7fc:98bb with SMTP id
 c32-20020a05683034a000b00636f7fc98bbmr2964393otu.223.1660072314985; Tue, 09
 Aug 2022 12:11:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220809170518.164662-1-cascardo@canonical.com>
In-Reply-To: <20220809170518.164662-1-cascardo@canonical.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 9 Aug 2022 15:11:44 -0400
Message-ID: <CAM0EoM=nAZJYbj-hOBxFF-3q38wMuhH11geVopYjOBv3Je4ELQ@mail.gmail.com>
Subject: Re: [PATCH] net_sched: cls_route: remove from list when handle is 0
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Zhenpeng Lin <zplin@u.northwestern.edu>,
        Kamal Mostafa <kamal@canonical.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 9, 2022 at 1:06 PM Thadeu Lima de Souza Cascardo
<cascardo@canonical.com> wrote:
>
> When a route filter is replaced and the old filter has a 0 handle, the old
> one won't be removed from the hashtable, while it will still be freed.
>
> The test was there since before commit 1109c00547fc ("net: sched: RCU
> cls_route"), when a new filter was not allocated when there was an old one.
> The old filter was reused and the reinserting would only be necessary if an
> old filter was replaced. That was still wrong for the same case where the
> old handle was 0.
>
> Remove the old filter from the list independently from its handle value.
>
> This fixes CVE-2022-2588, also reported as ZDI-CAN-17440.
>
> Reported-by: Zhenpeng Lin <zplin@u.northwestern.edu>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Reviewed-by: Kamal Mostafa <kamal@canonical.com>
> Cc: <stable@vger.kernel.org>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
