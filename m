Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E178194878
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 21:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbgCZUOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 16:14:44 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:51976 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgCZUOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 16:14:44 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02QKEeaD034295;
        Thu, 26 Mar 2020 15:14:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1585253680;
        bh=/hiNc32oAn99+EkX8tTkuyw258yWvcvbz/j5ciBIP4w=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=qLmdwtzOPKxpGhr7HIGOEPQ5R79JH4CmuEq3hWOdGZjX3NFMheP8+9OFVuGgNUdkM
         yCefOG3eaA33eDU5sEJ78b0TJit8jaEkG8uJ3dpnA08oa4g2jIkXPbk2dwEc5Sn4QQ
         3mIbYUJa0uV1tdcPdZGnWWgzCZ4dzW7hIi+sfd44=
Received: from DFLE106.ent.ti.com (dfle106.ent.ti.com [10.64.6.27])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02QKEdq2049378;
        Thu, 26 Mar 2020 15:14:39 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 26
 Mar 2020 15:14:39 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 26 Mar 2020 15:14:39 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02QKEab7029539;
        Thu, 26 Mar 2020 15:14:37 -0500
Subject: Re: [PATCH net-next v3 02/11] net: ethernet: ti: cpts: separate hw
 counter read from timecounter
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200320194244.4703-1-grygorii.strashko@ti.com>
 <20200320194244.4703-3-grygorii.strashko@ti.com>
 <20200326141804.GC20841@localhost>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <3f319e48-d955-c821-7bed-c85c634976f1@ti.com>
Date:   Thu, 26 Mar 2020 22:14:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200326141804.GC20841@localhost>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/03/2020 16:18, Richard Cochran wrote:
> On Fri, Mar 20, 2020 at 09:42:35PM +0200, Grygorii Strashko wrote:
>> Separate hw counter read from timecounter code:
>> - add CPTS context field to store current HW counter value
>> - move HW timestamp request and FIFO read code out of timecounter code
>> - convert cyc2time on event reception in cpts_fifo_read()
>> - call timecounter_read() in cpts_fifo_read() to update tk->cycle_last
> 
> This comment tells us WHAT the patch does, but does not help because
> we can see that from the patch itself.  Instead, the comment should
> tell us WHY is change is needed.
> 
> I was left scratching my head, with the question, what is the purpose
> here?  Maybe the answer is to be found later on in the series.
> 
> Here is commit message pattern to follow that I learned from tglx:
> 
> 1. context
> 2. problem
> 3. solution
> 
> For this patch, the sentence, "Separate hw counter read from
> timecounter code" is #3.

Sorry, will update.

-- 
Best regards,
grygorii
