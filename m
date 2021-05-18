Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13F0386EA6
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 03:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345311AbhERBCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 21:02:31 -0400
Received: from gateway33.websitewelcome.com ([192.185.145.9]:20978 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239539AbhERBCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 21:02:30 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id C1B75B741C
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 20:01:12 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id io6ilAZ3O8uM0io6ilS7c1; Mon, 17 May 2021 20:01:12 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=g9aBbdlWEIXLQ91l3oXZPVNVSDcfsWGvnZBY5r44FHw=; b=phC7PcKu2EfF/L0ObDfrRVu57u
        NmUUFnmFNKyhKdBOCpZQ2d4Byb7bZ20uGqYRChDe6Y2gt3GHIf7dWd53OgQJG9qP9oPVVGZ80duIy
        33ShssOmlZK5WKi+MYOy75ni/bN5BgETuQna3tZatlMfKMUdv7xodXn7KNrTGK8UkSbQ5XIfV0SVU
        Hi573Frstn5Couafpa48R8giz5RzXLVcwmWbS9oOHW8zj0sXM+4iwDJCLjTHk4lwtHX3DIddeQ3KM
        4E8WjeLqNkizaH2V17E3zIQyg6MQhGErcarrH1Zp5VvMLnMi3CEiOblrlE5OL7OPQH4W9THSjtW+m
        i87XNBnQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:53596 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lio6f-002yw1-5y; Mon, 17 May 2021 20:01:09 -0500
Subject: Re: [PATCH RESEND][next] rds: Fix fall-through warnings for Clang
To:     Haakon Bugge <haakon.bugge@oracle.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
References: <20210305090612.GA139288@embeddedor>
 <cd935ba5-a072-5b5a-d455-e06ef87a3a34@embeddedor.com>
 <6AB78D3D-C73D-4633-A6FD-9452DD8E4751@oracle.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <480ab028-5de9-85ea-3dc1-275eba61f544@embeddedor.com>
Date:   Mon, 17 May 2021 20:01:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <6AB78D3D-C73D-4633-A6FD-9452DD8E4751@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lio6f-002yw1-5y
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:53596
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

If you don't mind, I'm taking this in my -next[1] branch for v5.14.

Thanks
--
Gustavo

[1] https://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux.git/log/?h=for-next/kspp

On 5/6/21 01:50, Haakon Bugge wrote:
> Sorry for the delay.
> 
> 
>> On 20 Apr 2021, at 22:10, Gustavo A. R. Silva <gustavo@embeddedor.com> wrote:
>>
>> Hi all,
>>
>> Friendly ping: who can take this, please?
>>
>> Thanks
>> --
>> Gustavo
>>
>> On 3/5/21 03:06, Gustavo A. R. Silva wrote:
>>> In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
>>> warnings by explicitly adding multiple break statements instead of
>>> letting the code fall through to the next case.
>>>
>>> Link: https://github.com/KSPP/linux/issues/115
>>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
> 
> 
> Thxs, Håkon
> 
> 
>>> ---
>>> net/rds/tcp_connect.c | 1 +
>>> net/rds/threads.c     | 2 ++
>>> 2 files changed, 3 insertions(+)
>>>
>>> diff --git a/net/rds/tcp_connect.c b/net/rds/tcp_connect.c
>>> index 4e64598176b0..5461d77fff4f 100644
>>> --- a/net/rds/tcp_connect.c
>>> +++ b/net/rds/tcp_connect.c
>>> @@ -78,6 +78,7 @@ void rds_tcp_state_change(struct sock *sk)
>>> 	case TCP_CLOSE_WAIT:
>>> 	case TCP_CLOSE:
>>> 		rds_conn_path_drop(cp, false);
>>> +		break;
>>> 	default:
>>> 		break;
>>> 	}
>>> diff --git a/net/rds/threads.c b/net/rds/threads.c
>>> index 32dc50f0a303..1f424cbfcbb4 100644
>>> --- a/net/rds/threads.c
>>> +++ b/net/rds/threads.c
>>> @@ -208,6 +208,7 @@ void rds_send_worker(struct work_struct *work)
>>> 		case -ENOMEM:
>>> 			rds_stats_inc(s_send_delayed_retry);
>>> 			queue_delayed_work(rds_wq, &cp->cp_send_w, 2);
>>> +			break;
>>> 		default:
>>> 			break;
>>> 		}
>>> @@ -232,6 +233,7 @@ void rds_recv_worker(struct work_struct *work)
>>> 		case -ENOMEM:
>>> 			rds_stats_inc(s_recv_delayed_retry);
>>> 			queue_delayed_work(rds_wq, &cp->cp_recv_w, 2);
>>> +			break;
>>> 		default:
>>> 			break;
>>> 		}
>>>
> 
