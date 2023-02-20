Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C74969C6D1
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 09:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbjBTIf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 03:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbjBTIf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 03:35:58 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83CB13DFB;
        Mon, 20 Feb 2023 00:35:41 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id p18-20020a05600c359200b003dc57ea0dfeso326373wmq.0;
        Mon, 20 Feb 2023 00:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hW5au7Ld0bifXxWv0Ag8WVudrdSJ55bzMPJ9o228sOw=;
        b=cp0JiSmIZNa9J/uYldA9GvkheAkTXGNahQ7x7afIjYrPHUZoIoyUn/HLD0ajEvCzt7
         5ZEJhk8gsHhdxZdNElB4jd39P7MMQABzIK56e/f1zsGQi8t3ExZFEQzx5+pgyqUaU2lC
         slQjl4mdl7/a5EWWQUlpf3sS64UtCvwIeChVFYQ6caeuft+aTp3tB/ctqsSLQo5jKi05
         cW3VJfJq+IjX6Ibc8edymEbGFgaXqMr0LPlIuwuBpQr0vi0kceIR73e6dva++1BAaV53
         /vcMr/h83X75HhGHA/clKqNdk90hFPBPbEzGcrVz2CQ6FGqR4TicUKCtsAf5XQvXua0u
         9NCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hW5au7Ld0bifXxWv0Ag8WVudrdSJ55bzMPJ9o228sOw=;
        b=2DPJRyGaQKAKeC+pRGi0BZtaY2BE65FfRmPlaCoz9HlR4Tq9j4n2oXRyIQvDzkV8C/
         nyX/26CRX1URIs+Na1tMSZ17WigGYkKmFIHX+HvXBDG7mbLgrcjf48vGOjhjGJ8RJG3h
         1UixY+kPFGD4ei+8cPtCHH3Yt0sZz9oNLtNuEdXfYEGst/+h6paE8kp4mKjJYAMOSt4C
         yHQNVcK7vrhDA/LyKX9JERWEcsaH61Lhe+aNy9UY+hOm3UqRdaEqsDKArGcPr4tvMnnn
         +aFerRiB3ByYRsx2Y+I874ubCc2MimWQP6cLnmJAGqBJf6/oL1trZ95gZtaOeQte+yZq
         j15A==
X-Gm-Message-State: AO0yUKWBFS+FYPKfVcJsf1uYx3pCGC9SBzhg/+N4p46jM8r39zIQYGLo
        M06QPoAgsIPosN1NXPwUD9U=
X-Google-Smtp-Source: AK7set9VeEalWKHv4Y6TUjRdv/Y03YbCxkJrH9xMxmAv7B4Z/1yhXE/yQfXF9C50y7DkjFKV3z9KTQ==
X-Received: by 2002:a05:600c:a4c:b0:3df:9858:c02c with SMTP id c12-20020a05600c0a4c00b003df9858c02cmr3842690wmq.1.1676882140217;
        Mon, 20 Feb 2023 00:35:40 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id f4-20020a7bcd04000000b003e00c9888besm8579773wmj.30.2023.02.20.00.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 00:35:39 -0800 (PST)
Date:   Mon, 20 Feb 2023 08:35:37 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, ecree.xilinx@gmail.com,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] sfc: clean up some inconsistent indentings
Message-ID: <Y/Mw2UZ7KRF8iWfD@gmail.com>
Mail-Followup-To: Yang Li <yang.lee@linux.alibaba.com>, kuba@kernel.org,
        davem@davemloft.net, ecree.xilinx@gmail.com, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
References: <20230220065958.52941-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220065958.52941-1-yang.lee@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please fix the subject to use [PATCH net-next].

On Mon, Feb 20, 2023 at 02:59:58PM +0800, Yang Li wrote:
> Fix some indentngs and remove the warning below:
> drivers/net/ethernet/sfc/mae.c:657 efx_mae_enumerate_mports() warn: inconsistent indenting
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4117
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/mae.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
> index 6321fd393fc3..2d32abe5f478 100644
> --- a/drivers/net/ethernet/sfc/mae.c
> +++ b/drivers/net/ethernet/sfc/mae.c
> @@ -654,8 +654,8 @@ int efx_mae_enumerate_mports(struct efx_nic *efx)
>  								     MAE_MPORT_DESC_VNIC_FUNCTION_INTERFACE);
>  				d->pf_idx = MCDI_STRUCT_WORD(desc,
>  							     MAE_MPORT_DESC_VNIC_FUNCTION_PF_IDX);
> -			d->vf_idx = MCDI_STRUCT_WORD(desc,
> -						     MAE_MPORT_DESC_VNIC_FUNCTION_VF_IDX);
> +				d->vf_idx = MCDI_STRUCT_WORD(desc,
> +							     MAE_MPORT_DESC_VNIC_FUNCTION_VF_IDX);
>  				break;
>  			default:
>  				/* Unknown mport_type, just accept it */
> -- 
> 2.20.1.7.g153144c
