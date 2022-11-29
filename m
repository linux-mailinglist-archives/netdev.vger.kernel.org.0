Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1DA363BCAA
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiK2JNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiK2JNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:13:40 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513203E085
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 01:13:37 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id d20so8120489edn.0
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 01:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zm9HqCcqV4Dc0cSiKD6aK7hsPan9Fp9lKsI9qTmKRFo=;
        b=J7yjw9sX36UxGxmYw6J6YGmmd23lrXJd+rxYAlk/qp/nRkWqD1daIKOd0KY+KoJwiS
         56JVBv1JgvwGUkypEs+fiC8JdcoIDskYDHjAXUOVu1fl30On+vmq0SrGFl8avkIk10LQ
         W/rWzVzxZvSV1Aon8LV/TKyzq8wuGNPO0fLVzs3yIweVSay1Qu0yuaYsYNCKnb5Wfznn
         mCUzS/H7kXFr39zmcsBPrfcI7sOMmkEmpL5B8VyXikvJOdr2wPPB6XzGrynk86BVGBsq
         k9xTm1n2FaTTLzX6DwufXxlexOfP/EZpXaeYzMSRkvd7K4al6CBqWZcKe9UP+oglFilL
         0UjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zm9HqCcqV4Dc0cSiKD6aK7hsPan9Fp9lKsI9qTmKRFo=;
        b=hN/gZXHMobSN67l1qHNRuLtGn6UQR1GTVgI+FIrvo/x70LU5u5384BBb6XorQnVvRF
         Zleu4IkanYDBccW5AklbyG1CZsgKLMo1oD1Jl578hnR7gZWzhdiQ9BDQsoIhOMa3A7SV
         FHNktsWNp0t5Le1gxf5NPMAPSMhtr7THyGXXXIkDR/sFVI0qfX9sHqnVH0gG9wdzSUlo
         tXUnwwkYCl9lqnLNplA0tbmPEUa4iccKwEYILGNA/eHXZqahl5J/nNnJpGn1TAIf6ljP
         f4ykIqFiwxaMOmLdW3z6DYKB+VedVpwdh3cvAYPf7442huAvAzYA/9G27RkighvytI7B
         eyhw==
X-Gm-Message-State: ANoB5plBOUT+IutcFBwpr2UJdbZ3VSGPAcKyHNcIquGNmr6HLLnJcdCF
        sM65qakDyajJx8oLV789y3wXcg==
X-Google-Smtp-Source: AA0mqf5yJnVC8Zc01rktsWBuaK+b+xSIG973AWQKsMM2AjYT+sdkNhxPDpfsCf1yXXosDVjwyZoXyw==
X-Received: by 2002:a50:ee96:0:b0:469:d815:6b09 with SMTP id f22-20020a50ee96000000b00469d8156b09mr33202156edr.288.1669713215837;
        Tue, 29 Nov 2022 01:13:35 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id y12-20020a056402358c00b0046ac460da13sm4702121edc.53.2022.11.29.01.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 01:13:35 -0800 (PST)
Date:   Tue, 29 Nov 2022 10:13:34 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Shannon Nelson <shnelson@amd.com>,
        Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, drivers@pensando.io
Subject: Re: [RFC PATCH net-next 10/19] pds_core: devlink params for enabling
 VIF support
Message-ID: <Y4XNPtIVgkWsbA79@nanopsycho>
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-11-snelson@pensando.io>
 <20221128102953.2a61e246@kernel.org>
 <f7457718-cff6-e5e1-242e-89b0e118ec3f@amd.com>
 <Y4U8wIXSM2kESQIr@lunn.ch>
 <43eebffe-7ac1-6311-6973-c7a53935e42d@amd.com>
 <Y4VEZj7KQG+zSjlh@lunn.ch>
 <20221128153922.2e94958a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128153922.2e94958a@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 29, 2022 at 12:39:22AM CET, kuba@kernel.org wrote:
>On Tue, 29 Nov 2022 00:29:42 +0100 Andrew Lunn wrote:
>> > How about:
>> > 	DEVLINK_PARAM_GENERIC_ID_ENABLE_LIVE_MIGRATION  
>> 
>> Much better.
>
>+1, although I care much less about the define name which is stupidly
>long anyway and more about the actual value that the user will see

We have patches that introduce live migration as a generic port function
capability bit. It is an attribute of the function.

