Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C8EAD449
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 09:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfIIH5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 03:57:02 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34152 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfIIH5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 03:57:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id r12so8664976pfh.1;
        Mon, 09 Sep 2019 00:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YGGeCQtERmX90Lvsi+k1fVEQMKEHIDobHtMhw/gMGHE=;
        b=JYXqHlNZ81B82PHnnlJqixzmmzhpv0Armh395148tWKPJMByuJDwL6Ahdh7OM6iuiu
         1cYNwVS0YTBbFUtHsRJkhhYcH5oETVnhvLjlcqJT/pUbW4xes8CO6cHa2B3aYTKAK4tX
         fVlZwh1+7anVKS6/ftVgPzKXtlfJVM0oeNUgksydbIkKWK8taargOa+QVbAtqJLdCLjm
         EB8v1Aeq4HeOn7t1aGcf1c6SIVuDIaVq4JwmK2wroV+/5zbeacKxHra/4eoA3jAa26ap
         fA2LY/gqSF8ad3fAgdvKjUmVMQA8+3/LNHAqSGo4I1axbEFB+TTwAouQ6JPIyeihLJdG
         eU2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YGGeCQtERmX90Lvsi+k1fVEQMKEHIDobHtMhw/gMGHE=;
        b=QxIEy+IBcLU41cOSqjr55uVwd9alYkLGhsi0t9GFwndM2N1RIGJx9NzAegZ10X3ryL
         qX/XI9wv3OUNdYkR32dc2KqfZhkY4Llv2W4+/oz18YG2LLm78MN6cmVAcc4QSRemyW6w
         lCzfeLEPnVnmiPzbViJsvOTnJkqjM2ZDKyGAoOnkYCgtsZijJB2wow5sEOemNLa3tc46
         lNCADkNS3N3aeuGcpI/ukRi7vNZJ6RF0IcCtsGQX967lu020GtcKr0LB/i/f+yYfB2Jf
         jGS1v0N7Zeif0k+udqB4Dmas5ryVXNYnTt5s/5NH8+dYDChML3INso2d23xCX8nPF7k0
         xaLQ==
X-Gm-Message-State: APjAAAUxdJ2GL9eh1kik3WXuLbHzS4xu1TN/Re7VuQkK9wJXq4SfP/03
        53TW12/dwehd+8LTHVvXVS+28nl1qw8=
X-Google-Smtp-Source: APXvYqw0Vn1p3kvXhalSTFAxpXIbydjlqAOpdjPVukB/MpBbgaLE85+2SzhlleGrm39lfn+ng1gChg==
X-Received: by 2002:a17:90a:a4c3:: with SMTP id l3mr24271806pjw.46.1568015819248;
        Mon, 09 Sep 2019 00:56:59 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p5sm4026204pjr.2.2019.09.09.00.56.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 00:56:58 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 0/5] sctp: update from rfc7829
Date:   Mon,  9 Sep 2019 15:56:46 +0800
Message-Id: <cover.1568015756.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SCTP-PF was implemented based on a Internet-Draft in 2012:

  https://tools.ietf.org/html/draft-nishida-tsvwg-sctp-failover-05

It's been updated quite a few by rfc7829 in 2016.

This patchset adds the following features:

  1. add SCTP_ADDR_POTENTIALLY_FAILED notification
  2. add pf_expose per netns/sock/asoc
  3. add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
  4. add ps_retrans per netns/sock/asoc/transport
     (Primary Path Switchover)
  5. add spt_pathcpthld for SCTP_PEER_ADDR_THLDS sockopt

Xin Long (5):
  sctp: add SCTP_ADDR_POTENTIALLY_FAILED notification
  sctp: add pf_expose per netns and sock and asoc
  sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
  sctp: add support for Primary Path Switchover
  sctp: add spt_pathcpthld in struct sctp_paddrthlds

 include/net/netns/sctp.h   | 13 ++++++
 include/net/sctp/structs.h | 13 ++++--
 include/uapi/linux/sctp.h  |  4 ++
 net/sctp/associola.c       | 28 ++++++-------
 net/sctp/protocol.c        |  6 +++
 net/sctp/sm_sideeffect.c   |  5 +++
 net/sctp/socket.c          | 99 +++++++++++++++++++++++++++++++++++++++++++++-
 net/sctp/sysctl.c          | 16 ++++++++
 8 files changed, 165 insertions(+), 19 deletions(-)

-- 
2.1.0

