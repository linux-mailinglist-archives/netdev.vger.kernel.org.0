Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C191D7C3B
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 17:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgERPDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 11:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbgERPDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 11:03:13 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4741C061A0C;
        Mon, 18 May 2020 08:03:13 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id g11so4347008plp.1;
        Mon, 18 May 2020 08:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4vTekQhuHY9lAKdz6m7oQYFi8rFTF9tZZ83Zd0IQ7ww=;
        b=CYFJWDsEfiOaifGK1CWOjBUftQG5AWCsi4chqbFA4LLQBF4m8PKAezQ6Hf7gCXefKU
         7r+NcfdAS2zznOiR3Tkkrfe9979ZSei5IRDgT2+0CvB25rYuewUoDttmpo/4GiBMe6lh
         YFSf6AZ4dDQZKom1umIdhs+pJFFDx+8MpWRAl1PyoDKcD56iAW2MBLGx8AU126aE3Ldf
         f59taMLSyjDCq6ohz0/n40ZM4nndndCrERtWQ7h9pd4ZF+OcnNc8pXuJheY2hWz9V6Q6
         UrzNxU1SrjzHCtzOJNvTnxeXmeg+jDGAUzZ8djSsCNA+I4BEDo+sLhUq0G44zVLdCcqs
         DHrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4vTekQhuHY9lAKdz6m7oQYFi8rFTF9tZZ83Zd0IQ7ww=;
        b=SytHsixxJp0T5otM/pl9Y4sPuOpBZCtPjzadYlc55iuHNR3xOuJyOwrtCjXdkswnK1
         PBbdAD11RqN9Vktxoy1lFqK2ffX3c1o/3tgVsdEskl3+h0VgNF1cNYa9OcxI1PXR0wCe
         UWC7QbkfZalSzhq9KlOLRXA17YJpLNuoW1qL+2EGFiDfJ878/UkpQ5SFBSyr5MHOAsAh
         UywpQpCpsl3Wj5wk0jQEvAVrDeJtPXzbhfg/9MSMXqw8IzP0P/khAYHcx/KMZOZtT5iU
         AtYWnkgZr+oTEBsnOIR5ZA0iM8BrvzlQg0N3pbTxSj8qSmzGWn5gCoH5jURE0SSEmtjV
         l5Ag==
X-Gm-Message-State: AOAM530kNLugnzzdpHEt7yWQAheLtLGtlyuD7JJKzFQf5zovLdxXNVqT
        8/vdHjIqfzvEEeNd42sdGzs=
X-Google-Smtp-Source: ABdhPJwFZCQ71Tc10vG0Uf9SapqrNelBOBekbF1rdtm4LN/rq6dbbqi5HLKbSGohd2YBQZ0G8bym3g==
X-Received: by 2002:a17:90a:950d:: with SMTP id t13mr21093885pjo.102.1589814193156;
        Mon, 18 May 2020 08:03:13 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.209])
        by smtp.gmail.com with ESMTPSA id k1sm7963142pgh.78.2020.05.18.08.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 08:03:11 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        netdev@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        linux-kernel-mentees@lists.linuxfoundation.org, rjw@rjwysocki.net,
        "David S . Miller" <davem@davemloft.net>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, skhan@linuxfoundation.org
Subject: [PATCH net-next v3 0/2] realtek ethernet : use generic power management.
Date:   Mon, 18 May 2020 20:32:12 +0530
Message-Id: <20200518150214.100491-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patch series is to remove legacy power management callbacks
from realtek ethernet drivers.

The callbacks performing suspend() and resume() operations are still calling
pci_save_state(), pci_set_power_state(), etc. and handling the powermanagement
themselves, which is not recommended.

The conversion requires the removal of the those function calls and change the
callback definition accordingly.

All Changes are compile-tested only.

Vaibhav Gupta (2):
  realtek/8139too: use generic power management
  realtek/8139cp: use generic power management

 drivers/net/ethernet/realtek/8139cp.c  | 25 ++++++++-----------------
 drivers/net/ethernet/realtek/8139too.c | 26 +++++++-------------------
 2 files changed, 15 insertions(+), 36 deletions(-)

-- 
2.26.2

