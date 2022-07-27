Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596A9582914
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 16:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbiG0Oym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 10:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbiG0Oyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 10:54:41 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11343E758;
        Wed, 27 Jul 2022 07:54:40 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id z18so9374605edb.10;
        Wed, 27 Jul 2022 07:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7ER/CQCF1acpD7C4Ckvrw1Md4EUsY85fQW1PKFSkPb8=;
        b=aGXVFTI+dr06bXYSakS+Xbl3WTK0SbheWluhcpKepsJok2qNvTRC0ByS9iBd/NZGjR
         mQ7lLcHy9r6bzQnbvFE2jdKwZPWUzaAfnJos7byzPWmeJmwEYuNsHryM2DMN1JuSdF8H
         xFObj3/YPzICoTMCs7mwn9Owv22XfUGw+80IEa8dfUNbZgelE78m/1lga3PQQdoreCwg
         CgGoclbJm12P3hMdxlVDvdPQCXv1I08V9HXVez6Yl8lONhFed3G/MlTIwkVIraI0mioY
         P+WfyMe2nUDWn/qZ/bn2LUE1YdWBRizSq7kEWd6g5FQJ3HwAxvtORl/utMnzjUqfPGFE
         /g0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7ER/CQCF1acpD7C4Ckvrw1Md4EUsY85fQW1PKFSkPb8=;
        b=GLFD4DNPqDrEiBaXY8+DW/eQsvd+r/oMMduOsbjaOAlVFxvTgtFKQ+GLBQGCN7sblG
         +Ku/Xd7BTNyh2HeFrkjOmZaYs32Jhx+g7CZX0CDZABRXMldoMcqeUTnPA+Lp1NI654rn
         fhSFvhHOMzE76x5vvlDuQhbIp/IvsHXiYqtHYkJDfNDKOiOgXrKkkAP0qQJ3zWvLZoLm
         F7/dHZ1jsXBqtZ2Spqz8qfZOCkcjaLGOFPOKL9WxcIv47nXBIQtpiQIw0A4hVuVtMVs+
         GtXQtof2ZH55HQvoLRUQfyLLGMau1s696ETHXMXZWrGG3jYMOWzScMntFbggfL1EAT4k
         ZjEg==
X-Gm-Message-State: AJIora9qlzPyBKvF4Jf6rAEqJ0WBp95o0a1vHTSgRnbBPe/OYy7wjUDB
        C3/sfJ4FqEX8ZaKvewdA0kI=
X-Google-Smtp-Source: AGRyM1tfopLURxjiqkTrSgishqe4Al0K9sqiMvkF6zcq6QWIrcI++oi3wuKIc+sWb9Bwo72HwS4H0Q==
X-Received: by 2002:a05:6402:caa:b0:43b:c350:18c7 with SMTP id cn10-20020a0564020caa00b0043bc35018c7mr23620353edb.193.1658933679122;
        Wed, 27 Jul 2022 07:54:39 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id lb8-20020a170907784800b00722e52d043dsm7728144ejc.114.2022.07.27.07.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 07:54:38 -0700 (PDT)
Date:   Wed, 27 Jul 2022 17:54:36 +0300
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
Subject: Re: [net-next PATCH v5 10/14] net: dsa: qca8k: move port FDB/MDB
 function to common code
Message-ID: <20220727145436.dczf3xr372cxqnd6@skbuf>
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-11-ansuelsmth@gmail.com>
 <20220727113523.19742-11-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727113523.19742-11-ansuelsmth@gmail.com>
 <20220727113523.19742-11-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 01:35:19PM +0200, Christian Marangi wrote:
> The same port FDB/MDB function are used by drivers based on qca8k family
> switch. Move them to common code to make them accessible also by other
> drivers.
> Also drop bulk read/write functions and make them static
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
