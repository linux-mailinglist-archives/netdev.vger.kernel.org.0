Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0123258291E
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 16:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbiG0Ozl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 10:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbiG0Ozj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 10:55:39 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B35237FB4;
        Wed, 27 Jul 2022 07:55:38 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id v17so2164993edc.1;
        Wed, 27 Jul 2022 07:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hNum/KVDZLbiGBvueKR35Oy/MexgWsERICURREELkDk=;
        b=P+H/5L/YfQvm+4QmJS7PkTIgZQjmDd2liMFjN7N5g040ifJcxGYQvmKmNn9waP1Kaf
         J4IElV3lDnhwFWf9iOXBc0J3PHle2bF2W0s7gRwZ4NyqakIr6NsKyIeh35kfu6IWdC33
         DUezL9NE+dagojcxUbs/5l5tbjmCCCZXDRndpI1877e7KmrJSqMoXlHJ6bUSJoibLK7u
         kSlGaOaLZorBrb/CDbqEMNIIFKYTQcK2lOQdXuAbKP/86vRjN57u2hvnbyrubs7kADGv
         h52SPqtu+yvmXxDyMyfKQrU+J0hwkitTVBa4Hdo77rVL3lY/bxna0USWkHcNv2Ks18UN
         sq/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hNum/KVDZLbiGBvueKR35Oy/MexgWsERICURREELkDk=;
        b=UgLr8Idb5LTBTIBh5EstY3FhLZWd1dGq6cmTHs2AEXM21QfkG/+MnNPj+opDgfgVT1
         0vN7CP+nCYQWBUyZ00WERkEv2pMyUNerZUMZa/FxzC59VAnAPA4MAVvyOCywXd49qWWq
         WwQFiAVEvrGw1fwTh3SOIox5KHP8jusivC8+fay2GgYaLa4fJNJ3WJhNZXeoUFSy2hc+
         29jyj7decYlW5Uk1PGSkCjJrsMc7/+qXQAEu1a3iuSvpbccc1b48A5z1Tfr/ZW9r0vvH
         +15ANlzGyqSc1tO6Z+aQB1MKhypt2Tjwg/+xEaCvcqI7f336VnHqtigg7btePu8s/Yp3
         4rtQ==
X-Gm-Message-State: AJIora/yjbP+gnrAIf6Ys3Nzsrlld4vC43rP3LMF1c/VZoUAp8A0ebgV
        V7TTgheN0yOKt5zFMN5jk2ghIrfDQcWgKg==
X-Google-Smtp-Source: AGRyM1v29yU9EAn5IewjXK+FzvQqalDToboaJLUKJiMXVzcMqUCN3hwxV04Qghl6h6/UPM7HmF0DFg==
X-Received: by 2002:aa7:cac7:0:b0:43a:c5ba:24a6 with SMTP id l7-20020aa7cac7000000b0043ac5ba24a6mr23453659edt.84.1658933736371;
        Wed, 27 Jul 2022 07:55:36 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id bn17-20020a170906c0d100b0072b2cc08c48sm7665249ejb.63.2022.07.27.07.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 07:55:35 -0700 (PDT)
Date:   Wed, 27 Jul 2022 17:55:33 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v5 09/14] net: dsa: qca8k: move set age/MTU/port
 enable/disable functions to common code
Message-ID: <20220727145533.ujqliyonrftfd7ft@skbuf>
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-10-ansuelsmth@gmail.com>
 <20220727113523.19742-10-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727113523.19742-10-ansuelsmth@gmail.com>
 <20220727113523.19742-10-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 01:35:18PM +0200, Christian Marangi wrote:
> The same set age, MTU and port enable/disable function are used by
> driver based on qca8k family switch.
> Move them to common code to make them accessible also by other drivers.
> While at it also drop unnecessary qca8k_priv cast for void pointers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
