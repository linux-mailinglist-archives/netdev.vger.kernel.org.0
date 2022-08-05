Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5F958AC0E
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 16:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240856AbiHEOBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 10:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240859AbiHEOBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 10:01:03 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E4F57274
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 07:00:55 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id o22so3476900edc.10
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 07:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codilime.com; s=google;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc;
        bh=sNf5ppcGyOUfMnTbYUDBYWvD3Ds01mlYy5oDLdO43Qg=;
        b=TjoForzEla3lqIihKwk/vmQcCzGiCKA3Jl2tMv4O/+HXlwLhmiGhEImT44rj0WtDl4
         PDwfcm7DCH6GEa6ddXqqkPKTqZXhHF7AO5FXKsfIYNtrOz23eiDwxD7Y6CdI77Jsm/yD
         RWdDDZLUFW5tcOdcy1liqkKidu7UQp9v2FoMPydj9WZ9kQVJQ6DvhOp502E0dqwqzCIy
         hRL7xhnNqaD7lPLRUuBYBIdKQPmSZooogPkaM69cew0krEGYHYus0AEjYFC+3KQ1FdzW
         LmxGftVzImqoPxXBvaQ+w7Ism1fDu7NSfJJB4IsCjXKluug1Av6VLhQwLXKsXu/2C8bO
         jq2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc;
        bh=sNf5ppcGyOUfMnTbYUDBYWvD3Ds01mlYy5oDLdO43Qg=;
        b=iuSuqZZVAEha1+5pxp7bmblDKoJtSRP0F1pyCKfwPIJD+4aTkD8j4qpA9R3Bb6QTQc
         ZA778CgjhpY5Y0R4U0Ck1gC7RrYeu09H4LT4nVfxl7SA+0LXBbIbic4hdoPnUX34vV4v
         vSJZMaAV+dFO3wZvy/hmMQ+WqCenTBX1uifQGgvd0ykK0YA9lTuex8v8WJNCaaR7d/A0
         fWJTKwLNBpj6uIdSa9e2EEkL0Nc2NdpPYNdWUQmLBLFf6CoIv4x87NrJSNRPW+qwjvoa
         Bk/oug+1XsIC0+RcMpGzxRUpjpoqTA1IAGor3xFAzJB6NoTtO0e1Ld/zUrWwtQ/c0G+7
         lDFQ==
X-Gm-Message-State: ACgBeo2M7i2DFVetjhOh6GdHH/f8nVlheAfmUJfgDE7W03MpvsKOQH0j
        ACkzXconRC1oTI5lapD2x9rJ70iQyRBfv5su5RWrn2p41GPy38pJyXAcFrM6TkLoSFAwy+W+0Sa
        3APmeCDviEIR+yVfcHT5jL0nE/zlGgIZ5ZQ==
X-Google-Smtp-Source: AA6agR5HCqyeQfQIynNwlgsbTBMHbcT+XXjYDFfw7MPUMk233xKqFtEhY4zH9a6fyqZ3UMHWenS9+ZdsJs7BIHssg8A=
X-Received: by 2002:a05:6402:1bc9:b0:43d:3903:11ee with SMTP id
 ch9-20020a0564021bc900b0043d390311eemr6899014edb.113.1659708053932; Fri, 05
 Aug 2022 07:00:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAPYuOdx2jPwOWYPzo5z-xWQtEmNHO==pAKH63xxaOtG6JbGxdw@mail.gmail.com>
In-Reply-To: <CAPYuOdx2jPwOWYPzo5z-xWQtEmNHO==pAKH63xxaOtG6JbGxdw@mail.gmail.com>
From:   Maciej Wachowski <maciej.wachowski@codilime.com>
Date:   Fri, 5 Aug 2022 16:00:43 +0200
Message-ID: <CAPYuOdw380Ro1_dGm0usewPGaJJFLExM4XYuianBhExNOqg=aw@mail.gmail.com>
Subject: Re: Cannot change hash functions or use static not random keys on E810
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am not able to change hash function on Intel E810 card using ethtool:

RSS hash function:
    toeplitz: on
    xor: off
    crc32: off

root@my_server:~# ethtool -X ens802f0 hfunc xor
Cannot set RX flow hash configuration: Operation not supported

I also tried with newest ethtool (5.18) and newest ice driver (1.9.11)
but with no success.
Do you have any information on how to change hash func using ethtool
or if it is possible?


Best regards,

Maciej

-- 


-------------------------------
This document contains material that is 
confidential in CodiLime Sp. z o.o. DO NOT PRINT. DO NOT COPY. DO NOT 
DISTRIBUTE. If you are not the intended recipient of this document, be 
aware that any use, review, retransmission, distribution, reproduction or 
any action taken in reliance upon this message is strictly prohibited. If 
you received this in error, please contact the sender and help@codilime.com 
<mailto:help@codilime.com>. Return the paper copy, delete the material from 
all computers and storage media.
