Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81BB7367A4
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 00:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfFEWyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 18:54:21 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:60447 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfFEWyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 18:54:21 -0400
Received: from [192.168.1.110] ([77.2.1.21]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MekKJ-1h0xvT2Kwv-00aph6; Thu, 06 Jun 2019 00:53:22 +0200
Subject: Re: [PATCH] net: sctp: drop unneeded likely() call around IS_ERR()
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, vyasevich@gmail.com,
        nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
References: <1559768607-17439-1-git-send-email-info@metux.net>
 <20190605215026.GB3778@localhost.localdomain>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Organization: metux IT consult
Message-ID: <56e6ad8c-28b7-9f19-d8fa-a4857b694a1d@metux.net>
Date:   Wed, 5 Jun 2019 22:53:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190605215026.GB3778@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:rXUa6Pc6LMtEftx6VNBQm0VUE3tjcpKDqWWB45fQH9jCYPz2asS
 ctZSUm2wOOiCmYdX7Avhczn7F4kOpjgkDkoUbQYeNi95kaWBJb44halmQfSPdIOn0OVJMMd
 Whh7MHrzW8U3YyFhYQyfd6GZKeTL64es1QBztdZm54hjqn/XphsK8xRDApn1JhKZ+g1cQFB
 tpcumnfFtgHSCSqrc/aww==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:f2CbOOWLVG4=:VbWsfg2E6BvhPcXY6NtKpx
 4OtNhSBESV8w2DlbB+LAIulIEK0J2kKe+k6gKPOAgGMkKXbxHccF+HUsAWX19trSpdE7+7L1Y
 BgQ0A+jm5/XqX/jl8+5zGDFJFu+of1N8O+x191wNPi5vwkHDRaBd7zHk73WqHl2BdJ62bScxK
 YE7hDcAElBhnNrnIQvx66FGo99k+sunRHaupCm0hqshp+LcOdpTaTe04Z4V4qDtxY31dnuUoN
 O1U+VfzM+oI7Vy/0T2QJcw772Pqgrd8G50qhATSIV7qlfMtlYSyoPG9ZwrJz6dQuRdhKLrARJ
 uyqSnHsmX5Ar4vQK4hLfI0eHve9bY0yhUoM/Sx8NauF7elXCWU6yTnqFReZp2+kzRicQDsAlR
 GSfWrV/NPDowxQGorwjbYzBqFYt77gLGxhhgPUpnk7DHTPeJZLoS7naZVuofdpiw5ukr3lx2o
 IZCsOGanArdnjW13fq+VPtlPUihvynNofbeEnUJ5SFF02NrXzF9qct6oPOAuRgsusOwnypgeR
 NX4I7+cS5km3AUtTJ96WHVoL2eoxix1jnzdNdK8396N/2BO8v0nOXvgVOD6zhXP4qMH1NddrB
 mquswMK05SR6VFS12b8JG6hSpz6iIZSMxMGuvSIu3iH067urDJuGKfW5nE3xaT/dOGykXXfWu
 vIjlvBU9j3LKEQYE9Lbe6JINpCPgiTibaeDPQmQ5AHLFIei79vk9a5o54LvuhnrL8dcpR+mAG
 jzqx5QruneOoEO9lVZ++mS9B3k42EhqOrEjDzuYUKTjhSjKvdfxSCROjsGg=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.06.19 21:50, Marcelo Ricardo Leitner wrote:
> On Wed, Jun 05, 2019 at 11:03:27PM +0200, Enrico Weigelt, metux IT consult wrote:
>> From: Enrico Weigelt <info@metux.net>
>>
>> IS_ERR() already calls unlikely(), so this extra unlikely() call
>> around IS_ERR() is not needed.
>>
>> Signed-off-by: Enrico Weigelt <info@metux.net>
> 
> Hi,
> 
> This patch overlaps with
> Jun 05 Kefeng Wang     (4.4K) [PATCH net-next] net: Drop unlikely before IS_ERR(_OR_NULL)

I've missed Kefeng's patch ... feel free to ignore mine.


--mtx


-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
