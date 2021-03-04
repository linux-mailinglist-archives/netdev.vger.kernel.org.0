Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F0832D4B6
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 14:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241718AbhCDN5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 08:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235755AbhCDN4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 08:56:46 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B5CC061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 05:56:06 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id mj10so29462751ejb.5
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 05:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zNqt364yKc9AWMgU3gsE1glWEHnIX0hXdX9QnycDgAE=;
        b=h2MDWr0x+l/RRdWo87aMtBHYHL/EZs/ptnrUUCflnO+hIHY6vAI41jyhBF0syGZn/p
         Op3XhjCGwMm/0GobwqzZwPc69RXJUMVBpaN54DUECA4S9O2T7SxDqu9P5GR5Jr7JAbBi
         3xonWuM81lIInxPJBH7AABQqrezhq0wiLKqZ3ZlAe+DGtoWj1MDjKFDuYmVNT7cnvCPF
         T0rSDDmILzCUYwmNsoKGMDS9ZJL5wEpQlVfEbc3MQ7EJiBMu/tmUiZ8qVGTACDpnUggm
         P3z4cHSInsJnZ/lId4G3SFSzObh7UJ/sVc/zw8IB+ofkt/INH7XSoSiqfsvpVZu6L36d
         KfUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zNqt364yKc9AWMgU3gsE1glWEHnIX0hXdX9QnycDgAE=;
        b=jlnY3Pu2429r5JeS9p64MnqktnWiXw2wfkHqt+psPbV4zgIifsoohc71/GFKe3vRHF
         6Q8Nm0m8ChXrxWOe+s2+rBq7vYABz+IA5RpBS41IRXUCZNaEpPySOnE1OMbKCbk/t3UR
         FE9+VKa4JNMpUxzUA1dZnjTjMlbcHR2zx1wvmdGA0JrRDBtxKbibZE54Mq9ufmDc0u09
         K4GT9jeK7lL6UHtoYdgZVp4YaQMg1dMTCC26FT/Hfwi4geH2uDMjH/XDCsuy/9Htbcqg
         WehggpEocmiKr8Ibtxu4bUuArmHGyzfz1Z9IYlzdVCDLvl1RhZQ/aODxrdrrDlCvsTwT
         puqg==
X-Gm-Message-State: AOAM533qqcUxNxlmBsv29EWKOtGBGIi5vkp3ZjHRBkoXRuWFNM5FHT8F
        4CdhbBRLTVNcsee3A+sw2CcnAUePMww=
X-Google-Smtp-Source: ABdhPJxAN8N4NdgvjWU2MOXEnB6kADru+6UhFptJsbvinivZEE+I5c8Tze+KK7NVZ1dHn1cnFNPbFg==
X-Received: by 2002:a17:907:2093:: with SMTP id pv19mr4433600ejb.134.1614866165087;
        Thu, 04 Mar 2021 05:56:05 -0800 (PST)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id s14sm23865121ejf.47.2021.03.04.05.56.04
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 05:56:04 -0800 (PST)
Received: by mail-wr1-f52.google.com with SMTP id b18so21269538wrn.6
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 05:56:04 -0800 (PST)
X-Received: by 2002:adf:fa08:: with SMTP id m8mr4317031wrr.12.1614866163865;
 Thu, 04 Mar 2021 05:56:03 -0800 (PST)
MIME-Version: 1.0
References: <20210304064046.6232-1-hxseverything@gmail.com>
In-Reply-To: <20210304064046.6232-1-hxseverything@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 4 Mar 2021 08:55:26 -0500
X-Gmail-Original-Message-ID: <CA+FuTSc3W9jcL97OF+ctRWLhFoUdNxb3P0MyPm9k7W8nTvWX0Q@mail.gmail.com>
Message-ID: <CA+FuTSc3W9jcL97OF+ctRWLhFoUdNxb3P0MyPm9k7W8nTvWX0Q@mail.gmail.com>
Subject: Re: [PATCH/v5] bpf: add bpf_skb_adjust_room flag BPF_F_ADJ_ROOM_ENCAP_L2_ETH
To:     Xuesen Huang <hxseverything@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, bpf <bpf@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Xuesen Huang <huangxuesen@kuaishou.com>,
        Zhiyong Cheng <chengzhiyong@kuaishou.com>,
        Li Wang <wangli09@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 4, 2021 at 1:41 AM Xuesen Huang <hxseverything@gmail.com> wrote:
>
> From: Xuesen Huang <huangxuesen@kuaishou.com>
>
> bpf_skb_adjust_room sets the inner_protocol as skb->protocol for packets
> encapsulation. But that is not appropriate when pushing Ethernet header.
>
> Add an option to further specify encap L2 type and set the inner_protocol
> as ETH_P_TEB.
>
> Suggested-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Xuesen Huang <huangxuesen@kuaishou.com>
> Signed-off-by: Zhiyong Cheng <chengzhiyong@kuaishou.com>
> Signed-off-by: Li Wang <wangli09@kuaishou.com>

Acked-by: Willem de Bruijn <willemb@google.com>
