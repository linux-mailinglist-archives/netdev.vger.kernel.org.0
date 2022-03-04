Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E464CCE43
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 08:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbiCDHDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 02:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbiCDHDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 02:03:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7933820F53
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 23:02:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ADC461D55
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 07:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F302C340E9;
        Fri,  4 Mar 2022 07:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646377362;
        bh=L8kaEBCCbaB2RO3ZzJG3ELbwC8QItZ6kqT+c9BvjG5k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ugzMbDCwoI3pejV+tCgGD0unIjZU/2FRA+I3XTyYQmf9x6Or5C09Kg/t1e18RL3h8
         rq89Lvp/K7TLmqKQUzC+lLjzc9dnPUWfhbadub+NsmlvzZkhmAk72YqfE9pKnfruqT
         y/IjB/vTZ6ILuQj2N1cv3zr+oqUZT3iWSz1YYQu8ZgPg++iUYnOAao095atLRye5GU
         4QrlJ+mXceW7MheMWENRH83trh7UBAjSN5cqQ6BhgE8UQo5NYrNAndHeA/bmIFhuM0
         Ahe9XdsKg86YxJFNS4RFlkJ6zua3bGnWZ0xYGA6LvcDBFC37wT3TMjjzn0Uno+Qxre
         CwyAkwyi6EfgA==
Date:   Fri, 4 Mar 2022 09:02:37 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shangyan Zhou <sy.zhou@hotmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2] rdma: Fix res_print_uint()
Message-ID: <YiG5jQHDA7HuGjrO@unreal>
References: <TYCPR01MB7578E54F06AEFE50785B771CE3039@TYCPR01MB7578.jpnprd01.prod.outlook.com>
 <OSAPR01MB75677A8532242F986A967C9DE3059@OSAPR01MB7567.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSAPR01MB75677A8532242F986A967C9DE3059@OSAPR01MB7567.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 11:00:28AM +0800, Shangyan Zhou wrote:
> Print unsigned int64 should use print_color_u64() and fmt string should be "%" PRIu64.
> 
> Signed-off-by: Shangyan Zhou <sy.zhou@hotmail.com>
> ---
>  rdma/res.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/rdma/res.c b/rdma/res.c
> index 21fef9bd..1af61aa6 100644
> --- a/rdma/res.c
> +++ b/rdma/res.c
> @@ -214,7 +214,7 @@ void res_print_uint(struct rd *rd, const char *name, uint64_t val,
>  	if (!nlattr)
>  		return;
>  	print_color_uint(PRINT_ANY, COLOR_NONE, name, name, val);
> -	print_color_uint(PRINT_FP, COLOR_NONE, NULL, " %d ", val);
> +	print_color_u64(PRINT_FP, COLOR_NONE, NULL, " %" PRIu64 " ", val);
>  }

Except the res_print_uint() that should be changed too, the patch LGTM.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
