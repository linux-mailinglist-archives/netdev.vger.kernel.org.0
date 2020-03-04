Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF7E179217
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 15:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbgCDONF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 09:13:05 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35554 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbgCDONE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 09:13:04 -0500
Received: by mail-wm1-f67.google.com with SMTP id m3so2041058wmi.0
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 06:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+ewBO7sh5GzuKqMjUONZiatbtsDKWYQzX3E/Bd6F5Qo=;
        b=L579DvQj7f9QtaxyOkQp5AiR6TYKSTrGOwuaIbEu0HU3opBqwVjkMEZQgQmc9xcNL+
         fTi77nj5VHybXUui0K2+2Ol3CfsbGziCIHBqZf11OKj/k8Rnmi/G+3yzyMOA/fG2CzsT
         CJUJJ+2WusVzUTfr6Jz3zB/OrfhDE3rWNShC8whcsbAnPfTvpBtWMXrbr9N7PNI6Zttx
         W2THIL7+wFYea9wF14j8R+fzcsKzu4LQmTAz/r2FWqiPgxlMKu48e0/z86qLGAvquHgM
         UD0mh0qJdCl5dI9Dd1+DwVrvm6XT1ywRcLoNa9bBYXEtqMotCKbiIRm3yCIsGbEaMHcZ
         o5aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+ewBO7sh5GzuKqMjUONZiatbtsDKWYQzX3E/Bd6F5Qo=;
        b=OYk2BXvfyxSoulTZAZRSoM9zX4bzr0bs61s50rGPZ0HhGil4QFo/yOgzXyX0PHeSN3
         NJBlIANQgax6EjJu3DpGIu5jNb8+tiTpBDydQ+Gctd2RED2KhVtN3GsDVgi51/Cnuxmp
         nUolt00W+JDosUY+vNmsEBghVrvhtQDvT6VBcdGsMZE4hqyxq1W/+DjXvoFQJVA6KtW6
         0DtFlEEoVSanPSYiDNwTYRbuT+eDAuR0n0WEr5ViTQ/H6Kfst7qSMfRXEZ7U6kkRneQu
         keTc0FBW2UwEKjkiSakzIoMNX2qqrRlQ1ldhxd/eg1Z6zNxHy2+sZoBtwQu5vPnimQgb
         vHng==
X-Gm-Message-State: ANhLgQ3e/dB5WILziHQnJXqhsSPozUA8KPfZbXVnIblZJY9vRPd8558T
        sAf4yYej2EtwGQ767hxdZJFv0Q==
X-Google-Smtp-Source: ADFU+vv5mtYmWjElRPhYorGaro8nlx/XprXh/b4JPLFhrc5/Ri+Y1OiO7UNJdIbWxytj5V9dCKH1UQ==
X-Received: by 2002:a1c:cc11:: with SMTP id h17mr1750797wmb.154.1583331181384;
        Wed, 04 Mar 2020 06:13:01 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id o8sm4163936wmh.15.2020.03.04.06.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 06:12:51 -0800 (PST)
Date:   Wed, 4 Mar 2020 15:12:41 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [PATCH net-next 2/2] net/sched: act_ct: Use
 pskb_network_may_pull()
Message-ID: <20200304141241.GC4558@nanopsycho>
References: <1583322579-11558-1-git-send-email-paulb@mellanox.com>
 <1583322579-11558-3-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583322579-11558-3-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Mar 04, 2020 at 12:49:39PM CET, paulb@mellanox.com wrote:
>To make the filler functions more generic, use network
>relative skb pulling.
>
>Signed-off-by: Paul Blakey <paulb@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
