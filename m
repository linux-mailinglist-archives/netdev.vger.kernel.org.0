Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D311D5B9ED2
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 17:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiIOPbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 11:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiIOPbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 11:31:35 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B494CA16
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 08:31:34 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id g3so10549725wrq.13
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 08:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date;
        bh=Z4bGEoipREF/dVI8gmZ3B95b9Ue3ls+PMO8g10RMems=;
        b=AVIRDNt3/0EyryypXmc4hBoMrP1W0dFrTU5dXZI2xP00Z7k1K2CM+qXKpNShen78K3
         NVfitBP+w0RY561y2mtZ3P4R63csfLco72y812cD+0P40gwaJ9ZcqAgO9p+uurDZv/UD
         Vw9mB/sef0wLmAmWejbC9zMpf+3tPQHWj6OAx0pnWP3VcJsotoVffeSOTGBL8wWGoxN0
         2u9pu5lx76fXAsONJSqhuhxJBR165z4sPmMxsWp8aYD6pVHA+iL4FqglL4SXBdsJptKJ
         ogUBC2DatSEsQKScraFYtoSnozzTVejkmQp0Lzids662yz9CvzBx2mApV/QnfzTpqgdg
         6WDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Z4bGEoipREF/dVI8gmZ3B95b9Ue3ls+PMO8g10RMems=;
        b=Zw2x7eAYdHRHwDIINkfsOE7ol15ZzkWvgY6cI/ImyipbXigs7zQClp25CFfNGHP2n6
         Dd+HkewnQiiducAPu1VX4YssjsVh6zJf3LJeGFT8vuxCrtkXgIDu9lWrdHc5/RleSZ41
         a2nCEzjAU/kt+Gt6bj1/a9tY4iFM7eI2jT6vr0idJTh3omSVD//QS3t2hfKVIdIdjRDa
         4vV1VtlkXq0enhLbSnZ9k8H5b+IOK5cSjN+BJnz79cnDWFI9FQr1l5k4TUCmxDObw3gi
         z50IY0MiudX3jYTM9ouj/8NpUHecGpmR54vUegDewlKEt7bcVvAbQleKz4y598gWHZaG
         srAQ==
X-Gm-Message-State: ACrzQf1jp1vq9Db5WHo11rjZ7pDUmjCraTShJT6OTV9mDz5/ifUY/yz0
        zzDandWWQiy+Tt1sLVbo067OLz/w2oc=
X-Google-Smtp-Source: AMsMyM4r7PCCNAr01etx/T4Lbu6R2C1eQCTVcK4f6L/Pe+mvKR4DuI6iu0f11KIm72XMXr94U6evrg==
X-Received: by 2002:a5d:60c6:0:b0:22a:d6ec:63ac with SMTP id x6-20020a5d60c6000000b0022ad6ec63acmr135503wrt.309.1663255892950;
        Thu, 15 Sep 2022 08:31:32 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id y10-20020adff6ca000000b00228cd9f6349sm2813799wrp.106.2022.09.15.08.31.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Sep 2022 08:31:32 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api with
 queues and new parameters
To:     Michal Wilczynski <michal.wilczynski@intel.com>,
        netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, dchumak@nvidia.com, maximmi@nvidia.com,
        jiri@resnulli.us, simon.horman@corigine.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
 <20220915134239.1935604-3-michal.wilczynski@intel.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
Date:   Thu, 15 Sep 2022 16:31:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220915134239.1935604-3-michal.wilczynski@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/09/2022 14:42, Michal Wilczynski wrote:
> Currently devlink-rate only have two types of objects: nodes and leafs.
> There is a need to extend this interface to account for a third type of
> scheduling elements - queues. In our use case customer is sending
> different types of traffic on each queue, which requires an ability to
> assign rate parameters to individual queues.

Is there a use-case for this queue scheduling in the absence of a netdevice?
If not, then I don't see how this belongs in devlink; the configuration
 should instead be done in two parts: devlink-rate to schedule between
 different netdevices (e.g. VFs) and tc qdiscs (or some other netdev-level
 API) to schedule different queues within each single netdevice.
Please explain why this existing separation does not support your use-case.

Also I would like to see some documentation as part of this patch.  It looks
 like there's no kernel document for devlink-rate unlike most other devlink
 objects; perhaps you could add one?

-ed
