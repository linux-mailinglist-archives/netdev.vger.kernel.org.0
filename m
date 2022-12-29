Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96BA8658BD5
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 11:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbiL2Kk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 05:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiL2Kkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 05:40:51 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A08DCF;
        Thu, 29 Dec 2022 02:40:50 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id m18so44045531eji.5;
        Thu, 29 Dec 2022 02:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NzZOv1CRraywjb+t+xrlHJC1I3n/ntQos2kcP4ZYPFE=;
        b=qbjkceik0jikKwPqQ5YUpus+366wQdlW8/3vTKPMjIuyca6c8AaXJowv1TqYVP0OJc
         k6QZgc0JMs+FIZ4YaHuhIM9WM8wLywrOM1ipt9d7tTDhlorSHbmEx/kgt0g0CS6WxZXt
         QvPPFQiBpkednku2IBMaU9AkhLySELYC41Vz+QusNumArOsQa+2pfMuoVhp4jhbGwpju
         qp3/vLOearVHAZkfXOo+GDH9l1vL4CL97wODxSg1Fw7eUNFnOKazM5t8l4yG38zhyP0M
         VmMtgwKrH4LnTginj5RAD/kSjbRx6Nnk3uFMZUHNfayM7JbPlRADljFzpvF1JhtDHLvt
         aClA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NzZOv1CRraywjb+t+xrlHJC1I3n/ntQos2kcP4ZYPFE=;
        b=DVpWW98H423UVAtUti8BfFyw/qiW4VqrIKAY6jbNqfDdwrEHB69u2CK+U8RAxOmBX9
         POEh9WQ8rmNoYrph/jxty8iglqKfxuRwr2wbPqzSf/AJ+azlc7BJ7qF4KZsUONG/1F0t
         di1Dbw25DYrU9hdEJ3dlNZ2fkNdnjnl4zsz1+SaDdSbLrEPP9fnI0PhUTwtthULOmEf6
         klVS0NKtmB8UhSqVjG4iAFwKJ0UpsZKHBO7mn6VVA+EqGZwRWohy9WJJUr21Hj/kpMbX
         68yzv1rhoJWsYJE312Enmr486UWoNpQmxAbj5CsxSzVBRR7niyW8E7u4DtXiZQi69D9B
         AglA==
X-Gm-Message-State: AFqh2kpO/CxEzsjAanhu8pgVqq0gYWrwp2ttZol46htq8iOr38AFDl5U
        gGs82RgIIqrA2J6sAzwrnM7/+D/MXI7eo8YkYva0R3mQYU8=
X-Google-Smtp-Source: AMrXdXuyP1yNLlQySKApsJpcisyAUsFg8+A5y+WxBvR6yikiFExXtVKouGOP6s8yz7xdFhmFP9uz9RsixLbOSPRNsaw=
X-Received: by 2002:a17:906:e4f:b0:7c0:ae1c:3eb7 with SMTP id
 q15-20020a1709060e4f00b007c0ae1c3eb7mr1771649eji.510.1672310449173; Thu, 29
 Dec 2022 02:40:49 -0800 (PST)
MIME-Version: 1.0
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com> <84e2f2289e964834b1eaf60d4f9f5255@realtek.com>
In-Reply-To: <84e2f2289e964834b1eaf60d4f9f5255@realtek.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Thu, 29 Dec 2022 11:40:38 +0100
Message-ID: <CAFBinCAvSYgnamMCEBGg5+vt6Uvz+AKapJ+dSfSPBbmtERYsBw@mail.gmail.com>
Subject: Re: [PATCH 0/4] rtw88: Four fixes found while working on SDIO support
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tehuang@realtek.com" <tehuang@realtek.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ping-Ke,

On Thu, Dec 29, 2022 at 10:26 AM Ping-Ke Shih <pkshih@realtek.com> wrote:
[...]
> > Martin Blumenstingl (4):
> >   rtw88: Add packed attribute to the eFuse structs
>
> I think this patch depends on another patchset or oppositely.
> Please point that out for reviewers.
There are no dependencies for this smaller individual series other
than Linux 6.2-rc1 (as this has USB support). I made sure to not
include any of the SDIO changes in this series.
The idea is that it can be applied individually and make it either
into 6.2-rc2 (or newer) or -next (6.3).


Best regards,
Martin
