Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E126D5804
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 22:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbfJMURW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 16:17:22 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38049 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbfJMURV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 16:17:21 -0400
Received: by mail-pg1-f195.google.com with SMTP id w3so1917404pgt.5;
        Sun, 13 Oct 2019 13:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s90sNIFFQ7PmHxc2cwoGubvccMDisjiP9XcP/kL6H3U=;
        b=kbLagcUvUthkSmMZrG4t2XQFxKvdJYKm68dbcxa0Fv9QBw7WxBPkrSAMJHaWvvRrQf
         bQE+N1tQnyuX0iSc9UA4z8wsL8ijNyZ0lQcaETGYn5v1krHwVyw9khT5HlK3M+xWKtX4
         5Q3Mj+AJK0y55nx1sHRMmHv1VwiNRBrENGdp2hKBNSXJjktp36+4Vt4349KUxoJM8Phu
         WvRd4GdNPp8Atpd3KwO2kTof1/AJHrNKfKdrujx9is81mqnERmAVf2rq6bqrAc8rouPi
         AHq6aeTjsi6PpaWm+QSK4awJTmIzEyyQ31WEeUvTq6EcnaTTh4Dp9R6gdx+om8hBAfUb
         /pMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s90sNIFFQ7PmHxc2cwoGubvccMDisjiP9XcP/kL6H3U=;
        b=bJK9uFAkJ1Ncg1cKLEvv3NauxR/kzRCuN9SQKlsPbUw1TiQv2LeAn8AOzhPeR9I7rC
         Duy/ZhKvbEiVIpMdGXJimpCmqc5roqujF/cIuMTQGPCfg7hPNR5mxA2xvZB2MFS7GRzl
         D23lWnvsHZf1M9lSckPA9GcEhnP+uACgIE1LbmTpdOdXstPeJdgxPHE6fx0dkOuSK6sL
         3FDuQGwpJ7JqGEqBSZaPW4VJPXrTlaCYD/3OMvP9zLY6+1KErXd5zNTF4Bvtf59RESBC
         4kw575ZJoVNChmTv8kSbqiHCB2uOL2YV1AYAsZdAUWIXJLyMNHwrWdYR68gVPYIf9P+9
         1Uag==
X-Gm-Message-State: APjAAAXR2G7XvzMnDLnOTST5z03iEpkzhh1qMMggiwrwflL3IEku30gm
        MDwys0tWx7gbwoz5I2pYwikcPPJO
X-Google-Smtp-Source: APXvYqxlxH71wYXBZ/doH/v7+W7VTQYsxuFemZ1vZLBM4/U3hlPzEn71t9/cV2Bg6CzY0Xewp8lkMg==
X-Received: by 2002:a17:90a:8d06:: with SMTP id c6mr30531780pjo.141.1570997840317;
        Sun, 13 Oct 2019 13:17:20 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id 6sm13693774pgl.40.2019.10.13.13.17.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Oct 2019 13:17:19 -0700 (PDT)
Subject: Re: [PATCH] net: core: datagram: tidy up copy functions a bit
To:     Vito Caputo <vcaputo@pengaru.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191012115509.jrqe43yozs7kknv5@shells.gnugeneration.com>
 <8fab6f9c-70a6-02fd-5b2d-66a013c10a4f@gmail.com>
 <20191013200158.mhvwkdnsjk7ecuqu@shells.gnugeneration.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6864f888-1b62-36c5-6ac5-d5db01c5fcfb@gmail.com>
Date:   Sun, 13 Oct 2019 13:17:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191013200158.mhvwkdnsjk7ecuqu@shells.gnugeneration.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/13/19 1:01 PM, Vito Caputo wrote:
> On Sun, Oct 13, 2019 at 12:30:41PM -0700, Eric Dumazet wrote:
>>
>>
>> On 10/12/19 4:55 AM, Vito Caputo wrote:
>>> Eliminate some verbosity by using min() macro and consolidating some
>>> things, also fix inconsistent zero tests (! vs. == 0).
>>>
>>> Signed-off-by: Vito Caputo <vcaputo@pengaru.com>
>>> ---
>>>  net/core/datagram.c | 44 ++++++++++++++------------------------------
>>>  1 file changed, 14 insertions(+), 30 deletions(-)
>>>
>>> diff --git a/net/core/datagram.c b/net/core/datagram.c
>>> index 4cc8dc5db2b7..08d403f93952 100644
>>> --- a/net/core/datagram.c
>>> +++ b/net/core/datagram.c
>>> @@ -413,13 +413,11 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
>>>  					    struct iov_iter *), void *data)
>>>  {
>>>  	int start = skb_headlen(skb);
>>> -	int i, copy = start - offset, start_off = offset, n;
>>> +	int i, copy, start_off = offset, n;
>>>  	struct sk_buff *frag_iter;
>>>  
>>>  	/* Copy header. */
>>> -	if (copy > 0) {
>>> -		if (copy > len)
>>> -			copy = len;
>>> +	if ((copy = min(start - offset, len)) > 0) {
>>
>> No, we prefer not having this kind of construct anymore.
>>
>> This refactoring looks unnecessary code churn, making our future backports not
>> clean cherry-picks.
>>
>> Simply making sure this patch does not bring a regression is very time consuming.
> 
> Should I not bother submitting patches for such cleanups?
> 
> I submitted another, more trivial patch, is it also considered unnecessary churn:
> 
> ---
> 
> Author: Vito Caputo <vcaputo@pengaru.com>
> Date:   Sat Oct 12 17:10:41 2019 -0700
> 
>     net: core: skbuff: skb_checksum_setup() drop err
>     
>     Return directly from all switch cases, no point in storing in err.
>     
>     Signed-off-by: Vito Caputo <vcaputo@pengaru.com>
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index f5f904f46893..c59b68a413b5 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -4888,23 +4888,14 @@ static int skb_checksum_setup_ipv6(struct sk_buff *skb, bool recalculate)
>   */
>  int skb_checksum_setup(struct sk_buff *skb, bool recalculate)
>  {
> -       int err;
> -
>         switch (skb->protocol) {
>         case htons(ETH_P_IP):
> -               err = skb_checksum_setup_ipv4(skb, recalculate);
> -               break;
> -
> +               return skb_checksum_setup_ipv4(skb, recalculate);
>         case htons(ETH_P_IPV6):
> -               err = skb_checksum_setup_ipv6(skb, recalculate);
> -               break;
> -
> +               return skb_checksum_setup_ipv6(skb, recalculate);
>         default:
> -               err = -EPROTO;
> -               break;
> +               return -EPROTO;
>         }
> -
> -       return err;
>  }
>  EXPORT_SYMBOL(skb_checksum_setup);
> 
> ---
> 
> Asking to calibrate my thresholds to yours, since I was planning to volunteer
> some time each evening to reading kernel code and submitting any obvious
> cleanups.
> 

This is not a cleanup.

You prefer seeing the code written the way you did, but that is really a matter of taste.

Think about backports of real bug fixes to stable kernels.

Having these re-writes of code make things less easy for us really.
So in general we tend to leave the existing code style.

I already replied to the other patch submission, please read

https://marc.info/?l=linux-netdev&m=157099669227635&w=2


