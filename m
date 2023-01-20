Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB63067561C
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 14:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjATNrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 08:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjATNrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 08:47:18 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248FE7AF26;
        Fri, 20 Jan 2023 05:47:17 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id iv8-20020a05600c548800b003db04a0a46bso1196221wmb.0;
        Fri, 20 Jan 2023 05:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w9/uce4vDjbb3QGdKWqJHgUH8EpUbOmRoMPIxVcjyEk=;
        b=F1cw6HkK22FZIgIulG7FR3kwDvhir1/ES2huF4wXgX9kPaEIJEZDTZuGJA+ZE2Dsrk
         Jde74aPy0r2B03HZWs153PDUibsWnAvU6VGS1ZdAPRhkkGtoEDR5QGtjfe0EvR+fDQzZ
         NM2W2GQfDKmqeXXaUGBXZk6zmEWle41N6QFWs1nmhqM84syrty2TAgSiEePS79x+z9v8
         gKRhLcZ2nZUOMor5B+b86+fWPwGQ5aY1CydKvsUJgDlpt2ZdlbmGJDorgt6RTsCCKQy7
         xX0b3/cvngIZlKFXNr82fXbOz9UARIqaPZLg7yvRWXyL4ipVVPXd22lUy1RVU+ihHI9o
         SsNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w9/uce4vDjbb3QGdKWqJHgUH8EpUbOmRoMPIxVcjyEk=;
        b=uHf9Wl67G05CeG12pNAmia2Yq+R8vrSZR+FcqpWp5fKbAefbQY1gNFEACJEYbatrkM
         6LwWgSpzx/uFYU88nvUsfs4/I0mRzpDdn97Q8LwztAfnkSgciKhTKPQIT7/tVnhI7NYe
         HHQhFTL9/oza1WgdgdI+6VTO8cF94Pq6GkZzXDnEs1QNKvY1loYtVi3tXEN00/5V6qc9
         0ZBmCUfDOvcbcapCdpicFKOWr5jm1Csusi/A1pFjnVnDTf4gMzkKIKJmM8Ln16fj0RCP
         Mh8kWKcFEAzWMgmGmUMwVLemPjy+oKQUkl/DhH4PcryEKdsFbZA+Nn+0QOWrObfGcHmy
         yp5Q==
X-Gm-Message-State: AFqh2kpMjWpSkxWZViUUbcAC287rqAEi/z9Y/qJDwofYpC4sHtzGGEiT
        ech6NJ8cj+vKJQRPHsfrC9s=
X-Google-Smtp-Source: AMrXdXsE68bpRq7dVCqvYLy/GPhr0XSB5q5U6Cl9xtARg9zUuh9kf4MTdyH0D0TwKk1rFnSyWusENA==
X-Received: by 2002:a1c:7312:0:b0:3d2:3eda:dd1 with SMTP id d18-20020a1c7312000000b003d23eda0dd1mr13650562wmb.17.1674222435595;
        Fri, 20 Jan 2023 05:47:15 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id p21-20020a05600c359500b003c70191f267sm2696503wmq.39.2023.01.20.05.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 05:47:15 -0800 (PST)
Date:   Fri, 20 Jan 2023 16:47:12 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>
Cc:     Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: microchip: sparx5: Fix uninitialized variable
 in vcap_path_exist()
Message-ID: <Y8qbYAb+YSXo1DgR@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "eport" variable needs to be initialized to NULL for this code to
work.

Fixes: 814e7693207f ("net: microchip: vcap api: Add a storage state to a VCAP rule")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Probably you had CONFIG_INIT_STACK_ALL=y in your .config for this to
pass testing.

 drivers/net/ethernet/microchip/vcap/vcap_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 71f787a78295..69c026778b42 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -2012,7 +2012,8 @@ static int vcap_get_next_chain(struct vcap_control *vctrl,
 static bool vcap_path_exist(struct vcap_control *vctrl, struct net_device *ndev,
 			    int dst_cid)
 {
-	struct vcap_enabled_port *eport, *elem;
+	struct vcap_enabled_port *eport = NULL;
+	struct vcap_enabled_port *elem;
 	struct vcap_admin *admin;
 	int tmp;
 
-- 
2.35.1

