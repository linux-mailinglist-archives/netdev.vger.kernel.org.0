Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 024C017FCC
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 20:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbfEHS1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 14:27:15 -0400
Received: from uhil19pa10.eemsg.mail.mil ([214.24.21.83]:1698 "EHLO
        uhil19pa10.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728381AbfEHS1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 14:27:15 -0400
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 May 2019 14:27:14 EDT
X-EEMSG-check-017: 410886615|UHIL19PA10_EEMSG_MP8.csd.disa.mil
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by uhil19pa10.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 08 May 2019 18:17:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1557339457; x=1588875457;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Wi0xc9tR+0p1L4rKZ5CyFeJYGTKDY/U+Z9fKx4Cdp4E=;
  b=VON5Ynvd2Al/jNGItLV7Rj+pKc92cFwKkqDhDxoFloQPuyP0C5OCEDZ3
   qdM8C5txrCexsw9mXaVL0iBXOb0NGf8qgFXTIetVST+p4Fjxi45RSCxsl
   9bP1QSpKsMZanxpALzTNli2RteZBjVzgWooto81VCEhaF8ewvLPxNAbVS
   LNVMyyzX57OLnC8tIjVCdNA0XLaxzRVnkIN6CTFuNmZfgsc9N8RVA0tGO
   Z8lWO+T2i6Sd/xHgiXPUMnMyITxKK4Ua2LVx54Vc8fUeGJvFj3h8PCVwk
   X2f74Fb+qtvaiQX2MUVxP8CIjBJXv5Zwp09voGvdmOrc+knz1X+kN4hg6
   Q==;
X-IronPort-AV: E=Sophos;i="5.60,446,1549929600"; 
   d="scan'208";a="27298577"
IronPort-PHdr: =?us-ascii?q?9a23=3ABaKqOhes/2nkL6Q5am7oxKRJlGMj4u6mDksu8p?=
 =?us-ascii?q?Mizoh2WeGdxc27bRyN2/xhgRfzUJnB7Loc0qyK6vmmCTdLuM/Q+Fk5M7V0Hy?=
 =?us-ascii?q?cfjssXmwFySOWkMmbcaMDQUiohAc5ZX0Vk9XzoeWJcGcL5ekGA6ibqtW1aFR?=
 =?us-ascii?q?rwLxd6KfroEYDOkcu3y/qy+5rOaAlUmTaxe7x/IAiroQnLtcQbj4RuJrssxh?=
 =?us-ascii?q?bNv3BFZ/lYyWR0KFyJgh3y/N2w/Jlt8yRRv/Iu6ctNWrjkcqo7ULJVEi0oP3?=
 =?us-ascii?q?g668P3uxbDSxCP5mYHXWUNjhVIGQnF4wrkUZr3ryD3q/By2CiePc3xULA0RT?=
 =?us-ascii?q?Gv5LplRRP0lCsKMSMy/XrJgcJskq1UvBOhpwR+w4HKZoGVKOF+db7Zcd8DWG?=
 =?us-ascii?q?ZNQtpdWylHD4yydYsPC/cKM/heoYfzulACqQKyCAeoCe/qzDJDm3340rAg0+?=
 =?us-ascii?q?k5DA/I3BIuH9wNvnraotr6O6UdXvy6wqTT0TXObOlb1Svh5IXGcB0sp+yHU7?=
 =?us-ascii?q?JqccrWzEkiDx7LjkmOpoz9PzOayOINuHWG4eplT+2vj2onpB9xozOywcoskZ?=
 =?us-ascii?q?TGhpkOx1DY9SR23IY1JdqiRE59et6rCoFcty6dN4toW84vRXxjtiUiyrAepJ?=
 =?us-ascii?q?K2cycHxI4nyhLCcfCLbYeF7gz5WOqMJzpzmWhrd6ilhxmo9Eit0uj8Vs6p31?=
 =?us-ascii?q?lUtidFidzMtmwV1xzU98iHVuNx/ke/1jaL0ADe8v1ELloularaNp4h2aQ8lo?=
 =?us-ascii?q?YTsEvfHi/2n1/6jKmKeUU/5uek8eHnYrTippOENo90jB/xMrg2l8CiDuk1PR?=
 =?us-ascii?q?ICUmiG9eimyrHu8lP1TK9XgvEul6nWqpHaJcAVpq6jBA9V154u6w2iADe9y9?=
 =?us-ascii?q?kYgXkGI05FeBKAlYTpPUrOL+riAfewhFSsji9nx+raMb35HpXNMn/Dna/5fb?=
 =?us-ascii?q?ln8EFT1gwzzdFE6pJOFL4OPfLzVVXttNDCEhA5NAm0yf79CNphzoMeRX6PAq?=
 =?us-ascii?q?iBPaPKq1CI++YvLvKUZIAPpTb9L+Ep5/vpjX8+g18SY7Ol0ocQaHC9Bv5mOV?=
 =?us-ascii?q?mWYWLwgtcdFmcHphE+Q/LuiF2DVz5TenmzUrki5jE0Fo2mF53PRoOzj7yb2i?=
 =?us-ascii?q?e0AJlWanpBClCWHnfib5+EVOsUaCKOPs9hlSQJVb6/RI89yB6hqhH6xqF5Lu?=
 =?us-ascii?q?rb5CIYr4jv1Ntr6O3JkxE96zh0A96a02GXQGF+hnkISCMu3KBjvUx9zU+O0b?=
 =?us-ascii?q?RljPNGDtxc+fNIUgEhOJ7G0eN1FtDyVRjdftuTVFmmRdCmCykrTt0t298Of1?=
 =?us-ascii?q?p9G9K6gxDGxSWqGaMamKKPBJwz6K7c22b+J8dhy3bAyqYhlUIrQsRKNWK8h6?=
 =?us-ascii?q?5/8xLfCJLOk0Wcj6yqb7gT3DbR9GefymqDpFtYUA9sXqXFR38ffFbZoszl6U?=
 =?us-ascii?q?zaT7+hE7UnMg1fxs6ZMaZFccHpjVRARPf/JtveeWSxlHmsBRqS2ryMa4/qKC?=
 =?us-ascii?q?0h23DlAU8AlEg693uANEBqHi6rrmTfJCZjGVLmfwXn9uwo7DuDR1IwhySNaF?=
 =?us-ascii?q?dsn+6t8wMRreSVVvdW27UDoipnoDJxSgWTxdXTXuGcqhJhcaMUWtY05FNKxC?=
 =?us-ascii?q?qNrABmFoCxJKBlwFgFekJ4uF24hEY/MZlJjcV/9CBi9wF1M6/NlQoaJj4=3D?=
X-IPAS-Result: =?us-ascii?q?A2B+AAALHNNc/wHyM5BkHAEBAQQBAQcEAQGBUwUBAQsBg?=
 =?us-ascii?q?WYqgToBMiiEEJNeAQQGgTWJTI8GgXsJATQBAoQ/AoIIIzYHDgEDAQEBBAEBA?=
 =?us-ascii?q?QEDAQFsKII6KQGCZwEFIwQLAQVBEAkCDgoCAiYCAlcGAQwGAgEBgl8/gXcUk?=
 =?us-ascii?q?WqbZXwziGSBRoELJwGLTRd4gQeBESeCaz5phmWCWASLF5wrCYILggaQQwYbl?=
 =?us-ascii?q?VctiGiDD5FChTEBMYFWKwgCGAghD4MnghsXjjsjAzCBBgEBkAgBAQ?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 08 May 2019 18:17:36 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x48IHa2V018041;
        Wed, 8 May 2019 14:17:36 -0400
Subject: Re: [PATCH net] selinux: do not report error on connect(AF_UNSPEC)
From:   Stephen Smalley <sds@tycho.nsa.gov>
To:     Paolo Abeni <pabeni@redhat.com>, Paul Moore <paul@paul-moore.com>
Cc:     selinux@vger.kernel.org, netdev@vger.kernel.org,
        Tom Deseyn <tdeseyn@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Richard Haines <richard_c_haines@btinternet.com>
References: <7301017039d68c920cb9120c035a1a0df3e6b30d.1557322358.git.pabeni@redhat.com>
 <36e13dc4-be40-d1f6-0be5-32cd4fc38f6e@tycho.nsa.gov>
Message-ID: <83b4adb4-9d8f-848f-d1cc-a4a1f30cee51@tycho.nsa.gov>
Date:   Wed, 8 May 2019 14:13:17 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <36e13dc4-be40-d1f6-0be5-32cd4fc38f6e@tycho.nsa.gov>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/8/19 2:12 PM, Stephen Smalley wrote:
> On 5/8/19 9:32 AM, Paolo Abeni wrote:
>> calling connect(AF_UNSPEC) on an already connected TCP socket is an
>> established way to disconnect() such socket. After commit 68741a8adab9
>> ("selinux: Fix ltp test connect-syscall failure") it no longer works
>> and, in the above scenario connect() fails with EAFNOSUPPORT.
>>
>> Fix the above falling back to the generic/old code when the address 
>> family
>> is not AF_INET{4,6}, but leave the SCTP code path untouched, as it has
>> specific constraints.
>>
>> Fixes: 68741a8adab9 ("selinux: Fix ltp test connect-syscall failure")
>> Reported-by: Tom Deseyn <tdeseyn@redhat.com>
>> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
>> ---
>>   security/selinux/hooks.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>> index c61787b15f27..d82b87c16b0a 100644
>> --- a/security/selinux/hooks.c
>> +++ b/security/selinux/hooks.c
>> @@ -4649,7 +4649,7 @@ static int selinux_socket_connect_helper(struct 
>> socket *sock,
>>           struct lsm_network_audit net = {0,};
>>           struct sockaddr_in *addr4 = NULL;
>>           struct sockaddr_in6 *addr6 = NULL;
>> -        unsigned short snum;
>> +        unsigned short snum = 0;
>>           u32 sid, perm;
>>           /* sctp_connectx(3) calls via selinux_sctp_bind_connect()
>> @@ -4674,12 +4674,12 @@ static int 
>> selinux_socket_connect_helper(struct socket *sock,
>>               break;
>>           default:
>>               /* Note that SCTP services expect -EINVAL, whereas
>> -             * others expect -EAFNOSUPPORT.
>> +             * others must handle this at the protocol level:
>> +             * connect(AF_UNSPEC) on a connected socket is
>> +             * a documented way disconnect the socket.
>>                */
>>               if (sksec->sclass == SECCLASS_SCTP_SOCKET)
>>                   return -EINVAL;
>> -            else
>> -                return -EAFNOSUPPORT;
> 
> I think we need to return 0 here.  Otherwise, we'll fall through with an 
> uninitialized snum, triggering a random/bogus permission check.

Sorry, I see that you initialize snum above.  Nonetheless, I think the 
correct behavior here is to skip the check since this is a disconnect, 
not a connect.

> 
>>           }
>>           err = sel_netport_sid(sk->sk_protocol, snum, &sid);
>>
> 

