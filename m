Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2BC6566219
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 06:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbiGEEEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 00:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiGEEEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 00:04:33 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B0B12D19;
        Mon,  4 Jul 2022 21:04:33 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id bh13so4408530pgb.4;
        Mon, 04 Jul 2022 21:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GUeJvKk4WtvFDE4nbMc2nM4EyZaO/tAGnMRaTC8sqXI=;
        b=M30+cdDmHQAMOExKZy6W7NFmt6k6RzO+Pr+4QdVfk5mjm1NLKXlbcF88FtJJ7RfCUi
         5cs7g27NY/Ua+oN7z+Kb+Qc71Pl7bEnSVhXKLrjeA4ZspXss6TyQ/PfVQS6pK+7Lx1ze
         5DKNmY4YVU2sWy/TRCgrTxhd+rwNhEPwc5p0L5bbakAH7Y67N2YlZUKO31+A2Wg9jAOY
         TEVkugibkj+U9REf4LUL+S5eAVCqj5TNN8KvV6fJ3GwpzRA+j7HTsLbfnU7gQTzhz0ws
         lQs40R+KFvjFVZm6SmZSk9w5fVDer/sM1rH1hPbIfLdy66tGmisLFD7ZYcuEbSMCgY8l
         SFrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GUeJvKk4WtvFDE4nbMc2nM4EyZaO/tAGnMRaTC8sqXI=;
        b=N0qx96DGD37Woq1zUDAHVncXKIQFGfe53YVL4jpv0tSwJKTw9hi00xCR2MbHy0jvNT
         YWLWOfFjCgQ5Dx5Hoxuf0ER0A+FPRCm7rmaFtFmVZAk1fY4DrLwa4Fi/0JHaJDnHdFBl
         l2dFc/Mv2SwUKAiLlauH6Sjo2p+f7gW5+Vjv8AlV7tJifvqR9t3AVw+mvEMFpfvwP8y0
         6iGDa/iZLmR/tHwtBnSWg/6nLie3EmOj59hXDQmanuarIO9LstalZ0Opz3Q+vBHpMX9Z
         dJy6c5WxKxfHDoPZlrwrz0/R+AOS+eX9Il/5FKh42yy/CMsySNYo5L+j6lbqs/yx77ch
         3Sgw==
X-Gm-Message-State: AJIora9R+VF9n6VyF0KNkm43u8xyxJhum2pxPZBX85lFFE0fPK6R7MUN
        6kc72Q733fwlnute2n94lOX3nBSU0aQuuw==
X-Google-Smtp-Source: AGRyM1sShYqd965qsgVGHzMhNDc+xGICEibMnV8x51jtsis7/Mr2ydAHrJPxLwI70e+bSsl4VBdYww==
X-Received: by 2002:a63:287:0:b0:412:2f6e:7fc with SMTP id 129-20020a630287000000b004122f6e07fcmr8844898pgc.185.1656993872242;
        Mon, 04 Jul 2022 21:04:32 -0700 (PDT)
Received: from Negi ([68.181.16.243])
        by smtp.gmail.com with ESMTPSA id i1-20020a17090a718100b001ef87123615sm3360257pjk.37.2022.07.04.21.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 21:04:31 -0700 (PDT)
Date:   Mon, 4 Jul 2022 21:04:30 -0700
From:   Soumya Negi <soumya.negi97@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        syzbot+9d567e08d3970bfd8271@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com,
        Xiaolong Huang <butterflyhuangxx@gmail.com>,
        stable@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Test patch for KASAN: global-out-of-bounds Read in
 detach_capi_ctr
Message-ID: <20220705040430.GA18661@Negi>
References: <CAHH-VXdqp0ZGKyJWE76zdyKwhv104JRA8ujUY5NoYO47HC9XWQ@mail.gmail.com>
 <20220704112619.GZ16517@kadam>
 <YsLU6XL1HBnQR79P@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsLU6XL1HBnQR79P@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for letting me know. Is there a way I can check whether an open
syzbot bug already has a fix as in this case? Right now I am thinking
of running the reproducer on linux-next as well before starting on a
bug.

Regards
Soumya
