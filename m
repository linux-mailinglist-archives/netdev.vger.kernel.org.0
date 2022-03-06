Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F1A4CEE46
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 23:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbiCFWyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 17:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbiCFWyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 17:54:39 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3137D5A17D
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 14:53:46 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id s8so8141432pfk.12
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 14:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XeyZqgew3ZYkn7wmNIavNBgqbX60cnBTugaU6zIZ4Oc=;
        b=bma9Np9QSfw6YRZbEauUe+FBVQULo8Q1M9ZiUOCk2ejt2gXjtFWsDp9O3147ckqImX
         nZsSJt8P+KIqy15yUryoSMWu932uzZlHKEIeQU7nIqQk9129XVksFt3r01cTSX9CAMj9
         HiyRX5bZ9I1T4rJbS1b/pfSfTJ2LNKCTxpVadbRh37Crev0XH0XSbBOxe3ulJ+Mt3rM9
         /SQQYbZktC2Js05Zio/Ji5DVycJzMEZ9I0YelnYY+nDS4iyyAI5WITljRZHTVuSaD6mQ
         Pu8bsvR2F2QGZYVUCb1WNiRCNuInrodUi59zkaNFrPxeUe4OBL9Qc1szQhbFCd1R+Sl0
         PQjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XeyZqgew3ZYkn7wmNIavNBgqbX60cnBTugaU6zIZ4Oc=;
        b=ESsQncWQ89vJHuh951djbVt99aKGgV4/TuIvGFW7gVoroI59OD2UosNsk5A5esaGjJ
         i1Pa/eotix2nPW/wYdSyJF7g/ZxRBtp7RXH0dd94sYnIp656Ceh95vSmToPlL1V/1z5a
         yIXSAWSMbJUQG2mGECwNZ6Dd2c8Le3cT2aVIBm5tNv4PnqHhbrtUPHpJggZn+SJqOVCY
         Oy6FR08eSu+kmBJOgoV8f/iDJnbjZPqCDTmF1OGwkqMdt5f00DkYWSAWc0vDo81SM9tW
         F37TI/wdJxL0H+orPEpw0uBcjSqxd+QeAmrTx/u1HCBBCjVfHFHHdlxcMwbBtHt7gSw2
         p4kA==
X-Gm-Message-State: AOAM532qrRWNKl/W4IH62pDpOWfachOqW0XA41QYQUpnbx1XMId3vjk4
        38crhwqAeFplBMaHYMShGVy6HTNCU8I=
X-Google-Smtp-Source: ABdhPJyZmBjJGRP1c/XAdo+KBBcpWg2nnYDmE09pXrLjFsyVJeQioFXtybogqgo6R2deMV5kKwFXhg==
X-Received: by 2002:a63:90c7:0:b0:37c:7a8c:c2d3 with SMTP id a190-20020a6390c7000000b0037c7a8cc2d3mr7648657pge.473.1646607225633;
        Sun, 06 Mar 2022 14:53:45 -0800 (PST)
Received: from [100.127.84.93] ([2620:10d:c090:400::5:c84])
        by smtp.gmail.com with ESMTPSA id nn5-20020a17090b38c500b001bf09d6c7d7sm10803595pjb.26.2022.03.06.14.53.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Mar 2022 14:53:44 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kernel-team@fb.com
Subject: Re: [PATCH net-next 1/2] ptp: ocp: add nvmem interface for accessing
 eeprom
Date:   Sun, 06 Mar 2022 14:53:42 -0800
X-Mailer: MailMate (1.13.2r5673)
Message-ID: <0B9D1A8D-C56F-4B7C-BC62-31633003D7AC@gmail.com>
In-Reply-To: <20220304191134.6146087d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220303233801.242870-1-jonathan.lemon@gmail.com>
 <20220303233801.242870-4-jonathan.lemon@gmail.com>
 <20220303210112.701ed143@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <3D45B7EC-D480-4A0F-8ED2-2CC5677B8B13@gmail.com>
 <20220304081834.552ae666@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DC32C07D-52FC-437C-AE9A-FA03082E008B@gmail.com>
 <20220304191134.6146087d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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



On 4 Mar 2022, at 19:11, Jakub Kicinski wrote:

> On Fri, 04 Mar 2022 08:50:02 -0800 Jonathan Lemon wrote:
>>> And AFAIU the company delivering the card writes / assembles the
>>> firmware, you can't take FW load from company A and flash it onto
>>> company B's card, no?
>>
>> Nope.  There are currently 3 designs, and 3 firmware variants.
>> I’m looking for a way to tell them apart, especially since the
>> firmware file must match the card.  Suggestions?
>>
>> [root@timecard net-next]# devlink dev info
>> pci/0000:02:00.0:
>>   driver ptp_ocp
>>   serial_number fc:c2:3d:2e:d7:c0
>>   versions:
>>       fixed:
>>         board.manufacture GOTHAM
>>         board.id RSH04940
>>       running:
>>         fw 21
>> pci/0000:65:00.0:
>>   driver ptp_ocp
>>   serial_number 4e:75:6d:00:00:00
>>   versions:
>>       fixed:
>>         board.manufacture O2S
>>         board.id R3006G000100
>>       running:
>>         fw 9
>> pci/0000:b3:00.0:
>>   driver ptp_ocp
>>   serial_number 3d:00:00:0e:37:73
>>   versions:
>>       fixed:
>>         board.manufacture CLS
>>         board.id R4006G000101
>>       running:
>>         fw 32773
>
> Thanks for the output!
>
> In my limited experience the right fit here would be PCI Subsystem
> Vendor ID. This will also allow lspci to pretty print the vendor
> name like:
>
> 30:00.0 Dunno controller: OCP Time Card whatever (Vendor X)

Unfortunately, that’s not going to work for a while, until the
relevant numbers get through the PCI approval body.

I believe that board.manufacture is correct.  In this particular
example, the 3 boards are fabbed in 3 different locations, but
there are 2 “vendors”.

So what this does is identify the contractor who assembled the
particular board.  Isn’t that what this is intended for?
—
Jonathan
