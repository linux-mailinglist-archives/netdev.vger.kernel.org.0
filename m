Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD48135627
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 10:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbgAIJuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 04:50:19 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:58998 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729170AbgAIJuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 04:50:19 -0500
Received: from fsav101.sakura.ne.jp (fsav101.sakura.ne.jp [27.133.134.228])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 0099oBAr064529;
        Thu, 9 Jan 2020 18:50:11 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav101.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav101.sakura.ne.jp);
 Thu, 09 Jan 2020 18:50:11 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav101.sakura.ne.jp)
Received: from [192.168.1.9] (softbank126040062084.bbtec.net [126.40.62.84])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 0099o6ii064492
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Thu, 9 Jan 2020 18:50:11 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: commit b9ef5513c99b breaks ping to ipv6 linklocal addresses on
 debian buster
To:     David Ahern <dsahern@gmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <90fbf526-9edc-4e38-f4f7-a4c9e4aff42f@gmail.com>
 <202001060351.0063pLqJ023952@www262.sakura.ne.jp>
 <c0c9ee18-98f6-9888-4b80-c6e3e5a4a4f4@gmail.com>
 <a2612f24-00b7-7e9e-5a9e-d0d82b22ea8e@i-love.sakura.ne.jp>
 <d8bc9dce-fba2-685b-c26a-89ef05aa004a@gmail.com>
 <153de016-8274-5d62-83fe-ce7d8218f906@i-love.sakura.ne.jp>
 <3bafff5a-f404-e559-bfd6-bb456a923525@schaufler-ca.com>
 <8e0fd132-4574-4ae7-45ea-88c4a2ec94b2@gmail.com>
 <a730696a-9361-d39e-5dc1-280dc8d0f052@gmail.com>
 <44c7cd8a-7383-dada-e193-bcd79852912d@schaufler-ca.com>
 <b9473f09-d3f9-4f26-67fc-9e9805bec0db@gmail.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <f7177117-ad8b-464b-1c5f-09a11fe1a403@i-love.sakura.ne.jp>
Date:   Thu, 9 Jan 2020 18:50:05 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <b9473f09-d3f9-4f26-67fc-9e9805bec0db@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/01/09 13:06, David Ahern wrote:
> On 1/8/20 4:06 PM, Casey Schaufler wrote:
>> This version should work, I think. Please verify. Thank you.
>>
> 
> It does.
> 

Don't we want to do that check inside smk_ipv6_check() because
smk_ipv6_port_check() might call smk_ipv6_check() ?

smack does not want to call smack_netlabel_send() (as it is IPv4 socket)
when IPv4 address was given on IPv6 socket, does it?

Also, please fold smack_socket_bind() change (make it no-op unless
valid IPv6 address is given) into your patch.
