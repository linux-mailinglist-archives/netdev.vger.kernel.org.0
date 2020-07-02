Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0C5211C0A
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 08:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgGBGiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 02:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGBGiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 02:38:06 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2F7C08C5C1;
        Wed,  1 Jul 2020 23:38:06 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id b92so12091305pjc.4;
        Wed, 01 Jul 2020 23:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XyjnEdFZxF+tDKS9P8wBrY80ec4OJRjyUgQsd0cpcww=;
        b=kPsjRRlwZxwcP4I/Diji+FaejQzGmwkib0r4PN8AiBzHdwIPOxR7YBeqZfwcrT77Qo
         7WgvYpFGKn72xLv4xCfFpP9gAyFfvavwK6jcKKBJjMooeZKK91iq82rl9LHYn2vHM+wu
         5O8uJAg4VFi5iyDh0sZBjd1HfqYyjf5HhPsLt0GSL5EkLWjKBvEGHgpCiKWXVOePM319
         7h+OcTPC93YVzYZVY2JIBCYt7qB7uNmF5tEeYRN6di8kayaQOb2/UuOyMfhZ3Y3DWaKu
         uLMEoZUvkqMeDB0ZnNuutkEHIQ4B73NzyQYLwSuAt2AvSSgN6VFf/lLoI3uqP2BHC7Tw
         k2BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XyjnEdFZxF+tDKS9P8wBrY80ec4OJRjyUgQsd0cpcww=;
        b=ScPU4pAxmcJ0DJPTfO8vFS13p47037xIipQ8r0b/OhfCJ0K+YaumXUpHXtGpsiIkmC
         tYRX0Bp1wcIY56+5RmsGLPT0ROmdNrBahpL1wd5cQcz2jvnBFvvmTs+e5rWVl7WTIyco
         OXZyY+izdYNnLAp9ia7PkcefBoDgDxsYh+R+OC7D0MuOk3rWVfZkUE+rwjuha1ALHOO2
         g2Am8H+uMtiI0hosLLsx74Tv6FfEqvw6lOPt8SqJhN86WYxgr8Bm/ud+EAp+/ntBkNYb
         B8qjv11gzVmQKzVC+KOEU8ejzkTQ5w6LByjWj0Ivu/PD1bru3GePSuRIohJrc0TLQpVh
         5/QA==
X-Gm-Message-State: AOAM532b+YgFCeKnicbd41BmDeMNMQl0WyApDsIdj+a3ois479M81iAn
        PV++xhwA7j4Plrc9f4kV8Dg=
X-Google-Smtp-Source: ABdhPJzupBNpZFCBC2aKsQl7FOtxVyyRwJFpYSwVtclOE1dKRuI2i0q07HrjplUoYPW75RI/d+KYeA==
X-Received: by 2002:a17:90a:ea84:: with SMTP id h4mr20199016pjz.128.1593671886197;
        Wed, 01 Jul 2020 23:38:06 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.57])
        by smtp.gmail.com with ESMTPSA id l12sm7523549pff.212.2020.07.01.23.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 23:38:05 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Manish Chopra <manishc@marvell.com>,
        Rahul Verma <rahulv@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Shahed Shaikh <shshaikh@marvell.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: [PATCH v1 0/2] qlogic: use generic power management
Date:   Thu,  2 Jul 2020 12:06:30 +0530
Message-Id: <20200702063632.289959-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux Kernel Mentee: Remove Legacy Power Management.

The purpose of this patch series is to remove legacy power management callbacks
from qlogic ethernet drivers.

The callbacks performing suspend() and resume() operations are still calling
pci_save_state(), pci_set_power_state(), etc. and handling the power management
themselves, which is not recommended.

The conversion requires the removal of the those function calls and change the
callback definition accordingly and make use of dev_pm_ops structure.

All patches are compile-tested only.

Vaibhav Gupta (2):
  netxen_nic: use generic power management
  qlcninc: use generic power management

 .../ethernet/qlogic/netxen/netxen_nic_main.c  | 59 +++++++++----------
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    | 10 +---
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  | 33 +++--------
 3 files changed, 37 insertions(+), 65 deletions(-)

-- 
2.27.0

