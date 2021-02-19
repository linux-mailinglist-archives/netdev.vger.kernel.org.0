Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7276F31FED9
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 19:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhBSSg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 13:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhBSSgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 13:36:55 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E20C061574;
        Fri, 19 Feb 2021 10:36:15 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id v22so11448699edx.13;
        Fri, 19 Feb 2021 10:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GFIKisuNYIZcd2THlE/+uNrOu3IJ01P8tkbxwPNZpwc=;
        b=hlwAhiya/QLH4uEfZx9AXp/fj8kKoZbDGwSFPLi7dZc7WoT8PwSPUiv26G5JnLkFfn
         CJr751m3SmVXRpFxFNwa/tK8XxHPRGV1Yjlcdv4eFpWRv529CnUG2syKJkheQg/RLfk1
         ByGWLmF2XW1vkkXJwfqy8Ib+8+Q9C9K2wDlQ0A28jy1xsgzCfqa/J+lE1AAwHqGZS+Nt
         JT8Z1GJgk/LshASt2wHlPco/Fh0WhV6h6cOlsG3fKutW5jAFu52RYreNHMLMNU3S3ckY
         sgMpJHrIG08AlO3Y6TkMCHJCkz7Bc9uSlPXG33sJ5lpcOC3uK1A2PIsnLRPGQlc4Jd8Q
         EKug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GFIKisuNYIZcd2THlE/+uNrOu3IJ01P8tkbxwPNZpwc=;
        b=MNOlNfjsCb3i2Ff5LDpKEulN+9mHCBpePOvr3BUx58DOv7oliCb7NqSzbVVziNLMtq
         69WZnmAUAGOP+sRNjaItLL7Xrp8VRdKGdRSRZlyh7D67O0G3M3cSz/+fCbt+3g3mEC4U
         6bu804lILejmUl+L2bRYESCIaPwtUxO6pNLVLyPR32X+BEeyQuCRTq+uOVR5DTCkOoZ8
         tlnrE94Dn5iST0vU6+FM+bpBnj+pO8QwU9Lb5IRWyZSRsOv5NdCcauRdHid2mkjlm7EI
         AEysSZs7UZFWSM1kG64kFfeEZs28evUHvPN88Doir3XmhV/mkgAk0o/+1MAFTFvHsTdV
         O12g==
X-Gm-Message-State: AOAM530gqHmftqABdsQrUjhvmcodmX4P05n/SY1WaUg+bQx5KbFR/gS7
        laAhlsas58rpCcUWIlga9IC/OQqbxfY7sx/qFYM=
X-Google-Smtp-Source: ABdhPJxHDZf4WqfSFsWqPMGCnkXrO9XmU2eTsYqR/1Bs7VZ+j8g7OiIzt74ubsUQabShs5utmdu7L9+3cjBgGQmATEQ=
X-Received: by 2002:a05:6402:293:: with SMTP id l19mr10715421edv.4.1613759773834;
 Fri, 19 Feb 2021 10:36:13 -0800 (PST)
MIME-Version: 1.0
References: <YC+LUJ0YhF1Yutaw@mwanda>
In-Reply-To: <YC+LUJ0YhF1Yutaw@mwanda>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Sat, 20 Feb 2021 00:06:01 +0530
Message-ID: <CA+sq2CdeKDq6=jDk=mZeSaOVa9N25WvQU8V-k61bYp6ZyN8q-w@mail.gmail.com>
Subject: Re: [PATCH net] octeontx2-af: Fix an off by one in rvu_dbg_qsize_write()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Christina Jacob <cjacob@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Prakash Brahmajyosyula <bprakash@marvell.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 19, 2021 at 3:31 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> This code does not allocate enough memory for the NUL terminator so it
> ends up putting it one character beyond the end of the buffer.
>
> Fixes: 8756828a8148 ("octeontx2-af: Add NPA aura and pool contexts to debugfs")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
> index 48a84c65804c..d5f3ad660588 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
> @@ -385,7 +385,7 @@ static ssize_t rvu_dbg_qsize_write(struct file *filp,
>         u16 pcifunc;
>         int ret, lf;
>
> -       cmd_buf = memdup_user(buffer, count);
> +       cmd_buf = memdup_user(buffer, count + 1);
>         if (IS_ERR(cmd_buf))
>                 return -ENOMEM;
>
> --
> 2.30.0
>

Thanks for the fix.
