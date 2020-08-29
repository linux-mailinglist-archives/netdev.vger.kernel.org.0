Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06092566F9
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 13:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgH2LAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 07:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgH2LAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 07:00:31 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D8EC061236;
        Sat, 29 Aug 2020 04:00:30 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id bh1so829931plb.12;
        Sat, 29 Aug 2020 04:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=rbN31fDgN155GoEPESBbfhOMLuhG295QfIVmklyynfc=;
        b=M4tw0T9Qf9xg3i50nAO6NEFPH0QiPj1hJ2d3crfampfvSqM0XPH+X7FDJFJnfJXqSp
         CEfpYdLqN31z+u5NjHoPZssVkp7MgTXx53YWS4Aa7Z/ZLHqHUpUQ7pwtH5dfzwJUVwdG
         lD9s+EwCPFZFq8kqmrFJ71+QAmn6fMVCEJW2JBRmUPH/2FhbSQSd4RW7jAkTpArsP/09
         8qwDAr0o1Ur0kMmZgu76Xk/2B1dunipPzBdlLodfUFFvesYi/cIRTkfOV8cju+g25Slz
         SXuVieGPoX4mDzK3b3uWVXRgxQ52ipNgzyzM+UrE3jAA5e1pfDlxrCmLl/1TLncTaiRy
         /KyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=rbN31fDgN155GoEPESBbfhOMLuhG295QfIVmklyynfc=;
        b=hDE/wjUjC2YK4GLublxeEq4SJUlGmgRi/NtwFG4/NqCiMoYp311qmev7eY4BpD+FZm
         fQFV9/uQchmp8oJLhmjU0hnr4hJ0vo+kJNbzB7+YBu5bUNqfZtpB0bZFDXx6WfWylzCH
         xzMVNq43MGy+COxTAeHqRNxTG2xcOj+2u7qa7y7kXiHcej5j3uWcsUSwRNA0hO8gq+0+
         fN5xbAJrFyMtnmpiLZn4MQCZrbujQQo88poF0mDhPA96J+PodBzpUA0cuo4wUGKx6r1E
         qYGWaexV5Ohb+DWAK+4gO+1ilxLNm6cTtPUk8Z4NwyZIdoSipUz0KKdzrZ3HIPMvu5Rp
         3gNQ==
X-Gm-Message-State: AOAM532hWlEqQZS1CIO8HuP5l7YUebLCMLmf6rq8QSWeuppbhpGYiXvw
        ZMvcROTMVV0Uw+I6E+2ugqmP0sBa6KsHf810MUs=
X-Google-Smtp-Source: ABdhPJwSgwTECrL2qJy6gBd1V8IHxFn4UupJo7fWiDvJWS1ifGSPZYR63kl6danPfCmdx8EPuUrFXYHozuIR/xoYDSQ=
X-Received: by 2002:a17:90a:80c6:: with SMTP id k6mr2476928pjw.81.1598698830055;
 Sat, 29 Aug 2020 04:00:30 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:90a:1952:0:0:0:0 with HTTP; Sat, 29 Aug 2020 04:00:29
 -0700 (PDT)
In-Reply-To: <20200829103637.1730050-1-yili@winhong.com>
References: <20200829103637.1730050-1-yili@winhong.com>
From:   Yi Li <yilikernel@gmail.com>
Date:   Sat, 29 Aug 2020 19:00:29 +0800
Message-ID: <CAJfdMYCLNzWVKZMgmzU5oDg+6yhZ3JMaBv7_CmM7MCgY7A9iPQ@mail.gmail.com>
Subject: Re: [PATCH] bnx2x: correct a mistake when show error code
To:     Yi Li <yili@winhong.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net,
        GR-everest-linux-l2@marvell.com, skalluru@marvell.com,
        aelior@marvell.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is useless.
The original code just tell some error info. and don't  show errorcode

On 8/29/20, Yi Li <yili@winhong.com> wrote:
> use rc for error code.
>
> Signed-off-by: Yi Li <yili@winhong.com>
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
> index 1426c691c7c4..0346771396ce 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
> @@ -13562,9 +13560,8 @@ static int bnx2x_ext_phy_common_init(struct bnx2x
> *bp, u32 shmem_base_path[],
>  	}
>
>  	if (rc)
> -		netdev_err(bp->dev,  "Warning: PHY was not initialized,"
> -				      " Port %d\n",
> -			 0);
> +		netdev_err(bp->dev, "Warning: PHY was not initialized, Port %d\n",
> +			   rc);
>  	return rc;
>  }
>
> --
> 2.25.3
>
>
>
>
