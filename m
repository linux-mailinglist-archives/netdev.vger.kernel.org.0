Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3834B20B0A5
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgFZLig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:38:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43042 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgFZLig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:38:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05QBMOVP125906;
        Fri, 26 Jun 2020 11:37:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=k2A3eJ2ev4HDGAoi2Ne+4n6xqAdh/imn+vWwXQjLWzU=;
 b=j5M9iuTlzEUvPm3T5WQ6uV9FaMr+GFMRwOYnQs/tNV5ToMVJKXMHbEp7A33Z+ZL1JaTo
 lcQb6UfUx0XhGB4DQFS9kO0+9jonM7D0rpBuTFENqePps6gTQl1fC3kX3aseQqa0wD04
 61RXyTm1YBj45MnGJFRI6tIMcPKbLkPY3UC8g7vK02Hi3E3m+TWGc+PRjbpPzk6YhxyA
 gL673T/vNuBX/JADNIeHK24era6rfZRMH3F0RHTSlEaPQdwghaUd4ycLg4y1j4JpCihu
 ZMrr8LNYKJTsuFFKQRzmmGKGg+AIaSlzVhjTZGL9qVAFhJ1EeakAxZPm4CJaU9nG+rpU Vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31wg3bg1hj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 26 Jun 2020 11:37:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05QBIKMG066286;
        Fri, 26 Jun 2020 11:37:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31uurc27cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Jun 2020 11:37:39 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05QBbWZf007459;
        Fri, 26 Jun 2020 11:37:33 GMT
Received: from dhcp-10-175-206-62.vpn.oracle.com (/10.175.206.62)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 26 Jun 2020 11:37:32 +0000
Date:   Fri, 26 Jun 2020 12:37:19 +0100 (IST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Petr Mladek <pmladek@suse.com>
cc:     Alan Maguire <alan.maguire@oracle.com>, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, andriin@fb.com,
        arnaldo.melo@gmail.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux@rasmusvillemoes.dk, joe@perches.com,
        andriy.shevchenko@linux.intel.com, corbet@lwn.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 bpf-next 4/8] printk: add type-printing %pT format
 specifier which uses BTF
In-Reply-To: <20200626101523.GM8444@alley>
Message-ID: <alpine.LRH.2.21.2006261147130.417@localhost>
References: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com> <1592914031-31049-5-git-send-email-alan.maguire@oracle.com> <20200626101523.GM8444@alley>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 spamscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260083
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=3 phishscore=0
 malwarescore=0 cotscore=-2147483648 adultscore=0 lowpriorityscore=0
 impostorscore=0 clxscore=1011 mlxscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006260083
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 26 Jun 2020, Petr Mladek wrote:

> On Tue 2020-06-23 13:07:07, Alan Maguire wrote:
> > printk supports multiple pointer object type specifiers (printing
> > netdev features etc).  Extend this support using BTF to cover
> > arbitrary types.  "%pT" specifies the typed format, and the pointer
> > argument is a "struct btf_ptr *" where struct btf_ptr is as follows:
> > 
> > struct btf_ptr {
> >         void *ptr;
> >         const char *type;
> >         u32 id;
> > };
> > 
> > Either the "type" string ("struct sk_buff") or the BTF "id" can be
> > used to identify the type to use in displaying the associated "ptr"
> > value.  A convenience function to create and point at the struct
> > is provided:
> > 
> >         printk(KERN_INFO "%pT", BTF_PTR_TYPE(skb, struct sk_buff));
> > 
> > When invoked, BTF information is used to traverse the sk_buff *
> > and display it.  Support is present for structs, unions, enums,
> > typedefs and core types (though in the latter case there's not
> > much value in using this feature of course).
> > 
> > Default output is indented, but compact output can be specified
> > via the 'c' option.  Type names/member values can be suppressed
> > using the 'N' option.  Zero values are not displayed by default
> > but can be using the '0' option.  Pointer values are obfuscated
> > unless the 'x' option is specified.  As an example:
> > 
> >   struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
> >   pr_info("%pT", BTF_PTR_TYPE(skb, struct sk_buff));
> > 
> > ...gives us:
> > 
> > (struct sk_buff){
> >  .transport_header = (__u16)65535,
> >  .mac_header = (__u16)65535,
> >  .end = (sk_buff_data_t)192,
> >  .head = (unsigned char *)0x000000006b71155a,
> >  .data = (unsigned char *)0x000000006b71155a,
> >  .truesize = (unsigned int)768,
> >  .users = (refcount_t){
> >   .refs = (atomic_t){
> >    .counter = (int)1,
> >   },
> >  },
> >  .extensions = (struct skb_ext *)0x00000000f486a130,
> > }
> > 
> > printk output is truncated at 1024 bytes.  For cases where overflow
> > is likely, the compact/no type names display modes may be used.
> 
> Hmm, this scares me:
> 
>    1. The long message and many lines are going to stretch printk
>       design in another dimensions.
> 
>    2. vsprintf() is important for debugging the system. It has to be
>       stable. But the btf code is too complex.
>

Right on both points, and there's no way around that really. Representing 
even small data structures will stretch us to or beyond the 1024 byte 
limit.  This can be mitigated by using compact display mode and not 
printing field names, but the output becomes hard to parse then.

I think a better approach might be to start small, adding the core
btf_show functionality to BPF, allowing consumers to use it there,
perhaps via a custom helper. In the current model bpf_trace_printk()
inherits the functionality to display data from core printk, so a
different approach would be needed there.  Other consumers outside of BPF
could potentially avail of the show functionality directly via the btf_show
functions in the future, but at least it would have one consumer at the 
outset, and wouldn't present problems like these for printk.
 
> I would strongly prefer to keep this outside vsprintf and printk.
> Please, invert the logic and convert it into using separate printk()
> call for each printed line.
> 

I think the above is in line with what you're suggesting?

> 
> More details:
> 
> Add 1: Long messages with many lines:
> 
>   IMHO, all existing printk() users are far below this limit. And this is
>   even worse because there are many short lines. They would require
>   double space to add prefixes (loglevel, timestamp, caller id) when
>   printing to console.
> 
>   You might argue that 1024bytes are enough for you. But for how long?
> 
>   Now, we have huge troubles to make printk() lockless and thus more
>   reliable. There is no way to allocate any internal buffers
>   dynamically. People using kernel on small devices have problem
>   with large static buffers.
> 
>   printk() is primary designed to print single line messages. There are
>   many use cases where many lines are needed and they are solved by
>   many separate printk() calls.
> 
> 
> Add 2: Complex code:
> 
>   vsprintf() is currently called in printk() under logbuf_lock. It
>   might block printk() on the entire system.
> 
>   Most existing %p<modifier> handlers are implemented by relatively
>   simple routines inside lib/vsprinf.c. The other external routines
>   look simple as well.
> 
>   btf looks like a huge beast to me. For example, probe_kernel_read()
>   prevented boot recently, see the commit 2ac5a3bf7042a1c4abb
>   ("vsprintf: Do not break early boot with probing addresses").
> 
> 

Yep, no way round this either. I'll try a different approach. Thanks for 
taking a look!

Alan

> Best Regards,
> Petr
> 
