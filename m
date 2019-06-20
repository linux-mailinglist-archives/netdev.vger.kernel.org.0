Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC90F4CDF3
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 14:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731849AbfFTMrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 08:47:40 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:36564 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726838AbfFTMrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 08:47:39 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jun 2019 08:47:37 EDT
Received: from mxbackcorp1g.mail.yandex.net (mxbackcorp1g.mail.yandex.net [IPv6:2a02:6b8:0:1402::301])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 740152E0A55;
        Thu, 20 Jun 2019 15:40:17 +0300 (MSK)
Received: from smtpcorp1p.mail.yandex.net (smtpcorp1p.mail.yandex.net [2a02:6b8:0:1472:2741:0:8b6:10])
        by mxbackcorp1g.mail.yandex.net (nwsmtp/Yandex) with ESMTP id rW3WrpNMFh-eH5OgRV3;
        Thu, 20 Jun 2019 15:40:17 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1561034417; bh=8zUumKf1qeYuTC1ownuhlHgHCHk6qEa6psiv56trKZ0=;
        h=In-Reply-To:References:Date:Message-ID:From:To:Subject;
        b=j+2Xmh4sT8D479rVDfmbVGmhxUaSriUW7RJV/wFTW7+nSuxMANixYXGe2CpyZhdVd
         zRbpFjgUxB8h+o+nyPocDh1FL+zZtt6Zb0nWHS+6ak+vtAsAlEHDbRGbRpUZeKNQv7
         TO/sLQdOt2nOwqdHRUE133ZykzX5WajwXnKpGdiA=
Authentication-Results: mxbackcorp1g.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:a1b1:2ca9:8cc0:4c56])
        by smtpcorp1p.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id ado0pY8xXj-eGqqONGn;
        Thu, 20 Jun 2019 15:40:17 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: Re: [PATCH RFC] proc/meminfo: add NetBuffers counter for socket
 buffers
To:     Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <155792134187.1641.3858215257559626632.stgit@buzz>
 <9f611f72-c883-45e9-cb2a-824ba27356d9@suse.cz>
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Message-ID: <fe7a4739-556f-69b1-fe30-f4b6e1b31e64@yandex-team.ru>
Date:   Thu, 20 Jun 2019 15:40:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <9f611f72-c883-45e9-cb2a-824ba27356d9@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.06.2019 15:03, Vlastimil Babka wrote:
> On 5/15/19 1:55 PM, Konstantin Khlebnikov wrote:
>> Socket buffers always were dark-matter that lives by its own rules.
> 
> Is the information even exported somewhere e.g. in sysfs or via netlink yet?

in /proc/self/net/protocols

protocol  size sockets  memory press maxhdr  slab module     cl co di ac io in de sh ss gs se re sp bi br ha uh gp em
PACKET    1408      0      -1   NI       0   no   kernel      n  n  n  n  n  n  n  n  n  n  n  n  n  n  n  n  n  n  n
PINGv6    1088      0      -1   NI       0   yes  kernel      y  y  y  n  n  y  n  n  y  y  y  y  n  y  y  y  y  y  n
RAWv6     1088      0      -1   NI       0   yes  kernel      y  y  y  n  y  y  y  n  y  y  y  y  n  y  y  y  y  n  n
UDPLITEv6 1080      0      -1   NI       0   yes  kernel      y  y  y  n  y  y  y  n  y  y  y  y  n  n  y  y  y  y  n
UDPv6     1080     21     111   NI       0   yes  kernel      y  y  y  n  y  n  y  n  y  y  y  y  n  n  y  y  y  y  n
TCPv6     2048  49297  442697   no     304   yes  kernel      y  y  y  y  y  y  y  y  y  y  y  y  y  n  y  y  y  y  y
UNIX      1024    158      -1   NI       0   yes  kernel      n  n  n  n  n  n  n  n  n  n  n  n  n  n  n  n  n  n  n
UDP-Lite   920      0      -1   NI       0   yes  kernel      y  y  y  n  y  y  y  n  y  y  y  y  y  n  y  y  y  y  n
PING       880      0      -1   NI       0   yes  kernel      y  y  y  n  n  y  n  n  y  y  y  y  n  y  y  y  y  y  n
RAW        888      0      -1   NI       0   yes  kernel      y  y  y  n  y  y  y  n  y  y  y  y  n  y  y  y  y  n  n
UDP        920      0     111   NI       0   yes  kernel      y  y  y  n  y  n  y  n  y  y  y  y  y  n  y  y  y  y  n
TCP       1888      0  442697   no     304   yes  kernel      y  y  y  y  y  y  y  y  y  y  y  y  y  n  y  y  y  y  y
NETLINK   1040      1      -1   NI       0   no   kernel      n  n  n  n  n  n  n  n  n  n  n  n  n  n  n  n  n  n  n

column 'sockets' is virtualized, while 'memory' is not

> 
>> This patch adds line NetBuffers that exposes most common kinds of them.
> 
> Did you encounter a situation where the number was significant and this
> would help finding out why memory is occupied?

Might be. In example above tcp buffers are 1,7G.
This is real server, with 0.5T ram though.

> 
>> TCP and UDP are most important species.
>> SCTP is added as example of modular protocol.
>> UNIX have no memory counter for now, should be easy to add.
>>
>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> 
> Right now it's a sum of a few values, which should be fine wrt
> /proc/meminfo overhead. But I guess netdev guys should have a say in
> this. Also you should update the corresponding Documentation/ file.

Later I send another proposal: even bigger sum - "MemKernel".
https://lore.kernel.org/linux-mm/155853600919.381.8172097084053782598.stgit@buzz/
Which gives estimation for all kinds of 'kernel' memory. It seems more useful for me.

> 
> Thanks,
> Vlastimil
> 
>> ---
>>   fs/proc/meminfo.c  |    5 ++++-
>>   include/linux/mm.h |    6 ++++++
>>   mm/page_alloc.c    |    3 ++-
>>   net/core/sock.c    |   20 ++++++++++++++++++++
>>   net/sctp/socket.c  |    2 +-
>>   5 files changed, 33 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
>> index 7bc14716fc5d..0ee2300a916d 100644
>> --- a/fs/proc/meminfo.c
>> +++ b/fs/proc/meminfo.c
>> @@ -41,6 +41,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>>   	unsigned long sreclaimable, sunreclaim, misc_reclaimable;
>>   	unsigned long kernel_stack_kb, page_tables, percpu_pages;
>>   	unsigned long anon_pages, file_pages, swap_cached;
>> +	unsigned long net_buffers;
>>   	long kernel_misc;
>>   	int lru;
>>   
>> @@ -66,12 +67,13 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>>   	kernel_stack_kb = global_zone_page_state(NR_KERNEL_STACK_KB);
>>   	page_tables = global_zone_page_state(NR_PAGETABLE);
>>   	percpu_pages = pcpu_nr_pages();
>> +	net_buffers = total_netbuffer_pages();
>>   
>>   	/* all other kinds of kernel memory allocations */
>>   	kernel_misc = i.totalram - i.freeram - anon_pages - file_pages
>>   		      - sreclaimable - sunreclaim - misc_reclaimable
>>   		      - (kernel_stack_kb >> (PAGE_SHIFT - 10))
>> -		      - page_tables - percpu_pages;
>> +		      - page_tables - percpu_pages - net_buffers;
>>   	if (kernel_misc < 0)
>>   		kernel_misc = 0;
>>   
>> @@ -137,6 +139,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>>   	show_val_kb(m, "VmallocUsed:    ", 0ul);
>>   	show_val_kb(m, "VmallocChunk:   ", 0ul);
>>   	show_val_kb(m, "Percpu:         ", percpu_pages);
>> +	show_val_kb(m, "NetBuffers:     ", net_buffers);
>>   	show_val_kb(m, "KernelMisc:     ", kernel_misc);
>>   
>>   #ifdef CONFIG_MEMORY_FAILURE
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 0e8834ac32b7..d0a58355bfb7 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -2254,6 +2254,12 @@ extern void si_meminfo_node(struct sysinfo *val, int nid);
>>   extern unsigned long arch_reserved_kernel_pages(void);
>>   #endif
>>   
>> +#ifdef CONFIG_NET
>> +extern unsigned long total_netbuffer_pages(void);
>> +#else
>> +static inline unsigned long total_netbuffer_pages(void) { return 0; }
>> +#endif
>> +
>>   extern __printf(3, 4)
>>   void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...);
>>   
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 3b13d3914176..fcdd7c6e72b9 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -5166,7 +5166,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
>>   		" active_file:%lu inactive_file:%lu isolated_file:%lu\n"
>>   		" unevictable:%lu dirty:%lu writeback:%lu unstable:%lu\n"
>>   		" slab_reclaimable:%lu slab_unreclaimable:%lu\n"
>> -		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n"
>> +		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu net_buffers:%lu\n"
>>   		" free:%lu free_pcp:%lu free_cma:%lu\n",
>>   		global_node_page_state(NR_ACTIVE_ANON),
>>   		global_node_page_state(NR_INACTIVE_ANON),
>> @@ -5184,6 +5184,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
>>   		global_node_page_state(NR_SHMEM),
>>   		global_zone_page_state(NR_PAGETABLE),
>>   		global_zone_page_state(NR_BOUNCE),
>> +		total_netbuffer_pages(),
>>   		global_zone_page_state(NR_FREE_PAGES),
>>   		free_pcp,
>>   		global_zone_page_state(NR_FREE_CMA_PAGES));
>> diff --git a/net/core/sock.c b/net/core/sock.c
>> index 75b1c950b49f..dfca4e024b74 100644
>> --- a/net/core/sock.c
>> +++ b/net/core/sock.c
>> @@ -142,6 +142,7 @@
>>   #include <trace/events/sock.h>
>>   
>>   #include <net/tcp.h>
>> +#include <net/udp.h>
>>   #include <net/busy_poll.h>
>>   
>>   static DEFINE_MUTEX(proto_list_mutex);
>> @@ -3573,3 +3574,22 @@ bool sk_busy_loop_end(void *p, unsigned long start_time)
>>   }
>>   EXPORT_SYMBOL(sk_busy_loop_end);
>>   #endif /* CONFIG_NET_RX_BUSY_POLL */
>> +
>> +#if IS_ENABLED(CONFIG_IP_SCTP)
>> +atomic_long_t sctp_memory_allocated;
>> +EXPORT_SYMBOL_GPL(sctp_memory_allocated);
>> +#endif
>> +
>> +unsigned long total_netbuffer_pages(void)
>> +{
>> +	unsigned long ret = 0;
>> +
>> +#if IS_ENABLED(CONFIG_IP_SCTP)
>> +	ret += atomic_long_read(&sctp_memory_allocated);
>> +#endif
>> +#ifdef CONFIG_INET
>> +	ret += atomic_long_read(&tcp_memory_allocated);
>> +	ret += atomic_long_read(&udp_memory_allocated);
>> +#endif
>> +	return ret;
>> +}
>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
>> index e4e892cc5644..9d11afdeeae4 100644
>> --- a/net/sctp/socket.c
>> +++ b/net/sctp/socket.c
>> @@ -107,7 +107,7 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
>>   			     enum sctp_socket_type type);
>>   
>>   static unsigned long sctp_memory_pressure;
>> -static atomic_long_t sctp_memory_allocated;
>> +extern atomic_long_t sctp_memory_allocated;
>>   struct percpu_counter sctp_sockets_allocated;
>>   
>>   static void sctp_enter_memory_pressure(struct sock *sk)
>>
> 
