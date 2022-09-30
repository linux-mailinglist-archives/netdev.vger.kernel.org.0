Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 431495F01BE
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 02:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiI3AWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 20:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiI3AWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 20:22:12 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75716200B32
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 17:22:11 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-12c8312131fso3748792fac.4
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 17:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=eLIEnAwOgcD3RzZntVosaSQRt5lgikT9jrPA+ZstSNM=;
        b=t8sM4wz5hiMw3lGJponNYfeHmYQSKR99dkoiOfpA43bEbIrI9pyfS3sunMhKtPIn8K
         ZwKXWGRibo3DmRkznpAXf+6TCyZxvqGo7HHeqDBfx09pICDu/Wt8mwLgwawxdwF4LUJx
         pYhR0Fr7fyNMDxLbe73qUT+ZE7bS8a/5+k95ZiibfgoXEQX2fzbwTbGeA8WQR9YV2guk
         EOQusEEelMN8hR22ILrGqI7QYrEFfuene+j2odp29hdUE6DiRxR1lV7dnOJs7W8qC6ug
         Rbq8leUm2hVXefaDvaHauPm9zHAqCAWLn5+Avz3i1hSMSRj1csFfFbz6O37a44k5RxZN
         2eqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=eLIEnAwOgcD3RzZntVosaSQRt5lgikT9jrPA+ZstSNM=;
        b=5Kb2D89Nx1VL7iEF54qf2yBV2Dnz4YsHysjm1ZTAzYbWnDqx0uxpMCiGxwtv+KpvQy
         0Xj/g1qjJWWn62uDvBTVMWGIVLEsy4dcojhCtau8Mo4KxbWtkRn5i/fWvnHwSlRoN/FJ
         WBTpNrbXdbgbjdMZV7j/xFAjGNnAaI2HXjoS/dcJbrkXpPsg3ukSXEgW3kznTyre6ptb
         qZ7CfdSgcnR+gE7nfh+c83KIcrlGO4hDJGeXVFUE5cpfwXy2ogf6dGWVGYhikViCvQCH
         dFnyv440PkKNhStZFxM0wAXMf+7Q1oLDd/E/zzzAGMjzPnOdb/+V7qBPSqbS0o5k0mjB
         wZ/A==
X-Gm-Message-State: ACrzQf1fs+NgY6s+Y2SwSsrgt6cDNkz8Q53tgR80NKHF1KAEYCcuoz+D
        EMnfJJ0tqGqmz0GpAiXFv3GW/b2JORxQNwruoirqBA==
X-Google-Smtp-Source: AMsMyM5fdHlakT8nYyzmvEr1fjxKmwjzs8jtE/AUvE/WoIFQ9Bp46LAueFb9nBOkqKE9muhJr4CnTxLuY7IYrhjxkDI=
X-Received: by 2002:a05:6870:2417:b0:127:be13:2d1 with SMTP id
 n23-20020a056870241700b00127be1302d1mr3407265oap.268.1664497330795; Thu, 29
 Sep 2022 17:22:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220929041909.83913-1-shaozhengchao@huawei.com>
In-Reply-To: <20220929041909.83913-1-shaozhengchao@huawei.com>
From:   Victor Nogueira <victor@mojatatu.com>
Date:   Thu, 29 Sep 2022 21:21:59 -0300
Message-ID: <CA+NMeC8gFQ-M-nMzNA5H3UQKNtbekGvbKRxhyhg-b0QSNjY7MA@mail.gmail.com>
Subject: Re: [PATCH net-next,v2] selftests/tc-testing: update qdisc/cls/action
 features in config
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        shuah@kernel.org, weiyongjun1@huawei.com, yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 1:11 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>
> Since three patchsets "add tc-testing test cases", "refactor duplicate
> codes in the tc cls walk function", and "refactor duplicate codes in the
> qdisc class walk function" are merged to net-next tree, the list of
> supported features needs to be updated in config file.
>
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

Reviewed-by: Victor Nogueira <victor@mojatatu.com>
