Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7C83D8805
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 08:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234578AbhG1GfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 02:35:02 -0400
Received: from gateway32.websitewelcome.com ([192.185.145.171]:17613 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234237AbhG1GfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 02:35:00 -0400
X-Greylist: delayed 1366 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jul 2021 02:35:00 EDT
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id A72D8AE7DB
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 01:12:11 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 8cnbmKvtLoIHn8cnbmV3ks; Wed, 28 Jul 2021 01:12:11 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/gCRywG3p9gdzDsdnfCiyJuRt7hlhcIRTlf1DfYGxQk=; b=VcIfYrm9dG72K/ZQdtfuvuRlxT
        V3vj8YAhGaZx/cGjli4zOBFYlJLoXo0Vsd02K5fRjcNQP9NIaIESg+YOXV99qTCB2Yo/O/8WHP1ds
        tXZbD1nJiwP3eEvBBTiZUo+VuIrDMlwm0ktVaXENnRTX4JuI9vlmD7ltgDRPbsHiRknznvoYhhE9n
        E8MtFRCudEt5DeNW0MrlXGslPCSnGcfJ5OUAGOu7TVmX7V7cwyVfPVrDjuE3onf3wAwUBuIo0NmMx
        IpJTghBwcX95Gj2Ml9t6eR6MSITfuKehPikhPibC8RrQ3I91RzhVBZtQ0/pRauPtwPnnaJk7AevGt
        aQE41uZw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:44814 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1m8cna-003PI6-Vi; Wed, 28 Jul 2021 01:12:11 -0500
Subject: Re: [PATCH 19/64] ip: Use struct_group() for memcpy() regions
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-20-keescook@chromium.org> <YQDxaYrHu0PeBIuX@kroah.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <baead202-569f-775f-348c-aa64e69f03ed@embeddedor.com>
Date:   Wed, 28 Jul 2021 01:14:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YQDxaYrHu0PeBIuX@kroah.com>
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
X-Exim-ID: 1m8cna-003PI6-Vi
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:44814
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 9
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 00:55, Greg Kroah-Hartman wrote:
> On Tue, Jul 27, 2021 at 01:58:10PM -0700, Kees Cook wrote:
>> In preparation for FORTIFY_SOURCE performing compile-time and run-time
>> field bounds checking for memcpy(), memmove(), and memset(), avoid
>> intentionally writing across neighboring fields.
>>
>> Use struct_group() in struct flowi4, struct ipv4hdr, and struct ipv6hdr
>> around members saddr and daddr, so they can be referenced together. This
>> will allow memcpy() and sizeof() to more easily reason about sizes,
>> improve readability, and avoid future warnings about writing beyond the
>> end of saddr.
>>
>> "pahole" shows no size nor member offset changes to struct flowi4.
>> "objdump -d" shows no meaningful object code changes (i.e. only source
>> line number induced differences.)
>>
>> Note that since this is a UAPI header, struct_group() has been open
>> coded.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  include/net/flow.h            |  6 ++++--
>>  include/uapi/linux/if_ether.h | 12 ++++++++++--
>>  include/uapi/linux/ip.h       | 12 ++++++++++--
>>  include/uapi/linux/ipv6.h     | 12 ++++++++++--
>>  net/core/flow_dissector.c     | 10 ++++++----
>>  net/ipv4/ip_output.c          |  6 ++----
>>  6 files changed, 42 insertions(+), 16 deletions(-)
>>
>> diff --git a/include/net/flow.h b/include/net/flow.h
>> index 6f5e70240071..f1a3b6c8eae2 100644
>> --- a/include/net/flow.h
>> +++ b/include/net/flow.h
>> @@ -81,8 +81,10 @@ struct flowi4 {
>>  #define flowi4_multipath_hash	__fl_common.flowic_multipath_hash
>>  
>>  	/* (saddr,daddr) must be grouped, same order as in IP header */
>> -	__be32			saddr;
>> -	__be32			daddr;
>> +	struct_group(addrs,
>> +		__be32			saddr;
>> +		__be32			daddr;
>> +	);
>>  
>>  	union flowi_uli		uli;
>>  #define fl4_sport		uli.ports.sport
>> diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
>> index a0b637911d3c..8f5667b2ea92 100644
>> --- a/include/uapi/linux/if_ether.h
>> +++ b/include/uapi/linux/if_ether.h
>> @@ -163,8 +163,16 @@
>>  
>>  #if __UAPI_DEF_ETHHDR
>>  struct ethhdr {
>> -	unsigned char	h_dest[ETH_ALEN];	/* destination eth addr	*/
>> -	unsigned char	h_source[ETH_ALEN];	/* source ether addr	*/
>> +	union {
>> +		struct {
>> +			unsigned char h_dest[ETH_ALEN];	  /* destination eth addr */
>> +			unsigned char h_source[ETH_ALEN]; /* source ether addr	  */
>> +		};
>> +		struct {
>> +			unsigned char h_dest[ETH_ALEN];	  /* destination eth addr */
>> +			unsigned char h_source[ETH_ALEN]; /* source ether addr	  */
>> +		} addrs;
> 
> A union of the same fields in the same structure in the same way?
> 
> Ah, because struct_group() can not be used here?  Still feels odd to see
> in a userspace-visible header.
> 
>> +	};
>>  	__be16		h_proto;		/* packet type ID field	*/
>>  } __attribute__((packed));
>>  #endif
>> diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
>> index e42d13b55cf3..33647a37e56b 100644
>> --- a/include/uapi/linux/ip.h
>> +++ b/include/uapi/linux/ip.h
>> @@ -100,8 +100,16 @@ struct iphdr {
>>  	__u8	ttl;
>>  	__u8	protocol;
>>  	__sum16	check;
>> -	__be32	saddr;
>> -	__be32	daddr;
>> +	union {
>> +		struct {
>> +			__be32	saddr;
>> +			__be32	daddr;
>> +		} addrs;
>> +		struct {
>> +			__be32	saddr;
>> +			__be32	daddr;
>> +		};
> 
> Same here (except you named the first struct addrs, not the second,
> unlike above).
> 
> 
>> +	};
>>  	/*The options start here. */
>>  };
>>  
>> diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
>> index b243a53fa985..1c26d32e733b 100644
>> --- a/include/uapi/linux/ipv6.h
>> +++ b/include/uapi/linux/ipv6.h
>> @@ -130,8 +130,16 @@ struct ipv6hdr {
>>  	__u8			nexthdr;
>>  	__u8			hop_limit;
>>  
>> -	struct	in6_addr	saddr;
>> -	struct	in6_addr	daddr;
>> +	union {
>> +		struct {
>> +			struct	in6_addr	saddr;
>> +			struct	in6_addr	daddr;
>> +		} addrs;
>> +		struct {
>> +			struct	in6_addr	saddr;
>> +			struct	in6_addr	daddr;
>> +		};
> 
> addrs first?  Consistancy is key :)

I think addrs should be second. In general, I think all newly added
non-anonymous structures should be second.

Thanks
--
Gustavo
