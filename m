Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 232A760CB99
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 14:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiJYMPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 08:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJYMPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 08:15:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FC5F41A5
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 05:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666700146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nOzDdV0oEp6wyZXzDDf647sJ9V/1wsykXrnknbLQpv4=;
        b=famXgqTBqMvBZOiZHce9gTkH9QW+WR4IGPrblqaC6+A09H3nIy1S4Rmohk9KDnpj0Luc6I
        Hlnm+bhp1CywcdWMKzDTdQjt9kBE1WXYCoZPvrqhD4qV8nAw/gPHq8zN4Ejjl7/bUPDWxO
        x8zNOMREKoFwLpgxs2HkIDOgdZ6wHi4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-Aw4s5VMxObCjXXdpWAVxpQ-1; Tue, 25 Oct 2022 08:15:43 -0400
X-MC-Unique: Aw4s5VMxObCjXXdpWAVxpQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BC8629DD999;
        Tue, 25 Oct 2022 12:15:37 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.32.203])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B4ED1415117;
        Tue, 25 Oct 2022 12:15:29 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Kevin Sprague <ksprague0711@gmail.com>, dev@openvswitch.org,
        Eelco Chaudron <echaudro@redhat.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net 2/2] selftests: add openvswitch selftest suite
References: <20221019183054.105815-1-aconole@redhat.com>
        <20221019183054.105815-3-aconole@redhat.com>
        <88eff2a1-495c-0e89-44bf-1478db7d0661@ovn.org>
        <f7ty1taqznl.fsf@redhat.com>
        <1d7beda5-c558-5ea3-17f2-934bf298f4ad@ovn.org>
        <7b540b02-e676-5ccc-e832-269ef397f9ec@ovn.org>
Date:   Tue, 25 Oct 2022 08:15:27 -0400
In-Reply-To: <7b540b02-e676-5ccc-e832-269ef397f9ec@ovn.org> (Ilya Maximets's
        message of "Thu, 20 Oct 2022 19:17:35 +0200")
Message-ID: <f7tilk8p09s.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ilya Maximets <i.maximets@ovn.org> writes:

> On 10/20/22 18:33, Ilya Maximets wrote:
>> On 10/20/22 17:32, Aaron Conole wrote:
>>> Hi Ilya,
>>>
>>> Ilya Maximets <i.maximets@ovn.org> writes:
>>>
>>>> On 10/19/22 20:30, Aaron Conole wrote:
>>>>> Previous commit resolves a WARN splat that can be difficult to reproduce,
>>>>> but with the ovs-dpctl.py utility, it can be trivial.  Introduce a test
>>>>> case which creates a DP, and then downgrades the feature set.  This will
>>>>> include a utility 'ovs-dpctl.py' that can be extended to do additional
>>>>> work.
>>>>>
>>>>> Signed-off-by: Aaron Conole <aconole@redhat.com>
>>>>> Signed-off-by: Kevin Sprague <ksprague0711@gmail.com>
>>>>> ---
>>>>>  MAINTAINERS                                   |   1 +
>>>>>  tools/testing/selftests/Makefile              |   1 +
>>>>>  .../selftests/net/openvswitch/Makefile        |  13 +
>>>>>  .../selftests/net/openvswitch/openvswitch.sh  | 216 +++++++++
>>>>>  .../selftests/net/openvswitch/ovs-dpctl.py    | 411 ++++++++++++++++++
>>>>>  5 files changed, 642 insertions(+)
>>>>>  create mode 100644 tools/testing/selftests/net/openvswitch/Makefile
>>>>>  create mode 100755 tools/testing/selftests/net/openvswitch/openvswitch.sh
>>>>>  create mode 100644 tools/testing/selftests/net/openvswitch/ovs-dpctl.py
>>>>>
>>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>>> index abbe88e1c50b..295a6b0fbe26 100644
>>>>> --- a/MAINTAINERS
>>>>> +++ b/MAINTAINERS
>>>>> @@ -15434,6 +15434,7 @@ S:	Maintained
>>>>>  W:	http://openvswitch.org
>>>>>  F:	include/uapi/linux/openvswitch.h
>>>>>  F:	net/openvswitch/
>>>>> +F:	tools/testing/selftests/net/openvswitch/
>>>>>  
>>>>>  OPERATING PERFORMANCE POINTS (OPP)
>>>>>  M:	Viresh Kumar <vireshk@kernel.org>
>>>>
>>>> ...
>>>>
>>>>> +exit ${exitcode}
>>>>> diff --git a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
>>>>> b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
>>>>> new file mode 100644
>>>>> index 000000000000..791d76b7adcd
>>>>> --- /dev/null
>>>>> +++ b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
>>>>> @@ -0,0 +1,411 @@
>>>>> +#!/usr/bin/env python3
>>>>> +# SPDX-License-Identifier: GPL-2.0
>>>>> +
>>>>> +# Controls the openvswitch module.  Part of the kselftest suite, but
>>>>> +# can be used for some diagnostic purpose as well.
>>>>> +
>>>>> +import logging
>>>>> +import multiprocessing
>>>>> +import socket
>>>>> +import struct
>>>>> +import sys
>>>>> +
>>>>> +try:
>>>>> +    from libnl.attr import NLA_NESTED, NLA_STRING, NLA_U32, NLA_UNSPEC
>>>>> +    from libnl.attr import nla_get_string, nla_get_u32
>>>>> +    from libnl.attr import nla_put, nla_put_string, nla_put_u32
>>>>> +    from libnl.attr import nla_policy
>>>>> +
>>>>> +    from libnl.error import errmsg
>>>>> +
>>>>> +    from libnl.genl.ctrl import genl_ctrl_resolve
>>>>> +    from libnl.genl.genl import genl_connect, genlmsg_parse, genlmsg_put
>>>>> +
>>>>> +    from libnl.handlers import nl_cb_alloc, nl_cb_set
>>>>> +    from libnl.handlers import NL_CB_CUSTOM, NL_CB_MSG_IN, NL_CB_VALID
>>>>> +    from libnl.handlers import NL_OK, NL_STOP
>>>>> +
>>>>> +    from libnl.linux_private.netlink import NLM_F_ACK, NLM_F_DUMP
>>>>> +    from libnl.linux_private.netlink import NLM_F_REQUEST, NLMSG_DONE
>>>>> +
>>>>> +    from libnl.msg import NL_AUTO_SEQ, nlmsg_alloc, nlmsg_hdr
>>>>> +
>>>>> +    from libnl.nl import NLMSG_ERROR, nl_recvmsgs_default, nl_send_auto
>>>>> +    from libnl.socket_ import nl_socket_alloc, nl_socket_set_cb
>>>>> +    from libnl.socket_ import nl_socket_get_local_port
>>>>> +except ModuleNotFoundError:
>>>>> +    print("Need to install the python libnl3 library.")
>>>>
>>>>
>>>> Hey, Aaron and Kevin.  Selftests sounds like a very important and
>>>> long overdue thing to add.  Thanks for working on this!
>>>>
>>>> I have some worries about the libnl3 library though.  It doesn't
>>>> seem to be maintained well.  It it maintained by a single person,
>>>> it it was at least 3 different single persons over the last 7
>>>> years via forks.  It didn't get any significant development done
>>>> since 2015 as well and no commits at all for a last 1.5 years.
>>>> It is not packaged by any major distributions.
>>>
>>> :-/  On my fedora:
>>>
>>>   11:12:24 aconole@RHTPC1VM0NT ~$ dnf search python3-libnl3
>>>   Last metadata expiration check: 1 day, 0:25:11 ago on Wed 19 Oct 2022 10:47:21 AM EDT.
>>>   ===================== Name Exactly Matched: python3-libnl3 =====================
>>>   python3-libnl3.x86_64 : libnl3 binding for Python 3
>>>
>>>
>>> And I can use it:
>>>
>>>   11:18:39 aconole@RHTPC1VM0NT {(6a5c83bdd991...)} ~/git/linux/tools/testing/selftests/net/openvswitch$ sudo python3 ./ovs-dpctl.py show
>>>   foop
>>>     Lookups: Hit: 0 Missed: 0 Lost: 0
>>>     Flows: 0
>>>     Masks: Hit: 0 Total: 0
>>>     Cache: Hit: 0
>>>   Caches:
>>>     Masks-cache: size: 256
>>>       Port 0: foop (internal)
>>>   11:18:43 aconole@RHTPC1VM0NT {(6a5c83bdd991...)} ~/git/linux/tools/testing/selftests/net/openvswitch$ rpm -qa | grep python3-libnl3
>>>   python3-libnl3-3.5.0-6.fc34.x86_64
>>>   11:19:01 aconole@RHTPC1VM0NT {(6a5c83bdd991...)} ~/git/linux/tools/testing/selftests/net/openvswitch$ 
>>>
>>> Was there some place you did not find it?
>> 
>> You're right, I missed that somehow.  But this is not an
>> https://github.com/coolshou/libnl3 project. :)
>> These are python bindings for the C libnl library:
>> 
>> $ dnf info python3-libnl3
>> Available Packages
>> Name         : python3-libnl3
>> Version      : 3.7.0
>> Release      : 1.fc36
>> Architecture : x86_64
>> Size         : 153 k
>> Source       : libnl3-3.7.0-1.fc36.src.rpm
>> Repository   : updates
>> Summary      : libnl3 binding for Python 3
>> URL          : http://www.infradead.org/~tgr/libnl/
>> License      : LGPLv2
>> Description  : Python 3 bindings for libnl3
>
> Actually, I can't find an equivalent package for Ubuntu 22.04.
> And since pip is not an option (pip install libnl3 is a different
> package), there is no way to install it there beside building
> from sources.
>
> Am I still missing something?

Well, I have switched the latest version to using pyroute2 - hopefully
this will be acceptable :)

>> 
>>>
>>>> I'm talking about https://github.com/coolshou/libnl3 .  Please,
>>>> correct me if that is not the right one.  There are too many
>>>> libraies with the name libnl out there...  That is also not a great
>>>> sign.
>>>
>>> Yes, this is the project.
>> 
>> Doensn't look like it...
>> 
>>> We did look at some of the ones you
>>> mentioned, but didn't find much.
>>>
>>> It is a sparse landscape of projects that provide netlink support in
>>> python.
>>>
>>>> The C library libnl (https://github.com/thom311/libnl) seems to
>>>> be well maintained in general.  It has experimental python
>>>> bindings which are not really supported much.  Python bindings
>>>> received only 2 actual code-changing commits in the last 7 years.
>>>> Both of them are just python 2/3 compatibility changes.
>>>> Maybe that is not that big of a deal since it's not really a
>>>> real python library, but a wrapper on top of a main C library.
>>>> However, I didn't find these python bindings to be packaged in
>>>> distributions.  And they seem to be not available in pip as well.
>>>> So, building them is kind of a pain.
>>>
>>> Well, the python libnl3 should be installable via pip3.  Ex:
>>>
>>>   11:27:15 aconole@RHTPC1VM0NT ~$ pip3 install libnl3
>>>   Defaulting to user installation because normal site-packages is not writeable
>>>   Collecting libnl3
>>>     Using cached libnl3-0.3.0-py3-none-any.whl (89 kB)
>>>   Installing collected packages: libnl3
>>>   Successfully installed libnl3-0.3.0
>> 
>> And this is https://pypi.org/project/libnl3/, which is the
>> https://github.com/coolshou/libnl3 project.  So, by installing
>> libnl3 via pip and installing python3-libnl3 from the fedora
>> you're getting two completely different libraries.
>> 
>> So, which one users should use?
>> 
>> I can't find python bindings for the C libnl (which is the
>> python3-libnl3 package) in pypi, so it can't be installed
>> with pip.
>> 
>> 
>>>
>>> So I guess that is worth something.
>>>
>>> At least on Fedora it is installable from distribution as well.
>>>
>>>> There is another option which is pyroute2.  It positions itself
>>>> primarily as a netlink library and it does include an
>>>> pyroute2.netlink module indeed:
>>>>   https://github.com/svinota/pyroute2/tree/master/pyroute2/netlink
>>>> See the __init__.py for usage examples.
>>>>
>>>> This one looks to me like the most trustworthy.  It is actively
>>>> used by everyone in the python networking world, e.g. by OpenStack.
>>>> And it is actively developed and maintained unlike other
>>>> netlink-related python projects.  It is also packaged in most of the
>>>> main distributions, so it's easy to install and use.  Many people
>>>> already have it installed for other purposes.
>>>>
>>>> TBH, I didn't compare the functionality, but I'd expect that most
>>>> of the things we need are implemented.
>>>>
>>>> What do you think?
>>>
>>> We can certainly look at switching, but having a quick glance, it seems
>>> pyroute2 expects to provide the genl commands as well, so they would
>>> want us to create an ovs module in pyroute2 that includes all of the ovs
>>> family support.  Of course, we can always do this just in our module,
>>> but I think it isn't the way pyroute2 project wants to be structured.
>>> More like a library that provides all the command functionality.
>> 
>> What I was thinking is to import pyroute2.netlink and the
>> pyroute2.netlink.generic  and go from there.  But I didn't
>> look too deep on how to actually implement the functionality.
>> 
>> The python bindings for the C libnl (python3-libnl3) sounds
>> like a fine option since they are actually packaged in
>> distributions (missed that in my initial reply).  However,
>> the fact that you can not install them via pip and actually
>> you will install something but completely different is kind
>> of weird.  This has to be at least better documented, so
>> users will know what to install and they will not try to use
>> pip for that.
>> 
>>>
>>>> On the other note, I'm not a real python developer, but the code
>>>> looks more like a C than a python even for me.  Firstly, I'd say
>>>> that it would be great to maintain some coding style, e.g. by
>>>> checking with flake8 and/or black.  See some issues/suggestions
>>>> provided by these tools below.
>>>
>>> Agreed.  BTW, on the rhel8 system I developed on:
>>>
>>>   [root@wsfd-netdev60 openvswitch]# flake8 ./ovs-dpctl.py 
>>>   [root@wsfd-netdev60 openvswitch]# 
>>>
>>> So, I guess it is probably that I should have used a different system to
>>> do the flake8 checks.
>> 
>> Maybe the python version is different...  I was running on f36
>> with python 3.10.  Also, the list of defaults might be different.
>> flake8 doesn't use default ignore list if one is explicitly provided.
>> 
>>>
>>>> Secondly, we shouldd at least use argparse for argument parsing.
>>>> It's part of the standard library since python 3.2, so doens't
>>>> require any special dependencies to be installed.
>>>
>>> Okay - I can switch to argparse.  TBH, I haven't kept up with python
>>> standard library for some time.
>> 
>> Well, 3.2 was released 11 years ago. :)
>> 
>>>
>>>> Some parts of the code can probably be re-written to be more
>>>> "pythonic" as well, but I won't dive into that for now.  I didn't
>>>> review the code deep enough for that.
>>>
>>> I have difficulty sometimes understanding what it means to be "Real
>>> Python (tm)" - I don't plan to change things too much.  I can certainly
>>> switch to using argparse, but unless you give something you want to
>>> change, I would not change anything.
>> 
>> I breifly looked through code and though I don't fully
>> understand what this piece supposed to do:
>> 
>> +        segment = hdrval.find(":")
>> +        if segment == -1:
>> +            segment = len(hdrval)
>> +        hdrver = int(hdrval[:segment], 0)
>> +        if len(hdrval[:segment]):
>> +            userfeatures = int(hdrval[:segment], 0)
>> 
>> but I have a strong feeling that this part can benefit
>> from use of hdrval.split(':').
>> 
>> I won't insist on that too much. :)
>> 
>> Best regards, Ilya Maximets.

