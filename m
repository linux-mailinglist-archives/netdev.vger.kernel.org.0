Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5DF4F0927
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 13:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238327AbiDCLzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 07:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233471AbiDCLzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 07:55:02 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274052717D;
        Sun,  3 Apr 2022 04:53:09 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id bh17so14587449ejb.8;
        Sun, 03 Apr 2022 04:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=0miOY4xmd0bJtQiIkaCOxDWBc7el8oEkzYdvIgKDpgk=;
        b=RNmx6TASSpkrY+uI+6YCTbKP06UicXjh1SMne6tkiIsszblbBMbCUbWMqbjVQTNKRg
         ZmHGksEEof/u3GOxOHs9xnyB6AyXGNqOOQpJYkss6k9icsS829wk/Lj4//QmZuUxZxLI
         Gzh86M5192YoiRnH16IhiBOY7zEukJqgK72bTRjcOxWgXRu/cixwfP8mAuNeJNldJcC9
         RXytXfUMbi9KRcz/idpy6vqPSi86SFqwuDkbBzbGIXSgIq9ZwwoEKNrV5zB393d/AWcf
         Jq3Wt5zinI2f8GbZxuO5v2O0Lj7mkwVo2unhdbZC6rRpzkBzAfNKMNtS8m/nTsRCvhQk
         ESgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=0miOY4xmd0bJtQiIkaCOxDWBc7el8oEkzYdvIgKDpgk=;
        b=SCTp3QSxSBEpdb3a35g5jF3w1KmcKXuyWA8+qbKdR5Ig3+J6fs94GfhsC5v9pLcHsy
         YXBcPSNHUJKW4ZVQVQytH1EClKh+km2TZAHsNInARiGESpGe6Y4mjBS2NC+TzT1c48jT
         dkLVuTt0ZkCUb2g26REvVw0vF6dsEHNLCCvI4KQfSoNf3BfyTp/V8rjITr28TB7kVw7G
         VJxpGvRrVJFqsAle++hjGFISWmGdonIudMg6RZxfKj/By0qJn18B2MD9FysevN8dgf4i
         27vae83vFBS/XVy0feqoNaHEZnivf3YtIJAk4nIWgoMOvvQWCv+FkPE0FajhsaSiFIFk
         E/VA==
X-Gm-Message-State: AOAM530jqWrRFpvJx42q70cmJTBQ9PAz8GgJ5Nx6SnQvbs2xZ4gpii+y
        v2OBgMQ0r3kZ5yKdD+JpwGdvM5eniDGw1w==
X-Google-Smtp-Source: ABdhPJx47MzeB1u1Kj41YAQhpy59KHdnzfE6sffWndP9kk/h2B0UaAnUL5l7F9oTPY32DNXMn0o2eA==
X-Received: by 2002:a17:907:72c5:b0:6d6:e749:da41 with SMTP id du5-20020a17090772c500b006d6e749da41mr7185582ejc.591.1648986787582;
        Sun, 03 Apr 2022 04:53:07 -0700 (PDT)
Received: from smtpclient.apple (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.gmail.com with ESMTPSA id t14-20020a170906608e00b006d1455acc62sm3197750ejj.74.2022.04.03.04.53.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Apr 2022 04:53:07 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH] taprio: replace usage of found with dedicated list
 iterator variable
From:   Jakob Koschel <jakobkoschel@gmail.com>
In-Reply-To: <877d8a3sww.fsf@intel.com>
Date:   Sun, 3 Apr 2022 13:53:06 +0200
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6118F17F-6E0B-4FDA-A7C4-E1C487E9DB8F@gmail.com>
References: <20220324072607.63594-1-jakobkoschel@gmail.com>
 <87fsmz3uc6.fsf@intel.com> <A19238DC-24F8-4BD9-A6FA-C8019596F4A6@gmail.com>
 <877d8a3sww.fsf@intel.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> On 31. Mar 2022, at 19:58, Vinicius Costa Gomes =
<vinicius.gomes@intel.com> wrote:
>=20
> Jakob Koschel <jakobkoschel@gmail.com> writes:
>=20
>>> On 31. Mar 2022, at 01:15, Vinicius Costa Gomes =
<vinicius.gomes@intel.com> wrote:
>>>=20
>>> Hi,
>>>=20
>>> Jakob Koschel <jakobkoschel@gmail.com> writes:
>>>=20
>>>> To move the list iterator variable into the list_for_each_entry_*()
>>>> macro in the future it should be avoided to use the list iterator
>>>> variable after the loop body.
>>>>=20
>>>> To *never* use the list iterator variable after the loop it was
>>>> concluded to use a separate iterator variable instead of a
>>>> found boolean [1].
>>>>=20
>>>> This removes the need to use a found variable and simply checking =
if
>>>> the variable was set, can determine if the break/goto was hit.
>>>>=20
>>>> Link: =
https://lore.kernel.org/all/CAHk-=3DwgRr_D8CB-D9Kg-c=3DEHreAsk5SqXPwr9Y7k9=
sA6cWXJ6w@mail.gmail.com/
>>>> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
>>>> ---
>>>=20
>>> Code wise, patch look good.
>>>=20
>>> Just some commit style/meta comments:
>>> - I think that it would make more sense that these were two separate
>>> patches, but I haven't been following the fallout of the discussion
>>> above to know what other folks are doing;
>>=20
>> Thanks for the input, I'll split them up.
>>=20
>>> - Please use '[PATCH net-next]' in the subject prefix of your =
patch(es)
>>> when you next propose this (net-next is closed for new submissions =
for
>>> now, it should open again in a few days);
>>=20
>> I'll include that prefix, thanks.
>>=20
>> Paolo Abeni [CC'd] suggested to bundle all net-next patches in one =
series [1].
>> If that's the general desire I'm happy to do that.
>=20
> I agree with that, having one series for the whole net-next is going =
to
> be easier for everyone.

I have all the net-next patches bundled in one series now ready to =
repost.
Just wanted to verify that's the intended format since it grew a bit =
larger
then what was posted so far.

It's 46 patches changing 51 files across all those files:

 drivers/connector/cn_queue.c                            | 13 =
++++++-------
 drivers/net/dsa/mv88e6xxx/chip.c                        | 21 =
++++++++++-----------
 drivers/net/dsa/sja1105/sja1105_vl.c                    | 14 =
+++++++++-----
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c          |  3 ++-
 drivers/net/ethernet/intel/i40e/i40e_main.c             | 24 =
++++++++++++++----------
 drivers/net/ethernet/mellanox/mlx4/alloc.c              | 29 =
+++++++++++++++++++----------
 drivers/net/ethernet/mellanox/mlx4/mcg.c                | 17 =
++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/eq.c            | 10 +++++++---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c       | 12 =
++++++------
 drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c   | 21 =
++++++++++++---------
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c      |  7 +++++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c       | 12 =
+++++++++---
 drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c | 25 =
++++++++++++-------------
 drivers/net/ethernet/qlogic/qed/qed_dev.c               | 11 =
++++++-----
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c             | 26 =
++++++++++++--------------
 drivers/net/ethernet/qlogic/qed/qed_spq.c               |  6 +++---
 drivers/net/ethernet/qlogic/qede/qede_filter.c          | 11 =
+++++++----
 drivers/net/ethernet/qlogic/qede/qede_rdma.c            | 11 =
+++++------
 drivers/net/ethernet/sfc/rx_common.c                    |  6 ++++--
 drivers/net/ethernet/ti/netcp_core.c                    | 24 =
++++++++++++++++--------
 drivers/net/ethernet/toshiba/ps3_gelic_wireless.c       | 30 =
+++++++++++++++---------------
 drivers/net/ipvlan/ipvlan_main.c                        |  7 +++++--
 drivers/net/rionet.c                                    | 14 =
+++++++-------
 drivers/net/team/team.c                                 | 20 =
+++++++++++++-------
 drivers/net/wireless/ath/ath10k/mac.c                   | 19 =
++++++++++---------
 drivers/net/wireless/ath/ath11k/dp_rx.c                 | 15 =
+++++++--------
 drivers/net/wireless/ath/ath11k/wmi.c                   | 11 =
+++++------
 drivers/net/wireless/ath/ath6kl/htc_mbox.c              |  2 +-
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c          | 14 =
++++++++------
 drivers/rapidio/devices/rio_mport_cdev.c                | 42 =
++++++++++++++++++++----------------------
 drivers/rapidio/devices/tsi721.c                        | 13 =
++++++-------
 drivers/rapidio/rio.c                                   | 14 =
+++++++-------
 drivers/rapidio/rio_cm.c                                | 81 =
+++++++++++++++++++++++++++++++++++++
 net/9p/trans_virtio.c                                   | 15 =
+++++++--------
 net/9p/trans_xen.c                                      | 10 ++++++----
 net/core/devlink.c                                      | 22 =
+++++++++++++++-------
 net/core/gro.c                                          | 12 =
++++++++----
 net/dsa/dsa.c                                           | 11 =
+++++------
 net/ieee802154/core.c                                   |  7 +++++--
 net/ipv4/udp_tunnel_nic.c                               | 10 ++++++----
 net/mac80211/offchannel.c                               | 28 =
++++++++++++++--------------
 net/mac80211/util.c                                     |  7 +++++--
 net/sched/sch_cbs.c                                     | 11 =
+++++------
 net/sched/sch_taprio.c                                  | 11 =
+++++------
 net/smc/smc_ism.c                                       | 14 =
+++++++-------
 net/tipc/group.c                                        | 12 =
++++++++----
 net/tipc/monitor.c                                      | 21 =
++++++++++++++-------
 net/tipc/name_table.c                                   | 11 =
+++++++----
 net/tipc/socket.c                                       | 11 =
+++++++----
 net/wireless/core.c                                     |  7 +++++--
 net/xfrm/xfrm_ipcomp.c                                  | 11 =
+++++++----
 51 files changed, 452 insertions(+), 364 deletions(-)

Please let me know if I should split it up or if there are certain files =
that might not fit.
Otherwise I'll post them beginning of next week.

>=20
>=20
> Cheers,
> --=20
> Vinicius

Thanks,
Jakob

