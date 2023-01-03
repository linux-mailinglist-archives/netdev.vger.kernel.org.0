Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F7265C155
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 14:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237624AbjACN5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 08:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237560AbjACN5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 08:57:38 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE4310B5C;
        Tue,  3 Jan 2023 05:57:37 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id jo4so73797226ejb.7;
        Tue, 03 Jan 2023 05:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wiBka+STdfWqXEYEF1M8oLHBS2PSmzps9GRArvQ0wNQ=;
        b=f/XvfUxi6Y0rsfgiOoq/mD7Rx41wdk8aKmk/uWT++mY+WIDwkDdOK6GnzV6Ai6643i
         uhSwNjlL3L3Nt4mjJc1iZFlYPVw9WD5YTI/C2o6JCc9xFbHnlpp+4JU9nIhxQ+hiWXBd
         B5sNy/sPbatnJT9qWxxrteRXbaw+nlmoS8zXKR9wMaI9ZsXHlLo+5xLPOpQIYKrlzQpE
         5+O9mrtWCwpvo03dielomObAafVznn40dbmQT0Gvbtaulxf/VoiOreOskgBPq82gf6q+
         GdbtCO1E8JIw6IAO5wfaUdH5WhvO6zS70Ss6C6UePL6TNcu9g3j1I0mEq9uZrFYP0rIH
         qzAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wiBka+STdfWqXEYEF1M8oLHBS2PSmzps9GRArvQ0wNQ=;
        b=cYKMBKpbl7jqQ6eVSYO2LDh6+xYWJ5qJtpejdBs71BAsAIUMkRSftP+9y8+HDX3oSK
         xpOakw8xWO+Uxq2DKxH8rqaVEvZoSnLtYLeTuY9audz9z/E2Y6uOsj+gs67cCV130Qet
         4G8p3BlCHQQVCZnuNl/aSSp48ZTWjwAeeaWjf7QVMJVaWRuWuMT4/dlzNFU/NQHAaiHE
         TgRpQzHGPzBo7smdoKBtaQ+fyCOpKMk4PAlyt4MQzPFc2haVN8cPtaTFDS0QpfPuYv1j
         lcVlDqdPP7+mYlrUK5lkpsdbzmQP1VB8G7edYOu3mZ6D6uM1C877jmbUqC4IF1W+Tudb
         Bzkg==
X-Gm-Message-State: AFqh2krLhfFeSu0XBbE891BpLwS8oW34XI6DsDlrLjqY4WejDoG6AjHk
        UqLLbPLdZkiM3oAq8GJ2Plk=
X-Google-Smtp-Source: AMrXdXvHEPEUBS/O7zaaU5DAH5vatKPRD27MbUHcClggxuFQNb+o/DXxJXkEQA3LieO19gw+yFwtrg==
X-Received: by 2002:a17:906:8447:b0:7c8:9f04:ae7e with SMTP id e7-20020a170906844700b007c89f04ae7emr38712372ejy.22.1672754255330;
        Tue, 03 Jan 2023 05:57:35 -0800 (PST)
Received: from skbuf ([188.26.185.118])
        by smtp.gmail.com with ESMTPSA id k10-20020a170906158a00b007ba9c181202sm14095026ejd.56.2023.01.03.05.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 05:57:34 -0800 (PST)
Date:   Tue, 3 Jan 2023 15:57:32 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH RFC net-next v2 09/12] net: ethernet: freescale: fec:
 Separate C22 and C45 transactions for xgmac
Message-ID: <20230103135732.saku5om5hgyw3ygk@skbuf>
References: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-9-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-9-ddb37710e5a7@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221227-v6-2-rc1-c45-seperation-v2-9-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-9-ddb37710e5a7@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Regarding the commit title, there's no xgmac block in the FEC. "XG"
means 10 Gbps, surely there's no such thing on imx/Vybrid. Can just say:
"net: fec: Separate C22 and C45 MDIO transactions".
