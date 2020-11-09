Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8412AC124
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 17:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730555AbgKIQn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 11:43:29 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48394 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729776AbgKIQn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 11:43:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9GTiGs024900;
        Mon, 9 Nov 2020 16:43:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=yoSc8PVnoqz9vLpwLqVpjsZWxikRjgLIIdZmILAbnjM=;
 b=dBIunAvHvyYJ8eDVVK0GgO0D2jj4HnIPOe3U/fnqG71CAARSSvWmpB9UxcqU2v0GcrcT
 3Mz0lQDFL4oT55eZajk+X+BANRUd3wm8vq+SibOLLy7CYgnejsa7Bl4RAJXqOPjni/3T
 CtRijv3Rg7CVE4biWzGSFAI+W0T12WCTVGBR2i3kLXr4BISyP9SnYBcs5tpnmUiLUnlQ
 Yo7f5CTfxzgMAOZY78BCl2aN+7p415ZNYrrrCc5mocnEJsH5AZF/vStu1BmkK5d9HYDI
 YAQooRbqhu6CLgUu8lkVvrMxHTU3ChueWWQ7/Z42WyJnSZGebMKjmUZGM1KT7ncVP/kz GA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34nkhkpyh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 09 Nov 2020 16:43:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9GU3fY157105;
        Mon, 9 Nov 2020 16:43:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34p5gvg514-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Nov 2020 16:43:09 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A9Gh8du027322;
        Mon, 9 Nov 2020 16:43:08 GMT
Received: from dhcp-10-175-204-77.vpn.oracle.com (/10.175.204.77)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 08:43:07 -0800
Date:   Mon, 9 Nov 2020 16:42:58 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Andrii Nakryiko <andrii@kernel.org>
cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com,
        linux-kernel@vger.kernel.org, rafael@kernel.org, jeyu@kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH bpf-next 5/5] tools/bpftool: add support for in-kernel
 and named BTF in `btf show`
In-Reply-To: <20201106055111.3972047-6-andrii@kernel.org>
Message-ID: <alpine.LRH.2.21.2011091633450.4154@localhost>
References: <20201106055111.3972047-1-andrii@kernel.org> <20201106055111.3972047-6-andrii@kernel.org>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=3 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1011 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020, Andrii Nakryiko wrote:

> Display vmlinux BTF name and kernel module names when listing available BTFs
> on the system.
> 
> In human-readable output mode, module BTFs are reported with "name
> [module-name]", while vmlinux BTF will be reported as "name [vmlinux]".
> Square brackets are added by bpftool and follow kernel convention when
> displaying modules in human-readable text outputs.
> 

I had a go at testing this and all looks good, but I was curious
if  "bpftool btf dump" is expected to work with module BTF? I see
the various modules in /sys/kernel/btf, but if I run:

# bpftool btf dump file /sys/kernel/btf/ixgbe
Error: failed to load BTF from /sys/kernel/btf/ixgbe: Invalid argument

...while it still works for vmlinux:

# bpftool btf dump file /sys/kernel/btf/vmlinux
[1] INT '(anon)' size=4 bits_offset=0 nr_bits=32 encoding=(none)
[2] INT 'long unsigned int' size=8 bits_offset=0 nr_bits=64 
encoding=(none)
...

"bpftool btf show" works for ixgbe:

# bpftool btf show|grep ixgbe
19: name [ixgbe]  size 182074B

Is this perhaps not expected to work yet? (I updated pahole
to the latest changes etc and BTF generation seemed to work
fine for modules during kernel build).

For the "bpftool btf show" functionality, feel free to add

Tested-by: Alan Maguire <alan.maguire@oracle.com>

Thanks!

Alan
