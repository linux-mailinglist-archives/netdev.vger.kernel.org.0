Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2113E0973
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 22:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239723AbhHDUg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 16:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbhHDUgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 16:36:54 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBABC0613D5;
        Wed,  4 Aug 2021 13:36:40 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id p38so6742030lfa.0;
        Wed, 04 Aug 2021 13:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UdsxhqBSvgn9ELEUBWeyZpNWHMcvPR82inog+v7kzG0=;
        b=DDqeeuCg8DfaLKaM/a614M5ETLwzPIOuZeLZcC46OoWDgGAqUVmjG3eISFxCpI796X
         /anuBiGIrilAHFeVvwMiLJ/TYhJtE3EWMX58BkzGDYcsBKZCn8UfX0LkiXWb1ZrfiyIE
         3Qcy7oep4m9crB/xoE/XNHihmdJsOkwRbKygFI3J7JZg5q6+PshSECpIsxOHfi0rwWtG
         La1AwsbF7+a4HZCm8GflPXWT/jBkMeGw2p7wGF/MOUcX/wfnm+1zT5AAYub8nykojWqs
         egwKIkAQE+tOAutc0ucrDC7jjI6mhm3+h0gX9GbJxntLaFmlWDvozM3xCF7r/TAefVq8
         70fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UdsxhqBSvgn9ELEUBWeyZpNWHMcvPR82inog+v7kzG0=;
        b=cFQI8VxYvw8g6ruQEvYjNTQNssnEJh2iQlcgLfYdoeT2kzAppFIo9KZ1ZtDm/W3xWf
         BPWNuRqMBS9fbwEF36OSJFQltyCnuJYeN5SW38u/ltW6r0i70CJkc49dHu8uuUeCeBFK
         2YYkQGUJXWQGoL2TXqpOxKENhDG7T3qELa9AfovjTfzaE5iazQSWr4yUm2Q27VXVMzF7
         wGqlLB6VljVDgLUY9CVfRNPmAZqoG2umKGQwfcp0ylMutmijjkl/Dsex/xespOVCpiUX
         y2qxgO+TY+BV8DoJNsYETluscy2wKGZ2ss4hfKT/CAmWhtZnykBg93WjCs/Lp+xIcaCt
         25kQ==
X-Gm-Message-State: AOAM531NT9eCxeasTYNVhpBUzqNdCnT7OxqvIV1UtQKvZzsly6ogBJHm
        haihk21d7SQ4oG8PtO4cCgE=
X-Google-Smtp-Source: ABdhPJywYMrg8Y/Ed5Azsbss22yK7NL+/WDqXGrOCQaYoXb+KPZ3ab17BKwNCM/AiwsD8vpDOTxmPQ==
X-Received: by 2002:a19:4803:: with SMTP id v3mr747509lfa.83.1628109398869;
        Wed, 04 Aug 2021 13:36:38 -0700 (PDT)
Received: from [192.168.1.102] ([178.176.77.221])
        by smtp.gmail.com with ESMTPSA id o10sm295154lfg.109.2021.08.04.13.36.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 13:36:38 -0700 (PDT)
Subject: Re: [PATCH net-next v2 5/8] ravb: Add gstrings_stats and
 gstrings_size to struct ravb_hw_info
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-6-biju.das.jz@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <d324d7f1-425d-1a3d-3ad6-ee2213155ab9@gmail.com>
Date:   Wed, 4 Aug 2021 23:36:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210802102654.5996-6-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/21 1:26 PM, Biju Das wrote:

> The device stats strings for R-Car and RZ/G2L are different.
> 
> R-Car provides 30 device stats, whereas RZ/G2L provides only 15. In
> addition, RZ/G2L has stats "rx_queue_0_csum_offload_errors" instead of
> "rx_queue_0_missed_errors".
> 
> Add structure variables gstrings_stats and gstrings_size to struct
> ravb_hw_info, so that subsequent SoCs can be added without any code
> changes in the ravb_get_strings function.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

[...]

MBR, Sergei
