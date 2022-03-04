Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754F74CD975
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 17:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240124AbiCDQuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 11:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234843AbiCDQux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 11:50:53 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1FC55BE6
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 08:50:05 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id q11so8222677pln.11
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 08:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GHS+V8igoEs9SBZvPoebZs6xXojcInMHQEyQa/7Tio4=;
        b=BZL2qQI0zJ1cAOgF8j+Gw4goZ9nHoOx+TEsi2GtIFyfL0UTRndnmiE/zz7MiHRFSEV
         SO8mtpVGAeetrncHg/rAiQ96LzK4ySVYqgk2cyQziRmyTIfwICSGrSCNIDYYzABJj0Sa
         MPKiAEawcj+mr34nDJ102+vmYJgKkRq+S7GauL+rGOj9HVqdzZB9Mkw4xQWSbMEXXeFw
         aBkZtHe0pwY6gLk/0OzGIzqa9zfjO8U/pRMhG1/HUAqc8odkWs99aNP0+eSFbomQUCfj
         QwSwyenMEj0Mujqj3yqZn9Ju+idKz4Ho0jn53iBaYTYQWrZDdDKPykIN6rRB1b5s36+F
         DuZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GHS+V8igoEs9SBZvPoebZs6xXojcInMHQEyQa/7Tio4=;
        b=bT49DvfTSkb9uwTX7FNThMO6BgSx72NdZ24LdUCo99F5RGGtOb+T6TSrXIbwABWbNw
         fuHSvEVcIV2Yb8ukl5zmHAHnmwkLUClwFWKGu4y4dN+XnIWQKrvMjcay4/6F25hScugl
         VQIEyKlfw5/MY9Ds0bRxzd5GtCV8juPo4IG+hYpph5la/408ORbgPmgIL9c+FFAAqsZC
         h8Kgn9e+v9l9oZocGyMtIqXlLXgnCBu2UK4BBiSg0d1QkMEaHmFhu+1OepE0L979eguA
         jJo8WNPDB627ZHZ/MWGLJR3nPpsX6F/DWaWBxz9yFOxuJxGfz9y23Q1t9C2irDJ6NYmy
         OSzA==
X-Gm-Message-State: AOAM531qxYkSGOrqKCmAqcqHPSxYCQYG5zuYWecsOULPrlILgP6Z9GhN
        nlb1MyRC+RSMCCn2jwW2wUE=
X-Google-Smtp-Source: ABdhPJzQGuR4/uE7EHaR/yYV75zNCTKrJ+YzYS0Ct/vCH0vVdkKg8Oyj/Oo/cwga6blfgnNSCilewA==
X-Received: by 2002:a17:902:6904:b0:14b:416a:a2c0 with SMTP id j4-20020a170902690400b0014b416aa2c0mr42919327plk.14.1646412604782;
        Fri, 04 Mar 2022 08:50:04 -0800 (PST)
Received: from [100.127.84.93] ([2620:10d:c090:400::5:2667])
        by smtp.gmail.com with ESMTPSA id k21-20020a056a00169500b004f65bbfca3asm6268855pfc.57.2022.03.04.08.50.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Mar 2022 08:50:04 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kernel-team@fb.com
Subject: Re: [PATCH net-next 1/2] ptp: ocp: add nvmem interface for accessing
 eeprom
Date:   Fri, 04 Mar 2022 08:50:02 -0800
X-Mailer: MailMate (1.13.2r5673)
Message-ID: <DC32C07D-52FC-437C-AE9A-FA03082E008B@gmail.com>
In-Reply-To: <20220304081834.552ae666@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220303233801.242870-1-jonathan.lemon@gmail.com>
 <20220303233801.242870-4-jonathan.lemon@gmail.com>
 <20220303210112.701ed143@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <3D45B7EC-D480-4A0F-8ED2-2CC5677B8B13@gmail.com>
 <20220304081834.552ae666@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4 Mar 2022, at 8:18, Jakub Kicinski wrote:

> On Thu, 03 Mar 2022 21:39:48 -0800 Jonathan Lemon wrote:
>> On 3 Mar 2022, at 21:01, Jakub Kicinski wrote:
>>> On Thu,  3 Mar 2022 15:38:00 -0800 Jonathan Lemon wrote:
>>>> manufacturer
>>>
>>> The generic string is for manufacture, i.e. fab; that's different
>>> from manufacture*r* i.e. vendor. It's when you multi-source a single
>>> board design at multiple factories.
>>
>> The documentation seems unclear:
>>
>> board.manufacture
>> -----------------
>> An identifier of the company or the facility which produced the part.
>
> Yeah, so this is for standard NICs. Say you have a NIC made by
> Chelsio (just picking a random company that's unlikely to have its
> own fabs), the vendor is Chelsio but they will contract out building
> the boards to whatever contractors. The contractor just puts the board
> together and runs manufacturing tests, tho, no real IP work.
>
>> There isn’t a board.vendor (or manufacturer) in devlink.h.
>>
>> The board design is open source, there’s several variants of
>> the design being produced, so I’m looking for a simple way to
>> identify the design (other than the opaque board id)
>
> And all of them use Facebook PCI_ID, hm. But AFAIU the cards are not
> identical, right? Are they using the same exact board design or
> something derived from the reference board design that matches
> the OCP spec?

A reference design, apparently with optional features.


> And AFAIU the company delivering the card writes / assembles the
> firmware, you can't take FW load from company A and flash it onto
> company B's card, no?

Nope.  There are currently 3 designs, and 3 firmware variants.
I’m looking for a way to tell them apart, especially since the
firmware file must match the card.  Suggestions?

[root@timecard net-next]# devlink dev info
pci/0000:02:00.0:
  driver ptp_ocp
  serial_number fc:c2:3d:2e:d7:c0
  versions:
      fixed:
        board.manufacture GOTHAM
        board.id RSH04940
      running:
        fw 21
pci/0000:65:00.0:
  driver ptp_ocp
  serial_number 4e:75:6d:00:00:00
  versions:
      fixed:
        board.manufacture O2S
        board.id R3006G000100
      running:
        fw 9
pci/0000:b3:00.0:
  driver ptp_ocp
  serial_number 3d:00:00:0e:37:73
  versions:
      fixed:
        board.manufacture CLS
        board.id R4006G000101
      running:
        fw 32773

—
Jonathan
