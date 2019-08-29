Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F47A222B
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 19:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbfH2RZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 13:25:13 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33954 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727344AbfH2RZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 13:25:12 -0400
Received: by mail-pf1-f195.google.com with SMTP id b24so2540125pfp.1;
        Thu, 29 Aug 2019 10:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9GuN3MgFC46kDB7x4VlkI6LkxeFzQtYyvkTJ6qGJU5s=;
        b=bR8rtfcJAzcs66myVxnXNqz5PvXLdznyccocG6kepCtUDV74pdYC/KC1XA96ZKMuvo
         pImi2IyTf3vMfXLmCqPgZb0L1foivbxkXTaMyIL9E76A3imZx/D8Oo2ckxbEGv/fHamd
         g4zobDzE37wiB0poiMCRV+fe4pcfYCRIBBL7Li0i/Ix9P1aYVCMMcEm1cTMwNipEDDE7
         qPLs8NgSL09es5LFR7gq+fRL2MFf9+eYlSsf++E8b+tlW3gajV5kfvS14Swbns6K4WAX
         9FWwq1RlAfnycYdHMPyrbfm+SyISkjVN1btdrKXy41eT++l18pasheoZ3sXhT0Dg+alT
         Rf9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9GuN3MgFC46kDB7x4VlkI6LkxeFzQtYyvkTJ6qGJU5s=;
        b=M4zbykPCjnyAflFj70LpHCyIUZh+4LtADXQfxMiudz8EAOLqidfdxtex/cQPGVyQmP
         01AfaEcOWP685bo46tFfo1/Zb8iqC2kRk93xiiiTLEKcQzMCp26yt8kyjdjMg4KiQpxq
         YaQ73G02ni2D/ytOYWhB0xkymNiGdxWyUX/Kj0rbdv3X668iroNWXsuJ2TpMbhUpKLX/
         fUm2K8Z1Y9Bbtbce7G5fSBNuUkL7J5vhFfdnGMyrYROwCX09l04lPPLe+r22ZCYkdTM6
         wAIbujUcB9B8/GAv8rijQpyjnPSvkKJGzGo49nSFfWUbpETPVFwtijiIrG4VXwQqiljV
         8wNA==
X-Gm-Message-State: APjAAAWvcmQWow1tb34MbiM4eqZ5VK28za6t2Db0SfLz9tmmKxVSYUfY
        AQHbdjLYwWBLhCwpFCmEG7I/eyeL
X-Google-Smtp-Source: APXvYqytIuaJjAcpCV6XJWyP+tjsFwGztMkxKOTfF52FRtPJufK7QAOEpeimbPLe1ZKDcL65liq+YQ==
X-Received: by 2002:a62:764f:: with SMTP id r76mr12610577pfc.149.1567099511944;
        Thu, 29 Aug 2019 10:25:11 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id a17sm3770384pfc.26.2019.08.29.10.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 10:25:11 -0700 (PDT)
Date:   Thu, 29 Aug 2019 10:25:09 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] PTP: add support for one-shot output
Message-ID: <20190829172509.GB2166@localhost>
References: <20190829095825.2108-1-felipe.balbi@linux.intel.com>
 <20190829095825.2108-2-felipe.balbi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829095825.2108-2-felipe.balbi@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 12:58:25PM +0300, Felipe Balbi wrote:
> diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> index 98ec1395544e..a407e5f76e2d 100644
> --- a/drivers/ptp/ptp_chardev.c
> +++ b/drivers/ptp/ptp_chardev.c
> @@ -177,9 +177,8 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  			err = -EFAULT;
>  			break;
>  		}
> -		if ((req.perout.flags || req.perout.rsv[0] || req.perout.rsv[1]
> -				|| req.perout.rsv[2] || req.perout.rsv[3])
> -			&& cmd == PTP_PEROUT_REQUEST2) {
> +		if ((req.perout.rsv[0] || req.perout.rsv[1] || req.perout.rsv[2]
> +			|| req.perout.rsv[3]) && cmd == PTP_PEROUT_REQUEST2) {

Please check that the reserved bits of req.perout.flags, namely
~PTP_PEROUT_ONE_SHOT, are clear.

>  			err = -EINVAL;
>  			break;
>  		} else if (cmd == PTP_PEROUT_REQUEST) {
> diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
> index 039cd62ec706..95840e5f5c53 100644
> --- a/include/uapi/linux/ptp_clock.h
> +++ b/include/uapi/linux/ptp_clock.h
> @@ -67,7 +67,9 @@ struct ptp_perout_request {
>  	struct ptp_clock_time start;  /* Absolute start time. */
>  	struct ptp_clock_time period; /* Desired period, zero means disable. */
>  	unsigned int index;           /* Which channel to configure. */
> -	unsigned int flags;           /* Reserved for future use. */
> +
> +#define PTP_PEROUT_ONE_SHOT BIT(0)
> +	unsigned int flags;

@davem  Any CodingStyle policy on #define within a struct?  (Some
maintainers won't allow it.)

>  	unsigned int rsv[4];          /* Reserved for future use. */
>  };
>  
> -- 
> 2.23.0
> 

Thanks,
Richard
