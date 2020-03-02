Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 458AD17543E
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 08:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgCBHEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 02:04:32 -0500
Received: from mail-pf1-f171.google.com ([209.85.210.171]:39269 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgCBHEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 02:04:31 -0500
Received: by mail-pf1-f171.google.com with SMTP id l7so5109844pff.6
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 23:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R5/1GmsMDRuvHs8Eg5j1TKFca+X1oMnEPhFcLO24O9U=;
        b=Tb8TiCEYbDpO95BnRwe4UuBaV0XYcxMv2Ehgm+Gt7SJ6XsysFXvQ1S2ZNyNVXhiAyR
         yZxahi+RWghyoemPF2cy4NXypQf2zbtZ9t57oFUjT0fBpdt4eB2F0mQlOt/YiDaXwYvE
         fI8lIjTffGo6vThX+f5FQzuqzhhELoauu+oYGeeAcZmKfew7bLPd5K1ay19xb4mSmBmd
         MlmchOoJM7N1C3n1QcHMTZgpYTKP24c3MtjJ7LGrCPRrDfnGcj3pJF7AFXyJTOBpu+0s
         SrDlqkbGUgG/mPeZiWi0r/zrIz+87S6u2ciwYi9+YJrsoXB2sLvfeWXjEs3noYYgWwGr
         M2Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R5/1GmsMDRuvHs8Eg5j1TKFca+X1oMnEPhFcLO24O9U=;
        b=BMzAbz9s73IZ5wg/hKDtoZq8H332noWYa3TCQ+CwLT1mCV2Mp+dbzPmwQezAkSur27
         vWH/6fqj6KLYA91JhxI9fSsBA5Cdo9pPdXNjB9UD9LgCETGbDuN93rXwVZe/dzkCML2Q
         4uQBYGa3lF2G73RNa5ucaD/lGVNaBAgbgupak9cQwe5XmPEe4ESsaQal68TkGSM3Y72v
         UdemKUNqZp5z5kEZCvDVWTvVE2eL2ANrPeXk+vZO18pzAwgalvHvvp25FUSj6zOG96Bs
         t9E2U5TkCVFY//HoC4Z7srsYTeXFvSzy2C1POYObXXVEV2qizYivS7RPym9Niohr4Zfw
         Go8Q==
X-Gm-Message-State: APjAAAWV8zMEQzLAM6E9bxNeeDshU36Al58MiDUye1xJFO4HvJmkAjzr
        G67QNHXPiHe36dV79WhZIJeBEg==
X-Google-Smtp-Source: APXvYqxKwsQQNvUjAEKUOsN0wYCClSgfFm5zZ4GfHEU52jXT2j+PYAYd9E1K/tNWo1PmZh6rJsHUJA==
X-Received: by 2002:a65:43cb:: with SMTP id n11mr17535148pgp.65.1583132671006;
        Sun, 01 Mar 2020 23:04:31 -0800 (PST)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id b3sm19969551pft.73.2020.03.01.23.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 23:04:30 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 0/2] net: qrtr: Nameserver fixes
Date:   Sun,  1 Mar 2020 23:03:03 -0800
Message-Id: <20200302070305.612067-1-bjorn.andersson@linaro.org>
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
 net/qrtr/qrtr.c | 10 +--------
 net/qrtr/qrtr.h |  2 +-
 3 files changed, 33 insertions(+), 35 deletions(-)

-- 
2.24.0

