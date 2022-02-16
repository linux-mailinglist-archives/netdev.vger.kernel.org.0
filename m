Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4774B4B930E
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 22:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbiBPVTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 16:19:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiBPVTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 16:19:47 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31ADF224957;
        Wed, 16 Feb 2022 13:19:34 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id m17so6057262edc.13;
        Wed, 16 Feb 2022 13:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eJjUepHMJ3XjQahPeLYVJZBCt2LbAJ4aSYQ6YGubxko=;
        b=DP/QUlXXfeSdvaRKWGaTlc/s7+ZUhVLvX/3c/4fdJGStyXeQaU1jElIqHVWGNMQC54
         nuroeJ5ffqSGp/e/lNI9mhobmCmgLsUhSWLSqQ6WOFKAAyo4boTA3Oh46Q4eHg8bxGyw
         Kz77Neo8vLJkADB25RB5Kgsy7keg7F7o8AGWRm/hXEl1gIMOQh2agSoRy/P/uNQMteKR
         TBJldYdkMDVUgU1W08HVzPeyR/oK5QWr2/Ktx7LC4tjHMtKIzkru+ANkCkwco9XzvbUl
         1on0ToQ4vm8Y9OZVvyhQYibwkmgghuWgxFMWb4mKFd0PDEc7c3YZfyvryVDP3o71uIm+
         P5VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eJjUepHMJ3XjQahPeLYVJZBCt2LbAJ4aSYQ6YGubxko=;
        b=bEOgIAwV+pNUvkcjly9BEfb8vEaqfxTsVod49re177a/wdUeInqZ7jWGgYyhA4LDM2
         xXPZbUx0v4YQYpiddWvXSrBRQGA9zNqbawOYj5bUtOWlbcw4tfRZKTjHSk/kB5vo4+zf
         pQjhoYGCuwUHr6fwy6T02jSHjuWqOV3iDO6M7Kt1S+RLykWMqwKo92PWxH0sbcYwJuyA
         k3SsLZslkZcGpfYaz7gS7fC4+n6uvBBYGALpvtSuBSAqrllefuOp0ebSp+hjX1dXtwx9
         ZBxBzmQ//OUSd6bk0rW7oVpPYmZdYfRfoyTsIpF8+Nj19OSC4OYG7gyZ9YHB8X7T7dwn
         UjYQ==
X-Gm-Message-State: AOAM53199fkiONPdjoOvWbeofnhYy+/jyjyvYzow3eLvVclq+85aQev5
        QRTw9gSNrffJs1GTs3Vj/bU=
X-Google-Smtp-Source: ABdhPJzRG2TfWe37Jh6rpASb5zh3vWrjCq+6dAkgrboDf4ApNeLowDOsR1kV/dtbcxV1Zhw4ujwYkA==
X-Received: by 2002:aa7:d4ca:0:b0:410:d232:6b76 with SMTP id t10-20020aa7d4ca000000b00410d2326b76mr5105031edr.370.1645046372504;
        Wed, 16 Feb 2022 13:19:32 -0800 (PST)
Received: from debian64.daheim (p5b0d7a4c.dip0.t-ipconnect.de. [91.13.122.76])
        by smtp.gmail.com with ESMTPSA id u2sm336886eje.119.2022.02.16.13.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:19:31 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1nKRhz-0018wB-5X;
        Wed, 16 Feb 2022 22:19:31 +0100
Message-ID: <70a8dd7a-851d-686b-3134-50f21af0450c@gmail.com>
Date:   Wed, 16 Feb 2022 22:19:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH] ath10k: support bus and device specific API 1 BDF
 selection
Content-Language: de-DE
To:     Robert Marko <robimarko@gmail.com>, Thibaut <hacks@slashdirt.org>
Cc:     Kalle Valo <kvalo@kernel.org>, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
References: <20211009221711.2315352-1-robimarko@gmail.com>
 <163890036783.24891.8718291787865192280.kvalo@kernel.org>
 <CAOX2RU5mqUfPRDsQNSpVPdiz6sE_68KN5Ae+2bC_t1cQzdzgTA@mail.gmail.com>
 <09a27912-9ea4-fe75-df72-41ba0fa5fd4e@gmail.com>
 <CAOX2RU6qaZ7NkeRe1bukgH6OxXOPvJS=z9PRp=UYAxMfzwD2oQ@mail.gmail.com>
 <EC2778B3-B957-4F3F-B299-CC18805F8381@slashdirt.org>
 <CAOX2RU7FOdSuo2Jgo0i=8e-4bJwq7ahvQxLzQv_zNCz2HCTBwA@mail.gmail.com>
 <CAOX2RU7d9amMseczgp-PRzdOvrgBO4ZFM_+hTRSevCU85qT=kA@mail.gmail.com>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <CAOX2RU7d9amMseczgp-PRzdOvrgBO4ZFM_+hTRSevCU85qT=kA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 16/02/2022 14:38, Robert Marko wrote:
> Silent ping,
> 
> Does anybody have an opinion on this?

As a fallback, I've cobbled together from the old scripts that
"concat board.bin into a board-2.bin. Do this on the device
in userspace on the fly" idea. This was successfully tested
on one of the affected devices (MikroTik SXTsq 5 ac (RBSXTsqG-5acD))
and should work for all MikroTik.

"ipq40xx: dynamically build board-2.bin for Mikrotik"
<https://git.openwrt.org/?p=openwrt/staging/chunkeey.git;a=commit;h=52f3407d94da62b99ba6c09f3663464cccd29b4f>
(though I don't think this link will stay active for
too long.)

Regards,
Christian
