Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1FA5851E0
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 16:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbiG2O45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 10:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbiG2O44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 10:56:56 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF2D12620
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 07:56:55 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id n133so6092414oib.0
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 07:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RsDVZrZl+LA3Kc/LKUOnJ3Y91mTRnGArvMRybqe4uwY=;
        b=QbjrZPJ9MnriBYjMOzRy8OgARYOxap4+8wyfbVogH9gUa1TFh7nb7EosJyq8QIBAF6
         LzMn7+q4y2V3ekQRUDCVNX63WcgufIE2F14zA4SAuVUv3OXFtx3vGFTZvtp0w37azY27
         39Mm24nQCTWy1NOc08479pcqgS8jPqSf2dr71PsymR93TBk6gPzOjigJ1uQgdZbn5AhM
         Pl1b3J0xCcoB0J1l3tdDfLkQJhcYslhAelKTJAzF/iseTu4COFasKubnGS3ze4xMP4Vq
         j2umd6XQ3h5cYUC2yJtsYqWZOM7yQe6J+rCxpGqHzRI441tXvr/1+zrEq7EP5kauiOGO
         n+4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RsDVZrZl+LA3Kc/LKUOnJ3Y91mTRnGArvMRybqe4uwY=;
        b=ltkSnhRj9FCn7X5541Cox4vv4zPBgo2YajpVV95Eq03WeXUL21QEYQZPvG64uBmM6F
         0BxwOtWQhpM9HeO3ONA4vnvCmw3htG86I7HgKZXZ9QcWLLLM0RbOu1Q7mSaKVRFAhPHl
         zq0x2xSU+t1K0ZSTIeaQk8T89MyyJl/CMcWUKF3GMM1S2EMMN1pmM0PPrq85EmXNgBN0
         fYWMtJD7cXEyf/OGefMOqGyjJNWRpG7ZYe1RSRQeCHqswFZvdLGnN0h8H5FD9aZelbhL
         UZx3D/eBnscrfWe8ju2xKYsjC2JCiPpABxreblvMRoCxFbADomQsqIlcFjfWt771U1LI
         R+mA==
X-Gm-Message-State: AJIora/7GSFCE/JV27hJBbM2b0l3StkRVH6ZodgnH3RgagV3mDJyqj+a
        B/U/CsB6YmXDQE9GkFwLQMA=
X-Google-Smtp-Source: AGRyM1vilbZihfen3yHUUQtwMpJTWNOG/0lTFJO+mMaWh7+zUQ04QMGQb3dZ8T1KeFVsFpi858nDpQ==
X-Received: by 2002:a05:6808:1b24:b0:33a:bab5:ddcf with SMTP id bx36-20020a0568081b2400b0033abab5ddcfmr1716919oib.210.1659106615155;
        Fri, 29 Jul 2022 07:56:55 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:b47e:4ea2:2c6e:1224? ([2601:282:800:dc80:b47e:4ea2:2c6e:1224])
        by smtp.googlemail.com with ESMTPSA id v22-20020a4ac916000000b0042573968646sm1344660ooq.11.2022.07.29.07.56.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 07:56:54 -0700 (PDT)
Message-ID: <a1f2d255-7ae5-8091-9ff1-574ae3c7dd11@gmail.com>
Date:   Fri, 29 Jul 2022 08:56:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH iproute-next v4 1/3] lib: refactor ll_proto functions
Content-Language: en-US
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>,
        Guillaume Nault <gnault@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
References: <20220729085035.535788-1-wojciech.drewek@intel.com>
 <20220729085035.535788-2-wojciech.drewek@intel.com>
 <20220729132200.GA10877@pc-4.home>
 <MW4PR11MB5776E25C99B1DC3505BB4A54FD999@MW4PR11MB5776.namprd11.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <MW4PR11MB5776E25C99B1DC3505BB4A54FD999@MW4PR11MB5776.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/22 8:32 AM, Drewek, Wojciech wrote:
> Sorry, I forgot to add your Acked-by, if next version will be needed I'll add it.

please keep the ack's on the next version.
