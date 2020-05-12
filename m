Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F501CE9EA
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 03:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgELBAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 21:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728420AbgELA7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:59:55 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCECC061A0E
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:59:55 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id j21so5357521pgb.7
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 17:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GcPSJoiq2Hn4tpcHSFeoNkYgaD7vYFG3KSFZPTpMDws=;
        b=iQOT8ianP3O//1OJK0q5F+gsTwAafwh+fF4ZOHvbl9uwNxDXgMUDtBL3/b+UMtjPK6
         k/U35GkJZKbhL7nKnkYiTyXj5bP8zrelLe7CUAhPlwWIVNhvp4aTA43cOv0XfR46OGNQ
         sxsL0UMoJNU+zsdhzMkJg4DXd1bJg+BiSNWxPLdc6+k74I+y3cssqjlRMOUlbGON0B3h
         3wJHsQCqxSd+sLP1FGrfZTF34O/vvtd/eYEiI5D8e1vEgIedlvM9SMq8NOjiCqvsviyM
         +i5wvt8xn6r79lD4fATxHMrXtMZGEAAcx8Vg8Eo+SbsUbPCRx24f2t+ETXFBPDqLRPgU
         dtYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GcPSJoiq2Hn4tpcHSFeoNkYgaD7vYFG3KSFZPTpMDws=;
        b=FDhc/vKQ5t7EIRrQPOySpj50pU1xqKzyzgyg9QIR4BmwTQRC1Aq3pCczLWsanI7gGu
         JzGBg5xi3J3AdJ+6cwdF5F0GF0DwOaMx2K5SmfyjbfrF1cnELsC/WD04XdvehQSnEGB+
         VEZ63espjMVP8PFOBgJhYbhdIRKbFJ7oCQwOF4g6ve00ALBU9SnyYCFGnj2f336WRQkm
         novpqD0vQ5hGTo3KphTmG8TLut8uwlLH6BvMLHBsX7NNplaqaFMRvjRE9zqjSCThyaww
         WAQKvBitV2UunhEzc6p4ywry2BF9MJjRyWBT5XuwWtx+unJDB2GLovvDtd1CKsPIAFHX
         eIhQ==
X-Gm-Message-State: AGi0PuZg39T+Tk8tFZgwMKo5EouZpbQ+t1zpuCJdTvX1PmXEWRlRJZ/C
        Gt3MlCL7QVjvI2EdopBqhxZHQMU+VVo=
X-Google-Smtp-Source: APiQypLA7mffRp4/v82JIR0Vmjk4ebvjqKE5oBC9CURZQFCeViU4oDAyPKvV7KYBgjvBgCLCOb0Jog==
X-Received: by 2002:a62:6341:: with SMTP id x62mr19242912pfb.289.1589245194763;
        Mon, 11 May 2020 17:59:54 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h17sm10171477pfk.13.2020.05.11.17.59.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 17:59:53 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 05/10] ionic: shorter dev cmd wait time
Date:   Mon, 11 May 2020 17:59:31 -0700
Message-Id: <20200512005936.14490-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512005936.14490-1-snelson@pensando.io>
References: <20200512005936.14490-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shorten our msleep time while polling for the dev command
request to finish.  Yes, checkpatch.pl complains that the
msleep might actually go longer - that won't hurt, but we'll
take the shorter time if we can get it.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 8e2436d14621..c3f0f84164d3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -358,7 +358,7 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 		done = ionic_dev_cmd_done(idev);
 		if (done)
 			break;
-		msleep(20);
+		msleep(5);
 		hb = ionic_heartbeat_check(ionic);
 	} while (!done && !hb && time_before(jiffies, max_wait));
 	duration = jiffies - start_time;
-- 
2.17.1

