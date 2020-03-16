Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8331186ACB
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 13:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730959AbgCPMXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 08:23:52 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:52740 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730878AbgCPMXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 08:23:52 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02GCNWG8055256;
        Mon, 16 Mar 2020 07:23:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584361412;
        bh=/axxTSN4rOjW8bh6Kbh93WtVu/tmmhKSGynWOWCPzuY=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=vSg0a1+QKByxeZQ7KBTjfgkxDI9IEY9zlUWk/fQEdnbGDiw7iS+KNJxMY7pblqv91
         xcRc9iE/EmWBlfMtFx29z1Q7oLaJDwW3ojWz/gBihLpbblaWUvjPcymhZ6fkd6lTnK
         L6gF9F4A/jU3aB+ibd8fH0XVfsLOOvs8npPetIlU=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02GCNWpJ082049;
        Mon, 16 Mar 2020 07:23:32 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 16
 Mar 2020 07:23:32 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 16 Mar 2020 07:23:32 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02GCNS4R121266;
        Mon, 16 Mar 2020 07:23:29 -0500
Subject: Re: [PATCH] kthread: Mark timer used by delayed kthread works as IRQ
 safe
To:     Tejun Heo <tj@kernel.org>, Petr Mladek <pmladek@suse.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        <linux-rt-users@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>
References: <20200217120709.1974-1-pmladek@suse.com>
 <20200219152248.GC698990@mtj.thefacebook.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <6a4c07df-8971-8637-5251-ce177c3a08ce@ti.com>
Date:   Mon, 16 Mar 2020 14:23:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200219152248.GC698990@mtj.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Petr,

On 19/02/2020 17:22, Tejun Heo wrote:
> On Mon, Feb 17, 2020 at 01:07:09PM +0100, Petr Mladek wrote:
>> The timer used by delayed kthread works are IRQ safe because the used
>> kthread_delayed_work_timer_fn() is IRQ safe.
>>
>> It is properly marked when initialized by KTHREAD_DELAYED_WORK_INIT().
>> But TIMER_IRQSAFE flag is missing when initialized by
>> kthread_init_delayed_work().
>>
>> The missing flag might trigger invalid warning from del_timer_sync()
>> when kthread_mod_delayed_work() is called with interrupts disabled.
>>
>> Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> Signed-off-by: Petr Mladek <pmladek@suse.com>
>> Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>

I'm worry shouldn't this patch have "fixes" tag?

-- 
Best regards,
grygorii
