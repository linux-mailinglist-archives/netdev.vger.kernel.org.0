Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B021D738A
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 11:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgERJLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 05:11:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60028 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbgERJLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 05:11:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04I93ATR173287;
        Mon, 18 May 2020 09:10:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=Rvkso+0xj+PaZPCgO7NcqlP3hcldz8TuQZ/t643+Io8=;
 b=mqABSTJEenM30vsxFxjbAMut5oKHKCuD7bKCGWQ42NqBm0nm++F+hoWtMwoK4wBeWK94
 T6twSyP80Unnh+6nQQX27JJjxLeQ54BqYzNTtvM45pG71Rk7fdme6UwZrZ1PyXRXaXgM
 5+tZGQwj/nSq51Ie8gR7Ki99ikUtPX9f/ZTeRpZ7XgIiBn2fE51RcDYPu3xNcy9ClBBW
 31cnpS00srfEXmwSqVChOFdXI+S0DdBXOchqTNTY8wX3h0Xqx7cap9JtdtcIEUACFUVX
 HuKms+yjaw2OX/Mp8+j3RlAzN5Xpu/qF3893fuXBXl8I8GVwfSrFh19UrgKxgz4iWBDX qA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3127kqwn1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 18 May 2020 09:10:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04I94KsA115300;
        Mon, 18 May 2020 09:10:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 312t3v7w3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 May 2020 09:10:58 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04I9Ar6c001535;
        Mon, 18 May 2020 09:10:53 GMT
Received: from dhcp-10-175-184-176.vpn.oracle.com (/10.175.184.176)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 May 2020 02:10:52 -0700
Date:   Mon, 18 May 2020 10:10:44 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Yonghong Song <yhs@fb.com>
cc:     Alan Maguire <alan.maguire@oracle.com>, ast@kernel.org,
        daniel@iogearbox.net, bpf@vger.kernel.org, joe@perches.com,
        linux@rasmusvillemoes.dk, arnaldo.melo@gmail.com, kafai@fb.com,
        songliubraving@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next 6/7] bpf: add support for %pT format specifier
 for bpf_trace_printk() helper
In-Reply-To: <040b71a1-9bbf-9a55-6f1a-e7b8c36f8c6e@fb.com>
Message-ID: <alpine.LRH.2.21.2005181000520.893@localhost>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com> <1589263005-7887-7-git-send-email-alan.maguire@oracle.com> <040b71a1-9bbf-9a55-6f1a-e7b8c36f8c6e@fb.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9624 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 suspectscore=3 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005180081
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9624 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=3 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005180081
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 May 2020, Yonghong Song wrote:

> 
> > +				while (isbtffmt(fmt[i]))
> > +					i++;
> 
> The pointer passed to the helper may not be valid pointer. I think you
> need to do a probe_read_kernel() here. Do an atomic memory allocation
> here should be okay as this is mostly for debugging only.
> 

Are there other examples of doing allocations in program execution
context? I'd hate to be the first to introduce one if not. I was hoping
I could get away with some per-CPU scratch space. Most data structures
will fit within a small per-CPU buffer, but if multiple copies
are required, performance isn't the key concern. It will make traversing
the buffer during display a bit more complex but I think avoiding 
allocation might make that complexity worth it. The other thought I had 
was we could carry out an allocation associated with the attach, 
but that's messy as it's possible run-time might determine the type for
display (and thus the amount of the buffer we need to copy safely).

Great news about LLVM support for __builtin_btf_type_id()!

Thanks!

Alan
