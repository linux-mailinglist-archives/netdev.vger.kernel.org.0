Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2538233C6A
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 02:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730859AbgGaAHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 20:07:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:46030 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730786AbgGaAHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 20:07:46 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k1IaM-0007C3-P9; Fri, 31 Jul 2020 02:07:42 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k1IaM-0007Me-IO; Fri, 31 Jul 2020 02:07:42 +0200
Subject: Re: [PATCH net] net/bpfilter: initialize pos in
 __bpfilter_process_sockopt
To:     Christian Brauner <christian.brauner@ubuntu.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Rodrigo Madera <rodrigo.madera@gmail.com>
References: <20200730160900.187157-1-hch@lst.de>
 <20200730161303.erzgrhqsgc77d4ny@wittgenstein>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <03954b8f-0db7-427b-cfd6-7146da9b5466@iogearbox.net>
Date:   Fri, 31 Jul 2020 02:07:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200730161303.erzgrhqsgc77d4ny@wittgenstein>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25889/Thu Jul 30 17:03:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/20 6:13 PM, Christian Brauner wrote:
> On Thu, Jul 30, 2020 at 06:09:00PM +0200, Christoph Hellwig wrote:
>> __bpfilter_process_sockopt never initialized the pos variable passed to
>> the pipe write.  This has been mostly harmless in the past as pipes
>> ignore the offset, but the switch to kernel_write no verified the
> 
> s/no/now/
> 
>> position, which can lead to a failure depending on the exact stack
>> initialization patter.  Initialize the variable to zero to make
> 
> s/patter/pattern/
> 
>> rw_verify_area happy.
>>
>> Fixes: 6955a76fbcd5 ("bpfilter: switch to kernel_write")
>> Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
>> Reported-by: Rodrigo Madera <rodrigo.madera@gmail.com>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> Tested-by: Rodrigo Madera <rodrigo.madera@gmail.com>
>> ---
> 
> Thanks for tracking this down, Christoph! This fixes the logging issue
> for me.
> Tested-by: Christian Brauner <christian.brauner@ubuntu.com>
> Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>

Applied to bpf & fixed up the typos in the commit msg, thanks everyone!
