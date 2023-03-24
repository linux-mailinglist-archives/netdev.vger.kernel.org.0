Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBC46C8257
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 17:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbjCXQ3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 12:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjCXQ3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 12:29:19 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8823B2D4F
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 09:29:18 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id s13so1484142wmr.4
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 09:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=avride-ai.20210112.gappssmtp.com; s=20210112; t=1679675357;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=vQXdzREpNC82aYwfc8tVXYz0QLDEIupXUCEjM5LGLfs=;
        b=BSMa6/FcGG3BqV2L4oFydmdvPeRSOZha4DUcOFC9pJl+xw6zQCG6NWxT1yxPKAnkYZ
         NSCwv+2f///ZaUX+HHm+m+/aX6VtWu1MpGhFHDLoNWOfpq2AKOmuX4FK1UtbCltNXHf9
         oRDmbb7yv7bdX7+qbY/MGZh7HMsOgLDW3W8OahMYV7EvYI/ZUOL14+2cIaZVAXL/ZesU
         7fPIvcaykbIa+/wx/wZfiRr53QPrxb4tk2CMLHl+rypffMRmGcoZyq4Wd8xTpDtwAHII
         D4jcumNmO74hxqTkHH1QDMwCKiHT+iN1qSmSFRX06moHqPz4RUNwrIAqz4bCD1Fh6yfm
         a5mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679675357;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vQXdzREpNC82aYwfc8tVXYz0QLDEIupXUCEjM5LGLfs=;
        b=QhkSW8hBJ2t0SxTDtpeCtPsLFTINOMk5rLhu6VDjcZdJswI+twOu8Qvt7+g5q0S44W
         o4mi22GfAciW/wRZlnPowniOFl1Bb/V2CZt3SboiVnS/KIgLvJ0aGzImqJ69v1hRXlqW
         SZNhYER10w8a0jlf89t2+G2E0NvZqnwLoiFDuwUxyIgpSBtiVwPgwGJbyQc+tsiT/ldc
         3XuvVRS3POJ3iGWO0PAQTRbJfgo8F66OLMDlFLjQeH1v/cX6Y1QzEdDT9ayesLJnfvBe
         872T1VVSP1XLaoawn106XHh32C1e5O+76xtVqhUwcgEOCDqkxWughr37OvLyVAYgyZCH
         pmbA==
X-Gm-Message-State: AO0yUKU9T0zdU1bUhpWd0vDGGctenZ5yzWllNkh+5ZWtrrkYaHhApkP0
        JZX1wkFeuJUnCXq9WXU47xMhqg==
X-Google-Smtp-Source: AK7set/c+uH5wmSAGpa4jPOylG90xtB0qEfwoDO4wvdhv7BPaFdnNB9bQWlmZbJJWFkmULV0p366Ng==
X-Received: by 2002:a05:600c:2101:b0:3ee:7e12:f50 with SMTP id u1-20020a05600c210100b003ee7e120f50mr2604794wml.8.1679675357040;
        Fri, 24 Mar 2023 09:29:17 -0700 (PDT)
Received: from smtpclient.apple ([2001:40a8:400:600:fccd:d2cd:4b16:abe7])
        by smtp.gmail.com with ESMTPSA id z5-20020a05600c0a0500b003ee5fa61f45sm290704wmp.3.2023.03.24.09.29.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Mar 2023 09:29:16 -0700 (PDT)
From:   Kamil Zaripov <zaripov-kamil@avride.ai>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Network RX per process per interface statistics 
Message-Id: <F75020C7-9247-4F15-96CC-C3E6F11C0429@avride.ai>
Date:   Fri, 24 Mar 2023 19:29:15 +0300
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

I trying to make a BPF program that can collect per process per =
interface statistics of network data consumption. Right now most =
difficult part for me is RX traffic.

I have tried to find some point in the sk_buff's way up to network stack =
where I can extract info both about the network interface which captured =
package and the process that will consume this data but failed. So I =
have to listen events in several points and somehow merge collected =
data.

The last point I found at which sk_buff still contains information about =
network device that captured this sk_buff is netif_receive_skb =
tracepoint. The first point where I can found information about process =
is protocol's rcv handlers (like tcp_v4_do_rcv). But I have some =
questions, to finish my program:

1. It seems that sk_buff modifies during handling, so how can I "match" =
sk_buff with same data in netif_receive_skb and in tcp_v4_do_rcv?
2. Maybe there is some good point where I can attach listener and where =
I can extract both process and interface info for each package?

Regards
Zaripov Kamil.=
