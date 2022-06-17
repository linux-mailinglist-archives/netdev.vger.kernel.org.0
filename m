Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B741F54EF96
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 05:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379975AbiFQDMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 23:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379971AbiFQDMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 23:12:21 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7E366235
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 20:12:20 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id l4so2918503pgh.13
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 20:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+N+dvGmXc1f+RZmp00Ct2oTKXTDuTdwW097S9+qW+jg=;
        b=mViWEs6FsG0fGRc4M6iX3VQFPlyyrYlKY3PNkApY5ZnDXujMbkLFGo1HmupknWGDxp
         l4+izRZ88lnSqtRP6oZDCNFLVqPxFIj8wZsxQdX/c1BgME86MCbGnL4VPS/b+jfmI8yx
         nqhLmFgdS6h26atYL/lYb2nIOQboSHQGmVmhjfKKXw8dmG3q4SYUjS6ETqoLoLMUSQ3+
         4qYjVXCrOWTJ4vb2YWi7FPEyfrrSyEl3CHZPgOSg/Zl3gnkXkgkY9pbtqbH2GXHV/Yd4
         mWPaGMC72rXdCeacVcrFmdBLKeKdZl+d4CeLi/kzcNuAaVA04orlDVhoOfzXJ9/MsLcE
         GhXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+N+dvGmXc1f+RZmp00Ct2oTKXTDuTdwW097S9+qW+jg=;
        b=0Qd54q89rJypn/83zqm3d549w38z0Ohg8GrtQhcShiBxAPLNI84oB3pRHBqXWGF3OP
         RFTiu0z3H5BL+14ofc1K7eOhXENxqv4MvyOSC0oV8O3pDaQaSrVbQu0ZqhGHK9xQKtxP
         NHEnAw4lbLRMrdPaNcC5CgnicQALfh7EvA1oCPCdTAF5EM9QoianFDMxJslPXYqwfDfT
         ZweO8jD3k24sflm2izm9NMxmjeoxszy2gSB6RYucFj3HhZiKrNl855kDdjwK1Zf8VG0Z
         M6nZoomYeOu15QcgSMn9l2f1k3mPNIdHbgYlDlhu1AtMIKjLlYClnsltQ49rU/VxtTCa
         ou6w==
X-Gm-Message-State: AJIora9rTx+ZzdjEzS2TgPweUks2HHjDjp46Ovh1+Q5Kya/sYVJ+xjfY
        crePihsq1+ZoPd0ru/s3yqEfqKX+2PZD6Y9a
X-Google-Smtp-Source: AGRyM1sF1/pD31CmfPMt4mB/bkebJ7p06DJCpTDn52OoAa44mONcCNA1i+Zy94baEAAMlIBBYo6VTA==
X-Received: by 2002:a05:6a00:179b:b0:51b:f51f:992e with SMTP id s27-20020a056a00179b00b0051bf51f992emr7841742pfg.60.1655435539964;
        Thu, 16 Jun 2022 20:12:19 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id b19-20020a62a113000000b0051b9ac5a377sm2488196pff.213.2022.06.16.20.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 20:12:19 -0700 (PDT)
Date:   Thu, 16 Jun 2022 20:12:16 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     HighW4y2H3ll <huzh@nyu.edu>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] Fix Fortify String build warnings caused by the memcpy
 check in hinic_devlink.c.
Message-ID: <20220616201216.2eefad10@hermes.local>
In-Reply-To: <20220616235727.36546-1-huzh@nyu.edu>
References: <20220616235727.36546-1-huzh@nyu.edu>
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

On Thu, 16 Jun 2022 19:57:27 -0400
HighW4y2H3ll <huzh@nyu.edu> wrote:

> ...
> 	memcpy(&host_image->image_section_info[i],
> 	       	&fw_image->fw_section_info[i],
> 	       	sizeof(struct fw_section_info_st));
> ...
> ---
>  drivers/net/ethernet/huawei/hinic/hinic_devlink.h | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.h b/drivers/net/ethernet/huawei/hinic/hinic_devlink.h
> index 46760d607b9b..d7b26830c9ee 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.h
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.h
> @@ -92,14 +92,20 @@ struct fw_image_st {
>  		u32 fw_section_cnt:16;
>  		u32 resd:16;
>  	} fw_info;
> -	struct fw_section_info_st fw_section_info[MAX_FW_TYPE_NUM];
> +	union {
> +	struct_group(info, fw_section_info_st fw_section_info[0];);
> +	struct fw_section_info_st __data[MAX_FW_TYPE_NUM];
> +	};
>  	u32 device_id;
>  	u32 res[101];
>  	void *bin_data;
>  };
>  
>  struct host_image_st {
> -	struct fw_section_info_st image_section_info[MAX_FW_TYPE_NUM];
> +	union {
> +	struct_group(info, fw_section_info_st image_section_info[0];);
> +	struct fw_section_info_st __data[MAX_FW_TYPE_NUM];
> +	};
>  	struct {
>  		u32 up_total_len;
>  		u32 fw_version;

Patch is missing signed-of-by

Using [0] inside union will cause warnings in future since you are referencing
outside of bounds of array.

Also indentation is wrong, you need to indent the union
