Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B255012A6C4
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 09:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfLYI1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 03:27:51 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37132 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfLYI1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 03:27:51 -0500
Received: by mail-wr1-f68.google.com with SMTP id w15so8767383wru.4
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 00:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OrP/GZUcmkg7vvpr2zDPF3lAblUYoBKaM6cF68Hmac4=;
        b=mYWja6YzS6uIEFENgdb9HUBaR+GENcF1hbrNia0ySuLOAavmixwl9pR0EAxofMzk5O
         ycxQqIEyABZdpns/in898IYzQQKc41Dt1P0EKZlYol31VwEQMrRAZpmdjzDLIgjUrNPW
         497PIPJM4jk9qvXBbHd1ylfFJU2aAXBvoF6rh61L4jYzqOH47ULBy01yWT+EBqn2h8PV
         ZzC69FLnKsAGyYaXpFE2vHYqlQ3apkNyn0NyRiScqgImxRC+55lTEe4s/mWzW/zFWdlW
         mqyGWZ/Q14EyAdPE6gWKWN8fDh2AEA4saE0Wr7usqAdnsT/W4d0rEkfTcq7j9reCxxh+
         JpAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OrP/GZUcmkg7vvpr2zDPF3lAblUYoBKaM6cF68Hmac4=;
        b=Sd5S6jVdc66ssHOMFvP9yVO46eQeBm1g1liVKOQP7sh0EcIW8cB5idJMiaJe49k6qq
         2ORE5XgAm0ViS695yh1ngm2XX1rAPXEMstuT4FzfXTDzLjLlURndNwQ+uXaFTTB55vy0
         Tcx5MkGmAMkOe9tPU0ojrA2mWGLhHMYI0/N0SwXSJ1t4h66vfygGyuwJYdxJ37vRBPua
         4MjOM9wNVmF4gT9hwt/S5WD2ErxSTUbUnjc5z4z1ZFW9LZ+tEHKTb6Nx3JfuvmsCtbBl
         WgkGRE4uwR4Hv2ZtucWmv3Bv0zs0fZ+ltb609qOurMZqntZ3sLvThigCYDnT/jlR2izq
         J1FQ==
X-Gm-Message-State: APjAAAWBYojSS18QgE+A1esffKLF7AXVD1HKzEwv207rhX0Fi2Gi6+sJ
        UE+GQzaWc+FfPFtVZXPgDh4=
X-Google-Smtp-Source: APXvYqyCRLLCEWWqsx9vwE/6lT/qaJkKhJetCPfV33ls9wtSoXZ+1Q6JjaQ323nnNZhhf7XgkuI96A==
X-Received: by 2002:a5d:558d:: with SMTP id i13mr39645233wrv.364.1577262469305;
        Wed, 25 Dec 2019 00:27:49 -0800 (PST)
Received: from blondie ([141.226.11.88])
        by smtp.gmail.com with ESMTPSA id q19sm4966055wmc.12.2019.12.25.00.27.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 25 Dec 2019 00:27:48 -0800 (PST)
Date:   Wed, 25 Dec 2019 10:27:42 +0200
From:   Shmulik Ladkani <shmulik.ladkani@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        shmulik.ladkani@gmail.com,
        Shmulik Ladkani <sladkani@proofpoint.com>
Subject: Re: [PATCH net-next] net/sched: act_mirred: Ensure mac_len is
 pulled prior redirect to a non mac_header_xmit target device
Message-ID: <20191225102742.35f61e4e@blondie>
In-Reply-To: <c412ce79-1a37-963f-3633-2eba92ef05c4@mojatatu.com>
References: <20191223123336.13066-1-sladkani@proofpoint.com>
        <c412ce79-1a37-963f-3633-2eba92ef05c4@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Dec 2019 07:45:08 -0500
Jamal Hadi Salim <jhs@mojatatu.com> wrote:

> Shmulik - are you able to add a tdc testcase? It will be helpful to
> catch future regressions.

Sure, I'll try to cook something, different submission.
