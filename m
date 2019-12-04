Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1241128DD
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 11:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfLDKHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 05:07:32 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:57020 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbfLDKHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 05:07:32 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB4A7Pu0018610;
        Wed, 4 Dec 2019 04:07:25 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575454045;
        bh=GrVPGGlcZalggTrbWtDuRaXy7O+InNgDeEGcUp2l7pA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=bWaM+jWJaJMAgjY8IjL+Q/ox2HuHQZhVyQCk0f/S8xDoOWhRWXF7Co2PbWrHJB6O6
         la6Yp0QttWg4HYm06NjxWHxhPJB2Vaz3K1DyyQKg6QiF9iudJ0+7Iibnk06dttN7ZN
         6vycXUJp+x4/WqSwzuI5YTGl4gZ2pUvOfoo/WxkU=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB4A7P6n077186;
        Wed, 4 Dec 2019 04:07:25 -0600
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 4 Dec
 2019 04:07:25 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 4 Dec 2019 04:07:24 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB4A7Nue121457;
        Wed, 4 Dec 2019 04:07:23 -0600
Subject: Re: [net PATCH] xdp: obtain the mem_id mutex before trying to remove
 an entry.
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <kernel-team@fb.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20191203220114.1524992-1-jonathan.lemon@gmail.com>
 <20191204093240.581543f3@carbon>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <64b28372-e203-92db-bc67-1c308334042f@ti.com>
Date:   Wed, 4 Dec 2019 12:07:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191204093240.581543f3@carbon>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04/12/2019 10:32, Jesper Dangaard Brouer wrote:
> On Tue, 3 Dec 2019 14:01:14 -0800
> Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> 
>> A lockdep splat was observed when trying to remove an xdp memory
>> model from the table since the mutex was obtained when trying to
>> remove the entry, but not before the table walk started:
>>
>> Fix the splat by obtaining the lock before starting the table walk.
>>
>> Fixes: c3f812cea0d7 ("page_pool: do not release pool until inflight == 0.")
>> Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> 
> Have you tested if this patch fix the problem reported by Grygorii?
> 
> Link: https://lore.kernel.org/netdev/c2de8927-7bca-612f-cdfd-e9112fee412a@ti.com
> 
> Grygorii can you test this?

Thanks.
I do not see this trace any more and networking is working after if down/up

Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>


-- 
Best regards,
grygorii
