Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE003DA6BD
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 16:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237648AbhG2Oqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 10:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237785AbhG2On4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 10:43:56 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578D1C0617A2;
        Thu, 29 Jul 2021 07:43:52 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id o2-20020a9d22020000b0290462f0ab0800so6073671ota.11;
        Thu, 29 Jul 2021 07:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ghdxG0AoLe9NYK/5EqgXys2/gqMIiZChPSue54uLchk=;
        b=h5QdEIDfmW+qxNLxgwDPqXny2wX+yEEJ4/J9Z+Ql6r86dNvSf+4dlY0Yf3Hbu8oYou
         Iq6CyCsYnRiN6wktlsxFyVGykeXkaeYfdoAKzdhpg+38d3M8gpKFvWbV/k3Xv0l4v9d6
         pKN0rCv+MZ7iXJeu9DzZtJVZI58fZ88inIHb8Dl5AlvTKqXBXM6s1F9NUTwJKAgoRGjl
         aewNWLycjYdpqjqowNpfCwvP7Lx9ZYpNVePodZ5LWy9Gbk9Pju6lblUJc0flI5R6Us/Y
         WyuOogW0RMDlK7MfpPfYqf4ufR8Bmi5uGStkpC34oGbijcVbEO2mifQShWh8uTtOXDuq
         KNyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ghdxG0AoLe9NYK/5EqgXys2/gqMIiZChPSue54uLchk=;
        b=UOPyce5lj4uPyC6cGBgqfEuaxYYH62g0GDzy+IPS+Ig4/UMeJkw7eT1fS/vPqPH2dk
         QFiWOluZcxv9dOiF1wz3bohqmQ51QkZQ/naITYF2CrSw8HIxJxF5yuC26N6aXyzvoeG7
         yOm/kDWjll2MviPiLJejVZEgHBCfIKjmsrQeGVWqifcTzs64SOCddkwNiav+5BAWUjcm
         7wLaldY0HU8v7UTkVavg5LI3ZwZ+21PjCBqlLPeN/O9IdGdmKq/Qfcye0VlcqX9Rycct
         dPV9ppWyErLEYNuifNRxvE3A37OELEyibdT6lnPTnbhcEG5K3QhzhyiEwO7WK4seh5gl
         PL9w==
X-Gm-Message-State: AOAM530B8FaOsmoEucBgd1lsJ9jKIW9H6TWse0v/x8lv9KON4DnQf0mX
        Wth20pAm2hBZIHBHNyPZNuU=
X-Google-Smtp-Source: ABdhPJxOlhPK2Sc0q6P9nlTm0HsGtyt3h3SAEh58UtL/WN1pniTAIGjbnVXsSG2RsXMv79AzNtBy1w==
X-Received: by 2002:a9d:4b02:: with SMTP id q2mr3715524otf.52.1627569831801;
        Thu, 29 Jul 2021 07:43:51 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id l29sm501715ooh.44.2021.07.29.07.43.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 07:43:51 -0700 (PDT)
Subject: Re: [PATCH net-next] net: ipv6: add IFLA_RA_MTU to expose mtu value
 in the RA message
To:     Rocco Yue <rocco.yue@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, rocco.yue@gmail.com,
        chao.song@mediatek.com, zhuoliang.zhang@mediatek.com
References: <20210729090206.11138-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e0284a3a-2a6f-0d1b-5ca9-7d1b62b9f5f4@gmail.com>
Date:   Thu, 29 Jul 2021 08:43:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210729090206.11138-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also do not add mailing lists that cause bounces. Specifically, you tend
to add wsd_upstream@mediatek.com as a cc and every response to you
generates a bounce message for this address.
