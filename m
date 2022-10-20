Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F88606493
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 17:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiJTPcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 11:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbiJTPcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 11:32:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8851AD6B3
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 08:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666279949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gDcGWVURujAJnDW5B5ralktnDk7lRz6ewfCuzHG7XUk=;
        b=P3aZkraB1LfpY8lGaZNw83Xp034yEgfwAMPwejA1wSzdPW833R06prTLyxMi+gdY8E8wwE
        ANfIEXYfgEYWy8KcvEM3vAk5U85OAWHFbOsALYfBugVdJBwRTr2XuyvJti3qV6+6cDonkO
        ldTQS71T7Q1UrmFIjZ4IpY/QXX9ST5w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-ZSgIkAt1NfK8VxGDk5uCgg-1; Thu, 20 Oct 2022 11:32:25 -0400
X-MC-Unique: ZSgIkAt1NfK8VxGDk5uCgg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FF9A185A7AB;
        Thu, 20 Oct 2022 15:32:24 +0000 (UTC)
Received: from RHTPC1VM0NT (unknown [10.22.8.238])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 41FD72166B33;
        Thu, 20 Oct 2022 15:32:16 +0000 (UTC)
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
Date:   Thu, 20 Oct 2022 11:32:14 -0400
In-Reply-To: <88eff2a1-495c-0e89-44bf-1478db7d0661@ovn.org> (Ilya Maximets's
        message of "Thu, 20 Oct 2022 15:21:52 +0200")
Message-ID: <f7ty1taqznl.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ilya,

Ilya Maximets <i.maximets@ovn.org> writes:

> On 10/19/22 20:30, Aaron Conole wrote:
>> Previous commit resolves a WARN splat that can be difficult to reproduce,
>> but with the ovs-dpctl.py utility, it can be trivial.  Introduce a test
>> case which creates a DP, and then downgrades the feature set.  This will
>> include a utility 'ovs-dpctl.py' that can be extended to do additional
>> work.
>> 
>> Signed-off-by: Aaron Conole <aconole@redhat.com>
>> Signed-off-by: Kevin Sprague <ksprague0711@gmail.com>
>> ---
>>  MAINTAINERS                                   |   1 +
>>  tools/testing/selftests/Makefile              |   1 +
>>  .../selftests/net/openvswitch/Makefile        |  13 +
>>  .../selftests/net/openvswitch/openvswitch.sh  | 216 +++++++++
>>  .../selftests/net/openvswitch/ovs-dpctl.py    | 411 ++++++++++++++++++
>>  5 files changed, 642 insertions(+)
>>  create mode 100644 tools/testing/selftests/net/openvswitch/Makefile
>>  create mode 100755 tools/testing/selftests/net/openvswitch/openvswitch.sh
>>  create mode 100644 tools/testing/selftests/net/openvswitch/ovs-dpctl.py
>> 
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index abbe88e1c50b..295a6b0fbe26 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -15434,6 +15434,7 @@ S:	Maintained
>>  W:	http://openvswitch.org
>>  F:	include/uapi/linux/openvswitch.h
>>  F:	net/openvswitch/
>> +F:	tools/testing/selftests/net/openvswitch/
>>  
>>  OPERATING PERFORMANCE POINTS (OPP)
>>  M:	Viresh Kumar <vireshk@kernel.org>
>
> ...
>
>> +exit ${exitcode}
>> diff --git a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
>> b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
>> new file mode 100644
>> index 000000000000..791d76b7adcd
>> --- /dev/null
>> +++ b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
>> @@ -0,0 +1,411 @@
>> +#!/usr/bin/env python3
>> +# SPDX-License-Identifier: GPL-2.0
>> +
>> +# Controls the openvswitch module.  Part of the kselftest suite, but
>> +# can be used for some diagnostic purpose as well.
>> +
>> +import logging
>> +import multiprocessing
>> +import socket
>> +import struct
>> +import sys
>> +
>> +try:
>> +    from libnl.attr import NLA_NESTED, NLA_STRING, NLA_U32, NLA_UNSPEC
>> +    from libnl.attr import nla_get_string, nla_get_u32
>> +    from libnl.attr import nla_put, nla_put_string, nla_put_u32
>> +    from libnl.attr import nla_policy
>> +
>> +    from libnl.error import errmsg
>> +
>> +    from libnl.genl.ctrl import genl_ctrl_resolve
>> +    from libnl.genl.genl import genl_connect, genlmsg_parse, genlmsg_put
>> +
>> +    from libnl.handlers import nl_cb_alloc, nl_cb_set
>> +    from libnl.handlers import NL_CB_CUSTOM, NL_CB_MSG_IN, NL_CB_VALID
>> +    from libnl.handlers import NL_OK, NL_STOP
>> +
>> +    from libnl.linux_private.netlink import NLM_F_ACK, NLM_F_DUMP
>> +    from libnl.linux_private.netlink import NLM_F_REQUEST, NLMSG_DONE
>> +
>> +    from libnl.msg import NL_AUTO_SEQ, nlmsg_alloc, nlmsg_hdr
>> +
>> +    from libnl.nl import NLMSG_ERROR, nl_recvmsgs_default, nl_send_auto
>> +    from libnl.socket_ import nl_socket_alloc, nl_socket_set_cb
>> +    from libnl.socket_ import nl_socket_get_local_port
>> +except ModuleNotFoundError:
>> +    print("Need to install the python libnl3 library.")
>
>
> Hey, Aaron and Kevin.  Selftests sounds like a very important and
> long overdue thing to add.  Thanks for working on this!
>
> I have some worries about the libnl3 library though.  It doesn't
> seem to be maintained well.  It it maintained by a single person,
> it it was at least 3 different single persons over the last 7
> years via forks.  It didn't get any significant development done
> since 2015 as well and no commits at all for a last 1.5 years.
> It is not packaged by any major distributions.

:-/  On my fedora:

  11:12:24 aconole@RHTPC1VM0NT ~$ dnf search python3-libnl3
  Last metadata expiration check: 1 day, 0:25:11 ago on Wed 19 Oct 2022 10:47:21 AM EDT.
  ===================== Name Exactly Matched: python3-libnl3 =====================
  python3-libnl3.x86_64 : libnl3 binding for Python 3


And I can use it:

  11:18:39 aconole@RHTPC1VM0NT {(6a5c83bdd991...)} ~/git/linux/tools/testing/selftests/net/openvswitch$ sudo python3 ./ovs-dpctl.py show
  foop
    Lookups: Hit: 0 Missed: 0 Lost: 0
    Flows: 0
    Masks: Hit: 0 Total: 0
    Cache: Hit: 0
  Caches:
    Masks-cache: size: 256
      Port 0: foop (internal)
  11:18:43 aconole@RHTPC1VM0NT {(6a5c83bdd991...)} ~/git/linux/tools/testing/selftests/net/openvswitch$ rpm -qa | grep python3-libnl3
  python3-libnl3-3.5.0-6.fc34.x86_64
  11:19:01 aconole@RHTPC1VM0NT {(6a5c83bdd991...)} ~/git/linux/tools/testing/selftests/net/openvswitch$ 

Was there some place you did not find it?

> I'm talking about https://github.com/coolshou/libnl3 .  Please,
> correct me if that is not the right one.  There are too many
> libraies with the name libnl out there...  That is also not a great
> sign.

Yes, this is the project.  We did look at some of the ones you
mentioned, but didn't find much.

It is a sparse landscape of projects that provide netlink support in
python.

> The C library libnl (https://github.com/thom311/libnl) seems to
> be well maintained in general.  It has experimental python
> bindings which are not really supported much.  Python bindings
> received only 2 actual code-changing commits in the last 7 years.
> Both of them are just python 2/3 compatibility changes.
> Maybe that is not that big of a deal since it's not really a
> real python library, but a wrapper on top of a main C library.
> However, I didn't find these python bindings to be packaged in
> distributions.  And they seem to be not available in pip as well.
> So, building them is kind of a pain.

Well, the python libnl3 should be installable via pip3.  Ex:

  11:27:15 aconole@RHTPC1VM0NT ~$ pip3 install libnl3
  Defaulting to user installation because normal site-packages is not writeable
  Collecting libnl3
    Using cached libnl3-0.3.0-py3-none-any.whl (89 kB)
  Installing collected packages: libnl3
  Successfully installed libnl3-0.3.0

So I guess that is worth something.

At least on Fedora it is installable from distribution as well.

> There is another option which is pyroute2.  It positions itself
> primarily as a netlink library and it does include an
> pyroute2.netlink module indeed:
>   https://github.com/svinota/pyroute2/tree/master/pyroute2/netlink
> See the __init__.py for usage examples.
>
> This one looks to me like the most trustworthy.  It is actively
> used by everyone in the python networking world, e.g. by OpenStack.
> And it is actively developed and maintained unlike other
> netlink-related python projects.  It is also packaged in most of the
> main distributions, so it's easy to install and use.  Many people
> already have it installed for other purposes.
>
> TBH, I didn't compare the functionality, but I'd expect that most
> of the things we need are implemented.
>
> What do you think?

We can certainly look at switching, but having a quick glance, it seems
pyroute2 expects to provide the genl commands as well, so they would
want us to create an ovs module in pyroute2 that includes all of the ovs
family support.  Of course, we can always do this just in our module,
but I think it isn't the way pyroute2 project wants to be structured.
More like a library that provides all the command functionality.

> On the other note, I'm not a real python developer, but the code
> looks more like a C than a python even for me.  Firstly, I'd say
> that it would be great to maintain some coding style, e.g. by
> checking with flake8 and/or black.  See some issues/suggestions
> provided by these tools below.

Agreed.  BTW, on the rhel8 system I developed on:

  [root@wsfd-netdev60 openvswitch]# flake8 ./ovs-dpctl.py 
  [root@wsfd-netdev60 openvswitch]# 

So, I guess it is probably that I should have used a different system to
do the flake8 checks.

> Secondly, we shouldd at least use argparse for argument parsing.
> It's part of the standard library since python 3.2, so doens't
> require any special dependencies to be installed.

Okay - I can switch to argparse.  TBH, I haven't kept up with python
standard library for some time.

> Some parts of the code can probably be re-written to be more
> "pythonic" as well, but I won't dive into that for now.  I didn't
> review the code deep enough for that.

I have difficulty sometimes understanding what it means to be "Real
Python (tm)" - I don't plan to change things too much.  I can certainly
switch to using argparse, but unless you give something you want to
change, I would not change anything.

> Best regards, Ilya Maximets.
>
> $ flake8 --ignore=E203,W504,W503 ./dpctl.py
> ./dpctl.py:14:38: H301: one import per line
> ./dpctl.py:15:42: H301: one import per line
> ./dpctl.py:16:35: H301: one import per line
> ./dpctl.py:22:45: H301: one import per line
> ./dpctl.py:24:43: H301: one import per line
> ./dpctl.py:25:44: H301: one import per line
> ./dpctl.py:26:37: H301: one import per line
> ./dpctl.py:28:54: H301: one import per line
> ./dpctl.py:29:58: H301: one import per line
> ./dpctl.py:31:38: H301: one import per line
> ./dpctl.py:33:37: H301: one import per line
> ./dpctl.py:34:46: H301: one import per line
> ./dpctl.py:118:1: H404: multi line docstring should start without a leading new line
> ./dpctl.py:118:1: H405: multi line docstring summary not separated with an empty line
> ./dpctl.py:119:1: H404: multi line docstring should start without a leading new line
> ./dpctl.py:119:1: H405: multi line docstring summary not separated with an empty line
> ./dpctl.py:120:1: H404: multi line docstring should start without a leading new line
> ./dpctl.py:120:1: H405: multi line docstring summary not separated with an empty line
> ./dpctl.py:121:1: H404: multi line docstring should start without a leading new line
> ./dpctl.py:121:1: H405: multi line docstring summary not separated with an empty line
> ./dpctl.py:130:1: H404: multi line docstring should start without a leading new line
> ./dpctl.py:130:1: H405: multi line docstring summary not separated with an empty line
> ./dpctl.py:131:1: H404: multi line docstring should start without a leading new line
> ./dpctl.py:131:1: H405: multi line docstring summary not separated with an empty line
> ./dpctl.py:132:1: H404: multi line docstring should start without a leading new line
> ./dpctl.py:132:1: H405: multi line docstring summary not separated with an empty line
> ./dpctl.py:133:1: H404: multi line docstring should start without a leading new line
> ./dpctl.py:133:1: H405: multi line docstring summary not separated with an empty line
> ./dpctl.py:200:13: E126 continuation line over-indented for hanging indent
> ./dpctl.py:207:9: E121 continuation line under-indented for hanging indent
> ./dpctl.py:358:1: H404: multi line docstring should start without a leading new line
> ./dpctl.py:358:1: H405: multi line docstring summary not separated with an empty line
> ./dpctl.py:359:1: H404: multi line docstring should start without a leading new line
> ./dpctl.py:359:1: H405: multi line docstring summary not separated with an empty line
> ./dpctl.py:360:1: H404: multi line docstring should start without a leading new line
> ./dpctl.py:360:1: H405: multi line docstring summary not separated with an empty line
> ./dpctl.py:361:1: H404: multi line docstring should start without a leading new line
> ./dpctl.py:361:1: H405: multi line docstring summary not separated with an empty line
>
> Black also provides some readability suggestions like this:

Okay, I'll install black on my system and do some development there.
Additionally, I will use flake8 on my system.

> $ black -l 80 -S --check --diff dpctl.py 
> --- dpctl.py    2022-10-19 21:24:34.352403 +0000
> +++ dpctl.py    2022-10-20 13:15:29.095154 +0000
> @@ -137,12 +137,18 @@
>      if ret:
>          print(errmsg[abs(ret)])
>          sk = None
>          return ret
>      ovs_families = {}
> -    family_probe = [OVS_DATAPATH_FAMILY, OVS_VPORT_FAMILY, OVS_FLOW_FAMILY,
> -                    OVS_PACKET_FAMILY, OVS_METER_FAMILY, OVS_CT_LIMIT_FAMILY]
> +    family_probe = [
> +        OVS_DATAPATH_FAMILY,
> +        OVS_VPORT_FAMILY,
> +        OVS_FLOW_FAMILY,
> +        OVS_PACKET_FAMILY,
> +        OVS_METER_FAMILY,
> +        OVS_CT_LIMIT_FAMILY,
> +    ]
>      for family in family_probe:
>          ovs_families[family] = get_family(family)
>          if ovs_families[family] == -1:
>              return -1
>      return 0
> @@ -150,19 +156,21 @@
>  
>  def parse_dp_msg(nlh, target_dict):
>      dp_dict = {}
>      attrs = dict((i, None) for i in range(OVS_DP_ATTR_MAX))
>      dp_policy = dict((i, None) for i in range(OVS_DP_ATTR_MAX))
> -    dp_policy.update({
> -        OVS_DP_ATTR_NAME: nla_policy(type_=NLA_STRING, maxlen=15),
> -        OVS_DP_ATTR_UPCALL_PID: nla_policy(type_=NLA_U32),
> -        OVS_DP_ATTR_STATS: nla_policy(type_=NLA_NESTED),
> -        OVS_DP_ATTR_MEGAFLOW_STATS: nla_policy(type_=NLA_NESTED),
> -        OVS_DP_ATTR_USER_FEATURES: nla_policy(type_=NLA_U32),
> -        OVS_DP_ATTR_MASKS_CACHE_SIZE: nla_policy(type_=NLA_U32),
> -        OVS_DP_ATTR_PER_CPU_PIDS: nla_policy(type_=NLA_UNSPEC)
> -    })
> +    dp_policy.update(
> +        {
> +            OVS_DP_ATTR_NAME: nla_policy(type_=NLA_STRING, maxlen=15),
> +            OVS_DP_ATTR_UPCALL_PID: nla_policy(type_=NLA_U32),
> +            OVS_DP_ATTR_STATS: nla_policy(type_=NLA_NESTED),
> +            OVS_DP_ATTR_MEGAFLOW_STATS: nla_policy(type_=NLA_NESTED),
> +            OVS_DP_ATTR_USER_FEATURES: nla_policy(type_=NLA_U32),
> +            OVS_DP_ATTR_MASKS_CACHE_SIZE: nla_policy(type_=NLA_U32),
> +            OVS_DP_ATTR_PER_CPU_PIDS: nla_policy(type_=NLA_UNSPEC),
> +        }
> +    )
>      ret = genlmsg_parse(nlh, 4, attrs, OVS_DP_ATTR_MAX, dp_policy)
>      if ret:
>          print("Error parsing datapath")
>          return -1
>      if attrs[1] is None:
> @@ -173,11 +181,12 @@
>      dp_dict[OVS_DP_ATTR_STATS] = stats
>      b = bytes(attrs[OVS_DP_ATTR_MEGAFLOW_STATS].payload)
>      stats = struct.unpack("=QIIQQ", b[:32])
>      dp_dict[OVS_DP_ATTR_MEGAFLOW_STATS] = [stats[i] for i in (0, 1, 3)]
>      dp_dict[OVS_DP_ATTR_MASKS_CACHE_SIZE] = nla_get_u32(
> -        attrs[OVS_DP_ATTR_MASKS_CACHE_SIZE])
> +        attrs[OVS_DP_ATTR_MASKS_CACHE_SIZE]
> +    )
>      target_dict[dp_name] = dp_dict
>  
>  
>  def show_dp_cb(msg, dp_dict):
>      nlh = nlmsg_hdr(msg)
> @@ -194,19 +203,21 @@
>      retn = None
>      if nlh.nlmsg_type == NLMSG_DONE:
>          retn = NL_STOP
>      attrs = dict((i, None) for i in range(OVS_DP_ATTR_MAX))
>      port_policy = dict((i, None) for i in range(OVS_VPORT_ATTR_MAX))
> -    port_policy.update({
> +    port_policy.update(
> +        {
>              OVS_VPORT_ATTR_PORT_NO: nla_policy(type_=NLA_U32),
>              OVS_VPORT_ATTR_TYPE: nla_policy(type_=NLA_U32),
>              OVS_VPORT_ATTR_NAME: nla_policy(type_=NLA_STRING, maxlen=15),
>              OVS_VPORT_ATTR_OPTIONS: nla_policy(type_=NLA_NESTED),
>              OVS_VPORT_ATTR_UPCALL_PID: nla_policy(type_=NLA_UNSPEC),
>              OVS_VPORT_ATTR_STATS: nla_policy(type_=NLA_NESTED),
>              OVS_VPORT_ATTR_IFINDEX: nla_policy(type_=NLA_U32),
> -        })
> +        }
> +    )
>      genlmsg_parse(nlh, OVS_HDR_LEN, attrs, OVS_DP_ATTR_MAX, port_policy)
>      if attrs[1] is not None:
>          port_info = "Port " + str(nla_get_u32(attrs[1])) + ": "
>          if attrs[3] is not None:
>              port_info += nla_get_string(attrs[3]).decode('utf-8')
> @@ -234,12 +245,17 @@
>          f_zip = zip(fields, dp_info[i][OVS_DP_ATTR_MEGAFLOW_STATS])
>          format_list = [val for pair in f_zip for val in pair]
>          out_string = indent + "Masks: {}: {} {}: {}\n"
>          out_string += indent + "Cache: {}: {}"
>          print(out_string.format(*format_list))
> -        print("Caches:\n" + indent + "Masks-cache: size: {}".
> -              format(dp_info[i][OVS_DP_ATTR_MASKS_CACHE_SIZE]))
> +        print(
> +            "Caches:\n"
> +            + indent
> +            + "Masks-cache: size: {}".format(
> +                dp_info[i][OVS_DP_ATTR_MASKS_CACHE_SIZE]
> +            )
> +        )
>          indent = 4 * " "
>          for port in vport_info[i]:
>              print(indent + port)
>  
>  
> @@ -255,27 +271,46 @@
>              print("That interface does not exist.")
>              return -1
>          flag = NLM_F_REQUEST
>      else:
>          flag = NLM_F_DUMP
> -    genlmsg_put(msg_dpctl_get, 0, NL_AUTO_SEQ,
> -                ovs_families[OVS_DATAPATH_FAMILY], OVS_HDR_LEN,
> -                flag, OVS_DP_CMD_GET, OVS_DATAPATH_VERSION)
> +    genlmsg_put(
> +        msg_dpctl_get,
> +        0,
> +        NL_AUTO_SEQ,
> +        ovs_families[OVS_DATAPATH_FAMILY],
> +        OVS_HDR_LEN,
> +        flag,
> +        OVS_DP_CMD_GET,
> +        OVS_DATAPATH_VERSION,
> +    )
>      if dp is not None:
>          nla_put_string(msg_dpctl_get, OVS_DP_ATTR_NAME, dp.encode('utf-8'))
>      nl_sk_transaction(msg_dpctl_get, sk, cb_dp_show)
>      vport_info = dict((i, []) for i in dp_info)
>      # for each datapath, call down and ask it to tell us its vports.
>      for dp in vport_info:
>          msg_vport_get = nlmsg_alloc()
> -        ba = genlmsg_put(msg_vport_get, 0, NL_AUTO_SEQ,
> -                         ovs_families[OVS_VPORT_FAMILY], OVS_HDR_LEN,
> -                         NLM_F_DUMP, OVS_VPORT_CMD_GET, OVS_DATAPATH_VERSION)
> +        ba = genlmsg_put(
> +            msg_vport_get,
> +            0,
> +            NL_AUTO_SEQ,
> +            ovs_families[OVS_VPORT_FAMILY],
> +            OVS_HDR_LEN,
> +            NLM_F_DUMP,
> +            OVS_VPORT_CMD_GET,
> +            OVS_DATAPATH_VERSION,
> +        )
>          ba[0:OVS_HDR_LEN] = struct.pack('=I', socket.if_nametoindex(dp))
>          cb_vport_show = nl_cb_alloc(NL_CB_CUSTOM)
> -        nl_cb_set(cb_vport_show, NL_CB_VALID, NL_CB_CUSTOM,
> -                  show_vport_cb, (dp, vport_info))
> +        nl_cb_set(
> +            cb_vport_show,
> +            NL_CB_VALID,
> +            NL_CB_CUSTOM,
> +            show_vport_cb,
> +            (dp, vport_info),
> +        )
>          nl_sk_transaction(msg_vport_get, sk, cb_vport_show)
>      dpctl_show_print(dp_info, vport_info)
>  
>  
>  def mod_cb(msg, add):
> @@ -308,13 +343,20 @@
>              segment = len(hdrval)
>          hdrver = int(hdrval[:segment], 0)
>          if len(hdrval[:segment]):
>              userfeatures = int(hdrval[:segment], 0)
>  
> -    genlmsg_put(msg_dpctl_cmd, 0, NL_AUTO_SEQ,
> -                ovs_families[OVS_DATAPATH_FAMILY], OVS_HDR_LEN,
> -                NLM_F_ACK, cmd, hdrver)
> +    genlmsg_put(
> +        msg_dpctl_cmd,
> +        0,
> +        NL_AUTO_SEQ,
> +        ovs_families[OVS_DATAPATH_FAMILY],
> +        OVS_HDR_LEN,
> +        NLM_F_ACK,
> +        cmd,
> +        hdrver,
> +    )
>  
>      nla_put_u32(msg_dpctl_cmd, OVS_DP_ATTR_UPCALL_PID, 0)
>      nla_put_string(msg_dpctl_cmd, OVS_DP_ATTR_NAME, dp.encode('utf-8'))
>  
>      if setpid:
> @@ -325,12 +367,13 @@
>          for i in range(nproc):
>              if procarray is not None:
>                  procarray += struct.pack("=I", nl_socket_get_local_port(sk))
>              else:
>                  procarray = struct.pack('=I', nl_socket_get_local_port(sk))
> -        nla_put(msg_dpctl_cmd, OVS_DP_ATTR_UPCALL_PID, len(procarray),
> -                procarray)
> +        nla_put(
> +            msg_dpctl_cmd, OVS_DP_ATTR_UPCALL_PID, len(procarray), procarray
> +        )
>      nla_put_u32(msg_dpctl_cmd, OVS_DP_ATTR_USER_FEATURES, userfeatures)
>      cb_dp_mod = nl_cb_alloc(NL_CB_CUSTOM)
>      nl_cb_set(cb_dp_mod, NL_CB_MSG_IN, NL_CB_CUSTOM, mod_cb, add)
>      return nl_sk_transaction(msg_dpctl_cmd, sk, cb_dp_mod)
>  
> @@ -388,19 +431,19 @@
>              else:
>                  dpctl_show(argv[count])
>              return 0
>          elif arg == "add-dp":
>              dpctl_netlink_init()
> -            if len(argv) < 3:   # 3rd arg should be DP name or additional opts
> +            if len(argv) < 3:  # 3rd arg should be DP name or additional opts
>                  help("Missing a DP name")
>                  return -1
>              else:
>                  dpctl_add_dp(argv[count:])
>              return 0
>          elif arg == "del-dp":
>              dpctl_netlink_init()
> -            if len(argv) < 3:   # 3rd arg MUST be DP name
> +            if len(argv) < 3:  # 3rd arg MUST be DP name
>                  help("Missing a DP name")
>                  return -1
>              else:
>                  dpctl_del_dp(argv[count])
>              return 0
> ---

