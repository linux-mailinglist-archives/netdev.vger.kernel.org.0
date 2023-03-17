Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A406BE897
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 12:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjCQLvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 07:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjCQLva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 07:51:30 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8190B1ACC2;
        Fri, 17 Mar 2023 04:51:19 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z21so19319712edb.4;
        Fri, 17 Mar 2023 04:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679053878;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zVqcvHyI3OEULnLab5Axpbv7HZUjmkqZYgN9YSWuMzs=;
        b=lbZm0YWR5a3bK+S3L2n7oyIGecGgxQAlW9nDr9gaSih3byvNwjryHMBeujxAVBqM9Q
         2BHCb1V3/8ZBky53ICB7zv9nfNDR27KUOokZOljIcMwhV4C0Xr3PufOt0XvXZqCEy1n9
         6a+1jeiYBJaMmFQjLJ1XY43eMRg5EDQt8HclbQ7vybzJvJc8W1lNu70/o2F5lnY0zRQx
         jDl1uxLW0WXO8v2z3YPRuCM3K2xIWOg525UuxklIC6ocBOrFjpZJPHpdgt489OKjPyit
         nayEVvqO+zUiRw00pZ1kqlYQMJOAv7bJsRFvcvydRO/7VfQt3ObE3/DkD9EC0+aYFOMg
         Ij4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679053878;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zVqcvHyI3OEULnLab5Axpbv7HZUjmkqZYgN9YSWuMzs=;
        b=WKBOvCl1DsSwin5/SvFe+22VXfKZUCvsPqqJLCUiMjxBHAngwMY2kaKYyw9+Wpyz6q
         7GxVNGaObnM0JUCeMYLoYTF01n5Ud+KEgUZOk0GVeDftqRaLVPVTrmxyYAVkHFvdrTww
         +SUBgMAXo1RQHl7xgh0EUGR6KxfmzBmtGb1iTh6nkll6esu7wW7JgcMX6DO6cJQzy+U4
         oJvHV3bkne13+iu0Vn7gsOKnO2WyhnlU9c0W+GtXTHofVqLWLWQTmVvrc6BEZJSnLn48
         hOyN5mXl0Y1sG4d+FOtA19fjLfGcHlbOZBF8o9Aso0OmhUrzkALL+ECKRcSmwa0aRw8Z
         nQzQ==
X-Gm-Message-State: AO0yUKXTcxI2yLB2HSFnt6UjYrDEdo50RRnU7HmRboLn/QZSQxHT9/xH
        ASuWV+D6KwXJ1JaceHeRgoE=
X-Google-Smtp-Source: AK7set8fOrXuRFG2FnqOSc+kpvJW9dbGTyosqP//XxUhUep3O5DmfB+97X9BajISKjR/AALvZWJRFg==
X-Received: by 2002:a17:906:980d:b0:881:4d98:fe2e with SMTP id lm13-20020a170906980d00b008814d98fe2emr12721395ejb.29.1679053877605;
        Fri, 17 Mar 2023 04:51:17 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id ot17-20020a170906ccd100b008e51a1fd7bfsm894065ejb.172.2023.03.17.04.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:51:17 -0700 (PDT)
Date:   Fri, 17 Mar 2023 13:51:15 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?w4FsdmFybyBGZXJuw6FuZGV6?= Rojas <noltari@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        jonas.gorski@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net: dsa: b53: mmap: register MDIO Mux bus controller
Message-ID: <20230317115115.s32r52rz3svuj4ed@skbuf>
References: <20230317113427.302162-1-noltari@gmail.com>
 <20230317113427.302162-3-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230317113427.302162-3-noltari@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 12:34:26PM +0100, Álvaro Fernández Rojas wrote:
> b53 MMAP devices have a MDIO Mux bus controller that must be registered after
> properly initializing the switch. If the MDIO Mux controller is registered
> from a separate driver and the device has an external switch present, it will
> cause a race condition which will hang the device.

Could you describe the race in more details? Why does it hang the device?
