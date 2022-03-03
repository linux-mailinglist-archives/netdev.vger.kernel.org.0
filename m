Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F31A4CC561
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbiCCSow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiCCSow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:44:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4231417AED6
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 10:44:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB66261A39
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 18:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E58C004E1;
        Thu,  3 Mar 2022 18:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646333045;
        bh=iumLjh/ik+safnecPh9AJ5zFMOmji8jRD2z9gGv5CCk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IdAc1kSDczeTyo1llsGYIsJUvayn5fBNGCbQrLBJicGci+aJoa5qrzn3RuyclTkec
         6EwfdUHoU+QJozKWYrBLAcyN1s5q/I5lght4CNqZTolXc2qLml19syFDuBn3+N2izy
         F10BbHozH5Hv/R8nHD9iO39pSz7xtFw3GmUqv8F3HJJLRD6NkGY4pS8gkd57IQlEL+
         qRPx/68qbZXcCEAlnqKmwz/hj8ocpWzbm325cuq2YAr/44JsNCSkbHApKJm8VnWAzb
         BkdTvhvm/FNIGHKvhaDuFCC1CQeZfOUNPbklFsFq6zx/dWFdLQoWWpwTbHO/UwnH7k
         vKKYaUn2F+wLg==
Date:   Thu, 3 Mar 2022 20:44:00 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shangyan Zhou <sy.zhou@hotmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] rdma: Fix res_print_uint()
Message-ID: <YiEMcDbZAvSsFURj@unreal>
References: <TYCPR01MB7578E54F06AEFE50785B771CE3039@TYCPR01MB7578.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYCPR01MB7578E54F06AEFE50785B771CE3039@TYCPR01MB7578.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 11:06:41AM +0800, Shangyan Zhou wrote:
> Print unsigned int should use "%u" instead of "%d"
> 
> Signed-off-by: Shangyan Zhou <sy.zhou@hotmail.com>
> ---
>  rdma/res.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/rdma/res.c b/rdma/res.c
> index 21fef9bd..832b795d 100644
> --- a/rdma/res.c
> +++ b/rdma/res.c
> @@ -214,7 +214,7 @@ void res_print_uint(struct rd *rd, const char *name, uint64_t val,
>  	if (!nlattr)
>  		return;
>  	print_color_uint(PRINT_ANY, COLOR_NONE, name, name, val);
> -	print_color_uint(PRINT_FP, COLOR_NONE, NULL, " %d ", val);
> +	print_color_uint(PRINT_FP, COLOR_NONE, NULL, " %u ", val);

val is uint64_t, so the more correct change will need to use print_u64(...)
and "%"PRIu64 instead of %u/%d, but I don't know if _color_ variant exists
for *_u64.

Thanks

>  }
>  
>  RES_FUNC(res_no_args,	RDMA_NLDEV_CMD_RES_GET,	NULL, true, 0);
> -- 
> 2.20.1
> 
