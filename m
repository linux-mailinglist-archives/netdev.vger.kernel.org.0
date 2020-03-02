Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C86117521B
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 04:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgCBD0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 22:26:55 -0500
Received: from mail-pf1-f171.google.com ([209.85.210.171]:34286 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbgCBD0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 22:26:55 -0500
Received: by mail-pf1-f171.google.com with SMTP id y21so1340118pfp.1
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 19:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w6YjYn6BXH7WqeHF++GS4XYMLYZO97EPFGU0VNZwjrk=;
        b=QWFVFaE6EG6SzUe0Eu0/AJopy/tBy+E4KaLiOzNNnKDZ+InzFBBH6d9y6oXDD1p0Bk
         DgRZhCPdjmnoHC8gJaeesBnfg7WTslxgGn6qMciqVrInUGxjgpZySbK6vkhgMsZ3EnRL
         I27zVPc6LFKVi3tlMz4jQenxam2h8nEcUqVDEylc2vfVbf4axxkPx7w3AIbHg6aOFmXk
         xFf29JGE2Bj4iK3+StRMju+AvC8PpmQ2TqWeZoQCDR2MuD5JlK6snBGaWrXEjHzmvVjj
         fFA4D4vA/AWXGU/711864Di+GJWxN4xSdx1IYcdAEgsQK89Tt/Wbbzjc+mroftqd3ome
         65Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w6YjYn6BXH7WqeHF++GS4XYMLYZO97EPFGU0VNZwjrk=;
        b=CeAcFjXcWaAacF6WlArJgDtdQMibcmowZhBAKV1bf+Aj4LVmdXDEVarPEfrd2oozPq
         prMHuiwaFY1agm1QSELkn2v/RlFPgWFiXC8bEIFVuQYwYuLNM0VbLzlW372L/I2dIboC
         olCUZ0cEUsUq6q6Yqz1G+1GFatBzMw4BuPBrq2qWIUj0fI/DUcS9nRgmy3mp+HNck/SV
         wvv4+de5BRrxlgRZF9ra3T3frhtfhuxolBir/gxDvf0NWmaf53bl3ppQyeFvwlNEwXFw
         iChi5kXiyf3zAsqmhYNFGuaAuIedWsfcL2ntHFNmzd0Yd1lixfNCRTFeFW2PBzNvcM+X
         cyYg==
X-Gm-Message-State: APjAAAWBgpNTogERpPXa8nsfQ7uTOt7gXXqHYwZW2Ik/BnUqVAu5X6wV
        rDHFvaIdZAgBaR+ipG6QAIqNFw==
X-Google-Smtp-Source: APXvYqzRu+CHaA3CEuPwT7EdTKcOZjp9SVoiuWVf99F/1ddFKSnoeTCu88q2tC0vX+g7emLnpfHBFQ==
X-Received: by 2002:a63:3744:: with SMTP id g4mr17835545pgn.424.1583119612278;
        Sun, 01 Mar 2020 19:26:52 -0800 (PST)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id b133sm18435739pga.43.2020.03.01.19.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 19:26:51 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 0/2] net: qrtr: Nameserver fixes
Date:   Sun,  1 Mar 2020 19:25:25 -0800
Message-Id: <20200302032527.552916-1-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The need to respond to the HELLO message from the firmware was lost in the
translation from the user space implementation of the nameserver. Fixing this
also means we can remove the FIXME related to launching the ns.

Bjorn Andersson (2):
  net: qrtr: Respond to HELLO message
  net: qrtr: Fix FIXME related to qrtr_ns_init()

 net/qrtr/ns.c   | 56 +++++++++++++++++++++++++++----------------------
 net/qrtr/qrtr.c |  6 +-----
 net/qrtr/qrtr.h |  2 +-
 3 files changed, 33 insertions(+), 31 deletions(-)

-- 
2.24.0

