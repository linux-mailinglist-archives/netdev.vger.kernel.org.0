Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC94331283
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 16:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhCHPsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 10:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbhCHPsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 10:48:14 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53886C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 07:48:14 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id n14so10428207iog.3
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 07:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sVonTVjJAMsK2GHD2m3lsQfvKmyuFm8091f3NUK9GTM=;
        b=XM1yQwDjytAiC+dTxdsDGZnShzb9Uklg8sEHeZbXvsR8tjzYWuFWIOEr1+OpX2QxMw
         pVfn7Mek2nBvTsFFPoMXemPvQSQKtUnehgMo56PPEHGRbdyDbiWliv8mIF/R2+EZ1Wko
         tzUWXSovDnJq2LHkNXVdQbofPBn/GUrzzedrv8CL5DAc4k25EaSjv52rtH3gB5UVPbQh
         sf9DarpMSLQ6cfC6TfUhqxv2qXeKwOcLDsLQBZUoNanK99bhwl5IEUpWB5EI1WY/WGcZ
         0XzM01BISnRWncl9+ibS7UihoqrHwh+TfF8fNLOOUnSCOaMHUpZvUrQiQenxTkllzQob
         F4rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sVonTVjJAMsK2GHD2m3lsQfvKmyuFm8091f3NUK9GTM=;
        b=CRlmCLrQpNmc6SRfQKpEmFxFKL1hyqEeip4z08AhJ+ncbd5UhPXiSu2cGopEPf23DD
         Ymo08a0knJkQSPrgmE8jk5sMtmg2BSJ48pOkxd05OgaZJBS7q0Hy1D8N5AYSXxuopneV
         4OWnkRk7Wr5DRuIFiwinXq523fWKEnUHGPwcKqCK+4CyKRZk9Y4oTfbsr3HT+M4mFpDj
         1WRPB7fcez/5hGLVqYrRbgYIJ5N1Ot3ijPFkI7Br6ofE2T26kjYLpG1gem9HfVJBNYi+
         gXQrK1dlAXdJ6Q0jsTuGw0eIjZtBL/90orKWkMP/LeWv/vV3PHVeGpNwsgI1eTupWoTX
         7xRg==
X-Gm-Message-State: AOAM531WNaFDxp+RJwg//Bp1htEQvhnliBeBCWi7Qq98BpIPsSG5QVy7
        VaHs/lWzck0MamDffr6AkgmDZWG5tSo=
X-Google-Smtp-Source: ABdhPJyGFbzYfW6XRnCbq9zmiRORGkI84jKb5CLLHwFYOOadJUIfLS8vJze/5P6BX7/X4ibPKOzcMQ==
X-Received: by 2002:a02:7119:: with SMTP id n25mr24551630jac.48.1615218493572;
        Mon, 08 Mar 2021 07:48:13 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id c16sm6369686ils.2.2021.03.08.07.48.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 07:48:13 -0800 (PST)
Subject: Re: mlx5 sub function issue
To:     ze wang <wangze712@gmail.com>, Parav Pandit <parav@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org
References: <CANS1P8H8sDGUzQEh_LEFVi=6tUZzVxAty9_OKWAs4CU67wdLeg@mail.gmail.com>
 <BY5PR12MB43226FF17791F6365812D028DC939@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CANS1P8E8uPpR+SN4Qs9so_3Lve3p2jxsRg_3Grg5JBK5m55=Tw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b026b2c8-fdd5-d0fc-f0a6-42aa7e9d26f8@gmail.com>
Date:   Mon, 8 Mar 2021 08:48:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CANS1P8E8uPpR+SN4Qs9so_3Lve3p2jxsRg_3Grg5JBK5m55=Tw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/21 12:21 AM, ze wang wrote:
> mlxconfig tool from mft tools version 4.16.52 or higher to set number of SF.
> 
> mlxconfig -d b3:00.0  PF_BAR2_ENABLE=0 PER_PF_NUM_SF=1 PF_SF_BAR_SIZE=8
> mlxconfig -d b3:00.0  PER_PF_NUM_SF=1 PF_TOTAL_SF=192 PF_SF_BAR_SIZE=8
> mlxconfig -d b3:00.1  PER_PF_NUM_SF=1 PF_TOTAL_SF=192 PF_SF_BAR_SIZE=8
> 
> Cold reboot power cycle of the system as this changes the BAR size in device
> 

Is that capability going to be added to devlink?
