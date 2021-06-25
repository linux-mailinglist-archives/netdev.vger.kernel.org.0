Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379073B41B7
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 12:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbhFYKf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 06:35:57 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:26518 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230379AbhFYKfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 06:35:51 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15PAC0Lx003048;
        Fri, 25 Jun 2021 10:33:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=7kXzU6VQY7lM9RFtj3Mn30bxf9x5MvbukVSQFWdLIZY=;
 b=shLe6ys8iFsFYHDOZvl26wehMyAZpyOcBMPgpa/Y9ApffGJJCBLvHj8/3wXmktB5glND
 ysiu+bscHge3edzw3lyRnjyM+9P51rLe23FPQn5oLzViS3jk+MiXIFBckxBdV7C+V2JF
 2EsXHayTySklTvB0+CGC+dZ92Y2WriziuC+hCJNqZ6t481Sr+/UuQCBJcVbgfw1xyrSC
 Qv5ufAYKO1ZK8bX7jruIKBgmm6SYEqENjwHLoP26Z7X3Jjv+uZClpO3n/aoE/5TPjvKT
 uDlnT40DTd5dWz0ckpeDS92XXF7/H/n2qoK5jLMx12Xl0iU07VHKG7pWpjbB+/skrHzs Ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39d2kxs0v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 10:33:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15PABQ2i094051;
        Fri, 25 Jun 2021 10:33:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 39dbb15rpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 10:33:18 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15PASHaK149866;
        Fri, 25 Jun 2021 10:33:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 39dbb15rng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 10:33:17 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.14.4) with ESMTP id 15PAXFOI031239;
        Fri, 25 Jun 2021 10:33:16 GMT
Received: from kadam (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Jun 2021 03:33:14 -0700
Date:   Fri, 25 Jun 2021 13:33:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Colin King <colin.king@canonical.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] netfilter: nf_tables: Fix dereference of null
 pointer flow
Message-ID: <20210625103304.GI2040@kadam>
References: <20210624195718.170796-1-colin.king@canonical.com>
 <20210625095901.GH2040@kadam>
 <20210625102021.GA32352@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625102021.GA32352@salvia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: agBZSEvUiaAafEXSUMxVl_YcRlBC2KJn
X-Proofpoint-ORIG-GUID: agBZSEvUiaAafEXSUMxVl_YcRlBC2KJn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 12:20:21PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Fri, Jun 25, 2021 at 12:59:01PM +0300, Dan Carpenter wrote:
> > Btw, why is there no clean up if nft_table_validate() fails?
> 
> See below.
> 
> > net/netfilter/nf_tables_api.c
> >   3432                                  list_add_tail_rcu(&rule->list, &old_rule->list);
> >   3433                          else
> >   3434                                  list_add_rcu(&rule->list, &chain->rules);
> >   3435                  }
> >   3436          }
> >   3437          kvfree(expr_info);
> >   3438          chain->use++;
> >   3439  
> >   3440          if (flow)
> >   3441                  nft_trans_flow_rule(trans) = flow;
> >   3442  
> >   3443          if (nft_net->validate_state == NFT_VALIDATE_DO)
> >   3444                  return nft_table_validate(net, table);
> >                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > The cleanup for this would be quite involved unfortunately...  Not
> > necessarily something to attempt without being able to test the code.
> 
> At this stage, the transaction has been already registered in the
> list, and the nf_tables_abort() path takes care of undoing what has
> been updated in the preparation phase.
> 

Ah...  Thanks.

regards,
dan carpenter

