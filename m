Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13EBD3AE3FA
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 09:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhFUHU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 03:20:59 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:41532 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229597AbhFUHU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 03:20:58 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15L7BOdf016599;
        Mon, 21 Jun 2021 07:18:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5eb/oECVSzdI5E9j6u2cJRlEk2Z/x4pyxZIvvDsUMOw=;
 b=JsSmKgkVF/rVIcWTdSmJ3R9rAZqbRDgusXxhIvfBfiRlcxti1/V1kEhX5DFugVWfsJaB
 DwUaxV+bVuvzj+e1j/YEv5INhi2/UbEI3vWS2hdOgxRhhCkl0RaPPgwLF6SHxN2hHWCe
 05iEWCEmZjgHUww2QzxmvkXTu4HPRvhtsMymaOh0ZuQsPHuA7atltlzuAQjRvLsnSL8D
 M9EkUK185OUtHNEJD1UNi0u1NSfQiYsdY7cO5atIs9hJGgY0HitVI8AecoRPKuhh6F3D
 Z8XkRk383zQyz5cXj1jpxxN57/gmiMZAPLm3ow/umvDxfwxYoBHlVku5eMXXQxcvpr/y Zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39994r2ay7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 07:18:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15L7B7gb160859;
        Mon, 21 Jun 2021 07:18:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3995pu7dyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 07:18:40 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15L7BucK162747;
        Mon, 21 Jun 2021 07:18:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3995pu7dy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 07:18:39 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15L7IcGA027293;
        Mon, 21 Jun 2021 07:18:38 GMT
Received: from kadam (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Jun 2021 07:18:37 +0000
Date:   Mon, 21 Jun 2021 10:18:31 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     subashab@codeaurora.org
Cc:     Sean Tranchetti <stranche@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: qualcomm: rmnet: fix two pointer math bugs
Message-ID: <20210621071831.GB1901@kadam>
References: <YM32lkJIJdSgpR87@mwanda>
 <027ae9e2ddc18f0ed30c5d9c7075c8b9@codeaurora.org>
 <20210621071158.GA1901@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621071158.GA1901@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: NMMFNvMHdypto3gaDsxBITf0BEwpebZk
X-Proofpoint-GUID: NMMFNvMHdypto3gaDsxBITf0BEwpebZk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 10:11:58AM +0300, Dan Carpenter wrote:
> On Sat, Jun 19, 2021 at 01:12:09PM -0600, subashab@codeaurora.org wrote:
> > On 2021-06-19 07:52, Dan Carpenter wrote:
> > 
> > Hi Dan
> > 
> > Thanks for fixing this. Could you cast the ip4h to char* instead of void*.
> > Looks like gcc might raise issues if -Wpointer-arith is used.
> > 
> > https://gcc.gnu.org/onlinedocs/gcc-4.5.0/gcc/Pointer-Arith.html#Pointer-Arith
> 
> The fix for that is to not enable -Wpointer-arith.  The warning is dumb.

Sorry, that was uncalled for and not correct.  The GCC warning would be
useful if we were trying to write portable userspace code.  But in the
kernel the kernel uses GCC extensions a lot.

The Clang compiler can also compile the kernel these days.  But it had
to add support for a bunch of GCC extensions to make that work.  Really
most of linux userspace is written with GCC in mind so Clang had to do
this anyway.

So we will never enable -Wpointer-arith in the kernel because there is
no need.

regards,
dan carpenter
