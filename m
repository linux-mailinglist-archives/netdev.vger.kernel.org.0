Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECEF34FCC5
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 11:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234734AbhCaJ1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 05:27:30 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38712 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234711AbhCaJ1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 05:27:09 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12V9Ov1P189484;
        Wed, 31 Mar 2021 09:26:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=KPySmHLqAP61MyIasZoJ5OyxdVnPRXNfupUZxb+81o4=;
 b=CNdULtE6FqBc1YNYMuecY1hB4+Y+Egnrln6yDmvtd7+uCZD2hxu+6kYad9UAJV196U0I
 WImipTF6nRHSHNksC77MniLcPIJ/VHI+6Kg2I3gVkwuBbML8ujXC/3RjF4fFWkZGi/ZY
 shWoHk2FxL7uIoYuoxIL7d8mAK5RcK59ysBgkQ4qyxXBxxYpuAFi1+P5JCY8//MI8JtU
 Uyfu4iVZreoOezdTkZuQfoshBWlGhvLiQbHBXJI1/IoqAmvgujegOu3P0WO2KQHYsYsT
 HjqiSXvF7xdGcEZWN1KuGJRla2F/sQxQ3iCcFh6VtXR8cHDl/HwksIFGsiAuiQo135uJ QQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37mafv1k9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 09:26:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12V9JcZT067590;
        Wed, 31 Mar 2021 09:26:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 37mabp6beh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 09:26:43 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 12V9Qa8G007579;
        Wed, 31 Mar 2021 09:26:36 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 31 Mar 2021 02:26:36 -0700
Date:   Wed, 31 Mar 2021 12:26:24 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Xie Yongji <xieyongji@bytedance.com>, hch@infradead.org,
        mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 01/10] file: Export receive_fd() to modules
Message-ID: <20210331092624.GI2088@kadam>
References: <20210331080519.172-1-xieyongji@bytedance.com>
 <20210331080519.172-2-xieyongji@bytedance.com>
 <20210331091545.lr572rwpyvrnji3w@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331091545.lr572rwpyvrnji3w@wittgenstein>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9939 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103300000 definitions=main-2103310068
X-Proofpoint-ORIG-GUID: YHYYseNx9ByGLpeYrfNz0NmGPzPCiw_B
X-Proofpoint-GUID: YHYYseNx9ByGLpeYrfNz0NmGPzPCiw_B
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9939 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 adultscore=0
 impostorscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103300000
 definitions=main-2103310068
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 11:15:45AM +0200, Christian Brauner wrote:
> On Wed, Mar 31, 2021 at 04:05:10PM +0800, Xie Yongji wrote:
> > Export receive_fd() so that some modules can use
> > it to pass file descriptor between processes without
> > missing any security stuffs.
> > 
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> 
> Yeah, as I said in the other mail I'd be comfortable with exposing just
> this variant of the helper.
> Maybe this should be a separate patch bundled together with Christoph's
> patch to split parts of receive_fd() into a separate helper.
> This would also allow us to simplify a few other codepaths in drivers as
> well btw. I just took a hasty stab at two of them:
> 
> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> index c119736ca56a..3c716bf6d84b 100644
> --- a/drivers/android/binder.c
> +++ b/drivers/android/binder.c
> @@ -3728,8 +3728,9 @@ static int binder_apply_fd_fixups(struct binder_proc *proc,
>         int ret = 0;
> 
>         list_for_each_entry(fixup, &t->fd_fixups, fixup_entry) {
> -               int fd = get_unused_fd_flags(O_CLOEXEC);
> +               int fd = receive_fd(fixup->file, O_CLOEXEC);
                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Assignment duplicated on the next line.

> 
> +               fd = receive_fd(fixup->file, O_CLOEXEC);
>                 if (fd < 0) {
>                         binder_debug(BINDER_DEBUG_TRANSACTION,
>                                      "failed fd fixup txn %d fd %d\n",

regards,
dan carpenter

