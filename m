Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F958539419
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 17:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345727AbiEaPhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 11:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234153AbiEaPhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 11:37:50 -0400
Received: from m12-11.163.com (m12-11.163.com [220.181.12.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA7174DF7F;
        Tue, 31 May 2022 08:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=nwAslF7UTAY2p7754D
        PU5vsb/l32RP5T/3fbTLG0DoM=; b=i2VdKbpCTnKfJjtwfOSEzUv2SoVaFgrNi1
        wM+RTUNgXiVBh3nredQ3UGQmNgYAM6pGYAz0fZNdzAifBxi4HZAfhYGodyM0ijvw
        4TYFH3y6riyGMCqQvSOKN1gjihB1PEh5rjWu05ZABW3bmQt4NK9lcwFd6e5kwRfv
        8tOwbVGgM=
Received: from localhost.localdomain (unknown [171.221.150.250])
        by smtp7 (Coremail) with SMTP id C8CowAC325kMNpZiS1T3FQ--.58339S2;
        Tue, 31 May 2022 23:36:56 +0800 (CST)
From:   Chen Lin <chen45464546@163.com>
To:     kuba@kernel.org
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alexander.duyck@gmail.com,
        netdev@vger.kernel.org, Chen Lin <chen45464546@163.com>
Subject: Re:Re: [PATCH v2] mm: page_frag: Warn_on when frag_alloc size is bigger than PAGE_SIZE
Date:   Tue, 31 May 2022 23:36:22 +0800
Message-Id: <1654011382-2453-1-git-send-email-chen45464546@163.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20220531081412.22db88cc@kernel.org>
References: <20220531081412.22db88cc@kernel.org>
X-CM-TRANSID: C8CowAC325kMNpZiS1T3FQ--.58339S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xr4xJF4DZw1xtrykCw1rWFg_yoWDJwbE9F
        n7ZF1xArn8t3yxGa17Kr17urW2q3W09F12vrZI9a47tF98Awn8JFyDGFWfWrZ3tFZa9F9x
        CrnrG3W0qrya9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRRVc_5UUUUU==
X-Originating-IP: [171.221.150.250]
X-CM-SenderInfo: hfkh0kqvuwkkiuw6il2tof0z/1tbiGhgSnlaEB7qq2QAAsS
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At 2022-05-31 22:14:12, "Jakub Kicinski" <kuba@kernel.org> wrote:
>On Tue, 31 May 2022 22:41:12 +0800 Chen Lin wrote:
>> At 2022-05-31 02:29:18, "Jakub Kicinski" <kuba@kernel.org> wrote:
>> >Oh, well, the reuse also needs an update. We can slap a similar
>> >condition next to the pfmemalloc check.  
>> 
>> The sample code above cannot completely solve the current problem.
>> For example, when fragsz is greater than PAGE_FRAG_CACHE_MAX_SIZE(32768),
>> __page_frag_cache_refill will return a memory of only 32768 bytes, so 
>> should we continue to expand the PAGE_FRAG_CACHE_MAX_SIZE? Maybe more 
>> work needs to be done
>
>Right, but I can think of two drivers off the top of my head which will
>allocate <=32k frags but none which will allocate more.

In fact, it is rare to apply for more than one page, so is it necessary to 
change it to support? 
we can just warning and return, also it is easy to synchronize this simple 
protective measures to lower Linux versions.

