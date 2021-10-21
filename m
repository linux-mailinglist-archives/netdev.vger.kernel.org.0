Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB2D435BCE
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 09:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhJUHiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 03:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbhJUHiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 03:38:13 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7757EC06161C
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 00:35:57 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id d3so1902698edp.3
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 00:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=nPI0c4g9ffXNuRxEJuhHjGCKT6B0B7ijuzKHV/iYrqM=;
        b=jbLcvcUe00n789PG6kAAFIz9H5ASQnDANXpLQAy5ad6oQ1on99DQBGsffB9rj5DWgr
         7ht3dr9+Xg2qj4FOTIrn55m2y9lOO4UjbDt/qyZE5BxCMPAcf98QuOLCMVfvXlfJm0AY
         d+W8qC/rE4Py+I6cyubyQM23/abwd1kvcEjgFzj2wB7jm0cJX54H+8Ub19BdrNmjEE0J
         EdzIIvwxb4vgPXBa5aoBlVRXqAx2KaDbpnQXZzwy0Eun2vyzhoWHk1CLyME5ZvS6fgcx
         444mNdn4Rgsg6FGqwFXs6a/AFugTCggUiVWdLCaufYWSIWh/CSRuZLOYTQaIlLKR/bQb
         +s0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=nPI0c4g9ffXNuRxEJuhHjGCKT6B0B7ijuzKHV/iYrqM=;
        b=PWsGfO5sGZypW5IS0WCtrDEeQ1PfHd8oZVrv/LSDQH4v69G8GMvOMHmhBXZFo2cweL
         0eJEzCp8ty4o9B7Q5IQhHvDy0fhhF2Gkomg2LHNBOIz454HY5Qx2y8X0LZ3DSXGF+CSj
         Wu4PJVDoxiFTaV8CfF+kNF2lJZr+nFlKC3fL4ncwg1ZaI5nXsQJxesbJhALi6/66D4ny
         Nx9LcSxRPwnxOYKZnZujkApFFXY9ambHA9m3JEaisq7n2ZNrwSowz6SRLRswxsCQ1FsW
         C6zwAa/JJHdrdPUBjfdZeHCuwELtqhbIv3PZfKO6RekhmsyJbLVvwXxXjWX+2f45GuD0
         /n/Q==
X-Gm-Message-State: AOAM530O3aSya0uZH6Ba4+PAILOJYhF+ukjXtL9Bp7Z7r/ijxMaGvjIw
        tdJtAOtKisOGubtn1BwF/vU=
X-Google-Smtp-Source: ABdhPJwnXyAOXBFepa/ZumkURgwgv+cW/Q2A7OODO/tvjqiZVrE1Okh9NDDHzEmc+DutliDEuAvRfg==
X-Received: by 2002:a05:6402:3585:: with SMTP id y5mr5416930edc.323.1634801756015;
        Thu, 21 Oct 2021 00:35:56 -0700 (PDT)
Received: from localhost ([185.220.102.246])
        by smtp.gmail.com with ESMTPSA id rk9sm2071390ejb.31.2021.10.21.00.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 00:35:55 -0700 (PDT)
Date:   Thu, 21 Oct 2021 01:35:48 -0600
From:   =?utf-8?B?Ss61YW4=?= Sacren <sakiwit@gmail.com>
To:     Simon Horman <horms@kernel.org>
Cc:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: qed_ptp: fix redundant check of rc and
 against -EINVAL
Message-ID: <YXEYVC4gBC4JC7t9@mail.gmail.com>
References: <cover.1634621525.git.sakiwit@gmail.com>
 <492df79e1ae204ec455973e22002ca2c62c41d1e.1634621525.git.sakiwit@gmail.com>
 <20211020084835.GB3935@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211020084835.GB3935@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Horman <horms@kernel.org>
Date: Wed, 20 Oct 2021 10:48:35 +0200
>
> On Tue, Oct 19, 2021 at 12:26:41AM -0600, Jεan Sacren wrote:
> > From: Jean Sacren <sakiwit@gmail.com>
> > 
> > We should first check rc alone and then check it against -EINVAL to
> > avoid repeating the same operation.
> > 
> > With this change, we could also use constant 0 for return.
> > 
> > Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> > ---
> >  drivers/net/ethernet/qlogic/qed/qed_ptp.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_ptp.c b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
> > index 2c62d732e5c2..c927ff409109 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_ptp.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
> > @@ -52,9 +52,9 @@ static int qed_ptp_res_lock(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
> >  	qed_mcp_resc_lock_default_init(&params, NULL, resource, true);
> >  
> >  	rc = qed_mcp_resc_lock(p_hwfn, p_ptt, &params);
> > -	if (rc && rc != -EINVAL) {
> > -		return rc;
> > -	} else if (rc == -EINVAL) {
> > +	if (rc) {
> > +		if (rc != -EINVAL)
> > +			return rc;
> >  		/* MFW doesn't support resource locking, first PF on the port
> >  		 * has lock ownership.
> >  		 */
> > @@ -63,12 +63,14 @@ static int qed_ptp_res_lock(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
> >  
> >  		DP_INFO(p_hwfn, "PF doesn't have lock ownership\n");
> >  		return -EBUSY;
> > -	} else if (!rc && !params.b_granted) {
> > +	}
> > +
> > +	if (!params.b_granted) {
> 
> Can it be the case where the condition above is met and !rc is false?
> If so your patch seems to have changed the logic of this function.

Mr. Horman,

I'm so much appreciative to you for the review.  I'm so sorry this patch
is wrong.  I redid the patch.  Could you please help me review it?

I did verify at the point where we check (!params.b_granted), !rc is
always true.  Earlier when we check rc alone, it has to be 0 to let it
reach the point where we check (!params.b_granted).  If it is not 0, it
will hit one of the returns in the branch.

I'll add the following text in the changelog to curb the confusion I
incur.  What do you think?

We should also remove the check of !rc in (!rc && !params.b_granted)
since it is always true.

// diff --git a/drivers/net/ethernet/qlogic/qed/qed_ptp.c b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
// index 2c62d732e5c2..4e1b741ebb46 100644
// --- a/drivers/net/ethernet/qlogic/qed/qed_ptp.c
// +++ b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
// @@ -52,23 +52,27 @@ static int qed_ptp_res_lock(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
//  	qed_mcp_resc_lock_default_init(&params, NULL, resource, true);
//  
//  	rc = qed_mcp_resc_lock(p_hwfn, p_ptt, &params);
// -	if (rc && rc != -EINVAL) {
// +	if (rc) {
// +		if (rc == -EINVAL) {
// +			/* MFW doesn't support resource locking, first PF on the port
// +			 * has lock ownership.
// +			 */
// +			if (p_hwfn->abs_pf_id < p_hwfn->cdev->num_ports_in_engine)
// +				return 0;
// +
// +			DP_INFO(p_hwfn, "PF doesn't have lock ownership\n");
// +			return -EBUSY;
// +		}
// +
//  		return rc;
// -	} else if (rc == -EINVAL) {
// -		/* MFW doesn't support resource locking, first PF on the port
// -		 * has lock ownership.
// -		 */
// -		if (p_hwfn->abs_pf_id < p_hwfn->cdev->num_ports_in_engine)
// -			return 0;
// +	}
//  
// -		DP_INFO(p_hwfn, "PF doesn't have lock ownership\n");
// -		return -EBUSY;
// -	} else if (!rc && !params.b_granted) {
// +	if (!params.b_granted) {
//  		DP_INFO(p_hwfn, "Failed to acquire ptp resource lock\n");
//  		return -EBUSY;
//  	}
//  
// -	return rc;
// +	return 0;
//  }
//  
//  static int qed_ptp_res_unlock(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
