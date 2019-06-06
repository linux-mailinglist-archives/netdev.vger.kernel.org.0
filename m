Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A41371F5
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 12:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfFFKpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 06:45:16 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44654 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfFFKpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 06:45:16 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56AdBIo121846;
        Thu, 6 Jun 2019 10:44:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=rlTNItZ+vRzH1C5J9n3DIzZYXoQt0JFY3F5NEZCvtS8=;
 b=oWdP9WZFGCHw1qxWUhunX2JomZIVQPQhXJ2qwjvgRnbfY6feGLqv4FAbh8QZTqO9x2Lv
 GnyEYOdVNPpZYKVuC18tIW66GsQL6erL2HQrQj7ewltvSjVh93QhEEWh+D+N1Cxm/Qd5
 okGibrOrohrLg+bAMOd7POOERxAJ818UIs8/sQ5GYRMgtcU98fkMWnDBfFKQQmYfP/dQ
 AM+PnfG0Wzru10foVzr8RFpORFxWERTa8rIpEmYfwG+8Fad3tpZUYMme6iheDeaS3Gud
 eJJOotZ8HZcAh8A7NNppd9IllLw/YGG2GNSN2eflBbPmoizY+KDlF7SfhC/NpoeFVOmk Tg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2suevdqw7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 10:44:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56Aifb8006245;
        Thu, 6 Jun 2019 10:44:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2swnhcmdqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 10:44:41 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x56AidWx000959;
        Thu, 6 Jun 2019 10:44:39 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Jun 2019 03:44:38 -0700
Date:   Thu, 6 Jun 2019 13:44:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] bpf: remove redundant assignment to err
Message-ID: <20190606104428.GK31203@kadam>
References: <20190603170247.9951-1-colin.king@canonical.com>
 <20190603102140.70fee157@cakuba.netronome.com>
 <276525bd-dd79-052e-7663-9acc92621853@canonical.com>
 <20190603104930.466a306b@cakuba.netronome.com>
 <e351d18c-21cd-6617-2a59-31a48be54b7e@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e351d18c-21cd-6617-2a59-31a48be54b7e@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9279 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906060078
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9279 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906060078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 07:07:20PM +0100, Colin Ian King wrote:
> On 03/06/2019 18:49, Jakub Kicinski wrote:
> > On Mon, 3 Jun 2019 18:39:16 +0100, Colin Ian King wrote:
> >> On 03/06/2019 18:21, Jakub Kicinski wrote:
> >>> On Mon,  3 Jun 2019 18:02:47 +0100, Colin King wrote:  
> >>>> From: Colin Ian King <colin.king@canonical.com>
> >>>>
> >>>> The variable err is assigned with the value -EINVAL that is never
> >>>> read and it is re-assigned a new value later on.  The assignment is
> >>>> redundant and can be removed.
> >>>>
> >>>> Addresses-Coverity: ("Unused value")
> >>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> >>>> ---
> >>>>  kernel/bpf/devmap.c | 2 +-
> >>>>  kernel/bpf/xskmap.c | 2 +-
> >>>>  2 files changed, 2 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> >>>> index 5ae7cce5ef16..a76cc6412fc4 100644
> >>>> --- a/kernel/bpf/devmap.c
> >>>> +++ b/kernel/bpf/devmap.c
> >>>> @@ -88,7 +88,7 @@ static u64 dev_map_bitmap_size(const union bpf_attr *attr)
> >>>>  static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
> >>>>  {
> >>>>  	struct bpf_dtab *dtab;
> >>>> -	int err = -EINVAL;
> >>>> +	int err;
> >>>>  	u64 cost;  
> >>>
> >>> Perhaps keep the variables ordered longest to shortest?  
> >>
> >> Is that a required coding standard?
> > 
> > For networking code, yes.  Just look around the files you're changing
> > and see for yourself.
> 
> Ah, informal coding standards. Great. Won't this end up with more diff
> churn?

Everyone knows that netdev uses reverse Christmas tree declarations...

regards,
dan carpenter

