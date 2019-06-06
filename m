Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABE7C3732A
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 13:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbfFFLmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 07:42:15 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40468 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFFLmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 07:42:14 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so2072059wmj.5
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 04:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E0BCMKFWF3BD02Wd5RuR4571i9W2UxPN4NomtaxiJf8=;
        b=Pbsrk9Yj+GWVwYq8M7w1YrRXhvtlv6vWVu9wGO2ulnTXBApJWfu1qhBJU0w4egcivp
         K12s6a/oKV2js5QGMSzGu0vPgGV/5c+RQd6VxfGpmcDorv19Dq7DhPPIHwS3bPmxcuyM
         UdxNtuOGe+3vOJwB4afLc4ZS2BYoGJJAV8Ju9z/TZ09ziEqbSZUQ4suyfinpyUIPts0H
         XCXSbRovSubvBnslVaq/5i4yJ+rn8B3odZtsmGPE6tw0GnoXiDhtGNanBl/M0Lcudl2o
         WpfZhJ6ZnmLyrOfhSc2CQfNndf/b6w0szz3r0n85RC/lf0QoISyWmUu17iQeg/corFiZ
         5j/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E0BCMKFWF3BD02Wd5RuR4571i9W2UxPN4NomtaxiJf8=;
        b=ucSXq9dlsxUKp0lLVsoNYgfYkipf86K1WuY6uDHbhiidwUzNXA3OfyXQduBt6zyqAn
         1zXmJHvRZA8iAMZIagBQ7QeSuS3oZhDwGZQ9Hzcc35hZDkbwRe1mZHdEj7yoiPoHr3QN
         upHypgC6KZ/dgBW0lWHjhQ0IUa76ChNlpgFRTS6fS1+PbuH1vwjk1fuVsuhCDlWRtvNg
         TuhZAj9U2X+RUKYms0uWv17+wcQm9Lx++iASKANhRKkjztFSYQnWy/nnba0m6f/EBHCr
         WyGMTM9eSB5HIgYUSmct59KFLVgB22tngp2muiYLpYmSC0cxn/W8ROQxJYg4687e4Cnb
         GUQg==
X-Gm-Message-State: APjAAAUoib6MBcS4b2Q8qnnfYRq3BEvvU+Vyjuq3Pm+ySvYaXBtbMI/a
        URMd7E6pqh+2hyr10CnlkHB3Rg==
X-Google-Smtp-Source: APXvYqxPNSN0F6j5VkPbbj4cfFbydvLOz8MNaSzEUt0WLzskObgGKwkz+sN84m1QBV8OzBFbM7gHLA==
X-Received: by 2002:a1c:a00f:: with SMTP id j15mr16010739wme.167.1559821332413;
        Thu, 06 Jun 2019 04:42:12 -0700 (PDT)
Received: from localhost.localdomain (p548C9938.dip0.t-ipconnect.de. [84.140.153.56])
        by smtp.gmail.com with ESMTPSA id 95sm2002583wrk.70.2019.06.06.04.42.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 04:42:11 -0700 (PDT)
From:   Christian Brauner <christian@brauner.io>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org
Cc:     tyhicks@canonical.com, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, linux-kernel@vger.kernel.org,
        richardrose@google.com, vapier@chromium.org, bhthompson@google.com,
        smbarber@chromium.org, joelhockey@chromium.org,
        ueberall@themenzentrisch.de,
        Christian Brauner <christian@brauner.io>
Subject: [PATCH RESEND net-next 0/2] br_netfilter: enable in non-initial netns
Date:   Thu,  6 Jun 2019 13:41:40 +0200
Message-Id: <20190606114142.15972-1-christian@brauner.io>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey everyone,

This is another resend of the same patch series. I have received so many
requests, pings, and questions that I would really like to push for this
again.

Over time I have seen multiple reports by users who want to run applications
(Kubernetes e.g. via [1]) that require the br_netfilter module in
non-initial network namespaces. There are *a lot* of issues for this. A
shortlist including ChromeOS and other big users is found below under
[2]! Even non-devs already tried to get more traction on this by
commenting on the patchset (cf. [3]).

Currently, the /proc/sys/net/bridge folder is only created in the
initial network namespace. This patch series ensures that the
/proc/sys/net/bridge folder is available in each network namespace if
the module is loaded and disappears from all network namespaces when the
module is unloaded.
The patch series also makes the sysctls:

bridge-nf-call-arptables
bridge-nf-call-ip6tables
bridge-nf-call-iptables
bridge-nf-filter-pppoe-tagged
bridge-nf-filter-vlan-tagged
bridge-nf-pass-vlan-input-dev

apply per network namespace. This unblocks some use-cases where users
would like to e.g. not do bridge filtering for bridges in a specific
network namespace while doing so for bridges located in another network
namespace.
The netfilter rules are afaict already per network namespace so it
should be safe for users to specify whether a bridge device inside their
network namespace is supposed to go through iptables et al. or not.
Also, this can already be done by setting an option for each individual
bridge via Netlink. It should also be possible to do this for all
bridges in a network namespace via sysctls.

Thanks!
Christian

[1]: https://github.com/zimmertr/Bootstrap-Kubernetes-with-Ansible
[2]: https://bugs.chromium.org/p/chromium/issues/detail?id=878034 
     https://github.com/lxc/lxd/issues/5193
     https://discuss.linuxcontainers.org/t/bridge-nf-call-iptables-and-swap-error-on-lxd-with-kubeadm/2204
     https://github.com/lxc/lxd/issues/3306
     https://gitlab.com/gitlab-org/gitlab-runner/issues/3705
     https://ubuntuforums.org/showthread.php?t=2415032
     https://medium.com/@thomaszimmerman93/hi-im-unable-to-get-kubeadm-init-to-run-due-to-br-netfilter-not-being-loaded-within-the-5642a4ccfece
[3]: https://lkml.org/lkml/2019/3/7/365

Christian Brauner (2):
  br_netfilter: add struct netns_brnf
  br_netfilter: namespace bridge netfilter sysctls

 include/net/net_namespace.h          |   3 +
 include/net/netfilter/br_netfilter.h |   3 +-
 include/net/netns/netfilter.h        |  16 +++
 net/bridge/br_netfilter_hooks.c      | 166 ++++++++++++++++++---------
 net/bridge/br_netfilter_ipv6.c       |   2 +-
 5 files changed, 134 insertions(+), 56 deletions(-)

-- 
2.21.0

