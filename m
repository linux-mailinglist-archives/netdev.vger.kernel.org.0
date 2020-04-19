Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E701AF8D8
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 10:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgDSI5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 04:57:20 -0400
Received: from mx.sdf.org ([205.166.94.20]:60013 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgDSI5U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 04:57:20 -0400
Received: from sdf.org (IDENT:lkml@sdf.lonestar.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 03J8uxSH025923
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Sun, 19 Apr 2020 08:57:00 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 03J8uvCU003295;
        Sun, 19 Apr 2020 08:56:57 GMT
Date:   Sun, 19 Apr 2020 08:56:57 +0000
From:   George Spelvin <lkml@SDF.ORG>
To:     David Miller <davem@davemloft.net>
Cc:     tung.q.nguyen@dektech.com.au, jmaloy@redhat.com,
        ying.xue@windriver.com, netdev@vger.kernel.org, lkml@sdf.org
Subject: Re: [PATCH] tipc: Remove redundant tsk->published flag
Message-ID: <20200419085657.GA26904@SDF.ORG>
References: <202004160327.03G3RZLv012120@sdf.org>
 <20200418.153211.649575253431491187.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200418.153211.649575253431491187.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 03:32:11PM -0700, David Miller wrote:
> From: George Spelvin <lkml@sdf.org>
> Date: Thu, 16 Apr 2020 03:27:35 GMT
> 
>> @@ -3847,7 +3839,7 @@ int tipc_sk_dump(struct sock *sk, u16 dqueues, char *buf)
>>  	size_t sz = (dqueues) ? SK_LMAX : SK_LMIN;
>>  	struct tipc_sock *tsk;
>>  	struct publication *p;
>> -	bool tsk_connected;
>> +	bool tsk_connected, tsk_published;
>>  
> 
> Please preserve the reverse christmas tree ordering of local variables
> here.

Happy to, but is that actually defined anywhere?  "Preserve" implies that 
it was present before the patch, and I can't infer a rule which is obeyed 
by the pre-patch declarations:
	int i = 0;
	size_t sz = (dqueues) ? SK_LMAX : SK_LMIN;
	struct tipc_sock *tsk;
	struct publication *p;
	bool tsk_connected;

One option is to sort by the full line length, including initialization:
	size_t sz = (dqueues) ? SK_LMAX : SK_LMIN;
	struct tipc_sock *tsk;
	struct publication *p;
	bool tsk_connected;
	int i = 0;

The other is to sort by the *declaration* length:
	struct tipc_sock *tsk;
	struct publication *p;
	bool tsk_connected;
	size_t sz = (dqueues) ? SK_LMAX : SK_LMIN;
	int i = 0;

Looking at the local variable declarations in the rest of the file isn't
producing any clarity.

Thank you.
