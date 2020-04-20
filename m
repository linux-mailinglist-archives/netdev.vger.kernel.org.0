Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E061B0DE4
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 16:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgDTOHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 10:07:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54223 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726871AbgDTOHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 10:07:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587391620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WMuzcbIEoiVWqH25jsj0sUd4E7myG3+91xrafhledhw=;
        b=AOatA+f8p1/A0Nko1qISKeE44YD/6tHyxU8kzWpnhfRls2tALf+VBM23eMdWfj1jipqc/+
        S7ElmYNiYwkr+Rl3Q9MJF3DmD1/tY+xnTyeLh6fI3ngh0oKxXSvxSvKZaHfo8NS/bJP4wB
        tvBlUd0wKZPXI0MwPPSHjW85fWGkYUM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-PQl3FshfNZW_fNpE-38o4Q-1; Mon, 20 Apr 2020 10:06:58 -0400
X-MC-Unique: PQl3FshfNZW_fNpE-38o4Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BED0413F8;
        Mon, 20 Apr 2020 14:06:56 +0000 (UTC)
Received: from [10.10.112.203] (ovpn-112-203.rdu2.redhat.com [10.10.112.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB1385C1B2;
        Mon, 20 Apr 2020 14:06:52 +0000 (UTC)
Subject: Re: [PATCH] tipc: Remove redundant tsk->published flag
To:     George Spelvin <lkml@SDF.ORG>, David Miller <davem@davemloft.net>
Cc:     tung.q.nguyen@dektech.com.au, ying.xue@windriver.com,
        netdev@vger.kernel.org
References: <202004160327.03G3RZLv012120@sdf.org>
 <20200418.153211.649575253431491187.davem@davemloft.net>
 <20200419085657.GA26904@SDF.ORG>
From:   Jon Maloy <jmaloy@redhat.com>
Message-ID: <373a8c45-7438-4e28-e8ad-f3464928bdb5@redhat.com>
Date:   Mon, 20 Apr 2020 10:06:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200419085657.GA26904@SDF.ORG>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/19/20 4:56 AM, George Spelvin wrote:
> On Sat, Apr 18, 2020 at 03:32:11PM -0700, David Miller wrote:
>> From: George Spelvin <lkml@sdf.org>
>> Date: Thu, 16 Apr 2020 03:27:35 GMT
[...]
>> Please preserve the reverse christmas tree ordering of local variables
>> here.
> Happy to, but is that actually defined anywhere?  "Preserve" implies that
> it was present before the patch, and I can't infer a rule which is obeyed
> by the pre-patch declarations:

It all depends on the age of the code. In newer code, we always follow
the rule, and when refactoring old code at least I try to adapt to this
rule even at the cost of reshuffling a few declarations. It is risk free,
- you only have to watch out for dependencies.

> 	int i = 0;
> 	size_t sz = (dqueues) ? SK_LMAX : SK_LMIN;
> 	struct tipc_sock *tsk;
> 	struct publication *p;
> 	bool tsk_connected;
>
> One option is to sort by the full line length, including initialization:
> 	size_t sz = (dqueues) ? SK_LMAX : SK_LMIN;
> 	struct tipc_sock *tsk;
> 	struct publication *p;
> 	bool tsk_connected;
> 	int i = 0;
This is the preferred order, AFAIK.

///jon

