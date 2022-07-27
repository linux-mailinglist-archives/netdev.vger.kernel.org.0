Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB58582909
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 16:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbiG0Owj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 10:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbiG0Owi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 10:52:38 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6D03AE6C;
        Wed, 27 Jul 2022 07:52:37 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id fy29so31807389ejc.12;
        Wed, 27 Jul 2022 07:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=erI2zpR0k4Ks6//nyC1BXQ7Uay55VcKoF/0LYTibVdQ=;
        b=IcSC8/HDzD4sbOWkUgSbHqOh2lKueaxYTkl3zgjdqgBP08nq95dq6aeQEgaBIumLbC
         L9Yha3oBGCuu0Cdu6jwplsBJq0nRHcxftJzRr3bqUFmkuiapr8wnHtwpJ0CV0RRVJm59
         ZDE7OcVegkyClGVq6k+mGq5PtTsayvle6XKhCqe3diP56A7JZgTS6sasPHZT7kBNRjfI
         f6FGZSuTf2h4mrt/Jrc17PNuU28Kz78byqqjRJIQ50cYTDDnHVGCbhDVkeWYfM5xctQ0
         Ikajh9UaIR7KrrxDTUP9OQ4zINMoN+lby1AxLz0sma7+ekt0n+kWrEbFAaphdcSmStGT
         8jSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=erI2zpR0k4Ks6//nyC1BXQ7Uay55VcKoF/0LYTibVdQ=;
        b=LJPWMicO5WodN/0YqioVbEHpEFPnna0Xm9araSvqf3jffNTDLoGr5x7vbG8ywgE/pf
         jwz4pGw0lycTcULTU3+puBf+/CL3MFNB/0ED9BrwZn/B0vFrDUlg5cWiCJcipplC2mnm
         Pa5Uwaj+S3W7Wcl5d5Vw4rOGaxeH1lUzSmtFn4RNhXNbkIicDRpAzwhaBbXkegFGP36R
         q4iSh3Uwe36JgUTqcENeZQomfNOKptY2NBlIX3jwpB7DoTbeq+RNfBJIv6fIRoHFn/qY
         RoLaimMCC5fp0JLouWmKuFOX4eRhsz1YWxeSZCeSzUVOcnWderSkYgxSxtvksclEkh/Z
         i8OA==
X-Gm-Message-State: AJIora+sJj53v3q1UFA8MaNb5Y2hgX2jETR4W6Duy0/Ri5ui2z8RpwWt
        fzED5MlxPtziUatr0LbsgeY=
X-Google-Smtp-Source: AGRyM1srkSQeaOfTH1Gvxh2ikiHKPa1E9loCVssVsNMHm+aEaHqPcqGvDt5x5UiZmnPtxp3tSnJb5g==
X-Received: by 2002:a17:907:762a:b0:72b:394b:ebcc with SMTP id jy10-20020a170907762a00b0072b394bebccmr17919613ejc.622.1658933556167;
        Wed, 27 Jul 2022 07:52:36 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id l17-20020a056402255100b0043c7789cf4esm2509219edb.73.2022.07.27.07.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 07:52:35 -0700 (PDT)
Date:   Wed, 27 Jul 2022 17:52:33 +0300
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
Subject: Re: [net-next PATCH v5 14/14] net: dsa: qca8k: move read_switch_id
 function to common code
Message-ID: <20220727145233.724nv22ljaqmnsgr@skbuf>
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-15-ansuelsmth@gmail.com>
 <20220727113523.19742-15-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727113523.19742-15-ansuelsmth@gmail.com>
 <20220727113523.19742-15-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 01:35:23PM +0200, Christian Marangi wrote:
> The same function to read the switch id is used by drivers based on
> qca8k family switch. Move them to common code to make them accessible
> also by other drivers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
