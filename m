Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6E01C8705
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 12:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgEGKig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 06:38:36 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:43222 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725834AbgEGKig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 06:38:36 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 430066005C;
        Thu,  7 May 2020 10:38:35 +0000 (UTC)
Received: from us4-mdac16-46.ut7.mdlocal (unknown [10.7.66.13])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 476368009B;
        Thu,  7 May 2020 10:38:35 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.38])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BEBC028004D;
        Thu,  7 May 2020 10:38:34 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 28C9780005C;
        Thu,  7 May 2020 10:38:34 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 7 May 2020
 11:38:27 +0100
Subject: Re: [PATCH net,v4] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <jiri@resnulli.us>, <kuba@kernel.org>
References: <20200506183450.4125-1-pablo@netfilter.org>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <828ef810-9768-5b5c-7847-0edeb666af9b@solarflare.com>
Date:   Thu, 7 May 2020 11:38:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200506183450.4125-1-pablo@netfilter.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25404.003
X-TM-AS-Result: No-1.610000-8.000000-10
X-TMASE-MatchedRID: VPleTT1nwdS8rRvefcjeTR4ejJMDGBzF+D+zbdY8EilWpXKURBxd8xyZ
        V3OZbzzYT9nGAb6VEbWgY7jYWXGMNRUlZNGjIc0r/ccgt/EtX/3Fi3oiVvGfqQQsw9A3PIlLWod
        yjJN48mpGRGqJpovaqklW9ME/2Tk3mMdpq8xmbdIGLRKL2NexjQILzOoe9wbaZa+5Qf2DSM6jxY
        yRBa/qJQPTK4qtAgwIIC0OoeD/hCbQLWxBF9DMQcRB0bsfrpPIreCTu6Ejg5j56PhsPTTX6HRyc
        BW2Pk2XN9t9WW1V7Rs0Y/zwWr6luxweyc3jZsvsotCk7EnJZ1VF4ZmWWLAmAotWeLWxPWpCNrSa
        4CBS563UNewp4E2/TgSpmVYGQlZ3sxk1kV1Ja8cbbCVMcs1jUlqAtPM/2FFilExlQIQeRG0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-1.610000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25404.003
X-MDID: 1588847915-qJNtCM4SD_Uh
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/05/2020 19:34, Pablo Neira Ayuso wrote> -	} else if (act->hw_stats != FLOW_ACTION_HW_STATS_DISABLED) {
> +	} else if (act->hw_stats != FLOW_ACTION_HW_STATS_DISABLED &&
> +		   act->hw_stats != FLOW_ACTION_HW_STATS_DONT_CARE) {
>  		NL_SET_ERR_MSG_MOD(extack, "Unsupported action HW stats type");
>  		return -EOPNOTSUPP;
>  	}
FWIW my whole reason for suggesting DONT_CARE==0 in the first place
 was so that drivers could just use it as a boolean, e.g.
    if (act->hw_stats && !(act->hw_stats & FLOW_ACTION_HW_STATS_BLAH))
        error("driver only supports BLAH stats");
If you're not even doing that then the case for DONT_CARE == ~0 is
 even stronger.
Sorry I wasn't quick enough on the draw to say this before v4 was
 applied (I was waiting for an answer on the v2 thread; posting a
 Nack on v3 felt like it might come across as needlessly combative).

-ed
