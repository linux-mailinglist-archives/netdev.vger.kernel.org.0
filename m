Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5C1F638FC
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 18:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfGIQAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 12:00:10 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:37145 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbfGIQAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 12:00:10 -0400
Received: by mail-wm1-f42.google.com with SMTP id f17so3812975wme.2
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 09:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=9mEtF6MTDvkn+00K/PaPfku3JHwyCmyW1acro5g/3Zg=;
        b=xoeAWbyooY2l+eYNWfUlXtf/guxHDMCK0UUwZvdL56X1CzzTSCV6CdbQNxz6OnZa/f
         uW+M/Zxe6bmbH/Qz9+cARJYjy3IChZ+q3YHHPMrT4iVKPJGc8VHqal4Z5nUaLZUF4dRX
         JEkuJS/nq8wI415DXfaWDpjC5LyvuU1UqhaC8nIOVJJoOCHhWhNAs+ZSnGFkQGfvTiD4
         rGhEnTgPolh90OE3GxVbnVFweUsEIA7PPJnIlbc2FKlmVdgbtocyc9CU0hDWMsFbrpZJ
         a9xu/S218pwhcPJuJUuBI/dsp/r/kApAiEaP+nyyLBDkSqXRcJA5NqPtmiuuxvMnH/Ul
         BZzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9mEtF6MTDvkn+00K/PaPfku3JHwyCmyW1acro5g/3Zg=;
        b=ky7VY+PGVTw3C7VBdS961Wc3zKhJhNimz20ES5180eg1TJMoAeNkekDu02vGc1OzR2
         x+Mv1Qc7uf8MpzEuGK7ABjxnJDH7+jD701C6jS5D/v1bEL//ch3NEianw35U+I4M310q
         KUqbOIaWy/4wMtRyrV04IcHC0E/iiILByTNCZkIrEAWLf1QZTQ0E5pLyokR/4t6vu2AM
         g+yd38z3qMsxaQrAwo3owh2FaXokNpJB0A7gg+KNsBQBdeUeLzJfj9qGllWrU/1w77TX
         aWQMLduXxbNzSoMIk9O0X3AmhUdQxOUuOr+D68CeNcIbkl0Jgb0FNDn0Vnc7JlF9ruEn
         TK4g==
X-Gm-Message-State: APjAAAXAT7h04vWno12gAgIEFAduk1YpU2M/t0C31OXPLPRrRKriDVEU
        8aD7aTIS9+qX0eBBE/clQUlA/fvvwuc=
X-Google-Smtp-Source: APXvYqynkO3B3XB0WmbHe4pY7aJyJ8o5PYxiB+sh6uf6olJRiVF5u1HU2xJY6Rzc6vBS2C5KYlmybQ==
X-Received: by 2002:a1c:a7ca:: with SMTP id q193mr646494wme.150.1562688007555;
        Tue, 09 Jul 2019 09:00:07 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id t6sm3725900wmb.29.2019.07.09.09.00.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 09 Jul 2019 09:00:06 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        dsahern@gmail.com, willemdebruijn.kernel@gmail.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH iproute2-next 0/3] add interface to TC MPLS actions
Date:   Tue,  9 Jul 2019 16:59:29 +0100
Message-Id: <1562687972-23549-1-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent kernel additions to TC allows the manipulation of MPLS headers as
filter actions.

The following patchset creates an iproute2 interface to the new actions
and includes documentation on how to use it.

John Hurley (3):
  lib: add mpls_uc and mpls_mc as link layer protocol names
  tc: add mpls actions
  man: update man pages for TC MPLS actions

 lib/ll_proto.c     |   2 +
 man/man8/tc-mpls.8 | 156 ++++++++++++++++++++++++++++++
 tc/Makefile        |   1 +
 tc/m_mpls.c        | 275 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 434 insertions(+)
 create mode 100644 man/man8/tc-mpls.8
 create mode 100644 tc/m_mpls.c

-- 
2.7.4

