Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1127A4B0308
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiBJCJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbiBJCHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 21:07:39 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14D8B8;
        Wed,  9 Feb 2022 18:04:50 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JvKhl0SdGz67ySC;
        Thu, 10 Feb 2022 10:00:39 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Thu, 10 Feb 2022 03:04:47 +0100
Message-ID: <1b1aebc0-2915-0720-24c6-ba67ac0255f0@huawei.com>
Date:   Thu, 10 Feb 2022 05:04:46 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH 1/2] landlock: TCP network hooks implementation
Content-Language: ru
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20220124080215.265538-1-konstantin.meskhidze@huawei.com>
 <20220124080215.265538-2-konstantin.meskhidze@huawei.com>
 <CA+FuTSf4EjgjBCCOiu-PHJcTMia41UkTh8QJ0+qdxL_J8445EA@mail.gmail.com>
 <0934a27a-d167-87ea-97d2-b3ac952832ff@huawei.com>
 <CA+FuTSc8ZAeaHWVYf-zmn6i5QLJysYGJppAEfb7tRbtho7_DKA@mail.gmail.com>
 <d84ed5b3-837a-811a-6947-e857ceba3f83@huawei.com>
 <CA+FuTSeVhLdeXokyG4x__HGJyNOwsSicLOb4NKJA-gNp59S5uA@mail.gmail.com>
 <0d33f7cd-6846-5e7e-62b9-fbd0b28ecea9@digikod.net>
 <91885a8f-b787-62ff-1abb-700641f7c2cb@huawei.com>
 <CA+FuTScaoby-=xRKf_Dz3koSYHqrMN0cauCg4jMmy_nDxwPADA@mail.gmail.com>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <CA+FuTScaoby-=xRKf_Dz3koSYHqrMN0cauCg4jMmy_nDxwPADA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



2/7/2022 7:00 PM, Willem de Bruijn пишет:
> On Mon, Feb 7, 2022 at 12:51 AM Konstantin Meskhidze
> <konstantin.meskhidze@huawei.com> wrote:
>>
>>
>>
>> 2/1/2022 3:33 PM, Mickaël Salaün пишет:
>>>
>>> On 31/01/2022 18:14, Willem de Bruijn wrote:
>>>> On Fri, Jan 28, 2022 at 10:12 PM Konstantin Meskhidze
>>>> <konstantin.meskhidze@huawei.com> wrote:
>>>>>
>>>>>
>>>>>
>>>>> 1/26/2022 5:15 PM, Willem de Bruijn пишет:
>>>>>> On Wed, Jan 26, 2022 at 3:06 AM Konstantin Meskhidze
>>>>>> <konstantin.meskhidze@huawei.com> wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> 1/25/2022 5:17 PM, Willem de Bruijn пишет:
>>>>>>>> On Mon, Jan 24, 2022 at 3:02 AM Konstantin Meskhidze
>>>>>>>> <konstantin.meskhidze@huawei.com> wrote:
>>>>>>>>>
>>>>>>>>> Support of socket_bind() and socket_connect() hooks.
>>>>>>>>> Current prototype can restrict binding and connecting of TCP
>>>>>>>>> types of sockets. Its just basic idea how Landlock could support
>>>>>>>>> network confinement.
>>>>>>>>>
>>>>>>>>> Changes:
>>>>>>>>> 1. Access masks array refactored into 1D one and changed
>>>>>>>>> to 32 bits. Filesystem masks occupy 16 lower bits and network
>>>>>>>>> masks reside in 16 upper bits.
>>>>>>>>> 2. Refactor API functions in ruleset.c:
>>>>>>>>>         1. Add void *object argument.
>>>>>>>>>         2. Add u16 rule_type argument.
>>>>>>>>> 3. Use two rb_trees in ruleset structure:
>>>>>>>>>         1. root_inode - for filesystem objects
>>>>>>>>>         2. root_net_port - for network port objects
>>>>>>>>>
>>>>>>>>> Signed-off-by: Konstantin Meskhidze
>>>>>>>>> <konstantin.meskhidze@huawei.com>
>>>>>>>>
>>>>>>>>> +static int hook_socket_connect(struct socket *sock, struct
>>>>>>>>> sockaddr *address, int addrlen)
>>>>>>>>> +{
>>>>>>>>> +       short socket_type;
>>>>>>>>> +       struct sockaddr_in *sockaddr;
>>>>>>>>> +       u16 port;
>>>>>>>>> +       const struct landlock_ruleset *const dom =
>>>>>>>>> landlock_get_current_domain();
>>>>>>>>> +
>>>>>>>>> +       /* Check if the hook is AF_INET* socket's action */
>>>>>>>>> +       if ((address->sa_family != AF_INET) &&
>>>>>>>>> (address->sa_family != AF_INET6))
>>>>>>>>> +               return 0;
>>>>>>>>
>>>>>>>> Should this be a check on the socket family (sock->ops->family)
>>>>>>>> instead of the address family?
>>>>>>>
>>>>>>> Actually connect() function checks address family:
>>>>>>>
>>>>>>> int __inet_stream_connect(... ,struct sockaddr *uaddr ,...) {
>>>>>>> ...
>>>>>>>            if (uaddr) {
>>>>>>>                    if (addr_len < sizeof(uaddr->sa_family))
>>>>>>>                    return -EINVAL;
>>>>>>>
>>>>>>>                    if (uaddr->sa_family == AF_UNSPEC) {
>>>>>>>                            err = sk->sk_prot->disconnect(sk, flags);
>>>>>>>                            sock->state = err ? SS_DISCONNECTING :
>>>>>>>                            SS_UNCONNECTED;
>>>>>>>                    goto out;
>>>>>>>                    }
>>>>>>>            }
>>>>>>>
>>>>>>> ...
>>>>>>> }
>>>>>>
>>>>>> Right. My question is: is the intent of this feature to be limited to
>>>>>> sockets of type AF_INET(6) or to addresses?
>>>>>>
>>>>>> I would think the first. Then you also want to catch operations on
>>>>>> such sockets that may pass a different address family. AF_UNSPEC is
>>>>>> the known offender that will effect a state change on AF_INET(6)
>>>>>> sockets.
>>>>>
>>>>>     The intent is to restrict INET sockets to bind/connect to some ports.
>>>>>     You can apply some number of Landlock rules with port defenition:
>>>>>           1. Rule 1 allows to connect to sockets with port X.
>>>>>           2. Rule 2 forbids to connect to socket with port Y.
>>>>>           3. Rule 3 forbids to bind a socket to address with port Z.
>>>>>
>>>>>           and so on...
>>>>>>
>>>>>>>>
>>>>>>>> It is valid to pass an address with AF_UNSPEC to a PF_INET(6) socket.
>>>>>>>> And there are legitimate reasons to want to deny this. Such as
>>>>>>>> passing
>>>>>>>> a connection to a unprivileged process and disallow it from
>>>>>>>> disconnect
>>>>>>>> and opening a different new connection.
>>>>>>>
>>>>>>> As far as I know using AF_UNSPEC to unconnect takes effect on
>>>>>>> UDP(DATAGRAM) sockets.
>>>>>>> To unconnect a UDP socket, we call connect but set the family
>>>>>>> member of
>>>>>>> the socket address structure (sin_family for IPv4 or sin6_family for
>>>>>>> IPv6) to AF_UNSPEC. It is the process of calling connect on an already
>>>>>>> connected UDP socket that causes the socket to become unconnected.
>>>>>>>
>>>>>>> This RFC patch just supports TCP connections. I need to check the
>>>>>>> logic
>>>>>>> if AF_UNSPEC provided in connenct() function for TCP(STREAM) sockets.
>>>>>>> Does it disconnect already established TCP connection?
>>>>>>>
>>>>>>> Thank you for noticing about this issue. Need to think through how
>>>>>>> to manage it with Landlock network restrictions for both TCP and UDP
>>>>>>> sockets.
>>>>>>
>>>>>> AF_UNSPEC also disconnects TCP.
>>>>>
>>>>> So its possible to call connect() with AF_UNSPEC and make a socket
>>>>> unconnected. If you want to establish another connection to a socket
>>>>> with port Y, and if there is a landlock rule has applied to a process
>>>>> (or container) which restricts to connect to a socket with port Y, it
>>>>> will be banned.
>>>>> Thats the basic logic.
>>>>
>>>> Understood, and that works fine for connect. It would be good to also
>>>> ensure that a now-bound socket cannot call listen. Possibly for
>>>> follow-on work.
>>>
>>> Are you thinking about a new access right for listen? What would be the
>>> use case vs. the bind access right?
>>> .
>>
>>    If bind() function has already been restricted so the following
>> listen() function is automatically banned. I agree with Mickaёl about
>> the usecase here. Why do we need new-bound socket with restricted listening?
> 
> The intended use-case is for a privileged process to open a connection
> (i.e., bound and connected socket) and pass that to a restricted
> process. The intent is for that process to only be allowed to
> communicate over this pre-established channel.
> 
> In practice, it is able to disconnect (while staying bound) and
> elevate its privileges to that of a listening server:
> 
> static void child_process(int fd)
> {
>          struct sockaddr addr = { .sa_family = AF_UNSPEC };
>          int client_fd;
> 
>          if (listen(fd, 1) == 0)
>                  error(1, 0, "listen succeeded while connected");
> 
>          if (connect(fd, &addr, sizeof(addr)))
>                  error(1, errno, "disconnect");
> 
>          if (listen(fd, 1))
>                  error(1, errno, "listen");
> 
>          client_fd = accept(fd, NULL, NULL);
>          if (client_fd == -1)
>                  error(1, errno, "accept");
> 
>          if (close(client_fd))
>                  error(1, errno, "close client");
> }
> 
> int main(int argc, char **argv)
> {
>          struct sockaddr_in6 addr = { 0 };
>          pid_t pid;
>          int fd;
> 
>          fd = socket(PF_INET6, SOCK_STREAM, 0);
>          if (fd == -1)
>                  error(1, errno, "socket");
> 
>          addr.sin6_family = AF_INET6;
>          addr.sin6_addr = in6addr_loopback;
> 
>          addr.sin6_port = htons(8001);
>          if (bind(fd, (void *)&addr, sizeof(addr)))
>                  error(1, errno, "bind");
> 
>          addr.sin6_port = htons(8000);
>          if (connect(fd, (void *)&addr, sizeof(addr)))
>                  error(1, errno, "connect");
> 
>          pid = fork();
>          if (pid == -1)
>                  error(1, errno, "fork");
> 
>          if (pid)
>                  wait(NULL);
>          else
>                  child_process(fd);
> 
>          if (close(fd))
>                  error(1, errno, "close");
> 
>          return 0;
> }
> 
> It's fine to not address this case in this patch series directly, of
> course. But we should be aware of the AF_UNSPEC loophole.

  Thank you so much. I will check it and think about a test logic.
> .
