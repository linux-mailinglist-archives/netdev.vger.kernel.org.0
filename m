Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6151104AEE
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 08:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfKUHBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 02:01:25 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:33581 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726165AbfKUHBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 02:01:25 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 0166D4AF62;
        Thu, 21 Nov 2019 18:01:21 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=content-language:x-mailer:content-transfer-encoding
        :content-type:content-type:mime-version:message-id:date:date
        :subject:subject:in-reply-to:references:from:from:received
        :received:received; s=mail_dkim; t=1574319680; bh=Rqenvs+f3rzrhd
        vVd/Oa3kTQjo/RfdTFo+twqYcf8n8=; b=nw4ljZ0Ve2V9Sd8MbY2KcM9cNRMk3B
        v9EWSuAyrk3TVjNVO3ie12W5FBj1kvWKDzpIfQdpWEDsnkallqVYHWtFiqRqv3Ql
        oEXxZh2D/Kz59h6/Tw0uJfcyIGBDnv9nSc3bmlyXEKC8upCy0V9Vj9eqJELwMK8+
        LNi8M1PTBT4OI=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id UoCLqFvz8cCf; Thu, 21 Nov 2019 18:01:20 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 6272C4AF67;
        Thu, 21 Nov 2019 18:01:20 +1100 (AEDT)
Received: from VNLAP288VNPC (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id E1F8D4AF62;
        Thu, 21 Nov 2019 18:01:18 +1100 (AEDT)
From:   "Tuong Lien Tong" <tuong.t.lien@dektech.com.au>
To:     "'David Miller'" <davem@davemloft.net>
Cc:     <jon.maloy@ericsson.com>, <maloy@donjonn.com>,
        <ying.xue@windriver.com>, <netdev@vger.kernel.org>,
        <tipc-discussion@lists.sourceforge.net>
References: <20191121025325.15366-1-tuong.t.lien@dektech.com.au> <20191120.221357.2118936276393168423.davem@davemloft.net>
In-Reply-To: <20191120.221357.2118936276393168423.davem@davemloft.net>
Subject: RE: [net-next v2] tipc: support in-order name publication events
Date:   Thu, 21 Nov 2019 14:01:17 +0700
Message-ID: <00f001d5a039$7a0d7520$6e285f60$@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-us
Thread-Index: AQM1oHj4xz1xzoLoyExHyKnj+7tswgFeNPrxpMo906A=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The fact is we still want to keep it with that explicit meaning, so make the
code easy to understand. Yes, the 'time_after32()' or another macro can give
the same result but makes no sense in this particular scenario. Otherwise,
do you like something such as:

#define publication_after(...) time_after32(...)

BR/Tuong

-----Original Message-----
From: David Miller <davem@davemloft.net> 
Sent: Thursday, November 21, 2019 1:14 PM
To: tuong.t.lien@dektech.com.au
Cc: jon.maloy@ericsson.com; maloy@donjonn.com; ying.xue@windriver.com;
netdev@vger.kernel.org; tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next v2] tipc: support in-order name publication events

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Thu, 21 Nov 2019 09:53:25 +0700

> +static inline int publication_after(struct publication *pa,
> +				    struct publication *pb)
> +{
> +	return ((int)(pb->id - pa->id) < 0);
> +}

Juse use time32_after() et al. instead of reinventing the same exact
code please.

