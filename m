Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E7E3B4104
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 11:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhFYKBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 06:01:51 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52052 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229902AbhFYKBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 06:01:50 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15P9oTUp015650;
        Fri, 25 Jun 2021 09:59:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qFPjxinxMtQeDj5/w8/lqotDJyc/wyG/gK8nNVr0yw0=;
 b=uJdik+PZbr0cXt46QpIU1NlJvNEA9NH4vJQFNEhW6nHO7lgNIo84Z1Spk3b1O3pCjsF8
 T7PgCmL6JT6ahh+oFtbrjRS5ojzNTm0WeOpLiEdSZD2di+Vtc1QmIYUkVTsqmGVeh2Tr
 pPYXa3LJbEc2Cnz+ogSGyXZve75BSvNuZY9O3Ld25llB1ywkNx30UChCrlCvC2x4Bail
 AvGsavJ8v/p81akP0dxNjPCHV1ESsuTEf+NwDaNRt/z+k1TRCxZb5ItC1hjN4c1k5t2N
 mP9qO33TXHbhRhUKARb6CUtpCRxRmtQI6KmeiK85Gb2mCKT4euVSfX8JAjUfPPbH2ENw TA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39d24a9112-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 09:59:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15P9tOME097326;
        Fri, 25 Jun 2021 09:59:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 39d23xtvmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 09:59:13 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15P9xCMl109076;
        Fri, 25 Jun 2021 09:59:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 39d23xtvm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 09:59:12 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15P9x9M7007589;
        Fri, 25 Jun 2021 09:59:09 GMT
Received: from kadam (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Jun 2021 09:59:09 +0000
Date:   Fri, 25 Jun 2021 12:59:01 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] netfilter: nf_tables: Fix dereference of null
 pointer flow
Message-ID: <20210625095901.GH2040@kadam>
References: <20210624195718.170796-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210624195718.170796-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: bi0xJpBda37N-dmz3NNMc3-XuxtaYumR
X-Proofpoint-ORIG-GUID: bi0xJpBda37N-dmz3NNMc3-XuxtaYumR
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Btw, why is there no clean up if nft_table_validate() fails?

net/netfilter/nf_tables_api.c
  3432                                  list_add_tail_rcu(&rule->list, &old_rule->list);
  3433                          else
  3434                                  list_add_rcu(&rule->list, &chain->rules);
  3435                  }
  3436          }
  3437          kvfree(expr_info);
  3438          chain->use++;
  3439  
  3440          if (flow)
  3441                  nft_trans_flow_rule(trans) = flow;
  3442  
  3443          if (nft_net->validate_state == NFT_VALIDATE_DO)
  3444                  return nft_table_validate(net, table);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The cleanup for this would be quite involved unfortunately...  Not
necessarily something to attempt without being able to test the code.

  3445  
  3446          return 0;
  3447  
  3448  err_destroy_flow_rule:
  3449          nft_flow_rule_destroy(flow);
  3450  err_release_rule:
  3451          nf_tables_rule_release(&ctx, rule);
  3452  err_release_expr:
  3453          for (i = 0; i < n; i++) {
  3454                  if (expr_info[i].ops) {
  3455                          module_put(expr_info[i].ops->type->owner);
  3456                          if (expr_info[i].ops->type->release_ops)
  3457                                  expr_info[i].ops->type->release_ops(expr_info[i].ops);
  3458                  }
  3459          }
  3460          kvfree(expr_info);
  3461  
  3462          return err;
  3463  }

regards,
dan carpenter


