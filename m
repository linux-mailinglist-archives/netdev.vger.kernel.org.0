Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4AE2B7562
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 05:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgKRE3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 23:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgKRE3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 23:29:11 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABEAC0613D4;
        Tue, 17 Nov 2020 20:29:11 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id t33so454951ybd.0;
        Tue, 17 Nov 2020 20:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=SwvNaokgke4kbvNhyfkXcbbtZGBu7XJmcZ67g6MirT8=;
        b=fdhAdSYt+4EQsUVcK5B6NqmI6E/qCHzhtEF6JGYnDzjCIzu8ZHDWMhjJF21LmPetkQ
         YumukWmaV7VdD5plZFLqQJ9EjRqsR9iFIeCL2o0HdqSPSjP23oxPC5EiTZnQoklJJSMw
         k+gXTGhSjr2HPncinIhaKsJEfmTbLwPLHisX8ocpR+fBRLOipFID528g32jLvp8yh6pL
         23Lr29nB9xmsE8oTx1WHIg56i1KF3Sako43pFQLqGHOc+afHxn+wHByXBtk7706sWZHb
         /W47t8xfW+W/4HMBR599MeuMtNgHNsx9AwDx69k4xKGKP6znAcn7KVCoA+pxYNA/G/Er
         aREA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=SwvNaokgke4kbvNhyfkXcbbtZGBu7XJmcZ67g6MirT8=;
        b=b8lhTjPwZMrTJmUW5+mw49OTd+5lNW2igPCaysCF17moS6+GyeP5qJRTJDTQO7hVcJ
         NSlAuzX3VjNo+mgwJTUofyrCyNas7a9a7X6URxHg8FJPFQwC1Knxg+EEPXSmZDTL618l
         QlNGzPoGW4YPFzNGwun5i2id0CdbVtKnY+MzXu7mgPy0rH6h+jKwXDpWA6f+c1/xlBnY
         RtZo0IXZ7u42SOg6X5PMlv3nDSRchywCEsdAXd4sL3eupKLCqjF4ubIkubLZhMBmdFvq
         vAUZ0jW4/jYSWtRuvhwVpbOLVgNk3y1ZZ1fFy9HMlCcv2twMwfYT7XRkZ61nsLnySNcn
         OJCg==
X-Gm-Message-State: AOAM532hEtosV3BoFtwv7tUscLozQaQ5Tv7OgxL3ubsPOe9Cw1bxlD0h
        76o3hBsd3WPSV1m5qzph02Ot0rk8hQBHucOjH9V3Lz77wos=
X-Google-Smtp-Source: ABdhPJw3rS6F7ro88tO9pO1AtkwV/oKzq+tp6Vfeh/1DzhsCy+WgLCvx0Xl1lsyyjcqr4FYa7f1OxyzsJqERfdgRQJE=
X-Received: by 2002:a25:2f84:: with SMTP id v126mr4645382ybv.509.1605673750464;
 Tue, 17 Nov 2020 20:29:10 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a25:9785:0:0:0:0:0 with HTTP; Tue, 17 Nov 2020 20:29:09
 -0800 (PST)
In-Reply-To: <20201117175758.3befce93@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <CGME20201117053759epcms2p80e47c3e9be01d564c775c045a42678f7@epcms2p8>
 <20201117053759epcms2p80e47c3e9be01d564c775c045a42678f7@epcms2p8> <20201117175758.3befce93@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Bongsu Jeon <bs.jeon87@gmail.com>
Date:   Wed, 18 Nov 2020 13:29:09 +0900
Message-ID: <CAEx-X7cjKNAYzpifOX=qaqpNVSuGEE6t69R=Zf=DZjFrp9PZ4w@mail.gmail.com>
Subject: Re: [PATCH net-next] net/nfc/nci: Support NCI 2.x initial sequence
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/20, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 17 Nov 2020 14:37:59 +0900 Bongsu Jeon wrote:
>> implement the NCI 2.x initial sequence to support NCI 2.x NFCC.
>> Since NCI 2.0, CORE_RESET and CORE_INIT sequence have been changed.
>> If NFCEE supports NCI 2.x, then NCI 2.x initial sequence will work.
>>
>> In NCI 1.0, Initial sequence and payloads are as below:
>> (DH)                     (NFCC)
>>  |  -- CORE_RESET_CMD --> |
>>  |  <-- CORE_RESET_RSP -- |
>>  |  -- CORE_INIT_CMD -->  |
>>  |  <-- CORE_INIT_RSP --  |
>>  CORE_RESET_RSP payloads are Status, NCI version, Configuration Status.
>>  CORE_INIT_CMD payloads are empty.
>>  CORE_INIT_RSP payloads are Status, NFCC Features,
>>     Number of Supported RF Interfaces, Supported RF Interface,
>>     Max Logical Connections, Max Routing table Size,
>>     Max Control Packet Payload Size, Max Size for Large Parameters,
>>     Manufacturer ID, Manufacturer Specific Information.
>>
>> In NCI 2.0, Initial Sequence and Parameters are as below:
>> (DH)                     (NFCC)
>>  |  -- CORE_RESET_CMD --> |
>>  |  <-- CORE_RESET_RSP -- |
>>  |  <-- CORE_RESET_NTF -- |
>>  |  -- CORE_INIT_CMD -->  |
>>  |  <-- CORE_INIT_RSP --  |
>>  CORE_RESET_RSP payloads are Status.
>>  CORE_RESET_NTF payloads are Reset Trigger,
>>     Configuration Status, NCI Version, Manufacturer ID,
>>     Manufacturer Specific Information Length,
>>     Manufacturer Specific Information.
>>  CORE_INIT_CMD payloads are Feature1, Feature2.
>>  CORE_INIT_RSP payloads are Status, NFCC Features,
>>     Max Logical Connections, Max Routing Table Size,
>>     Max Control Packet Payload Size,
>>     Max Data Packet Payload Size of the Static HCI Connection,
>>     Number of Credits of the Static HCI Connection,
>>     Max NFC-V RF Frame Size, Number of Supported RF Interfaces,
>>     Supported RF Interfaces.
>>
>> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
>
> Please fix the following sparse (build with C=1) warning:
>
> net/nfc/nci/ntf.c:42:17: warning: cast to restricted __le32
>
>> +	__u8 status = 0;
>
> Please don't use the __u types in the normal kernel code, those are
> types for user space ABI.
>

Thanks for reviewing my patch.
I will change the code to fix it
and then resend my patch with version2.
