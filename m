Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6113F644218
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbiLFL14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234663AbiLFL1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 06:27:34 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0633A230
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 03:27:32 -0800 (PST)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 7C4114423F
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 11:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1670326051;
        bh=pcwj0xSndXh6KnkaS8bTnDF5WeQqaKV6mdZEo74JDfA=;
        h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type;
        b=f5Ft5BS/OTbdpNYtRd1YC1D/BM8HNHlwhy5fcE1CiigybWjXBX+anhsP56wNbwpdt
         Nq12VMAizCso+knBAYdnrTlIFtdGViYLa1WQuql+a6EZEVqAquhpoRP3Yyq+T7hU9+
         WO5qSDwLJFlol8lEYLOosaUKNmGSAh6Vsu4w0wtJwrYXXs8k6Nw4HmnhX4vVjiG4OV
         3ztuSpPeDIAsYfNCya8ykhdeJw+nWnF8Fxn4nWY1NAma3GCcTI5LyNYgMMNOmZOGSD
         CULeCBzDo3UULYUtp+olIlH+pWKMg8jpKqBmVdlbn/mQ/5HNrwhy/SVTn8QvjnRCoG
         CdcHS2NqRL+sQ==
Received: by mail-ej1-f72.google.com with SMTP id js17-20020a17090797d100b007c0dd8018b6so1350544ejc.17
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 03:27:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pcwj0xSndXh6KnkaS8bTnDF5WeQqaKV6mdZEo74JDfA=;
        b=cGuMDvaL12S7XLuCYEGTB7yNa2+XXGysSfnRxYlZefu42hCZnMzTgNSNEM/Mysvnbm
         /+sc+ZNjhb6JwAyUIFbxamH5MdFXdtHKt/dolci+bYLSQKhZPVUo41YvgpISxQ7+nraU
         u2UrHfpMExVHgyw8O5/WPhFp09QTAhOWqEsIS6nK6We8uoIdY2giUQGahlcVE3cJV1cA
         RmWBUvhV4/4hzhRyhOlZiSPYbPd5+me1QbRRQzFth9yNvyb8tK4d5t5ctzpUhxe9cX1Y
         UKRlKh27Q6vt+azkEBMUvzZATz95ERZp16CZw38anutYThlgASDkRZZX1twIvBWbzECv
         aZBQ==
X-Gm-Message-State: ANoB5plDwT5TPZQcGQSNc4Gerh8OC+OZp131vEEUy8E03Jopon8QeDGC
        53fCKOWfXYutO2y2Qe5LU/nEJu/6hLLDPnglrJbxB5KHM5AWQJbMcIB4qzEMAGY/VZD3XCbihkp
        ZOLXqO/pa+bbRWuZOh6qU87V4QkGRiXjqzg==
X-Received: by 2002:a17:906:a209:b0:78e:ebf:2722 with SMTP id r9-20020a170906a20900b0078e0ebf2722mr69523358ejy.490.1670326049536;
        Tue, 06 Dec 2022 03:27:29 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7+7hJEm7RS//qwjZI2NkgcgeFfx5BgIMCo+8buUL8NMmMPAqOa0RpikMn7gYObBbSc3mEwnw==
X-Received: by 2002:a17:906:a209:b0:78e:ebf:2722 with SMTP id r9-20020a170906a20900b0078e0ebf2722mr69523351ejy.490.1670326049362;
        Tue, 06 Dec 2022 03:27:29 -0800 (PST)
Received: from [192.168.1.27] ([92.44.145.54])
        by smtp.gmail.com with ESMTPSA id r6-20020a508d86000000b004587f9d3ce8sm865452edh.56.2022.12.06.03.27.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 03:27:29 -0800 (PST)
Message-ID: <f0b260c1-a7c4-9e0e-5b29-a3c8a7570df1@canonical.com>
Date:   Tue, 6 Dec 2022 14:27:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:108.0) Gecko/20100101
 Thunderbird/108.0
Content-Language: en-US
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
From:   Cengiz Can <cengiz.can@canonical.com>
Subject: Regarding 711f8c3fb3db "Bluetooth: L2CAP: Fix accepting connection
 request for invalid SPSM"
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Luiz Augusto,


I'm by no means a bluetooth expert so please bear with me if my
questions sound dumb or pointless.


I'm trying to backport commit 711f8c3fb3db ("Bluetooth: L2CAP: Fix
accepting connection request for invalid SPSM") to v4.15.y and older
stable kernels. (CVE-2022-42896)


According to the changes to `net/bluetooth/l2cap_core.c` there are two
functions that need patching:


* l2cap_le_connect_req
* l2cap_ecred_conn_req



Only the former exists in kernels <= v4.15.y. So I decided to skip

l2cap_ecred_conn_req for older kernels.


Do you think this would be enough to mitigate the issue?



If so, older kernels also lack definitions of L2CAP_CR_LE_BAD_PSM and

L2CAP_PSM_LE_DYN_END.


I see that L2CAP_CR_LE_BAD_PSM is basically the same as
L2CAP_CR_BAD_PSM so I used it to signify an error.


I think it should be enough for the sake of a backport.


What do you think?


Also the range boundary that is defined with L2CAP_PSM_LE_DYN_END is

non-existent in older kernels, and it's hard to decide which value to
use in this expression:

`if (!psm || __le16_to_cpu(psm) > L2CAP_PSM_LE_DYN_END) {`


I can easily define L2CAP_PSM_LE_DYN_END as 0x00FF and call it a day
but I had to ask if we are absolutely sure if that's the right value.


Because the comment block states that it's from the "credit based
connection request" ranges but l2cap_le_connect_req is not credit based.

Is it?

Thank you in advance.

Cengiz Can
