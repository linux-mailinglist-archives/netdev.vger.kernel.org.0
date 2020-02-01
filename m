Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B72014F8E2
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 17:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgBAQ0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 11:26:44 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58866 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgBAQ0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 11:26:43 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 011GO2ho170066;
        Sat, 1 Feb 2020 16:26:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=qcGXKiY3GE8IoOSuEgOX+PWsQEJZ9WKgu7dUUWQqrfQ=;
 b=YSNZofZ7ZqYnCJOxzT8gCflqxf5fW+U69ygw+SqauiAzTzmO5wdPmyb7Iu3JqVUPldJb
 i4r/4UJOEV/voWzBdpRGAh/ya5x/TjfXvibYstNEOW9IdwbVwSv6B/4saeuF600HaYMF
 C5gZbNGYHs4s6ZeVgIJM6UhsD0etsXyU5jEl+kbCx+nSVhWdZvDF7TIl+R/zKI1nuVKE
 e+m6pmS/XHQMPyJ4yFW4AuL+2NmZN1y/tGy8JKvmwZ6MyOQXStAjsAeX1tEzXV1Ia75Z
 QYxEF6Ttok170eDo5OkRmk4kjnGANo6PeQKsEWXJYtR4p3ExjsYmzrUdbccT+UyrA+lp TQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xw0rtsr75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Feb 2020 16:26:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 011GNKM2187896;
        Sat, 1 Feb 2020 16:26:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xvycydah3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Feb 2020 16:26:03 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 011GPpS3016390;
        Sat, 1 Feb 2020 16:25:51 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 01 Feb 2020 08:25:50 -0800
Date:   Sat, 1 Feb 2020 19:25:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+0dc4444774d419e916c8@syzkaller.appspotmail.com>,
        airlied@linux.ie, alexander.deucher@amd.com,
        amd-gfx@lists.freedesktop.org, chris@chris-wilson.co.uk,
        christian.koenig@amd.com, daniel@ffwll.ch, davem@davemloft.net,
        dri-devel@lists.freedesktop.org, emil.velikov@collabora.com,
        eric@anholt.net, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, robdclark@chromium.org,
        seanpaul@chromium.org, sumit.semwal@linaro.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in vgem_gem_dumb_create
Message-ID: <20200201162537.GK1778@kadam>
References: <20200201043209.13412-1-hdanton@sina.com>
 <20200201090247.10928-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200201090247.10928-1-hdanton@sina.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9518 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002010121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9518 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002010121
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 01, 2020 at 05:02:47PM +0800, Hillf Danton wrote:
> 
> On Sat, 1 Feb 2020 09:17:57 +0300 Dan Carpenter wrote:
> > On Sat, Feb 01, 2020 at 12:32:09PM +0800, Hillf Danton wrote:
> > >
> > > Release obj in error path.
> > > 
> > > --- a/drivers/gpu/drm/vgem/vgem_drv.c
> > > +++ b/drivers/gpu/drm/vgem/vgem_drv.c
> > > @@ -196,10 +196,10 @@ static struct drm_gem_object *vgem_gem_c
> > >  		return ERR_CAST(obj);
> > >  
> > >  	ret = drm_gem_handle_create(file, &obj->base, handle);
> > > -	drm_gem_object_put_unlocked(&obj->base);
> > > -	if (ret)
> > > +	if (ret) {
> > > +		drm_gem_object_put_unlocked(&obj->base);
> > >  		return ERR_PTR(ret);
> > > -
> > > +	}
> > >  	return &obj->base;
> > 
> > Oh yeah.  It's weird that we never noticed the success path was broken.
> > It's been that way for three years and no one noticed at all.  Very
> > strange.
> > 
> > Anyway, it already gets freed on error in drm_gem_handle_create() so
> > we should just delete the drm_gem_object_put_unlocked() here it looks
> > like.
> 
> Good catch, Dan :P
> Would you please post a patch sometime convenient next week?

Sure.  Will do.

regards,
dan carpenter

