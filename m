Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E67F65B2B2
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 14:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbjABNes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 08:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbjABNer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 08:34:47 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763AD6447
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 05:34:45 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id k26-20020a05600c1c9a00b003d972646a7dso17560757wms.5
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 05:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y/Yzl4um9V42xJOcfP8E1ke9YNBK6l/KwLH72T+I6Jk=;
        b=1ws2U//nF3GWS5y+iFideC24gKdpsLZRe2z/WG9SqfSroUdvuZku5HMgcM4FdBmWKx
         nrpeEOfi5R4oFYS7WKya8KxMBkBsXaeMaTvXHm8pvQfuiWJDQZ7P9wexVjBaZNcS9Cll
         Cl1RKbLNOk3ObnCaqro5YMPd1DeajVK/edbrhc4Sm2PCuxdmKQlZdvSk3cu45WCaf+j+
         UxHjHqp2pNQnF60+R3RJqyu7Y3mp1FbkDuRURVEhsBt00ppeTUFpFz8f66mC3DFIl2SM
         YaIR6i8JxthjrxyGoZvGYKuILhf3Zmdc8h88+RlU1+y5974OCYdm3DMID96l6NKfzY2k
         crqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y/Yzl4um9V42xJOcfP8E1ke9YNBK6l/KwLH72T+I6Jk=;
        b=wXI8AAZ+5GYBW7qFjg+gupMOK4BQUn+OU2MKAAtvSknq+tVkKvIc88/6/71eelYn5B
         s8QmMhH/gmlsbrRWDRuSSguZU5wLSNm0YSvFHVPFhVSe+Qq8SR7nIzqzCvjmpbD8f2zc
         zwntTMqG8I0TTBlq8wPqlo2h/y5tcl+I99zLEzH4CMBIJojfM6i5Vn6bjrpLS11GzD6P
         ZudAmgGIT7Uo/hAtWNbuQKtIe/359uTbAn5Wksjm2ostkMYtOrm+PqgaZZFH5sjW/erC
         2/+OFlb2G4OGyGTj9lQEdYYx2BXAge3JBO6RQ+ViAwj2p9wNKdfa7ouY9x4NOhkxOmmB
         DA+A==
X-Gm-Message-State: AFqh2kqLBQYzquCGPUgwRiO2gekrTVuwdQ4GafBhOQtwQLd4zakcpcQk
        lFu7x2Z86b3kJdWLCFXfQs4JQqvgGkHSdSeBXErbfg==
X-Google-Smtp-Source: AMrXdXv1D+04H/tAy2h8dm59geSKG1/xjG36875HR4aH7wb7BauhXhSi3ur9igSOnDdXRRmZA6IXlQ==
X-Received: by 2002:a05:600c:4998:b0:3cf:68d3:3047 with SMTP id h24-20020a05600c499800b003cf68d33047mr28572981wmp.41.1672666484097;
        Mon, 02 Jan 2023 05:34:44 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id m18-20020a05600c3b1200b003a6125562e1sm42573557wms.46.2023.01.02.05.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 05:34:43 -0800 (PST)
Date:   Mon, 2 Jan 2023 14:34:42 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 10/10] netdevsim: register devlink instance before
 sub-objects
Message-ID: <Y7Ldciiq9wX+xUqM@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
 <20221217011953.152487-11-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221217011953.152487-11-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Dec 17, 2022 at 02:19:53AM CET, kuba@kernel.org wrote:
>Move the devlink instance registration up so that all the sub-object
>manipulation happens on a valid instance.

I wonder, why don't you squash patch 8 to this one and make 1 move, to
the fina destination?
