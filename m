Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 155E618BD5B
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 18:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgCSRAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 13:00:31 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33557 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728033AbgCSRA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 13:00:29 -0400
Received: by mail-lf1-f66.google.com with SMTP id c20so2263799lfb.0
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 10:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=vtMkzIwErSV95ddMs8+z368iZRh2IGDxPAeyTBG0cRU=;
        b=DWnpDyFyEjuHzu+kRPx00hpMuT06IvaqqLSwmamJaN9ZNBGgnTK9dVYcoEswiuB9so
         2zppWBUEL5zX+7W7st4WJ9jc3k2T6d1kDdTytPDB8t+kMIV2ZJyj2IlkTO7DLiPxOiGx
         yRxuE+k07s8wSpC/DdTrKGRVHg8PluVX0yNT0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=vtMkzIwErSV95ddMs8+z368iZRh2IGDxPAeyTBG0cRU=;
        b=Hym+5AzRen9Y6d1yoZM3eI0VfSgQakIz0BZNLSFRWfpkZ95NbXU2q6RNNMfvdenFhr
         nV2mf0DqENKTYBz/vIB/tw3E/2xq/oLs+NdnJyEALqK4YGVi7XaQRJ+FR+NpYGXGITKb
         me2TcOciLMnnb18xv9OVXlWItiY/WPnjEzIVhuciW+48bPbjpaJ+RyFnyl+K8qS58sam
         V1IaqNjXfBdh227nHnUpL7e33frpNfi0WpXhru9Tj9OodIja+3W7J39GxGLaGLOhfluo
         BjEEIsfFoK3arKT9CA8sNR8o+I0A7p9a3bdnx2+BocwZgwic6uO4oBpWTspJxxgen/43
         tQtw==
X-Gm-Message-State: ANhLgQ2hcPD1VoSzL43cUvchh/pzFh1Bjv4r2OV4PZgGaauowkTxSMLE
        D3RIn467zX30PZ1ptYjxmsmbDw==
X-Google-Smtp-Source: ADFU+vvvm/Zy8geTn5pwmr1xdKqSGIlU4wTLcd+FA6SFqyZdZVOBmSRCEIBDJWaa85K8mP1TxQOxEA==
X-Received: by 2002:a05:6512:6cd:: with SMTP id u13mr2791061lff.1.1584637226598;
        Thu, 19 Mar 2020 10:00:26 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id 64sm1793944ljj.41.2020.03.19.10.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 10:00:25 -0700 (PDT)
References: <20200319124631.58432-1-yuehaibing@huawei.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     lmb@cloudflare.com, daniel@iogearbox.net, john.fastabend@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next] bpf: tcp: Fix unused function warnings
In-reply-to: <20200319124631.58432-1-yuehaibing@huawei.com>
Date:   Thu, 19 Mar 2020 18:00:24 +0100
Message-ID: <87fte4xot3.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 01:46 PM CET, YueHaibing wrote:
> If BPF_STREAM_PARSER is not set, gcc warns:
>
> net/ipv4/tcp_bpf.c:483:12: warning: 'tcp_bpf_sendpage' defined but not used [-Wunused-function]
> net/ipv4/tcp_bpf.c:395:12: warning: 'tcp_bpf_sendmsg' defined but not used [-Wunused-function]
> net/ipv4/tcp_bpf.c:13:13: warning: 'tcp_bpf_stream_read' defined but not used [-Wunused-function]
>
> Moves the unused functions into the #ifdef
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---

In addition to this fix, looks like tcp_bpf_recvmsg can be static and
also conditional on CONFIG_BPF_STREAM_PARSER.

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
