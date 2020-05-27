Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0BB1E3E9C
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 12:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387751AbgE0KIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 06:08:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55268 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbgE0KIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 06:08:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04RA7bN9029643;
        Wed, 27 May 2020 10:07:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=Jgk+aa3gaSbaEJGRzqmUB4J/D3RcAW2mzmSgXwtDYpI=;
 b=I++iBdw/d6EbbsVc0QonMYtP9GdH7G9gqk7JTiB94+7WbFWe/ILrE7Z3/1Xou2AA/fj0
 XfiW1ia3B13QNes64K8EvFxGTdek2n1b1W/CZkKh0BNspXqu5WHk3CdXeMTM9mLZJxGW
 HOtff/B6xDcXoVujMkSWvLLR+R8xcPpBHqJLZ0kEdQhnfyRw8J6J6VCNosFSIaEu0thm
 Xz1cn4ch5LgZ1tUZIBA3t8NTvbbgSWEt29tV/Ak2G+yNA1HvzCz/bBs7k698p7fC90vO
 0n/SEPzLJEx2JmH8cX0h5LZ95k2fkDoJBgdt9g4Ud68tggcn37DEw46UAI4yWToBi71J Lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 316u8qxjjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 10:07:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R9vY3D160684;
        Wed, 27 May 2020 10:05:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 317j5rcya4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 10:05:35 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04RA5XM3005085;
        Wed, 27 May 2020 10:05:33 GMT
Received: from dhcp-10-175-217-36.vpn.oracle.com (/10.175.217.36)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 May 2020 03:05:33 -0700
Date:   Wed, 27 May 2020 11:05:23 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
cc:     kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Emanuele Giuseppe Esposito <e.emanuelegiuseppe@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        brendanhiggins@google.com, linux-kselftest@vger.kernel.org,
        kunit-dev@googlegroups.com
Subject: Re: [PATCH v3 3/7] kunit: tests for stats_fs API
In-Reply-To: <20200526110318.69006-4-eesposit@redhat.com>
Message-ID: <alpine.LRH.2.21.2005271054360.24819@localhost>
References: <20200526110318.69006-1-eesposit@redhat.com> <20200526110318.69006-4-eesposit@redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=4
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270072
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 cotscore=-2147483648 suspectscore=4
 phishscore=0 clxscore=1011 mlxlogscore=999 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005270073
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 May 2020, Emanuele Giuseppe Esposito wrote:

> Add kunit tests to extensively test the stats_fs API functionality.
>

I've added in the kunit-related folks.
 
> In order to run them, the kernel .config must set CONFIG_KUNIT=y
> and a new .kunitconfig file must be created with CONFIG_STATS_FS=y
> and CONFIG_STATS_FS_TEST=y
>

It looks like CONFIG_STATS_FS is built-in, but it exports
much of the functionality you are testing.  However could the
tests also be built as a module (i.e. make CONFIG_STATS_FS_TEST
a tristate variable)? To test this you'd need to specify
CONFIG_KUNIT=m and CONFIG_STATS_FS_TEST=m, and testing would
simply be a case of "modprobe"ing the stats fs module and collecting
results in /sys/kernel/debug/kunit/<module_name> (rather 
than running kunit.py). Are you relying on unexported internals in
the the tests that would prevent building them as a module?

Thanks!

Alan
