Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C68E0179871
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbgCDS4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:56:13 -0500
Received: from mail-pl1-f179.google.com ([209.85.214.179]:44925 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgCDS4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 13:56:12 -0500
Received: by mail-pl1-f179.google.com with SMTP id d9so1405993plo.11
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 10:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kS4IUmCRm2jVOf0zGM0RXaG0aMwF3x0hQ2mtRwEQYFA=;
        b=Cd+tlC9A4F41XJwnI/1qXqVYQS1HITt6gp667TdYBnII0gGFqp3TAbLOrEWCCxs/BG
         aeLyHuDC7K35S3beYvwNmLJq88rj+OKh5K4nsUMUzXDl5+sJisl3F/po8Qh/3fNlQRaY
         XKecj3kquPJodPUcdcmpL/37muvXvzWLQlxTSxRuaPKB4QjPbGkFhr9ducTdqtMNEar9
         +SMrBN05aOUXx036q+vLqj1MYv1ItG4PttUOhfetAg2jJuofytZQSEq9zt7x8ny7Lty1
         qRk/StwH2gFBdgdpr5yuamK92+Rr5pAJNYu5zEETemhhCRHoLaCXn645a5wqQk8sVKsc
         EsZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kS4IUmCRm2jVOf0zGM0RXaG0aMwF3x0hQ2mtRwEQYFA=;
        b=NHDfy/aoozw9+VKOSBdiYZNbMA2S7oWAmSVaHG79gsO8ICb4h8NGOC7UgTlotbgoaU
         JY5REQiWhKVQdxwdrEksUuIUB9tNIfFCjGBGsJlsDpkr8I28tI/I0QJYyDZgK7v50SuG
         EFeSzPvfyFPxF3pCtd0/ygKvZYKhRITp8D+uake8hZTDjTNEPn8BJJCHyS6DRR/IU2ls
         qSnZodBufIkP+kgeXeH5A8XCcO3n88nt5iHh3DqytXZqeD4VxZqJDs+S4FbzshxPUtcs
         9DCs7mnO/nI6humNT7g1w08dSMm8ptZdxXoBH1YiyCZfRLrhKnhar2CHexJfK8YTLC4l
         3wSg==
X-Gm-Message-State: ANhLgQ2B3lXkmD7XB4Vkq5PuP38ALnw2p+xySM//R+jFLR9zFoBMFe6X
        muYzrcSNWAOoiN/Ia1royjPiPLYs
X-Google-Smtp-Source: ADFU+vs20ZCrkvzcgzQrCJNqXt1sPzT44NeHh6SrU9AdUFmiE3Z8clwLq7+NidGKrmsprXKoT57ySA==
X-Received: by 2002:a17:902:b210:: with SMTP id t16mr4106874plr.65.1583348169705;
        Wed, 04 Mar 2020 10:56:09 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id h12sm12720021pfk.124.2020.03.04.10.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 10:56:08 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, tahiliani@nitk.edu.in, gautamramk@gmail.com
Subject: [PATCH net-next v2 0/4] pie: minor improvements
Date:   Thu,  5 Mar 2020 00:25:58 +0530
Message-Id: <20200304185602.2540-1-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series includes the following minor changes with
respect to the PIE/FQ-PIE qdiscs:

 - Patch 1 removes some ambiguity by using the term "backlog"
           instead of "qlen" when referring to the queue length
           in bytes.
 - Patch 2 removes redundant type casting on two expressions.
 - Patch 3 removes the pie_vars->accu_prob_overflows variable
           without affecting the precision in calculations and
           makes the size of the pie_vars structure exactly 64
           bytes.
 - Patch 4 realigns a comment affected by a change in patch 3.

Changes from v1 to v2:
 - Kept 8 as the argument to prandom_bytes() instead of changing it
   to 7 as suggested by David Miller.

Leslie Monis (4):
  pie: use term backlog instead of qlen
  pie: remove unnecessary type casting
  pie: remove pie_vars->accu_prob_overflows
  pie: realign comment

 include/net/pie.h      | 31 +++++++++++++---------------
 net/sched/sch_fq_pie.c |  1 -
 net/sched/sch_pie.c    | 47 +++++++++++++++++-------------------------
 3 files changed, 33 insertions(+), 46 deletions(-)

-- 
2.17.1

