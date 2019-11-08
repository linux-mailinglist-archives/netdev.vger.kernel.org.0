Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC98F5B85
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 00:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKHXAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 18:00:37 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37437 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfKHXAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 18:00:36 -0500
Received: by mail-pl1-f195.google.com with SMTP id g8so633228plt.4;
        Fri, 08 Nov 2019 15:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=t7PcAgajFGR59UtDJGqs8YNkm/5v5ezun18gFFVjh20=;
        b=LHJjlwuGYK77ZVCXyIeB52s0Usv7syyoXZa8Ix6Yj5DHx8EjwF7kiLGhcZu+szID0P
         YfW8phQhbJXChSbdxa75TFDfb64tKYmSqUyFgpHz8ZM6ReVTdfe7kZIkW01NExqT51cq
         npaXtO8+Io9yFB+VxjBpouC/Ut0Bcajwl8sJ4kC6/OdJ0835BY4g6t0eesX5VMwiAuvD
         kZib13OgSuK4OY3o5h06YB4Qze2+8eeuKiqAHe6xXmD1Cc2z5f/VeK/jBjk8m6mpvDZM
         M9gpTWGBYScm1HTjXskxyNVykRGnyA9ceUTMN0vVXME+8UnTyYMepM2e1JOkqQkAux9W
         Zh2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=t7PcAgajFGR59UtDJGqs8YNkm/5v5ezun18gFFVjh20=;
        b=kVDr0E01LBV3AyI27JutMsvrE14w4K/KQzrhpvPAq4w2yN0Ju9UpVPbu0dmkTeyVIU
         mIaaw2JQ7OCs1GBQl5vwLhgPAuAcX7KcBIp36GvpptnZSnyT0erKPsrgB2wNghd8dwIQ
         0rlp+8qWEhqgPj+ROPpKjOWm5GdBrqeAmeeVInLaW4fSr9GnCJhC1qYlVlp7q/g/epmW
         T2sY0E+zusePluV1pgW4KxXXDfA4BtrWc8uzWy9chwc39P1cd4Vxf3vRdNH37fyzgVDB
         pjujGSmVKsN68r2/nThDLLYo53QAo9tNLm+MpS+ijnbAckDjJ9ERwq2bVJEEQAiZr2N6
         qwtA==
X-Gm-Message-State: APjAAAULYH5MU2zMYewmvPw6ZCMVY3fC6Uh0qns2qKfJBD1ol1sx9NoR
        PafANtfKvhCgYjqUQDXyaGo=
X-Google-Smtp-Source: APXvYqyT8t5YAOxLn4PLmr1cdzp/tg7Lnl7sgh37KQWg6N2ay67dTMKy2NIhohRfeBEpi++iarO0LQ==
X-Received: by 2002:a17:902:8d95:: with SMTP id v21mr10978065plo.96.1573254036187;
        Fri, 08 Nov 2019 15:00:36 -0800 (PST)
Received: from [172.20.40.253] ([2620:10d:c090:200::3:c214])
        by smtp.gmail.com with ESMTPSA id q70sm8963947pjq.26.2019.11.08.15.00.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 15:00:35 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Magnus Karlsson" <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, u9012063@gmail.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 3/5] libbpf: allow for creating Rx or Tx only
 AF_XDP sockets
Date:   Fri, 08 Nov 2019 15:00:34 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <E9A83A68-F43B-495E-8BFB-0DFC956C8444@gmail.com>
In-Reply-To: <1573148860-30254-4-git-send-email-magnus.karlsson@intel.com>
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
 <1573148860-30254-4-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7 Nov 2019, at 9:47, Magnus Karlsson wrote:

> The libbpf AF_XDP code is extended to allow for the creation of Rx
> only or Tx only sockets. Previously it returned an error if the socket
> was not initialized for both Rx and Tx.
>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
