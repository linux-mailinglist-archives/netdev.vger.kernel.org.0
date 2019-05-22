Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F007A269C4
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbfEVSXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:23:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34754 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728272AbfEVSXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:23:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4MIJ5uZ071020;
        Wed, 22 May 2019 18:22:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=r5KZMuAu+51JUTI2ohhapWR6r+UgqS3aDYLLXOt7kLM=;
 b=goDtFo0Rr/Ds1O+vpv8kzreIVzaXr2FwgjQ/MipPKL+JxYC4bAn329mQEOpa6Ky7VBjy
 qpfzJWdvOvMbMACb6c8cVqsHSgZYWTsM7gYnJHSnNNXza+L3wAqSLhgIClBequuaoZ8R
 a9BJ9lgJHsqs/lfkaZIPiW1Y6v8zzOGISsxwZkr/ceVxjfTCKt5g3e2RzyY2ytzJ969Z
 Iuo7oTzQVEog543lhQ9fVgaAtHZk5LYKyrndey6nLACYxGLT4PdWq5BCteyBAmeFELyO
 8RwA3ln39aSxeoeWZBCEek/X1VJaXZnLIt0CWl/nJ5QEOVuZdpe1DrT+4/6JXZhu9znF 9g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2smsk55syx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 May 2019 18:22:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4MILhUW043670;
        Wed, 22 May 2019 18:22:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2smsgv13ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 May 2019 18:22:25 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4MIMOoo045618;
        Wed, 22 May 2019 18:22:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2smsgv13aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 May 2019 18:22:24 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4MIMI50023367;
        Wed, 22 May 2019 18:22:18 GMT
Received: from localhost (/10.159.211.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 May 2019 18:22:17 +0000
Date:   Wed, 22 May 2019 14:22:15 -0400
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kris Van Hees <kris.van.hees@oracle.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190522182215.GO2422@oracle.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
 <20190522142531.GE16275@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522142531.GE16275@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9265 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905220128
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 04:25:32PM +0200, Peter Zijlstra wrote:
> On Tue, May 21, 2019 at 10:56:18AM -0700, Alexei Starovoitov wrote:
> 
> > and no changes are necessary in kernel/events/ring_buffer.c either.
> 
> Let me just NAK them on the principle that I don't see them in my inbox.

My apologies for failing to include you on the Cc for the patches.  That was
an oversight on my end and certainly not intentional.

> Let me further NAK it for adding all sorts of garbage to the code --
> we're not going to do gaps and stay_in_page nonsense.

Could you give some guidance in terms of an alternative?  The ring buffer code
provides both non-contiguous page allocation support and a vmalloc-based
allocation, and the vmalloc version certainly would avoid the entire gap and
page boundary stuff.  But since the allocator is chosen at build time based on
the arch capabilities, there is no way to select a specific memory allocator.
I'd be happy to use an alternative approach that allows direct writing into
the ring buffer.

	Thanks,
	Kris
