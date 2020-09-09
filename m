Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30BB26285F
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 09:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbgIIHTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 03:19:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55522 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgIIHTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 03:19:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08975chh026702;
        Wed, 9 Sep 2020 07:19:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Hebn1+MO0cKwb3V91uzK8aFpPdTOf1H7cwnZUPJze/Y=;
 b=wVu97UJap7NiLIEzQCvYkPMcfmm2MbSTSECp7B/CSx8jF7KKW9lkRli6U1/kSEaqNpXt
 8+qChhyDyNnRtSKU8/ZFarSu3U+VZv7bvQIwAB1ZtbUgKYy06aJxO28UPloKJauHDWan
 RKgCPDo6IvtfRPYLhKRVoo6p9ig6YQAhMs33dZTkDf+QjexaiB8BvIv+kane6mm7gQb8
 DVltfrIT2Tx9iXPB2kBFsNcL591RWx51wZz+467/kH/p/lK+0XtgLZYh/TDFuyScC5T5
 WU0FSnFIdTNm3Lx8zIJHOI8nruWmd7xxxX5kO+yOVnumWqGYuarL3EF/l5V6OLmhuhCZ 4w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 33c23qyyrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 07:19:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08976MkV063678;
        Wed, 9 Sep 2020 07:19:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33cmkx974x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 07:19:33 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0897JWqY011710;
        Wed, 9 Sep 2020 07:19:32 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Sep 2020 00:19:31 -0700
Date:   Wed, 9 Sep 2020 10:19:24 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     nan chen <whutchennan@gmail.com>
Cc:     Krzysztof Halasa <khc@pm.waw.pl>, Jakub Kicinski <kuba@kernel.org>,
        security@kernel.org, Greg KH <greg@kroah.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] hdlc_ppp: add range checks in ppp_cp_parse_cr()
Message-ID: <20200909071924.GT8321@kadam>
References: <20200908153200.GB4165114@kroah.com>
 <20200908175359.GA356675@mwanda>
 <CAMnVd19nWToENW3X7v_PZN4snoXAoLgqKqn=dezXnd=z89zL7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMnVd19nWToENW3X7v_PZN4snoXAoLgqKqn=dezXnd=z89zL7Q@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090063
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090063
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 05:37:37AM +0800, nan chen wrote:
> Looks like the judgment of len <sizeof(valid_accm) has a problem.
> The judgment cannot avoid the memory overflow of the memcpy below.
>                         case LCP_OPTION_ACCM: /* async control character
> map */
> +                               if (len < sizeof(valid_accm))
> +                                       goto err_out;
> Assume that the initial value of len is 10.Then the length of 'out' memory
> is 10.
> And assume the value of opt[1] in each loop is 2.
> Then it will loop 3 times.
> 3 times memcpy will cause the 'out' memory to be overwritten by 18 bytes (
> > 10 bytes). This will be memory overflow.
> 
> I think the correct way is to judge the value of opt[1] like this:
> .                        case LCP_OPTION_ACCM: /* async control character
> map */
> +                               if (opt[1] < sizeof(valid_accm))
> +                                       goto err_out;
> 

Yeah.  You're right.  The "nak_len" count would grow faster than it
should leading to memory corruption.  I'll resend.

regards,
dan carpenter
