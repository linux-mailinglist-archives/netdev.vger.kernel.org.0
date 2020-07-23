Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4380A22B295
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 17:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbgGWPab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 11:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgGWPaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 11:30:30 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4A1C0619DC;
        Thu, 23 Jul 2020 08:30:29 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id e13so5706830qkg.5;
        Thu, 23 Jul 2020 08:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4M2X8c1o1GLGue/gT+Yu3vbhPjzYcFb5GdcwmFKqkWY=;
        b=eXAJZ9XD5BqetmyLyB5TZz7wGQpBNIlz+C1NMxXQWh3hmhzYlYzU8aFhAnM4isDJjo
         IAqxstbtahBVLsriVMNzBUD7iApZ4zg8mmltzroHrgfdqolM4v07afdVDVmFsEPInZBO
         hSXLz1yYAtQzKThbpWYZYThayUziLpWJspR7y5zXrWUtM7S8LLIQEjnoEieJysRISUlr
         vMvsrWA+lB5suoZO39AYNiwSNRSAChRNLhlCTZGyafU0OIXE7wSd9roD0BE6+q3cK6zS
         gmLoDWoD/yPIlLU7cTuv6WiohyB51M+vXE4OyCqsqs0FWIuLnFfDymgooPM/PcmD17XJ
         H50A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4M2X8c1o1GLGue/gT+Yu3vbhPjzYcFb5GdcwmFKqkWY=;
        b=jtaJ+MfOaubfO5g9m5pWGu4070/Quj3eyx/aAu/Ou4E3OWVZ/QRI6Xv5lpDlYHxX9D
         8hRIbFcWrrVn/hYAqMt5mQBs1S4w9cxZmWcoLwJZDLmO5ANJE+xFKW2TTIcJjsZ89n/u
         nl7QrLpBRy2T9NugpOBnz+U7AR7kJoU+4tNSJ9HdPu4nXOS11/+2aQH/x2BYYDgzAqLS
         lzFrPN6wOyewzyqpMfcRmgG757Cc4LoP1yTXaOXRvGnfWH7H5/kwIHYpDvCZxEC2Yn1T
         qnvR/NLumhzGmrQZWLicL9yxKj/s3fpT4e7n68jJUIqe1Imeygg37ICW9FJQs8TnoNfd
         /QFw==
X-Gm-Message-State: AOAM533QryD80IueF8YQbiJgDh5KDo4SLf8mfieVaMhs2DNC03NoWAdP
        OQZqldvYOvWnDKPtsI8wLCyi0RJD
X-Google-Smtp-Source: ABdhPJwR9Hh6hYOYz3Hz+plQtfbh1jjySQlltnsfxlkdKygETBvNDCJ0V/hIO3Ge7DxIOv10r7B7Sg==
X-Received: by 2002:a37:5b46:: with SMTP id p67mr5813992qkb.346.1595518228834;
        Thu, 23 Jul 2020 08:30:28 -0700 (PDT)
Received: from localhost.localdomain ([138.204.24.96])
        by smtp.gmail.com with ESMTPSA id n81sm2909642qke.11.2020.07.23.08.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 08:30:27 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 334DFC18B3; Thu, 23 Jul 2020 12:30:25 -0300 (-03)
Date:   Thu, 23 Jul 2020 12:30:25 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        linux-sctp@vger.kernel.org
Subject: Re: [PATCH net-next] sctp: fix slab-out-of-bounds in
 SCTP_DELAYED_SACK processing
Message-ID: <20200723153025.GF3307@localhost.localdomain>
References: <5955bc857c93d4bb64731ef7a9e90cb0094a8989.1595450200.git.marcelo.leitner@gmail.com>
 <20200722204231.GA3398@localhost.localdomain>
 <20200723092238.GA21143@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723092238.GA21143@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 11:22:38AM +0200, Christoph Hellwig wrote:
> On Wed, Jul 22, 2020 at 05:42:31PM -0300, Marcelo Ricardo Leitner wrote:
> > Cc'ing linux-sctp@vger.kernel.org.
> 
> What do you think of this version, which I think is a little cleaner?

It splits up the argument parsing from the actual handling, ok. Looks
good. Just one point:

> +static int sctp_setsockopt_delayed_ack(struct sock *sk,
> +				       struct sctp_sack_info *params,
> +				       unsigned int optlen)
> +{
> +	if (optlen == sizeof(struct sctp_assoc_value)) {
> +		struct sctp_sack_info p;
> +
> +		pr_warn_ratelimited(DEPRECATED
> +				    "%s (pid %d) "
> +				    "Use of struct sctp_assoc_value in delayed_ack socket option.\n"
> +				    "Use struct sctp_sack_info instead\n",
> +				    current->comm, task_pid_nr(current));
> +
> +		memcpy(&p, params, sizeof(struct sctp_assoc_value));
> +		p.sack_freq = p.sack_delay ? 0 : 1;

Please add a comment saying that sctp_sack_info.sack_delay maps
exactly to sctp_assoc_value.assoc_value, so that's why we can do
memcpy and read assoc_value as sack_delay. I think it will help us not
trip on this again in the future.

> +		return __sctp_setsockopt_delayed_ack(sk, &p);
> +	}
> +
> +	if (optlen != sizeof(struct sctp_sack_info))
> +		return -EINVAL;
> +	if (params->sack_delay == 0 && params->sack_freq == 0)
> +		return 0;
> +	return __sctp_setsockopt_delayed_ack(sk, params);
> +}
> +
>  /* 7.1.3 Initialization Parameters (SCTP_INITMSG)
>   *
>   * Applications can specify protocol parameters for the default association
