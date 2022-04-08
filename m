Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8784F99C3
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 17:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237666AbiDHPqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 11:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbiDHPqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 11:46:05 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16279939D4;
        Fri,  8 Apr 2022 08:44:02 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id y3-20020a056830070300b005cd9c4d03feso6364056ots.3;
        Fri, 08 Apr 2022 08:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZmDnR4P0jms8okdjduyqjSplf8RRrDLwebVyvapStdM=;
        b=q04HLZ0LDH775/jL4wmsYosOew3eVyA130Ebf0Hjemgd1xc+/U9TEgVLcxnSj+ezGT
         RO27hWfcPYerNF1cbbls8Sr9SAh+TxGsBB5vzQtgJzwgPY3/6bbDTXS/390mSOa376IL
         D1fOnKZMFzAhy/G/TNlC65f0Er83SPQyuq9WJEkrd4TX5oE1QO1HT1IqsAjLdsIeD+81
         tg9py5fSdk0FNoNl3T1IwxaoFKPkindCLVPjrPXS/zXO/IHCfRjamSo01YOBGKvsgz7V
         lnNK8C+O9nPZZBkM9TbDrJk1i9TaEEeKfJ5/iIOq0pAQq3DiUezlVTb6zyNJPZdR+65f
         lLaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ZmDnR4P0jms8okdjduyqjSplf8RRrDLwebVyvapStdM=;
        b=XB1EHPbDgSWqL3mKSQvsEBQUf3BHe6xsvNlBENTeonHWbl2u1OnxvxJdbqd0QjMgLG
         XqhJsRZGW1ewXbRJyPbtypPPpCHG961G8Hg1K+PdqpC5P9LDuMyXMI1G7ToJlhauy59C
         BCwp7+BB4GdvLm8gBvcPX2Nf0T6on6gIzBULkeImSLZ+yzUsvLxLofvjDbPGR+R/BxmV
         7yAFFn28nrd65oo9xZsFZu3h2omlXlll6mAS6NKTt5kxqk5mQWRLqutKpVIy8clS3Dqz
         8DYT2Ma6Ivi+iGzSyU8U4rQxm2whluUX7+kZuESX53WXpX65LCu7i4j3aQY1o3rFlzyj
         7Hhw==
X-Gm-Message-State: AOAM533zrefyqUOTjwtltzqSBBIKpuLPShJPARNZLGdge1lftdCCVubV
        eeHvm+Ba8lNLsrwqIs45Ab4=
X-Google-Smtp-Source: ABdhPJwAhyxaAiIKxBPRZFRdw0ZKo8GeUCAUQI4jHqQfPoMxYJvlz3V23XIq5jt8T0X3tIrVa11CWA==
X-Received: by 2002:a9d:75cc:0:b0:5cd:9f3a:6ee6 with SMTP id c12-20020a9d75cc000000b005cd9f3a6ee6mr6791592otl.10.1649432641469;
        Fri, 08 Apr 2022 08:44:01 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v12-20020a05687105cc00b000e215a2e957sm5074156oan.17.2022.04.08.08.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 08:43:47 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 8 Apr 2022 08:43:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Michael Walle <michael@walle.cc>
Cc:     Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>,
        Jean Delvare <jdelvare@suse.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH v4 2/2] hwmon: intel-m10-bmc-hwmon: use
 devm_hwmon_sanitize_name()
Message-ID: <20220408154343.GA105850@roeck-us.net>
References: <20220405092452.4033674-1-michael@walle.cc>
 <20220405092452.4033674-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405092452.4033674-3-michael@walle.cc>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 11:24:52AM +0200, Michael Walle wrote:
> Instead of open-coding the bad characters replacement in the hwmon name,
> use the new devm_hwmon_sanitize_name().
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> Acked-by: Xu Yilun <yilun.xu@intel.com>
> Reviewed-by: Tom Rix <trix@redhat.com>

Applied.

Thanks,
Guenter
