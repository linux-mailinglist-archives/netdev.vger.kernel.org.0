Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCF017A5B9
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgCEMyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:54:03 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40388 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbgCEMyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 07:54:03 -0500
Received: by mail-wm1-f65.google.com with SMTP id e26so5611110wme.5
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 04:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=UithumxeWzYgScx9rLpMyD2GJqEdo81auVSNbfn9oiY=;
        b=f6PmxY+OolwFWG6Qlwyz2Vw3Fx3A+kmQsoP2kyPGcXtEWvliRhBV5iONwsB4PRtoHu
         HvtCtJiLV+XvTInlE90TtwWIowBizogvXcRXTobxU9eLqYTvBiNAsfyp4qIXeCRp7xR0
         LGoYy8e9/mmZW1JFe/3FVRueKfq8NbiHwb5Qg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=UithumxeWzYgScx9rLpMyD2GJqEdo81auVSNbfn9oiY=;
        b=jQrp42goCZClx3cV1VaAITek2ErDnTb6t66XVTzGdlL5NDL3umWKU+30yKdRLt7I/d
         aVHy/jOQ7A/eA9l3INkiEGVAJ9IDfqvUolgnbub+2pW2tQHlURr03EiaFprcwy0D4/Jn
         Q0M1HIcDQYUUILEDmy41AdvhER4RZDJ1Nd2TDfPRa7Gr5Rm4iQa2wcbRDTc4oiZwy7sM
         5jm39NzxY3OD/1FpBaN/cOv6aFNoteZ58sIh36c0z5s0XYu1BOUptXiKgUwAHYHCWsH7
         8+1KjAvLE9webwpePqFQODimbJzEANBMhHjnZXgDZp2nOWYuZeYtz6UI1vbdlqLE3RUx
         0Kow==
X-Gm-Message-State: ANhLgQ2Py7nwJ0ksbYWRgXjdjJGgwPzU0Y7lXaGPNDu31VHi7aV2mnZ6
        1E5BG60crh2a7yBpBc2VD7SJrg==
X-Google-Smtp-Source: ADFU+vtVxwix/QuB6JjhX0awb1vybd4BvpFB+lIY68z69hOr/TCDPZBDyFJM31X5dKcZBJjdP0iwtw==
X-Received: by 2002:a1c:7c08:: with SMTP id x8mr9227427wmc.71.1583412841132;
        Thu, 05 Mar 2020 04:54:01 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id i18sm41145017wrv.30.2020.03.05.04.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 04:54:00 -0800 (PST)
References: <20200304101318.5225-1-lmb@cloudflare.com> <20200304101318.5225-10-lmb@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     john.fastabend@gmail.com, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team@cloudflare.com, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 09/12] selftests: bpf: don't listen() on UDP sockets
In-reply-to: <20200304101318.5225-10-lmb@cloudflare.com>
Date:   Thu, 05 Mar 2020 13:53:59 +0100
Message-ID: <878skfynbs.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 11:13 AM CET, Lorenz Bauer wrote:
> Most tests for TCP sockmap can be adapted to UDP sockmap if the
> listen call is skipped. Rename listen_loopback, etc. to socket_loopback
> and skip listen() for SOCK_DGRAM.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---

FWIW, Go has net.ListenUDP so I don't think it would be very confusing
to leave the helper name as is.

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>

[...]
