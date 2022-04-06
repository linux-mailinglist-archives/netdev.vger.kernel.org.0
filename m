Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138724F6739
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239277AbiDFRaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238776AbiDFRaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:30:07 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305251DB8B9
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 08:33:09 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c23so2313448plo.0
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 08:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MjcSmqVHYIq7U0K7l10IYhCWyYGrYQ0aIl97wixacUE=;
        b=tWTS5JVVCTZIbmlRikAbLaxDeEgUr/dKhCx0fPFViKb6DcFs3hgevgsEQ08QzgUrw8
         3XB7pxHXwGw8rUqzaYIO/Gvi6tZLLzI9/nxfFALkvwg+uunSRXFI56hz0zR/auasxUmw
         v0foYieQ+mfSjaTaeWfOSgKVMtWK8/78FTZTMVBsY+SjnzLMeuM6kw/DrLWCZRgAnOnE
         KlHescpJcjHFc+LM4cgnrDDNhjF9GWziWcpQnzHUoaS7tqP6fHi0pMQJGs+B44TF4Xph
         +dsordLzU5os0wjurH/3wJJTBnUCEJBCNTgF2loaBn8LPCyFBGrePRh3PiIlgvOxJ/Hr
         y/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MjcSmqVHYIq7U0K7l10IYhCWyYGrYQ0aIl97wixacUE=;
        b=dHJDRUu8JQiuwymsvpaOpug8m8vgSLKIDhYrygTKrRPXoM1vlBRUzmgMYWJ8vIef7L
         4fo48VuKMTbzJQGiOLelfM2X60bKpqFZridyaReLTSAeoQ45XwTdH/SvZfWjrUQm4pil
         UvIkhsXJehcfPeTJPTSZ+nt91PZTDdYaq+0Bx/HsWcKEjoNG3SWY5qdp6Q139dayrT9b
         Lf0/B3Ep6+pq1tSqQpwFGZw4rV01bb46v4KZZUbTNDDjxwfvl7SMmj52CH5M44cPibpt
         mX75XQsoDpO7/1FT//FU23hAEW/b6lKHz9zRKLfq8rJvKG6UuthzzFCdLqzpfyjKguWI
         F/gg==
X-Gm-Message-State: AOAM530KJV32FbGgK+L3kkvE72T8G+f2kzqtF15dJWbJwdEQawzT+G40
        duqqxjGSLnJg87phaq3py3I6VG3G5mNXsA==
X-Google-Smtp-Source: ABdhPJxTJfOJWX8QKl5KE8ghsJS+YfCjGTH+zNruTOXjMBxmcSp4+dmprTaA8p9SdiqUtmN9QrSZyA==
X-Received: by 2002:a17:902:e748:b0:153:b484:bdf4 with SMTP id p8-20020a170902e74800b00153b484bdf4mr9111105plf.66.1649259188684;
        Wed, 06 Apr 2022 08:33:08 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id f6-20020a056a00238600b004fae79a3cbfsm21102284pfc.100.2022.04.06.08.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 08:33:08 -0700 (PDT)
Date:   Wed, 6 Apr 2022 08:33:04 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     08005325@163.com
Cc:     netdev@vger.kernel.org, parav@nvidia.com,
        Michael Qiu <qiudayu@archeros.com>
Subject: Re: [PATCH iproute2] vdpa: Add virtqueue pairs set capacity
Message-ID: <20220406083304.724d3cd8@hermes.local>
In-Reply-To: <1648113553-10547-1-git-send-email-08005325@163.com>
References: <1648113553-10547-1-git-send-email-08005325@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Mar 2022 05:19:13 -0400
08005325@163.com wrote:

> From: Michael Qiu <qiudayu@archeros.com>
> 
> vdpa framework not only support query the max virtqueue pair, but
> also for the set action.
> 
> This patch enable this capacity, and it is very useful for VMs
>  who needs multiqueue support.
> 
> Signed-off-by: Michael Qiu <qiudayu@archeros.com>

You need to add show logic to pr_out_dev_net_config
