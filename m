Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0AFC3BEA3
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390155AbfFJV0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:26:30 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38830 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389736AbfFJV0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:26:12 -0400
Received: by mail-ed1-f65.google.com with SMTP id g13so16546399edu.5
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 14:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z42gzvzY13YDIHa7rgtca7+PN9nIaqwGu45YWYJL0ZE=;
        b=AMqJUE9Q4r0Jka3/fomU/aSIQ75ZwQbfS3VT3qSbOphlsrZTStHYrpmMq1/ZTUE3fQ
         +1sNc/XVUjn9IlXWZpIiCy34EqXAP2FNpGlGgo8tn4PBmjO9MdWPJFOYN968XyQjTZj+
         DzXjUyNIxN1N2QwEAjnd0wOp/BsiroKnG3x6hdsLSEPem1+GFKuMGkBKsfTMQ8ujVBsa
         +7Qjy/sAOjFpnT6t+7zKOmTkypECm1CJeTlnHBnaE4gYPQPanvGpsN0SxUu/HG7RmpGi
         14QrTKqvTAHeGc8qwsC/mb/n0B+OqwlMackr0zAkB4aztO5jrfqlGRoehhQ9NISLzHcX
         akLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z42gzvzY13YDIHa7rgtca7+PN9nIaqwGu45YWYJL0ZE=;
        b=AXoD4Z6TcswjHn6Q+GrqBGIeNh6541ybjQx/7YvZq7DJuAbI7PNFCwQj9oHmGS8bvd
         eEicQoK3KfgFRJM1n+yYhhu91x0bgkON37oVK/yFLkf6hxw6/RP03XQIKd08amZMA1C1
         11SuWZ8jUCxUFJscxiVx1tSVWebZKFIUMyO4+5pPd8PiWyD/XiFZq2cJfpTEjWjJQOtj
         UHdpxt8jFkNXy3JwXgSNy9Fdqb1lbu9DIX8sT97ePpWv1b76ftjp0RkS+UbpO7lqGMvH
         Kv56olA49CQVichIgdimxFsX269CT3fNaWBbnATLqOa9DD3e6UKcjWfWXNMicJlLlcUc
         eoHA==
X-Gm-Message-State: APjAAAWH4EonTD2frYS36oxAjcCCD+w0EhEY4T4k6goGaSO1YP26RG7h
        jRfx6kICRi7ifA+lmnGorIvdMA==
X-Google-Smtp-Source: APXvYqwCEBHElm6355I+1+Ng6diMwVnfbMqxpbWxvEsZlyN3UMPMo9ttQMSDbYnJv6Ezi7DAWpEnBw==
X-Received: by 2002:a50:a485:: with SMTP id w5mr76216796edb.78.1560201970561;
        Mon, 10 Jun 2019 14:26:10 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8109:9cc0:6dac:cd8f:f6e9:1b84:bbb1])
        by smtp.gmail.com with ESMTPSA id d28sm1092256edn.31.2019.06.10.14.26.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 14:26:09 -0700 (PDT)
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
Subject: [PATCH net-next v2 0/2] br_netfilter: enable in non-initial netns
Date:   Mon, 10 Jun 2019 23:26:04 +0200
Message-Id: <20190610212606.29743-1-christian@brauner.io>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey everyone,

/* v2 */
Split into two patches (cf. [4]):
1/2: replace #define with static inline helpers
2/2: namespace syscals

/* v1 */
This is a rework of the patch to not touch struct net at all and instead
rely on the pernet infrastructure directly to namespace the sysctls.

/* v0 */
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
[4]: https://lore.kernel.org/lkml/20190610174136.p3fbcbn33en5bb7f@salvia/

Christian Brauner (2):
  br_netfilter: port sysctls to use brnf_net
  br_netfilter: namespace bridge netfilter sysctls

 include/net/netfilter/br_netfilter.h |   3 +-
 net/bridge/br_netfilter_hooks.c      | 245 +++++++++++++++++----------
 net/bridge/br_netfilter_ipv6.c       |   2 +-
 3 files changed, 162 insertions(+), 88 deletions(-)

-- 
2.21.0

