Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6492CD835
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730384AbgLCNve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgLCNvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 08:51:33 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6CDC061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 05:50:53 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id c7so2147716edv.6
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 05:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=essensium.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=plP/bTLAduxXDkk4ZNIIU74yKiIZjrQEty9nrRdjKWU=;
        b=Cn80YsmTfKXqKV5nw/bJ93ttZUqwPSzgJ+mA18itw5EqvqyggNTFuTiyYJ/PUzW47Q
         Zg13S05NIisOUOgglu0Dx24cHNK9MOdo0zo8S1iloUICcklCNcZhTfO6pfsNI49B0Uxk
         DQoE//xMS0d6Ro4TnRTBkXer+FMByanXWJqeuUavsoFunzz5Ls8/4gr2+aYA8ikxsLW6
         EDLiH/Mu4mqUGRJKfKgXOPxgc9GyJXkhbpkh77HejswuDgAQ8UoU1zO892qMIaE5MVdW
         TYBkw6H2E7fkJFjRaZ0xZZCq6Nz8K2CquaaGAPmW2p2eKTHMWst5FlI1CSXFFwa+sw8F
         NROQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=plP/bTLAduxXDkk4ZNIIU74yKiIZjrQEty9nrRdjKWU=;
        b=cXfNYW2ViK36OatY1Au36XUh3Rh035ziBFMMHMs2iEUoSowEegWRDW0cgwouU0gkTl
         5lilBfgn0nhegHd3PqOx9K3krzvUnnke2qu/fKofEl5y/3Cc4t5E/nPhelaYFkxEdTR7
         7wBvA711nkXbA6cTgQWTTjV7/pLdSGMHaH7GWOR9xhxpgdswMEa9RuZ5tW1VNI5CF8lV
         bl1ZS+Xd7C5WxrGgA5ppkezpiumnfJUgruLNbwcscUAW1iRBy0OzcM7xyh5yzWdQGnSb
         4FndEOHLiZg8eLA0KETxnoiQCN+zoI4yhxIsiEyAkQzaAWgOjkgJP1EYyyYQI97JIpPT
         imng==
X-Gm-Message-State: AOAM5318zVNnzXc6ILgJ4du2VAfSGzjl6XxRJd0Ob9E0ajsis4jpVC8H
        BM6nK9H8OBsOcVFr/eyhXIEQYw==
X-Google-Smtp-Source: ABdhPJxBSSFRQjdp7yxP1yhW8LJSG88giWm0idIOkTcotdfCQzXmqsbzD6VGV3YP0fmv0c+sK1qsNw==
X-Received: by 2002:a50:ab47:: with SMTP id t7mr2943580edc.289.1607003452090;
        Thu, 03 Dec 2020 05:50:52 -0800 (PST)
Received: from belels006.local.ess-mail.com (ip-188-118-3-185.reverse.destiny.be. [188.118.3.185])
        by smtp.gmail.com with ESMTPSA id t19sm903192eje.86.2020.12.03.05.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 05:50:51 -0800 (PST)
From:   Patrick Havelange <patrick.havelange@essensium.com>
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Patrick Havelange <patrick.havelange@essensium.com>
Subject: [PATCH net 0/4] freescale/fman: remove usage of __devm_request_region
Date:   Thu,  3 Dec 2020 14:50:35 +0100
Message-Id: <20201203135039.31474-1-patrick.havelange@essensium.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, 

This patch series is solving a bug inside 
ethernet/freescale/fman/fman_port.c caused by an incorrect usage of
__devm_request_region.
The bug came from the fact that the resource given as parameter to the
function __devm_request_region is on the stack, leading to an invalid
pointer being stored inside the devres structure, and the new resource
pointer being lost.
In order to solve this, it is first necessary to make the regular call
devm_request_mem_region work.
This call cannot work as is, because the main fman driver has already
reserved the memory region used by the fman_port driver.

Thus the first action is to split the memory region reservation done in
the main fman driver in two, so that the regions used by fman_port will
not be reserved. The main memory regions have also been reduced to not
request the memory regions used by fman_mac.

Once this first step is done, regular usage of devm_request_mem_region
can be done.
This also leads to a bit of code removal done in the last patch.

1. fman: split the memory region of the main fman driver, so the memory that
will be used by fman_port & fman_mac will not be already reserved.

2. fman_port: replace call of __devm_request_region to devm_request_mem_region

3. fman_mac: replace call of __devm_request_region to devm_request_mem_region

4. the code is now simplified a bit, there is no need to store the main region
anymore

The whole point of this series is to be able to apply the patch N°2.
Since N°3 is a similar change, let's do it at the same time.

I think they all should be part of the same series.

Patrick Havelange (4):
  net: freescale/fman: Split the main resource region reservation
  net: freescale/fman-port: remove direct use of __devm_request_region
  net: freescale/fman-mac: remove direct use of __devm_request_region
  net: freescale/fman: remove fman_get_mem_region

 drivers/net/ethernet/freescale/fman/fman.c    | 120 +++++++++---------
 drivers/net/ethernet/freescale/fman/fman.h    |  11 +-
 .../net/ethernet/freescale/fman/fman_port.c   |   6 +-
 drivers/net/ethernet/freescale/fman/mac.c     |   8 +-
 4 files changed, 75 insertions(+), 70 deletions(-)


base-commit: 832e09798c261cf58de3a68cfcc6556408c16a5a
-- 
2.17.1

