Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783361CE964
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 01:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgEKX6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 19:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725836AbgEKX6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 19:58:03 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B559BC061A0C;
        Mon, 11 May 2020 16:58:02 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id r16so9583506edw.5;
        Mon, 11 May 2020 16:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MWpk5jA28TlV15w4MA5TEHk6jUilLe3oRA7Uwl0N0kA=;
        b=PPlf5vONyihPtmK64tqxLAsh1jmrKbCTboXK/FncoPb1OGp9P/U0Ooch6eu69Q4nTb
         +AaXLsxsUgPJpcoBii0T8iip8cJv3s/kMpI7ECG1ykba4/ZLvgAXHrzkZTBXabMbV8ys
         maTyvLhlwwDGdwYqeJGW9WxkIc5pZw6V/1dQ4oMfsQ1UCfiiyEUS3k5kJJX7rdtAAPA2
         apVfGibrr+N8dJ92ZDkoWtpHofRw0ECRUfcBLKTdRlwPDUR13DcrULIeznLaPShueEFB
         6NSVgAVglcj7ZWAUFNRobkPvSPHKjUnmYybQRFk0xmxRrDrKK9HQuD7aMvJ9tIce84we
         zH6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MWpk5jA28TlV15w4MA5TEHk6jUilLe3oRA7Uwl0N0kA=;
        b=kIG/AT1UexVCJQsygyA0otPn8vTSfLscbz4HhBLGBY+pAoYwf8oOHt/hyHnNFLTeyu
         rYkIC9QxZlKN/fPvkYxgXb+8VPVeScWrgm1FVpBlhA3CP7bt2Edxc5TxXv1e3PttOTXk
         3D804/Mv1XRIM+NIqx+qVBvA6c9RqfGjzXe72fxe+E8cXHkAL/+Dag8JyJPEqlqhf6Vb
         wYoOCznJaPRSZUmhAjhd77UfT57I0ISUMsAr6Kj4OAmE1rMp7t5iBVsplpldTti3HBhH
         d2ZzM576KflYICtUZdn+mNyVTq4qIHxIoSlwZdR078KzDD6PUkSfNZLlX56pB9N0Ngdw
         PxiQ==
X-Gm-Message-State: AGi0PubYMOEt6Not4xL6bUqvTBWHYkn60sXC/77u65E32udN/C4ItAkT
        +430gBQCbc1Ej8gKtZMm0gTXh0kuQGI+6cKf3HU=
X-Google-Smtp-Source: APiQypL/97F+B4EVtnonwCofYS64u0tshxlYuMwiew52py+Cn2V/19xDYWBoaRu2QCXwQ8ykD5B4gAC/7jwxfAEHKl4=
X-Received: by 2002:aa7:df8d:: with SMTP id b13mr16086962edy.145.1589241481415;
 Mon, 11 May 2020 16:58:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200511135338.20263-4-olteanv@gmail.com> <202005120607.z7yY4vNY%lkp@intel.com>
In-Reply-To: <202005120607.z7yY4vNY%lkp@intel.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 12 May 2020 02:57:50 +0300
Message-ID: <CA+h21ho7XpgQOkM9L64OLf--YKsz1j4tp6U+OpytkhBJX0Swog@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 03/15] net: dsa: sja1105: keep the VLAN
 awareness state in a driver variable
To:     kbuild test robot <lkp@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        kbuild-all@lists.01.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@idosch.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 May 2020 at 01:59, kbuild test robot <lkp@intel.com> wrote:
>
> Hi Vladimir,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on net-next/master]
> [cannot apply to linus/master v5.7-rc5]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
>
> url:    https://github.com/0day-ci/linux/commits/Vladimir-Oltean/Traffic-support-for-dsa_8021q-in-vlan_filtering-1-mode/20200512-024329
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git a6f0b26d6a5dcf27980e65f965779a929039f11d
> config: xtensa-randconfig-r021-20200511 (attached as .config)
> compiler: xtensa-linux-gcc (GCC) 9.3.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day GCC_VERSION=9.3.0 make.cross ARCH=xtensa
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    xtensa-linux-ld: net/dsa/tag_sja1105.o: in function `sja1105_rcv':
> >> net/dsa/tag_sja1105.c:305: undefined reference to `sja1105_can_use_vlan_as_tags'
>    xtensa-linux-ld: net/dsa/tag_sja1105.o: in function `sja1105_filter':
>    net/dsa/tag_sja1105.c:77: undefined reference to `sja1105_can_use_vlan_as_tags'
>

Argh, this is by compiling the tagger module without the driver, it
looks like I can't get away with doing this.
The issue is that I don't want to expose struct sja1105_private
publicly, but I do have a struct sja1105_port hanging off of dp->priv.
But I don't have access to a dp pointer in the .filter method... So
the only realistic idea I have is to provide a shim implementation for
the call.


> vim +305 net/dsa/tag_sja1105.c
>
> f3097be21bf17a Vladimir Oltean 2019-06-08  246
> 227d07a07ef126 Vladimir Oltean 2019-05-05  247  static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
> 227d07a07ef126 Vladimir Oltean 2019-05-05  248                                     struct net_device *netdev,
> 227d07a07ef126 Vladimir Oltean 2019-05-05  249                                     struct packet_type *pt)
> 227d07a07ef126 Vladimir Oltean 2019-05-05  250  {
> e53e18a6fe4d3a Vladimir Oltean 2019-06-08  251          struct sja1105_meta meta = {0};
> d461933638ae9f Vladimir Oltean 2019-06-08  252          int source_port, switch_id;
> e80f40cbe4dd51 Vladimir Oltean 2020-03-24  253          struct ethhdr *hdr;
> 227d07a07ef126 Vladimir Oltean 2019-05-05  254          u16 tpid, vid, tci;
> 42824463d38d27 Vladimir Oltean 2019-06-08  255          bool is_link_local;
> 227d07a07ef126 Vladimir Oltean 2019-05-05  256          bool is_tagged;
> e53e18a6fe4d3a Vladimir Oltean 2019-06-08  257          bool is_meta;
> 227d07a07ef126 Vladimir Oltean 2019-05-05  258
> e80f40cbe4dd51 Vladimir Oltean 2020-03-24  259          hdr = eth_hdr(skb);
> e80f40cbe4dd51 Vladimir Oltean 2020-03-24  260          tpid = ntohs(hdr->h_proto);
> d461933638ae9f Vladimir Oltean 2019-06-08  261          is_tagged = (tpid == ETH_P_SJA1105);
> 42824463d38d27 Vladimir Oltean 2019-06-08  262          is_link_local = sja1105_is_link_local(skb);
> e53e18a6fe4d3a Vladimir Oltean 2019-06-08  263          is_meta = sja1105_is_meta_frame(skb);
> 227d07a07ef126 Vladimir Oltean 2019-05-05  264
> 227d07a07ef126 Vladimir Oltean 2019-05-05  265          skb->offload_fwd_mark = 1;
> 227d07a07ef126 Vladimir Oltean 2019-05-05  266
> 42824463d38d27 Vladimir Oltean 2019-06-08  267          if (is_tagged) {
> 42824463d38d27 Vladimir Oltean 2019-06-08  268                  /* Normal traffic path. */
> e80f40cbe4dd51 Vladimir Oltean 2020-03-24  269                  skb_push_rcsum(skb, ETH_HLEN);
> e80f40cbe4dd51 Vladimir Oltean 2020-03-24  270                  __skb_vlan_pop(skb, &tci);
> e80f40cbe4dd51 Vladimir Oltean 2020-03-24  271                  skb_pull_rcsum(skb, ETH_HLEN);
> e80f40cbe4dd51 Vladimir Oltean 2020-03-24  272                  skb_reset_network_header(skb);
> e80f40cbe4dd51 Vladimir Oltean 2020-03-24  273                  skb_reset_transport_header(skb);
> e80f40cbe4dd51 Vladimir Oltean 2020-03-24  274
> 42824463d38d27 Vladimir Oltean 2019-06-08  275                  vid = tci & VLAN_VID_MASK;
> 42824463d38d27 Vladimir Oltean 2019-06-08  276                  source_port = dsa_8021q_rx_source_port(vid);
> 42824463d38d27 Vladimir Oltean 2019-06-08  277                  switch_id = dsa_8021q_rx_switch_id(vid);
> 42824463d38d27 Vladimir Oltean 2019-06-08  278                  skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
> 42824463d38d27 Vladimir Oltean 2019-06-08  279          } else if (is_link_local) {
> 227d07a07ef126 Vladimir Oltean 2019-05-05  280                  /* Management traffic path. Switch embeds the switch ID and
> 227d07a07ef126 Vladimir Oltean 2019-05-05  281                   * port ID into bytes of the destination MAC, courtesy of
> 227d07a07ef126 Vladimir Oltean 2019-05-05  282                   * the incl_srcpt options.
> 227d07a07ef126 Vladimir Oltean 2019-05-05  283                   */
> 227d07a07ef126 Vladimir Oltean 2019-05-05  284                  source_port = hdr->h_dest[3];
> 227d07a07ef126 Vladimir Oltean 2019-05-05  285                  switch_id = hdr->h_dest[4];
> 227d07a07ef126 Vladimir Oltean 2019-05-05  286                  /* Clear the DMAC bytes that were mangled by the switch */
> 227d07a07ef126 Vladimir Oltean 2019-05-05  287                  hdr->h_dest[3] = 0;
> 227d07a07ef126 Vladimir Oltean 2019-05-05  288                  hdr->h_dest[4] = 0;
> e53e18a6fe4d3a Vladimir Oltean 2019-06-08  289          } else if (is_meta) {
> e53e18a6fe4d3a Vladimir Oltean 2019-06-08  290                  sja1105_meta_unpack(skb, &meta);
> e53e18a6fe4d3a Vladimir Oltean 2019-06-08  291                  source_port = meta.source_port;
> e53e18a6fe4d3a Vladimir Oltean 2019-06-08  292                  switch_id = meta.switch_id;
> 227d07a07ef126 Vladimir Oltean 2019-05-05  293          } else {
> 42824463d38d27 Vladimir Oltean 2019-06-08  294                  return NULL;
> 227d07a07ef126 Vladimir Oltean 2019-05-05  295          }
> 227d07a07ef126 Vladimir Oltean 2019-05-05  296
> 227d07a07ef126 Vladimir Oltean 2019-05-05  297          skb->dev = dsa_master_find_slave(netdev, switch_id, source_port);
> 227d07a07ef126 Vladimir Oltean 2019-05-05  298          if (!skb->dev) {
> 227d07a07ef126 Vladimir Oltean 2019-05-05  299                  netdev_warn(netdev, "Couldn't decode source port\n");
> 227d07a07ef126 Vladimir Oltean 2019-05-05  300                  return NULL;
> 227d07a07ef126 Vladimir Oltean 2019-05-05  301          }
> 227d07a07ef126 Vladimir Oltean 2019-05-05  302
> f3097be21bf17a Vladimir Oltean 2019-06-08  303          return sja1105_rcv_meta_state_machine(skb, &meta, is_link_local,
> f3097be21bf17a Vladimir Oltean 2019-06-08  304                                                is_meta);
> 227d07a07ef126 Vladimir Oltean 2019-05-05 @305  }
> 227d07a07ef126 Vladimir Oltean 2019-05-05  306
>
> :::::: The code at line 305 was first introduced by commit
> :::::: 227d07a07ef126272ea2eed97fd136cd7a803d81 net: dsa: sja1105: Add support for traffic through standalone ports
>
> :::::: TO: Vladimir Oltean <olteanv@gmail.com>
> :::::: CC: David S. Miller <davem@davemloft.net>
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
