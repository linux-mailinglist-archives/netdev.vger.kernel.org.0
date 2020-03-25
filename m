Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACD419275F
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 12:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgCYLlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 07:41:36 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53572 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbgCYLlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 07:41:36 -0400
Received: by mail-pj1-f66.google.com with SMTP id l36so921678pjb.3
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 04:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=A2rFQYoG0usK23r1oSVQdtCYmOQHZ3GA8pHrI4dPEBk=;
        b=bMlf6cWqDPI2MgiVb0sizXfL1nLC/A17hUqxz9xNNgYtSaart9Z70CF+mAvdKM2B5a
         8h/qh1Ju4Q4Pp+wtY13ln9gdbjBqmwvs2TquYomgxGXoZJYD++s6Sxpndi5Sf4DPkJgU
         Yt9Sco4FtOFZUdhDtyZKeD3W4s5WYaje2l+k51lsZziZkCweGcDTwZcX/0f6tqUWUwhn
         zw9Nwyk6NzyaKwlBpj9DSNsYZKhAIgV/QGLxbuHySAAZLkZwD9OYeS1zaSRxf/l1ftmk
         Nh1Z3RlocwkdUmiiDzJ12mo7FhXweusTYtGhvVPmFQH6MKVpRgs7sFu6PatJH6ifj6P3
         WTgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=A2rFQYoG0usK23r1oSVQdtCYmOQHZ3GA8pHrI4dPEBk=;
        b=LiW3lZU5nkDizsBtLg/aeRF/HZ2jO+vidXm6LmLjejoyCIwpJmPDxz8PgNSEOA9AX/
         LMdExjuOd2EXYh628saR2M0TCeLLkBcGHMrkIbvewbRLBZQZ7zP/r0Tk5eni9TZi4xIh
         2aY5uqD2bfehGDVyIkJb6wALAJu+N+VdACoAA0nbFIkUhpo3bv+qNfii81Vfp1XeLjAh
         oI51Z/zjHtQ9fk5QwFjh4ZAYtgmEDl9hGJMNxFP2s9jfomnk3AK5m+x688VnL8GVt5ZZ
         rM6mVNUQ23e/VCOZ9csn8qXo49XOiUB9L9xrWQCYKWQD6ukFyG8+3XH7CnV8JK53yPLK
         O0Pg==
X-Gm-Message-State: ANhLgQ250AUZhg1BMBVUVBWppFANDq86HXKEa4TigI16qL+sJlg8p7Ht
        BsYQdShuxI3YMVHQhMqYVoP1OsbYPS8=
X-Google-Smtp-Source: ADFU+vuA7kn6L0ZNz30BBtVp3O2x6qb3suEPv+3pZQubht95I2vVVHPSZd5oa5Dxxckt7XG72eG6yw==
X-Received: by 2002:a17:902:7682:: with SMTP id m2mr2774112pll.311.1585136494826;
        Wed, 25 Mar 2020 04:41:34 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id h11sm2846632pfn.125.2020.03.25.04.41.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 25 Mar 2020 04:41:34 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH net-next 0/2] Miscellaneous fixes
Date:   Wed, 25 Mar 2020 17:11:15 +0530
Message-Id: <1585136477-16629-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

This patchset fixes couple of issues related to missing
page refcount updation and taking a mutex lock in atomic
context.

Sunil Goutham (2):
  octeontx2-pf: Fix rx buffer page refcount
  octeontx2-pf: Fix ndo_set_rx_mode

 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  2 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 29 ++++++++++++++++++++--
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  1 +
 3 files changed, 30 insertions(+), 2 deletions(-)

-- 
2.7.4

