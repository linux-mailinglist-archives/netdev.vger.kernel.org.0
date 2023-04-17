Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB9E6E54E7
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 01:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjDQXAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 19:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDQXAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 19:00:17 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096ABB8;
        Mon, 17 Apr 2023 16:00:16 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-187949fdb1cso24963fac.0;
        Mon, 17 Apr 2023 16:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681772415; x=1684364415;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3PHQcs2GF/iCPq2HqHD/xnziqhMCVZsZ4qb963Y8dCA=;
        b=Z/5xEyHIkOL/1PFEBA0SIfTCE/F/AqGR/bJhFB2fjF/YbOppBdMMr5r+dUFICwnY2L
         qGttGwvkL6/AuhfOjz3v/oXJtBCJdJmlnHUmzVZOQPgDXOdKb60o6u4oH57rpMBDmrUN
         yg+RuRWkj5wGmGUrj97/iRynr/u0lXdNeeaGrNRHPvQh7WWjobEiZ32t6LjiVGaueVpk
         BLMk2MKbT8bH8G6bQbpRfRH+Gi72VyYiQn+pqvg2T8fGsEgVuwbijJ+xN9gbeSUYC4/r
         1kh2bbh9y9Q4i5TXqN10g7GWt8qSdYG0VlwDhcUo9UfpjVb4UKmY4dLjaRihTM8f58Dm
         7ldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681772415; x=1684364415;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3PHQcs2GF/iCPq2HqHD/xnziqhMCVZsZ4qb963Y8dCA=;
        b=U+inyctIIHPDqpaWzvahgHgYspix0yKAoKHp467FOhMyjHHnjfHe7IC8VWJ7Kq16Qk
         fyqkB+Mwb+XphTF80UhImMLCDLg464m2sX0E4BjQlvi0lkFzvD5xXrbiop/UZ+fkD/O0
         45h3ZvGQhvHLqw8FZo75zLFYwQ9xp/9Vga76Osd0hcwUlGy7TqkynmKYGAfaLDEnYDeS
         kRPO9AGoF3W11s5tKAmien4+tL0kHlX+it+jjK39bPMmi0u9AQr6dcLNeCwgS2r64FuW
         JP6YZAZljjyARuDse6+5CndU5/HwFcmNX9u0R44sXBVKiqtuRTBvYJ6FI/I6tFLOKcbr
         FwUw==
X-Gm-Message-State: AAQBX9enpVtigUHdvcddzp1RiGM5h4AfBOL6PnlkihgmynxVmqvKH8MW
        ttlalduzVHeEXJSAW/AqUQ==
X-Google-Smtp-Source: AKy350btPcC3sQlolUns67oyohPCyfD1u/C+xsrSL2QgXSnnbg3iXLwOka1hRrAGTnCcu6CdDvXyhQ==
X-Received: by 2002:a05:6870:d355:b0:17e:e1ac:2efe with SMTP id h21-20020a056870d35500b0017ee1ac2efemr65462oag.44.1681772415053;
        Mon, 17 Apr 2023 16:00:15 -0700 (PDT)
Received: from bytedance ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id c126-20020a4a4f84000000b005462a25c4f9sm2157337oob.9.2023.04.17.16.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 16:00:14 -0700 (PDT)
Date:   Mon, 17 Apr 2023 16:00:11 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Pedro Tammela <pctammela@mojatatu.com>,
        Seth Forshee <sforshee@digitalocean.com>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com, peilin.ye@bytedance.com
Subject: Re: [syzbot] [net?] KASAN: slab-use-after-free Write in
 mini_qdisc_pair_swap
Message-ID: <20230417230011.GA41709@bytedance>
References: <0000000000006cf87705f79acf1a@google.com>
 <20230328184733.6707ef73@kernel.org>
 <ZCOylfbhuk0LeVff@do-x1extreme>
 <b4d93f31-846f-3391-db5d-db8682ac3c34@mojatatu.com>
 <CAM0EoMn2LnhdeLcxCFdv+4YshthN=YHLnr1rvv4JoFgNS92hRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoMn2LnhdeLcxCFdv+4YshthN=YHLnr1rvv4JoFgNS92hRA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On Mon, Apr 03, 2023 at 11:58:44AM -0400, Jamal Hadi Salim wrote:
> To provide more update:
> Happens on single processor before Seth's patches; and only on
> multi-processor after Seth's patches.
> Theory is: there is a logic bug in the miniqdisc rcu visibility. Feels
> like the freeing of the structure is done without rcu involvement.
> Jiri/Cong maybe you can take a look since youve been dabbling in
> miniqdisc? The reproducer worked for me and Pedro 100% of the time.

I also reproduced this UAF using the syzkaller reproducer in the report
(the C reproducer did not work for me for unknown reasons).  I will look
into this.

Thanks,
Peilin Ye

