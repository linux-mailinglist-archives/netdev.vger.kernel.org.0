Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E65A6466B
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 14:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfGJMlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 08:41:07 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33664 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfGJMlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 08:41:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so2342922wru.0
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 05:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=PjY3kbUr6l1lFSqZrTcAErRPwC1ctJRZ894O74IGzQ4=;
        b=0aLX2Y6TF3P6FrZegXEgF8k1spR9kdBDZ22Pe1Sx91AURIeRldTslGQdSBL0MpCqMo
         nXi8+gUSVmMwIm88J0t5SEGvqFwsEK6PZZFZSyDGGaHajHwD5tPQdtaQEotmrgTvjdi7
         MXEtYclfQBRE5PiCBylMlqLRfOfOFRpju8ebwmda+fjteykVZg5mgonuyOG8psUGW/71
         k1zdNVFxBRXfsL8ByMUlbn4Z3wbdru8zIUh6WpULplegzxb9wwIedY3/Q3bfu/tJuoCV
         UXCT3moYrpvKS9ZJUr4fsOuoAGg4nt5UYYZjqnGCattFyyy6SqlBxFqFrse9Ler9qEbF
         XLJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PjY3kbUr6l1lFSqZrTcAErRPwC1ctJRZ894O74IGzQ4=;
        b=LrSxiKiRHwGKtWNbSrcgEEJvLYqDC4jBmMVxKCSwdmLo43ILCwnHxUktRZ+ebc2DJx
         05DJwET4XB35Qti5fjWNpdpJxtgBjy9TXWC0gxPUrzjbzi/VPW0b9TRflULo4xiRfRIo
         y6rHxUgeVwf8BiK4EzDksCVXVrIsFVJo8+rCywRWaHyqCNbVsu12NxQkx+W5dEUZQn3X
         STpS6GFlr72q9ZmldrrMp6lX+MwM7QyxooIV8hExEY6OWxPtuPqkqiEJb34lDrpV3ma5
         ykAsJ9llmzGc30vILg1fUjl1VAYmhhGD4GbeApXj0R2wocmW1pcP9fQA00jQHu27wc59
         mzoQ==
X-Gm-Message-State: APjAAAXLIwww/9lMqbDwnNKQsRzzqOuf9pKI0+0EACyQ1lAzTBPzFWsn
        sUcsNVqfK6g+e/U/VAPV1F6maKUts5k=
X-Google-Smtp-Source: APXvYqysA6sXCImNmIriL+qeOa21TJ/msRxPrcPvu7Z01+W2HtZz+jlAkd+FTfc0tcvYlA2QgwYWRg==
X-Received: by 2002:adf:ec0c:: with SMTP id x12mr30996702wrn.342.1562762465060;
        Wed, 10 Jul 2019 05:41:05 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id z5sm1406759wmf.48.2019.07.10.05.41.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 10 Jul 2019 05:41:04 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        stephen@networkplumber.org, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH iproute2-next v2 0/3] add interface to TC MPLS actions
Date:   Wed, 10 Jul 2019 13:40:37 +0100
Message-Id: <1562762440-25656-1-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent kernel additions to TC allows the manipulation of MPLS headers as
filter actions.

The following patchset creates an iproute2 interface to the new actions
and includes documentation on how to use it.

v1->v2:
- change error from print_string() to fprintf(strerr,) (Stephen Hemminger)
- split long line in explain() message (David Ahern)
- use _SL_ instead of /n in print message (David Ahern)

John Hurley (3):
  lib: add mpls_uc and mpls_mc as link layer protocol names
  tc: add mpls actions
  man: update man pages for TC MPLS actions

 lib/ll_proto.c     |   2 +
 man/man8/tc-mpls.8 | 156 ++++++++++++++++++++++++++++++
 tc/Makefile        |   1 +
 tc/m_mpls.c        | 276 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 435 insertions(+)
 create mode 100644 man/man8/tc-mpls.8
 create mode 100644 tc/m_mpls.c

-- 
2.7.4

