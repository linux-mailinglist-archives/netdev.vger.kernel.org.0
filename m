Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B8C298717
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 07:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1770765AbgJZGxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 02:53:10 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55442 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390722AbgJZGxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 02:53:09 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09Q6jBft087478;
        Mon, 26 Oct 2020 06:52:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ZCdYqwskaOvpapAfB2phd0RcmVu3e0MieFtG58z39f0=;
 b=K82V47ulVlrXf1V5GQII3mj90UVz8n8x2EzQ14TVSVM4CQONhcpGl7dYFZyZRbCTz9Kt
 CAFEqVXH1k8diXvHuNmkOm00mw07yAD9ctYNnDs8wAS1s0SOh91Ng7dI4B1aBr5MtvoX
 sc4NG57srMf2n9jMSQOYAmspog/bgFNcSyqE0FZvvc0eO7n7SZwwhAyOvReqOusqalf8
 oZJR/oxPJiiqtX2uJnAHzkY+3UQofYi2O6NapdXrEJ1baNJLLMBzGk+0EQHa9kpAzuw/
 4kg0tQTlvF/GcjS05KtWPj4CVKFtjaL4oiUCKjOG0q+F1xJrckYd/3WLW4+dNHR/c2fF aA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34c9sakanm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 06:52:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09Q6oKUv087069;
        Mon, 26 Oct 2020 06:52:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34cwujye7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 06:52:47 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09Q6qkVY027221;
        Mon, 26 Oct 2020 06:52:46 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 25 Oct 2020 23:52:45 -0700
Date:   Mon, 26 Oct 2020 09:52:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: hns3: clean up a return in hclge_tm_bp_setup()
Message-ID: <20201026065235.GG18329@kadam>
References: <20201023112212.GA282278@mwanda>
 <3fbcbfbd-deea-162e-9281-29e65b90996b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fbcbfbd-deea-162e-9281-29e65b90996b@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1011 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260046
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 11:18:16AM +0800, Yunsheng Lin wrote:
> On 2020/10/23 19:22, Dan Carpenter wrote:
> > Smatch complains that "ret" might be uninitialized if we don't enter
> > the loop.  We do always enter the loop so it's a false positive, but
> > it's cleaner to just return a literal zero and that silences the
> > warning as well.
> 
> Thanks for the clean up. Minor comment below:
> Perhap it makes sense to limit ret scope within the for loop after
> returning zero.
> 

It's not really normal to limit ret scope...  I think it's better to
leave it as-is.

regards,
dan carpenter

