Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948FE673C0A
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 15:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjASOck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 09:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbjASOcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 09:32:18 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8154A8454C
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 06:30:46 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id c4-20020a1c3504000000b003d9e2f72093so3707070wma.1
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 06:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2Umd92wRNfvAofgDIf+r9yO6iFgRztRZ4IYJ8AlzHdY=;
        b=vkJOCCzoL8vjtTPGRMsoOw1R7mAXvOAuerYWRxBWXaMunEvMBJjX9QndCAb/cafgXt
         Wp7AkkYDAcaPRBYQ2VzjOWVN5wMoZwqSQeukFJm2XD2SjfcQjxuESHU2zwmh/1FcbtXJ
         OR5MMr6FO9bGoSKOuVuORlUSNlWpvJonbFssJ4ND0rStfsU754zN4PuUj9O8ONNIjh4a
         XtpkqnpVW9+jKKgKSW7R6dKH1iBsVvX0/s9opm2SOcUAbFbwYsgnVMH8XvKRL/D2Bxl+
         wln/UUynFA/QaLNWDnaf5NjAcf474M7n22HbeVud8gC0gqsEEcvlanaQjOHrda0OhsBF
         77EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Umd92wRNfvAofgDIf+r9yO6iFgRztRZ4IYJ8AlzHdY=;
        b=od4RtpJ886shGrPibRariSpFb+bo8c6BFHNZ8dFUl6n9gVMbrQZVnKo2L2N1E/e4Dt
         9yv6jNxMiRY5ORaIFd/vCvnkSS78fGVrQAC+NdcfaWLGKZwv40FBn0gPa1+OOAt+N33R
         WF8Th08nnArcshBj1+37ksiMgLadLK6km89tkrGl2PWOdI+YO/PrtG2nc+52+poSLvxY
         ER1BQi4aF0HtNdK8KnxOTXrFKkaVSyhsoE42hEuJrBUBR9jmpEBvuRtt+Fr2UaG/rIYU
         DDqmW5t/pMLFBHg10jjE3g7caEDDcxj/zsxWdK8OsPhL2Tx9o1C+ni6iAetzSS/ZHC9A
         mmyQ==
X-Gm-Message-State: AFqh2kpBPRZ+ImYxZI/TXLFw0hOZJOdE1btJ+XrmabsXfsl9L27TE+Xd
        PACrzVQ4wTAAXQPBUgw9OzV4uw==
X-Google-Smtp-Source: AMrXdXt/qRZqd3d5H5nKuT29rqnbZSUkbKuOzkuX9Eo+5Br+urhGdBlFyU95SdJu1GACPisSU9MB5A==
X-Received: by 2002:a05:600c:601c:b0:3d9:ee01:60a4 with SMTP id az28-20020a05600c601c00b003d9ee0160a4mr10567478wmb.1.1674138641269;
        Thu, 19 Jan 2023 06:30:41 -0800 (PST)
Received: from [192.168.0.15] (cpc76484-cwma10-2-0-cust274.7-3.cable.virginm.net. [82.31.201.19])
        by smtp.gmail.com with ESMTPSA id o12-20020a05600c4fcc00b003daff80f16esm6836420wmq.27.2023.01.19.06.30.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 06:30:40 -0800 (PST)
Message-ID: <000e333d-f6df-0d08-07a0-2e7056bb6792@linaro.org>
Date:   Thu, 19 Jan 2023 14:30:39 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Content-Language: en-US
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Alex Elder <elder@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20230119114125.5182c7ab@canb.auug.org.au>
From:   Caleb Connolly <caleb.connolly@linaro.org>
In-Reply-To: <20230119114125.5182c7ab@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19/01/2023 00:41, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got conflicts in:
> 
>   drivers/net/ipa/ipa_interrupt.c
>   drivers/net/ipa/ipa_interrupt.h
> 
> between commit:
> 
>   9ec9b2a30853 ("net: ipa: disable ipa interrupt during suspend")
> 
> from the net tree and commits:
> 
>   8e461e1f092b ("net: ipa: introduce ipa_interrupt_enable()")
>   d50ed3558719 ("net: ipa: enable IPA interrupt handlers separate from registration")
> 
> from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
> 

Hi all, sorry for the delayed response to this.

If this is the same fixup in Matthieu's email [1] (which it appears to
be), I can confirm that it's the correct fix here.

I based the patch on master as it is a bug fix which we intend to
backport, I should have mentioned the conflict with Alex's patch on
-next, apologies for the miscommunication.

-- 
Kind Regards,
Caleb (they/them)
