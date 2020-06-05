Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE33E1F0183
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 23:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbgFEVZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 17:25:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35112 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbgFEVZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 17:25:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 055LCfnP068053;
        Fri, 5 Jun 2020 21:24:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=aV98zPU93QBvNWrzk/ChQ5VDmnpe9w8rIC4yo8Fb6lM=;
 b=Q1wCXDw9w/bF7V0bkGC6IvL76x/w0WRjHOjcxmnHanLSCPjsBGyoHCWarj+RUh94mOSJ
 JOw6GQd3a5lw9KYdYwB2p/gU3zJuSBSrGrcp6GYC6IH07y9J6nCZZj+uTRccUfHts6bd
 MdUyRr//DuAUp9QUBtGFB4+83Cz9gWQPj0pd9i6KcEhicYRbbQUTTrLaGUHKpeehAJCZ
 81LgCPL7zl/DqQu7VMtqkC3X4EK4U8vjMA9l5YLArm6psse7CKjV7A9oD3lz3ZtmSrRt
 ET2Dx60lQiQPN8gE2bl/ckY4w3R5KJWxgT9i2gvTGQxuSupj4SrfzCWHtvZJZpGjkGwB yQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31f91dvsxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 05 Jun 2020 21:24:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 055LEWQ2149042;
        Fri, 5 Jun 2020 21:24:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31f927qyn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jun 2020 21:24:52 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 055LOfOR001022;
        Fri, 5 Jun 2020 21:24:41 GMT
Received: from [10.39.238.70] (/10.39.238.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jun 2020 14:24:41 -0700
Subject: Re: [PATCH 04/12] x86/xen: add system core suspend and resume
 callbacks
To:     "Agarwal, Anchal" <anchalag@amazon.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Valentin, Eduardo" <eduval@amazon.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
References: <cover.1589926004.git.anchalag@amazon.com>
 <79cf02631dc00e62ebf90410bfbbdb52fe7024cb.1589926004.git.anchalag@amazon.com>
 <4b577564-e4c3-0182-2b9e-5f79004f32a1@oracle.com>
 <B966B3A2-4F08-42FA-AF59-B8AA0783C2BA@amazon.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Autocrypt: addr=boris.ostrovsky@oracle.com; keydata=
 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
 Jg6OxFYd01z+a+oL
Message-ID: <e2073aa4-2410-4630-fee6-4e4abc172876@oracle.com>
Date:   Fri, 5 Jun 2020 17:24:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <B966B3A2-4F08-42FA-AF59-B8AA0783C2BA@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9643 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006050158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9643 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 clxscore=1015 cotscore=-2147483648 malwarescore=0 adultscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 spamscore=0 mlxscore=0
 impostorscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006050158
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/20 6:40 PM, Agarwal, Anchal wrote:
>     CAUTION: This email originated from outside of the organization. Do=
 not click links or open attachments unless you can confirm the sender an=
d know the content is safe.
>
>
>
>     On 5/19/20 7:26 PM, Anchal Agarwal wrote:
>     > From: Munehisa Kamata <kamatam@amazon.com>
>     >
>     > Add Xen PVHVM specific system core callbacks for PM suspend and
>     > hibernation support. The callbacks suspend and resume Xen
>     > primitives,like shared_info, pvclock and grant table. Note that
>     > Xen suspend can handle them in a different manner, but system
>     > core callbacks are called from the context.
>
>
>     I don't think I understand that last sentence.
>
> Looks like it may have cryptic meaning of stating that xen_suspend call=
s syscore_suspend from xen_suspend
> So, if these syscore ops gets called  during xen_suspend do not do anyt=
hing. Check if the mode is in xen suspend=20
> and return from there. These syscore_ops are specifically for domU hibe=
rnation.
> I must admit, I may have overlooked lack of explanation of some implici=
t details in the original commit msg.=20
>
>     >  So if the callbacks
>     > are called from Xen suspend context, return immediately.
>     >
>
>
>     > +
>     > +static int xen_syscore_suspend(void)
>     > +{
>     > +     struct xen_remove_from_physmap xrfp;
>     > +     int ret;
>     > +
>     > +     /* Xen suspend does similar stuffs in its own logic */
>     > +     if (xen_suspend_mode_is_xen_suspend())
>     > +             return 0;


With your explanation now making this clearer, is this check really
necessary? From what I see we are in XEN_SUSPEND mode when
lock_system_sleep() lock is taken, meaning that we can't initialize
hibernation.


>     > +
>     > +     xrfp.domid =3D DOMID_SELF;
>     > +     xrfp.gpfn =3D __pa(HYPERVISOR_shared_info) >> PAGE_SHIFT;
>     > +
>     > +     ret =3D HYPERVISOR_memory_op(XENMEM_remove_from_physmap, &x=
rfp);
>     > +     if (!ret)
>     > +             HYPERVISOR_shared_info =3D &xen_dummy_shared_info;
>     > +
>     > +     return ret;
>     > +}
>     > +
>     > +static void xen_syscore_resume(void)
>     > +{
>     > +     /* Xen suspend does similar stuffs in its own logic */
>     > +     if (xen_suspend_mode_is_xen_suspend())
>     > +             return;
>     > +
>     > +     /* No need to setup vcpu_info as it's already moved off */
>     > +     xen_hvm_map_shared_info();
>     > +
>     > +     pvclock_resume();
>     > +
>     > +     gnttab_resume();
>
>
>     Do you call gnttab_suspend() in pm suspend path?
> No, since it does nothing for HVM guests. The unmap_frames is only appl=
icable for PV guests right?


You should call it nevertheless. It will decide whether or not anything
needs to be done.


-boris


