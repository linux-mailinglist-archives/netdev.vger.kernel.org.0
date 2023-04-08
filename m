Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6626DBB79
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 16:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjDHOGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 10:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbjDHOGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 10:06:41 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8F71025F
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 07:06:20 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f080fc6994so761465e9.1
        for <netdev@vger.kernel.org>; Sat, 08 Apr 2023 07:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680962777;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3vUmvnNPOdVZqOHJVc8mQPvw2xX7AXvZhuej+JbW2Cw=;
        b=DENrKe7TKLpkCh1E4Z0mWkFlnmQi0+Q/IB34h1bpAA7D1YPzi/mL8dhtImcxx25bbZ
         VlchHXkjkcAlDm1gcHwgCsbgdYfZNJtg8OaUOWTGB8eeQKHUevXBPrj3F3vAhM2Fkh+T
         6bLVBPxzEaz4mvoQAdCmxWH6PJevrY4nyeKxnw1wtVogs0UIGL/JNaKkl8pUgl8p66st
         MpKVP0dXv5Jrhu9JEBAySEXrUV7Q7gTuTWEoSdP27TPjPvyvppv0ABhQReRokh7VU/Gw
         1yHmLrt2yRFdx3Pngs3UxUSP2Ok5TpIFJ9JUbqboWjUDgZ8afKSym7mT6BqiCNpjaOFj
         x47w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680962777;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3vUmvnNPOdVZqOHJVc8mQPvw2xX7AXvZhuej+JbW2Cw=;
        b=AYEmHGzmmXD2XbVzWHB02wJtpP+ppFaq/+3T7FKmWCB7+2vHklhL26XffflWHO/iNd
         5iB6qD1tmhTsln9nbPbSIODR3fskq27cql4J9YbxNxXKeTmgfGgdzZGyAUSNQF8gZsJu
         mwEHO4jA9KVU/1R0F9T1XgGC6ublQojChtKBuAeOzHElxkdXzPsHMkn1vFaXXs5TB2FL
         QUJm1Jn3/U9qgixpaFdBS0dUMcK6ZdsNH6z9FewHgXg9CoXvNTwwji4KADIq4raRQhmh
         Hmztkwn7aKaUDwTMEMwxfFYEBrIOc9qHqGD6Yz6lW5TVqV4YHWHPRilRT6XGzJgU7x26
         JOcw==
X-Gm-Message-State: AAQBX9c4oIX79G+GfqSGkBZgPLo01UwtUI5BhBArHe1WAW0ISWGCQcNl
        wHXfY0uk2SpDkw+HyqMMXpE=
X-Google-Smtp-Source: AKy350YXyiIXRu1M/ogl5A1KonuWQfXHa5RmbNzoNr7/GBz5mmjNtsVcETUyXWo/i5MMfHpP+Byauw==
X-Received: by 2002:a5d:595a:0:b0:2c7:1c72:699f with SMTP id e26-20020a5d595a000000b002c71c72699fmr1741928wri.4.1680962777396;
        Sat, 08 Apr 2023 07:06:17 -0700 (PDT)
Received: from localhost (195-70-108-137.stat.salzburg-online.at. [195.70.108.137])
        by smtp.gmail.com with ESMTPSA id u5-20020adff885000000b002c70851fdd8sm7013361wrp.75.2023.04.08.07.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 07:06:16 -0700 (PDT)
Date:   Sat, 8 Apr 2023 16:06:14 +0200
From:   Richard Cochran <richardcochran@gmail.com>
To:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, gerhard@engleder-embedded.com,
        thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <ZDF01pSBxtQEqPZU@localhost>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-3-kory.maincent@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230406173308.401924-3-kory.maincent@bootlin.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 07:33:05PM +0200, Köry Maincent wrote:
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>

Since this patch is now completely re-written, you can drop my Sob and
authorship, keeping all the credit for yourself!

Thanks,
Richard
