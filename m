Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B64E1E130B
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 18:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391267AbgEYQtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 12:49:50 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:45980 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388279AbgEYQtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 12:49:50 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04PGndvC055595;
        Mon, 25 May 2020 11:49:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590425379;
        bh=0vnr9ZSxH/gu+SWUmdVYynFBAw9sxHpQB9LQfQVihOk=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=JR2+PeC5ByUl5uzgqneZGkEnvCNTqSFy3fNq9SV+2WLiKfvGMVvrxXhFcobJGywR1
         1ktNiSpef7XJ5FAvkEwb61wS8vkWhx9hot48EfvJY8k3bWIDvn1jXK04lRGuqB3SgJ
         xF6M98EmFE4tlcDpD8Zz25e0C4o3syrYDExTDgSo=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04PGndYK002802
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 25 May 2020 11:49:39 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 25
 May 2020 11:49:39 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 25 May 2020 11:49:39 -0500
Received: from [10.250.74.234] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04PGnc5A098076;
        Mon, 25 May 2020 11:49:39 -0500
Subject: Re: [net-next RFC PATCH 00/13] net: hsr: Add PRP driver
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>
References: <20200506163033.3843-1-m-karicheri2@ti.com>
 <87r1vdkxes.fsf@intel.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <5feae5ae-af46-f4b6-fe91-91a19036112b@ti.com>
Date:   Mon, 25 May 2020 12:49:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87r1vdkxes.fsf@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On 5/21/20 1:31 PM, Vinicius Costa Gomes wrote:
> Murali Karicheri <m-karicheri2@ti.com> writes:
> 
------------ Snip-------------

>>    - prefix all common code with hsr_prp
>>    - net/hsr -> renamed to net/hsr-prp
>>    - All common struct types, constants, functions renamed with
>>      hsr{HSR}_prp{PRP} prefix.
> 
> I don't really like these prefixes, I am thinking of when support for
> IEEE 802.1CB is added, do we rename this to "hsr_prp_frer"?
> 
> And it gets even more complicated, and using 802.1CB you can configure
> the tagging method and the stream identification function so a system
> can interoperate in a HSR or PRP network.
> 
> So, I see this as different methods of achieving the same result, which
> makes me think that the different "methods/types" (HSR and PRP in your
> case) should be basically different implementations of a "struct
> hsr_ops" interface. With this hsr_ops something like this:
> 
>     struct hsr_ops {
>            int (*handle_frame)()
>            int (*add_port)()
>            int (*remove_port)()
>            int (*setup)()
>            void (*teardown)()
>     };
> 

Thanks for your response!

I agree with you that the prefix renaming is ugly. However I wasn't
sure if it is okay to use a hsr prefixed code to handle PRP as
well as it may not be intuitive to anyone investigating the code. For
the same reason, handling 802.1CB specifc functions using the hsr_
prefixed code. If that is okay, then patch 1-6 are unnecessary. We could
also add some documentation at the top of the file to indicate that
both hsr and prp are implemented in the code or something like that.
BTW, I need to investigate more into 802.1CB and this was not known
when I developed this code few years ago.

Main difference between HSR and PRP is how they handle the protocol tag
or rct and create or handle the protocol specific part in the frame.
For that part, we should be able to define ops() like you have
suggested, instead of doing if check throughout the code. Hope that
is what you meant by hsr_ops() for this. Again shouldn't we use some 
generic name like proto_ops or red_ops instead of hsr_ops() and assign
protocol specific implementaion to them? i.e hsr_ or prp_
or 802.1CB specific functions assigned to the function pointers. For
now I see handle_frame(), handle_sv_frame, create_frame(), 
create_sv_frame() etc implemented differently (This is currently part of
patch 11 & 12). So something like

    struct proto_ops {
	int (*handle_frame)();
	int (*create_frame)();
	int (*handle_sv_frame)();
	int (*create_sv_frame)();
    };

and call dev->proto_ops->handle_frame() to process a frame from the
main hook. proto_ops gets initialized to of the set if implementation
at device or interface creation in hsr_dev_finalize().

>>
>> Please review this and provide me feedback so that I can work to
>> incorporate them and send a formal patch series for this. As this
>> series impacts user space, I am not sure if this is the right
>> approach to introduce a new definitions and obsolete the old
>> API definitions for HSR. The current approach is choosen
>> to avoid redundant code in iproute2 and in the netlink driver
>> code (hsr_netlink.c). Other approach we discussed internally was
>> to Keep the HSR prefix in the user space and kernel code, but
>> live with the redundant code in the iproute2 and hsr netlink
>> code. Would like to hear from you what is the best way to add
>> this feature to networking core. If there is any other
>> alternative approach possible, I would like to hear about the
>> same.
> 
> Why redudant code is needed in the netlink parts and in iproute2 when
> keeping the hsr prefix?

May be this is due to the specific implementation that I chose.
Currently I have separate netlink socket for HSR and PRP which may
be an overkill since bith are similar protocol.

Currently hsr inteface is created as

ip link add name hsr0 type hsr slave1 eth0 slave2 eth1 supervision 0

So I have implemented similar command for prp

ip link add name prp0 type prp slave1 eth0 slave2 eth1 supervision 0

In patch 7/13 I renamed existing HSR netlink socket attributes that
defines the hsr interface with the assumption that we can obsolete
the old definitions in favor of new common definitions with the
HSR_PRP prefix. Then I have separate code for creating prp
interface and related functions, even though they are similar.
So using common definitions, I re-use the code in netlink and
iproute2 (see patch 8 and 9 to re-use the code). PRP netlink
socket code in patch 10 which register prp_genl_family similar
to HSR.

+static struct genl_family prp_genl_family __ro_after_init = {
+	.hdrsize = 0,
+	.name = "PRP",
+	.version = 1,
+	.maxattr = HSR_PRP_A_MAX,
+	.policy = prp_genl_policy,
+	.module = THIS_MODULE,
+	.ops = prp_ops,
+	.n_ops = ARRAY_SIZE(prp_ops),
+	.mcgrps = prp_mcgrps,
+	.n_mcgrps = ARRAY_SIZE(prp_mcgrps),
+};
+
+int __init prp_netlink_init(void)
+{
+	int rc;
+
+	rc = rtnl_link_register(&prp_link_ops);
+	if (rc)
+		goto fail_rtnl_link_register;
+
+	rc = genl_register_family(&prp_genl_family);
+	if (rc)
+		goto fail_genl_register_family;


If we choose to re-use the existing HSR_ uapi defines, then should we
re-use the hsr netlink socket interface for PRP as well and
add additional attribute for differentiating the protocol specific
part?

i.e introduce protocol attribute to existing HSR uapi defines for
netlink socket to handle creation of prp interface.

enum {
	HSR_A_UNSPEC,
	HSR_A_NODE_ADDR,
	HSR_A_IFINDEX,
	HSR_A_IF1_AGE,
	HSR_A_IF2_AGE,
	HSR_A_NODE_ADDR_B,
	HSR_A_IF1_SEQ,
	HSR_A_IF2_SEQ,
	HSR_A_IF1_IFINDEX,
	HSR_A_IF2_IFINDEX,
	HSR_A_ADDR_B_IFINDEX,
+       HSR_A_PROTOCOL  <====if missing it is HSR (backward 	
			     compatibility)
                              defines HSR or PRP or 802.1CB in future.
	__HSR_A_MAX,
};

So if ip link command is

ip link add name <if name> type <proto> slave1 eth0 slave2 eth1 
supervision 0

Add HSR_A_PROTOCOL attribute with HSR/PRP specific value.

This way, the iprout2 code mostly remain the same as hsr, but will
change a bit to introduced this new attribute if user choose proto as
'prp' vs 'hsr'

BTW, I have posted the existing iproute2 code also to the mailing list
with title 'iproute2: Add PRP support'.

If re-using hsr code with existing prefix is fine for PRP or any future
protocol such as 801.1B, then I will drop patch 1-6 that are essentially
doing some renaming and re-use existing hsr netlink code for PRP with
added attribute to differentiate the protocol at the driver as described
above along with proto_ops and re-spin the series.

Let me know.

Regards,

Murali
> 
>>
>> The patch was tested using two TI AM57x IDK boards which are
>> connected back to back over two CPSW ports.
>>
>> Script used for creating the hsr/prp interface is given below
>> and uses the ip link command. Also provided logs from the tests
>> I have executed for your reference.
>>
>> iproute2 related patches will follow soon....
>>
>> Murali Karicheri
>> Texas Instruments
>>
>> ============ setup.sh =================================================
>> #!/bin/sh
>> if [ $# -lt 4 ]
>> then
>>         echo "setup-cpsw.sh <hsr/prp> <MAC-Address of slave-A>"
>>         echo "  <ip address for hsr/prp interface>"
>>         echo "  <if_name of hsr/prp interface>"
>>         exit
>> fi
>>
>> if [ "$1" != "hsr" ] && [ "$1" != "prp" ]
>> then
>>         echo "use hsr or prp as first argument"
>>         exit
>> fi
>>
>> if_a=eth2
>> if_b=eth3
>> if_name=$4
>>
>> ifconfig $if_a down
>> ifconfig $if_b down
>> ifconfig $if_a hw ether $2
>> ifconfig $if_b hw ether $2
>> ifconfig $if_a up
>> ifconfig $if_b up
>>
>> echo "Setting up $if_name with MAC address $2 for slaves and IP address $3"
>> echo "          using $if_a and $if_b"
>>
>> if [ "$1" = "hsr" ]; then
>>         options="version 1"
>> else
>>         options=""
>> fi
>>
>> ip link add name $if_name type $1 slave1 $if_a slave2 $if_b supervision 0 $options
>> ifconfig $if_name $3 up
>> ==================================================================================
>> PRP Logs:
>>
>> DUT-1 : https://pastebin.ubuntu.com/p/hhsRjTQpcr/
>> DUT-2 : https://pastebin.ubuntu.com/p/snPFKhnpk4/
>>
>> HSR Logs:
>>
>> DUT-1 : https://pastebin.ubuntu.com/p/FZPNc6Nwdm/
>> DUT-2 : https://pastebin.ubuntu.com/p/CtV4ZVS3Yd/
>>
>> Murali Karicheri (13):
>>    net: hsr: Re-use Kconfig option to support PRP
>>    net: hsr: rename hsr directory to hsr-prp to introduce PRP
>>    net: hsr: rename files to introduce PRP support
>>    net: hsr: rename hsr variable inside struct hsr_port to priv
>>    net: hsr: rename hsr_port_get_hsr() to hsr_prp_get_port()
>>    net: hsr: some renaming to introduce PRP driver support
>>    net: hsr: introduce common uapi include/definitions for HSR and PRP
>>    net: hsr: migrate HSR netlink socket code to use new common API
>>    net: hsr: move re-usable code for PRP to hsr_prp_netlink.c
>>    net: hsr: add netlink socket interface for PRP
>>    net: prp: add supervision frame generation and handling support
>>    net: prp: add packet handling support
>>    net: prp: enhance debugfs to display PRP specific info in node table
>>
>>   MAINTAINERS                                   |   2 +-
>>   include/uapi/linux/hsr_netlink.h              |   3 +
>>   include/uapi/linux/hsr_prp_netlink.h          |  50 ++
>>   include/uapi/linux/if_link.h                  |  19 +
>>   net/Kconfig                                   |   2 +-
>>   net/Makefile                                  |   2 +-
>>   net/hsr-prp/Kconfig                           |  37 ++
>>   net/hsr-prp/Makefile                          |  11 +
>>   net/hsr-prp/hsr_netlink.c                     | 202 +++++++
>>   net/{hsr => hsr-prp}/hsr_netlink.h            |  15 +-
>>   .../hsr_prp_debugfs.c}                        |  82 +--
>>   net/hsr-prp/hsr_prp_device.c                  | 562 ++++++++++++++++++
>>   net/hsr-prp/hsr_prp_device.h                  |  23 +
>>   net/hsr-prp/hsr_prp_forward.c                 | 558 +++++++++++++++++
>>   .../hsr_prp_forward.h}                        |  10 +-
>>   .../hsr_prp_framereg.c}                       | 323 +++++-----
>>   net/hsr-prp/hsr_prp_framereg.h                |  68 +++
>>   net/hsr-prp/hsr_prp_main.c                    | 194 ++++++
>>   net/hsr-prp/hsr_prp_main.h                    | 289 +++++++++
>>   net/hsr-prp/hsr_prp_netlink.c                 | 365 ++++++++++++
>>   net/hsr-prp/hsr_prp_netlink.h                 |  28 +
>>   net/hsr-prp/hsr_prp_slave.c                   | 222 +++++++
>>   net/hsr-prp/hsr_prp_slave.h                   |  37 ++
>>   net/hsr-prp/prp_netlink.c                     | 141 +++++
>>   net/hsr-prp/prp_netlink.h                     |  27 +
>>   net/hsr/Kconfig                               |  29 -
>>   net/hsr/Makefile                              |  10 -
>>   net/hsr/hsr_device.c                          | 509 ----------------
>>   net/hsr/hsr_device.h                          |  22 -
>>   net/hsr/hsr_forward.c                         | 379 ------------
>>   net/hsr/hsr_framereg.h                        |  62 --
>>   net/hsr/hsr_main.c                            | 154 -----
>>   net/hsr/hsr_main.h                            | 188 ------
>>   net/hsr/hsr_netlink.c                         | 514 ----------------
>>   net/hsr/hsr_slave.c                           | 198 ------
>>   net/hsr/hsr_slave.h                           |  33 -
>>   36 files changed, 3084 insertions(+), 2286 deletions(-)
>>   create mode 100644 include/uapi/linux/hsr_prp_netlink.h
>>   create mode 100644 net/hsr-prp/Kconfig
>>   create mode 100644 net/hsr-prp/Makefile
>>   create mode 100644 net/hsr-prp/hsr_netlink.c
>>   rename net/{hsr => hsr-prp}/hsr_netlink.h (58%)
>>   rename net/{hsr/hsr_debugfs.c => hsr-prp/hsr_prp_debugfs.c} (52%)
>>   create mode 100644 net/hsr-prp/hsr_prp_device.c
>>   create mode 100644 net/hsr-prp/hsr_prp_device.h
>>   create mode 100644 net/hsr-prp/hsr_prp_forward.c
>>   rename net/{hsr/hsr_forward.h => hsr-prp/hsr_prp_forward.h} (50%)
>>   rename net/{hsr/hsr_framereg.c => hsr-prp/hsr_prp_framereg.c} (56%)
>>   create mode 100644 net/hsr-prp/hsr_prp_framereg.h
>>   create mode 100644 net/hsr-prp/hsr_prp_main.c
>>   create mode 100644 net/hsr-prp/hsr_prp_main.h
>>   create mode 100644 net/hsr-prp/hsr_prp_netlink.c
>>   create mode 100644 net/hsr-prp/hsr_prp_netlink.h
>>   create mode 100644 net/hsr-prp/hsr_prp_slave.c
>>   create mode 100644 net/hsr-prp/hsr_prp_slave.h
>>   create mode 100644 net/hsr-prp/prp_netlink.c
>>   create mode 100644 net/hsr-prp/prp_netlink.h
>>   delete mode 100644 net/hsr/Kconfig
>>   delete mode 100644 net/hsr/Makefile
>>   delete mode 100644 net/hsr/hsr_device.c
>>   delete mode 100644 net/hsr/hsr_device.h
>>   delete mode 100644 net/hsr/hsr_forward.c
>>   delete mode 100644 net/hsr/hsr_framereg.h
>>   delete mode 100644 net/hsr/hsr_main.c
>>   delete mode 100644 net/hsr/hsr_main.h
>>   delete mode 100644 net/hsr/hsr_netlink.c
>>   delete mode 100644 net/hsr/hsr_slave.c
>>   delete mode 100644 net/hsr/hsr_slave.h
>>
>> -- 
>> 2.17.1
>>
> 

-- 
Murali Karicheri
Texas Instruments
