Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06775B2691
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 21:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiIHTNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 15:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIHTNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 15:13:53 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F29CEE50E
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 12:13:52 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id bz13so24368780wrb.2
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 12:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=hXot5Yk4b8g9FLlGulknQtsPjQUxy/GicFei7aiKjsA=;
        b=WlmlxSlg7llHhixPzp1MvspHgMpkGrMKj5rJ7CEh00Y89DOLiGiD7dIXzFTP461ajX
         0Yqo8NQYzAQCbxivma7J2L2eiBetmOtn4ySmXtpM6LQ1DvAYtYl9Iw+K7v9QgSOiN1Eh
         901ZQAyXSg75ChMf6PhdIU50XtHlRc0z9Mgch27mg7BNjNrX0a1zCDez5iCmrHsJcVO5
         m9YkO2E3PsNVB5/XtypUZGvpGUgdwCeMwHd2U+kydZaScj2nCLB3CDn3WsOVEbNpdqBq
         nxbsXmFgFKJUVHYlqYb1yC6rqb29Necg+ECWPvBr4nCDuBFI+NOXRwf/d4hAve+vEPu7
         80pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=hXot5Yk4b8g9FLlGulknQtsPjQUxy/GicFei7aiKjsA=;
        b=kDURUwMLfFuDqFJVwECb2xKMGwNavqC5gCltbfErZmI4EEBECY1QNK4QBmqq09sO4X
         5Zf2VI5VMkH6PzAJPrUfBo51aQvUqvAIcaqIKsz6Qeh8h1vYGkC+ziNZ0C+PYosJW2Bh
         hs9KL/ydXPoGH795/zwhQt9NZWiW+i7SiKSBRukZFXXNex+EuSHRO99V+8ysGb3QcDfP
         q4yERg7Iw43AAAp0qyQsB6osXpN2b4k+VFZWdU9SM1swXIkQXxwJr+W6GXheSfr+cM6L
         Fw+HqgYgcxhtz9I8Q3bDXNxQtZALbha81EcPK3r5TG5gorFkq8PlyMb758AagNozPNnx
         20xA==
X-Gm-Message-State: ACgBeo0Kl/A1EiurLL+Cz0CQGT36LqR3q5iThc8CLzTuzf0utG3Bn6PZ
        9UK1nglZR6oyuqSqSOf620DolKBFNFY=
X-Google-Smtp-Source: AA6agR5zshfpQJCrBzvsGyI4/pHABHauGCzlVdGxmttyZu7arKxg2OD4giGDrhOkO708P0Vm9BXG8g==
X-Received: by 2002:adf:fa12:0:b0:228:62a8:7c79 with SMTP id m18-20020adffa12000000b0022862a87c79mr5882070wrr.231.1662664430754;
        Thu, 08 Sep 2022 12:13:50 -0700 (PDT)
Received: from [192.168.1.10] (2e41ab4c.skybroadband.com. [46.65.171.76])
        by smtp.googlemail.com with ESMTPSA id o5-20020a05600c510500b003a31fd05e0fsm13464876wms.2.2022.09.08.12.13.49
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 12:13:49 -0700 (PDT)
Message-ID: <e5d757d7-69bc-a92a-9d19-0f7ed0a81743@googlemail.com>
Date:   Thu, 8 Sep 2022 20:13:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-GB
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Chris Clayton <chris2553@googlemail.com>
Subject: b118509076b3 (probably) breaks my firewall
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just a heads up and a question...

I've pulled the latest and greatest from Linus' tree and built and installed the kernel. git describe gives
v6.0-rc4-126-g26b1224903b3.

I find that my firewall is broken because /proc/sys/net/netfilter/nf_conntrack_helper no longer exists. It existed on an
-rc4 kernel. Are changes like this supposed to be introduced at this stage of the -rc cycle?

I'd like to revert the change and see if it fixes things, but I'm tied up for the next 10 days.

Chris
