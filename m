Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0EE04D93E6
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 06:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245383AbiCOFeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 01:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242505AbiCOFeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 01:34:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053B52BF9;
        Mon, 14 Mar 2022 22:32:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7452B6118F;
        Tue, 15 Mar 2022 05:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290D5C340E8;
        Tue, 15 Mar 2022 05:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647322367;
        bh=XwfpXnEY7+wrg7B2csX4wE7a6rKBiz6F6P9neGxhXwA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UBUqwwHGlWWkv2/0uGVZBkjaSlGMmZ1WBsYvT4MZVkLCkYoxa6d5Fi9HZXPaBQ6LG
         kuBdq/Lj3Jz1+RL6rtrpY5qOrORwVS4sAfA422p7vDmvApGnOTQTnRIMurdHRj0HNo
         y39TUyb4wZXrfkN500PxcuvKhPD0EwhWtZWkYsUVXta0DaSAOsfkLdRnRVTOw6K+Y8
         35oPo1Kki+E8Ex5t3TrFcFdFhZStBArIsandoLNetv6WxyFM/1v6iS3cOjTQfkQ1qt
         53YZqDGjWKPzvnUPbbaW89Kl6sx7YNTgwXf1mx40axxouESh5z+DeXl+MIjJs7xvvw
         HDhaUR5otj3Iw==
Date:   Mon, 14 Mar 2022 22:32:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v4 net-next 04/15] net: bridge: mst: Notify switchdev
 drivers of MST mode changes
Message-ID: <20220314223246.45cf8305@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220315002543.190587-5-tobias@waldekranz.com>
References: <20220315002543.190587-1-tobias@waldekranz.com>
        <20220315002543.190587-5-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Mar 2022 01:25:32 +0100 Tobias Waldekranz wrote:
> Trigger a switchdev event whenever the bridge's MST mode is
> enabled/disabled. This allows constituent ports to either perform any
> required hardware config, or refuse the change if it not supported.
>=20
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

../net/bridge/br_mst.c: In function =E2=80=98br_mst_set_enabled=E2=80=99:
../net/bridge/br_mst.c:102:16: error: variable =E2=80=98attr=E2=80=99 has i=
nitializer but incomplete type
  102 |         struct switchdev_attr attr =3D {
      |                ^~~~~~~~~~~~~~
../net/bridge/br_mst.c:103:18: error: =E2=80=98struct switchdev_attr=E2=80=
=99 has no member named =E2=80=98id=E2=80=99
  103 |                 .id =3D SWITCHDEV_ATTR_ID_BRIDGE_MST,
      |                  ^~
../net/bridge/br_mst.c:103:23: error: =E2=80=98SWITCHDEV_ATTR_ID_BRIDGE_MST=
=E2=80=99 undeclared (first use in this function)
  103 |                 .id =3D SWITCHDEV_ATTR_ID_BRIDGE_MST,
      |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
../net/bridge/br_mst.c:103:23: note: each undeclared identifier is reported=
 only once for each function it appears in
../net/bridge/br_mst.c:103:23: warning: excess elements in struct initializ=
er
../net/bridge/br_mst.c:103:23: note: (near initialization for =E2=80=98attr=
=E2=80=99)
../net/bridge/br_mst.c:104:18: error: =E2=80=98struct switchdev_attr=E2=80=
=99 has no member named =E2=80=98orig_dev=E2=80=99
  104 |                 .orig_dev =3D br->dev,
      |                  ^~~~~~~~
../net/bridge/br_mst.c:104:29: warning: excess elements in struct initializ=
er
  104 |                 .orig_dev =3D br->dev,
      |                             ^~
../net/bridge/br_mst.c:104:29: note: (near initialization for =E2=80=98attr=
=E2=80=99)
../net/bridge/br_mst.c:105:18: error: =E2=80=98struct switchdev_attr=E2=80=
=99 has no member named =E2=80=98u=E2=80=99
  105 |                 .u.mst =3D on,
      |                  ^
../net/bridge/br_mst.c:105:26: warning: excess elements in struct initializ=
er
  105 |                 .u.mst =3D on,
      |                          ^~
../net/bridge/br_mst.c:105:26: note: (near initialization for =E2=80=98attr=
=E2=80=99)
../net/bridge/br_mst.c:102:31: error: storage size of =E2=80=98attr=E2=80=
=99 isn=E2=80=99t known
  102 |         struct switchdev_attr attr =3D {
      |                               ^~~~
../net/bridge/br_mst.c:125:15: error: implicit declaration of function =E2=
=80=98switchdev_port_attr_set=E2=80=99; did you mean =E2=80=98br_switchdev_=
port_vlan_del=E2=80=99? [-Werror=3Dimplicit-function-declaration]
  125 |         err =3D switchdev_port_attr_set(br->dev, &attr, extack);
      |               ^~~~~~~~~~~~~~~~~~~~~~~
      |               br_switchdev_port_vlan_del
../net/bridge/br_mst.c:102:31: warning: unused variable =E2=80=98attr=E2=80=
=99 [-Wunused-variable]
  102 |         struct switchdev_attr attr =3D {
      |                               ^~~~
