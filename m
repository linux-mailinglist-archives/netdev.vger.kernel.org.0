Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E907435BCF
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 09:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhJUHig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 03:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbhJUHie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 03:38:34 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B453C06161C
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 00:36:18 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 5so1572306edw.7
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 00:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Pf4pZsMpTQMdqP+vz3QpjXdryMAVYVTZlG49NKi1EX0=;
        b=d+dJiSmUapMX+EH4PruHErHiTJ70YMQiTYtp5tg+KMTgbX2XkMY5vwIA5n3RyXXM4K
         Xu2ufwgHrGa/iuZS7+eBnGz22SwIprGgvx1uynPulnPkPFVT7YOy3U+4wCj+HP9M0o8P
         YE67MBQZdbEw1hkPdzinLyQCGIa5DGmgmcpVogvjmEwLDBNa25vVvgD4e5xdLvw67xA+
         RZGXNwfCNPsgpgX9/q/DzZM/QVu4nh+shk8AKBm6mc4e5KiES/6SW8xqmTB0c1pqpBMy
         r6ns20kl0qg+AdysbWoLmDg0uXovUVt4VXoDaM2gyHaeW/DzeZRCrKD7lOgHWJAuI+NQ
         zclA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Pf4pZsMpTQMdqP+vz3QpjXdryMAVYVTZlG49NKi1EX0=;
        b=ZqYbRbYX+NWMJpN7vC6i1SYIK6cdyvMaqFBNSQUZQFgn/lJR4rQ+bHDavzNPyZynJ1
         R8USf7RbtI0XbDUJDhP/YGiA1ppaEli2WagOuhm3x0+RTxrb8NN3ys5NoNAy5sUOvyQH
         /Cb76wPQWGau+YMOZfjIeYfJSlnuBcbFlDHubjBa9RaocmHSS5TohLdQkiGrzj0uJg0T
         kGfkc6vnbJ5Bm1/AkOr73Pk4Bxr+vIHei2pN7/kLBbWKjEsV4BM3TicIbeM06MFbsFlt
         37R+eRMPzlZsjFXSPsSQ4ZnEqTYGRLh16PvmyKvVzW5W6Hq/E6O2Ma1B7qPZtPka38A2
         o11A==
X-Gm-Message-State: AOAM530yfNTKmJwWOLp+a1XFUkRTc2dBQyj9lXAEvvBEz+Z2G1cHB4Xa
        6F14eAMqTSThOtjuVmuv+m4=
X-Google-Smtp-Source: ABdhPJzrqj4tpPQ81dlS8f3R1E9S3r9B+239QxXWr8H3y9KM02jmb1J0eGhJboleFMhcJt2ocSDTPA==
X-Received: by 2002:a50:d841:: with SMTP id v1mr5390524edj.221.1634801777161;
        Thu, 21 Oct 2021 00:36:17 -0700 (PDT)
Received: from localhost ([185.220.102.246])
        by smtp.gmail.com with ESMTPSA id w11sm2480295edl.87.2021.10.21.00.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 00:36:16 -0700 (PDT)
Date:   Thu, 21 Oct 2021 01:36:10 -0600
From:   =?utf-8?B?Ss61YW4=?= Sacren <sakiwit@gmail.com>
To:     Simon Horman <horms@kernel.org>
Cc:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: qed_dev: fix redundant check of rc and
 against -EINVAL
Message-ID: <YXEYamNlxa3CWR1V@mail.gmail.com>
References: <cover.1634621525.git.sakiwit@gmail.com>
 <b187bc8a2a12e20dd54bce71f7de0f8e7c45f249.1634621525.git.sakiwit@gmail.com>
 <20211020084713.GA3935@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211020084713.GA3935@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Horman <horms@kernel.org>
Date: Wed, 20 Oct 2021 10:47:17 +0200
>
> On Tue, Oct 19, 2021 at 12:26:42AM -0600, Jεan Sacren wrote:
> > From: Jean Sacren <sakiwit@gmail.com>
> > 
> > We should first check rc alone and then check it against -EINVAL to
> > avoid repeating the same operation multiple times.
> > 
> > Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> > ---
> >  drivers/net/ethernet/qlogic/qed/qed_dev.c | 35 +++++++++++++----------
> >  1 file changed, 20 insertions(+), 15 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
> > index 18f3bf7c4dfe..fe8bdb4523b5 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
> > @@ -3987,30 +3987,35 @@ static int qed_hw_get_resc(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
> >  				       QED_RESC_LOCK_RESC_ALLOC, false);
> >  
> >  	rc = qed_mcp_resc_lock(p_hwfn, p_ptt, &resc_lock_params);
> > -	if (rc && rc != -EINVAL) {
> > -		return rc;
> > -	} else if (rc == -EINVAL) {
> > +	if (rc) {
> > +		if (rc != -EINVAL)
> > +			return rc;
> > +
> >  		DP_INFO(p_hwfn,
> >  			"Skip the max values setting of the soft resources since the resource lock is not supported by the MFW\n");
> > -	} else if (!rc && !resc_lock_params.b_granted) {
> > +	}
> > +
> > +	if (!resc_lock_params.b_granted) {
> 
> Can it be the case where the condition above is met and !rc is false?
> If so your patch seems to have changed the logic of this function.

Mr. Horman,

I'm so much appreciative to you for the review.  I'm so sorry this patch
is wrong.  I redid the patch.  Could you please help me review it?

I'll add the following text in the changelog to curb the confusion I
incur.  What do you think?

We should also remove the check of !rc in this expression since it is
always true:

        (!rc && !resc_lock_params.b_granted)

[...]
> > -			rc = qed_mcp_resc_unlock(p_hwfn, p_ptt,
> > -						 &resc_unlock_params);
> 
> nit: it looks like the two lines above would now fit on one.

Absolutely.  I'll put these two lines together as one.

I'd be very much grateful if you could help me review both patches.
I'll respin the whole series and resubmit as v2 upon your review.

Thank you!

// diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
// index 18f3bf7c4dfe..44b0d4b42bc3 100644
// --- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
// +++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
// @@ -3987,29 +3987,33 @@ static int qed_hw_get_resc(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
//  				       QED_RESC_LOCK_RESC_ALLOC, false);
//  
//  	rc = qed_mcp_resc_lock(p_hwfn, p_ptt, &resc_lock_params);
// -	if (rc && rc != -EINVAL) {
// -		return rc;
// -	} else if (rc == -EINVAL) {
// -		DP_INFO(p_hwfn,
// -			"Skip the max values setting of the soft resources since the resource lock is not supported by the MFW\n");
// -	} else if (!rc && !resc_lock_params.b_granted) {
// -		DP_NOTICE(p_hwfn,
// -			  "Failed to acquire the resource lock for the resource allocation commands\n");
// -		return -EBUSY;
// +	if (rc) {
// +		if (rc == -EINVAL)
// +			DP_INFO(p_hwfn,
// +				"Skip the max values setting of the soft resources since the resource lock is not supported by the MFW\n");
// +		else
// +			return rc;
//  	} else {
// -		rc = qed_hw_set_soft_resc_size(p_hwfn, p_ptt);
// -		if (rc && rc != -EINVAL) {
// +		if (!resc_lock_params.b_granted) {
//  			DP_NOTICE(p_hwfn,
// -				  "Failed to set the max values of the soft resources\n");
// -			goto unlock_and_exit;
// -		} else if (rc == -EINVAL) {
// -			DP_INFO(p_hwfn,
// -				"Skip the max values setting of the soft resources since it is not supported by the MFW\n");
// -			rc = qed_mcp_resc_unlock(p_hwfn, p_ptt,
// -						 &resc_unlock_params);
// -			if (rc)
// +				  "Failed to acquire the resource lock for the resource allocation commands\n");
// +			return -EBUSY;
// +		}
// +
// +		rc = qed_hw_set_soft_resc_size(p_hwfn, p_ptt);
// +		if (rc) {
// +			if (rc == -EINVAL) {
//  				DP_INFO(p_hwfn,
// -					"Failed to release the resource lock for the resource allocation commands\n");
// +					"Skip the max values setting of the soft resources since it is not supported by the MFW\n");
// +				rc = qed_mcp_resc_unlock(p_hwfn, p_ptt, &resc_unlock_params);
// +				if (rc)
// +					DP_INFO(p_hwfn,
// +						"Failed to release the resource lock for the resource allocation commands\n");
// +			} else {
// +				DP_NOTICE(p_hwfn,
// +					  "Failed to set the max values of the soft resources\n");
// +				goto unlock_and_exit;
// +			}
//  		}
//  	}
//  
