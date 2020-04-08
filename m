Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 574141A2706
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 18:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbgDHQTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 12:19:25 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:38013 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgDHQTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 12:19:25 -0400
Received: by mail-pj1-f44.google.com with SMTP id t40so35077pjb.3
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 09:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=8MOJfkNX9KPzxKK/0bC08iHQqWBEE5q9cjFgY2DVtM8=;
        b=1jmTVl7UB/i3sS+l6dtY1HGI8nmjLBOeGr5BupKpA8ABHTd6Ii2UEoiu88RaGOeKYW
         OrGHF6fs6jRhoJbjX4L0BIKW1f5rn6DgBzeAcxqk5GxiIM/CKzld/DPjywIMSdpVzD1A
         FWc9iTW4Qm697HgHhn4ebr3rUb/j5wxumZupZPnyI7AVjG7OfyNpvnRM+sC5dzSrpBJf
         qqbc38fg4ysEzofwQsSxcnc7X/9YI01ISLackmZY/GLherRD+pcAaeG3QxkO0fznYf26
         bCRClPy+SBCpOIsEHSg3XGJUkslWIHcbZVXgYUykcNjjzYKeqDBwFELtnRksSob8F0OH
         uw0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8MOJfkNX9KPzxKK/0bC08iHQqWBEE5q9cjFgY2DVtM8=;
        b=gz4/KRmfGt+elBJFAtKhK0P110u8HXh3nE1mnOvZ25LRQjYV48ZdXOogNrr64+nFKD
         A9QkfwJmftEGirCCTbwGeT7k0NyUAxy5rkedPWCYqxDEK9oA7Td7djrfS9qL92PVG16g
         b3siSK/iqjPo1BjLH84qwyYzff3ZQ8364q3SObokOv3LvAx71M185xzlEI1+TYqUtljH
         qRvsbn1Z4YgThjjSi9T8h1eTVgdKGhk+Akl6/mgoXufPHiaKCPlnhyHT3fKmG1CAtEjd
         aAWVDRJ5xfpEKmqk6D1xXFuHqpB/DnRGnuk2nJhJxwf7XqSFoUvvFKwJgVRumsdO2NFL
         lqrA==
X-Gm-Message-State: AGi0PuZR0QzXcc3VyXXGqMe5/8V72poa1/L/ktvp6ntZVCyLD1E3W5tO
        w/xd12pVGK2EjsbTgj25af0MDg845YA=
X-Google-Smtp-Source: APiQypLG0QyXMS4jWUyW9HUH/CIPh+lpm301+hf1w180f4qQmQMBPsi2G9dDyxBAxk7Z7z/DMCL/Gg==
X-Received: by 2002:a17:902:164:: with SMTP id 91mr7592310plb.207.1586362763751;
        Wed, 08 Apr 2020 09:19:23 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id s12sm16021693pgi.38.2020.04.08.09.19.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Apr 2020 09:19:23 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 0/2] fw upgrade filter fixes
Date:   Wed,  8 Apr 2020 09:19:10 -0700
Message-Id: <20200408161912.17153-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With further testing of the fw-upgrade operations we found a
couple of issues that needed to be cleaned up:
 - the filters other than the base MAC address need to be
   reinstated into the device
 - we don't need to remove the station MAC filter if it
   isn't changing from a previous MAC filter

Shannon Nelson (2):
  ionic: replay filters after fw upgrade
  ionic: set station addr only if needed

 .../net/ethernet/pensando/ionic/ionic_lif.c   | 44 ++++++++++------
 .../ethernet/pensando/ionic/ionic_rx_filter.c | 52 +++++++++++++++----
 .../ethernet/pensando/ionic/ionic_rx_filter.h |  2 +-
 3 files changed, 70 insertions(+), 28 deletions(-)

-- 
2.17.1

