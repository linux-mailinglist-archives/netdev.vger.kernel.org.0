Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFD45507C8
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 02:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbiFSAou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 20:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232678AbiFSAot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 20:44:49 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA9BDF34
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 17:44:48 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id h187so9717196oif.4
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 17:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=tS3gKeaapmkpZeo85YmOyIr2C34nCvtB0ItqxZxKFxM=;
        b=bsoEohqmaeo/ld7FpLfdKCsZj04xuEDWZAA1CJFFyFUNs3l9XIsuTArKnJqKR/Xcau
         AKSm6fHN9nTw6rvAsxrSYAtaQHgOJ35u7JJFHGH49Pv8oTZZBmyj+NYkAWVwFGHoEjs6
         1AtaH4RMYBKP8cAn3ewDhsloQDhm5bNpeZfzxB56T+bhwWIoUhXeBQnW3j7fgIZeN5RW
         P7ArON+LTM2/mSvtWzFJ2mKqClIy5JCGAANxUk1mIBQ/DbHMyICLWT61paxfDN4zvWHv
         HrXXiss/FSFfpV9aTbb8cooAuF0eB70islyTjAuc0YDrHzcxPujPOWcetr8a1sg7mp9r
         eZNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=tS3gKeaapmkpZeo85YmOyIr2C34nCvtB0ItqxZxKFxM=;
        b=zlDyeOe27yetRFyvyr9SmMibRyJhdaneEVsnfdV6Bl/K0UKAQ3j8OqRToP9mEu8eGh
         x6OyBPcq8PwU9OguQMNdmxplZT0LmwJf6RO31dwxjkYqMNnTxvtud+IbSxMoD3YTkPpD
         NRPWIHPmUb9Z7kjFG+Te7EBmytHGNhvMfKvfnQ/9QWuyIoX/IbsRQyZ2roPRw9RhLpPT
         2NQQid3vvCZGi1A2v/OfsQFx/pVVgXi91qpks4ScxB4lwlO1thTqol+ygWVo9GL1UeUi
         NTwWpvAt1dYVzvZ0ONm1DsDzFM0ERXl2xSPFlX7SnNpwzitM3wzyei8uoBe5WvMB4/kb
         0PLQ==
X-Gm-Message-State: AJIora/ZdXWlZpU8nqPeLnSmZLm27yk8IXJxnmrXfTIkFbx6xwiwlz2R
        8/VIoNvYxI0wEGFe6xmKBrw5BZ/WKP2UWg==
X-Google-Smtp-Source: AGRyM1vPFvoshTv/dHzYjqxmGwqL2cimu/GF5A9Fju8pqgMxxhU4E5V/S/EJMhlA69apOcjvCfzhJQ==
X-Received: by 2002:a05:6808:d4c:b0:32f:361d:638f with SMTP id w12-20020a0568080d4c00b0032f361d638fmr8517845oik.100.1655599487293;
        Sat, 18 Jun 2022 17:44:47 -0700 (PDT)
Received: from ?IPv6:2804:14c:71:8e3a:bbb4:4cf8:bf04:4125? ([2804:14c:71:8e3a:bbb4:4cf8:bf04:4125])
        by smtp.gmail.com with ESMTPSA id d70-20020a4a5249000000b0035ef3da8387sm3959377oob.4.2022.06.18.17.44.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 17:44:46 -0700 (PDT)
Message-ID: <d807fb1b6780bcccb3b216bdfbe0fddfa8e2be2a.camel@gmail.com>
Subject: Re: [PATCH] net: usb: ax88179_178a: ax88179_rx_fixup corrections
From:   Jose Alonso <joalonsof@gmail.com>
To:     netdev@vger.kernel.org
Date:   Sat, 18 Jun 2022 21:44:44 -0300
In-Reply-To: <8069714f3301862dc8ed64a0cc0ab8c9f29b5f99.camel@gmail.com>
References: <8069714f3301862dc8ed64a0cc0ab8c9f29b5f99.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-06-18 at 16:11 -0300, Jose Alonso wrote:
> This patch corrects the receiving of packets in ax88179_rx_fixup.
>=20
Please disregard this patch.
It will fail for big-endian.
I will resending it.
