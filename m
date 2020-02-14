Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D916515D5A9
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 11:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbgBNKbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 05:31:01 -0500
Received: from mail-pg1-f176.google.com ([209.85.215.176]:46725 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727965AbgBNKbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 05:31:01 -0500
Received: by mail-pg1-f176.google.com with SMTP id b35so4603664pgm.13
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 02:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=M7z/UpvFrXiCKdy859UXJ/E53JBb0XvLwmkmQXzAoVU=;
        b=mubacCh+kykEDDg0zDbH2dII7MvVqqukTAAqTD7ieoX4NQ33m+YD5hOb/2Ax6W66DK
         S2aYiv2tZK1NyjhL+RdjDSKHM+QumESsDWEqSS0FHgzxvka4anLJLa8vJwC6mujMyGnT
         DnT2aCZvaLs7o4uYmioL7OLhOGBz8SGeIDEv05gIRdWtne0+Ki4HLzWy3VxmFASi3Ot3
         SXBWsxufy4s99QSqm5LSOcdYxHM/MoPONuNmQmN3O6Y439/Pk/87NB5O2SOi50pneQOY
         B7my3+wMFEQ5pwbJC301nVML15QKiuBMIwnpaaqoivUKXFiq4XbjrgYMSFZ5waRqqWF/
         tK9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=M7z/UpvFrXiCKdy859UXJ/E53JBb0XvLwmkmQXzAoVU=;
        b=tH3ehAQrv8yCCPNELBjbQAf0er6OV5+bz3p8wg5QG3WAUiIO794zB08dv4xRojgRcz
         w9NlarlXFWLpIGST3eKYbs3Dt10QUrAPlq5Hs51505XchKPGy1Ep7WsxZRVtschDMwg2
         uCJ+ux0JaDaPHi026YhT5gTbM1ozGe4f6dc/csiAWUeFZtXwnBgBMHhqzyKcIWnWPgC2
         P+7GKQJRcnhsyOFAJtJO1b28kXYg1RY4AHpe39lYO81eas8QHI/nodG1B24e+ZVg1ojb
         NmopWhr3p9vFVUVd2vOdiJMKw55mWplUkSVkfhdO0jzcUhYruMHT+/znyc9WBsmEl7cB
         uJPA==
X-Gm-Message-State: APjAAAVKiYjUvUZsj17XQODq1emEy4vGm/+5xt7BtCUH6v3rnX7WWDqf
        o1mmQ8dRDEM+3Ayn7jJ+GEpuRbLO
X-Google-Smtp-Source: APXvYqwB2/a60Zh2roC10cgReox6MVFEAQIc55ewxrhrVgNTKv4YNzTsuXgSMFAEbZHdtk1DoWQGQg==
X-Received: by 2002:a63:f403:: with SMTP id g3mr2813902pgi.62.1581676259983;
        Fri, 14 Feb 2020 02:30:59 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e1sm6408326pff.188.2020.02.14.02.30.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Feb 2020 02:30:59 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCHv3 iproute2-next 0/7] iproute2: fully support for geneve/vxlan/erspan options
Date:   Fri, 14 Feb 2020 18:30:44 +0800
Message-Id: <cover.1581676056.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1-3 add the geneve/vxlan/erspan options support for
iproute_lwtunnel, and Patch 4-5 add the vxlan/erspan options
for tc m_tunnel_key, and Patch 6-7 add the vxlan/erspan options
for tc f_flower.

In kernel space, these features have been supported since these
patchsets:

  https://patchwork.ozlabs.org/cover/1190172/
  https://patchwork.ozlabs.org/cover/1198854/

v1->v2:
  - improve the bash commands in changelog as David A. suggested.
  - use PRINT_ANY to support dummping with json format as Stephen
    suggested.
v2->v3:
  - implement proper JSON array for opts as Stephen suggested.

Xin Long (7):
  iproute_lwtunnel: add options support for geneve metadata
  iproute_lwtunnel: add options support for vxlan metadata
  iproute_lwtunnel: add options support for erspan metadata
  tc: m_tunnel_key: add options support for vxlan
  tc: m_tunnel_key: add options support for erpsan
  tc: f_flower: add options support for vxlan
  tc: f_flower: add options support for erspan

 ip/iproute_lwtunnel.c    | 398 ++++++++++++++++++++++++++++++++++++++++++++++-
 man/man8/tc-flower.8     |  26 ++++
 man/man8/tc-tunnel_key.8 |  20 ++-
 tc/f_flower.c            | 301 +++++++++++++++++++++++++++++++++--
 tc/m_tunnel_key.c        | 205 ++++++++++++++++++++++--
 5 files changed, 922 insertions(+), 28 deletions(-)

-- 
2.1.0

