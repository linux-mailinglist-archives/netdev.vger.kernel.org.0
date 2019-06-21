Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C85D94E478
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 11:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfFUJqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 05:46:48 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42102 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbfFUJqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 05:46:47 -0400
Received: by mail-pg1-f194.google.com with SMTP id l19so3097768pgh.9;
        Fri, 21 Jun 2019 02:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SDb6fS66l3rIdgOP+xeGdS65KBD4+SVxzLqxETJy540=;
        b=tHmDc21h4z8FGOySimqA/JJA0jud8SB83BSGl90MQpJLk4bLP7R/QKQw+45dqU88s4
         WXXo8j36RcJwF3JJucdQVOhwR2NBs2/0pAWugp39yqS0XTOAWHZb5Okwv6I6KFUp9Ltj
         nMqVlI190DQ5Kfk48bAD1spf0Ql3q1ZKCBs2SHguekVAFRslfHLsjYmfxMNj9/Zobwc1
         0g9p7aUWGtwDhilimS6/rZffSJ+VjltLI0yGx3LN/YtkeFPnu7oCrqn5Yr+pLsoVcdgM
         FzR+n6gqpNcZk6Uhbu0q9W+qWXwhJ3aVN//CwEocRUsuuURi3ELhdAqTF4iypNAsrBYm
         uROQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SDb6fS66l3rIdgOP+xeGdS65KBD4+SVxzLqxETJy540=;
        b=aoDRtoIMkmZH+cwIlACaQS+oNmW267xNOPsffpcMwRb0x1vcuuo8AAXksy9yIuXYk0
         DtXj8/srT2kK2sgWXbKOrJG0ER9KJuHVG3NICMvbaUpWa5VkZelWVQBAwbFi4dU7ueGF
         ObF1t6Q4xly/7vV5mAPyveBKv236jJ4hGTJ6UgFkbygKzsjspbx4Ccxk8UQ0VjSrugJY
         xkf2WL01w9XDPXuAuz3tMyobyNvj74L7hrTZz7EAhJsuj+6VZeD/muP2hWB0x9ZMG/QB
         BHFOC+0gGuzGDDV6m9h+mGgZG0iu3fs4lKmEUKv80HGx/Gn03as6j97k2B3OFpiAydBH
         t+rA==
X-Gm-Message-State: APjAAAXLIhtAUJL+HPXqUryB4TPSQ6aNnGIbJxP2QrkHJTOm2w76x4Ev
        w6scMjr+dWHA0X7cB4A4VNedmsn+5eGOmQ==
X-Google-Smtp-Source: APXvYqzYDIumDjcuNF+spxLeWY+sn/VYIJJTKdnueD12yLGO0ruD7QUv9wfI2q5NeSuiyLopssoMJg==
X-Received: by 2002:a65:50cb:: with SMTP id s11mr17411630pgp.371.1561110406990;
        Fri, 21 Jun 2019 02:46:46 -0700 (PDT)
Received: from localhost.localdomain ([2402:3a80:913:88b1:ac7e:774f:a03c:dcac])
        by smtp.googlemail.com with ESMTPSA id u2sm2147746pjv.9.2019.06.21.02.46.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 02:46:46 -0700 (PDT)
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v3 0/3] net: fddi: skfp: Use PCI generic definitions instead of private duplicates
Date:   Fri, 21 Jun 2019 15:16:04 +0530
Message-Id: <20190621094607.15011-1-puranjay12@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series removes the private duplicates of PCI definitions in
favour of generic definitions defined in pci_regs.h.

This driver only uses some of the generic PCI definitons,
which are included from pci_regs.h and thier private versions
are removed from skfbi.h with all other private defines.

The skfbi.h defines PCI_REV_ID and other private defines with different
names, these are renamed to Generic PCI names to make them
compatible with defines in pci_regs.h.

All unused defines are removed from skfbi.h.

Puranjay Mohan (3):
  net: fddi: skfp: Rename local PCI defines to match generic PCI defines
  net: fddi: skfp: Include generic PCI definitions
  net: fddi: skfp: Remove unused private PCI definitions

 drivers/net/fddi/skfp/drvfbi.c  |  3 +-
 drivers/net/fddi/skfp/h/skfbi.h | 80 +--------------------------------
 2 files changed, 4 insertions(+), 79 deletions(-)

-- 
2.21.0

