Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB2A5A1971
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 21:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243608AbiHYTWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 15:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243630AbiHYTWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 15:22:06 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717C1BD0A1
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 12:22:03 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id t140so15589461oie.8
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 12:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=j11I9jJbBdP2EsV8zm8vGrZ8to2ALD+DZiEMfyWlhf4=;
        b=KjzVxnhpw6QKMn5c7oLhZ2YXfy0o0q7ppQDDA/IUG9Tba1CyII5IegLq2jiOsTx6sf
         9PktWYsvLhv6OduPZa78FKjas33U49IxO+UttcDOMAdp3MTlGJvDXLmU3ofAZEoFFqZT
         pafvPKdLl3l0hKSE9VWBcm6msZs1UGsFX0W0WhRtsci35MLKycrvSxbg6GiEiXprLSDz
         35gtzDXDspqbKE6U1rd+mL/P+1w92XWlGqtbdRRUw9gw3+q3FfhdBiDfZom+YIwlZBrE
         iSIuTPlKIwHdWrtxWrdA/Tch392Qi6e4omMMHzm85TUdvnZFdOZSQACivsWz9KW0c6uk
         JDjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=j11I9jJbBdP2EsV8zm8vGrZ8to2ALD+DZiEMfyWlhf4=;
        b=Vj0YkbqAUWAnfBcD+Yjb+gkMwk4WBaziVn2hTPh/W36uWZrjc0yNoYjum2EEUC/Itb
         HzkcHZypNKdU27glmyh6q0qpxlR/CluJlJb4ytRVklSjtjeVpLockK7jDY7ekQR2skz8
         aS7F4F4aP8mk65IhWaINjul4Vhc0yIUORNCQiT1K3zL0rdTHz46XdcBg8XafRz1q69mb
         wd9OWVoJSnqTLsZ+p2Fieky+OenvYZZXcvGMKpvt5z+ZlyoPN6U8IipRkcwYSsy7t68c
         hx6Ri0IM5D71Rab3gcVJEXQUHOi/xCzUNyxd80oq9kl8v7nr/BWjYrukz6eXr9dmhHLP
         u07A==
X-Gm-Message-State: ACgBeo0G7gScdiWZTUdUi8FOoBiPpw5nSa9QGZJqszbPjtrnEJzzUTLt
        +c1Q9JVtZNsE4FecKR4rU/W0nk8d+oVQPMiW45pW
X-Google-Smtp-Source: AA6agR5+NrNDgFeVEqQOH6xO8KzleveZvD24+0ma4hp6CR5I88pcrQbnickGgaR7sl54W0OczwK1VkCsRh+9Rsqv/HQ=
X-Received: by 2002:a05:6808:3a9:b0:343:4b14:ccce with SMTP id
 n9-20020a05680803a900b003434b14cccemr243316oie.41.1661455322788; Thu, 25 Aug
 2022 12:22:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220825001830.1911524-1-kuba@kernel.org>
In-Reply-To: <20220825001830.1911524-1-kuba@kernel.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 25 Aug 2022 15:21:52 -0400
Message-ID: <CAHC9VhSxesi0TSSvcQSr1kDhP3Vce4+O3w2diEExGEGnjGpmiw@mail.gmail.com>
Subject: Re: [PATCH net-next] genetlink: start to validate reserved header bytes
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, johannes@sipsolutions.net,
        linux-block@vger.kernel.org, osmocom-net-gprs@lists.osmocom.org,
        linux-wpan@vger.kernel.org, wireguard@lists.zx2c4.com,
        linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-pm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-cifs@vger.kernel.org, cluster-devel@redhat.com,
        mptcp@lists.linux.dev, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        linux-security-module@vger.kernel.org, dev@openvswitch.org,
        linux-s390@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 24, 2022 at 8:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> We had historically not checked that genlmsghdr.reserved
> is 0 on input which prevents us from using those precious
> bytes in the future.
>
> One use case would be to extend the cmd field, which is
> currently just 8 bits wide and 256 is not a lot of commands
> for some core families.
>
> To make sure that new families do the right thing by default
> put the onus of opting out of validation on existing families.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: jiri@resnulli.us
> CC: johannes@sipsolutions.net
> CC: linux-block@vger.kernel.org
> CC: osmocom-net-gprs@lists.osmocom.org
> CC: linux-wpan@vger.kernel.org
> CC: wireguard@lists.zx2c4.com
> CC: linux-wireless@vger.kernel.org
> CC: linux-scsi@vger.kernel.org
> CC: target-devel@vger.kernel.org
> CC: linux-pm@vger.kernel.org
> CC: virtualization@lists.linux-foundation.org
> CC: linux-cifs@vger.kernel.org
> CC: cluster-devel@redhat.com
> CC: mptcp@lists.linux.dev
> CC: lvs-devel@vger.kernel.org
> CC: netfilter-devel@vger.kernel.org
> CC: linux-security-module@vger.kernel.org
> CC: dev@openvswitch.org
> CC: linux-s390@vger.kernel.org
> CC: tipc-discussion@lists.sourceforge.net
> ---
>  drivers/block/nbd.c                      | 1 +
>  drivers/net/gtp.c                        | 1 +
>  drivers/net/ieee802154/mac802154_hwsim.c | 1 +
>  drivers/net/macsec.c                     | 1 +
>  drivers/net/team/team.c                  | 1 +
>  drivers/net/wireguard/netlink.c          | 1 +
>  drivers/net/wireless/mac80211_hwsim.c    | 1 +
>  drivers/target/target_core_user.c        | 1 +
>  drivers/thermal/thermal_netlink.c        | 1 +
>  drivers/vdpa/vdpa.c                      | 1 +
>  fs/cifs/netlink.c                        | 1 +
>  fs/dlm/netlink.c                         | 1 +
>  fs/ksmbd/transport_ipc.c                 | 1 +
>  include/linux/genl_magic_func.h          | 1 +
>  include/net/genetlink.h                  | 3 +++
>  kernel/taskstats.c                       | 1 +
>  net/batman-adv/netlink.c                 | 1 +
>  net/core/devlink.c                       | 1 +
>  net/core/drop_monitor.c                  | 1 +
>  net/ethtool/netlink.c                    | 1 +
>  net/hsr/hsr_netlink.c                    | 1 +
>  net/ieee802154/netlink.c                 | 1 +
>  net/ieee802154/nl802154.c                | 1 +
>  net/ipv4/fou.c                           | 1 +
>  net/ipv4/tcp_metrics.c                   | 1 +
>  net/ipv6/ila/ila_main.c                  | 1 +
>  net/ipv6/ioam6.c                         | 1 +
>  net/ipv6/seg6.c                          | 1 +
>  net/l2tp/l2tp_netlink.c                  | 1 +
>  net/mptcp/pm_netlink.c                   | 1 +
>  net/ncsi/ncsi-netlink.c                  | 1 +
>  net/netfilter/ipvs/ip_vs_ctl.c           | 1 +
>  net/netlabel/netlabel_calipso.c          | 1 +
>  net/netlabel/netlabel_cipso_v4.c         | 1 +
>  net/netlabel/netlabel_mgmt.c             | 1 +
>  net/netlabel/netlabel_unlabeled.c        | 1 +
>  net/netlink/genetlink.c                  | 4 ++++
>  net/nfc/netlink.c                        | 1 +
>  net/openvswitch/conntrack.c              | 1 +
>  net/openvswitch/datapath.c               | 3 +++
>  net/openvswitch/meter.c                  | 1 +
>  net/psample/psample.c                    | 1 +
>  net/smc/smc_netlink.c                    | 3 ++-
>  net/smc/smc_pnet.c                       | 3 ++-
>  net/tipc/netlink.c                       | 1 +
>  net/tipc/netlink_compat.c                | 1 +
>  net/wireless/nl80211.c                   | 1 +
>  47 files changed, 56 insertions(+), 2 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com> (NetLabel)

-- 
paul-moore.com
