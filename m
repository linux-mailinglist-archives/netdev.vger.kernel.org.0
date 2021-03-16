Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8AF33CC28
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 04:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbhCPDiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 23:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhCPDh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 23:37:56 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9153CC06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 20:37:56 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso596004pji.3
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 20:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=D0BAFysH7qL4LFoBg75GBctRM5jSEuwatot3WxQhxec=;
        b=HcWXZvS7r20fk9uy6+Tp7Sj9tGQ3uBbzqPP9Y1bxIJozWtScnQryXzDZ46MXHn27Vm
         ce/m9xmU2wfGztiowmH0hWP0E1fUV3WQnMX9FM0ySoC6tXOCkOXcb1849eHKdPyJZkGH
         iZCMES+ByVxau6hxYUK60VzJi0AXWV3PY9sEv4M4fbxDeaDDvesRyYwvancIoZyFV0oN
         SLemja+/3zlImtr7878oDHJ3FqBxpO3cSZWh3VWuzo0PCsIiCsrXDpb1KNVSlXvMkZo3
         B1fVCq+x7nmE/CFRA0XKMTVbPiPYUNEQsArrIF8hymhtNGaPz5KXfsCkoZGn39kjTU7N
         fJDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=D0BAFysH7qL4LFoBg75GBctRM5jSEuwatot3WxQhxec=;
        b=Ud3Fjsh3F05vSxvHASOafCDXJ5UPOYwbgWLmsrktzKfu699vYp+wtzkwC799eQNQ4m
         gbCd1uWrd9J6VHqEHy+O1JrkHskrqMZ9dAYLBUmkYFSn2Mdm1zL+DgouIbcvmcAcdirt
         Hg0wYBRVFO+mXLFLZodC76NSqAmwMjXDeoWPdYfEtSoCjgU1Tv4surNo51mnTSAnPQHA
         dNEp/o7IywNhEIG+J9OXD3Exci+AGmpYQO71Usald9yGiEonM01IOSqPws7A8MdEL1kX
         qsksOPL1JXzTIoEYy5yhiOKeTnsESOSYn7jFDuHkqPEsNHzSv3a6qNtE+Ot9vuAWsqri
         PwzQ==
X-Gm-Message-State: AOAM530HgNld6jwBnUL1yKxxGeyKyieoEB/uNUTbb0qElhisXJVa33HC
        jhTRyBFppdaFcr9KYkYBaYVl
X-Google-Smtp-Source: ABdhPJyvRDPd5npK4k/hb/oqXewaWLQEt4ZzgK65SexKt4oGbDqiew6RjYf9e77ckiFpgkhpqywGQw==
X-Received: by 2002:a17:90a:6be4:: with SMTP id w91mr2716772pjj.68.1615865875875;
        Mon, 15 Mar 2021 20:37:55 -0700 (PDT)
Received: from work ([103.66.79.72])
        by smtp.gmail.com with ESMTPSA id x190sm14525096pfx.60.2021.03.15.20.37.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Mar 2021 20:37:55 -0700 (PDT)
Date:   Tue, 16 Mar 2021 09:07:50 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: ipa: fix a duplicated tlv_type value
Message-ID: <20210316033750.GC29414@work>
References: <20210315152112.1907968-1-elder@linaro.org>
 <20210315152112.1907968-2-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315152112.1907968-2-elder@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 10:21:10AM -0500, Alex Elder wrote:
> In the ipa_indication_register_req_ei[] encoding array, the tlv_type
> associated with the ipa_mhi_ready_ind field is wrong.  It duplicates
> the value used for the data_usage_quota_reached field (0x11) and
> should use value 0x12 instead.  Fix this bug.
> 
> Reported-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Signed-off-by: Alex Elder <elder@linaro.org>

Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

> ---
>  drivers/net/ipa/ipa_qmi_msg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_qmi_msg.c b/drivers/net/ipa/ipa_qmi_msg.c
> index 73413371e3d3e..e00f829a783f6 100644
> --- a/drivers/net/ipa/ipa_qmi_msg.c
> +++ b/drivers/net/ipa/ipa_qmi_msg.c
> @@ -56,7 +56,7 @@ struct qmi_elem_info ipa_indication_register_req_ei[] = {
>  		.elem_size	=
>  			sizeof_field(struct ipa_indication_register_req,
>  				     ipa_mhi_ready_ind_valid),
> -		.tlv_type	= 0x11,
> +		.tlv_type	= 0x12,
>  		.offset		= offsetof(struct ipa_indication_register_req,
>  					   ipa_mhi_ready_ind_valid),
>  	},
> @@ -66,7 +66,7 @@ struct qmi_elem_info ipa_indication_register_req_ei[] = {
>  		.elem_size	=
>  			sizeof_field(struct ipa_indication_register_req,
>  				     ipa_mhi_ready_ind),
> -		.tlv_type	= 0x11,
> +		.tlv_type	= 0x12,
>  		.offset		= offsetof(struct ipa_indication_register_req,
>  					   ipa_mhi_ready_ind),
>  	},
> -- 
> 2.27.0
> 
