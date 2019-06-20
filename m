Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACC594C6D8
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 07:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfFTFkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 01:40:19 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:38781 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbfFTFkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 01:40:19 -0400
Received: by mail-io1-f47.google.com with SMTP id j6so123651ioa.5;
        Wed, 19 Jun 2019 22:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=CHQrdpLakU3alJYQvxRZT1mY4W6opRcI/cqy2ZH4TS4=;
        b=bwryuyaa+2wgtpk+f8ydLlXa2TpGhDppJZad8igWGDs9E6ZBV21lXn8GuezG1DSwWA
         lASFr7gZFuZe8ToiUELQkAMAGsGA14m5QC1VCC/cdVActpxn+YmxnpzB+1ERw9UDXOa7
         orGcVXrLgPf60iqFn6+cRtYvNjNkU8geVIXWY4HNoxBKz7Did9aN2c8gwnoyqJCKhkPH
         0s0oIwP7LtjMfj0NdbrSlfC6Ah7s0/eaehSemmVcX5/5Ey/XEshgV4ivCBQOz7Cqdi0L
         OiLjlJ2Z+Pa06OhkDHyxz6yR4U94mvEBiR4uskb2HWFcBvr5M2EMsPBsKBvyQwidbNY2
         YyzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=CHQrdpLakU3alJYQvxRZT1mY4W6opRcI/cqy2ZH4TS4=;
        b=PHkVBj+JHv0rViHyWRhddTv/hxNQz3mxy01G1YOd2vo21pECMU9AMyt3k4b/XEX5y1
         /pJy75j4AYo9W3mLfgk15t0lOdk71KSNfEGZMVwQmr9rM/6OBOjwW9Is5zP5L9bX9Igi
         W3ABJwKVrigsESy/Q8Zm+PECcbRQlMAujA9Y3D+NrDgkOs4ne9/7SI2vXKWsS239yQWx
         gPLAXgL5q1jIjUHiG/AwzIGw36yG9aog1aOi9/SPZh1600iDeXyja0Nm9T2KdZNen77v
         xNn86u+LnyHz48Ly2JObgm8Che0m0rUASbruK8B0ll1Qnk7kTPuRPmwluL/iqFqkfls6
         1RJA==
X-Gm-Message-State: APjAAAU+Y6EfS9Udrm9qDzx0SeEFT9Tp5SG+eu/OKBTvk29/2oEFW/o4
        y42ULwICnE/MtiTS/8hfGHc=
X-Google-Smtp-Source: APXvYqxm0ykJ05XtDok9Xf3gPzbKZQGbqd7P1RWvPMt//Yj8IiKlHCsnnFVBKOXHUYYE9p89b5QW6Q==
X-Received: by 2002:a02:c918:: with SMTP id t24mr103306349jao.111.1561009218572;
        Wed, 19 Jun 2019 22:40:18 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k5sm20699467ioj.47.2019.06.19.22.40.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 22:40:18 -0700 (PDT)
Date:   Wed, 19 Jun 2019 22:40:10 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Message-ID: <5d0b1c3a3f565_21bb2acd7a54c5b49@john-XPS-13-9370.notmuch>
In-Reply-To: <20190615191225.2409862-3-ast@kernel.org>
References: <20190615191225.2409862-1-ast@kernel.org>
 <20190615191225.2409862-3-ast@kernel.org>
Subject: RE: [PATCH v3 bpf-next 2/9] selftests/bpf: fix tests due to const
 spill/fill
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> fix tests that incorrectly assumed that the verifier
> cannot track constants through stack.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  .../bpf/verifier/direct_packet_access.c       |  3 +-
>  .../bpf/verifier/helper_access_var_len.c      | 28 ++++++++++---------
>  2 files changed, 17 insertions(+), 14 deletions(-)
> 
 
Acked-by: John Fastabend <john.fastabend@gmail.com>
