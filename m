Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D714362923
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 22:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245419AbhDPUQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 16:16:54 -0400
Received: from gateway32.websitewelcome.com ([192.185.145.108]:16956 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244908AbhDPUQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 16:16:53 -0400
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 14EC89C2BF
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 15:16:25 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id XUt7lMeaAb8LyXUt7lSdYa; Fri, 16 Apr 2021 15:16:25 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mk2pez5sUEyFBM3Ffood7KCNM41oWHQx1y7+7W8SBlg=; b=B5smeeutWe6rbwzeBVjvOdUySq
        pPuBrwtisxQGGRLSsYX8WcLGIQYALNDD+JZVAkaxGem8QP6PFKutPqhjKsU5o1+BMmfIpY7d2o15G
        htpEXtaN0bgj2JtGMtceVHiPkJZ8zDhlZbNXGwOk8/Tmbn0b+xP6YtRY/lNq0Cjr9YK0elI8Rscm3
        JJC+/wmXddah84TfmvOBkpSKdB+o+nz1SSFzMIbn0rqJrgBvZ3Yw+2PjSCBNNKfXL511lrb8PSk+E
        UGBc/6scBtJ2sMCKwXzziqMjOGUx4LHXkQ6tEoYyTIsG9GhFkxWJsgYEETB1iuOVlJLmL8hm9ZI4m
        qTpgNS8g==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:55580 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lXUt2-003AWq-R3; Fri, 16 Apr 2021 15:16:20 -0500
Subject: Re: [PATCH][next] sctp: Fix out-of-bounds warning in
 sctp_process_asconf_param()
To:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210416191236.GA589296@embeddedor>
 <202104161249.D889C975D9@keescook>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <d9c17b72-51e8-8572-e905-c850b0bb9294@embeddedor.com>
Date:   Fri, 16 Apr 2021 15:16:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <202104161249.D889C975D9@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lXUt2-003AWq-R3
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:55580
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 9
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 14:53, Kees Cook wrote:
> On Fri, Apr 16, 2021 at 02:12:36PM -0500, Gustavo A. R. Silva wrote:
>> Fix the following out-of-bounds warning:
>>
>> net/sctp/sm_make_chunk.c:3150:4: warning: 'memcpy' offset [17, 28] from the object at 'addr' is out of the bounds of referenced subobject 'v4' with type 'struct sockaddr_in' at offset 0 [-Warray-bounds]
>>
>> This helps with the ongoing efforts to globally enable -Warray-bounds
>> and get us closer to being able to tighten the FORTIFY_SOURCE routines
>> on memcpy().
>>
>> Link: https://github.com/KSPP/linux/issues/109
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> Yup!

:)

> Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks, Kees.

--
Gustavo
