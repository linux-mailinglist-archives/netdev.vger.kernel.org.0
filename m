Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3546696E3
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 13:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbjAMMX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 07:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241343AbjAMMXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 07:23:31 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F1678EBA;
        Fri, 13 Jan 2023 04:19:44 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id f34so32854241lfv.10;
        Fri, 13 Jan 2023 04:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lTyCLU2tnSwpMO6ISe/l+z0ifaohdA0x9bYd5cr8na4=;
        b=dEZj1oJnyFv3WcL9hNTNJGZTia8Em/TAD/oYNjESsqaD738KGcaShpQH1VtT504Z1E
         xEf/ai65XZ/c63fD8IMzpXHaJWd15qO5piwWX1c4YsC8JM67gMtP/rdq2y6fmsKnB4K+
         cl2baYKRvH0lH3nMEXOXnMzVJRMXW2jPhA11YHUI/BYYx7M3TfBcSDkWzFe2i+gL/XMZ
         oWHn+FK1WH269gCkqG8MRcEUP+vCB/UW22xdpBt3j23sdSfvH3rrl5dpvuy0gsjAaw0I
         ZNHMbrtzqJMTfg+lpODFpzlVPH4u/0MsmviDpVaFA8aPXNr+dZd8Nm5AJphT8if4VlEa
         21Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lTyCLU2tnSwpMO6ISe/l+z0ifaohdA0x9bYd5cr8na4=;
        b=REgdnD4I3y6thpOuxEoUBncSSybSpsn2g/+XoJshfUEwhALTRT0DmbHLANFQSFvNku
         UnMn6eLnssPnhW4o0pXuYCBXa94tQGbt4LjOEFWXjhITEbwqi9W5/mjNesnr10HXshoU
         a1bCDEoy74bxPXLhXNJs6Zo81gn+wp1RHTtMcnqGqxQ/81gr6e9/Xrmxew3F6NFW/8pA
         wcqcYx4pM4ZrA3ARw3vcUBQJVGXXW1VbYoSrCrz7AXvrvK206lyQyqEsKwrvbYYT82zq
         UySXnFtHW5da+V10g1VFYqOumxHg2E3/B9BqyrEndDZnu0IZiRqkO38h/gnulw1AhH4m
         mjOg==
X-Gm-Message-State: AFqh2kob2zFWFTc4sNf/tg0Q8AAfKDmn/YUzv+xR7msL3Uc+NCr2AE6n
        YOqmabf4FzFAXrSAyTA/PwM=
X-Google-Smtp-Source: AMrXdXvktgndg6nbnlrClTFC5aIM2TF19qweZZIBGTK+LbtfrLNasTul+gnDNje06ffwawBdOd8r/A==
X-Received: by 2002:a05:6512:2a90:b0:4ac:b7bf:697a with SMTP id dt16-20020a0565122a9000b004acb7bf697amr4868907lfb.4.1673612382685;
        Fri, 13 Jan 2023 04:19:42 -0800 (PST)
Received: from localhost ([185.244.30.32])
        by smtp.gmail.com with ESMTPSA id k3-20020ac257c3000000b004a764f9d653sm3814621lfo.242.2023.01.13.04.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 04:19:42 -0800 (PST)
Date:   Fri, 13 Jan 2023 14:19:38 +0200
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, sbhatta@marvell.com,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: Re: [net-next PATCH 1/5] sch_htb: Allow HTB priority parameter in
 offload mode
Message-ID: <Y8FMWs3XKuI+t0zW@mail.gmail.com>
References: <20230112173120.23312-1-hkelam@marvell.com>
 <20230112173120.23312-2-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112173120.23312-2-hkelam@marvell.com>
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 11:01:16PM +0530, Hariprasad Kelam wrote:
> From: Naveen Mamindlapalli <naveenm@marvell.com>
> 
> The current implementation of HTB offload returns the EINVAL error
> for unsupported parameters like prio and quantum. This patch removes
> the error returning checks for 'prio' parameter and populates its
> value to tc_htb_qopt_offload structure such that driver can use the
> same.
> 
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> ---
>  include/net/pkt_cls.h | 1 +
>  net/sched/sch_htb.c   | 7 +++----
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index 4cabb32a2ad9..02afb1baf39d 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -864,6 +864,7 @@ struct tc_htb_qopt_offload {
>  	u16 qid;
>  	u64 rate;
>  	u64 ceil;
> +	u8 prio;
>  };
>  
>  #define TC_HTB_CLASSID_ROOT U32_MAX
> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
> index 2238edece1a4..f2d034cdd7bd 100644
> --- a/net/sched/sch_htb.c
> +++ b/net/sched/sch_htb.c
> @@ -1806,10 +1806,6 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>  			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the quantum parameter");
>  			goto failure;
>  		}
> -		if (hopt->prio) {
> -			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the prio parameter");
> -			goto failure;
> -		}

The check should go to mlx5e then.

>  	}
>  
>  	/* Keeping backward compatible with rate_table based iproute2 tc */
> @@ -1905,6 +1901,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>  					TC_HTB_CLASSID_ROOT,
>  				.rate = max_t(u64, hopt->rate.rate, rate64),
>  				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
> +				.prio = hopt->prio,
>  				.extack = extack,
>  			};
>  			err = htb_offload(dev, &offload_opt);
> @@ -1925,6 +1922,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>  					TC_H_MIN(parent->common.classid),
>  				.rate = max_t(u64, hopt->rate.rate, rate64),
>  				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
> +				.prio = hopt->prio,
>  				.extack = extack,
>  			};
>  			err = htb_offload(dev, &offload_opt);
> @@ -2010,6 +2008,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>  				.classid = cl->common.classid,
>  				.rate = max_t(u64, hopt->rate.rate, rate64),
>  				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
> +				.prio = hopt->prio,
>  				.extack = extack,
>  			};
>  			err = htb_offload(dev, &offload_opt);
> -- 
> 2.17.1
> 
