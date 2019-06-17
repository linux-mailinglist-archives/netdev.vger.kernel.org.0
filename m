Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 041A8489D2
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfFQRQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:16:15 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40603 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfFQRQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:16:15 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so1530746pgj.7
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 10:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=5+L8q4MccaA4jsHU0wyQTIrx8hFyzOC6yHHTOz7k82U=;
        b=X0gpcVNyZm1GSsqTUkrRG7+HeaZQ6Tportm+/KM14yd5slz1+8ZliJHOar0YCgO09S
         OoBw4KO3oOuUWyrlr1ZLjDIxvT9IJhRMm5ih+y8QbH7h9Cw373G8zhkb6kwaAIUjnyJ9
         oLxfewuEU8jeSsH5PpGYYKpuz8+yxrr+3srCpqC1CZt2jruCDqXsxqdsBsbuMlsfiDL7
         yiSVPWk818LtuPzRD3asu0w1MPXMukHwsxy1s6c0YWwHSGVKuR4RvgBomSLCsG++g+pR
         zrECO69HK8gIAIuIrbCM9gD+FiFCo87zM71dr9YhoVrE1fbVMyBbkh/196CqQ6zu6SV9
         0nfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=5+L8q4MccaA4jsHU0wyQTIrx8hFyzOC6yHHTOz7k82U=;
        b=rnFj2GOgDwnQfSbry/0OzjARDrzzJp6BV3Sqi8TDXAE6lgCJa5n2cwluahWlvoWskn
         LnJuzF1IPFiDUMp0TzZ65Pbqos1Tkv1ySCm693HAOb8WnhCQjNfpeCY1u5qafORQzvyv
         D9pALJsxrTMtBVZNc8eRUcPKxIK6bkFLXzGzYgKfrPxUZ21B1tDtAE9oUX44Xu1lRA4m
         wS2TOXvb8QTDb5QDebmae2rRum7pUcFhItBAOQNVZSt1qrWgaUbL0TcnsYFxmc8CJiy6
         BNyxWc4qXqhB6+5eYDDYyzv5JvXaJyYIyUfHzGJ4JwGk2C0D8wM0dBcTwq/CmVpWIpYS
         EYFg==
X-Gm-Message-State: APjAAAV61jEXwQLd/4bk1B9sreWIVvn5Qua7nel1R+6XKGeyxzOv0dqp
        Zu3wFh7+4RrS7XHmOD/j2Ro=
X-Google-Smtp-Source: APXvYqxKYiapScWIrGZeB3MsjBpbt64uoTpeZ4AGV7Nls57kjqSwIh9VaVHaQmXCE383vCtOMA7VRA==
X-Received: by 2002:a17:90a:9a95:: with SMTP id e21mr26376061pjp.98.1560791774433;
        Mon, 17 Jun 2019 10:16:14 -0700 (PDT)
Received: from [172.26.125.68] ([2620:10d:c090:180::1:e1dd])
        by smtp.gmail.com with ESMTPSA id k22sm9329709pfg.77.2019.06.17.10.16.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 10:16:13 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Eric Dumazet" <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Jonathan Looney" <jtl@netflix.com>,
        "Neal Cardwell" <ncardwell@google.com>,
        "Tyler Hicks" <tyhicks@canonical.com>,
        "Yuchung Cheng" <ycheng@google.com>,
        "Bruce Curtis" <brucec@netflix.com>
Subject: Re: [PATCH net 4/4] tcp: enforce tcp_min_snd_mss in tcp_mtu_probing()
Date:   Mon, 17 Jun 2019 10:16:12 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <0EBAC49D-D8A7-4E00-9227-C3B1D6FDB610@gmail.com>
In-Reply-To: <20190617170354.37770-5-edumazet@google.com>
References: <20190617170354.37770-1-edumazet@google.com>
 <20190617170354.37770-5-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17 Jun 2019, at 10:03, Eric Dumazet wrote:

> If mtu probing is enabled tcp_mtu_probing() could very well end up
> with a too small MSS.
>
> Use the new sysctl tcp_min_snd_mss to make sure MSS search
> is performed in an acceptable range.
>
> CVE-2019-11479 -- tcp mss hardcoded to 48
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> Cc: Jonathan Looney <jtl@netflix.com>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Tyler Hicks <tyhicks@canonical.com>
> Cc: Bruce Curtis <brucec@netflix.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
