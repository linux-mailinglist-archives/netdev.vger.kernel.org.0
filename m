Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5033B4FB67C
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 10:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240104AbiDKI47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 04:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343970AbiDKI4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 04:56:53 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BA0B1DC
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 01:54:39 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 4A033320206B;
        Mon, 11 Apr 2022 04:54:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 11 Apr 2022 04:54:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1649667277; x=
        1649753677; bh=jzng1XOBW3xPBYnJi+N5hk5n67g3Chy6qX4dNeMOK7c=; b=G
        +O4QAAbtAPA1xEodXbsEvttxqrODsTbN4i7qSzL2c1lkp0saASQf2aCu5hCud6+1
        3cZkYi88mgAQSu5resxT+7FoHB/MXq+y/Fg00bpQx0yDCS065cJ0UcWJ7zUUgySQ
        7kThlnibTfFBRVqiVLg4+mYkGjzRdgJ0D7AGRBw8NP5E9OON2/b7eFWnGAx3T7dl
        scT0PZONuLuJpIcCEFvUjXXXAzhP532FvcmZ85TawBvJtc/UG/Bjs6CAZ6gySSNB
        iWyqXY5T1vO+/qoBzQ3OELydSFdrbEvVKn/i638Q7PixvCRHtPGg7Honxu4DxeWr
        NlUGSa9MIhrz+Q2g5S8gg==
X-ME-Sender: <xms:zexTYrlpW3gJ88Gax6DW-JIySAIdLzVp02LxAwnDfgKzo5pRWxd4Ng>
    <xme:zexTYu1VaozZn4w3QtdSvsNKD10SYqFb6FIqYWV1WkQvpjdGGOCoZgqP7trzOEYoL
    493rHsgvkeODVs>
X-ME-Received: <xmr:zexTYhrcVQa3vmcZ1oXIJq5pnhqdX1QgQBfumQuFRZUf2MdO_M6oavwkkqF6>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekiedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:zexTYjl_KY9fhyWryWXibBL0zml5WYf2XxkiK687KxnCvMMx6AnT3A>
    <xmx:zexTYp0lyC8uP8ChAxG9kOhGIQgmrTMpfovYp2Af0cQuQMwFZtyiVA>
    <xmx:zexTYiuupX26ejokezVyXOsuODVHnUIO3_OLccmhYpjR5crlu_8sRQ>
    <xmx:zexTYiyOZ-CGh-5zUv4TD57VFZM6Taju1vsriMdpbd-3QX5gETDFKw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 11 Apr 2022 04:54:36 -0400 (EDT)
Date:   Mon, 11 Apr 2022 11:54:34 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 0/6] net: bridge: add flush filtering support
Message-ID: <YlPsyr6NfdO0I1xz@shredder>
References: <20220409105857.803667-1-razor@blackwall.org>
 <YlPdFS//hYbBSAkT@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlPdFS//hYbBSAkT@shredder>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 10:47:38AM +0300, Ido Schimmel wrote:
> On Sat, Apr 09, 2022 at 01:58:51PM +0300, Nikolay Aleksandrov wrote:
> > Hi,
> > This patch-set adds support to specify filtering conditions for a flush
> > operation. Initially only FDB flush filtering is added, later MDB
> > support will be added as well. Some user-space applications need a way
> > to delete only a specific set of entries, e.g. mlag implementations need
> > a way to flush only dynamic entries excluding externally learned ones
> > or only externally learned ones without static entries etc. Also apps
> > usually want to target only a specific vlan or port/vlan combination.
> > The current 2 flush operations (per port and bridge-wide) are not
> > extensible and cannot provide such filtering, so a new bridge af
> > attribute is added (IFLA_BRIDGE_FLUSH) which contains the filtering
> > information for each object type which has to be flushed.
> > An example structure for fdbs:
> >      [ IFLA_BRIDGE_FLUSH ]
> >       `[ BRIDGE_FDB_FLUSH ]
> >         `[ FDB_FLUSH_NDM_STATE ]
> >         `[ FDB_FLUSH_NDM_FLAGS ]
> > 
> > I decided against embedding these into the old flush attributes for
> > multiple reasons - proper error handling on unsupported attributes,
> > older kernels silently flushing all, need for a second mechanism to
> > signal that the attribute should be parsed (e.g. using boolopts),
> > special treatment for permanent entries.
> > 
> > Examples:
> > $ bridge fdb flush dev bridge vlan 100 static
> > < flush all static entries on vlan 100 >
> > $ bridge fdb flush dev bridge vlan 1 dynamic
> > < flush all dynamic entries on vlan 1 >
> > $ bridge fdb flush dev bridge port ens16 vlan 1 dynamic
> > < flush all dynamic entries on port ens16 and vlan 1 >
> > $ bridge fdb flush dev bridge nooffloaded nopermanent
> > < flush all non-offloaded and non-permanent entries >
> > $ bridge fdb flush dev bridge static noextern_learn
> > < flush all static entries which are not externally learned >
> > $ bridge fdb flush dev bridge permanent
> > < flush all permanent entries >
> 
> IIUC, the new IFLA_BRIDGE_FLUSH attribute is supposed to be passed in
> RTM_SETLINK messages, but the current 'bridge fdb' commands all
> correspond to RTM_{NEW,DEL,GET}NEIGH messages. To continue following
> this pattern, did you consider turning the above examples to the
> following?
> 
> $ ip link set dev bridge type bridge fdb_flush vlan 100 static
> $ ip link set dev bridge type bridge fdb_flush vlan 1 dynamic
> $ ip link set dev ens16 type bridge_slave fdb_flush vlan 1 dynamic

Thinking about it again, I guess this is more appropriate:

$ ip link set dev bridge type bridge fdb_flush port ens16 vlan 1 dynamic

> $ ip link set dev bridge type bridge fdb_flush nooffloaded nopermanent
> $ ip link set dev bridge type bridge fdb_flush static noextern_learn
> $ ip link set dev bridge type bridge fdb_flush permanent
> 
> It's not critical, but I like the correspondence between iproute2
> commands and the underlying netlink messages.
> 
> > 
> > Note that all flags have their negated version (static vs nostatic etc)
> > and there are some tricky cases to handle like "static" which in flag
> > terms means fdbs that have NUD_NOARP but *not* NUD_PERMANENT, so the
> > mask matches on both but we need only NUD_NOARP to be set. That's
> > because permanent entries have both set so we can't just match on
> > NUD_NOARP. Also note that this flush operation doesn't treat permanent
> > entries in a special way (fdb_delete vs fdb_delete_local), it will
> > delete them regardless if any port is using them. We can extend the api
> > with a flag to do that if needed in the future.
> > 
> > Patches in this set:
> >  1. adds the new IFLA_BRIDGE_FLUSH bridge af attribute
> >  2. adds a basic structure to describe an fdb flush filter
> >  3. adds fdb netlink flush call via BRIDGE_FDB_FLUSH attribute
> >  4 - 6. add support for specifying various fdb fields to filter
> > 
> > Patch-sets (in order):
> >  - Initial flush infra and fdb flush filtering (this set)
> >  - iproute2 support
> >  - selftests
> > 
> > Future work:
> >  - mdb flush support
> > 
> > Thanks,
> >  Nik
> > 
> > Nikolay Aleksandrov (6):
> >   net: bridge: add a generic flush operation
> >   net: bridge: fdb: add support for fine-grained flushing
> >   net: bridge: fdb: add new nl attribute-based flush call
> >   net: bridge: fdb: add support for flush filtering based on ndm flags
> >     and state
> >   net: bridge: fdb: add support for flush filtering based on ifindex
> >   net: bridge: fdb: add support for flush filtering based on vlan id
> > 
> >  include/uapi/linux/if_bridge.h |  22 ++++++
> >  net/bridge/br_fdb.c            | 128 +++++++++++++++++++++++++++++++--
> >  net/bridge/br_netlink.c        |  59 ++++++++++++++-
> >  net/bridge/br_private.h        |  12 +++-
> >  net/bridge/br_sysfs_br.c       |   6 +-
> >  5 files changed, 215 insertions(+), 12 deletions(-)
> > 
> > -- 
> > 2.35.1
> > 
