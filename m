Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFA32EBD39
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 12:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbhAFLjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 06:39:02 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58884 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbhAFLjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 06:39:02 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106BSlhE075887;
        Wed, 6 Jan 2021 11:38:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=Lwz5KjHL/lzDDL+gepiJSdF1gvmm6AZCK+JE+g9inn4=;
 b=DE9fzP71wvNMgpO0WnNKN2iMpvOf/LUz/7Oin00Ev0vmHCaYChoAnvpjaTHGZJmtyd+W
 u62ETOm8yH98ADBpCG+S+Zj57HQmq7glAZy8sVgA1z9hm5g7jhvjSaCjo04dvpHlDeG9
 fsIgd1lx3EBraTd5/vbILhoKXcVrqX2hicr1G0hZyaJjxAyWoKpmxBXQsAfh+HhqqFcC
 9+vtntf4oEUaMUDLQUh14nyhDbsa7uZ0fsrGyYWRbJS82dOmxT0YO0Vlic3DcdW0X1BV
 LhciR97ecd4tBOdyaApIKlH5DyKNLRuFhxXhap7221IHLCMybFHEt3ffMO0JCSXNIugU 7Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35wc96r1b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 11:38:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106BZn3b156963;
        Wed, 6 Jan 2021 11:36:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35v1f9sype-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 11:36:07 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 106BZX9V017595;
        Wed, 6 Jan 2021 11:35:33 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 03:35:32 -0800
Date:   Wed, 6 Jan 2021 14:35:24 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>
Cc:     Markus Elfring <Markus.Elfring@web.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        hulkci@huawei.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [v2] net: qrtr: fix null pointer dereference in qrtr_ns_remove
Message-ID: <20210106113524.GI2809@kadam>
References: <20210105055754.16486-1-miaoqinglang@huawei.com>
 <4596fb37-5e74-5bf6-60e5-ded6fbb83969@web.de>
 <fdea7394-3e4a-0afe-6b22-7e3a258f5607@huawei.com>
 <b70726b8-0965-1fb9-2af1-2e05609905ea@web.de>
 <1a736322-42ce-e803-f91c-dc7595acffdd@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a736322-42ce-e803-f91c-dc7595acffdd@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060071
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1011 mlxscore=0 malwarescore=0 suspectscore=0
 spamscore=0 bulkscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 05:46:22PM +0800, Qinglang Miao wrote:
> 
> 
> 在 2021/1/6 16:09, Markus Elfring 写道:
> > > > > A null-ptr-deref bug is reported by Hulk Robot like this:
> > > > 
> > > > Can it be clearer to use the term “null pointer dereference” for the final commit message?
> > > This advice is too detailed for 'null-ptr-deref' is known as a general phrase
> > 
> > This key word was provided already by the referenced KASAN report.
> > 
> Yep, you're right. 'null-ptr-deref' is not really proper here.
> > 
> > > like 'use-after-free' for kernel developer, I think.
> > I suggest to reconsider the use of abbreviations at some places.
> >  >
> > > > > Fix it by making …
> > > > 
> > > > Would you like to replace this wording by the tag “Fixes”?
> > > Sorry, I didn't get your words.
> > > 
> > > 'Fix it by' follows the solution
> > 
> > I propose to specify the desired adjustments without such a prefix
> > in the change description.
> Sorry, I can understand what you means, but I still disagree with this one,
> for:
> 
> 1. 'Fix it by' is everywhere in kernel commit message.
> 2. I think adding it or not makes no change for understanding.
> 3. I'm not sure this is an official proposal.
> 

Feel free to ignore Markus...  :/  We have asked him over and over to
stop sending these sort of advice but he refused and eventually he was
banned from the mailing lists.  The rest of us can't see his messages to
you unless we're included personally in the CC list.

regards,
dan carpenter

