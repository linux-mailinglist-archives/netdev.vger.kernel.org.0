Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3C2B197E47
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 16:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbgC3OY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 10:24:26 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44009 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgC3OY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 10:24:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id m11so15993109wrx.10
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 07:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R92YWJs6ZUfSUciFXC15gqnX+iY6Oe8tr3zBsBmLO1o=;
        b=LXSTmu4XJB6THCgffb7Wh5jdNUNfS6AoU1HEvnVHpfGmoCl/Gpk9ef1MhSfJachfku
         l/pz0ykCpM9na/7NW7aH8sfJmIeDlUxcAD9cqFfqxnQ2idt5T2S6H+i/cnWeETINdOCt
         YDztfxy0uVdGyHLxrdftP9uiyF2rz0enhoZ+xQCTwGqiAietRCFSRV+Vs9WE/+f4QYXy
         VA2Vq0z4hP7KS3fZflOE8OHAQkqfCNsFvl+Rw2CMuS1SRmdvPiEwJcUiDTHJs8f/pRUc
         lt5ICwE1zFQOHUqI+d2NT0FjvOIT65sD2guwZGqnK3eyAViGBJbuCSbk8XZz6IXMGx5c
         DfCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R92YWJs6ZUfSUciFXC15gqnX+iY6Oe8tr3zBsBmLO1o=;
        b=Zu847zjlWzHaDpq1nYBT+Pl3yILRWHQ+WyfTdeavJwDOsx1gaGCDZD72KiYIFyNzMh
         Fo5nVivXT9jq34FRgSY7Ki0eEeBT4QS46LGi9A/uoLm4xEp9Om1FLyT0Ervg0HXRoSVQ
         MLYVSK1hq+xu4fSFBkTDp002HTHgFMFQJtBXiPSr3YS4Vp0a3G3avWYG13ij11r22ObB
         HyEOEV42Ekqmp5qLcFeAlZehhfdN7K1+nqayFMlLTgec+Xxc805sDUcZveab4hXEPXYd
         +WY8lPkC5wbZoNyXmAkdPr9TdLDQM8hALjxzih9hdGricHkPhqub8v1egPnmR+AfZFwl
         yA3w==
X-Gm-Message-State: ANhLgQ1ff02VOr8Yd0eYPmXMpA/z8Mr3uVXqvrTozV78OUtxZubkeRoF
        nApyf7TotRjwz9BkjlhStiXTYddpyZgpZA==
X-Google-Smtp-Source: ADFU+vv7KfG6cDoJPBzvIgHv+jIPcVdFbw8LRWcROuV/VqOx0I657GZNoPiwVRqznZO9siXcTE60RQ==
X-Received: by 2002:adf:fe4b:: with SMTP id m11mr14950388wrs.20.1585578263415;
        Mon, 30 Mar 2020 07:24:23 -0700 (PDT)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id 98sm22956856wrk.52.2020.03.30.07.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 07:24:22 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net-next 0/1] selftests:mptcp: fix failure due to whitespace damage
Date:   Mon, 30 Mar 2020 16:23:53 +0200
Message-Id: <20200330142354.563259-1-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David: it seems that some trailing whitespaces were removed by one of
your scripts when applying eedbc685321b (selftests: add PM netlink
functional tests).

This causes a self test failure because the expected result in the
script has been modified.

We do think that it is best not having trailing whitespaces in the code
and that's why we are proposing here a new version without them. The
documentation also ask us not to leave unexepected trailing whitespace
at the end of lines.

But we simply want to ask you this question: Is it normal that these
trailing whitespaces are automatically removed? We understand if it is
and it would make sense somehow but just in case it is not normal, we
prefer to raise the question and avoid other people hitting the same
issue we had :)

Matthieu Baerts (1):
  selftests:mptcp: fix failure due to whitespace damage

 tools/testing/selftests/net/mptcp/pm_netlink.sh | 12 ++++++------
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c   |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

-- 
2.25.1

