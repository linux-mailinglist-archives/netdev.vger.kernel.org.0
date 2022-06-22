Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5228A554808
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbiFVK04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 06:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiFVK0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 06:26:52 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCD6183B6
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 03:26:50 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id o8so22747614wro.3
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 03:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2RBanrWD+rLIp5SPW6KPehFCJ1Ot2rvK3Dm/gjV/kUY=;
        b=bHQhfceOyOfGkm/pHRG2/Hi6+orXoMa3xPnkZ9tuwQADGUrK0/uglMAFGEWc3oZq3i
         dRwIl7fuFBflZEuWK7pRN8zGUi6UM05rqKR4pdALAS3EiBNa3qpHGLzr9rBFWVE16BKi
         +yYuHcOMnFHSDIHt5HHK1LebW33PJnWvK5wgHFQ54D5vHm6AUK8QCVYrZErkyrbul486
         Q2Kq+4KfIZwNz8o7AGucqixtiMepagUzPqUFgqAVuO5dyClO5TqsjRLHxFneH3TEZ8gD
         feOkzDIxRI4dCqCowo1fUCJAgoo8aSuSHc/U+JFw2Oxnl2s9OSENMwS6gnlSJ+gtCFbj
         pHVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2RBanrWD+rLIp5SPW6KPehFCJ1Ot2rvK3Dm/gjV/kUY=;
        b=axLRBKSR6oZ+faFGbTV+9VNVLXwM4Vvxr9U/sYfTYZjKjO1f20FiSvjOvZ5aLyAwOD
         szStnPo7kpMBuIkgwdA8nHm9Cvt8ocxbr1hkxfK8QH+Lv++c15TctlEKm9Cr5tTmp2CU
         ylDg4S1fpcNDmIUvwKKQhqtgJhNEfLBAwhrOntxHA9wAsQZ2xri3qf4gzaMOXyKknWUW
         3PZYpX8mVR0J+4viYMPpdgOTDlrspZUJRRaMFuCcb6OOBhHhkLd4PVxqqp1KyqFeqJdn
         wAMv3cgqfaf51dRYptijd4q+dfBd0KXpu3AposTYZfnRRSCO2Et7/K1oLXCH6aS8r3fR
         okKg==
X-Gm-Message-State: AJIora8WYmUxEsmDJZzaO6MYkNPSd+69QSO8d7nok0py01Frkcb4sjog
        jtzqoRNFLU94+QzAFU4kdZM=
X-Google-Smtp-Source: AGRyM1ux/yHScsOl8+T7htJNSIpQTzMx0q5g8RnugSan4KfeifQSZo5j0XcV/NfszFZzOF1NE3fOPw==
X-Received: by 2002:a5d:6daf:0:b0:21b:994a:a6d1 with SMTP id u15-20020a5d6daf000000b0021b994aa6d1mr2548262wrs.75.1655893608663;
        Wed, 22 Jun 2022 03:26:48 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id n68-20020a1c2747000000b0039c5a765388sm21000197wmn.28.2022.06.22.03.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 03:26:48 -0700 (PDT)
Date:   Wed, 22 Jun 2022 12:25:20 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        willemb@google.com, imagedong@tencent.com, talalahmad@google.com,
        kafai@fb.com, vasily.averin@linux.dev, luiz.von.dentz@intel.com,
        jk@codeconstruct.com.au, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: helper function for skb_shift
Message-ID: <20220622102517.GA4171@debian>
References: <20220620155641.GA3846@debian>
 <20220621221240.36c6a3a6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621221240.36c6a3a6@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 10:12:40PM -0700, Jakub Kicinski wrote:
> That's better, thanks. Please move the helper to skbuff.h

Will do.

> and consider changing the subject from talking about skb_shift() 
> which is just one of the users now to mentioning the helper's name.

When submitting the updated patch with a new subject, should it be marked v3
or is it considered a new patch entirely?
